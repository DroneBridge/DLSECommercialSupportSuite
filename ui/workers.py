"""Background jobs used by the DroneBridge Fleet Manager."""

from __future__ import annotations

import os
from concurrent.futures import FIRST_COMPLETED, ThreadPoolExecutor, as_completed, wait
from pathlib import Path
from threading import Event
from typing import Any, Callable

from PySide6.QtCore import QObject, QRunnable, Signal, Slot

from DroneBridgeCommercialSupportSuite import (
    DBDLSERelease,
    DBLicenseType,
    db_api_activate_dlse_device,
    db_api_create_request_session,
    db_api_get_dlse_releases,
    db_api_get_device_details,
    db_api_get_json,
    db_api_ota_update_device,
    db_api_reboot_esp32_device,
    db_api_update_settings,
    db_check_release_binaries_present,
    db_download_and_extract_dlse_release,
    db_find_extracted_dlse_release_root,
    db_is_dlse_lic_server_available,
    db_list_offline_dlse_releases,
    db_mavlink_reboot_esp32_devices,
    db_scan_for_esp32_devices,
    db_scan_for_esp32_devices_by_ip_range,
)
from ui.models import DeviceRecord, record_from_discovery


class WorkerSignals(QObject):
    """Signals shared by Fleet Manager runnables."""

    finished = Signal(object)
    error = Signal(str)
    progress = Signal(object)


class FunctionWorker(QRunnable):
    """Run a callable in the shared thread pool."""

    def __init__(self, function: Callable[[], Any]) -> None:
        """Store a no-argument callable for background execution."""
        super().__init__()
        self.signals = WorkerSignals()
        self.function = function

    @Slot()
    def run(self) -> None:
        """Execute the callable and emit its result or sanitized error."""
        try:
            self.signals.finished.emit(self.function())
        except Exception as exc:
            self.signals.error.emit(str(exc))


class DiscoveryWorker(QRunnable):
    """Discover devices and hydrate REST details without blocking the UI."""

    def __init__(self, subnet: str, mavlink_enabled: bool, http_enabled: bool,
                 esp32_port: int, local_port: int, http_timeout: float,
                 http_workers: int) -> None:
        """Create a bounded combined discovery job."""
        super().__init__()
        self.signals = WorkerSignals()
        self.subnet = subnet
        self.mavlink_enabled = mavlink_enabled
        self.http_enabled = http_enabled
        self.esp32_port = esp32_port
        self.local_port = local_port
        self.http_timeout = http_timeout
        self.http_workers = max(1, min(http_workers, 64))

    @Slot()
    def run(self) -> None:
        """
        Run enabled discovery methods concurrently, hydrate, and emit records.

        :return: None. Individual discovery or hydration failures are emitted as
            progress diagnostics; an unexpected worker failure emits ``error``.
        """
        try:
            discovered: dict[str, tuple[dict[str, Any], set[str]]] = {}
            discovery_jobs: dict[Any, str] = {}
            with ThreadPoolExecutor(max_workers=2) as executor:
                if self.mavlink_enabled:
                    discovery_jobs[executor.submit(
                        db_scan_for_esp32_devices,
                        subnet_mask=self.subnet,
                        timeout=2,
                        esp32_broadcast_port=self.esp32_port,
                        local_brcst_port=self.local_port,
                        _beta_4_support=True,
                    )] = "mavlink"
                if self.http_enabled:
                    discovery_jobs[executor.submit(
                        db_scan_for_esp32_devices_by_ip_range,
                        subnet_mask=self.subnet,
                        timeout=self.http_timeout,
                        max_workers=self.http_workers,
                    )] = "http"

                for future in as_completed(discovery_jobs):
                    source = discovery_jobs[future]
                    try:
                        devices = future.result()
                    except Exception as exc:
                        self.signals.progress.emit({
                            "source": source,
                            "error": str(exc),
                        })
                        continue
                    for device in devices:
                        ip = str(device.get("ip") or "")
                        if not ip:
                            continue
                        current, sources = discovered.get(ip, ({}, set()))
                        current.update(device)
                        sources.add(source)
                        discovered[ip] = (current, sources)

            records: list[DeviceRecord] = []
            with ThreadPoolExecutor(max_workers=self.http_workers) as executor:
                futures = {
                    executor.submit(self._hydrate, ip, data, sources): ip
                    for ip, (data, sources) in discovered.items()
                }
                for future in as_completed(futures):
                    try:
                        record = future.result()
                    except Exception as exc:
                        self.signals.progress.emit({
                            "ip": futures[future],
                            "error": str(exc),
                        })
                        continue
                    records.append(record)
                    self.signals.progress.emit(record)
            self.signals.finished.emit(records)
        except Exception as exc:
            self.signals.error.emit(str(exc))

    def _hydrate(self, ip: str, device: dict[str, Any], sources: set[str]) -> DeviceRecord:
        """Fetch REST detail groups for one discovered IP."""
        session = db_api_create_request_session(retries=1)
        try:
            details = db_api_get_device_details(session, ip)
        finally:
            session.close()
        merged = dict(device)
        merged["ip"] = ip
        for key in ("system_info", "settings", "stats", "errors"):
            if details.get(key):
                merged[key] = details[key]
        record = record_from_discovery(merged, sorted(sources)[0])
        record.sources = sources
        return record


class StatsPollingWorker(QRunnable):
    """Poll retained devices with bounded concurrency and incremental results."""

    def __init__(self, records: list[DeviceRecord], timeout: float,
                 workers: int = 20) -> None:
        """
        Create one cancellable stats polling round for a device snapshot.

        :param records: Retained devices captured at the start of the round.
        :param timeout: Per-device HTTP timeout in seconds.
        :param workers: Maximum simultaneous requests, bounded to 1 through 64.
        """
        super().__init__()
        self.signals = WorkerSignals()
        self.records = list(records)
        self.timeout = max(0.1, min(timeout, 30.0))
        self.workers = max(1, min(workers, 64))
        self.cancel_event = Event()

    def cancel(self) -> None:
        """Prevent queued devices from starting additional HTTP requests."""
        self.cancel_event.set()

    @Slot()
    def run(self) -> None:
        """
        Poll a bounded device window and emit each result immediately.

        :return: None. Request failures become per-device failure payloads;
            unexpected executor failures emit the worker-level ``error`` signal.
        """
        results: list[dict[str, Any]] = []
        try:
            with ThreadPoolExecutor(max_workers=self.workers) as executor:
                futures: dict[Any, DeviceRecord] = {}
                pending_records = iter(self.records)

                def submit_next() -> bool:
                    """Submit one request while preserving the concurrency bound."""
                    if self.cancel_event.is_set():
                        return False
                    try:
                        record = next(pending_records)
                    except StopIteration:
                        return False
                    futures[executor.submit(self._poll_one, record)] = record
                    return True

                for _ in range(min(self.workers, len(self.records))):
                    submit_next()
                while futures:
                    completed, _pending = wait(
                        futures,
                        return_when=FIRST_COMPLETED,
                    )
                    for future in completed:
                        record = futures.pop(future)
                        try:
                            stats = future.result()
                            payload = {
                                "identity": record.identity,
                                "ip": record.ip,
                                "success": stats is not None,
                                "stats": stats,
                                "error": "" if stats is not None else "Stats request failed",
                            }
                        except Exception as exc:
                            payload = {
                                "identity": record.identity,
                                "ip": record.ip,
                                "success": False,
                                "stats": None,
                                "error": str(exc),
                            }
                        results.append(payload)
                        self.signals.progress.emit(payload)
                        submit_next()
            self.signals.finished.emit(results)
        except Exception as exc:
            self.signals.error.emit(str(exc))

    def _poll_one(self, record: DeviceRecord) -> dict[str, Any] | None:
        """
        Fetch one device's stats object with no automatic HTTP retries.

        :param record: Device whose IP is queried.
        :return: Parsed statistics, or ``None`` for HTTP, timeout, or JSON failure.
        """
        session = db_api_create_request_session(retries=0, backoff_factor=0)
        try:
            return db_api_get_json(
                session,
                record.ip,
                "/api/system/stats",
                timeout=self.timeout,
            )
        finally:
            session.close()


class LicenseStatusWorker(FunctionWorker):
    """Check license-server availability."""

    def __init__(self) -> None:
        """Create a non-blocking license-server check."""
        super().__init__(db_is_dlse_lic_server_available)


class OtaReleaseListWorker(QRunnable):
    """List cached and account DLSE releases without blocking the UI."""

    def __init__(self, token: str) -> None:
        """
        Create a release listing job.

        :param token: Optional session-only license server token. Empty tokens
            still allow cached release discovery.
        :return: None. Results are emitted through ``signals.finished``.
        """
        super().__init__()
        self.signals = WorkerSignals()
        self.token = token.strip()

    @Slot()
    def run(self) -> None:
        """
        Build UI-safe release option dictionaries from cache and server data.

        :return: None. Emits a list of option dictionaries. Network or parsing
            failures produce cached options plus a status message instead of
            raising to QML.
        """
        try:
            options: list[dict[str, Any]] = []
            online_releases: list[DBDLSERelease] = []
            status_parts: list[str] = []
            if self.token:
                online_releases = db_api_get_dlse_releases(self.token) or []
                status_parts.append(f"{len(online_releases)} online")
            else:
                status_parts.append("no token")

            for index, release in enumerate(
                sorted(online_releases, key=lambda item: item.release_date, reverse=True),
                start=1,
            ):
                label = f"[download] {release.release_date} - {release.name}"
                if index == 1:
                    label = f"{label} (latest)"
                options.append({
                    "id": f"online:{index}:{release.safe_folder_name}",
                    "source": "online",
                    "label": label,
                    "releaseDate": release.release_date,
                    "name": release.name,
                    "release": release,
                })

            offline_releases = db_list_offline_dlse_releases()
            status_parts.append(f"{len(offline_releases)} cached")
            for index, release_path in enumerate(offline_releases, start=1):
                path = Path(release_path)
                options.append({
                    "id": f"cached:{index}:{path.name}",
                    "source": "cached",
                    "label": f"[cached] {release_path}",
                    "path": str(path),
                })

            self.signals.finished.emit({
                "options": options,
                "status": ", ".join(status_parts),
            })
        except Exception as exc:
            self.signals.error.emit(str(exc))


class OtaReleaseResolveWorker(QRunnable):
    """Resolve one cached or online release option to a validated local folder."""

    def __init__(self, option: dict[str, Any], token: str) -> None:
        """
        Create a release preflight job.

        :param option: Release option selected in the controller.
        :param token: Session-only token used only for online release downloads.
        :return: None. The resolved release root path is emitted on success.
        """
        super().__init__()
        self.signals = WorkerSignals()
        self.option = dict(option)
        self.token = token.strip()

    @Slot()
    def run(self) -> None:
        """
        Download if needed, normalize the extracted root, and validate binaries.

        :return: None. Emits ``{"release_path": path}`` on success or a
            sanitized error message on failure.
        """
        try:
            source = str(self.option.get("source") or "")
            if source == "online":
                release = self.option.get("release")
                if not self.token:
                    self.signals.error.emit("A license server token is required to download releases.")
                    return
                if not isinstance(release, DBDLSERelease):
                    self.signals.error.emit("The selected online release is no longer available.")
                    return
                release_path = db_download_and_extract_dlse_release(release, self.token)
                if not release_path:
                    self.signals.error.emit("Release download or extraction failed.")
                    return
            else:
                release_path = str(self.option.get("path") or "")
                if not release_path:
                    self.signals.error.emit("The selected cached release is missing its local path.")
                    return

            release_root = db_find_extracted_dlse_release_root(release_path) or Path(release_path)
            release_root_str = str(release_root)
            if not db_check_release_binaries_present(release_root_str):
                self.signals.error.emit("The selected release does not contain the required DLSE binaries.")
                return
            self.signals.finished.emit({"release_path": release_root_str})
        except Exception as exc:
            self.signals.error.emit(str(exc))


class ActivationWorker(QRunnable):
    """Activate selected devices sequentially with duplicate protection."""

    def __init__(self, records: list[DeviceRecord], token: str,
                 license_type: DBLicenseType) -> None:
        """Create a cancellable activation queue."""
        super().__init__()
        self.signals = WorkerSignals()
        self.records = records
        self.token = token or os.environ.get("DRONEBRIDGE_SECRET_TOKEN", "")
        self.license_type = license_type
        self.cancel_event = Event()

    def cancel(self) -> None:
        """Stop before processing the next queued device."""
        self.cancel_event.set()

    @Slot()
    def run(self) -> None:
        """Process records one by one and emit per-device results."""
        session = db_api_create_request_session()
        processed_keys: set[str] = set()
        successful_ips: set[str] = set()
        results = []
        try:
            validity_days = 60 if self.license_type == DBLicenseType.EVALUATION else 0
            for record in self.records:
                if self.cancel_event.is_set():
                    break
                self.signals.progress.emit({"identity": record.identity, "status": "activating"})
                try:
                    result = db_api_activate_dlse_device(
                        {"ip": record.ip, "sys_id": record.mavlink_sys_id or None},
                        session, self.token, processed_keys, successful_ips,
                        self.license_type, validity_days,
                    )
                except Exception as exc:
                    result = {
                        "identity": record.identity,
                        "success": False,
                        "message": str(exc),
                    }
                results.append(result)
                self.signals.progress.emit({
                    "identity": record.identity,
                    "status": result.status.value if hasattr(result, "status") else "failed",
                    "result": result,
                })
            self.signals.finished.emit(results)
        except Exception as exc:
            self.signals.error.emit(str(exc))
        finally:
            session.close()


class RebootWorker(QRunnable):
    """Reboot selected devices through REST, or all devices through MAVLink."""

    def __init__(self, records: list[DeviceRecord], workers: int = 20,
                 mavlink_subnet: str | None = None, mavlink_port: int = 14555) -> None:
        """Create a bounded reboot operation."""
        super().__init__()
        self.signals = WorkerSignals()
        self.records = records
        self.workers = max(1, min(workers, 64))
        self.mavlink_subnet = mavlink_subnet
        self.mavlink_port = mavlink_port

    @Slot()
    def run(self) -> None:
        """Send the selected reboot command and emit per-device status."""
        try:
            if self.mavlink_subnet:
                success = db_mavlink_reboot_esp32_devices(self.mavlink_subnet, self.mavlink_port)
                self.signals.finished.emit({"mavlink": True, "success": success, "count": len(self.records)})
                return
            results = []
            with ThreadPoolExecutor(max_workers=self.workers) as executor:
                futures = {executor.submit(self._reboot_one, record): record for record in self.records}
                for future in as_completed(futures):
                    record = futures[future]
                    try:
                        success = future.result()
                        message = ""
                    except Exception as exc:
                        success = False
                        message = str(exc)
                    payload = {
                        "identity": record.identity,
                        "success": success,
                        "message": message,
                    }
                    results.append(payload)
                    self.signals.progress.emit(payload)
            self.signals.finished.emit(results)
        except Exception as exc:
            self.signals.error.emit(str(exc))

    @staticmethod
    def _reboot_one(record: DeviceRecord) -> bool:
        """Reboot one record using an isolated requests session."""
        session = db_api_create_request_session()
        try:
            return db_api_reboot_esp32_device(session, record.ip)
        finally:
            session.close()


class SettingsWorker(QRunnable):
    """Apply one settings dictionary to multiple selected devices."""

    def __init__(self, records: list[DeviceRecord], settings: dict[str, Any],
                 workers: int = 20) -> None:
        """Create a bounded settings operation."""
        super().__init__()
        self.signals = WorkerSignals()
        self.records = records
        self.settings = settings
        self.workers = max(1, min(workers, 64))

    @Slot()
    def run(self) -> None:
        """Apply settings in parallel and emit structured results."""
        try:
            results = []
            with ThreadPoolExecutor(max_workers=self.workers) as executor:
                futures = {executor.submit(self._apply_one, record): record for record in self.records}
                for future in as_completed(futures):
                    record = futures[future]
                    try:
                        result = future.result()
                        payload = {"identity": record.identity, "result": result}
                    except Exception as exc:
                        payload = {
                            "identity": record.identity,
                            "success": False,
                            "message": str(exc),
                        }
                    results.append(payload)
                    self.signals.progress.emit(payload)
            self.signals.finished.emit(results)
        except Exception as exc:
            self.signals.error.emit(str(exc))

    def _apply_one(self, record: DeviceRecord) -> Any:
        """Apply the configured partial settings to one record."""
        session = db_api_create_request_session()
        try:
            return db_api_update_settings(session, record.ip, self.settings)
        finally:
            session.close()


class OtaWorker(QRunnable):
    """Run bounded parallel OTA updates with per-device progress."""

    def __init__(self, records: list[DeviceRecord], release_path: Path | None,
                 www_path: Path | None, firmware_path: Path | None,
                 workers: int = 20, target_version: str = "") -> None:
        """Create an OTA queue using release or explicit binary paths."""
        super().__init__()
        self.signals = WorkerSignals()
        self.records = records
        self.release_path = release_path
        self.www_path = www_path
        self.firmware_path = firmware_path
        self.workers = max(1, min(workers, 64))
        self.target_version = target_version.strip()
        self.cancel_event = Event()

    def cancel(self) -> None:
        """Prevent queued records from starting new uploads."""
        self.cancel_event.set()

    @Slot()
    def run(self) -> None:
        """Update eligible devices and emit results as futures complete."""
        eligible = [
            record for record in self.records
            if not self.target_version or record.firmware_version == self.target_version
        ]
        for record in self.records:
            if record not in eligible:
                self.signals.progress.emit({
                    "identity": record.identity,
                    "status": "skipped version",
                    "percent": 0,
                })
        results = []
        try:
            with ThreadPoolExecutor(max_workers=self.workers) as executor:
                futures = {}
                pending_records = iter(eligible)

                def submit_next() -> bool:
                    """Submit one queued update unless cancellation was requested."""
                    if self.cancel_event.is_set():
                        return False
                    try:
                        record = next(pending_records)
                    except StopIteration:
                        return False
                    futures[executor.submit(self._update_one, record)] = record
                    return True

                for _ in range(min(self.workers, len(eligible))):
                    submit_next()
                while futures:
                    completed, _pending = wait(
                        futures,
                        return_when=FIRST_COMPLETED,
                    )
                    for future in completed:
                        record = futures.pop(future)
                        try:
                            result = future.result()
                            payload = {
                                "identity": record.identity,
                                "result": result,
                                "status": "complete" if result.success else "failed",
                                "percent": 100 if result.success else 0,
                            }
                            results.append(result)
                        except Exception as exc:
                            payload = {
                                "identity": record.identity,
                                "success": False,
                                "status": "failed",
                                "percent": 0,
                                "message": str(exc),
                            }
                            results.append(payload)
                        self.signals.progress.emit(payload)
                        submit_next()
            self.signals.finished.emit(results)
        except Exception as exc:
            self.signals.error.emit(str(exc))

    def _update_one(self, record: DeviceRecord) -> Any:
        """Run the shared OTA workflow for one record."""
        session = db_api_create_request_session()
        try:
            return db_api_ota_update_device(
                session,
                record.ip,
                release_path=self.release_path,
                www_path=self.www_path,
                firmware_path=self.firmware_path,
                progress_callback_fn=lambda progress: self.signals.progress.emit({
                    "identity": record.identity,
                    "status": progress.stage.value,
                    "percent": int(progress.sent_bytes * 100 / progress.total_bytes)
                    if progress.total_bytes else 0,
                    "progress": progress,
                }),
            )
        finally:
            session.close()

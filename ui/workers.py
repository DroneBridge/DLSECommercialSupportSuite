"""Background jobs used by the DroneBridge Fleet Manager."""

from __future__ import annotations

import asyncio
import math
import os
import ssl
from concurrent.futures import FIRST_COMPLETED, ThreadPoolExecutor, as_completed, wait
from ipaddress import IPv4Address, IPv4Network
from pathlib import Path
from threading import Event
from time import monotonic, sleep
from typing import Any, Callable

import aiohttp
from PySide6.QtCore import QObject, QRunnable, Signal, Slot
from pymavlink import mavutil

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


class SystemInfoRefreshWorker(QRunnable):
    """Refresh static system information for a completed UI operation."""

    def __init__(self, records: list[DeviceRecord], timeout: float = 5.0,
                 workers: int = 20) -> None:
        """
        Create a bounded post-operation ``/api/system/info`` refresh.

        :param records: Devices whose OTA or activation operation emitted a result.
        :param timeout: Per-device HTTP timeout in seconds.
        :param workers: Maximum simultaneous refresh requests.
        """
        super().__init__()
        self.signals = WorkerSignals()
        self.records = list(records)
        self.timeout = max(0.1, min(timeout, 30.0))
        self.workers = max(1, min(workers, 64))

    @Slot()
    def run(self) -> None:
        """
        Refresh each supplied device and emit one result per attempted request.

        :return: None. Request failures become per-device failure payloads;
            unexpected executor failures emit the worker-level ``error`` signal.
        """
        results: list[dict[str, Any]] = []
        try:
            with ThreadPoolExecutor(max_workers=self.workers) as executor:
                futures = {
                    executor.submit(self._refresh_one, record): record
                    for record in self.records
                }
                for future in as_completed(futures):
                    record = futures[future]
                    try:
                        system_info = future.result()
                        payload = {
                            "identity": record.identity,
                            "ip": record.ip,
                            "success": system_info is not None,
                            "system_info": system_info,
                            "error": "" if system_info is not None else "System info request failed",
                        }
                    except Exception as exc:
                        payload = {
                            "identity": record.identity,
                            "ip": record.ip,
                            "success": False,
                            "system_info": None,
                            "error": str(exc),
                        }
                    results.append(payload)
                    self.signals.progress.emit(payload)
            self.signals.finished.emit(results)
        except Exception as exc:
            self.signals.error.emit(str(exc))

    def _refresh_one(self, record: DeviceRecord) -> dict[str, Any] | None:
        """
        Fetch one device's static information using the shared REST helper.

        :param record: Device whose system information should be refreshed.
        :return: Parsed ``/api/system/info`` response, or ``None`` on failure.
        """
        session = db_api_create_request_session()
        try:
            return db_api_get_json(
                session,
                record.ip,
                "/api/system/info",
                timeout=self.timeout,
            )
        finally:
            session.close()


class UnifiPollingWorker(QRunnable):
    """Read active wireless clients from a UniFi gateway through aiounifi."""

    def __init__(
        self,
        host: str,
        port: int,
        api_token: str,
        site: str = "default",
        timeout: float = 5.0,
        verify_tls: bool = False,
    ) -> None:
        """
        Create one bounded UniFi active-client polling request.

        :param host: Gateway hostname or IPv4 address without a URL scheme.
        :param port: HTTPS port used by the UniFi console.
        :param api_token: User-supplied Network API token sent as ``X-API-Key``.
        :param site: Internal UniFi site name used by the classic client endpoint.
        :param timeout: Total request timeout in seconds, bounded to 1 through 30.
        :param verify_tls: Whether to verify the gateway's TLS certificate.
        :return: None. Results are emitted through ``signals.finished`` and
            connection or authentication failures through ``signals.error``.
        """
        super().__init__()
        self.signals = WorkerSignals()
        self.host = host
        self.port = port
        self.api_token = api_token
        self.site = site
        self.timeout = max(1.0, min(float(timeout), 30.0))
        self.verify_tls = verify_tls

    @Slot()
    def run(self) -> None:
        """Run the asynchronous aiounifi request inside this worker thread."""
        try:
            self.signals.finished.emit(asyncio.run(self._fetch_clients()))
        except Exception as exc:
            self.signals.error.emit(str(exc))

    async def _fetch_clients(self) -> list[dict[str, Any]]:
        """
        Fetch and normalize active wireless clients from the configured site.

        :return: Client dictionaries containing ``mac``, ``ip``, ``rssi``, and
            optional AP metadata. Wired clients and invalid RSSI values are
            omitted. aiounifi/network exceptions propagate to ``run``.
        """
        timeout = aiohttp.ClientTimeout(total=self.timeout)
        ssl_context: ssl.SSLContext | bool = (
            ssl.create_default_context() if self.verify_tls else False
        )
        async with aiohttp.ClientSession(timeout=timeout) as session:
            controller = _create_unifi_controller(
                session,
                self.host,
                self.port,
                self.site,
                ssl_context,
            )
            connectivity = getattr(controller, "connectivity", controller)
            connectivity.is_unifi_os = True
            connectivity.headers["X-API-Key"] = self.api_token
            connectivity.headers["Accept"] = "application/json"
            await controller.clients.update()
            return [
                payload
                for client in controller.clients.values()
                if (payload := _unifi_client_payload(client)) is not None
            ]


def _create_unifi_controller(
    session: aiohttp.ClientSession,
    host: str,
    port: int,
    site: str,
    ssl_context: ssl.SSLContext | bool,
) -> Any:
    """
    Create an aiounifi controller across its Python 3.10–3.13 API generations.

    :param session: aiohttp session owned by the current polling request.
    :param host: UniFi console hostname or address.
    :param port: UniFi console HTTPS port.
    :param site: Internal UniFi site name.
    :param ssl_context: Verified SSL context or ``False`` for local self-signed TLS.
    :return: An aiounifi ``Controller`` instance. Import errors propagate so a
        missing optional UI dependency is reported by the worker boundary.
    """
    from aiounifi import Controller

    try:
        from aiounifi.models.configuration import Configuration
    except ImportError:
        return Controller(
            host,
            session,
            username="",
            password="",
            port=port,
            site=site,
            ssl_context=ssl_context,
        )
    return Controller(
        Configuration(
            session,
            host,
            username="",
            password="",
            port=port,
            site=site,
            ssl_context=ssl_context,
        )
    )


def _unifi_client_payload(client: Any) -> dict[str, Any] | None:
    """
    Normalize one aiounifi client to AP-observed metrics.

    :param client: aiounifi client object exposing its controller response as
        ``raw``.
    :return: A safe wireless-client dictionary, or ``None`` for wired clients,
        missing identifiers, or values that are not plausible RSSI dBm values.
        Rate and activity fields are kept numeric so the UI can format them
        without losing precision; fields absent from a particular UniFi
        firmware response remain ``None``.
    """
    raw = getattr(client, "raw", {})
    if not isinstance(raw, dict) or raw.get("is_wired") is True:
        return None
    mac = str(raw.get("mac") or "")
    ip = str(raw.get("ip") or "")
    if not mac and not ip:
        return None
    # UniFi's ``signal`` field is the signed dBm measurement.  Some releases
    # also expose ``rssi`` as a positive quality number, so only use it when
    # the dBm field is absent; accepting that quality value would discard all
    # otherwise valid wireless observations as implausible RSSI.
    signal = raw.get("signal")
    if signal is None:
        signal = raw.get("rssi")
    if isinstance(signal, bool):
        return None
    try:
        rssi = float(signal)
    except (TypeError, ValueError):
        return None
    if not -150 <= rssi <= 0:
        return None
    normalized_rssi: int | float = int(rssi) if rssi.is_integer() else rssi
    signal_balance = next(
        (
            raw.get(key)
            for key in (
                "signal_balance",
                "ap_client_signal_balance",
                "balance",
            )
            if raw.get(key) not in (None, "")
        ),
        None,
    )
    return {
        "mac": mac,
        "ip": ip,
        "rssi": normalized_rssi,
        "ap_mac": str(raw.get("ap_mac") or ""),
        "ssid": str(raw.get("essid") or ""),
        "channel": raw.get("channel"),
        "radio": str(raw.get("radio") or ""),
        "radio_name": str(raw.get("radio_name") or ""),
        "ap_channel": _unifi_channel(raw.get("channel")),
        "ap_band": _unifi_band(raw.get("radio"), raw.get("channel")),
        "wifi_standard": str(raw.get("radio_proto") or ""),
        "rx_rate": _unifi_number(raw.get("rx_rate")),
        "tx_rate": _unifi_number(raw.get("tx_rate")),
        "rx_bytes": _unifi_number(raw.get("rx_bytes")),
        "tx_bytes": _unifi_number(raw.get("tx_bytes")),
        "rx_bytes_rate": _unifi_first_number(
            raw,
            ("rx_bytes-r", "rx_bytes_rate"),
        ),
        "tx_bytes_rate": _unifi_first_number(
            raw,
            ("tx_bytes-r", "tx_bytes_rate"),
        ),
        "signal_balance": signal_balance,
        "source": "unifi",
    }


def _unifi_number(value: Any) -> int | float | None:
    """Return a JSON-safe finite UniFi number, preserving integral values."""
    if isinstance(value, bool):
        return None
    try:
        number = float(value)
    except (TypeError, ValueError):
        return None
    if not math.isfinite(number):
        return None
    return int(number) if number.is_integer() else number


def _unifi_first_number(
    raw: dict[str, Any],
    keys: tuple[str, ...],
) -> int | float | None:
    """Return the first numeric value from alternative UniFi field names."""
    for key in keys:
        number = _unifi_number(raw.get(key))
        if number is not None:
            return number
    return None


def _unifi_channel(value: Any) -> int | None:
    """Return a valid Wi-Fi channel number from a UniFi client payload."""
    number = _unifi_number(value)
    if number is None or not float(number).is_integer() or not 1 <= number <= 233:
        return None
    return int(number)


def _unifi_band(radio: Any, channel: Any = None) -> str | None:
    """Map UniFi radio names to bands without guessing ambiguous channels."""
    normalized = str(radio or "").strip().lower().replace(" ", "")
    if normalized in {"ng", "2g", "2.4", "2.4g", "2.4ghz", "bg"}:
        return "2.4 GHz"
    if normalized in {"na", "5g", "5ghz", "5"}:
        return "5 GHz"
    if normalized in {"6e", "6g", "6ghz", "6"}:
        return "6 GHz"
    channel_number = _unifi_channel(channel)
    return "2.4 GHz" if channel_number is not None and channel_number <= 14 else None


class SettingsRefreshWorker(QRunnable):
    """Refresh REST settings for devices after accepted settings changes."""

    def __init__(
        self,
        records: list[DeviceRecord],
        target_ips: dict[str, str] | None = None,
        timeout: float = 5.0,
        workers: int = 20,
    ) -> None:
        """
        Create a bounded post-reboot ``/api/settings`` refresh.

        :param records: Devices whose settings update was accepted.
        :param target_ips: Optional identity-to-IP mapping used when a settings
            change moved a device to a new static address.
        :param timeout: Per-device HTTP timeout in seconds.
        :param workers: Maximum simultaneous refresh requests.
        """
        super().__init__()
        self.signals = WorkerSignals()
        self.records = list(records)
        self.target_ips = dict(target_ips or {})
        self.timeout = max(0.1, min(timeout, 30.0))
        self.workers = max(1, min(workers, 64))

    @Slot()
    def run(self) -> None:
        """
        Fetch settings for each supplied device and emit one result per device.

        :return: None. Request failures become per-device failure payloads;
            unexpected executor failures emit the worker-level ``error`` signal.
        """
        results: list[dict[str, Any]] = []
        try:
            with ThreadPoolExecutor(max_workers=self.workers) as executor:
                futures = {
                    executor.submit(
                        self._refresh_one,
                        self.target_ips.get(record.identity, record.ip),
                    ): record
                    for record in self.records
                }
                for future in as_completed(futures):
                    record = futures[future]
                    target_ip = self.target_ips.get(record.identity, record.ip)
                    try:
                        settings = future.result()
                        payload = {
                            "identity": record.identity,
                            "ip": target_ip,
                            "success": isinstance(settings, dict),
                            "settings": settings,
                            "error": ""
                            if isinstance(settings, dict)
                            else "Settings request failed",
                        }
                    except Exception as exc:
                        payload = {
                            "identity": record.identity,
                            "ip": target_ip,
                            "success": False,
                            "settings": None,
                            "error": str(exc),
                        }
                    results.append(payload)
                    self.signals.progress.emit(payload)
            self.signals.finished.emit(results)
        except Exception as exc:
            self.signals.error.emit(str(exc))

    def _refresh_one(self, target_ip: str) -> dict[str, Any] | None:
        """
        Fetch one device's settings using the shared REST helper.

        :param target_ip: Address to query after the device rebooted.
        :return: Parsed ``/api/settings`` response, or ``None`` on request failure.
        """
        session = db_api_create_request_session()
        try:
            return db_api_get_json(
                session,
                target_ip,
                "/api/settings",
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


class StaticIpAssignmentWorker(QRunnable):
    """Assign or clear static IPv4 settings for visible selected DLSE devices."""

    def __init__(
        self,
        records: list[DeviceRecord],
        assignments: dict[str, str],
        netmask: str,
        gateway: str,
        workers: int = 20,
    ) -> None:
        """Create a bounded static-IP operation with a stable identity mapping.

        Empty assignment, netmask, and gateway values clear the corresponding
        ESP32 static-network settings.
        """
        super().__init__()
        self.signals = WorkerSignals()
        self.records = records
        self.assignments = dict(assignments)
        self.settings = {
            "ip_sta_netmsk": netmask,
            "ip_sta_gw": gateway,
        }
        self.workers = max(1, min(workers, 64))
        self._cancel_event = Event()

    def cancel(self) -> None:
        """Request cancellation of assignments that have not started yet."""
        self._cancel_event.set()

    @staticmethod
    def _normalize_netmask(value: str) -> tuple[str, IPv4Network]:
        """Normalize a dotted or prefix-length IPv4 mask and return its network helper."""
        text = str(value or "").strip().lstrip("/")
        if not text:
            raise ValueError("Enter a subnet mask, for example 255.255.255.0.")
        try:
            network = IPv4Network(f"0.0.0.0/{text}", strict=False)
        except ValueError as exc:
            raise ValueError("Enter a valid contiguous IPv4 subnet mask.") from exc
        if network.prefixlen >= 31:
            raise ValueError("The subnet mask must leave at least two usable host addresses.")
        return str(network.netmask), network

    @staticmethod
    def generate_target_ips(start_ip: str, count: int) -> list[str]:
        """Generate host-style addresses, carrying to the third octet after `.254`."""
        if count < 0:
            raise ValueError("The assignment count cannot be negative.")
        try:
            start = IPv4Address(str(start_ip or "").strip())
        except ValueError as exc:
            raise ValueError("Enter a valid starting IPv4 address.") from exc
        start_last_octet = int(str(start).rsplit(".", 1)[1])
        if not 1 <= start_last_octet <= 254:
            raise ValueError("The starting IP final octet must be between 1 and 254.")

        base = (int(start) // 256) * 256
        targets = []
        for offset in range(count):
            host_position = start_last_octet - 1 + offset
            block_offset, final_octet = divmod(host_position, 254)
            address_value = base + (block_offset * 256) + final_octet + 1
            try:
                targets.append(str(IPv4Address(address_value)))
            except ValueError as exc:
                raise ValueError("The generated IP range exceeds IPv4 address space.") from exc
        return targets

    @classmethod
    def prepare_assignments(
        cls,
        records: list[DeviceRecord],
        all_records: list[DeviceRecord],
        start_ip: str,
        netmask: str,
        gateway: str,
    ) -> tuple[dict[str, str], str, str]:
        """Validate the batch and return identity-to-target-IP assignments."""
        normalized_mask, _ = cls._normalize_netmask(netmask)
        try:
            start_address = IPv4Address(str(start_ip or "").strip())
        except ValueError as exc:
            raise ValueError("Enter a valid starting IPv4 address.") from exc
        network = IPv4Network(f"{start_address}/{normalized_mask}", strict=False)
        try:
            gateway_address = IPv4Address(str(gateway or "").strip())
        except ValueError as exc:
            raise ValueError("Enter a valid gateway IPv4 address.") from exc
        if gateway_address not in network:
            raise ValueError("The gateway must be inside the entered subnet.")
        if gateway_address in {network.network_address, network.broadcast_address}:
            raise ValueError("The gateway must be a usable host address.")

        targets = cls.generate_target_ips(start_ip, len(records))
        target_addresses = [IPv4Address(target) for target in targets]
        target_set = set(target_addresses)
        assignment_by_identity = {
            record.identity: target
            for record, target in zip(records, targets)
        }
        for target in target_addresses:
            if target not in network:
                raise ValueError(
                    f"Generated IP {target} is outside the entered subnet; use a larger subnet mask."
                )
            if target in {network.network_address, network.broadcast_address}:
                raise ValueError(f"Generated IP {target} is not a usable host address.")
            if target == gateway_address:
                raise ValueError(f"Generated IP {target} conflicts with the gateway.")

        for record in all_records:
            try:
                current_address = IPv4Address(str(record.ip or "").strip())
            except ValueError:
                continue
            own_target = assignment_by_identity.get(record.identity)
            if current_address in target_set and own_target != str(current_address):
                raise ValueError(
                    f"Generated IP {current_address} is already assigned to another retained device."
                )

        return (
            {record.identity: target for record, target in zip(records, targets)},
            normalized_mask,
            str(gateway_address),
        )

    @Slot()
    def run(self) -> None:
        """Apply assignments concurrently and emit per-device progress and results."""
        try:
            results = []
            with ThreadPoolExecutor(max_workers=self.workers) as executor:
                futures = {}
                pending_records = iter(self.records)

                def submit_next() -> bool:
                    """Submit one queued assignment unless cancellation was requested."""
                    if self._cancel_event.is_set():
                        return False
                    try:
                        record = next(pending_records)
                    except StopIteration:
                        return False
                    target_ip = self.assignments.get(record.identity, "")
                    futures[executor.submit(self._apply_one, record, target_ip)] = record
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
                        target_ip = self.assignments.get(record.identity, "")
                        try:
                            result = future.result()
                            payload = {
                                "identity": record.identity,
                                "target_ip": target_ip,
                                "settings": {
                                    "ip_sta": target_ip,
                                    **self.settings,
                                },
                                **result,
                            }
                            payload["status"] = (
                                "static IP accepted"
                                if payload.get("success")
                                else "static IP failed"
                            )
                        except Exception as exc:
                            payload = {
                                "identity": record.identity,
                                "target_ip": target_ip,
                                "success": False,
                                "status": "static IP failed",
                                "message": str(exc),
                            }
                        results.append(payload)
                        self.signals.progress.emit(payload)
                        submit_next()
            self.signals.finished.emit(results)
        except Exception as exc:
            self.signals.error.emit(str(exc))

    def _apply_one(self, record: DeviceRecord, target_ip: str) -> dict[str, Any]:
        """Apply one static-IP or clear payload to the record's current address."""
        try:
            IPv4Address(str(record.ip or "").strip())
        except ValueError:
            return {
                "success": False,
                "message": f"Current DLSE IP '{record.ip}' is invalid or missing.",
            }
        session = db_api_create_request_session()
        try:
            result = db_api_update_settings(
                session,
                record.ip,
                {"ip_sta": target_ip, **self.settings},
            )
            return {
                "success": bool(getattr(result, "success", False)),
                "message": str(getattr(result, "message", "") or ""),
            }
        finally:
            session.close()


class SysIdAlignmentWorker(QRunnable):
    """Align selected DLSE and flight-controller MAVLink system IDs safely."""

    MODES = {"ip", "fc", "manual"}
    PARAMETER_CANDIDATES = ("SYSID_THISMAV", "MAV_SYS_ID")
    PARAMETER_TIMEOUT_SECONDS = 2.0
    PARAMETER_ATTEMPTS = 2
    RETRY_DELAY_SECONDS = 0.25

    def __init__(
        self,
        records: list[DeviceRecord],
        mode: str,
        fallback_port: int,
        workers: int = 20,
    ) -> None:
        """
        Create a selected-device SYS ID alignment operation.

        :param records: Eligible selected device records to process.
        :param mode: One of ``ip``, ``fc``, or ``manual`` source modes.
        :param fallback_port: UDP destination port when device settings lack one.
        :param workers: Maximum number of simultaneous device operations.
        :raises ValueError: If ``mode`` is unsupported.
        """
        super().__init__()
        normalized_mode = mode.strip().lower()
        if normalized_mode not in self.MODES:
            raise ValueError(f"Unsupported SYS ID alignment mode: {mode}")
        self.signals = WorkerSignals()
        self.records = records
        self.mode = normalized_mode
        self.fallback_port = fallback_port
        self.workers = max(1, min(workers, 64))
        self.cancel_event = Event()

    def cancel(self) -> None:
        """Prevent queued devices from starting new SYS ID alignment work."""
        self.cancel_event.set()

    @Slot()
    def run(self) -> None:
        """Align queued devices with bounded parallelism and emit row progress."""
        results: list[dict[str, Any]] = []
        try:
            with ThreadPoolExecutor(max_workers=self.workers) as executor:
                futures: dict[Any, DeviceRecord] = {}
                pending_records = iter(self.records)

                def submit_next() -> bool:
                    """Submit one device unless cancellation was requested."""
                    if self.cancel_event.is_set():
                        return False
                    try:
                        record = next(pending_records)
                    except StopIteration:
                        return False
                    futures[executor.submit(self._align_one, record)] = record
                    return True

                for _ in range(min(self.workers, len(self.records))):
                    submit_next()
                while futures:
                    completed, _pending = wait(futures, return_when=FIRST_COMPLETED)
                    for future in completed:
                        record = futures.pop(future)
                        try:
                            result = future.result()
                        except Exception as exc:
                            result = self._result(record, False, str(exc))
                        results.append(result)
                        self.signals.progress.emit({
                            "identity": record.identity,
                            "success": result["success"],
                            "status": "complete" if result["success"] else "failed",
                            "percent": 100 if result["success"] else 0,
                            "message": result["message"],
                        })
                        submit_next()
            self.signals.finished.emit(results)
        except Exception as exc:
            self.signals.error.emit(str(exc))

    def _align_one(self, record: DeviceRecord) -> dict[str, Any]:
        """
        Align one device and return its structured success or failure result.

        Flight-controller changes are completed before a DLSE settings request,
        because accepted settings reboot the ESP32 and would interrupt MAVLink.
        """
        target_sys_id, error = self._target_sys_id(record)
        if error:
            return self._result(record, False, error)

        if self.mode != "fc":
            self._emit_stage(record, "writing FC SYS ID", 15)
            success, message = self._update_and_reboot_fc(record, target_sys_id)
            if not success:
                return self._result(record, False, message)

        self._emit_stage(record, "applying DLSE SYS ID settings", 75)
        session = db_api_create_request_session()
        try:
            settings_result = db_api_update_settings(
                session,
                record.ip,
                self._dlse_settings(target_sys_id),
            )
        finally:
            session.close()
        if not settings_result.success:
            return self._result(
                record,
                False,
                f"DLSE settings update failed: {settings_result.message}",
            )
        return self._result(record, True, "SYS IDs aligned; DLSE settings accepted")

    def _target_sys_id(self, record: DeviceRecord) -> tuple[int, str]:
        """
        Resolve and validate the selected source SYS ID for one record.

        :param record: Selected device whose cached details provide the source.
        :return: A valid target ID and an empty error, or ``0`` and an error.
        """
        if self.mode == "ip":
            try:
                target = int(IPv4Address(str(record.ip).strip())) & 0xFF
            except ValueError:
                return 0, "DLSE IP address does not provide a valid SYS ID"
            if not self._is_valid_sys_id(target):
                return 0, "DLSE IP address last octet must be between 1 and 255"
            return target, ""
        source = (
            record.stats.get("fc_sysid")
            if self.mode == "fc"
            else record.settings.get("show_man_sysid")
        )
        target = self._coerce_sys_id(source)
        if target is None:
            label = "FC SYS ID" if self.mode == "fc" else "manual DLSE SYS ID"
            return 0, f"Cached {label} must be between 1 and 255"
        return target, ""

    def _dlse_settings(self, target_sys_id: int) -> dict[str, int]:
        """
        Return the minimal DLSE settings payload for the selected alignment mode.

        :param target_sys_id: Already validated source ID for FC-based mode.
        :return: Partial settings safe for ``POST /api/settings``.
        """
        if self.mode == "ip":
            return {"show_en_syid_ip": 1}
        if self.mode == "fc":
            return {"show_man_sysid": target_sys_id, "show_en_syid_ip": 0}
        return {"show_en_syid_ip": 0}

    def _update_and_reboot_fc(
        self,
        record: DeviceRecord,
        target_sys_id: int,
    ) -> tuple[bool, str]:
        """
        Confirm an FC parameter update, then request an acknowledged reboot.

        :param record: Device whose cached FC SYS ID and UDP port are used.
        :param target_sys_id: Valid ID to write to the FC.
        :return: Success flag and operator-facing result message.
        """
        current_sys_id = self._coerce_sys_id(record.stats.get("fc_sysid"))
        if current_sys_id is None:
            return False, "Cached FC SYS ID must be between 1 and 255"
        port = self._resolve_udp_port(record.settings.get("udp_local_port"), self.fallback_port)
        if port is None:
            return False, "DLSE UDP port must be between 1 and 65535"

        connection = f"udpout:{record.ip}:{port}"
        master = None
        reasons: list[str] = []
        try:
            master = mavutil.mavlink_connection(connection, source_system=255)
            for parameter_name in self.PARAMETER_CANDIDATES:
                if parameter_name == "MAV_SYS_ID" and target_sys_id > 250:
                    reasons.append("PX4 MAV_SYS_ID accepts values only through 250")
                    continue
                parameter_type = self._read_parameter_type(
                    master,
                    current_sys_id,
                    parameter_name,
                )
                if parameter_type is None:
                    reasons.append(f"{parameter_name} was not available")
                    continue
                if self._write_parameter_and_confirm(
                    master,
                    current_sys_id,
                    parameter_name,
                    target_sys_id,
                    parameter_type,
                ):
                    self._emit_stage(record, "rebooting FC", 55)
                    if self._reboot_fc(master, current_sys_id):
                        return True, f"FC SYS ID set through {parameter_name} and reboot accepted"
                    return False, "FC SYS ID updated but reboot not confirmed; DLSE settings were not changed"
                reasons.append(f"{parameter_name} did not confirm the requested value")
            return False, "FC SYS ID update failed: " + "; ".join(reasons)
        except Exception as exc:
            return False, f"FC MAVLink operation failed: {exc}"
        finally:
            close = getattr(master, "close", None)
            if callable(close):
                close()

    def _read_parameter_type(
        self,
        master: Any,
        target_system: int,
        parameter_name: str,
    ) -> Any | None:
        """
        Request a parameter and return its MAVLink type when it is echoed.

        :param master: Open MAVLink connection to one DLSE endpoint.
        :param target_system: Current FC system ID used for targeted messages.
        :param parameter_name: Candidate ArduPilot or PX4 parameter name.
        :return: MAVLink parameter type, or ``None`` when not confirmed.
        """
        for attempt in range(self.PARAMETER_ATTEMPTS):
            master.mav.param_request_read_send(
                target_system,
                mavutil.mavlink.MAV_COMP_ID_AUTOPILOT1,
                parameter_name.encode("ascii"),
                -1,
            )
            message = self._wait_for_parameter(master, parameter_name)
            if message is not None:
                return getattr(message, "param_type", None)
            if attempt + 1 < self.PARAMETER_ATTEMPTS:
                sleep(self.RETRY_DELAY_SECONDS)
        return None

    def _write_parameter_and_confirm(
        self,
        master: Any,
        target_system: int,
        parameter_name: str,
        target_value: int,
        parameter_type: Any,
    ) -> bool:
        """
        Write a parameter and require a matching ``PARAM_VALUE`` echo.

        :param master: Open MAVLink connection to one DLSE endpoint.
        :param target_system: Current FC system ID used for targeted messages.
        :param parameter_name: Confirmed parameter name to update.
        :param target_value: Valid MAVLink system ID to store.
        :param parameter_type: Type reported by the FC during parameter read.
        :return: ``True`` only after a matching echoed value is received.
        """
        for attempt in range(self.PARAMETER_ATTEMPTS):
            master.mav.param_set_send(
                target_system,
                mavutil.mavlink.MAV_COMP_ID_AUTOPILOT1,
                parameter_name.encode("ascii"),
                float(target_value),
                parameter_type,
            )
            message = self._wait_for_parameter(master, parameter_name, target_value)
            if message is not None:
                return True
            if attempt + 1 < self.PARAMETER_ATTEMPTS:
                sleep(self.RETRY_DELAY_SECONDS)
        return False

    def _reboot_fc(self, master: Any, target_system: int) -> bool:
        """
        Request an FC reboot and require an accepted MAVLink command acknowledgement.

        :param master: Open MAVLink connection to one DLSE endpoint.
        :param target_system: Current FC system ID used for targeted messages.
        :return: ``True`` only when the FC accepts the reboot command.
        """
        command = mavutil.mavlink.MAV_CMD_PREFLIGHT_REBOOT_SHUTDOWN
        for attempt in range(self.PARAMETER_ATTEMPTS):
            master.mav.command_long_send(
                target_system,
                mavutil.mavlink.MAV_COMP_ID_AUTOPILOT1,
                command,
                0,
                1,
                0,
                0,
                0,
                0,
                0,
                0,
            )
            message = self._wait_for_command_ack(master, command)
            if message is not None:
                return True
            if attempt + 1 < self.PARAMETER_ATTEMPTS:
                sleep(self.RETRY_DELAY_SECONDS)
        return False

    def _wait_for_parameter(
        self,
        master: Any,
        parameter_name: str,
        expected_value: int | None = None,
    ) -> Any | None:
        """
        Wait up to the bounded timeout for a matching FC parameter response.

        :param master: Open MAVLink connection to one DLSE endpoint.
        :param parameter_name: Expected parameter identifier.
        :param expected_value: Optional value that must match the echo.
        :return: Matching MAVLink message, or ``None`` after timeout.
        """
        deadline = monotonic() + self.PARAMETER_TIMEOUT_SECONDS
        while True:
            remaining = deadline - monotonic()
            if remaining <= 0:
                return None
            message = master.recv_match(
                type="PARAM_VALUE",
                blocking=True,
                timeout=remaining,
            )
            if message is None:
                return None
            if self._parameter_name(message) != parameter_name:
                continue
            if expected_value is None:
                return message
            try:
                if int(round(float(message.param_value))) == expected_value:
                    return message
            except (AttributeError, TypeError, ValueError):
                pass

    def _wait_for_command_ack(self, master: Any, command: int) -> Any | None:
        """
        Wait up to the bounded timeout for an accepted FC reboot acknowledgement.

        :param master: Open MAVLink connection to one DLSE endpoint.
        :param command: MAVLink command identifier that must be acknowledged.
        :return: Accepted acknowledgement message, or ``None`` after timeout.
        """
        deadline = monotonic() + self.PARAMETER_TIMEOUT_SECONDS
        while True:
            remaining = deadline - monotonic()
            if remaining <= 0:
                return None
            message = master.recv_match(
                type="COMMAND_ACK",
                blocking=True,
                timeout=remaining,
            )
            if message is None:
                return None
            if getattr(message, "command", None) != command:
                continue
            if getattr(message, "result", None) == mavutil.mavlink.MAV_RESULT_ACCEPTED:
                return message

    @staticmethod
    def _parameter_name(message: Any) -> str:
        """
        Normalize a MAVLink parameter identifier from bytes or text.

        :param message: MAVLink ``PARAM_VALUE`` message.
        :return: Null-trimmed ASCII parameter identifier.
        """
        value = getattr(message, "param_id", b"")
        if isinstance(value, bytes):
            return value.decode("ascii", errors="ignore").split("\x00", 1)[0]
        return str(value).split("\x00", 1)[0]

    @staticmethod
    def _resolve_udp_port(value: Any, fallback: int) -> int | None:
        """
        Select a valid device UDP port or a valid operation fallback port.

        :param value: Hydrated ``udp_local_port`` value from one DLSE.
        :param fallback: Scan settings ESP32 port used when ``value`` is invalid.
        :return: A port from 1 through 65535, or ``None`` when unavailable.
        """
        for candidate in (value, fallback):
            try:
                port = int(candidate)
            except (TypeError, ValueError):
                continue
            if 1 <= port <= 65535:
                return port
        return None

    @staticmethod
    def _coerce_sys_id(value: Any) -> int | None:
        """
        Convert one cached source value to a valid MAVLink system ID.

        :param value: Raw cached REST settings or stats value.
        :return: An ID from 1 through 255, or ``None`` when invalid.
        """
        try:
            sys_id = int(value)
        except (TypeError, ValueError):
            return None
        return sys_id if SysIdAlignmentWorker._is_valid_sys_id(sys_id) else None

    @staticmethod
    def _is_valid_sys_id(value: int) -> bool:
        """Return whether ``value`` is a valid MAVLink system ID from 1 through 255."""
        return 1 <= value <= 255

    def _emit_stage(self, record: DeviceRecord, status: str, percent: int) -> None:
        """
        Emit an in-progress row status for one device.

        :param record: Device currently being aligned.
        :param status: Short operator-facing activity label.
        :param percent: Approximate operation completion percentage.
        :return: None.
        """
        self.signals.progress.emit({
            "identity": record.identity,
            "status": status,
            "percent": percent,
        })

    @staticmethod
    def _result(record: DeviceRecord, success: bool, message: str) -> dict[str, Any]:
        """
        Create one result mapping compatible with the shared controller handler.

        :param record: Device the result belongs to.
        :param success: Whether every required operation succeeded.
        :param message: Safe operator-facing success or failure explanation.
        :return: Structured result mapping with the stable device identity.
        """
        return {"identity": record.identity, "success": success, "message": message}


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

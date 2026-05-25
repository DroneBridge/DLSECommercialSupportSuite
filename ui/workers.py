"""Background workers for discovery, detail refresh, and license activation."""

import os
from typing import Any

from PySide6.QtCore import QObject, QRunnable, Signal, Slot

from DroneBridgeCommercialSupportSuite import (
    DBLicenseType,
    db_api_activate_dlse_device,
    db_api_create_request_session,
    db_api_get_device_details,
    db_is_dlse_lic_server_available,
    db_scan_for_esp32_devices,
    db_scan_for_esp32_devices_by_ip_range,
)
from ui.models import DeviceRecord, record_from_discovery


class WorkerSignals(QObject):
    """Signals shared by QRunnable workers."""
    finished = Signal(object)
    error = Signal(str)
    progress = Signal(object)


class DiscoveryWorker(QRunnable):
    """Run MAVLink and/or HTTP discovery without blocking the UI."""

    def __init__(self, subnet: str, mavlink_enabled: bool, http_enabled: bool,
                 esp32_port: int, local_port: int, http_timeout: float,
                 http_workers: int) -> None:
        """
        Create a discovery worker.

        :param subnet: CIDR subnet or range accepted by the support-suite scanner.
        :param mavlink_enabled: Whether to run UDP/MAVLink broadcast discovery.
        :param http_enabled: Whether to run HTTP probing across the subnet.
        :param esp32_port: ESP32 UDP broadcast port.
        :param local_port: Local UDP broadcast receive port.
        :param http_timeout: Per-host HTTP probe timeout in seconds.
        :param http_workers: Maximum concurrent HTTP probes.
        """
        super().__init__()
        self.signals = WorkerSignals()
        self.subnet = subnet
        self.mavlink_enabled = mavlink_enabled
        self.http_enabled = http_enabled
        self.esp32_port = esp32_port
        self.local_port = local_port
        self.http_timeout = http_timeout
        self.http_workers = http_workers

    @Slot()
    def run(self) -> None:
        """
        Execute discovery and emit normalized device records.

        Discovery failures are reported through ``error`` and do not crash the UI.
        """
        records: list[DeviceRecord] = []
        try:
            if self.mavlink_enabled:
                for device in db_scan_for_esp32_devices(
                    subnet_mask=self.subnet,
                    timeout=2,
                    esp32_broadcast_port=self.esp32_port,
                    local_brcst_port=self.local_port,
                    _beta_4_support=True,
                ):
                    records.append(record_from_discovery(device, "mavlink"))
            if self.http_enabled:
                for device in db_scan_for_esp32_devices_by_ip_range(
                    subnet_mask=self.subnet,
                    timeout=self.http_timeout,
                    max_workers=self.http_workers,
                ):
                    records.append(record_from_discovery(device, "http"))
            self.signals.finished.emit(records)
        except Exception as exc:
            self.signals.error.emit(str(exc))


class DeviceDetailsWorker(QRunnable):
    """Fetch REST detail data for the selected ESP32."""

    def __init__(self, record: DeviceRecord, token: str | None = None) -> None:
        """
        Create a details worker.

        :param record: Selected device record.
        :param token: Optional session token for authenticated endpoints.
        """
        super().__init__()
        self.signals = WorkerSignals()
        self.record = record
        self.token = token

    @Slot()
    def run(self) -> None:
        """
        Fetch details and emit a merged record plus raw details.

        Network errors are folded into the returned details dictionary.
        """
        session = db_api_create_request_session()
        try:
            details = db_api_get_device_details(session, self.record.ip, token=self.token)
            merged: dict[str, Any] = dict(self.record.raw)
            merged["ip"] = self.record.ip
            if details.get("system_info"):
                merged["system_info"] = details["system_info"]
            if details.get("settings"):
                merged["settings"] = details["settings"]
            if details.get("stats"):
                merged["stats"] = details["stats"]
            normalized = record_from_discovery(merged, self.record.source or "rest")
            self.signals.finished.emit({"record": normalized, "details": details})
        except Exception as exc:
            self.signals.error.emit(str(exc))
        finally:
            session.close()


class LicenseStatusWorker(QRunnable):
    """Check whether the DroneBridge license server is reachable."""

    def __init__(self) -> None:
        """Create a license-server status worker."""
        super().__init__()
        self.signals = WorkerSignals()

    @Slot()
    def run(self) -> None:
        """
        Emit True when the license server is reachable.

        The support-suite helper applies its own timeout.
        """
        try:
            self.signals.finished.emit(db_is_dlse_lic_server_available())
        except Exception as exc:
            self.signals.error.emit(str(exc))


class ActivationWorker(QRunnable):
    """Activate selected ESP32 devices in sequence."""

    def __init__(self, records: list[DeviceRecord], token: str, license_type: DBLicenseType) -> None:
        """
        Create an activation worker.

        :param records: Device records selected for activation.
        :param token: DroneBridge license server token for this session.
        :param license_type: Regular activated or evaluation license type.
        """
        super().__init__()
        self.signals = WorkerSignals()
        self.records = records
        self.token = token or os.environ.get("DRONEBRIDGE_SECRET_TOKEN", "")
        self.license_type = license_type

    @Slot()
    def run(self) -> None:
        """
        Activate records one-by-one and emit progress for each device.

        Evaluation licenses use a fixed 60-day validity. Regular activated
        licenses use zero validity days, matching the batch workflow.
        """
        session = db_api_create_request_session()
        processed_keys: set[str] = set()
        successful_ips: set[str] = set()
        try:
            validity_days = 60 if self.license_type == DBLicenseType.EVALUATION else 0
            for record in self.records:
                self.signals.progress.emit({"identity": record.identity, "status": "activating"})
                result = db_api_activate_dlse_device(
                    device={"ip": record.ip, "sys_id": record.mavlink_sys_id or None},
                    session=session,
                    token=self.token,
                    processed_keys=processed_keys,
                    successful_ips=successful_ips,
                    license_type=self.license_type,
                    validity_days=validity_days,
                )
                self.signals.progress.emit({
                    "identity": record.identity,
                    "status": result.status.value,
                    "result": result,
                })
            self.signals.finished.emit(True)
        except Exception as exc:
            self.signals.error.emit(str(exc))
        finally:
            session.close()


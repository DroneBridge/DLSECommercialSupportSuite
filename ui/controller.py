"""QML-facing application controller for the DLSE Fleet Manager."""

from __future__ import annotations

import ipaddress
import json
import math
import os
from importlib.metadata import PackageNotFoundError, version
from pathlib import Path
from time import monotonic
from typing import Any, Callable

from PySide6.QtCore import (
    Property,
    QObject,
    QSettings,
    QThreadPool,
    QTimer,
    QUrl,
    Qt,
    Signal,
    Slot,
)

from DroneBridgeCommercialSupportSuite import (
    DBLicenseType,
    db_check_release_binaries_present,
    db_settings_from_csv,
    db_settings_to_csv,
)
from ui.models import (
    DeviceCardModel,
    DeviceFilterProxyModel,
    DeviceRecord,
    DeviceTableModel,
)
from ui.workers import (
    ActivationWorker,
    DiscoveryWorker,
    LicenseStatusWorker,
    OtaReleaseListWorker,
    OtaReleaseResolveWorker,
    OtaWorker,
    RebootWorker,
    SettingsWorker,
    StatsPollingWorker,
)


DEFAULT_BULK_EXCLUSIONS = {
    "ip_sta",
    "ip_sta_netmsk",
    "ip_sta_gw",
    "wifi_hostname",
    "show_man_sysid",
}
MIN_COLUMN_WIDTH = 48
MAX_COLUMN_WIDTH = 420
DEFAULT_INSPECTOR_WIDTH = 355
MIN_INSPECTOR_WIDTH = 300
MAX_INSPECTOR_WIDTH = 640


class FleetController(QObject):
    """Coordinate QML state, persisted preferences, and background workflows."""

    stateChanged = Signal()
    inspectorChanged = Signal()
    webUrlChanged = Signal()
    columnsChanged = Signal()
    inspectorWidthChanged = Signal()
    scanSettingsChanged = Signal()
    csvTemplateChanged = Signal()
    csvTemplateReady = Signal()
    otaReleasesChanged = Signal()
    toastRequested = Signal(str, str)
    resultReady = Signal(str, str, bool)

    def __init__(self) -> None:
        """Create fleet models, timers, settings, and operation state."""
        super().__init__()
        self.settings = QSettings("DroneBridge", "DLSECommercialSupportSuite")
        self.pool = QThreadPool.globalInstance()
        self.source_model = DeviceTableModel()
        self.fleet_model = DeviceFilterProxyModel()
        self.fleet_model.setSourceModel(self.source_model)
        self.card_model = DeviceCardModel(self.fleet_model)

        self._scanning_enabled = False
        self._scan_running = False
        self._discovery_status = "STOPPED"
        self._stats_poll_running = False
        self._stats_worker: StatsPollingWorker | None = None
        self._stats_round_started_at = 0.0
        self._stats_polling_status = (
            "WAITING" if self._scan_values()["stats_enabled"] else "DISABLED"
        )
        self._fleet_generation = 0
        self._license_check_running = False
        self._license_status = "unknown"
        self._status_text = "IDLE"
        self._active_worker: Any = None
        self._active_operation = ""
        self._active_targets: set[str] = set()
        self._inspected_identity = ""
        self._last_web_url = ""
        self._setting_edits: dict[str, Any] = {}
        self._csv_template: dict[str, Any] = {}
        self._failed_identities: set[str] = set()
        self._retry_context: tuple[str, dict[str, Any]] | None = None
        self._ota_releases: list[dict[str, Any]] = []
        self._ota_release_lookup: dict[str, dict[str, Any]] = {}
        self._ota_release_status = "Not loaded"
        self._ota_release_refresh_running = False
        self._ota_pending_options: dict[str, Any] | None = None

        self.source_model.inventoryChanged.connect(self._inventory_changed)
        self.source_model.selectionChanged.connect(self.stateChanged)
        self._restore_columns()

        self.scan_timer = QTimer(self)
        self.scan_timer.timeout.connect(self.startScan)
        self._restart_scan_timer()
        self.stats_timer = QTimer(self)
        self.stats_timer.setSingleShot(True)
        self.stats_timer.timeout.connect(self.startStatsPolling)
        if self._scan_values()["stats_enabled"]:
            self.stats_timer.start(self._scan_values()["stats_interval"] * 1000)
        self.license_timer = QTimer(self)
        self.license_timer.setInterval(10_000)
        self.license_timer.timeout.connect(self.checkLicenseServer)
        self.license_timer.start()
        QTimer.singleShot(250, self.checkLicenseServer)

    @Property(str, constant=True)
    def suiteVersion(self) -> str:
        """Return the installed suite version or ``local``."""
        try:
            return version("DLSECommercialSupportSuite")
        except PackageNotFoundError:
            return "local"

    @Property(bool, notify=stateChanged)
    def scanning(self) -> bool:
        """Return whether recurring discovery is enabled."""
        return self._scanning_enabled

    @Property(bool, notify=stateChanged)
    def scanRunning(self) -> bool:
        """Return whether a discovery pass is currently active."""
        return self._scan_running

    @Property(str, notify=stateChanged)
    def discoveryStatus(self) -> str:
        """Return ``STOPPED``, ``WAITING``, ``SCANNING``, or ``ERROR``."""
        return self._discovery_status

    @Property(str, notify=stateChanged)
    def statsPollingStatus(self) -> str:
        """Return ``DISABLED``, ``WAITING``, ``POLLING``, or ``ERROR``."""
        return self._stats_polling_status

    @Property(str, notify=stateChanged)
    def statusText(self) -> str:
        """Return the concise fleet status shown in the footer."""
        return self._status_text

    @Property(str, notify=stateChanged)
    def licenseStatus(self) -> str:
        """Return ``online``, ``offline``, ``checking``, or ``unknown``."""
        return self._license_status

    @Property(int, notify=stateChanged)
    def detectedCount(self) -> int:
        """Return the number of retained session devices."""
        return self.source_model.rowCount()

    @Property(int, notify=stateChanged)
    def visibleCount(self) -> int:
        """Return the number of devices accepted by the current filter."""
        return self.fleet_model.rowCount()

    @Property(int, notify=stateChanged)
    def selectedCount(self) -> int:
        """Return the number of explicitly selected devices."""
        return len(self.source_model.selected_records())

    @Property(str, notify=stateChanged)
    def activeOperation(self) -> str:
        """Return the currently active fleet operation name."""
        return self._active_operation

    @Property(bool, notify=stateChanged)
    def canCancel(self) -> bool:
        """Return whether the active worker supports queued-work cancellation."""
        return callable(getattr(self._active_worker, "cancel", None))

    @Property(str, notify=stateChanged)
    def environmentToken(self) -> str:
        """Return the session-only token supplied through the environment."""
        return os.environ.get("DRONEBRIDGE_SECRET_TOKEN", "")

    @Property("QVariantList", notify=otaReleasesChanged)
    def otaReleases(self) -> list[dict[str, Any]]:
        """Return UI-safe cached and online release choices for OTA updates."""
        visible_releases = []
        for option in self._ota_releases:
            visible_releases.append({
                key: value
                for key, value in option.items()
                if key != "release"
            })
        return visible_releases

    @Property(str, notify=otaReleasesChanged)
    def otaReleaseStatus(self) -> str:
        """Return the current release-listing or release-preflight status."""
        return self._ota_release_status

    @Property("QVariantMap", notify=scanSettingsChanged)
    def scanSettings(self) -> dict[str, Any]:
        """Return persisted discovery settings with field-safe defaults."""
        return self._scan_values()

    @Property("QVariantList", notify=columnsChanged)
    def columns(self) -> list[dict[str, Any]]:
        """Return ordered configurable column metadata for the QML dialog."""
        visible_keys = self.source_model.visible_column_keys()
        visible = set(visible_keys)
        ordered_keys = visible_keys + [
            key
            for key, _title, _width in DeviceTableModel.COLUMNS
            if key not in visible
        ]
        definitions = {
            key: (title, width)
            for key, title, width in DeviceTableModel.COLUMNS
        }
        return [
            {
                "key": key,
                "title": definitions[key][0],
                "width": self._column_width_for_key(key),
                "visible": key in visible,
                "canMoveUp": key in visible and visible_keys.index(key) > 0,
                "canMoveDown": (
                    key in visible
                    and visible_keys.index(key) < len(visible_keys) - 1
                ),
            }
            for key in ordered_keys
        ]

    @Property("QVariantMap", notify=inspectorChanged)
    def selectedDevice(self) -> dict[str, Any]:
        """Return complete flattened data for the inspected device."""
        record = self._inspected_record()
        if record is None:
            return {}
        return {
            "identity": record.identity,
            "ip": record.ip,
            "hostname": record.hostname,
            "activationStatus": record.activation_status,
            "firmwareVersion": record.firmware_version,
            "dronebridgeVersion": record.dronebridge_version,
            "mavlinkSysId": record.mavlink_sys_id,
            "fcSysId": record.fc_sys_id,
            "wifiSsid": record.wifi_ssid,
            "wifiChannel": record.wifi_channel,
            "rssi": record.rssi,
            "batteryVoltage": record.battery_voltage,
            "activationKey": record.activation_key,
            "mac": record.mac,
            "source": record.source,
            "online": record.online,
            "operation": record.operation,
            "operationProgress": record.operation_progress,
            "systemInfo": record.system_info,
            "settings": record.settings,
            "stats": record.stats,
            "errors": record.errors,
        }

    @Property(str, notify=inspectorChanged)
    def inspectedIdentity(self) -> str:
        """Return the stable identity currently shown in the inspector."""
        return self._inspected_identity

    @Property("QVariantList", notify=inspectorChanged)
    def settingsFields(self) -> list[dict[str, Any]]:
        """Return typed, dirty-aware setting editor definitions."""
        record = self._inspected_record()
        if record is None:
            return []
        fields = []
        for key in sorted(record.settings):
            if key.endswith("_type"):
                continue
            original = record.settings[key]
            current = self._setting_edits.get(key, original)
            fields.append(
                {
                    "key": key,
                    "label": key,
                    "value": current,
                    "original": original,
                    "metadataType": str(record.settings.get(f"{key}_type", "")),
                    "editor": self._editor_type(key, original),
                    "dirty": current != original,
                }
            )
        return fields

    @Property("QVariantList", notify=inspectorChanged)
    def metrics(self) -> list[dict[str, Any]]:
        """Return system and runtime details for the inspector metrics tab."""
        record = self._inspected_record()
        if record is None:
            return []
        base = {
            "IP": record.ip,
            "Hostname": record.hostname,
            "MAC": record.mac,
            "Activation key": record.activation_key,
            "License": record.activation_status,
            "Firmware": record.firmware_version,
            "Build Version": record.dronebridge_version,
            "Online": record.online,
            "Discovery source": record.source,
        }
        rows = [
            {"group": "Device", "key": key, "value": str(value)}
            for key, value in base.items()
        ]
        rows.extend(
            {"group": "System", "key": str(key), "value": str(value)}
            for key, value in sorted(record.system_info.items())
        )
        rows.extend(
            {"group": "Statistics", "key": str(key), "value": str(value)}
            for key, value in sorted(record.stats.items())
        )
        return rows

    @Property(str, notify=webUrlChanged)
    def webUrl(self) -> str:
        """Return the selected online device web-interface URL."""
        record = self._inspected_record()
        return f"http://{record.ip}" if record and record.online and record.ip else ""

    @Property(int, notify=inspectorWidthChanged)
    def inspectorWidth(self) -> int:
        """Return the persisted right-side configuration panel width."""
        return self._inspector_width()

    @Property("QVariantList", notify=csvTemplateChanged)
    def csvParameters(self) -> list[dict[str, Any]]:
        """Return imported template parameters and default exclusions."""
        multi_device = len(self._target_records("selected_or_visible")) > 1
        defaults = DEFAULT_BULK_EXCLUSIONS if multi_device else set()
        return [
            {
                "key": key,
                "value": str(value),
                "excluded": key in defaults,
            }
            for key, value in sorted(self._csv_template.items())
        ]

    @Slot()
    def toggleScanning(self) -> None:
        """Start or stop recurring non-overlapping discovery."""
        self._scanning_enabled = not self._scanning_enabled
        self._status_text = "SCANNING..." if self._scanning_enabled else "STOPPED"
        if not self._scanning_enabled and not self._scan_running:
            self._discovery_status = "STOPPED"
        self.stateChanged.emit()
        if self._scanning_enabled:
            self.startScan()

    @Slot()
    def startScan(self) -> None:
        """Start one discovery pass when scanning is enabled and idle."""
        if not self._scanning_enabled or self._scan_running:
            return
        values = self._scan_values()
        self._scan_running = True
        self._discovery_status = "SCANNING"
        self._status_text = "SCANNING..."
        self.stateChanged.emit()
        worker = DiscoveryWorker(
            values["subnet"],
            values["mavlink"],
            values["http"],
            values["esp32_port"],
            values["local_port"],
            values["http_timeout"],
            values["workers"],
        )
        worker.signals.finished.connect(self._scan_finished)
        worker.signals.progress.connect(self._scan_progress)
        worker.signals.error.connect(self._scan_failed)
        self.pool.start(worker)

    @Slot()
    def startStatsPolling(self) -> None:
        """
        Start one bounded stats round when retained devices are available.

        :return: None. Calls made during an active round are ignored; an empty
            fleet reschedules the next check without creating a worker.
        """
        values = self._scan_values()
        if not values["stats_enabled"]:
            self.stats_timer.stop()
            self._stats_polling_status = "DISABLED"
            self.stateChanged.emit()
            return
        if self._stats_poll_running:
            return
        records = self.source_model.all_records()
        if not records:
            self._stats_polling_status = "WAITING"
            self.stats_timer.start(values["stats_interval"] * 1000)
            self.stateChanged.emit()
            return
        generation = self._fleet_generation
        worker = StatsPollingWorker(
            records,
            timeout=values["stats_timeout"],
            workers=values["stats_workers"],
        )
        self.stats_timer.stop()
        self._stats_poll_running = True
        self._stats_worker = worker
        self._stats_round_started_at = monotonic()
        self._stats_polling_status = "POLLING"
        worker.signals.progress.connect(
            lambda payload, active_generation=generation:
                self._stats_progress(payload, active_generation)
        )
        worker.signals.finished.connect(
            lambda results, active_generation=generation:
                self._stats_finished(results, active_generation)
        )
        worker.signals.error.connect(
            lambda message, active_generation=generation:
                self._stats_failed(message, active_generation)
        )
        self.stateChanged.emit()
        self.pool.start(worker)

    @Slot(
        str,
        bool,
        bool,
        int,
        int,
        int,
        float,
        int,
        bool,
        int,
        float,
        int,
        int,
        result=bool,
    )
    def saveScanSettings(
        self,
        subnet: str,
        mavlink_enabled: bool,
        http_enabled: bool,
        esp32_port: int,
        local_port: int,
        interval: int,
        http_timeout: float,
        workers: int,
        stats_enabled: bool,
        stats_interval: int,
        stats_timeout: float,
        stats_workers: int,
        stats_failure_threshold: int,
    ) -> bool:
        """Validate, persist, and apply discovery and stats polling settings."""
        try:
            network = ipaddress.ip_network(subnet.strip(), strict=False)
        except ValueError:
            self.toastRequested.emit("error", "Enter a valid IPv4 CIDR subnet.")
            return False
        if network.version != 4:
            self.toastRequested.emit("error", "Only IPv4 discovery ranges are supported.")
            return False
        if network.num_addresses > 65536:
            self.toastRequested.emit(
                "error",
                "The discovery range is too large. Use an IPv4 /16 or smaller range.",
            )
            return False
        if not (mavlink_enabled or http_enabled):
            self.toastRequested.emit("error", "Enable MAVLink or HTTP discovery.")
            return False
        if not 1 <= esp32_port <= 65535 or not 1 <= local_port <= 65535:
            self.toastRequested.emit("error", "Ports must be between 1 and 65535.")
            return False
        values = {
            "subnet": str(network),
            "mavlink": mavlink_enabled,
            "http": http_enabled,
            "esp32_port": esp32_port,
            "local_port": local_port,
            "interval": max(5, min(interval, 3600)),
            "http_timeout": max(0.1, min(http_timeout, 30.0)),
            "workers": max(1, min(workers, 64)),
            "stats_enabled": stats_enabled,
            "stats_interval": max(1, min(stats_interval, 3600)),
            "stats_timeout": max(0.1, min(stats_timeout, 30.0)),
            "stats_workers": max(1, min(stats_workers, 64)),
            "stats_failure_threshold": max(
                1,
                min(stats_failure_threshold, 20),
            ),
        }
        was_stats_enabled = self._scan_values()["stats_enabled"]
        for key, value in values.items():
            self.settings.setValue(f"scan/{key}", value)
        self._restart_scan_timer()
        if not stats_enabled:
            self._fleet_generation += 1
            if self._stats_worker is not None:
                self._stats_worker.cancel()
            self._stats_poll_running = False
            self._stats_worker = None
            self.stats_timer.stop()
            self._stats_polling_status = "DISABLED"
        elif not was_stats_enabled:
            self._stats_polling_status = "WAITING"
            self.startStatsPolling()
        elif not self._stats_poll_running:
            self._stats_polling_status = "WAITING"
            self._schedule_next_stats_round()
        self.scanSettingsChanged.emit()
        self.stateChanged.emit()
        return True

    @Slot(str)
    def setSearchText(self, text: str) -> None:
        """Apply full-record filtering to both fleet views."""
        self.fleet_model.setFilterText(text)
        self.stateChanged.emit()

    @Slot(int, bool)
    def sortByColumn(self, column: int, ascending: bool) -> None:
        """Sort the visible table by one projected column."""
        order = Qt.AscendingOrder if ascending else Qt.DescendingOrder
        self.fleet_model.sort(column, order)

    @Slot(int, result=int)
    def columnWidth(self, column: int) -> int:
        """Return the preferred width for one projected table column."""
        return self._column_width_for_key(self.source_model.column_key(column))

    @Slot(int, int, result=int)
    def setColumnWidth(self, column: int, width: int) -> int:
        """Persist one manually resized visible data-column width and return it."""
        key = self.source_model.column_key(column)
        if key == "selected" or self.source_model.column_definition(key) is None:
            return self.columnWidth(column)
        try:
            requested = int(width)
        except (TypeError, ValueError):
            requested = self._default_column_width(key)
        bounded = max(MIN_COLUMN_WIDTH, min(MAX_COLUMN_WIDTH, requested))
        default_width = self._default_column_width(key)
        if bounded == default_width:
            self.settings.remove(f"columns/width/{key}")
        else:
            self.settings.setValue(f"columns/width/{key}", bounded)
        self.columnsChanged.emit()
        return bounded

    @Slot(int, result=int)
    def resetColumnWidth(self, column: int) -> int:
        """Reset one visible data-column width to its default value."""
        key = self.source_model.column_key(column)
        if key != "selected":
            self.settings.remove(f"columns/width/{key}")
            self.columnsChanged.emit()
        return self.columnWidth(column)

    @Slot()
    def resetColumnWidths(self) -> None:
        """Remove all persisted fleet-table data-column widths."""
        for key, _title, _width in DeviceTableModel.COLUMNS:
            self.settings.remove(f"columns/width/{key}")
        self.columnsChanged.emit()

    @Slot(int, result=int)
    def setInspectorWidth(self, width: int) -> int:
        """Persist a bounded right-side configuration panel width and return it."""
        try:
            requested = int(width)
        except (TypeError, ValueError):
            requested = DEFAULT_INSPECTOR_WIDTH
        bounded = max(MIN_INSPECTOR_WIDTH, min(MAX_INSPECTOR_WIDTH, requested))
        self.settings.setValue("inspector/width", bounded)
        self.inspectorWidthChanged.emit()
        return bounded

    @Slot(result=int)
    def resetInspectorWidth(self) -> int:
        """Reset the right-side configuration panel width to its default."""
        self.settings.remove("inspector/width")
        self.inspectorWidthChanged.emit()
        return self.inspectorWidth

    @Slot(str, bool)
    def setColumnVisible(self, key: str, visible: bool) -> None:
        """Persist one column visibility choice while preserving custom order."""
        keys = self.source_model.visible_column_keys()
        if visible and key not in keys:
            keys.append(key)
        elif not visible and key in keys and len(keys) > 1:
            keys.remove(key)
        self._apply_visible_columns(keys)

    @Slot(str, int)
    def moveColumn(self, key: str, offset: int) -> None:
        """Move one visible data column by a bounded offset and persist the order."""
        keys = self.source_model.visible_column_keys()
        if key not in keys or offset == 0:
            return
        index = keys.index(key)
        target = max(0, min(len(keys) - 1, index + offset))
        if target == index:
            return
        keys.pop(index)
        keys.insert(target, key)
        self._apply_visible_columns(keys)

    @Slot(str)
    def inspectDevice(self, identity: str) -> None:
        """Select one device as the inspector data source."""
        if identity == self._inspected_identity:
            return
        self._inspected_identity = identity
        self._setting_edits.clear()
        self._emit_web_url_if_changed()
        self.inspectorChanged.emit()

    @Slot(str)
    def toggleSelection(self, identity: str) -> None:
        """Toggle one device checkbox using its stable identity."""
        self.source_model.toggle_selected(identity)

    @Slot(bool)
    def selectAll(self, selected: bool) -> None:
        """Select or clear every retained session device."""
        identities = {record.identity for record in self.source_model.all_records()}
        self.source_model.set_selected_identities(identities, selected)

    @Slot(bool)
    def selectVisible(self, selected: bool) -> None:
        """Select or clear all currently filtered devices."""
        identities = {record.identity for record in self.fleet_model.visible_records()}
        self.source_model.set_selected_identities(identities, selected)

    @Slot()
    def clearFleet(self) -> None:
        """Clear retained devices and cancel queued stats polling requests."""
        self._fleet_generation += 1
        if self._stats_worker is not None:
            self._stats_worker.cancel()
        self.source_model.clear()
        self._inspected_identity = ""
        self._setting_edits.clear()
        self._emit_web_url_if_changed()
        self.inspectorChanged.emit()

    @Slot(str, "QVariant")
    def setSettingValue(self, key: str, value: Any) -> None:
        """Store one inspector edit without mutating cached device settings."""
        record = self._inspected_record()
        if record is None or key not in record.settings:
            return
        self._setting_edits[key] = value
        self.inspectorChanged.emit()

    @Slot()
    def discardSettingChanges(self) -> None:
        """Discard all pending edits for the inspected device."""
        if self._setting_edits:
            self._setting_edits.clear()
            self.inspectorChanged.emit()

    @Slot()
    def applyEditedSettings(self) -> None:
        """Validate and apply dirty settings to the inspected device."""
        record = self._inspected_record()
        if record is None:
            self.toastRequested.emit("info", "Select a device first.")
            return
        changed: dict[str, Any] = {}
        try:
            for key, edited in self._setting_edits.items():
                original = record.settings.get(key)
                converted = self._convert_setting(edited, original)
                if converted != original:
                    changed[key] = converted
        except (TypeError, ValueError) as exc:
            self.toastRequested.emit("error", f"Invalid setting value: {exc}")
            return
        if not changed:
            self.toastRequested.emit("info", "No settings have changed.")
            return
        self._start_settings([record], changed, remember=True)

    @Slot(str)
    def exportSettings(self, file_url: str) -> None:
        """Export inspected settings to an NVS-compatible local CSV file."""
        record = self._inspected_record()
        path = self._local_path(file_url)
        if record is None or not record.settings:
            self.toastRequested.emit("info", "Select a device with loaded settings.")
            return
        if path is None:
            self.toastRequested.emit("error", "Choose a valid local CSV path.")
            return
        if db_settings_to_csv(record.settings, path):
            self.toastRequested.emit("success", f"Settings exported to {path.name}.")
        else:
            self.toastRequested.emit("error", "The settings CSV could not be written.")

    @Slot(str)
    def prepareCsvImport(self, file_url: str) -> None:
        """Parse a local CSV template and expose its exclusion preview."""
        path = self._local_path(file_url)
        parameters = db_settings_from_csv(path) if path else None
        if parameters is None:
            self.toastRequested.emit("error", "The CSV file is malformed or unsupported.")
            return
        self._csv_template = parameters
        self.csvTemplateChanged.emit()
        self.csvTemplateReady.emit()

    @Slot("QVariantList", str)
    def applyCsvTemplate(self, excluded_keys: list[Any], scope: str) -> None:
        """Apply imported settings after QML exclusion selection."""
        records = self._target_records(scope)
        if not records:
            self.toastRequested.emit("info", "No target devices are available.")
            return
        excluded = {str(key) for key in excluded_keys}
        settings = {
            key: value
            for key, value in self._csv_template.items()
            if key not in excluded
        }
        if not settings:
            self.toastRequested.emit("info", "All template parameters are excluded.")
            return
        self._start_settings(records, settings, remember=True)

    @Slot(str, result="QVariantList")
    def defaultCsvExclusions(self, scope: str) -> list[str]:
        """Return unique-device exclusions for a multi-device target scope."""
        if len(self._target_records(scope)) <= 1:
            return []
        return [
            key
            for key in sorted(DEFAULT_BULK_EXCLUSIONS)
            if key in self._csv_template
        ]

    @Slot(str, str, str)
    def startActivation(self, token: str, scope: str, license_type: str) -> None:
        """Start sequential permanent or evaluation activation."""
        records = self._target_records(scope)
        active_token = token.strip() or os.environ.get("DRONEBRIDGE_SECRET_TOKEN", "")
        if not active_token:
            self.toastRequested.emit("error", "A license server token is required.")
            return
        if not records:
            self.toastRequested.emit("info", "No target devices are available.")
            return
        enum_value = (
            DBLicenseType.EVALUATION
            if license_type.lower() == "evaluation"
            else DBLicenseType.ACTIVATED
        )
        self._launch_activation(records, active_token, enum_value, remember=True)

    @Slot(str, str)
    def startReboot(self, scope: str, method: str) -> None:
        """Start bounded REST reboot or an explicit all-online MAVLink broadcast."""
        mavlink = method.lower() == "mavlink"
        records = self._target_records("visible" if mavlink else scope)
        if mavlink:
            records = [record for record in records if record.online]
        if not records:
            self.toastRequested.emit("info", "No target devices are available.")
            return
        self._launch_reboot(records, mavlink=mavlink, remember=not mavlink)

    @Slot(str, str, str, str, int, str)
    def startOta(
        self,
        release_url: str,
        www_url: str,
        firmware_url: str,
        target_version: str,
        workers: int,
        scope: str,
    ) -> None:
        """Validate local OTA inputs and start bounded parallel updates."""
        records = self._target_records(scope)
        if not records:
            self.toastRequested.emit("info", "Select at least one target device.")
            return
        release = self._local_path(release_url)
        www = self._local_path(www_url)
        firmware = self._local_path(firmware_url)
        valid_release = bool(
            release
            and release.is_dir()
            and db_check_release_binaries_present(str(release))
        )
        valid_custom = bool(www and www.is_file() and firmware and firmware.is_file())
        if not (valid_release or valid_custom):
            self.toastRequested.emit(
                "error",
                "Choose a valid release folder or both OTA binary files.",
            )
            return
        self._launch_ota(
            records,
            release if valid_release else None,
            www if not valid_release else None,
            firmware if not valid_release else None,
            max(1, min(workers, 64)),
            target_version,
            remember=True,
        )

    @Slot(str)
    def refreshOtaReleases(self, token: str) -> None:
        """
        Refresh cached and account release choices for the OTA dialog.

        :param token: Optional session-only token. Empty values still list
            cached releases from the local release cache.
        :return: None. Results update ``otaReleases`` asynchronously.
        """
        if self._ota_release_refresh_running:
            return
        self._ota_release_refresh_running = True
        self._ota_release_status = "Loading releases..."
        self.otaReleasesChanged.emit()
        active_token = token.strip() or os.environ.get("DRONEBRIDGE_SECRET_TOKEN", "")
        worker = OtaReleaseListWorker(active_token)
        worker.signals.finished.connect(self._ota_releases_loaded)
        worker.signals.error.connect(self._ota_releases_failed)
        self.pool.start(worker)

    @Slot(str, str, str, int, str)
    def startOtaFromRelease(
        self,
        selection_id: str,
        token: str,
        target_version: str,
        workers: int,
        scope: str,
    ) -> None:
        """
        Resolve a cached or online release, then start OTA with its local root.

        :param selection_id: Stable release option id from ``otaReleases``.
        :param token: Optional session-only token used only for online downloads.
        :param target_version: Optional exact current firmware version filter.
        :param workers: Requested parallel upload limit, clamped to 1 through 64.
        :param scope: ``selected`` or ``visible`` target scope.
        :return: None. Device queuing starts only after release validation passes.
        """
        records = self._target_records(scope)
        if not records:
            self.toastRequested.emit("info", "Select at least one target device.")
            return
        option = self._ota_release_lookup.get(selection_id)
        if option is None:
            self.toastRequested.emit("error", "Select a valid DLSE release.")
            return
        if not self._operation_available():
            return

        self._ota_pending_options = {
            "records": records,
            "workers": max(1, min(workers, 64)),
            "target_version": target_version,
        }
        active_token = token.strip() or os.environ.get("DRONEBRIDGE_SECRET_TOKEN", "")
        worker = OtaReleaseResolveWorker(option, active_token)
        self._active_worker = worker
        self._active_operation = "ota release"
        self._active_targets = {record.identity for record in records}
        self._failed_identities.clear()
        self._status_text = "RESOLVING RELEASE..."
        self._ota_release_status = "Resolving selected release..."
        worker.signals.finished.connect(self._ota_release_resolved)
        worker.signals.error.connect(self._ota_release_failed)
        self.stateChanged.emit()
        self.otaReleasesChanged.emit()
        self.pool.start(worker)

    @Slot()
    def cancelActiveOperation(self) -> None:
        """Cancel queued work while allowing active transfers to finish."""
        cancel = getattr(self._active_worker, "cancel", None)
        if callable(cancel):
            cancel()
            self._status_text = "CANCELLING QUEUED WORK..."
            self.stateChanged.emit()

    @Slot()
    def retryFailed(self) -> None:
        """Retry the last retryable operation for failed devices only."""
        if not self._retry_context or not self._failed_identities:
            self.toastRequested.emit("info", "There are no failed devices to retry.")
            return
        kind, options = self._retry_context
        records = [
            record
            for record in self.source_model.all_records()
            if record.identity in self._failed_identities
        ]
        if not records:
            self.toastRequested.emit("info", "Failed devices are no longer available.")
            return
        if kind == "activation":
            self._launch_activation(records, options["token"], options["license_type"], False)
        elif kind == "ota":
            self._launch_ota(records, remember=False, **options)
        elif kind == "settings":
            self._start_settings(records, options["settings"], remember=False)
        elif kind == "reboot":
            self._launch_reboot(records, mavlink=False, remember=False)

    @Slot()
    def checkLicenseServer(self) -> None:
        """Start a ten-second non-overlapping license-server check."""
        if self._license_check_running:
            return
        self._license_check_running = True
        self._license_status = "checking"
        self.stateChanged.emit()
        worker = LicenseStatusWorker()
        worker.signals.finished.connect(self._license_checked)
        worker.signals.error.connect(self._license_failed)
        self.pool.start(worker)

    @Slot(object)
    def _ota_releases_loaded(self, payload: Any) -> None:
        """
        Store release choices returned by the release listing worker.

        :param payload: Mapping containing ``options`` and ``status``.
        :return: None. Malformed payloads are treated as an empty release list.
        """
        self._ota_release_refresh_running = False
        options = []
        if isinstance(payload, dict) and isinstance(payload.get("options"), list):
            options = [
                option
                for option in payload["options"]
                if isinstance(option, dict) and option.get("id")
            ]
        self._ota_releases = options
        self._ota_release_lookup = {
            str(option["id"]): option
            for option in options
        }
        status = str(payload.get("status") or "") if isinstance(payload, dict) else ""
        self._ota_release_status = status or f"{len(options)} releases available"
        if not options:
            self._ota_release_status = f"{self._ota_release_status}; no valid releases found"
        self.otaReleasesChanged.emit()

    @Slot(str)
    def _ota_releases_failed(self, message: str) -> None:
        """
        Recover from a failed release-list refresh without changing old choices.

        :param message: Failure detail to sanitize before display.
        :return: None.
        """
        self._ota_release_refresh_running = False
        self._ota_release_status = "Release refresh failed"
        self.otaReleasesChanged.emit()
        self.toastRequested.emit("error", self._sanitize_error(message))

    @Slot(object)
    def _ota_release_resolved(self, payload: Any) -> None:
        """
        Launch OTA after release preflight produced a validated local root.

        :param payload: Mapping containing the resolved ``release_path``.
        :return: None. Missing pending state or paths abort without queuing.
        """
        pending = self._ota_pending_options
        self._ota_pending_options = None
        self._active_worker = None
        self._active_operation = ""
        self._active_targets.clear()
        self._status_text = "SCANNING..." if self._scanning_enabled else "IDLE"
        if not pending or not isinstance(payload, dict) or not payload.get("release_path"):
            self.stateChanged.emit()
            self.toastRequested.emit("error", "Release preflight did not return a valid folder.")
            return
        release_path = Path(str(payload["release_path"]))
        self._ota_release_status = f"Using {release_path}"
        self.otaReleasesChanged.emit()
        self.stateChanged.emit()
        self._launch_ota(
            pending["records"],
            release_path,
            None,
            None,
            pending["workers"],
            pending["target_version"],
            remember=True,
        )

    @Slot(str)
    def _ota_release_failed(self, message: str) -> None:
        """
        Recover from a failed release preflight without starting OTA uploads.

        :param message: Failure detail to sanitize before display.
        :return: None. Target device operation labels are left untouched.
        """
        self._ota_pending_options = None
        self._active_worker = None
        self._active_operation = ""
        self._active_targets.clear()
        self._status_text = "ERROR"
        self._ota_release_status = "Release preflight failed"
        self.stateChanged.emit()
        self.otaReleasesChanged.emit()
        self.resultReady.emit("OTA Firmware Upgrade", self._sanitize_error(message), False)

    def _launch_activation(
        self,
        records: list[DeviceRecord],
        token: str,
        license_type: DBLicenseType,
        remember: bool,
    ) -> None:
        """Create and launch a sequential activation worker."""
        if not self._operation_available():
            return
        for record in records:
            self.source_model.update_operation(record.identity, "queued", 0)
        worker = ActivationWorker(records, token, license_type)
        if remember:
            self._retry_context = (
                "activation",
                {"token": token, "license_type": license_type},
            )
        self._begin_worker("activation", worker)

    def _launch_reboot(
        self,
        records: list[DeviceRecord],
        mavlink: bool,
        remember: bool,
    ) -> None:
        """Create and launch a REST or MAVLink reboot worker."""
        if not self._operation_available():
            return
        values = self._scan_values()
        for record in records:
            self.source_model.update_operation(record.identity, "rebooting", 0)
        worker = RebootWorker(
            records,
            workers=values["workers"],
            mavlink_subnet=values["subnet"] if mavlink else None,
            mavlink_port=values["esp32_port"],
        )
        if remember:
            self._retry_context = ("reboot", {})
        self._begin_worker("reboot", worker)

    def _launch_ota(
        self,
        records: list[DeviceRecord],
        release_path: Path | None,
        www_path: Path | None,
        firmware_path: Path | None,
        workers: int,
        target_version: str,
        remember: bool,
    ) -> None:
        """Create and launch a bounded OTA worker."""
        if not self._operation_available():
            return
        for record in records:
            self.source_model.update_operation(record.identity, "queued", 0)
        options = {
            "release_path": release_path,
            "www_path": www_path,
            "firmware_path": firmware_path,
            "workers": workers,
            "target_version": target_version,
        }
        worker = OtaWorker(records, **options)
        if remember:
            self._retry_context = ("ota", options)
        self._begin_worker("ota", worker)

    def _start_settings(
        self,
        records: list[DeviceRecord],
        settings: dict[str, Any],
        remember: bool,
    ) -> None:
        """Validate and launch a bounded settings worker."""
        error = self._validate_settings(settings)
        if error:
            self.toastRequested.emit("error", error)
            return
        if not self._operation_available():
            return
        for record in records:
            self.source_model.update_operation(record.identity, "applying settings", 0)
        worker = SettingsWorker(records, settings, self._scan_values()["workers"])
        if remember:
            self._retry_context = ("settings", {"settings": settings})
        self._begin_worker("settings", worker)

    def _begin_worker(self, kind: str, worker: Any) -> None:
        """Connect common worker signals and start one fleet operation."""
        self._active_worker = worker
        self._active_operation = kind
        self._active_targets = {
            record.identity for record in getattr(worker, "records", [])
        }
        self._failed_identities.clear()
        self._status_text = kind.upper()
        worker.signals.progress.connect(self._operation_progress)
        worker.signals.finished.connect(
            lambda results, operation=kind: self._operation_finished(operation, results)
        )
        worker.signals.error.connect(self._operation_failed)
        self.stateChanged.emit()
        self.pool.start(worker)

    def _operation_available(self) -> bool:
        """Reject overlapping destructive fleet operations."""
        if self._active_worker is not None:
            self.toastRequested.emit(
                "warning",
                f"Wait for the active {self._active_operation} operation to finish.",
            )
            return False
        return True

    @Slot(object)
    def _scan_finished(self, records: list[DeviceRecord]) -> None:
        """Merge one additive discovery cycle without changing device health."""
        self._scan_running = False
        self._discovery_status = (
            "WAITING" if self._scanning_enabled else "STOPPED"
        )
        self.source_model.upsert_many(records)
        self._status_text = "SCANNING..." if self._scanning_enabled else "IDLE"
        self.stateChanged.emit()
        self.startStatsPolling()

    @Slot(object)
    def _scan_progress(self, payload: Any) -> None:
        """Merge hydrated devices incrementally during discovery."""
        if isinstance(payload, DeviceRecord):
            self.source_model.upsert_many([payload])
            self.startStatsPolling()

    @Slot(str)
    def _scan_failed(self, message: str) -> None:
        """Recover from one discovery worker failure."""
        self._scan_running = False
        self._discovery_status = "ERROR"
        self._status_text = "SCAN ERROR"
        self.stateChanged.emit()
        self.toastRequested.emit("error", self._sanitize_error(message))

    def _stats_progress(self, payload: Any, generation: int) -> None:
        """
        Apply one incremental stats result when it belongs to this fleet.

        :param payload: Worker result containing identity, IP, status, and stats.
        :param generation: Fleet generation captured when the round started.
        :return: None. Stale or unresolvable results are ignored safely.
        """
        if generation != self._fleet_generation or not isinstance(payload, dict):
            return
        identity = str(payload.get("identity") or "")
        if self.source_model.record_by_identity(identity) is None:
            identity = self._identity_for_ip(str(payload.get("ip") or ""))
        if not identity:
            return
        self.source_model.apply_stats_result(
            identity,
            bool(payload.get("success")),
            payload.get("stats") if isinstance(payload.get("stats"), dict) else None,
            self._sanitize_error(str(payload.get("error") or "Stats request failed")),
            self._scan_values()["stats_failure_threshold"],
        )

    def _stats_finished(self, _results: Any, _generation: int) -> None:
        """
        Release the overlap guard and schedule the next stats round.

        :param _results: Completed per-device results; updates were already emitted.
        :param _generation: Fleet generation retained for signal compatibility.
        :return: None.
        """
        if _generation != self._fleet_generation:
            return
        self._stats_poll_running = False
        self._stats_worker = None
        self._stats_polling_status = "WAITING"
        self._schedule_next_stats_round()
        self.stateChanged.emit()

    def _stats_failed(self, message: str, generation: int) -> None:
        """
        Recover from an unexpected worker-level polling failure.

        :param message: Failure detail to sanitize for the UI.
        :param generation: Fleet generation that produced the failure.
        :return: None. Stale failures are rescheduled without displaying a toast.
        """
        if generation != self._fleet_generation:
            return
        self._stats_poll_running = False
        self._stats_worker = None
        self._stats_polling_status = "ERROR"
        self._schedule_next_stats_round()
        self.stateChanged.emit()
        self.toastRequested.emit("error", self._sanitize_error(message))

    def _schedule_next_stats_round(self) -> None:
        """
        Schedule the next round at least two seconds after the prior start.

        :return: None. Long rounds restart immediately instead of overlapping.
        """
        values = self._scan_values()
        if not values["stats_enabled"]:
            self.stats_timer.stop()
            return
        elapsed = monotonic() - self._stats_round_started_at
        delay_ms = max(
            0,
            math.ceil((values["stats_interval"] - elapsed) * 1000),
        )
        self.stats_timer.start(delay_ms)

    @Slot(object)
    def _operation_progress(self, payload: dict[str, Any]) -> None:
        """Apply generic worker progress to the matching inventory record."""
        identity = str(payload.get("identity") or "")
        status = str(payload.get("status") or "")
        result = payload.get("result")
        if not identity and result is not None:
            identity = self._identity_for_ip(str(getattr(result, "device_ip", "")))
        if isinstance(result, dict):
            success = result.get("success")
            result_message = str(result.get("message") or status)
        else:
            success = getattr(result, "success", payload.get("success"))
            result_message = str(
                getattr(result, "message", payload.get("message") or status)
            )
        percent = int(
            payload.get(
                "percent",
                100 if success or status in {"activated", "already_activated", "complete"} else 0,
            )
        )
        if identity:
            if success is False:
                status = f"failed: {result_message}"
                self._failed_identities.add(identity)
            self.source_model.update_operation(identity, status, percent)

    def _operation_finished(self, kind: str, results: Any) -> None:
        """Summarize results, update reboot grace, and notify QML."""
        items = results if isinstance(results, list) else [results]
        successes = 0
        failed: set[str] = set(self._failed_identities)
        for item in items:
            success = self._result_success(item)
            successes += int(success)
            identity = self._result_identity(item)
            if identity and not success:
                failed.add(identity)
            if identity and success:
                label = "reboot accepted" if kind == "reboot" else "complete"
                self.source_model.update_operation(identity, label, 100)
        if kind == "reboot" and isinstance(results, dict) and results.get("mavlink"):
            visible_records = [
                record
                for record in self.fleet_model.visible_records()
                if record.identity in self._active_targets
            ]
            command_success = bool(results.get("success"))
            successes = len(visible_records) if command_success else 0
            items = [results] * max(1, successes or int(results.get("count", 1)))
            for record in visible_records:
                self.source_model.update_operation(
                    record.identity,
                    "MAVLink command sent" if command_success else "MAVLink command failed",
                    100 if command_success else 0,
                )
        if kind == "reboot" and successes:
            successful_ids = {
                self._result_identity(item)
                for item in items
                if self._result_success(item) and self._result_identity(item)
            }
            if not successful_ids and isinstance(results, dict) and results.get("mavlink"):
                successful_ids = set(self._active_targets)
            self.source_model.set_reboot_grace(successful_ids, 20)
        self._failed_identities = failed
        total = len(items)
        failures = max(0, total - successes)
        self._active_worker = None
        self._active_operation = ""
        self._active_targets.clear()
        self._status_text = "SCANNING..." if self._scanning_enabled else "IDLE"
        if kind == "settings" and not failures:
            self._setting_edits.clear()
            self.inspectorChanged.emit()
        self.stateChanged.emit()
        self.resultReady.emit(
            kind.replace("_", " ").title(),
            f"Operation finished: {successes} succeeded, {failures} failed.",
            bool(failures and self._retry_context),
        )

    @Slot(str)
    def _operation_failed(self, message: str) -> None:
        """Recover from an unhandled worker-level operation failure."""
        title = self._active_operation.replace("_", " ").title() or "Operation"
        self._active_worker = None
        self._active_operation = ""
        self._active_targets.clear()
        self._status_text = "ERROR"
        self.stateChanged.emit()
        self.resultReady.emit(title, self._sanitize_error(message), False)

    @Slot(object)
    def _license_checked(self, online: bool) -> None:
        """Update license-server state after a successful check."""
        self._license_check_running = False
        self._license_status = "online" if online else "offline"
        self.stateChanged.emit()

    @Slot(str)
    def _license_failed(self, _message: str) -> None:
        """Treat license-server worker failures as offline state."""
        self._license_check_running = False
        self._license_status = "offline"
        self.stateChanged.emit()

    @Slot()
    def _inventory_changed(self) -> None:
        """Refresh aggregate and inspector QML properties."""
        if self._inspected_identity and not self._inspected_record():
            self._inspected_identity = ""
            self._setting_edits.clear()
        self.stateChanged.emit()
        self._emit_web_url_if_changed()
        self.inspectorChanged.emit()

    def _emit_web_url_if_changed(self) -> None:
        """
        Notify QML only when the selected device web URL actually changes.

        :return: None. Routine stats updates keep the existing WebEngine page
            loaded unless they change the selected device's online state or IP.
        """
        current_url = self.webUrl
        if current_url == self._last_web_url:
            return
        self._last_web_url = current_url
        self.webUrlChanged.emit()

    def _target_records(self, scope: str) -> list[DeviceRecord]:
        """Resolve selected, visible, or selected-then-visible operation scope."""
        selected = self.source_model.selected_records()
        visible = self.fleet_model.visible_records()
        if scope == "selected":
            return selected
        if scope == "visible":
            return visible
        return selected or visible

    def _inspected_record(self) -> DeviceRecord | None:
        """Return the record currently shown in the inspector."""
        return self.source_model.record_by_identity(self._inspected_identity)

    def _identity_for_ip(self, device_ip: str) -> str:
        """Resolve a worker result IP back to a stable inventory identity."""
        return next(
            (
                record.identity
                for record in self.source_model.all_records()
                if record.ip == device_ip
            ),
            "",
        )

    def _result_identity(self, item: Any) -> str:
        """Extract a stable identity from any supported worker result shape."""
        if isinstance(item, dict):
            if item.get("identity"):
                return str(item["identity"])
            result = item.get("result")
            if result is not None:
                return self._identity_for_ip(str(getattr(result, "device_ip", "")))
            return ""
        return self._identity_for_ip(str(getattr(item, "device_ip", "")))

    @staticmethod
    def _result_success(item: Any) -> bool:
        """Return success from a structured object or worker result mapping."""
        if isinstance(item, dict):
            result = item.get("result")
            return bool(item.get("success", getattr(result, "success", False)))
        return bool(getattr(item, "success", False))

    def _scan_values(self) -> dict[str, Any]:
        """Return persisted discovery settings with bounded defaults."""
        return {
            "subnet": str(self.settings.value("scan/subnet", "192.168.1.0/24")),
            "mavlink": self.settings.value("scan/mavlink", True, bool),
            "http": self.settings.value("scan/http", True, bool),
            "esp32_port": int(self.settings.value("scan/esp32_port", 14555)),
            "local_port": int(self.settings.value("scan/local_port", 14550)),
            "interval": max(
                5,
                min(int(self.settings.value("scan/interval", 5)), 3600),
            ),
            "http_timeout": max(
                0.1,
                min(
                    float(self.settings.value("scan/http_timeout", 1.0)),
                    30.0,
                ),
            ),
            "workers": max(
                1,
                min(int(self.settings.value("scan/workers", 20)), 64),
            ),
            "stats_enabled": self.settings.value(
                "scan/stats_enabled",
                True,
                bool,
            ),
            "stats_interval": max(
                1,
                min(
                    int(self.settings.value("scan/stats_interval", 2)),
                    3600,
                ),
            ),
            "stats_timeout": max(
                0.1,
                min(
                    float(self.settings.value("scan/stats_timeout", 1.0)),
                    30.0,
                ),
            ),
            "stats_workers": max(
                1,
                min(
                    int(self.settings.value("scan/stats_workers", 20)),
                    64,
                ),
            ),
            "stats_failure_threshold": max(
                1,
                min(
                    int(
                        self.settings.value(
                            "scan/stats_failure_threshold",
                            3,
                        )
                    ),
                    20,
                ),
            ),
        }

    def _restart_scan_timer(self) -> None:
        """Apply the persisted rolling refresh interval."""
        self.scan_timer.start(max(5, self._scan_values()["interval"]) * 1000)

    def _restore_columns(self) -> None:
        """Restore persisted column keys or the required defaults."""
        stored = str(self.settings.value("columns/visible", "")).strip()
        keys = [key for key in stored.split(",") if key] if stored else []
        self.source_model.set_visible_columns(
            keys or list(DeviceTableModel.DEFAULT_COLUMN_KEYS)
        )

    def _apply_visible_columns(self, keys: list[str]) -> None:
        """Apply and persist ordered data-column keys for the fleet table."""
        self.source_model.set_visible_columns(keys)
        self.settings.setValue(
            "columns/visible",
            ",".join(self.source_model.visible_column_keys()),
        )
        self.columnsChanged.emit()

    def _column_width_for_key(self, key: str) -> int:
        """Return a clamped persisted width for one stable table column key."""
        default_width = self._default_column_width(key)
        if key == "selected":
            return default_width
        try:
            stored = int(self.settings.value(f"columns/width/{key}", default_width))
        except (TypeError, ValueError):
            stored = default_width
        return max(MIN_COLUMN_WIDTH, min(MAX_COLUMN_WIDTH, stored))

    @staticmethod
    def _default_column_width(key: str) -> int:
        """Return the built-in width for a stable table column key."""
        if key == "selected":
            return 54
        definition = DeviceTableModel.column_definition(key)
        return definition[2] if definition else 100

    def _inspector_width(self) -> int:
        """Return a clamped persisted width for the configuration panel."""
        try:
            stored = int(self.settings.value("inspector/width", DEFAULT_INSPECTOR_WIDTH))
        except (TypeError, ValueError):
            stored = DEFAULT_INSPECTOR_WIDTH
        return max(MIN_INSPECTOR_WIDTH, min(MAX_INSPECTOR_WIDTH, stored))

    @staticmethod
    def _local_path(file_url: str) -> Path | None:
        """Convert a QML file URL or local path without accepting remote URLs."""
        if not file_url:
            return None
        url = QUrl(file_url)
        if url.isLocalFile():
            return Path(url.toLocalFile()).expanduser()
        if url.scheme():
            return None
        return Path(file_url).expanduser()

    @staticmethod
    def _editor_type(key: str, value: Any) -> str:
        """Choose a QML editor from value type and high-risk field semantics."""
        lowered = key.lower()
        if "pass" in lowered or "secret" in lowered or "token" in lowered:
            return "password"
        if lowered in {
            "ip_sta",
            "ip_sta_gw",
            "ip_sta_netmsk",
            "ap_ip",
            "udp_client_ip",
        }:
            return "ip"
        if lowered.endswith("_port"):
            return "port"
        if isinstance(value, bool):
            return "boolean"
        if isinstance(value, int):
            return "integer"
        if isinstance(value, float):
            return "number"
        return "text"

    @staticmethod
    def _convert_setting(value: Any, original: Any) -> Any:
        """Convert a QML editor value to the original REST value type."""
        if isinstance(original, bool):
            if isinstance(value, bool):
                return value
            return str(value).strip().lower() in {"1", "true", "yes", "on"}
        if isinstance(original, int):
            return int(value)
        if isinstance(original, float):
            return float(value)
        return str(value)

    @staticmethod
    def _validate_settings(settings: dict[str, Any]) -> str | None:
        """Validate risky network fields, passwords, and payload size."""
        for key in ("ip_sta", "ip_sta_gw", "ap_ip", "udp_client_ip"):
            value = settings.get(key)
            if value:
                try:
                    ipaddress.ip_address(str(value))
                except ValueError:
                    return f"{key} is not a valid IP address."
        netmask = settings.get("ip_sta_netmsk")
        if netmask:
            try:
                ipaddress.IPv4Network(f"0.0.0.0/{netmask}")
            except ValueError:
                return "ip_sta_netmsk is not a valid IPv4 subnet mask."
        for key, value in settings.items():
            if key.lower().endswith("_port") and not 0 <= int(value) <= 65535:
                return f"{key} must be between 0 and 65535."
        for key in ("wifi_pass", "wifi_pass_ap"):
            if key in settings and settings[key] and not 7 <= len(str(settings[key])) <= 64:
                return f"{key} must contain 7 to 64 characters."
        try:
            if len(json.dumps(settings).encode("utf-8")) >= 10240:
                return "Settings payload exceeds the 10,240 byte device limit."
        except (TypeError, ValueError) as exc:
            return f"Settings are not serializable: {exc}"
        return None

    def _sanitize_error(self, message: str) -> str:
        """Remove session tokens and activation keys from diagnostic messages."""
        sanitized = str(message)
        secrets = [os.environ.get("DRONEBRIDGE_SECRET_TOKEN", "")]
        secrets.extend(
            record.activation_key
            for record in self.source_model.all_records()
            if record.activation_key
        )
        for secret in secrets:
            if secret:
                sanitized = sanitized.replace(secret, self._mask(secret))
        return sanitized

    @staticmethod
    def _mask(value: str) -> str:
        """Return a short masked representation for log-style diagnostics."""
        if len(value) <= 6:
            return "*" * len(value)
        return f"{value[:3]}{'*' * (len(value) - 6)}{value[-3:]}"

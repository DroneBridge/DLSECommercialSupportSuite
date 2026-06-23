"""Fleet inventory models exposed to the Qt Quick user interface."""

from __future__ import annotations

import ipaddress
from dataclasses import dataclass, field
from datetime import datetime, timedelta
from typing import Any

from PySide6.QtCore import (
    QAbstractListModel,
    QAbstractTableModel,
    QModelIndex,
    QSortFilterProxyModel,
    Qt,
    Signal,
    Slot,
)


@dataclass
class DeviceRecord:
    """Store session-scoped state for one discovered DLSE ESP32."""

    identity: str
    ip: str
    hostname: str = ""
    activation_status: str = "discovered"
    firmware_version: str = ""
    dronebridge_version: str = ""
    mavlink_sys_id: str = ""
    fc_sys_id: str = ""
    wifi_ssid: str = ""
    wifi_channel: str = ""
    rssi: str = ""
    battery_voltage: str = ""
    activation_key: str = ""
    mac: str = ""
    sources: set[str] = field(default_factory=set)
    last_seen: datetime = field(default_factory=datetime.now)
    consecutive_stats_failures: int = 0
    offline_grace_until: datetime | None = None
    online: bool = True
    selected: bool = False
    operation: str = ""
    operation_progress: int = 0
    system_info: dict[str, Any] = field(default_factory=dict)
    settings: dict[str, Any] = field(default_factory=dict)
    stats: dict[str, Any] = field(default_factory=dict)
    errors: dict[str, str] = field(default_factory=dict)

    @property
    def source(self) -> str:
        """Return a stable display string for all discovery sources."""
        return ", ".join(sorted(self.sources))

    @property
    def searchable_text(self) -> str:
        """Return searchable content covering all REST and inventory fields."""
        values = [
            self.identity,
            self.ip,
            self.hostname,
            self.activation_status,
            self.firmware_version,
            self.dronebridge_version,
            self.mavlink_sys_id,
            self.fc_sys_id,
            self.wifi_ssid,
            self.wifi_channel,
            self.rssi,
            self.battery_voltage,
            self.activation_key,
            self.mac,
            self.source,
            self.operation,
            self.system_info,
            self.settings,
            self.stats,
        ]
        return " ".join(str(value) for value in values).lower()


class DeviceTableModel(QAbstractTableModel):
    """Incremental table model suitable for inventories of at least 5,000 devices."""

    inventoryChanged = Signal()
    selectionChanged = Signal()

    COLUMNS = [
        ("hostname", "HOSTNAME", 112),
        ("ip", "IP", 112),
        ("activation_status", "ACTIVATION STATUS", 138),
        ("firmware_version", "DLSE FIRMWARE", 132),
        ("dronebridge_version", "BUILD VERSION", 116),
        ("mavlink_sys_id", "MAVLINK SYS ID", 116),
        ("wifi_ssid", "WIFI SSID", 120),
        ("wifi_channel", "CHANNEL", 82),
        ("rssi", "RSSI", 76),
        ("activation_key", "ACTIVATION KEY", 210),
        ("mac", "MAC", 138),
        ("online", "ONLINE", 86),
        ("operation", "OPERATION", 150),
        ("operation_progress", "PROGRESS", 106),
    ]
    DEFAULT_COLUMN_KEYS = tuple(column[0] for column in COLUMNS[:9])

    IdentityRole = Qt.UserRole + 1
    IpRole = Qt.UserRole + 2
    HostnameRole = Qt.UserRole + 3
    ActivationStatusRole = Qt.UserRole + 4
    FirmwareVersionRole = Qt.UserRole + 5
    DronebridgeVersionRole = Qt.UserRole + 6
    MavlinkSysIdRole = Qt.UserRole + 7
    FcSysIdRole = Qt.UserRole + 8
    WifiSsidRole = Qt.UserRole + 9
    WifiChannelRole = Qt.UserRole + 10
    RssiRole = Qt.UserRole + 11
    BatteryVoltageRole = Qt.UserRole + 12
    ActivationKeyRole = Qt.UserRole + 13
    MacRole = Qt.UserRole + 14
    SourceRole = Qt.UserRole + 15
    LastSeenRole = Qt.UserRole + 16
    OnlineRole = Qt.UserRole + 17
    SelectedRole = Qt.UserRole + 18
    OperationRole = Qt.UserRole + 19
    OperationProgressRole = Qt.UserRole + 20
    SystemInfoRole = Qt.UserRole + 21
    SettingsRole = Qt.UserRole + 22
    StatsRole = Qt.UserRole + 23
    ErrorsRole = Qt.UserRole + 24
    ColumnKeyRole = Qt.UserRole + 25

    _ROLE_ATTRIBUTES = {
        IdentityRole: "identity",
        IpRole: "ip",
        HostnameRole: "hostname",
        ActivationStatusRole: "activation_status",
        FirmwareVersionRole: "firmware_version",
        DronebridgeVersionRole: "dronebridge_version",
        MavlinkSysIdRole: "mavlink_sys_id",
        FcSysIdRole: "fc_sys_id",
        WifiSsidRole: "wifi_ssid",
        WifiChannelRole: "wifi_channel",
        RssiRole: "rssi",
        BatteryVoltageRole: "battery_voltage",
        ActivationKeyRole: "activation_key",
        MacRole: "mac",
        OnlineRole: "online",
        SelectedRole: "selected",
        OperationRole: "operation",
        OperationProgressRole: "operation_progress",
        SystemInfoRole: "system_info",
        SettingsRole: "settings",
        StatsRole: "stats",
        ErrorsRole: "errors",
    }

    def __init__(self) -> None:
        """Create an empty inventory with the required default columns."""
        super().__init__()
        self._records: dict[str, DeviceRecord] = {}
        self._order: list[str] = []
        self._visible_columns = list(self.DEFAULT_COLUMN_KEYS)

    def roleNames(self) -> dict[int, bytes]:
        """Expose stable role names to QML table and card delegates."""
        return {
            Qt.DisplayRole: b"display",
            self.IdentityRole: b"identity",
            self.IpRole: b"ip",
            self.HostnameRole: b"hostname",
            self.ActivationStatusRole: b"activationStatus",
            self.FirmwareVersionRole: b"firmwareVersion",
            self.DronebridgeVersionRole: b"dronebridgeVersion",
            self.MavlinkSysIdRole: b"mavlinkSysId",
            self.FcSysIdRole: b"fcSysId",
            self.WifiSsidRole: b"wifiSsid",
            self.WifiChannelRole: b"wifiChannel",
            self.RssiRole: b"rssi",
            self.BatteryVoltageRole: b"batteryVoltage",
            self.ActivationKeyRole: b"activationKey",
            self.MacRole: b"mac",
            self.SourceRole: b"source",
            self.LastSeenRole: b"lastSeen",
            self.OnlineRole: b"online",
            self.SelectedRole: b"selected",
            self.OperationRole: b"operation",
            self.OperationProgressRole: b"operationProgress",
            self.SystemInfoRole: b"systemInfo",
            self.SettingsRole: b"settings",
            self.StatsRole: b"stats",
            self.ErrorsRole: b"errors",
            self.ColumnKeyRole: b"columnKey",
        }

    def rowCount(self, parent: QModelIndex = QModelIndex()) -> int:
        """Return the inventory row count."""
        return 0 if parent.isValid() else len(self._order)

    def columnCount(self, parent: QModelIndex = QModelIndex()) -> int:
        """Return selection plus the configured visible data columns."""
        return 0 if parent.isValid() else len(self._visible_columns) + 1

    def data(self, index: QModelIndex, role: int = Qt.DisplayRole) -> Any:
        """Return cell values and complete record roles for QML delegates."""
        record = self.record_at(index.row()) if index.isValid() else None
        if record is None:
            return None
        column_key = self.column_key(index.column())
        if role in (Qt.DisplayRole, Qt.EditRole):
            return self._display_value(record, column_key)
        if role == self.ColumnKeyRole:
            return column_key
        if role == self.SourceRole:
            return record.source
        if role == self.LastSeenRole:
            return record.last_seen.isoformat(timespec="seconds")
        attribute = self._ROLE_ATTRIBUTES.get(role)
        return getattr(record, attribute) if attribute else None

    def headerData(
        self,
        section: int,
        orientation: Qt.Orientation,
        role: int = Qt.DisplayRole,
    ) -> Any:
        """Return configured fleet column labels and row numbers."""
        if role != Qt.DisplayRole:
            return None
        if orientation == Qt.Vertical:
            return section + 1
        key = self.column_key(section)
        if key == "selected":
            return "SEL"
        column = self.column_definition(key)
        return column[1] if column else ""

    def flags(self, index: QModelIndex) -> Qt.ItemFlag:
        """Return read-only enabled flags for valid cells."""
        return Qt.ItemIsEnabled if index.isValid() else Qt.NoItemFlags

    def column_key(self, column: int) -> str:
        """Return the stable key represented by a visible table column."""
        if column == 0:
            return "selected"
        offset = column - 1
        return self._visible_columns[offset] if 0 <= offset < len(self._visible_columns) else ""

    @classmethod
    def column_definition(cls, key: str) -> tuple[str, str, int] | None:
        """Return metadata for a stable column key."""
        return next((column for column in cls.COLUMNS if column[0] == key), None)

    def column_width(self, column: int) -> int:
        """Return the preferred QML width for one visible column."""
        key = self.column_key(column)
        if key == "selected":
            return 54
        definition = self.column_definition(key)
        return definition[2] if definition else 100

    def visible_column_keys(self) -> list[str]:
        """Return the active data-column keys, excluding selection."""
        return list(self._visible_columns)

    def set_visible_columns(self, keys: list[str]) -> None:
        """Apply a validated ordered visible-column projection and reset the table."""
        valid_keys = {column[0] for column in self.COLUMNS}
        normalized = []
        for key in keys:
            if key in valid_keys and key not in normalized:
                normalized.append(key)
        if not normalized:
            normalized = list(self.DEFAULT_COLUMN_KEYS)
        if normalized == self._visible_columns:
            return
        self.beginResetModel()
        self._visible_columns = normalized
        self.endResetModel()

    def upsert_many(self, records: list[DeviceRecord]) -> None:
        """Merge discovered records and emit one efficient model reset."""
        if not records:
            return
        self.beginResetModel()
        for incoming in records:
            identity = self._find_identity(incoming)
            existing = self._records.get(identity) if identity else None
            if existing:
                old_identity = existing.identity
                self._merge(existing, incoming)
                new_identity = preferred_identity(existing)
                existing.identity = new_identity
                if old_identity != new_identity:
                    self._records.pop(old_identity, None)
                self._records[new_identity] = existing
            else:
                incoming.identity = preferred_identity(incoming)
                self._records[incoming.identity] = incoming
        self._order = sorted(
            self._records,
            key=lambda key: _ip_sort_key(self._records[key].ip),
        )
        self.endResetModel()
        self.inventoryChanged.emit()

    def apply_stats_result(
        self,
        identity: str,
        success: bool,
        stats: dict[str, Any] | None = None,
        error: str = "",
        failure_threshold: int = 3,
    ) -> None:
        """
        Apply one stats attempt and update the device's online health.

        :param identity: Stable inventory identity of the polled device.
        :param success: Whether the request returned a valid JSON object.
        :param stats: Latest runtime statistics for a successful request.
        :param error: Sanitized failure detail stored for inspector diagnostics.
        :param failure_threshold: Consecutive counted failures required offline.
        :return: None. Unknown identities are ignored; reaching the configured
            failure threshold marks a device offline while success restores it.
        """
        record = self._records.get(identity)
        if record is None:
            return
        if success and isinstance(stats, dict):
            record.stats = stats
            record.last_seen = datetime.now()
            record.consecutive_stats_failures = 0
            record.offline_grace_until = None
            record.online = True
            record.errors.pop("stats", None)
            if "fc_sys_id" in stats:
                record.fc_sys_id = str(stats["fc_sys_id"])
            if "battery_voltage" in stats:
                record.battery_voltage = str(stats["battery_voltage"])
            if "esp_rssi" in stats:
                record.rssi = str(stats["esp_rssi"])
            elif "sta_rssi" in stats:
                record.rssi = str(stats["sta_rssi"])
        else:
            record.errors["stats"] = error or "Stats request failed"
            if (
                record.offline_grace_until is None
                or datetime.now() >= record.offline_grace_until
            ):
                record.consecutive_stats_failures += 1
                if record.consecutive_stats_failures >= max(
                    1,
                    min(failure_threshold, 20),
                ):
                    record.online = False
        self._emit_record_changed(identity)

    def update_operation(self, identity: str, operation: str, progress: int = 0) -> None:
        """Update one device operation label and bounded percentage."""
        record = self._records.get(identity)
        if record is None:
            return
        record.operation = operation
        record.operation_progress = max(0, min(100, progress))
        self._emit_record_changed(identity)

    def set_reboot_grace(self, identities: set[str], seconds: int = 20) -> None:
        """Delay offline failure counting after accepted reboot commands."""
        grace_until = datetime.now() + timedelta(seconds=max(0, seconds))
        for identity in identities:
            record = self._records.get(identity)
            if record is not None:
                record.offline_grace_until = grace_until
                record.consecutive_stats_failures = 0

    def set_selected(self, identity: str, selected: bool) -> None:
        """Set one record's selection state and notify all projections."""
        record = self._records.get(identity)
        if record is None or record.selected == selected:
            return
        record.selected = selected
        self._emit_record_changed(identity)
        self.selectionChanged.emit()

    def toggle_selected(self, identity: str) -> None:
        """Toggle one record's selection state."""
        record = self._records.get(identity)
        if record is not None:
            self.set_selected(identity, not record.selected)

    def set_selected_identities(self, identities: set[str], selected: bool) -> None:
        """Set selection for a group of stable identities."""
        rows = []
        for identity in identities:
            record = self._records.get(identity)
            if record is not None and record.selected != selected:
                record.selected = selected
                rows.append(self._order.index(identity))
        if not rows:
            return
        self.dataChanged.emit(
            self.index(min(rows), 0),
            self.index(max(rows), self.columnCount() - 1),
        )
        self.selectionChanged.emit()

    def clear_selection(self) -> None:
        """Clear all selected records."""
        self.set_selected_identities(
            {record.identity for record in self._records.values() if record.selected},
            False,
        )

    def selected_records(self) -> list[DeviceRecord]:
        """Return selected records in source display order."""
        return [record for record in self.all_records() if record.selected]

    def clear(self) -> None:
        """Remove all devices from the current session inventory."""
        if not self._records:
            return
        self.beginResetModel()
        self._records.clear()
        self._order.clear()
        self.endResetModel()
        self.inventoryChanged.emit()
        self.selectionChanged.emit()

    def record_at(self, row: int) -> DeviceRecord | None:
        """Return a record by source-model row."""
        return self._records[self._order[row]] if 0 <= row < len(self._order) else None

    def record_by_identity(self, identity: str) -> DeviceRecord | None:
        """Return a record by stable identity."""
        return self._records.get(identity)

    def all_records(self) -> list[DeviceRecord]:
        """Return all records in source display order."""
        return [self._records[key] for key in self._order]

    def _find_identity(self, incoming: DeviceRecord) -> str | None:
        """Find an existing identity using activation key, MAC, then IP."""
        if incoming.identity in self._records:
            return incoming.identity
        for identity, record in self._records.items():
            if incoming.activation_key and record.activation_key == incoming.activation_key:
                return identity
            if incoming.mac and record.mac.lower() == incoming.mac.lower():
                return identity
            if incoming.ip and record.ip == incoming.ip:
                return identity
        return None

    @staticmethod
    def _merge(existing: DeviceRecord, incoming: DeviceRecord) -> None:
        """Merge fresh non-empty fields while preserving UI operation state."""
        for name in (
            "ip",
            "hostname",
            "activation_status",
            "firmware_version",
            "dronebridge_version",
            "mavlink_sys_id",
            "wifi_ssid",
            "wifi_channel",
            "activation_key",
            "mac",
        ):
            value = getattr(incoming, name)
            if value not in ("", None):
                setattr(existing, name, value)
        existing.sources.update(incoming.sources)
        for name in ("system_info", "settings"):
            value = getattr(incoming, name)
            if value:
                setattr(existing, name, value)
        existing.errors.update(
            {
                key: value
                for key, value in incoming.errors.items()
                if key != "stats"
            }
        )
        existing.last_seen = datetime.now()

    def _emit_record_changed(self, identity: str) -> None:
        """Emit a full-row change for one known identity."""
        try:
            row = self._order.index(identity)
        except ValueError:
            return
        self.dataChanged.emit(
            self.index(row, 0),
            self.index(row, self.columnCount() - 1),
        )
        self.inventoryChanged.emit()

    @staticmethod
    def _display_value(record: DeviceRecord, column_key: str) -> Any:
        """Format one cell without masking operator-visible activation keys."""
        if column_key == "selected":
            return record.selected
        value = getattr(record, column_key, "")
        if column_key == "online":
            return "ONLINE" if record.online else "OFFLINE"
        if column_key == "operation_progress":
            return f"{value}%" if record.operation else ""
        return value


class DeviceFilterProxyModel(QSortFilterProxyModel):
    """Filter and sort every cached device field for the QML table."""

    filterTextChanged = Signal()

    def __init__(self) -> None:
        """Create a case-insensitive dynamically sorted filter."""
        super().__init__()
        self._filter_text = ""
        self.setDynamicSortFilter(True)

    @Slot(str)
    def setFilterText(self, text: str) -> None:
        """Set a literal full-record search string."""
        normalized = text.strip().lower()
        if normalized == self._filter_text:
            return
        self._filter_text = normalized
        self.invalidate()
        self.filterTextChanged.emit()

    def filterAcceptsRow(
        self,
        source_row: int,
        source_parent: QModelIndex,
    ) -> bool:
        """Return whether a source record contains the current search text."""
        model = self.sourceModel()
        record = model.record_at(source_row) if isinstance(model, DeviceTableModel) else None
        return bool(
            record
            and (not self._filter_text or self._filter_text in record.searchable_text)
        )

    def lessThan(self, left: QModelIndex, right: QModelIndex) -> bool:
        """Sort IP addresses numerically and other cells case-insensitively."""
        model = self.sourceModel()
        key = model.column_key(left.column()) if isinstance(model, DeviceTableModel) else ""
        left_value = left.data()
        right_value = right.data()
        if key == "ip":
            return _ip_sort_key(str(left_value)) < _ip_sort_key(str(right_value))
        return str(left_value).lower() < str(right_value).lower()

    def visible_records(self) -> list[DeviceRecord]:
        """Return records accepted by the current filter in display order."""
        source = self.sourceModel()
        if not isinstance(source, DeviceTableModel):
            return []
        records = []
        for row in range(self.rowCount()):
            source_index = self.mapToSource(self.index(row, 0))
            record = source.record_at(source_index.row())
            if record:
                records.append(record)
        return records


class DeviceCardModel(QAbstractListModel):
    """List projection of the filtered table model for the QML matrix view."""

    def __init__(self, proxy: DeviceFilterProxyModel) -> None:
        """Mirror a table proxy as one row per device."""
        super().__init__()
        self._proxy = proxy
        for signal in (
            proxy.modelReset,
            proxy.layoutChanged,
            proxy.rowsInserted,
            proxy.rowsRemoved,
            proxy.dataChanged,
        ):
            signal.connect(lambda *_args: self._reset())

    def roleNames(self) -> dict[int, bytes]:
        """Reuse the source model's complete QML role contract."""
        source = self._proxy.sourceModel()
        return source.roleNames() if isinstance(source, DeviceTableModel) else {}

    def rowCount(self, parent: QModelIndex = QModelIndex()) -> int:
        """Return one list row per filtered device."""
        return 0 if parent.isValid() else self._proxy.rowCount()

    def data(self, index: QModelIndex, role: int = Qt.DisplayRole) -> Any:
        """Return row roles through the first proxy table column."""
        if not index.isValid() or not 0 <= index.row() < self._proxy.rowCount():
            return None
        return self._proxy.index(index.row(), 0).data(role)

    @Slot()
    def _reset(self, *_args: Any) -> None:
        """Reset the lightweight card projection after table changes."""
        self.beginResetModel()
        self.endResetModel()


def preferred_identity(record: DeviceRecord) -> str:
    """Return activation key, MAC, or IP as the stable session identity."""
    return record.activation_key or record.mac.lower() or record.ip


def record_from_discovery(device: dict[str, Any], source: str) -> DeviceRecord:
    """Normalize MAVLink or REST discovery data into one fleet record."""
    info = device.get("system_info") or {}
    settings = device.get("settings") or {}
    stats = device.get("stats") or {}
    activation_key = str(
        info.get("activation_key")
        or device.get("activation_key")
        or info.get("key")
        or ""
    )
    ip = str(device.get("ip") or "")
    mac = str(info.get("esp_mac") or device.get("mac") or "")
    sys_id = (
        device.get("sys_id")
        or device.get("mavlink_sys_id")
        or settings.get("show_man_sysid")
        or ""
    )
    return DeviceRecord(
        identity=activation_key or mac.lower() or ip,
        ip=ip,
        hostname=str(settings.get("wifi_hostname") or info.get("hostname") or ""),
        activation_status=str(info.get("license_type") or "discovered"),
        firmware_version=_format_firmware(info, device),
        dronebridge_version=str(
            info.get("db_build_version")
            or device.get("middleware_sw_version")
            or ""
        ),
        mavlink_sys_id=str(sys_id),
        fc_sys_id=str(stats.get("fc_sys_id") or ""),
        wifi_ssid=str(settings.get("ssid") or settings.get("ssid_ap") or ""),
        wifi_channel=str(settings.get("wifi_chan") or ""),
        rssi=str(stats.get("esp_rssi") or stats.get("sta_rssi") or ""),
        battery_voltage=str(stats.get("battery_voltage") or ""),
        activation_key=activation_key,
        mac=mac,
        sources={source},
        system_info=info,
        settings=settings,
        stats=stats,
        errors=device.get("errors") or {},
    )


def _format_firmware(info: dict[str, Any], device: dict[str, Any]) -> str:
    """Format firmware fields from REST or MAVLink discovery."""
    flight = device.get("flight_sw_version")
    if isinstance(flight, dict):
        return str(flight.get("version_str") or "")
    parts = [
        info.get("major_version"),
        info.get("minor_version"),
        info.get("patch_version"),
    ]
    if all(part is not None for part in parts):
        version = ".".join(str(int(part)) for part in parts)
        maturity = info.get("maturity_version")
        return f"{version}-{maturity}" if maturity else version
    return ""


def _ip_sort_key(value: str) -> tuple[int, int | str]:
    """Return a total-order key for valid and malformed IP values."""
    try:
        return 0, int(ipaddress.ip_address(value))
    except ValueError:
        return 1, value

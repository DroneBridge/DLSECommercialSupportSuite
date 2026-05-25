"""Qt models for ESP32 discovery and filtering."""

from dataclasses import dataclass, field
from datetime import datetime
from typing import Any

from PySide6.QtCore import QAbstractTableModel, QModelIndex, QSortFilterProxyModel, Qt


@dataclass
class DeviceRecord:
    """In-memory representation of one discovered ESP32 shown in the UI."""
    identity: str
    ip: str
    hostname: str = ""
    activation_status: str = "discovered"
    firmware_version: str = ""
    dronebridge_version: str = ""
    mavlink_sys_id: str = ""
    wifi_ssid: str = ""
    wifi_channel: str = ""
    rssi: str = ""
    activation_key: str = ""
    mac: str = ""
    source: str = ""
    last_seen: datetime = field(default_factory=datetime.now)
    raw: dict[str, Any] = field(default_factory=dict)


class DeviceTableModel(QAbstractTableModel):
    """Table model optimized for large discovered-device lists."""

    COLUMNS = [
        ("hostname", "Hostname"),
        ("ip", "IP"),
        ("activation_status", "Activation Status"),
        ("firmware_version", "Firmware version"),
        ("dronebridge_version", "DroneBridge version"),
        ("mavlink_sys_id", "MAVLink Sys ID"),
        ("wifi_ssid", "WiFi SSID"),
        ("wifi_channel", "WiFi Channel"),
        ("rssi", "RSSI"),
    ]

    def __init__(self) -> None:
        """
        Create an empty device table model.

        Devices are stored by stable identity and exposed as sorted rows.
        """
        super().__init__()
        self._records: dict[str, DeviceRecord] = {}
        self._order: list[str] = []

    def rowCount(self, parent: QModelIndex = QModelIndex()) -> int:
        """Return the number of visible model rows."""
        if parent.isValid():
            return 0
        return len(self._order)

    def columnCount(self, parent: QModelIndex = QModelIndex()) -> int:
        """Return the number of default device columns."""
        if parent.isValid():
            return 0
        return len(self.COLUMNS)

    def data(self, index: QModelIndex, role: int = Qt.DisplayRole) -> Any:
        """Return table cell content for display, sorting, and filtering."""
        if not index.isValid() or index.row() >= len(self._order):
            return None
        record = self._records[self._order[index.row()]]
        attr, _title = self.COLUMNS[index.column()]
        if role in (Qt.DisplayRole, Qt.EditRole):
            return getattr(record, attr)
        if role == Qt.UserRole:
            return record
        return None

    def headerData(self, section: int, orientation: Qt.Orientation,
                   role: int = Qt.DisplayRole) -> Any:
        """Return table header names for columns and row numbers."""
        if role != Qt.DisplayRole:
            return None
        if orientation == Qt.Horizontal:
            return self.COLUMNS[section][1]
        return section + 1

    def flags(self, index: QModelIndex) -> Qt.ItemFlag:
        """Return read-only selectable table item flags."""
        if not index.isValid():
            return Qt.NoItemFlags
        return Qt.ItemIsEnabled | Qt.ItemIsSelectable

    def upsert_many(self, records: list[DeviceRecord]) -> None:
        """
        Merge discovered devices into the table.

        :param records: Device records produced by discovery or detail refresh workers.
        :return: None. The model emits a reset because batches may reorder rows.
        """
        if not records:
            return
        self.beginResetModel()
        for record in records:
            existing = self._records.get(record.identity)
            if existing is None:
                old_identity = next(
                    (identity for identity, stored in self._records.items() if stored.ip == record.ip),
                    None,
                )
                if old_identity is not None:
                    existing = self._records.pop(old_identity)
            if existing:
                merged = existing
                for field_name, value in record.__dict__.items():
                    if value not in ("", None, {}, []):
                        setattr(merged, field_name, value)
                merged.last_seen = datetime.now()
                self._records[merged.identity] = merged
            else:
                self._records[record.identity] = record
        self._order = sorted(self._records, key=lambda key: self._records[key].ip)
        self.endResetModel()

    def update_status(self, identity: str, status: str) -> None:
        """
        Update the activation status for one device.

        :param identity: Stable device identity from ``DeviceRecord.identity``.
        :param status: Human-readable status shown in the table.
        :return: None. Emits row data changes when the identity exists.
        """
        record = self._records.get(identity)
        if record is None:
            return
        record.activation_status = status
        row = self._order.index(identity)
        left = self.index(row, 0)
        right = self.index(row, self.columnCount() - 1)
        self.dataChanged.emit(left, right, [Qt.DisplayRole])

    def record_at(self, row: int) -> DeviceRecord | None:
        """
        Return the device record at a source-model row.

        :param row: Row in the source model.
        :return: Matching ``DeviceRecord`` or ``None`` if the row is invalid.
        """
        if row < 0 or row >= len(self._order):
            return None
        return self._records[self._order[row]]

    def all_records(self) -> list[DeviceRecord]:
        """
        Return all records in table order.

        :return: List of current device records.
        """
        return [self._records[key] for key in self._order]


class DeviceFilterProxyModel(QSortFilterProxyModel):
    """Case-insensitive filter that searches all stored fields for a device."""

    def __init__(self) -> None:
        """
        Create a proxy model with plain-text search behavior.

        The filter text is not treated as a regular expression, so activation
        keys, IP addresses, and MAC addresses can be searched literally.
        """
        super().__init__()
        self._filter_text = ""

    def set_filter_text(self, text: str) -> None:
        """
        Set the plain-text filter used across all device fields.

        :param text: User-entered search text.
        :return: None. Invalidates the proxy filter.
        """
        self._filter_text = text.strip().lower()
        self.invalidateFilter()

    def filterAcceptsRow(self, source_row: int, source_parent: QModelIndex) -> bool:
        """Return True when a device row matches the active search string."""
        needle = self._filter_text
        if not needle:
            return True
        model = self.sourceModel()
        if not isinstance(model, DeviceTableModel):
            return True
        record = model.record_at(source_row)
        if record is None:
            return False
        haystack = " ".join(str(value) for value in record.__dict__.values()).lower()
        return needle in haystack


def record_from_discovery(device: dict[str, Any], source: str) -> DeviceRecord:
    """
    Convert discovery helper output into a table record.

    :param device: Device dictionary returned by MAVLink or HTTP discovery.
    :param source: Discovery source label.
    :return: Normalized device record for the Qt model.
    """
    info = device.get("system_info") or {}
    settings = device.get("settings") or {}
    stats = device.get("stats") or {}
    activation_key = info.get("activation_key") or device.get("activation_key") or info.get("key") or ""
    ip = str(device.get("ip") or "")
    sys_id = device.get("sys_id") or device.get("mavlink_sys_id") or ""
    mac = info.get("esp_mac") or device.get("mac") or ""
    identity = activation_key or f"{ip}:{sys_id or mac or source}"
    firmware = _format_firmware(info, device)
    return DeviceRecord(
        identity=identity,
        ip=ip,
        hostname=str(settings.get("wifi_hostname") or info.get("hostname") or ""),
        activation_status=str(info.get("license_type") or "discovered"),
        firmware_version=firmware,
        dronebridge_version=str(info.get("db_build_version") or device.get("middleware_sw_version") or ""),
        mavlink_sys_id=str(sys_id),
        wifi_ssid=str(settings.get("ssid") or settings.get("ssid_ap") or ""),
        wifi_channel=str(settings.get("wifi_chan") or ""),
        rssi=str(stats.get("esp_rssi") or stats.get("sta_rssi") or ""),
        activation_key=str(activation_key),
        mac=str(mac),
        source=source,
        raw=device,
    )


def _format_firmware(info: dict[str, Any], device: dict[str, Any]) -> str:
    """
    Format firmware version fields from REST or MAVLink data.

    :param info: ``/api/system/info`` response data.
    :param device: Discovery dictionary that may include decoded MAVLink version data.
    :return: Human-readable firmware version string or an empty string.
    """
    if "flight_sw_version" in device and isinstance(device["flight_sw_version"], dict):
        return str(device["flight_sw_version"].get("version_str") or "")
    parts = [info.get("major_version"), info.get("minor_version"), info.get("patch_version")]
    if all(part is not None for part in parts):
        maturity = info.get("maturity_version")
        version = ".".join(str(int(part)) for part in parts)
        return f"{version}-{maturity}" if maturity else version
    return ""

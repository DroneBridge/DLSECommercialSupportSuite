"""Fleet inventory models exposed to the Qt Quick user interface."""

from __future__ import annotations

import ipaddress
import math
from dataclasses import dataclass, field
from datetime import datetime, timedelta
from time import monotonic
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

from DroneBridgeCommercialSupportSuite import DLSESupportedChips


@dataclass
class DeviceRecord:
    """Store session-scoped state for one discovered DLSE ESP32."""

    identity: str
    ip: str
    hostname: str = ""
    activation_status: str = "discovered"
    firmware_version: str = ""
    chip: str = ""
    dronebridge_version: str = ""
    mavlink_sys_id: str = ""
    dlse_mode: str = ""
    baud: str = ""
    gpio_cts: str = ""
    gpio_rts: str = ""
    gpio_tx: str = ""
    gpio_rx: str = ""
    led_cont_en: str = ""
    adc_a_en: str = ""
    adc_v_en: str = ""
    dlse_local_udp_port: str = ""
    dlse_remote_udp_port: str = ""
    power_mgmt: str = ""
    dlse_mavlink_heartbeat: str = ""
    dlse_mavlink_sys_id_based_on_ip: str = ""
    fc_sys_id: str = "unknown"
    wifi_ssid: str = ""
    wifi_channel: str = ""
    rssi: str = ""
    ap_rssi: str = ""
    ap_channel: str = ""
    ap_band: str = ""
    ap_wifi_standard: str = ""
    ap_live_throughput: str = ""
    ap_rx_rate: str = ""
    ap_tx_rate: str = ""
    ap_signal_balance: str = ""
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
    ap_metrics: dict[str, Any] = field(default_factory=dict)
    stats_rates: dict[str, float | None] = field(default_factory=dict)
    stats_sampled_at: float | None = None
    errors: dict[str, str] = field(default_factory=dict)

    @property
    def source(self) -> str:
        """Return a stable display string for all discovery sources."""
        return ", ".join(sorted(self.sources))

    @property
    def fc_sys_id_mismatch(self) -> bool:
        """
        Return whether a known FC MAVLink SYS ID differs from the DLSE setting.

        :return: ``False`` while the FC SYS ID is unknown. Otherwise ``True``
            when the configured DLSE MAVLink SYS ID is missing, malformed, or
            numerically different from the FC-reported value.
        """
        if self.fc_sys_id == "unknown":
            return False
        try:
            return int(self.fc_sys_id) != int(self.mavlink_sys_id)
        except (TypeError, ValueError):
            return True

    @property
    def searchable_text(self) -> str:
        """Return searchable content covering all REST and inventory fields."""
        values = [
            self.identity,
            self.ip,
            self.hostname,
            self.activation_status,
            self.firmware_version,
            self.chip,
            self.dronebridge_version,
            self.mavlink_sys_id,
            self.dlse_mode,
            self.baud,
            self.gpio_cts,
            self.gpio_rts,
            self.gpio_tx,
            self.gpio_rx,
            self.led_cont_en,
            self.adc_a_en,
            self.adc_v_en,
            self.dlse_local_udp_port,
            self.dlse_remote_udp_port,
            self.power_mgmt,
            self.dlse_mavlink_heartbeat,
            self.dlse_mavlink_sys_id_based_on_ip,
            self.fc_sys_id,
            self.wifi_ssid,
            self.wifi_channel,
            self.rssi,
            self.ap_rssi,
            self.ap_channel,
            self.ap_band,
            self.ap_wifi_standard,
            self.ap_live_throughput,
            self.ap_rx_rate,
            self.ap_tx_rate,
            self.ap_signal_balance,
            self.battery_voltage,
            self.activation_key,
            self.mac,
            self.source,
            self.operation,
            self.system_info,
            self.settings,
            self.stats,
            self.ap_metrics,
        ]
        return " ".join(str(value) for value in values).lower()


class DeviceTableModel(QAbstractTableModel):
    """Incremental table model suitable for inventories of at least 5,000 devices."""

    inventoryChanged = Signal()
    selectionChanged = Signal()

    COLUMNS = [
        ("hostname", "HOSTNAME", 112),
        ("ip", "IP", 112),
        ("activation_status", "ACTIVATION\nSTATUS", 138),
        ("firmware_version", "DLSE FIRMWARE", 132),
        ("chip", "CHIP", 86),
        ("dronebridge_version", "DLSE BUILD\nVERSION", 116),
        ("mavlink_sys_id", "DLSE CONFIGURED\nMAVLINK SYS ID", 136),
        ("fc_sys_id", "FC MAVLINK\nSYS ID", 104),
        ("wifi_ssid", "DB APMODE\nSSID", 120),
        ("wifi_channel", "DB APMODE\nCHANNEL", 82),
        ("rssi", "DEVICE\nRSSI", 76),
        ("ap_rssi", "AP-MEASURED\nRSSI", 96),
        ("ap_channel", "AP\nCHANNEL", 92),
        ("ap_band", "AP\nBAND", 90),
        ("ap_wifi_standard", "AP WIFI\nSTANDARD", 126),
        ("ap_live_throughput", "AP LIVE\nTHROUGHPUT", 128),
        ("ap_rx_rate", "AP RX\nRATE", 100),
        ("ap_tx_rate", "AP TX\nRATE", 100),
        ("ap_signal_balance", "AP/CLIENT\nSIGNAL BALANCE", 138),
        ("dlse_mode", "DLSE MODE", 118),
        ("baud", "BAUD", 92),
        ("gpio_cts", "CTS GPIO", 86),
        ("gpio_rts", "RTS GPIO", 86),
        ("gpio_tx", "TX GPIO", 86),
        ("gpio_rx", "RX GPIO", 86),
        ("led_cont_en", "LED CONTROL", 112),
        ("adc_a_en", "CURRENT\nMONITOR", 120),
        ("adc_v_en", "VOLTAGE\nMONITOR", 120),
        ("dlse_local_udp_port", "DLSE LOCAL\nUDP PORT", 116),
        ("dlse_remote_udp_port", "DLSE REMOTE\nUDP PORT", 122),
        ("power_mgmt", "POWER\nMGMT", 94),
        ("dlse_mavlink_heartbeat", "DLSE MAVLINK\nHEARTBEAT", 122),
        ("dlse_mavlink_sys_id_based_on_ip", "DLSE MAVLINK\nSYS ID BASED ON IP", 154),
        ("activation_key", "ACTIVATION KEY", 210),
        ("mac", "MAC", 138),
        ("online", "ESP\nONLINE", 86),
        ("operation", "OPERATION", 150),
        ("operation_progress", "PROGRESS", 106),
    ]
    DEFAULT_COLUMN_KEYS = tuple(column[0] for column in COLUMNS[:19])

    IdentityRole = Qt.UserRole + 1
    IpRole = Qt.UserRole + 2
    HostnameRole = Qt.UserRole + 3
    ActivationStatusRole = Qt.UserRole + 4
    FirmwareVersionRole = Qt.UserRole + 5
    ChipRole = Qt.UserRole + 6
    DronebridgeVersionRole = Qt.UserRole + 7
    MavlinkSysIdRole = Qt.UserRole + 8
    DlseModeRole = Qt.UserRole + 9
    BaudRole = Qt.UserRole + 10
    DlseLocalUdpPortRole = Qt.UserRole + 11
    DlseRemoteUdpPortRole = Qt.UserRole + 12
    PowerMgmtRole = Qt.UserRole + 13
    DlseMavlinkHeartbeatRole = Qt.UserRole + 14
    DlseMavlinkSysIdBasedOnIpRole = Qt.UserRole + 15
    FcSysIdRole = Qt.UserRole + 16
    WifiSsidRole = Qt.UserRole + 17
    WifiChannelRole = Qt.UserRole + 18
    RssiRole = Qt.UserRole + 19
    BatteryVoltageRole = Qt.UserRole + 20
    ActivationKeyRole = Qt.UserRole + 21
    MacRole = Qt.UserRole + 22
    SourceRole = Qt.UserRole + 23
    LastSeenRole = Qt.UserRole + 24
    OnlineRole = Qt.UserRole + 25
    SelectedRole = Qt.UserRole + 26
    OperationRole = Qt.UserRole + 27
    OperationProgressRole = Qt.UserRole + 28
    SystemInfoRole = Qt.UserRole + 29
    SettingsRole = Qt.UserRole + 30
    StatsRole = Qt.UserRole + 31
    ErrorsRole = Qt.UserRole + 32
    ColumnKeyRole = Qt.UserRole + 33
    FcSysIdMismatchRole = Qt.UserRole + 34
    ApRssiRole = Qt.UserRole + 35
    ApMetricsRole = Qt.UserRole + 36
    ApWifiStandardRole = Qt.UserRole + 37
    ApLiveThroughputRole = Qt.UserRole + 38
    ApRxRateRole = Qt.UserRole + 39
    ApTxRateRole = Qt.UserRole + 40
    ApSignalBalanceRole = Qt.UserRole + 41
    ApChannelRole = Qt.UserRole + 42
    ApBandRole = Qt.UserRole + 43

    _ROLE_ATTRIBUTES = {
        IdentityRole: "identity",
        IpRole: "ip",
        HostnameRole: "hostname",
        ActivationStatusRole: "activation_status",
        FirmwareVersionRole: "firmware_version",
        ChipRole: "chip",
        DronebridgeVersionRole: "dronebridge_version",
        MavlinkSysIdRole: "mavlink_sys_id",
        DlseModeRole: "dlse_mode",
        BaudRole: "baud",
        DlseLocalUdpPortRole: "dlse_local_udp_port",
        DlseRemoteUdpPortRole: "dlse_remote_udp_port",
        PowerMgmtRole: "power_mgmt",
        DlseMavlinkHeartbeatRole: "dlse_mavlink_heartbeat",
        DlseMavlinkSysIdBasedOnIpRole: "dlse_mavlink_sys_id_based_on_ip",
        FcSysIdRole: "fc_sys_id",
        WifiSsidRole: "wifi_ssid",
        WifiChannelRole: "wifi_channel",
        RssiRole: "rssi",
        ApRssiRole: "ap_rssi",
        ApChannelRole: "ap_channel",
        ApBandRole: "ap_band",
        ApWifiStandardRole: "ap_wifi_standard",
        ApLiveThroughputRole: "ap_live_throughput",
        ApRxRateRole: "ap_rx_rate",
        ApTxRateRole: "ap_tx_rate",
        ApSignalBalanceRole: "ap_signal_balance",
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
        ApMetricsRole: "ap_metrics",
        FcSysIdMismatchRole: "fc_sys_id_mismatch",
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
            self.ChipRole: b"chip",
            self.DronebridgeVersionRole: b"dronebridgeVersion",
            self.MavlinkSysIdRole: b"mavlinkSysId",
            self.DlseModeRole: b"dlseMode",
            self.BaudRole: b"baud",
            self.DlseLocalUdpPortRole: b"dlseLocalUdpPort",
            self.DlseRemoteUdpPortRole: b"dlseRemoteUdpPort",
            self.PowerMgmtRole: b"powerMgmt",
            self.DlseMavlinkHeartbeatRole: b"dlseMavlinkHeartbeat",
            self.DlseMavlinkSysIdBasedOnIpRole: b"dlseMavlinkSysIdBasedOnIp",
            self.FcSysIdRole: b"fcSysId",
            self.WifiSsidRole: b"wifiSsid",
            self.WifiChannelRole: b"wifiChannel",
            self.RssiRole: b"rssi",
            self.ApRssiRole: b"apRssi",
            self.ApChannelRole: b"apChannel",
            self.ApBandRole: b"apBand",
            self.ApWifiStandardRole: b"apWifiStandard",
            self.ApLiveThroughputRole: b"apLiveThroughput",
            self.ApRxRateRole: b"apRxRate",
            self.ApTxRateRole: b"apTxRate",
            self.ApSignalBalanceRole: b"apSignalBalance",
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
            self.ApMetricsRole: b"apMetrics",
            self.ColumnKeyRole: b"columnKey",
            self.FcSysIdMismatchRole: b"fcSysIdMismatch",
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
        sampled_at: float | None = None,
    ) -> None:
        """
        Apply one stats attempt and update the device's online health.

        :param identity: Stable inventory identity of the polled device.
        :param success: Whether the request returned a valid JSON object.
        :param stats: Latest runtime statistics for a successful request.
        :param error: Sanitized failure detail stored for inspector diagnostics.
        :param failure_threshold: Consecutive counted failures required offline.
        :param sampled_at: Optional monotonic sample time used by deterministic
            callers and tests. The current monotonic time is used when omitted.
        :return: None. Unknown identities are ignored; reaching the configured
            failure threshold marks a device offline while success restores it.
        """
        record = self._records.get(identity)
        if record is None:
            return
        if success and isinstance(stats, dict):
            current_sample_time = monotonic() if sampled_at is None else sampled_at
            elapsed = (
                current_sample_time - record.stats_sampled_at
                if record.stats_sampled_at is not None
                else None
            )
            record.stats_rates = {
                key: _counter_rate(record.stats, stats, key, elapsed)
                for key in ("read_bytes", "serial_bytes_sent")
            }
            record.stats = dict(stats)
            record.stats_sampled_at = current_sample_time
            record.last_seen = datetime.now()
            record.consecutive_stats_failures = 0
            record.offline_grace_until = None
            record.online = True
            record.errors.pop("stats", None)
            record.fc_sys_id = _format_fc_sys_id(stats.get("fc_sysid"))
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

    def apply_system_info_result(
        self,
        identity: str,
        success: bool,
        system_info: dict[str, Any] | None = None,
        error: str = "",
    ) -> None:
        """
        Apply a post-operation ``/api/system/info`` result to one device.

        :param identity: Stable inventory identity of the refreshed device.
        :param success: Whether the request returned a valid JSON object.
        :param system_info: Latest static system-information payload on success.
        :param error: Sanitized failure detail stored for inspector diagnostics.
        :return: None. Failed refreshes preserve existing device values.
        """
        record = self._records.get(identity)
        if record is None:
            return
        if success and isinstance(system_info, dict):
            record.system_info = dict(system_info)
            license_type = system_info.get("license_type")
            if license_type not in (None, ""):
                record.activation_status = str(license_type)
            activation_key = system_info.get("activation_key") or system_info.get("key")
            if activation_key:
                record.activation_key = str(activation_key)
            mac = system_info.get("esp_mac")
            if mac:
                record.mac = str(mac)
            chip = _format_chip(system_info.get("esp_chip_model"))
            if chip:
                record.chip = chip
            firmware_version = _format_firmware(system_info, {})
            if firmware_version:
                record.firmware_version = firmware_version
            build_version = system_info.get("db_build_version")
            if build_version not in (None, ""):
                record.dronebridge_version = str(build_version)
            record.errors.pop("system_info", None)
        else:
            record.errors["system_info"] = error or "System info request failed"
        self._emit_record_changed(identity)

    def apply_ap_clients(self, clients: list[dict[str, Any]]) -> None:
        """
        Apply the latest UniFi client observations to retained DLSE devices.

        :param clients: Normalized active-client dictionaries containing MAC,
            IP, RSSI, rates, and optional access-point metadata. Missing values
            remain blank rather than being inferred from an unrelated metric.
        :return: None. Records are matched by normalized MAC first and by IP as
            a fallback. Missing clients have their stale AP observation cleared.
        """
        by_mac = {
            normalized: client
            for client in clients
            if (normalized := _normalize_mac(client.get("mac")))
        }
        by_ip = {
            str(client.get("ip")): client
            for client in clients
            if client.get("ip")
        }
        changed = False
        for record in self._records.values():
            client = by_mac.get(_normalize_mac(record.mac)) or by_ip.get(record.ip)
            metrics = dict(client) if client else {}
            ap_rssi = _rssi_text(metrics.get("rssi")) if metrics else ""
            ap_channel = (
                _ap_channel_text(metrics.get("ap_channel", metrics.get("channel")))
                if metrics
                else ""
            )
            ap_band = (
                _ap_band_text(
                    metrics.get("ap_band", metrics.get("band")),
                    metrics.get("ap_channel", metrics.get("channel")),
                    metrics.get("radio"),
                )
                if metrics
                else ""
            )
            ap_wifi_standard = (
                _wifi_standard_text(metrics.get("wifi_standard")) if metrics else ""
            )
            ap_live_throughput = _throughput_text(metrics) if metrics else ""
            ap_rx_rate = _rate_text(metrics.get("rx_rate")) if metrics else ""
            ap_tx_rate = _rate_text(metrics.get("tx_rate")) if metrics else ""
            ap_signal_balance = (
                _signal_balance_text(metrics.get("signal_balance")) if metrics else ""
            )
            if (
                record.ap_metrics == metrics
                and record.ap_rssi == ap_rssi
                and record.ap_channel == ap_channel
                and record.ap_band == ap_band
                and record.ap_wifi_standard == ap_wifi_standard
                and record.ap_live_throughput == ap_live_throughput
                and record.ap_rx_rate == ap_rx_rate
                and record.ap_tx_rate == ap_tx_rate
                and record.ap_signal_balance == ap_signal_balance
            ):
                continue
            record.ap_metrics = metrics
            record.ap_rssi = ap_rssi
            record.ap_channel = ap_channel
            record.ap_band = ap_band
            record.ap_wifi_standard = ap_wifi_standard
            record.ap_live_throughput = ap_live_throughput
            record.ap_rx_rate = ap_rx_rate
            record.ap_tx_rate = ap_tx_rate
            record.ap_signal_balance = ap_signal_balance
            changed = True
        if not changed or not self._order:
            return
        self.dataChanged.emit(
            self.index(0, 0),
            self.index(len(self._order) - 1, self.columnCount() - 1),
        )
        self.inventoryChanged.emit()

    def apply_settings_result(
        self,
        identity: str,
        success: bool,
        settings: dict[str, Any] | None = None,
        ip: str | None = None,
        error: str = "",
    ) -> None:
        """
        Apply a refreshed REST settings response to one inventory record.

        :param identity: Stable inventory identity of the refreshed device.
        :param success: Whether the settings request returned valid JSON.
        :param settings: Complete or partial ``/api/settings`` response on success.
        :param ip: Device address used for the successful refresh, when known.
        :param error: Sanitized failure detail stored for inspector diagnostics.
        :return: None. Failed refreshes preserve cached settings and table values.
        """
        record = self._records.get(identity)
        if record is None:
            return
        if success and isinstance(settings, dict):
            if ip:
                record.ip = str(ip)
            record.settings = dict(settings)
            if "wifi_hostname" in settings:
                record.hostname = _setting_text(settings.get("wifi_hostname"))
            if "esp32_mode" in settings:
                record.dlse_mode = _format_esp32_mode(settings.get("esp32_mode"))
            if "baud" in settings:
                record.baud = _setting_text(settings.get("baud"))
            if "gpio_cts" in settings:
                record.gpio_cts = _setting_text(settings.get("gpio_cts"))
            if "gpio_rts" in settings:
                record.gpio_rts = _setting_text(settings.get("gpio_rts"))
            if "gpio_tx" in settings:
                record.gpio_tx = _setting_text(settings.get("gpio_tx"))
            if "gpio_rx" in settings:
                record.gpio_rx = _setting_text(settings.get("gpio_rx"))
            if "led_cont_en" in settings:
                record.led_cont_en = _format_enabled_disabled(
                    settings.get("led_cont_en")
                )
            if "adc_a_en" in settings:
                record.adc_a_en = _format_enabled_disabled(settings.get("adc_a_en"))
            if "adc_v_en" in settings:
                record.adc_v_en = _format_enabled_disabled(settings.get("adc_v_en"))
            if "udp_local_port" in settings:
                record.dlse_local_udp_port = _setting_text(
                    settings.get("udp_local_port")
                )
            if "wifi_brcst_port" in settings:
                record.dlse_remote_udp_port = _setting_text(
                    settings.get("wifi_brcst_port")
                )
            if "show_pm_en" in settings:
                record.power_mgmt = _format_enabled_disabled(settings.get("show_pm_en"))
            if "show_pm_en_hb" in settings:
                record.dlse_mavlink_heartbeat = _format_enabled_disabled(
                    settings.get("show_pm_en_hb")
                )
            if "show_en_syid_ip" in settings:
                record.dlse_mavlink_sys_id_based_on_ip = _format_yes_no(
                    settings.get("show_en_syid_ip")
                )
            if "wifi_chan" in settings:
                record.wifi_channel = _setting_text(settings.get("wifi_chan"))
            if "ssid" in settings or "ssid_ap" in settings:
                record.wifi_ssid = _setting_text(
                    _first_configured_value(
                        settings.get("ssid"),
                        settings.get("ssid_ap"),
                    )
                )
            if _setting_enabled(settings.get("show_en_syid_ip")):
                sys_id = _sys_id_from_device_ip(record.ip)
                if sys_id:
                    record.mavlink_sys_id = sys_id
            elif "show_man_sysid" in settings:
                record.mavlink_sys_id = _setting_text(settings.get("show_man_sysid"))
            record.last_seen = datetime.now()
            record.errors.pop("settings", None)
        else:
            record.errors["settings"] = error or "Settings request failed"
        self._emit_record_changed(identity)

    def update_operation(self, identity: str, operation: str, progress: int = 0) -> None:
        """Update one device operation label and bounded percentage."""
        record = self._records.get(identity)
        if record is None:
            return
        record.operation = operation
        record.operation_progress = max(0, min(100, progress))
        self._emit_record_changed(identity)

    def update_static_network(
        self,
        identity: str,
        ip: str,
        settings: dict[str, Any],
    ) -> None:
        """Update a device's cached IP and accepted static-network settings."""
        record = self._records.get(identity)
        if record is None:
            return
        record.ip = str(ip)
        record.settings.update(settings)
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
            "chip",
            "dronebridge_version",
            "mavlink_sys_id",
            "dlse_mode",
            "baud",
            "gpio_cts",
            "gpio_rts",
            "gpio_tx",
            "gpio_rx",
            "led_cont_en",
            "adc_a_en",
            "adc_v_en",
            "dlse_local_udp_port",
            "dlse_remote_udp_port",
            "power_mgmt",
            "dlse_mavlink_heartbeat",
            "dlse_mavlink_sys_id_based_on_ip",
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
        if incoming.stats:
            existing.fc_sys_id = incoming.fc_sys_id
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
        """Format one cell without changing the raw role values."""
        if column_key == "selected":
            return record.selected
        value = getattr(record, column_key, "")
        if column_key == "online":
            return "ONLINE" if record.online else "OFFLINE"
        if column_key == "operation_progress":
            return f"{value}%" if record.operation else ""
        if column_key in {"rssi", "ap_rssi"} and str(value).strip():
            return f"{value} dBm"
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


def _normalize_mac(value: Any) -> str:
    """Return a separator-free lowercase MAC key, or an empty string if invalid."""
    normalized = "".join(
        character
        for character in str(value or "").lower()
        if character.isalnum()
    )
    return normalized if len(normalized) == 12 and all(
        character in "0123456789abcdef" for character in normalized
    ) else ""


def _rssi_text(value: Any) -> str:
    """Return a finite AP RSSI value as compact text, or empty text if invalid."""
    if isinstance(value, bool):
        return ""
    try:
        number = float(value)
    except (TypeError, ValueError):
        return ""
    if not -150 <= number <= 0:
        return ""
    return str(int(number)) if number.is_integer() else f"{number:g}"


def _ap_channel_text(value: Any) -> str:
    """Return a valid UniFi Wi-Fi channel number as display text."""
    number = _numeric_metric(value)
    if number is None or not number.is_integer() or not 1 <= number <= 233:
        return "Unavailable"
    return str(int(number))


def _ap_band_text(value: Any, channel: Any = None, radio: Any = None) -> str:
    """Map UniFi radio metadata to a band, with a safe channel fallback."""
    normalized = str(value or radio or "").strip().lower().replace(" ", "")
    if normalized in {"ng", "2g", "2.4", "2.4g", "2.4ghz", "bg"}:
        return "2.4 GHz"
    if normalized in {"na", "5g", "5ghz", "5"}:
        return "5 GHz"
    if normalized in {"6e", "6g", "6ghz", "6"}:
        return "6 GHz"
    # Channels 1-14 are unambiguous 2.4 GHz channels. Other channel ranges
    # overlap 5/6 GHz allocations, so do not guess without UniFi radio data.
    channel_text = _ap_channel_text(channel)
    try:
        channel_number = int(channel_text)
    except ValueError:
        return "Unavailable"
    return "2.4 GHz" if 1 <= channel_number <= 14 else "Unavailable"


def _numeric_metric(value: Any) -> float | None:
    """Return a finite numeric UniFi metric, excluding booleans."""
    if isinstance(value, bool):
        return None
    try:
        number = float(value)
    except (TypeError, ValueError):
        return None
    return number if math.isfinite(number) else None


def _wifi_standard_text(value: Any) -> str:
    """Translate UniFi ``radio_proto`` values to operator-friendly Wi-Fi text."""
    protocol = str(value or "").strip().lower()
    if not protocol:
        return "Unavailable"
    return {
        "be": "Wi-Fi 7 (802.11be)",
        "ax": "Wi-Fi 6 (802.11ax)",
        "ac": "Wi-Fi 5 (802.11ac)",
        "n": "Wi-Fi 4 (802.11n)",
        "ng": "Wi-Fi 4 (802.11n)",
        "na": "Wi-Fi 4 (802.11n)",
        "g": "802.11g",
        "a": "802.11a",
        "b": "802.11b",
    }.get(protocol, str(value))


def _rate_text(value: Any) -> str:
    """Format a UniFi client PHY rate, whose API unit is usually kbit/s."""
    number = _numeric_metric(value)
    if number is None or number <= 0:
        return "Unavailable"
    mbps = number / 1000.0 if number >= 1000 else number
    if mbps >= 100:
        return f"{mbps:.0f} Mbps"
    if mbps.is_integer():
        return f"{int(mbps)} Mbps"
    return f"{mbps:.1f} Mbps"


def _speed_text(bits_per_second: float | None) -> str:
    """Format a live traffic rate expressed in bits per second."""
    if bits_per_second is None or bits_per_second < 0:
        return "Unavailable"
    if bits_per_second >= 1_000_000:
        value = bits_per_second / 1_000_000
        return f"{value:.1f} Mbps"
    if bits_per_second >= 1_000:
        return f"{bits_per_second / 1_000:.1f} Kbps"
    return f"{bits_per_second:.0f} bps"


def _throughput_text(metrics: dict[str, Any]) -> str:
    """Format UniFi live throughput from direct or byte-counter rate fields."""
    direct = _numeric_metric(metrics.get("live_throughput_bps"))
    if direct is not None:
        return _speed_text(direct)
    rx_bytes = _numeric_metric(metrics.get("rx_bytes_rate"))
    tx_bytes = _numeric_metric(metrics.get("tx_bytes_rate"))
    if rx_bytes is None and tx_bytes is None:
        return "Unavailable"
    return _speed_text(max(0.0, (rx_bytes or 0.0) + (tx_bytes or 0.0)) * 8)


def _signal_balance_text(value: Any) -> str:
    """Format UniFi's optional AP/client signal-balance value."""
    if value is None or str(value).strip() == "":
        return "Unavailable"
    return str(value)


def _first_configured_value(*values: Any) -> Any:
    """
    Return the first present settings or discovery value.

    :param values: Candidate values ordered by precedence.
    :return: The first value that is neither ``None`` nor an empty string. Numeric
        zero is preserved because it can be a configured MAVLink system ID.
    """
    for value in values:
        if value is not None and value != "":
            return value
    return ""


def _setting_enabled(value: Any) -> bool:
    """
    Interpret ESP32 integer-style setting values as a boolean.

    :param value: Raw setting value from REST hydration, commonly ``0``, ``1``,
        or a string representation of those values.
    :return: ``True`` only when the normalized integer value is ``1``. Missing or
        malformed values are treated as disabled.
    """
    try:
        return int(value) == 1
    except (TypeError, ValueError):
        return False


def _setting_text(value: Any) -> str:
    """
    Convert a REST setting value to table text without losing configured zeroes.

    :param value: Raw REST setting value.
    :return: Empty string for absent settings, otherwise the string value.
    """
    return "" if value is None or value == "" else str(value)


def _format_esp32_mode(value: Any) -> str:
    """
    Decode the ESP32 mode setting for operator display.

    :param value: Raw ``esp32_mode`` setting from REST hydration.
    :return: ``ACCESS POINT`` for mode ``1``, ``CLIENT`` for mode ``2``,
        ``INVALID`` for unsupported or malformed configured values, and an
        empty string when the setting is absent.
    """
    if value is None or value == "":
        return ""
    try:
        mode = int(value)
    except (TypeError, ValueError):
        return "INVALID"
    if mode == 1:
        return "ACCESS POINT"
    if mode == 2:
        return "CLIENT"
    return "INVALID"


def _format_enabled_disabled(value: Any) -> str:
    """
    Decode a REST ``0``/``1`` setting as enabled or disabled.

    :param value: Raw REST setting value.
    :return: ``enabled`` for ``1``, ``disabled`` for ``0``, ``INVALID`` for
        other configured values, and an empty string when the setting is absent.
    """
    if value is None or value == "":
        return ""
    try:
        enabled = int(value)
    except (TypeError, ValueError):
        return "INVALID"
    if enabled == 1:
        return "enabled"
    if enabled == 0:
        return "disabled"
    return "INVALID"


def _format_yes_no(value: Any) -> str:
    """
    Decode a REST ``0``/``1`` setting as yes or no.

    :param value: Raw REST setting value.
    :return: ``yes`` for ``1``, ``no`` for ``0``, ``INVALID`` for other
        configured values, and an empty string when the setting is absent.
    """
    if value is None or value == "":
        return ""
    try:
        enabled = int(value)
    except (TypeError, ValueError):
        return "INVALID"
    if enabled == 1:
        return "yes"
    if enabled == 0:
        return "no"
    return "INVALID"


def _sys_id_from_device_ip(value: Any) -> str:
    """
    Derive the MAVLink system ID from the ESP32's current IPv4 address.

    :param value: Discovered ESP32 IP address.
    :return: The last IPv4 octet as a string, or an empty string when the IP is
        missing or malformed.
    """
    try:
        ip_address = ipaddress.ip_address(str(value))
        if not isinstance(ip_address, ipaddress.IPv4Address):
            return ""
        return str(ip_address.packed[-1])
    except ValueError:
        return ""


def _configured_mavlink_sys_id(
    device: dict[str, Any],
    settings: dict[str, Any],
) -> Any:
    """
    Resolve the operator-facing configured MAVLink system ID.

    :param device: Raw discovery record, optionally including observed
        ``sys_id`` or ``mavlink_sys_id`` values from MAVLink discovery.
    :param settings: REST settings object, optionally including
        ``show_en_syid_ip`` and ``show_man_sysid``.
    :return: The best available configured system ID. When
        ``show_en_syid_ip`` is enabled, derive it from the discovered ESP32 IP
        address before considering MAVLink discovery or ``show_man_sysid``.
    """
    if _setting_enabled(settings.get("show_en_syid_ip")):
        device_ip_sys_id = _sys_id_from_device_ip(device.get("ip"))
        if device_ip_sys_id != "":
            return device_ip_sys_id
    observed_sys_id = _first_configured_value(
        device.get("sys_id"),
        device.get("mavlink_sys_id"),
    )
    if observed_sys_id != "":
        return observed_sys_id
    return _first_configured_value(settings.get("show_man_sysid"))


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
    sys_id = _configured_mavlink_sys_id(device, settings)
    return DeviceRecord(
        identity=activation_key or mac.lower() or ip,
        ip=ip,
        hostname=str(settings.get("wifi_hostname") or info.get("hostname") or ""),
        activation_status=str(info.get("license_type") or "discovered"),
        firmware_version=_format_firmware(info, device),
        chip=_format_chip(info.get("esp_chip_model")),
        dronebridge_version=str(
            info.get("db_build_version")
            or device.get("middleware_sw_version")
            or ""
        ),
        mavlink_sys_id=str(sys_id),
        dlse_mode=_format_esp32_mode(settings.get("esp32_mode")),
        baud=_setting_text(settings.get("baud")),
        gpio_cts=_setting_text(settings.get("gpio_cts")),
        gpio_rts=_setting_text(settings.get("gpio_rts")),
        gpio_tx=_setting_text(settings.get("gpio_tx")),
        gpio_rx=_setting_text(settings.get("gpio_rx")),
        led_cont_en=_format_enabled_disabled(settings.get("led_cont_en")),
        adc_a_en=_format_enabled_disabled(settings.get("adc_a_en")),
        adc_v_en=_format_enabled_disabled(settings.get("adc_v_en")),
        dlse_local_udp_port=_setting_text(settings.get("udp_local_port")),
        dlse_remote_udp_port=_setting_text(settings.get("wifi_brcst_port")),
        power_mgmt=_format_enabled_disabled(settings.get("show_pm_en")),
        dlse_mavlink_heartbeat=_format_enabled_disabled(settings.get("show_pm_en_hb")),
        dlse_mavlink_sys_id_based_on_ip=_format_yes_no(settings.get("show_en_syid_ip")),
        fc_sys_id=_format_fc_sys_id(stats.get("fc_sysid")),
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


def _format_fc_sys_id(value: Any) -> str:
    """
    Format the flight-controller MAVLink system ID reported by DLSE statistics.

    :param value: Raw ``fc_sysid`` value from ``/api/system/stats``.
    :return: A valid MAVLink system ID from ``1`` through ``255`` as text.
        The firmware's ``-1`` unknown sentinel, zero, missing values, booleans,
        malformed values, and values outside the valid range return ``"unknown"``.
    """
    if isinstance(value, bool) or (
        isinstance(value, float) and not value.is_integer()
    ):
        return "unknown"
    try:
        sys_id = int(value)
    except (TypeError, ValueError):
        return "unknown"
    return str(sys_id) if 1 <= sys_id <= 255 else "unknown"


def _counter_rate(
    previous: dict[str, Any],
    current: dict[str, Any],
    key: str,
    elapsed: float | None,
) -> float | None:
    """
    Calculate a non-negative counter delta per second.

    :param previous: Previous successful runtime statistics payload.
    :param current: Current successful runtime statistics payload.
    :param key: Counter field to compare between payloads.
    :param elapsed: Monotonic seconds between successful samples.
    :return: Counter units per second, or ``None`` until two valid increasing
        samples exist. A decreasing counter is treated as a device reset.
    """
    if elapsed is None or elapsed <= 0 or key not in previous or key not in current:
        return None
    old_value = previous[key]
    new_value = current[key]
    if isinstance(old_value, bool) or isinstance(new_value, bool):
        return None
    try:
        delta = float(new_value) - float(old_value)
    except (TypeError, ValueError):
        return None
    if delta < 0:
        return None
    return delta / elapsed


def _format_chip(chip_id: Any) -> str:
    """
    Decode a REST API ESP32 chip ID into the library's supported chip name.

    :param chip_id: Raw ``esp_chip_model`` value from ``/api/system/info``.
    :return: The decoded chip string, such as ``ESP32C5``. Missing, malformed,
        or unsupported chip IDs return an empty string.
    """
    try:
        return DLSESupportedChips(int(chip_id)).name
    except (TypeError, ValueError):
        return ""


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

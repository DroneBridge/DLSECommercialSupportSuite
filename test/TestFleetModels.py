"""Tests for Fleet Manager inventory semantics."""

import unittest
from datetime import datetime, timedelta

from PySide6.QtCore import Qt

from ui.models import (
    DeviceCardModel,
    DeviceFilterProxyModel,
    DeviceRecord,
    DeviceTableModel,
    record_from_discovery,
)


class TestFleetModels(unittest.TestCase):
    """Verify identity upgrades and offline retention."""

    def test_identity_upgrades_from_ip_to_activation_key(self):
        """REST hydration upgrades an IP fallback identity without duplicating the row."""
        model = DeviceTableModel()
        model.upsert_many([DeviceRecord(identity="192.168.1.42", ip="192.168.1.42")])
        model.upsert_many([
            DeviceRecord(
                identity="KEY-42", ip="192.168.1.42", activation_key="KEY-42", mac="AA:BB"
            )
        ])
        self.assertEqual(1, model.rowCount())
        self.assertEqual("KEY-42", model.record_at(0).identity)

    def test_device_becomes_offline_after_three_failed_stats_attempts(self):
        """Session records remain present but become offline after three failures."""
        model = DeviceTableModel()
        model.upsert_many([
            DeviceRecord(
                identity="KEY",
                ip="192.168.1.42",
                activation_key="KEY",
            )
        ])
        for _ in range(3):
            model.apply_stats_result("KEY", False, error="offline")
        self.assertEqual(1, model.rowCount())
        self.assertFalse(model.record_at(0).online)

    def test_system_info_refresh_updates_activation_status_and_preserves_it_on_failure(self):
        """A post-operation info result updates status while failures retain prior values."""
        model = DeviceTableModel()
        model.upsert_many([
            DeviceRecord(
                identity="KEY",
                ip="192.168.1.42",
                activation_key="KEY",
                activation_status="EVALUATION",
                firmware_version="1.0.0",
            )
        ])

        model.apply_system_info_result(
            "KEY",
            True,
            {
                "license_type": "ACTIVATED",
                "major_version": 1,
                "minor_version": 2,
                "patch_version": 3,
                "maturity_version": "release",
            },
        )

        record = model.record_by_identity("KEY")
        self.assertEqual("ACTIVATED", record.activation_status)
        self.assertEqual("1.2.3-release", record.firmware_version)
        self.assertEqual("ACTIVATED", record.system_info["license_type"])

        model.apply_system_info_result(
            "KEY",
            False,
            error="request timed out",
        )

        self.assertEqual("ACTIVATED", record.activation_status)
        self.assertEqual("request timed out", record.errors["system_info"])

    def test_settings_refresh_updates_table_projection_and_preserves_values_on_failure(self):
        """A refreshed settings payload updates setting columns and failure diagnostics."""
        record = DeviceRecord(
            identity="KEY",
            ip="192.168.1.42",
            activation_key="KEY",
            hostname="Old",
            dlse_mode="ACCESS POINT",
            baud="115200",
            wifi_channel="6",
            settings={
                "wifi_hostname": "Old",
                "esp32_mode": 1,
                "baud": 115200,
                "wifi_chan": 6,
            },
        )
        model = DeviceTableModel()
        model.upsert_many([record])

        model.apply_settings_result(
            "KEY",
            True,
            {
                "wifi_hostname": "New",
                "esp32_mode": 2,
                "baud": 921600,
                "udp_local_port": 14555,
                "wifi_chan": 7,
                "show_en_syid_ip": 1,
            },
            ip="192.168.1.77",
        )

        refreshed = model.record_by_identity("KEY")
        self.assertEqual("192.168.1.77", refreshed.ip)
        self.assertEqual("New", refreshed.hostname)
        self.assertEqual("CLIENT", refreshed.dlse_mode)
        self.assertEqual("921600", refreshed.baud)
        self.assertEqual("7", refreshed.wifi_channel)
        self.assertEqual("77", refreshed.mavlink_sys_id)
        self.assertEqual(14555, refreshed.settings["udp_local_port"])

        model.apply_settings_result("KEY", False, error="device rebooting")

        self.assertEqual("New", refreshed.hostname)
        self.assertEqual("device rebooting", refreshed.errors["settings"])

    def test_stats_failure_threshold_is_configurable(self):
        """The configured attempt threshold controls the offline transition."""
        model = DeviceTableModel()
        model.upsert_many([
            DeviceRecord(
                identity="KEY",
                ip="192.168.1.42",
                activation_key="KEY",
            )
        ])

        model.apply_stats_result(
            "KEY",
            False,
            error="offline",
            failure_threshold=1,
        )

        self.assertFalse(model.record_at(0).online)

    def test_successful_stats_poll_restores_online_state_and_updates_metrics(self):
        """A successful stats response resets failures and refreshes derived fields."""
        model = DeviceTableModel()
        record = DeviceRecord(
            identity="KEY",
            ip="192.168.1.42",
            activation_key="KEY",
        )
        record.online = False
        record.consecutive_stats_failures = 3
        model.upsert_many([record])

        model.apply_stats_result(
            "KEY",
            True,
            {"esp_rssi": -51, "battery_voltage": 15.8, "fc_sysid": 3},
        )

        updated = model.record_at(0)
        self.assertTrue(updated.online)
        self.assertEqual(0, updated.consecutive_stats_failures)
        self.assertEqual("-51", updated.rssi)
        self.assertEqual("15.8", updated.battery_voltage)
        self.assertEqual("3", updated.fc_sys_id)

    def test_stats_poll_calculates_directional_rates_and_resets_baseline(self):
        """Successful counter samples produce rates and tolerate device resets."""
        model = DeviceTableModel()
        model.upsert_many([
            DeviceRecord(
                identity="KEY",
                ip="192.168.1.42",
                activation_key="KEY",
            )
        ])

        model.apply_stats_result(
            "KEY",
            True,
            {"read_bytes": 1000, "serial_bytes_sent": 500},
            sampled_at=10.0,
        )
        record = model.record_at(0)
        self.assertIsNone(record.stats_rates["read_bytes"])
        self.assertIsNone(record.stats_rates["serial_bytes_sent"])

        model.apply_stats_result(
            "KEY",
            True,
            {"read_bytes": 3048, "serial_bytes_sent": 1524},
            sampled_at=12.0,
        )
        self.assertEqual(1024.0, record.stats_rates["read_bytes"])
        self.assertEqual(512.0, record.stats_rates["serial_bytes_sent"])

        model.apply_stats_result(
            "KEY",
            True,
            {"read_bytes": 10, "serial_bytes_sent": 5},
            sampled_at=14.0,
        )
        self.assertIsNone(record.stats_rates["read_bytes"])
        self.assertIsNone(record.stats_rates["serial_bytes_sent"])

        model.apply_stats_result(
            "KEY",
            True,
            {"read_bytes": 522, "serial_bytes_sent": 261},
            sampled_at=16.0,
        )
        self.assertEqual(256.0, record.stats_rates["read_bytes"])
        self.assertEqual(128.0, record.stats_rates["serial_bytes_sent"])

    def test_stats_poll_rejects_invalid_rate_samples(self):
        """Missing, malformed, boolean, and zero-time counters have no rate."""
        model = DeviceTableModel()
        model.upsert_many([
            DeviceRecord(
                identity="KEY",
                ip="192.168.1.42",
                activation_key="KEY",
            )
        ])
        model.apply_stats_result(
            "KEY",
            True,
            {"read_bytes": 10, "serial_bytes_sent": 5},
            sampled_at=10.0,
        )
        model.apply_stats_result(
            "KEY",
            True,
            {"read_bytes": True, "serial_bytes_sent": "bad"},
            sampled_at=10.0,
        )
        record = model.record_at(0)
        self.assertIsNone(record.stats_rates["read_bytes"])
        self.assertIsNone(record.stats_rates["serial_bytes_sent"])

    def test_fc_mavlink_sys_id_uses_the_stats_api_contract(self):
        """Only API values 1 through 255 produce a visible FC MAVLink SYS ID."""
        model = DeviceTableModel()
        model.upsert_many([
            DeviceRecord(
                identity="KEY",
                ip="192.168.1.42",
                activation_key="KEY",
            )
        ])

        for raw_value, expected in (
            (-1, "unknown"),
            (0, "unknown"),
            (1, "1"),
            (255, "255"),
            (256, "unknown"),
            ("invalid", "unknown"),
            (None, "unknown"),
        ):
            model.apply_stats_result("KEY", True, {"fc_sysid": raw_value})
            self.assertEqual(expected, model.record_at(0).fc_sys_id)

        model.apply_stats_result("KEY", True, {"fc_sys_id": 42})
        self.assertEqual("unknown", model.record_at(0).fc_sys_id)

    def test_fc_sys_id_mismatch_role_compares_known_numeric_ids(self):
        """Only a known, numerically different FC SYS ID triggers the warning."""
        model = DeviceTableModel()
        model.set_visible_columns(["mavlink_sys_id", "fc_sys_id"])
        model.upsert_many([
            DeviceRecord(
                identity="MATCH",
                ip="192.168.1.2",
                mavlink_sys_id="03",
                fc_sys_id="3",
            ),
            DeviceRecord(
                identity="MISMATCH",
                ip="192.168.1.3",
                mavlink_sys_id="4",
                fc_sys_id="3",
            ),
            DeviceRecord(
                identity="UNKNOWN",
                ip="192.168.1.4",
                mavlink_sys_id="4",
                fc_sys_id="unknown",
            ),
        ])

        self.assertFalse(model.record_at(0).fc_sys_id_mismatch)
        self.assertTrue(model.record_at(1).fc_sys_id_mismatch)
        self.assertFalse(model.record_at(2).fc_sys_id_mismatch)
        self.assertEqual(
            b"fcSysIdMismatch",
            model.roleNames()[DeviceTableModel.FcSysIdMismatchRole],
        )
        self.assertTrue(
            model.index(1, 1).data(DeviceTableModel.FcSysIdMismatchRole)
        )

    def test_discovery_merge_does_not_reset_stats_health(self):
        """Rediscovery refreshes inventory data without changing stats health."""
        model = DeviceTableModel()
        record = DeviceRecord(identity="KEY", ip="192.168.1.42")
        record.online = False
        record.consecutive_stats_failures = 3
        record.stats = {"esp_rssi": -80}
        record.rssi = "-80"
        model.upsert_many([record])

        model.upsert_many([
            DeviceRecord(
                identity="KEY",
                ip="192.168.1.42",
                hostname="rediscovered",
                stats={"esp_rssi": -20},
                rssi="-20",
            )
        ])

        updated = model.record_at(0)
        self.assertFalse(updated.online)
        self.assertEqual(3, updated.consecutive_stats_failures)
        self.assertEqual({"esp_rssi": -80}, updated.stats)
        self.assertEqual("-80", updated.rssi)
        self.assertEqual("rediscovered", updated.hostname)

    def test_reboot_grace_suppresses_stats_failure_counting(self):
        """Failed polls during reboot grace do not move a device toward offline."""
        model = DeviceTableModel()
        model.upsert_many([
            DeviceRecord(
                identity="KEY",
                ip="192.168.1.42",
                activation_key="KEY",
            )
        ])
        model.set_reboot_grace({"KEY"}, seconds=20)

        model.apply_stats_result("KEY", False, error="rebooting")

        record = model.record_at(0)
        self.assertTrue(record.online)
        self.assertEqual(0, record.consecutive_stats_failures)
        record.offline_grace_until = datetime.now() - timedelta(seconds=1)
        model.apply_stats_result("KEY", False, error="offline")
        self.assertEqual(1, record.consecutive_stats_failures)

    def test_additive_discovery_does_not_replace_absent_devices(self):
        """A later discovery batch adds or merges without removing prior rows."""
        model = DeviceTableModel()
        model.upsert_many([
            DeviceRecord(identity="A", ip="192.168.1.2", activation_key="A"),
        ])

        model.upsert_many([
            DeviceRecord(identity="B", ip="192.168.1.3", activation_key="B"),
        ])

        self.assertEqual(2, model.rowCount())
        self.assertIsNotNone(model.record_by_identity("A"))
        self.assertIsNotNone(model.record_by_identity("B"))

    def test_complete_activation_key_is_searchable_and_stored(self):
        """Activation keys are retained in full rather than masked."""
        model = DeviceTableModel()
        key = "FULL-ACTIVATION-KEY-123"
        model.upsert_many([DeviceRecord(identity=key, ip="192.168.1.42", activation_key=key)])
        self.assertIn(key.lower(), model.record_at(0).searchable_text)
        self.assertEqual(key, model.record_at(0).activation_key)

    def test_inventory_accepts_five_thousand_records(self):
        """The model stores the required fleet size without per-row widgets."""
        model = DeviceTableModel()
        model.upsert_many([
            DeviceRecord(identity=f"KEY-{index}", ip=f"10.{index // 65536}.{index // 256 % 256}.{index % 256}")
            for index in range(5000)
        ])
        self.assertEqual(5000, model.rowCount())

    def test_qml_roles_expose_complete_activation_key(self):
        """Named QML roles expose full operator-visible activation keys."""
        model = DeviceTableModel()
        model.upsert_many([
            DeviceRecord(
                identity="FULL-KEY",
                ip="192.168.1.42",
                activation_key="FULL-KEY",
            )
        ])
        index = model.index(0, 0)
        self.assertEqual(
            "FULL-KEY",
            index.data(DeviceTableModel.ActivationKeyRole),
        )
        self.assertEqual(b"activationKey", model.roleNames()[DeviceTableModel.ActivationKeyRole])

    def test_filter_and_card_projection_share_record_roles(self):
        """Table filtering is reflected by the virtualized matrix projection."""
        model = DeviceTableModel()
        proxy = DeviceFilterProxyModel()
        proxy.setSourceModel(model)
        cards = DeviceCardModel(proxy)
        model.upsert_many([
            DeviceRecord(identity="A", ip="10.0.0.1", hostname="Alpha"),
            DeviceRecord(identity="B", ip="10.0.0.2", hostname="Bravo"),
        ])
        proxy.setFilterText("bravo")
        self.assertEqual(1, proxy.rowCount())
        self.assertEqual(1, cards.rowCount())
        self.assertEqual(
            "Bravo",
            cards.index(0, 0).data(DeviceTableModel.HostnameRole),
        )

    def test_selection_is_stored_on_inventory_records(self):
        """QML table and matrix views share one identity-based selection state."""
        model = DeviceTableModel()
        model.upsert_many([
            DeviceRecord(
                identity="A",
                ip="10.0.0.1",
                activation_key="A",
            )
        ])
        model.set_selected("A", True)
        self.assertTrue(model.selected_records()[0].selected)
        self.assertTrue(model.index(0, 0).data(DeviceTableModel.SelectedRole))

    def test_column_projection_keeps_selection_column(self):
        """Configured data columns retain the non-configurable selection column."""
        model = DeviceTableModel()
        model.set_visible_columns(["ip", "activation_key"])
        self.assertEqual(3, model.columnCount())
        self.assertEqual("selected", model.column_key(0))
        self.assertEqual("ip", model.column_key(1))
        self.assertEqual("activation_key", model.column_key(2))

    def test_column_projection_preserves_custom_order_without_duplicates(self):
        """Configured data columns keep user order and ignore repeated keys."""
        model = DeviceTableModel()
        model.set_visible_columns(["rssi", "ip", "rssi", "unknown", "hostname"])

        self.assertEqual(["rssi", "ip", "hostname"], model.visible_column_keys())
        self.assertEqual("rssi", model.column_key(1))
        self.assertEqual("ip", model.column_key(2))
        self.assertEqual("hostname", model.column_key(3))

    def test_rssi_display_includes_dbm_unit(self):
        """The table display value adds the RSSI unit while roles stay raw."""
        model = DeviceTableModel()
        model.set_visible_columns(["rssi"])
        model.upsert_many([
            DeviceRecord(identity="A", ip="10.0.0.1", rssi="-64"),
        ])

        index = model.index(0, 1)

        self.assertEqual("-64 dBm", index.data(Qt.DisplayRole))
        self.assertEqual("-64", index.data(DeviceTableModel.RssiRole))

    def test_rest_chip_id_is_decoded_to_chip_column(self):
        """REST system info chip IDs are exposed as supported chip names."""
        record = record_from_discovery(
            {
                "ip": "10.0.0.1",
                "system_info": {"esp_chip_model": 23},
            },
            "rest",
        )
        model = DeviceTableModel()
        model.set_visible_columns(["chip"])
        model.upsert_many([record])

        index = model.index(0, 1)

        self.assertEqual("ESP32C5", index.data(Qt.DisplayRole))
        self.assertEqual("ESP32C5", index.data(DeviceTableModel.ChipRole))

    def test_dronebridge_version_column_is_labeled_build_version(self):
        """The middleware build field uses the operator-facing Build Version title."""
        self.assertEqual(
            "DLSE BUILD\nVERSION",
            DeviceTableModel.column_definition("dronebridge_version")[1],
        )

    def test_mavlink_sys_id_column_is_labeled_configured_sys_id(self):
        """The MAVLink system ID column identifies the configured DLSE value."""
        self.assertEqual(
            "DLSE CONFIGURED\nMAVLINK SYS ID",
            DeviceTableModel.column_definition("mavlink_sys_id")[1],
        )

    def test_fc_mavlink_sys_id_column_is_default_and_labeled(self):
        """The REST-backed flight-controller SYS ID is a default table column."""
        self.assertEqual(
            "FC MAVLINK\nSYS ID",
            DeviceTableModel.column_definition("fc_sys_id")[1],
        )
        self.assertEqual(
            "fc_sys_id",
            DeviceTableModel.DEFAULT_COLUMN_KEYS[
                DeviceTableModel.DEFAULT_COLUMN_KEYS.index("mavlink_sys_id") + 1
            ],
        )

    def test_online_column_identifies_the_esp32(self):
        """The online column title distinguishes ESP32 health from FC status."""
        self.assertEqual(
            "ESP\nONLINE",
            DeviceTableModel.column_definition("online")[1],
        )

    def test_rest_record_formats_fc_mavlink_sys_id(self):
        """Initial REST hydration formats the firmware's FC SYS ID sentinel."""
        known = record_from_discovery(
            {"ip": "192.168.1.88", "stats": {"fc_sysid": 255}},
            "rest",
        )
        unknown = record_from_discovery(
            {"ip": "192.168.1.89", "stats": {"fc_sysid": -1}},
            "rest",
        )

        self.assertEqual("255", known.fc_sys_id)
        self.assertEqual("unknown", unknown.fc_sys_id)

    def test_rest_record_uses_discovered_ip_sys_id_when_enabled(self):
        """IP-based SYS IDs use the current ESP32 address, not static settings."""
        record = record_from_discovery(
            {
                "ip": "192.168.1.88",
                "settings": {
                    "show_en_syid_ip": 1,
                    "ip_sta": "192.168.50.42",
                    "show_man_sysid": 7,
                },
            },
            "rest",
        )

        self.assertEqual("88", record.mavlink_sys_id)

        dynamic_record = record_from_discovery(
            {
                "ip": "192.168.1.89",
                "settings": {
                    "show_en_syid_ip": 1,
                    "ip_sta": "",
                    "show_man_sysid": 7,
                },
            },
            "rest",
        )

        self.assertEqual("89", dynamic_record.mavlink_sys_id)

    def test_rest_record_preserves_manual_zero_sys_id_when_ip_sys_id_disabled(self):
        """Manual MAVLink system ID zero is not dropped by fallback handling."""
        record = record_from_discovery(
            {
                "ip": "192.168.1.88",
                "settings": {
                    "show_en_syid_ip": 0,
                    "ip_sta": "192.168.50.42",
                    "show_man_sysid": 0,
                },
            },
            "rest",
        )

        self.assertEqual("0", record.mavlink_sys_id)

    def test_ip_based_sys_id_takes_precedence_over_mavlink_discovery(self):
        """Configured IP-based SYS IDs use the ESP32 IP despite a discovery reply."""
        record = record_from_discovery(
            {
                "ip": "192.168.1.88",
                "sys_id": 99,
                "settings": {
                    "show_en_syid_ip": 1,
                    "ip_sta": "192.168.50.42",
                    "show_man_sysid": 7,
                },
            },
            "mavlink",
        )

        self.assertEqual("88", record.mavlink_sys_id)

    def test_rest_settings_columns_are_available_with_requested_labels(self):
        """REST API settings are exposed as configurable table columns."""
        expected = {
            "dlse_mode": "DLSE MODE",
            "baud": "BAUD",
            "dlse_local_udp_port": "DLSE LOCAL\nUDP PORT",
            "dlse_remote_udp_port": "DLSE REMOTE\nUDP PORT",
            "power_mgmt": "POWER\nMGMT",
            "dlse_mavlink_heartbeat": "DLSE MAVLINK\nHEARTBEAT",
            "dlse_mavlink_sys_id_based_on_ip": "DLSE MAVLINK\nSYS ID BASED ON IP",
        }

        for key, label in expected.items():
            self.assertEqual(label, DeviceTableModel.column_definition(key)[1])

    def test_rest_settings_columns_are_populated_from_hydrated_settings(self):
        """Hydrated REST settings populate the additional operator columns."""
        record = record_from_discovery(
            {
                "ip": "192.168.1.88",
                "settings": {
                    "esp32_mode": 2,
                    "baud": 921600,
                    "udp_local_port": 14555,
                    "wifi_brcst_port": 14550,
                    "show_pm_en": 1,
                    "show_pm_en_hb": 0,
                    "show_en_syid_ip": 1,
                },
            },
            "rest",
        )

        self.assertEqual("CLIENT", record.dlse_mode)
        self.assertEqual("921600", record.baud)
        self.assertEqual("14555", record.dlse_local_udp_port)
        self.assertEqual("14550", record.dlse_remote_udp_port)
        self.assertEqual("enabled", record.power_mgmt)
        self.assertEqual("disabled", record.dlse_mavlink_heartbeat)
        self.assertEqual("yes", record.dlse_mavlink_sys_id_based_on_ip)

    def test_rest_settings_columns_are_exposed_as_qml_roles(self):
        """QML delegates can read REST setting columns from any table cell."""
        record = record_from_discovery(
            {
                "ip": "192.168.1.88",
                "settings": {
                    "esp32_mode": 1,
                    "baud": 921600,
                    "udp_local_port": 14555,
                    "wifi_brcst_port": 14550,
                    "show_pm_en": 0,
                    "show_pm_en_hb": 1,
                    "show_en_syid_ip": 0,
                },
            },
            "rest",
        )
        model = DeviceTableModel()
        model.upsert_many([record])
        index = model.index(0, 0)

        self.assertEqual(b"dlseMode", model.roleNames()[DeviceTableModel.DlseModeRole])
        self.assertEqual("ACCESS POINT", index.data(DeviceTableModel.DlseModeRole))
        self.assertEqual("disabled", index.data(DeviceTableModel.PowerMgmtRole))
        self.assertEqual("enabled", index.data(DeviceTableModel.DlseMavlinkHeartbeatRole))

    def test_rest_settings_columns_decode_access_point_disabled_and_no_values(self):
        """Mode, power management, and sys-id source settings decode both states."""
        record = record_from_discovery(
            {
                "ip": "192.168.1.88",
                "settings": {
                    "esp32_mode": "1",
                    "show_pm_en": "0",
                    "show_en_syid_ip": "0",
                },
            },
            "rest",
        )

        self.assertEqual("ACCESS POINT", record.dlse_mode)
        self.assertEqual("disabled", record.power_mgmt)
        self.assertEqual("no", record.dlse_mavlink_sys_id_based_on_ip)

    def test_rest_settings_columns_mark_invalid_modes(self):
        """Unsupported ESP32 mode values are shown as invalid."""
        record = record_from_discovery(
            {
                "ip": "192.168.1.88",
                "settings": {"esp32_mode": 3},
            },
            "rest",
        )

        self.assertEqual("INVALID", record.dlse_mode)


if __name__ == "__main__":
    unittest.main()

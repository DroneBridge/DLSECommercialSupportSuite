"""Tests for Fleet Manager inventory semantics."""

import unittest
from datetime import datetime, timedelta

from PySide6.QtCore import Qt

from ui.models import (
    DeviceCardModel,
    DeviceFilterProxyModel,
    DeviceRecord,
    DeviceTableModel,
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
            {"esp_rssi": -51, "battery_voltage": 15.8, "fc_sys_id": 3},
        )

        updated = model.record_at(0)
        self.assertTrue(updated.online)
        self.assertEqual(0, updated.consecutive_stats_failures)
        self.assertEqual("-51", updated.rssi)
        self.assertEqual("15.8", updated.battery_voltage)
        self.assertEqual("3", updated.fc_sys_id)

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

    def test_dronebridge_version_column_is_labeled_build_version(self):
        """The middleware build field uses the operator-facing Build Version title."""
        self.assertEqual(
            "BUILD VERSION",
            DeviceTableModel.column_definition("dronebridge_version")[1],
        )


if __name__ == "__main__":
    unittest.main()

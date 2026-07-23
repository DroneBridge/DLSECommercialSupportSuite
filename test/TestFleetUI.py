"""Offscreen Qt Quick tests for the QML Fleet Manager shell."""

import os
import tempfile
import unittest
from pathlib import Path
from unittest.mock import Mock, patch

os.environ.setdefault("QT_QPA_PLATFORM", "offscreen")
os.environ.setdefault("QTWEBENGINE_DISABLE_SANDBOX", "1")
os.environ.setdefault("QT_QUICK_CONTROLS_STYLE", "Basic")

from PySide6.QtCore import QMetaObject, QPoint, QPointF, QSettings, Qt, QUrl
from PySide6.QtGui import QColor, QGuiApplication
from PySide6.QtQuick import QQuickItem
from PySide6.QtQml import QQmlComponent
from PySide6.QtTest import QTest

from DroneBridgeCommercialSupportSuite import DBDLSERelease
from ui.app import create_engine
from ui.controller import (
    DEFAULT_BULK_EXCLUSIONS,
    DEFAULT_INSPECTOR_WIDTH,
    MAX_INSPECTOR_WIDTH,
    MAX_COLUMN_WIDTH,
    MIN_INSPECTOR_WIDTH,
    MIN_COLUMN_WIDTH,
    FleetController,
)
from ui.models import DeviceRecord, DeviceTableModel


class TestFleetUI(unittest.TestCase):
    """Verify the QML shell and controller contract without visible windows."""

    QML_ROOT = Path(__file__).resolve().parents[1] / "ui" / "qml"

    @classmethod
    def setUpClass(cls):
        """Create one QGuiApplication and isolated persistent settings path."""
        cls.temp_settings = tempfile.TemporaryDirectory()
        QSettings.setDefaultFormat(QSettings.IniFormat)
        QSettings.setPath(
            QSettings.IniFormat,
            QSettings.UserScope,
            cls.temp_settings.name,
        )
        cls.app = QGuiApplication.instance() or QGuiApplication([])

    @classmethod
    def tearDownClass(cls):
        """Release the temporary QSettings directory."""
        cls.temp_settings.cleanup()

    def setUp(self):
        """Load a fresh QML engine while suppressing the startup server check."""
        settings_path = Path(self.temp_settings.name) / f"{self.id()}.ini"
        self._test_settings = QSettings(str(settings_path), QSettings.IniFormat)
        with (
            patch("ui.controller.QSettings", return_value=self._test_settings),
            patch("ui.controller.QTimer.singleShot"),
        ):
            self.engine, self.controller = create_engine()
        self.controller.license_timer.stop()
        self.controller.scan_timer.stop()
        self.controller.stats_timer.stop()
        self.root = self.engine.rootObjects()[0]
        self._standalone_components = []

    def tearDown(self):
        """Destroy the QML root and process deferred deletion."""
        self.root.close()
        self.engine.clearComponentCache()
        self.app.processEvents()
        self._standalone_components.clear()

    def _create_qml_component(self, name):
        """Create a standalone QML component or fail with its load errors."""
        component = QQmlComponent(
            self.engine,
            QUrl.fromLocalFile(str(self.QML_ROOT / name)),
        )
        instance = component.create()
        self.assertIsNotNone(
            instance,
            "\n".join(error.toString() for error in component.errors()),
        )
        self._standalone_components.append((component, instance))
        return instance

    def _enter_main_screen(self):
        """Navigate from the start page to the fleet manager screen."""
        start = self.root.findChild(object, "startScreen")
        self.assertTrue(
            QMetaObject.invokeMethod(
                start,
                "directStandaloneRequested",
                Qt.DirectConnection,
            )
        )
        self.app.processEvents()

    def _click_item(self, item):
        """Click the center of a QML item in the offscreen window."""
        scene_position = item.mapToScene(QPointF(item.width() / 2, item.height() / 2))
        QTest.mouseClick(
            self.root,
            Qt.LeftButton,
            Qt.NoModifier,
            QPoint(round(scene_position.x()), round(scene_position.y())),
        )
        self.app.processEvents()

    @staticmethod
    def _color_name(value, alpha=False):
        """Return a stable lowercase RGB or ARGB string for a Qt color value."""
        color = QColor(value)
        mode = QColor.HexArgb if alpha else QColor.HexRgb
        return color.name(mode).lower()

    def test_shell_contains_start_and_fleet_pages(self):
        """The application loads both exported-design screens under App.qml."""
        self.assertIsNotNone(self.root.findChild(object, "startScreen"))
        self.assertIsNotNone(self.root.findChild(object, "mainScreen"))
        self.assertIsNotNone(self.root.findChild(object, "fleetTable"))
        self.assertIsNotNone(self.root.findChild(object, "fleetMatrix"))
        self.assertEqual(1298, self.root.width())
        self.assertEqual(804, self.root.height())

    def test_direct_standalone_navigation_signal_is_live(self):
        """The start-screen Direct Standalone signal navigates without widgets."""
        self._enter_main_screen()
        self.assertIsNotNone(self.root.findChild(object, "configPanel"))

    def test_standalone_mode_badge_returns_to_start(self):
        """Standalone Mode, not the logo, navigates back to the start screen."""
        self._enter_main_screen()
        main_screen = self.root.findChild(QQuickItem, "mainScreen")
        standalone_button = self.root.findChild(QQuickItem, "standaloneModeButton")
        self.assertTrue(main_screen.isVisible())
        self.assertIsNotNone(standalone_button)

        self._click_item(standalone_button)

        self.assertFalse(main_screen.isVisible())

    def test_scan_toolbar_uses_exported_segmented_controls(self):
        """The scan toolbar renders the original exported scan components."""
        self._enter_main_screen()
        scan_button = self.root.findChild(QQuickItem, "scanButton")
        scan_settings = self.root.findChild(QQuickItem, "scanSettingsButton")

        self.assertIsNotNone(scan_button)
        self.assertIsNotNone(scan_settings)
        radar_icon = scan_button.findChild(QQuickItem, "radarIcon")
        settings_icon = scan_settings.findChild(QQuickItem, "settingsIcon")
        self.assertIsNotNone(radar_icon)
        self.assertIsNotNone(settings_icon)
        self.assertEqual(20, radar_icon.width())
        self.assertEqual(20, radar_icon.height())
        self.assertEqual(20, settings_icon.width())
        self.assertEqual(20, settings_icon.height())
        self.assertIn(
            'fill="#e2d5c8"',
            (self.QML_ROOT.parent / "resources" / "images" / "radar_24dp.svg").read_text(encoding="utf-8"),
        )
        self.assertIn(
            'fill="#e2d5c8"',
            (self.QML_ROOT.parent / "resources" / "images" / "settings_24dp.svg").read_text(encoding="utf-8"),
        )
        self.assertEqual(154, scan_button.width())
        self.assertEqual(30, scan_button.height())
        self.assertEqual(36, scan_settings.width())
        self.assertEqual(30, scan_settings.height())
        self.assertEqual(0, scan_button.property("eigenschaft_2"))
        self.assertEqual(0, scan_settings.property("eigenschaft_2"))
        self.assertEqual("Scan for Devices", scan_button.property("labelText"))

    def test_scan_exported_button_toggles_discovery(self):
        """Clicking the exported scan segment invokes the scan workflow."""
        self._enter_main_screen()
        self.controller.pool.start = Mock()
        scan_button = self.root.findChild(QQuickItem, "scanButton")

        self._click_item(scan_button)

        self.assertTrue(self.controller.scanning)
        self.controller.pool.start.assert_called_once()
        self.assertEqual(2, scan_button.property("eigenschaft_2"))
        self.assertEqual("Scanning ...", scan_button.property("labelText"))

    def test_scan_settings_exported_button_opens_dialog(self):
        """Clicking the exported settings segment opens scan settings."""
        self._enter_main_screen()
        scan_settings = self.root.findChild(QQuickItem, "scanSettingsButton")
        scan_dialog = self.root.findChild(object, "scanDialog")
        self.assertFalse(scan_dialog.property("opened"))

        self._click_item(scan_settings)

        self.assertTrue(scan_dialog.property("opened"))
        source = (self.QML_ROOT / "FleetDialogs.qml").read_text(encoding="utf-8")
        self.assertIn("SYSTEM STATS POLLING  /api/system/stats", source)
        self.assertIn("statsEnabledCheck.checked", source)
        self.assertIn("statsFailureThresholdField", source)

    def test_operation_toolbar_uses_exported_buttons(self):
        """Fleet operations render with the exported button frame controls."""
        self._enter_main_screen()
        expected = {
            "rebootButton": ("Reboot Devices", 150, 100, False),
            "assignStaticIpButton": ("Assign Static IPs", 170, 130, False),
            "alignSysIdsButton": ("Align SYS IDs", 150, 100, False),
            "otaFirmwareButton": ("OTA Firmware Upgrade", 208, 158, False),
            "otaActivationButton": ("OTA DLSE Activation", 190, 140, False),
            "applySettingsButton": ("Apply Settings", 158, 108, False),
        }
        for name, (label, width, label_width, key_icon_visible) in expected.items():
            button = self.root.findChild(QQuickItem, name)
            self.assertIsNotNone(button, name)
            self.assertAlmostEqual(width, button.width(), places=2)
            self.assertEqual(29, button.height())
            self.assertEqual(label, button.property("text_LabelText"))
            self.assertAlmostEqual(label_width, button.property("text_LabelWidth"), places=2)
            self.assertEqual(key_icon_visible, button.property("keyIconVisible"))
            self.assertEqual(0, button.property("eigenschaft_2"))

        source = (self.QML_ROOT / "OTA_Button_1.qml").read_text(encoding="utf-8")
        self.assertIn("property bool keyIconVisible: true", source)
        self.assertIn("visible: oTA_Button.keyIconVisible", source)

        expected_icon_sizes = {
            "restartIcon": 20,
            "formatListNumberedImage": 16,
            "computerArrowIcon": 20,
            "keyIcon": 20,
            "uploadFileIcon": 20,
        }
        for icon_name, expected_size in expected_icon_sizes.items():
            icon = self.root.findChild(QQuickItem, icon_name)
            self.assertIsNotNone(icon, icon_name)
            self.assertAlmostEqual(expected_size, icon.width(), places=2)
            self.assertAlmostEqual(expected_size, icon.height(), places=2)

        for asset_name in (
            "restart_alt_24dp.svg",
            "format_list_numbered.svg",
            "computer_arrow_up_24dp.svg",
            "key_24dp.svg",
            "upload_file_24dp.svg",
        ):
            asset = (self.QML_ROOT.parents[1] / "ui" / "resources" / "images" / asset_name).read_text(
                encoding="utf-8"
            )
            self.assertIn('fill="#e2d5c8"', asset)

    def test_static_ip_assignment_button_opens_documented_dialog(self):
        """The static-IP toolbar action opens its eligible selected-device dialog."""
        self._enter_main_screen()
        self.controller.source_model.upsert_many([
            DeviceRecord(
                identity="A",
                ip="10.0.0.2",
                activation_status="ACTIVATED",
                selected=True,
            )
        ])
        self.app.processEvents()

        button = self.root.findChild(QQuickItem, "assignStaticIpButton")
        dialog = self.root.findChild(object, "staticIpAssignmentDialog")
        self.assertIsNotNone(button)
        self.assertIsNotNone(dialog)
        self.assertTrue(button.isEnabled())
        self.assertFalse(dialog.property("opened"))

        self._click_item(button)

        self.assertTrue(dialog.property("opened"))
        source = (self.QML_ROOT / "FleetDialogs.qml").read_text(encoding="utf-8")
        self.assertIn("Addresses are assigned in the current table order", source)
        self.assertIn("after .254, the third octet increases", source)
        self.assertIn('placeholderText: "e.g. 255.255.255.0"', source)
        self.assertIn('objectName: "staticIpAssignmentDialog"', source)
        dialog.close()

    def test_apply_settings_toolbar_uses_selected_only_csv_import(self):
        """The toolbar settings action imports CSV files for selected devices only."""
        self._enter_main_screen()
        button = self.root.findChild(QQuickItem, "applySettingsButton")

        self.assertIsNotNone(button)

        source = (self.QML_ROOT / "FleetDialogs.qml").read_text(encoding="utf-8")
        self.assertIn("function openApplyCsvToSelected()", source)
        self.assertIn("csvSelectedOnly = true", source)
        self.assertIn(
            'dialogs.csvSelectedOnly || csvScope.currentIndex === 0 ? "selected" : "visible"',
            source,
        )
        self.assertIn('objectName: "importCsvDialog"', source)

    def test_operation_exported_buttons_open_dialogs(self):
        """Clicking restored operation buttons opens the existing QML dialogs."""
        self._enter_main_screen()
        self.controller.source_model.upsert_many([
            DeviceRecord(identity="A", ip="192.168.1.2", activation_key="A")
        ])
        self.app.processEvents()

        for button_name, dialog_name in (
            ("rebootButton", "rebootDialog"),
            ("otaFirmwareButton", "otaDialog"),
            ("otaActivationButton", "activationDialog"),
        ):
            button = self.root.findChild(QQuickItem, button_name)
            dialog = self.root.findChild(object, dialog_name)
            self.assertFalse(dialog.property("opened"), dialog_name)
            self._click_item(button)
            self.assertTrue(dialog.property("opened"), dialog_name)
            dialog.close()
            self.app.processEvents()

    def test_align_sys_ids_button_opens_selected_only_dialog(self):
        """The SYS ID alignment toolbar button opens its selected-device dialog."""
        self._enter_main_screen()
        self.controller.source_model.upsert_many([
            DeviceRecord(
                identity="A",
                ip="192.168.1.2",
                activation_key="A",
                activation_status="ACTIVATED",
                selected=True,
            )
        ])
        self.app.processEvents()
        button = self.root.findChild(QQuickItem, "alignSysIdsButton")
        icon = self.root.findChild(QQuickItem, "syncAltIcon")
        image = self.root.findChild(QQuickItem, "syncAltImage")
        dialog = self.root.findChild(object, "sysIdAlignmentDialog")

        self.assertTrue(button.isEnabled())
        self.assertIsNotNone(icon)
        self.assertIsNotNone(image)
        icon_source = (self.QML_ROOT / "sync_alt.svg").read_text(encoding="utf-8")
        self.assertIn("M280-120 80-320", icon_source)
        self.assertIn('fill="#e2d5c8"', icon_source)
        self.assertEqual(20, image.width())
        self.assertEqual(20, image.height())
        self.assertFalse(dialog.property("opened"))
        self._click_item(button)

        self.assertTrue(dialog.property("opened"))
        source = (self.QML_ROOT / "FleetDialogs.qml").read_text(encoding="utf-8")
        self.assertIn("Only EVALUATION and ACTIVATED devices are processed.", source)
        self.assertIn("Based on DLSE IP address", source)
        self.assertIn("Based on FC SYS ID", source)
        self.assertIn("Based on manual DLSE SYS ID", source)

    def test_view_mode_uses_exported_controls_switch(self):
        """The List/Matrix toggle uses the exported switch and changes views."""
        self._enter_main_screen()
        main_screen = self.root.findChild(object, "mainScreen")
        view_switch = self.root.findChild(QQuickItem, "viewModeSwitch")

        self.assertIsNotNone(view_switch)
        self.assertEqual(128, view_switch.width())
        self.assertEqual(24, view_switch.height())
        self.assertEqual(0, main_screen.property("viewMode"))

        list_icon = view_switch.findChild(QQuickItem, "listViewIcon")
        matrix_icon = view_switch.findChild(QQuickItem, "gridViewIcon")
        self.assertIsNotNone(list_icon)
        self.assertIsNotNone(matrix_icon)
        self.assertEqual(16, list_icon.width())
        self.assertEqual(16, list_icon.height())
        self.assertEqual(16, matrix_icon.width())
        self.assertEqual(16, matrix_icon.height())
        for asset_name in ("list_24dp.svg", "grid_view.svg"):
            asset = (self.QML_ROOT.parents[1] / "ui" / "resources" / "images" / asset_name).read_text(
                encoding="utf-8"
            )
            self.assertIn('fill="#e2d5c8"', asset)

        self._click_item(view_switch)
        self.assertEqual(1, main_screen.property("viewMode"))

        self._click_item(view_switch)
        self.assertEqual(0, main_screen.property("viewMode"))

    def test_header_settings_uses_exported_settings_tab(self):
        """The header settings control uses the exported SettingsTab component."""
        self._enter_main_screen()
        settings_tab = self.root.findChild(QQuickItem, "headerSettingsTab")
        scan_dialog = self.root.findChild(object, "scanDialog")

        self.assertIsNotNone(settings_tab)
        self.assertEqual(48, settings_tab.width())
        self.assertEqual(63, settings_tab.height())
        self.assertEqual(0, settings_tab.property("eigenschaft_2"))

        self._click_item(settings_tab)

        self.assertTrue(scan_dialog.property("opened"))

    def test_fleet_table_uses_horizontal_separators_only(self):
        """Table cells avoid vertical grid lines and headers have no dividers."""
        source = (self.QML_ROOT / "MainScreen.qml").read_text(encoding="utf-8")
        header_block = source[
            source.index("HorizontalHeaderView {"):
            source.index("TableView {")
        ]
        table_block = source[
            source.index("TableView {"):
            source.index("GridView {")
        ]

        self.assertIn("border.width: 0", header_block)
        self.assertNotIn("border.color: theme.border", header_block)
        self.assertIn("border.width: 0", table_block)
        self.assertNotIn("border.color: theme.border", table_block)
        self.assertIn("anchors.bottom: parent.bottom", table_block)
        self.assertIn("height: 1", table_block)

    def test_fleet_table_text_and_rows_match_design(self):
        """Table body uses fixed monospace text and no alternating row colors."""
        source = (self.QML_ROOT / "MainScreen.qml").read_text(encoding="utf-8")
        table_block = source[
            source.index("TableView {"):
            source.index("GridView {")
        ]

        self.assertIn('font.family: "JetBrains Mono"', table_block)
        self.assertIn("font.pixelSize: 10", table_block)
        self.assertIn('color: selected ? "#12304d"', table_block)
        self.assertIn('identity === fleetController.inspectedIdentity ? "#0f253a"', table_block)
        self.assertIn(": theme.background", table_block)
        self.assertNotIn("row %", table_block)
        self.assertNotIn("#091a2a", table_block)

    def test_table_inspection_highlight_differs_from_selection(self):
        """Clicked inspection rows use a highlight distinct from selected rows."""
        self.controller.source_model.upsert_many([
            DeviceRecord(identity="A", ip="192.168.1.2"),
            DeviceRecord(identity="B", ip="192.168.1.3"),
        ])
        self.controller.inspectDevice("A")
        self.assertEqual("A", self.controller.inspectedIdentity)

        source = (self.QML_ROOT / "MainScreen.qml").read_text(encoding="utf-8")
        table_block = source[
            source.index("TableView {"):
            source.index("GridView {")
        ]
        self.assertIn('selected ? "#12304d"', table_block)
        self.assertIn('identity === fleetController.inspectedIdentity ? "#0f253a"', table_block)

    def test_settings_view_uses_editable_table_rows(self):
        """Settings render as parameter/value rows with editable value cells."""
        self._enter_main_screen()
        self.controller.source_model.upsert_many([
            DeviceRecord(
                identity="KEY",
                ip="192.168.1.42",
                activation_key="KEY",
                settings={"wifi_chan": 6, "wifi_enabled": True},
            )
        ])
        self.controller.inspectDevice("KEY")
        self.app.processEvents()

        self.assertIsNotNone(self.root.findChild(QQuickItem, "settingsTable"))

        source = (self.QML_ROOT / "Config.qml").read_text(encoding="utf-8")
        self.assertIn('text: "PARAMETER"', source)
        self.assertIn('text: "VALUE"', source)
        self.assertIn("objectName: \"settingsTable\"", source)
        self.assertIn("fleetController.setSettingValue(modelData.key", source)
        self.assertIn("echoMode: TextInput.Normal", source)
        self.assertNotIn("TextInput.Password", source)
        self.assertNotIn("id: settingsList", source)

    def test_license_server_poll_interval_and_overlap_guard(self):
        """License checks run every ten seconds and cannot overlap."""
        self.assertEqual(10_000, self.controller.license_timer.interval())
        self.controller.pool.start = Mock()
        self.controller.checkLicenseServer()
        self.controller.checkLicenseServer()
        self.controller.pool.start.assert_called_once()

    def test_stats_poll_interval_and_overlap_guard(self):
        """Stats rounds target two seconds and cannot overlap."""
        self.assertEqual(2_000, self.controller.stats_timer.interval())
        self.controller.source_model.upsert_many([
            DeviceRecord(identity="A", ip="192.168.1.2"),
            DeviceRecord(identity="B", ip="192.168.1.3"),
        ])
        self.controller.pool.start = Mock()

        self.controller.startStatsPolling()
        self.controller.startStatsPolling()

        self.controller.pool.start.assert_called_once()
        worker = self.controller.pool.start.call_args.args[0]
        self.assertEqual(2, len(worker.records))
        self.assertEqual(1.0, worker.timeout)
        self.assertEqual(20, worker.workers)

    def test_stats_settings_are_independent_and_persisted(self):
        """Stats cadence and load controls persist separately from discovery."""
        self.controller.pool.start = Mock()

        saved = self.controller.saveScanSettings(
            "192.168.1.0/24",
            True,
            True,
            14555,
            14550,
            7,
            2.5,
            12,
            True,
            9,
            0.7,
            6,
            5,
        )

        self.assertTrue(saved)
        values = self.controller.scanSettings
        self.assertEqual(7, values["interval"])
        self.assertEqual(2.5, values["http_timeout"])
        self.assertEqual(12, values["workers"])
        self.assertEqual(9, values["stats_interval"])
        self.assertEqual(0.7, values["stats_timeout"])
        self.assertEqual(6, values["stats_workers"])
        self.assertEqual(5, values["stats_failure_threshold"])

    def test_stats_settings_are_bounded(self):
        """Stats values are clamped to documented safe ranges."""
        self.controller.pool.start = Mock()

        self.controller.saveScanSettings(
            "192.168.1.0/24",
            True,
            True,
            14555,
            14550,
            5,
            1.0,
            20,
            True,
            0,
            99.0,
            500,
            99,
        )

        values = self.controller.scanSettings
        self.assertEqual(1, values["stats_interval"])
        self.assertEqual(30.0, values["stats_timeout"])
        self.assertEqual(64, values["stats_workers"])
        self.assertEqual(20, values["stats_failure_threshold"])

    def test_disabling_stats_polling_preserves_device_state(self):
        """Disabling polling cancels work without clearing cached health or stats."""
        record = DeviceRecord(
            identity="A",
            ip="192.168.1.2",
            activation_key="A",
            stats={"esp_rssi": -51},
        )
        self.controller.source_model.upsert_many([record])
        self.controller.pool.start = Mock()
        self.controller.startStatsPolling()
        worker = self.controller.pool.start.call_args.args[0]

        self.controller.saveScanSettings(
            "192.168.1.0/24",
            True,
            True,
            14555,
            14550,
            5,
            1.0,
            20,
            False,
            2,
            1.0,
            20,
            3,
        )

        retained = self.controller.source_model.record_by_identity("A")
        self.assertTrue(worker.cancel_event.is_set())
        self.assertEqual("DISABLED", self.controller.statsPollingStatus)
        self.assertTrue(retained.online)
        self.assertEqual({"esp_rssi": -51}, retained.stats)

    def test_reenabling_stats_polling_starts_immediately(self):
        """Changing stats polling from disabled to enabled starts one round."""
        self._test_settings.setValue("scan/stats_enabled", False)
        self.controller.pool.start = Mock()
        self.controller.source_model.upsert_many([
            DeviceRecord(identity="A", ip="192.168.1.2"),
        ])

        self.controller.saveScanSettings(
            "192.168.1.0/24",
            True,
            True,
            14555,
            14550,
            5,
            1.0,
            20,
            True,
            2,
            1.0,
            20,
            3,
        )

        self.controller.pool.start.assert_called_once()
        self.assertEqual("POLLING", self.controller.statsPollingStatus)

    def test_late_stats_results_are_ignored_after_disable(self):
        """Results from a cancelled generation cannot mutate retained devices."""
        self.controller.source_model.upsert_many([
            DeviceRecord(
                identity="A",
                ip="192.168.1.2",
                activation_key="A",
            ),
        ])
        generation = self.controller._fleet_generation
        self.controller.pool.start = Mock()
        self.controller.startStatsPolling()

        self.controller.saveScanSettings(
            "192.168.1.0/24",
            True,
            True,
            14555,
            14550,
            5,
            1.0,
            20,
            False,
            2,
            1.0,
            20,
            1,
        )
        self.controller._stats_progress(
            {
                "identity": "A",
                "success": False,
                "error": "late failure",
            },
            generation,
        )

        record = self.controller.source_model.record_by_identity("A")
        self.assertTrue(record.online)
        self.assertEqual(0, record.consecutive_stats_failures)

    def test_clear_fleet_cancels_queued_stats_polling(self):
        """Clearing retained devices cancels the active polling round."""
        self.controller.source_model.upsert_many([
            DeviceRecord(identity="A", ip="192.168.1.2"),
        ])
        self.controller.pool.start = Mock()
        self.controller.startStatsPolling()
        worker = self.controller.pool.start.call_args.args[0]

        self.controller.clearFleet()

        self.assertTrue(worker.cancel_event.is_set())
        self.assertEqual(0, self.controller.source_model.rowCount())

    def test_stats_updates_do_not_notify_unchanged_web_url(self):
        """Runtime stats refresh the inspector without reloading its web page."""
        self.controller.source_model.upsert_many([
            DeviceRecord(
                identity="A",
                ip="192.168.1.2",
                activation_key="A",
            ),
        ])
        web_url_changes = []
        inspector_changes = []
        self.controller.webUrlChanged.connect(lambda: web_url_changes.append(True))
        self.controller.inspectorChanged.connect(lambda: inspector_changes.append(True))
        self.controller.inspectDevice("A")
        self.assertEqual("http://192.168.1.2", self.controller.webUrl)
        web_url_changes.clear()
        inspector_changes.clear()

        self.controller.source_model.apply_stats_result(
            "A",
            True,
            {"esp_rssi": -51},
        )

        self.assertEqual([], web_url_changes)
        self.assertTrue(inspector_changes)
        self.assertEqual("http://192.168.1.2", self.controller.webUrl)

    def test_web_url_notifies_when_selected_device_goes_offline(self):
        """The web panel unloads only after health changes its effective URL."""
        self.controller.source_model.upsert_many([
            DeviceRecord(
                identity="A",
                ip="192.168.1.2",
                activation_key="A",
            ),
        ])
        self.controller.inspectDevice("A")
        web_url_changes = []
        self.controller.webUrlChanged.connect(lambda: web_url_changes.append(True))

        for _ in range(3):
            self.controller.source_model.apply_stats_result(
                "A",
                False,
                error="offline",
            )

        self.assertEqual([True], web_url_changes)
        self.assertEqual("", self.controller.webUrl)

    @patch("ui.controller.monotonic")
    def test_stats_round_cadence_is_scheduled_from_round_start(self, monotonic):
        """Long rounds restart immediately while short rounds wait to two seconds."""
        self._test_settings.setValue("scan/stats_interval", 2)
        self.controller._stats_round_started_at = 10.0
        monotonic.return_value = 11.0
        self.controller._schedule_next_stats_round()
        self.assertEqual(1_000, self.controller.stats_timer.interval())

        monotonic.return_value = 13.0
        self.controller._schedule_next_stats_round()
        self.assertEqual(0, self.controller.stats_timer.interval())
        self.controller.stats_timer.stop()

    def test_footer_exposes_independent_scan_indicators(self):
        """The footer contains separate discovery and stats process states."""
        self._enter_main_screen()
        discovery = self.root.findChild(QQuickItem, "discoveryFooterStatus")
        stats = self.root.findChild(QQuickItem, "statsPollingFooterStatus")

        self.assertIsNotNone(discovery)
        self.assertIsNotNone(stats)
        self.assertIn("STOPPED", discovery.property("text"))
        self.assertIn("WAITING", stats.property("text"))

    def test_discovery_and_stats_status_transitions_are_independent(self):
        """Starting discovery does not overwrite the stats polling indicator."""
        self.controller.pool.start = Mock()
        self.assertEqual("STOPPED", self.controller.discoveryStatus)
        self.assertEqual("WAITING", self.controller.statsPollingStatus)

        self.controller.toggleScanning()

        self.assertEqual("SCANNING", self.controller.discoveryStatus)
        self.assertEqual("WAITING", self.controller.statsPollingStatus)

    def test_discovery_continues_when_stats_polling_is_disabled(self):
        """Disabling stats does not disable or block device discovery."""
        self.controller.pool.start = Mock()
        self.controller.saveScanSettings(
            "192.168.1.0/24",
            True,
            True,
            14555,
            14550,
            5,
            1.0,
            20,
            False,
            2,
            1.0,
            20,
            3,
        )
        self.controller.pool.start.reset_mock()

        self.controller.toggleScanning()

        self.controller.pool.start.assert_called_once()
        self.assertEqual("SCANNING", self.controller.discoveryStatus)
        self.assertEqual("DISABLED", self.controller.statsPollingStatus)

    def test_device_stats_failure_does_not_set_global_polling_error(self):
        """Ordinary unreachable devices remain device-level failures."""
        self.controller.source_model.upsert_many([
            DeviceRecord(identity="A", ip="192.168.1.2"),
        ])
        generation = self.controller._fleet_generation

        self.controller._stats_progress(
            {
                "identity": "192.168.1.2",
                "ip": "192.168.1.2",
                "success": False,
                "error": "offline",
            },
            generation,
        )

        self.assertEqual("WAITING", self.controller.statsPollingStatus)

    def test_worker_failures_set_only_the_matching_footer_error(self):
        """Discovery and stats worker failures update independent indicators."""
        self.controller._scan_failed("discovery failed")
        self.assertEqual("ERROR", self.controller.discoveryStatus)
        self.assertEqual("WAITING", self.controller.statsPollingStatus)

        self.controller._stats_failed(
            "polling failed",
            self.controller._fleet_generation,
        )
        self.assertEqual("ERROR", self.controller.discoveryStatus)
        self.assertEqual("ERROR", self.controller.statsPollingStatus)

    def test_footer_indicators_fit_minimum_window_width(self):
        """All status indicators remain within the 1180-pixel minimum window."""
        self._enter_main_screen()
        self.root.setWidth(1180)
        self.app.processEvents()
        license_status = self.root.findChild(QQuickItem, "licenseFooterStatus")
        right_edge = license_status.mapToScene(
            QPointF(license_status.width(), 0)
        ).x()

        self.assertLessEqual(right_edge, self.root.width())

    def test_default_columns_match_requirements(self):
        """The required fields are the default table projection."""
        self.assertEqual(
            list(DeviceTableModel.DEFAULT_COLUMN_KEYS),
            self.controller.source_model.visible_column_keys(),
        )
        self.assertEqual(12, self.controller.source_model.columnCount())

    def test_sys_id_mismatch_uses_critical_status_badges(self):
        """Known FC/DLSE SYS ID mismatches highlight exactly the two ID cells."""
        screen = (self.QML_ROOT / "MainScreen.qml").read_text(encoding="utf-8")
        badge = (self.QML_ROOT / "StatusBadge.qml").read_text(encoding="utf-8")

        self.assertIn("required property bool fcSysIdMismatch", screen)
        self.assertIn('columnKey === "mavlink_sys_id"', screen)
        self.assertIn('columnKey === "fc_sys_id"', screen)
        self.assertIn("critical: fcSysIdMismatch", screen)
        self.assertIn("property bool critical: false", badge)
        self.assertIn('return "#52141e"', badge)

    def test_saved_column_layout_adds_fc_sys_id_only_once(self):
        """Existing layouts receive the new default column without overriding a later hide."""
        self._test_settings.setValue(
            "columns/visible",
            "hostname,ip,mavlink_sys_id,wifi_ssid",
        )
        self._test_settings.remove("columns/fc_sys_id_default_added")
        with (
            patch("ui.controller.QSettings", return_value=self._test_settings),
            patch("ui.controller.QTimer.singleShot"),
        ):
            migrated = FleetController()
        migrated.license_timer.stop()
        migrated.scan_timer.stop()
        migrated.stats_timer.stop()

        self.assertEqual(
            ["hostname", "ip", "mavlink_sys_id", "fc_sys_id", "wifi_ssid"],
            migrated.source_model.visible_column_keys(),
        )

        migrated.setColumnVisible("fc_sys_id", False)
        with (
            patch("ui.controller.QSettings", return_value=self._test_settings),
            patch("ui.controller.QTimer.singleShot"),
        ):
            restored = FleetController()
        restored.license_timer.stop()
        restored.scan_timer.stop()
        restored.stats_timer.stop()

        self.assertNotIn("fc_sys_id", restored.source_model.visible_column_keys())

    def test_column_order_can_be_moved_and_persisted(self):
        """The column dialog can reorder visible data columns across sessions."""
        self.controller.moveColumn("rssi", -10)

        self.assertEqual(
            ["rssi", *list(DeviceTableModel.DEFAULT_COLUMN_KEYS[:-1])],
            self.controller.source_model.visible_column_keys(),
        )
        self.assertEqual(
            "rssi,hostname,ip,activation_status,firmware_version,"
            "chip,dronebridge_version,mavlink_sys_id,fc_sys_id,wifi_ssid,wifi_channel",
            self._test_settings.value("columns/visible"),
        )
        columns = self.controller.columns
        self.assertEqual("rssi", columns[0]["key"])
        self.assertFalse(columns[0]["canMoveUp"])
        self.assertTrue(columns[0]["canMoveDown"])

    def test_column_order_can_be_set_absolutely(self):
        """Drag/drop column ordering can persist the final visible key order."""
        self.controller.setColumnOrder([
            "rssi",
            "ip",
            "ip",
            "unknown",
            "hostname",
        ])

        self.assertEqual(
            [
                "rssi",
                "ip",
                "hostname",
                "activation_status",
                "firmware_version",
                "chip",
                "dronebridge_version",
                "mavlink_sys_id",
                "fc_sys_id",
                "wifi_ssid",
                "wifi_channel",
            ],
            self.controller.source_model.visible_column_keys(),
        )
        self.assertEqual(
            "rssi,ip,hostname,activation_status,firmware_version,"
            "chip,dronebridge_version,mavlink_sys_id,fc_sys_id,wifi_ssid,wifi_channel",
            self._test_settings.value("columns/visible"),
        )

    def test_column_visibility_preserves_custom_order(self):
        """Newly shown columns are appended instead of resetting prior order."""
        self.controller.moveColumn("rssi", -10)
        self.controller.setColumnVisible("activation_key", True)

        self.assertEqual(
            [
                "rssi",
                *list(DeviceTableModel.DEFAULT_COLUMN_KEYS[:-1]),
                "activation_key",
            ],
            self.controller.source_model.visible_column_keys(),
        )

    def test_column_width_can_be_changed_and_persisted(self):
        """Manual table column widths are stored by stable column key."""
        applied = self.controller.setColumnWidth(2, 188)

        self.assertEqual(188, applied)
        self.assertEqual(188, self.controller.columnWidth(2))
        self.assertEqual(188, int(self._test_settings.value("columns/width/ip")))
        columns = self.controller.columns
        self.assertEqual(
            188,
            next(column["width"] for column in columns if column["key"] == "ip"),
        )

    def test_column_width_follows_key_after_reorder(self):
        """Persisted widths stay with the column key, not the visible index."""
        self.controller.setColumnWidth(2, 188)
        self.controller.moveColumn("ip", 4)
        ip_column = self.controller.source_model.visible_column_keys().index("ip") + 1

        self.assertEqual(188, self.controller.columnWidth(ip_column))

    def test_column_widths_are_bounded_and_resettable(self):
        """Custom widths are clamped and can be reset to defaults."""
        self.assertEqual(MIN_COLUMN_WIDTH, self.controller.setColumnWidth(2, -5))
        self.assertEqual(MAX_COLUMN_WIDTH, self.controller.setColumnWidth(2, 9999))

        self.assertEqual(112, self.controller.resetColumnWidth(2))
        self.assertIsNone(self._test_settings.value("columns/width/ip"))

        self.controller.setColumnWidth(2, 188)
        self.controller.setColumnWidth(3, 190)
        self.controller.resetColumnWidths()
        self.assertIsNone(self._test_settings.value("columns/width/ip"))
        self.assertIsNone(self._test_settings.value("columns/width/activation_status"))

    def test_columns_dialog_exposes_drag_reorder_controls(self):
        """Configure Columns includes drag/drop column ordering controls."""
        source = (self.QML_ROOT / "FleetDialogs.qml").read_text(encoding="utf-8")

        self.assertIn("ListModel {", source)
        self.assertIn("id: columnOrderModel", source)
        self.assertIn("function updateDraggedColumnTarget(targetIndex)", source)
        self.assertIn("function finishDraggedColumn()", source)
        self.assertIn("columnOrderModel.move", source)
        self.assertIn("onPositionChanged:", source)
        self.assertIn("columnList.indexAt(center.x, center.y)", source)
        self.assertIn("property real dragContentY", source)
        self.assertIn("Timer {", source)
        self.assertIn("running: columnList.dragStartIndex >= 0", source)
        self.assertIn("viewportY < margin && columnList.contentY > 0", source)
        self.assertIn("enabled: columnOrderModel.count > 1", source)
        self.assertIn("Drag.active: dragHandle.drag.active", source)
        self.assertIn("fleetController.setColumnOrder(keys)", source)
        self.assertNotIn("id: moveColumnUp", source)
        self.assertNotIn("id: moveColumnDown", source)
        self.assertIn("fleetController.resetColumnWidths()", source)

        modal_source = (self.QML_ROOT / "ModalDialog.qml").read_text(encoding="utf-8")
        self.assertIn("function centerInParent()", modal_source)
        self.assertIn("onOpened: centerTimer.restart()", modal_source)
        self.assertIn("onHeightChanged:", modal_source)

    def test_table_header_exposes_resize_controls(self):
        """The table header includes a drag handle for manual column widths."""
        source = (self.QML_ROOT / "MainScreen.qml").read_text(encoding="utf-8")
        header_block = source[
            source.index("HorizontalHeaderView {"):
            source.index("TableView {")
        ]

        self.assertIn("id: resizeHandle", header_block)
        self.assertIn("fleetController.setColumnWidth", header_block)
        self.assertIn("fleetController.resetColumnWidth(index)", header_block)
        self.assertIn("Qt.SplitHCursor", header_block)
        self.assertIn("preventStealing: true", header_block)
        self.assertIn("mainScreen.resizingColumn = true", header_block)
        self.assertIn("mainScreen.resizingColumn = false", header_block)
        self.assertIn("resizableColumns: false", header_block)
        self.assertIn(
            "interactive: !mainScreen.resizingColumn && !mainScreen.resizingInspector",
            source,
        )

    def test_inspector_width_can_be_changed_and_persisted(self):
        """The right-side configuration panel width is bounded and stored."""
        self.assertEqual(DEFAULT_INSPECTOR_WIDTH, self.controller.inspectorWidth)

        self.assertEqual(420, self.controller.setInspectorWidth(420))
        self.assertEqual(420, self.controller.inspectorWidth)
        self.assertEqual(420, int(self._test_settings.value("inspector/width")))

        self.assertEqual(MIN_INSPECTOR_WIDTH, self.controller.setInspectorWidth(-1))
        self.assertEqual(MAX_INSPECTOR_WIDTH, self.controller.setInspectorWidth(9999))
        self.assertEqual(DEFAULT_INSPECTOR_WIDTH, self.controller.resetInspectorWidth())
        self.assertIsNone(self._test_settings.value("inspector/width"))

    def test_configuration_panel_exposes_resize_handle(self):
        """The inspector wrapper includes a mouse-driven left-edge resize handle."""
        source = (self.QML_ROOT / "MainScreen.qml").read_text(encoding="utf-8")

        self.assertIn('objectName: "inspectorShell"', source)
        self.assertIn('objectName: "inspectorResizeHandle"', source)
        self.assertIn(
            "Layout.preferredWidth: inspectorExpanded ? fleetController.inspectorWidth : 0",
            source,
        )
        self.assertIn("fleetController.setInspectorWidth", source)
        self.assertIn("fleetController.resetInspectorWidth()", source)
        self.assertIn("mainScreen.resizingInspector = true", source)
        self.assertIn("mainScreen.resizingInspector = false", source)
        self.assertIn("anchors.left: parent.left", source)

    def test_bulk_template_defaults_depend_on_target_scope(self):
        """The five unique fields are excluded only for multi-device application."""
        self.controller._csv_template = {
            key: "value" for key in DEFAULT_BULK_EXCLUSIONS
        }
        self.controller._csv_template["wifi_chan"] = 6
        self.controller.source_model.upsert_many([
            DeviceRecord(identity="A", ip="192.168.1.2"),
            DeviceRecord(identity="B", ip="192.168.1.3"),
        ])

        self.assertEqual(
            DEFAULT_BULK_EXCLUSIONS,
            set(self.controller.defaultCsvExclusions("visible")),
        )
        self.controller.source_model.set_selected("A", True)
        self.assertEqual([], self.controller.defaultCsvExclusions("selected"))

    def test_sys_id_alignment_filters_selected_devices_by_license_status(self):
        """Only selected Evaluation and Activated records enter SYS ID alignment."""
        self.controller.source_model.upsert_many([
            DeviceRecord(identity="EVAL", ip="192.168.1.2", activation_status="evaluation", selected=True),
            DeviceRecord(identity="ACTIVE", ip="192.168.1.3", activation_status="ACTIVATED", selected=True),
            DeviceRecord(identity="OTHER", ip="192.168.1.4", activation_status="discovered", selected=True),
        ])
        self.controller._launch_sys_id_alignment = Mock()

        self.controller.startSysIdAlignment("ip")

        records, mode = self.controller._launch_sys_id_alignment.call_args.args[:2]
        self.assertEqual(["192.168.1.2", "192.168.1.3"], [record.identity for record in records])
        self.assertEqual("ip", mode)
        self.assertEqual(2, self.controller.eligibleSysIdAlignmentCount)
        self.assertEqual(1, self.controller.ineligibleSysIdAlignmentCount)

    def test_sys_id_alignment_rejects_empty_eligible_selection(self):
        """A selected unlicensed device does not create an alignment operation."""
        self.controller.source_model.upsert_many([
            DeviceRecord(identity="OTHER", ip="192.168.1.4", activation_status="discovered", selected=True)
        ])
        self.controller._launch_sys_id_alignment = Mock()
        toast = []
        self.controller.toastRequested.connect(lambda level, message: toast.append((level, message)))

        self.controller.startSysIdAlignment("manual")

        self.controller._launch_sys_id_alignment.assert_not_called()
        self.assertEqual("info", toast[-1][0])
        self.assertIn("Evaluation or Activated", toast[-1][1])

    def test_static_ip_assignment_uses_visible_table_order_and_license_filter(self):
        """Static IP targets follow the filtered table order and eligible licenses only."""
        self.controller.source_model.upsert_many([
            DeviceRecord(
                identity="B",
                ip="10.0.0.3",
                hostname="B",
                activation_status="ACTIVATED",
                activation_key="B",
                selected=True,
            ),
            DeviceRecord(
                identity="A",
                ip="10.0.0.2",
                hostname="A",
                activation_status="EVALUATION",
                activation_key="A",
                selected=True,
            ),
            DeviceRecord(
                identity="OTHER",
                ip="10.0.0.4",
                hostname="Other",
                activation_status="DISCOVERED",
                activation_key="OTHER",
                selected=True,
            ),
        ])
        self.controller.sortByColumn(1, True)
        self.controller._launch_static_ip_assignment = Mock()

        self.assertTrue(
            self.controller.startStaticIpAssignment(
                "192.168.20.1",
                "255.255.255.0",
                "192.168.20.254",
            )
        )

        records, assignments = self.controller._launch_static_ip_assignment.call_args.args[:2]
        self.assertEqual(["A", "B"], [record.identity for record in records])
        self.assertEqual(
            {"A": "192.168.20.1", "B": "192.168.20.2"},
            assignments,
        )
        self.assertEqual(2, self.controller.eligibleStaticIpCount)
        self.assertEqual(1, self.controller.ineligibleStaticIpCount)
        self.assertEqual(0, self.controller.filteredStaticIpCount)

    def test_static_ip_assignment_excludes_selected_rows_hidden_by_search(self):
        """Selected rows hidden by the search filter are excluded and reported separately."""
        self.controller.source_model.upsert_many([
            DeviceRecord(
                identity="VISIBLE",
                ip="10.0.0.2",
                activation_status="ACTIVATED",
                activation_key="VISIBLE",
                selected=True,
            ),
            DeviceRecord(
                identity="HIDDEN",
                ip="10.0.0.3",
                activation_status="EVALUATION",
                activation_key="HIDDEN",
                selected=True,
            ),
        ])
        self.controller.setSearchText("VISIBLE")
        self.controller._launch_static_ip_assignment = Mock()

        self.assertTrue(
            self.controller.startStaticIpAssignment(
                "192.168.20.1",
                "255.255.255.0",
                "192.168.20.254",
            )
        )

        records = self.controller._launch_static_ip_assignment.call_args.args[0]
        self.assertEqual(["VISIBLE"], [record.identity for record in records])
        self.assertEqual(1, self.controller.eligibleStaticIpCount)
        self.assertEqual(1, self.controller.filteredStaticIpCount)

    def test_static_ip_assignment_rejects_invalid_preflight_without_launching(self):
        """Invalid static network input reports an error before creating a worker."""
        self.controller.source_model.upsert_many([
            DeviceRecord(
                identity="A",
                ip="10.0.0.2",
                activation_status="ACTIVATED",
                activation_key="A",
                selected=True,
            )
        ])
        self.controller._launch_static_ip_assignment = Mock()
        toast = []
        self.controller.toastRequested.connect(lambda level, message: toast.append((level, message)))

        self.assertFalse(
            self.controller.startStaticIpAssignment(
                "192.168.20.1",
                "255.255.255.0",
                "192.168.21.1",
            )
        )

        self.controller._launch_static_ip_assignment.assert_not_called()
        self.assertEqual("error", toast[-1][0])
        self.assertIn("gateway", toast[-1][1].lower())

    def test_static_ip_success_updates_cached_address_and_reboot_grace(self):
        """An accepted static-IP result updates the table address before reboot polling resumes."""
        self.controller.source_model.upsert_many([
            DeviceRecord(
                identity="A",
                ip="10.0.0.2",
                activation_key="A",
                activation_status="ACTIVATED",
            )
        ])
        self.controller._active_worker = Mock()
        self.controller._active_operation = "static_ip"
        self.controller._active_targets = {"A"}

        self.controller._operation_finished(
            "static_ip",
            [{
                "identity": "A",
                "target_ip": "192.168.20.1",
                "settings": {
                    "ip_sta": "192.168.20.1",
                    "ip_sta_netmsk": "255.255.255.0",
                    "ip_sta_gw": "192.168.20.254",
                },
                "success": True,
            }],
        )

        record = self.controller.source_model.record_by_identity("A")
        self.assertEqual("192.168.20.1", record.ip)
        self.assertEqual("255.255.255.0", record.settings["ip_sta_netmsk"])
        self.assertIsNotNone(record.offline_grace_until)

    def test_settings_preflight_rejects_invalid_network_values(self):
        """High-risk settings fail validation before worker creation."""
        self.assertIn(
            "not a valid IP",
            FleetController._validate_settings({"ip_sta": "999.1.1.1"}),
        )
        self.assertIsNone(
            FleetController._validate_settings({
                "ip_sta": "192.168.1.42",
                "ip_sta_netmsk": "255.255.255.0",
                "ip_sta_gw": "192.168.1.1",
                "udp_local_port": 14555,
            })
        )

    def test_settings_submission_contains_only_dirty_values(self):
        """Inspector application submits only converted changed parameters."""
        self.controller.source_model.upsert_many([
            DeviceRecord(
                identity="KEY",
                ip="192.168.1.42",
                activation_key="KEY",
                settings={"wifi_chan": 6, "wifi_hostname": "Drone"},
            )
        ])
        self.controller.inspectDevice("KEY")
        self.controller.setSettingValue("wifi_chan", "7")
        self.controller.setSettingValue("wifi_hostname", "Drone")
        self.controller._start_settings = Mock()

        self.controller.applyEditedSettings()

        records, settings = self.controller._start_settings.call_args.args[:2]
        self.assertEqual(["KEY"], [record.identity for record in records])
        self.assertEqual({"wifi_chan": 7}, settings)

    def test_csv_application_respects_custom_exclusions(self):
        """User-selected exclusions are removed before bulk submission."""
        self.controller._csv_template = {
            "ip_sta": "192.168.1.42",
            "wifi_hostname": "Drone",
            "wifi_chan": 6,
        }
        self.controller.source_model.upsert_many([
            DeviceRecord(identity="A", ip="192.168.1.2", activation_key="A"),
            DeviceRecord(identity="B", ip="192.168.1.3", activation_key="B"),
        ])
        self.controller._start_settings = Mock()

        self.controller.applyCsvTemplate(["ip_sta", "wifi_chan"], "visible")

        records, settings = self.controller._start_settings.call_args.args[:2]
        self.assertEqual(2, len(records))
        self.assertEqual({"wifi_hostname": "Drone"}, settings)

    def test_activation_uses_environment_token_without_persisting_it(self):
        """An empty dialog token falls back to the environment for this session."""
        self.controller.source_model.upsert_many([
            DeviceRecord(identity="A", ip="192.168.1.2", activation_key="A")
        ])
        self.controller._launch_activation = Mock()
        with patch.dict(os.environ, {"DRONEBRIDGE_SECRET_TOKEN": "session-secret"}):
            self.controller.startActivation("", "visible", "evaluation")

        self.assertEqual(
            "session-secret",
            self.controller._launch_activation.call_args.args[1],
        )
        self.assertNotIn("session-secret", str(self._test_settings.allKeys()))

    @patch("ui.workers.db_list_offline_dlse_releases", return_value=[])
    @patch("ui.workers.db_api_get_dlse_releases", return_value=[])
    def test_ota_release_refresh_uses_environment_token_without_persisting_it(
        self,
        get_releases,
        _offline,
    ):
        """An empty release refresh token falls back to the session environment only."""
        self.controller.pool.start = lambda worker: worker.run()
        with patch.dict(os.environ, {"DRONEBRIDGE_SECRET_TOKEN": "session-secret"}):
            self.controller.refreshOtaReleases("")

        get_releases.assert_called_once_with("session-secret")
        self.assertNotIn("session-secret", str(self._test_settings.allKeys()))

    @patch("ui.workers.db_check_release_binaries_present", return_value=True)
    @patch("ui.workers.db_find_extracted_dlse_release_root")
    @patch("ui.workers.db_download_and_extract_dlse_release")
    def test_online_ota_release_preflight_launches_existing_ota_worker(
        self,
        download_release,
        find_root,
        _check_release,
    ):
        """Downloaded account releases are validated before launching OTA uploads."""
        self.controller.source_model.upsert_many([
            DeviceRecord(identity="A", ip="192.168.1.2", activation_key="A")
        ])
        release = DBDLSERelease("2026-06-01", "DLSE v1.1.0", "/new.zip")
        option = {
            "id": "online:1:test",
            "source": "online",
            "label": "[download] 2026-06-01 - DLSE v1.1.0",
            "release": release,
        }
        self.controller._ota_releases_loaded({"options": [option], "status": "1 online"})
        self.controller.pool.start = lambda worker: worker.run()
        self.controller._launch_ota = Mock()

        with tempfile.TemporaryDirectory(dir=".") as directory:
            download_release.return_value = directory
            find_root.return_value = Path(directory)
            self.controller.startOtaFromRelease(
                "online:1:test",
                "token",
                "1.0.0-beta.5",
                20,
                "visible",
            )

            download_release.assert_called_once_with(release, "token")
            args = self.controller._launch_ota.call_args.args
            self.assertEqual(Path(directory), args[1])
            self.assertEqual("1.0.0-beta.5", args[5])

    @patch("ui.workers.db_download_and_extract_dlse_release", return_value=None)
    def test_failed_ota_release_preflight_does_not_queue_devices(self, _download_release):
        """Release download failure stops before any device operation is marked queued."""
        self.controller.source_model.upsert_many([
            DeviceRecord(identity="A", ip="192.168.1.2", activation_key="A")
        ])
        release = DBDLSERelease("2026-06-01", "DLSE v1.1.0", "/new.zip")
        self.controller._ota_releases_loaded({
            "options": [{
                "id": "online:1:test",
                "source": "online",
                "label": "[download] 2026-06-01 - DLSE v1.1.0",
                "release": release,
            }],
            "status": "1 online",
        })
        self.controller.pool.start = lambda worker: worker.run()
        self.controller._launch_ota = Mock()

        self.controller.startOtaFromRelease("online:1:test", "token", "", 20, "visible")

        record = self.controller.source_model.record_by_identity("A")
        self.controller._launch_ota.assert_not_called()
        self.assertEqual("", record.operation)

    @patch("ui.controller.db_check_release_binaries_present", return_value=True)
    def test_manual_ota_release_folder_path_still_launches_directly(self, _check_release):
        """The existing manual release folder OTA path remains available."""
        self.controller.source_model.upsert_many([
            DeviceRecord(identity="A", ip="192.168.1.2", activation_key="A")
        ])
        self.controller._launch_ota = Mock()
        with tempfile.TemporaryDirectory(dir=".") as directory:
            self.controller.startOta(directory, "", "", "", 20, "visible")

            args = self.controller._launch_ota.call_args.args
            self.assertEqual(Path(directory), args[1])
            self.assertIsNone(args[2])
            self.assertIsNone(args[3])

    def test_python_ui_contains_no_widget_layer(self):
        """No UI Python module may import or construct Qt Widgets."""
        ui_root = Path(__file__).resolve().parents[1] / "ui"
        forbidden = (
            "PySide6.QtWidgets",
            "QtWebEngineWidgets",
            "QWidget",
            "QDialog",
            "QMainWindow",
            "QApplication",
        )
        for path in ui_root.glob("*.py"):
            text = path.read_text(encoding="utf-8")
            for token in forbidden:
                self.assertNotIn(token, text, f"{token} found in {path.name}")

    def test_main_screen_theme_uses_reference_text_colors(self):
        """Semantic text colors match the updated MainScreen reference exactly."""
        theme = self._create_qml_component("Theme.qml")
        self.assertEqual("#e2d5c8", self._color_name(theme.property("primaryText")))
        self.assertEqual("#deceb9", self._color_name(theme.property("secondaryText")))
        self.assertEqual(
            "#87deceb9",
            self._color_name(theme.property("mutedText"), alpha=True),
        )
        self.assertEqual("#ff8e00", self._color_name(theme.property("accent")))
        self.assertEqual("#34d399", self._color_name(theme.property("success")))
        self.assertEqual("#ffa00a", self._color_name(theme.property("warning")))
        self.assertEqual("#ffaeae", self._color_name(theme.property("error")))
        theme.deleteLater()

    def test_status_badges_use_reference_palette(self):
        """Evaluation, activated, and expired badges use screenshot colors."""
        badge = self._create_qml_component("StatusBadge.qml")
        expected = {
            "evaluation": ("#43361b", "#ffa00a"),
            "activated": ("#16554a", "#34d399"),
            "expired": ("#52141e", "#ffaeae"),
        }
        for status, (background, foreground) in expected.items():
            badge.setProperty("status", status)
            self.app.processEvents()
            self.assertEqual(
                background,
                self._color_name(badge.property("backgroundColor")),
            )
            self.assertEqual(
                foreground,
                self._color_name(badge.property("foregroundColor")),
            )
        badge.deleteLater()

    def test_operational_text_does_not_use_link_blue(self):
        """Buttons and device addresses reserve blue for genuine hyperlinks."""
        button = self._create_qml_component("AppButton.qml")
        self.assertEqual(
            "#e2d5c8",
            self._color_name(button.property("foregroundColor")),
        )
        button.deleteLater()

        for name in ("AppButton.qml", "MainScreen.qml", "OTA_Button.qml",
                     "OTA_Button_1.qml"):
            source = (self.QML_ROOT / name).read_text(encoding="utf-8").lower()
            self.assertNotIn("#d0edff", source, name)
            self.assertNotIn("theme.link", source, name)


if __name__ == "__main__":
    unittest.main()

"""PySide6 application for OTA license activation of DroneBridge DLSE devices."""

import os
import sys
from importlib.metadata import PackageNotFoundError, version
from pathlib import Path
from typing import Any

from PySide6.QtCore import QSettings, QTimer, Qt, QThreadPool
from PySide6.QtGui import QAction, QIcon, QPixmap
from PySide6.QtWidgets import (
    QApplication,
    QCheckBox,
    QComboBox,
    QFrame,
    QGridLayout,
    QHBoxLayout,
    QHeaderView,
    QLabel,
    QLineEdit,
    QMainWindow,
    QMenu,
    QMessageBox,
    QPushButton,
    QSpinBox,
    QSplitter,
    QTableView,
    QTreeWidget,
    QTreeWidgetItem,
    QVBoxLayout,
    QWidget,
)

from DroneBridgeCommercialSupportSuite import DBLicenseType
from ui.models import DeviceFilterProxyModel, DeviceRecord, DeviceTableModel
from ui.styles import IMAGE_ROOT, app_stylesheet, load_fonts
from ui.workers import ActivationWorker, DeviceDetailsWorker, DiscoveryWorker, LicenseStatusWorker


class MainWindow(QMainWindow):
    """Main window for device discovery and OTA license activation."""

    def __init__(self) -> None:
        """
        Create and wire the main UI.

        The window owns timers, workers, model state, and persisted non-secret
        preferences for the activation workflow.
        """
        super().__init__()
        self.settings = QSettings("DroneBridge", "DLSECommercialSupportSuite")
        self.pool = QThreadPool.globalInstance()
        self.model = DeviceTableModel()
        self.proxy = DeviceFilterProxyModel()
        self.proxy.setSourceModel(self.model)
        self.proxy.setFilterCaseSensitivity(Qt.CaseInsensitive)
        self.scan_running = False
        self.scanning_enabled = False
        self.server_check_running = False

        self.setWindowTitle("DroneBridge Commercial Support Suite")
        app_icon = IMAGE_ROOT / "app_icon.png"
        if app_icon.exists():
            self.setWindowIcon(QIcon(str(app_icon)))

        self._build_ui()
        self._restore_settings()
        self._connect_signals()
        self._setup_timers()

    def _build_ui(self) -> None:
        """Build widgets and layouts for the main window."""
        root = QWidget()
        root_layout = QVBoxLayout(root)
        root_layout.setContentsMargins(8, 8, 8, 8)
        root_layout.setSpacing(8)

        header = QHBoxLayout()
        logo = QLabel()
        logo_path = IMAGE_ROOT / "DroneBridgeLogo.png"
        if logo_path.exists():
            logo.setPixmap(QPixmap(str(logo_path)).scaledToHeight(16, Qt.SmoothTransformation))
        brand = QLabel("")
        brand.setObjectName("Brand")
        header.addWidget(logo)
        header.addWidget(brand)
        header.addStretch(1)
        self.settings_button = QPushButton("Settings")
        header.addWidget(self.settings_button)
        root_layout.addLayout(header)

        nav = QGridLayout()
        nav.setHorizontalSpacing(8)
        nav.setVerticalSpacing(6)
        self.scan_button = QPushButton("Scan for devices")
        self.scan_button.setObjectName("Primary")
        self.filter_edit = QLineEdit()
        self.filter_edit.setPlaceholderText("Filter by hostname, IP, MAC, activation key, SSID, status...")
        self.subnet_edit = QLineEdit()
        self.subnet_edit.setPlaceholderText("192.168.1.0/24")
        self.local_port_spin = QSpinBox()
        self.local_port_spin.setRange(1, 65535)
        self.local_port_spin.setValue(14550)
        self.esp32_port_spin = QSpinBox()
        self.esp32_port_spin.setRange(1, 65535)
        self.esp32_port_spin.setValue(14555)
        self.update_rate_spin = QSpinBox()
        self.update_rate_spin.setRange(5, 3600)
        self.update_rate_spin.setSuffix(" s")
        self.update_rate_spin.setValue(5)
        self.http_scan_check = QCheckBox("HTTP scan")
        self.http_scan_check.setChecked(True)
        self.mavlink_scan_check = QCheckBox("MAVLink broadcast")
        self.mavlink_scan_check.setChecked(True)
        self.token_edit = QLineEdit()
        self.token_edit.setEchoMode(QLineEdit.Password)
        self.token_edit.setPlaceholderText("DRONEBRIDGE_SECRET_TOKEN or session token")
        self.license_type_combo = QComboBox()
        self.license_type_combo.addItem("Activated license", DBLicenseType.ACTIVATED)
        self.license_type_combo.addItem("Evaluation license (60 days)", DBLicenseType.EVALUATION)
        self.activate_selected_button = QPushButton("Activate selected")
        self.activate_all_button = QPushButton("Activate all visible")

        nav.addWidget(self.scan_button, 0, 0)
        nav.addWidget(QLabel("Filter"), 0, 1)
        nav.addWidget(self.filter_edit, 0, 2, 1, 3)
        nav.addWidget(QLabel("Subnet"), 1, 0)
        nav.addWidget(self.subnet_edit, 1, 1)
        nav.addWidget(QLabel("ESP32 port"), 1, 2)
        nav.addWidget(self.esp32_port_spin, 1, 3)
        nav.addWidget(QLabel("Local port"), 1, 4)
        nav.addWidget(self.local_port_spin, 1, 5)
        nav.addWidget(QLabel("Update"), 2, 0)
        nav.addWidget(self.update_rate_spin, 2, 1)
        nav.addWidget(self.mavlink_scan_check, 2, 2)
        nav.addWidget(self.http_scan_check, 2, 3)
        nav.addWidget(self.license_type_combo, 2, 4)
        nav.addWidget(self.activate_selected_button, 2, 5)
        nav.addWidget(QLabel("Token"), 3, 0)
        nav.addWidget(self.token_edit, 3, 1, 1, 3)
        nav.addWidget(self.activate_all_button, 3, 4, 1, 2)
        root_layout.addLayout(nav)

        splitter = QSplitter(Qt.Horizontal)
        self.table = QTableView()
        self.table.setObjectName("Panel")
        self.table.setModel(self.proxy)
        self.table.setAlternatingRowColors(True)
        self.table.setSortingEnabled(True)
        self.table.setSelectionBehavior(QTableView.SelectRows)
        self.table.setSelectionMode(QTableView.ExtendedSelection)
        self.table.horizontalHeader().setSectionResizeMode(QHeaderView.Interactive)
        self.table.horizontalHeader().setStretchLastSection(True)
        splitter.addWidget(self.table)

        detail_panel = QFrame()
        detail_panel.setObjectName("Panel")
        detail_layout = QVBoxLayout(detail_panel)
        detail_heading = QLabel("Settings")
        detail_heading.setObjectName("Heading")
        self.detail_tree = QTreeWidget()
        self.detail_tree.setHeaderLabels(["Parameter", "Value"])
        detail_layout.addWidget(detail_heading)
        detail_layout.addWidget(self.detail_tree)
        splitter.addWidget(detail_panel)
        splitter.setStretchFactor(0, 4)
        splitter.setStretchFactor(1, 1)
        root_layout.addWidget(splitter, 1)

        footer = QHBoxLayout()
        self.detected_label = QLabel("Detected ESP32s: 0")
        self.scan_status_label = QLabel("Idle")
        self.server_label = QLabel("License Server Status: unknown")
        footer.addWidget(self.detected_label)
        footer.addWidget(self.scan_status_label)
        footer.addStretch(1)
        footer.addWidget(QLabel(f"Suite version: {self._suite_version()}"))
        footer.addWidget(self.server_label)
        root_layout.addLayout(footer)

        self.setCentralWidget(root)
        self.resize(1500, 900)

    def _restore_settings(self) -> None:
        """Restore non-secret UI preferences from QSettings."""
        self.subnet_edit.setText(self.settings.value("subnet", "192.168.1.0/24"))
        self.update_rate_spin.setValue(int(self.settings.value("update_rate", 5)))
        self.esp32_port_spin.setValue(int(self.settings.value("esp32_port", 14555)))
        self.local_port_spin.setValue(int(self.settings.value("local_port", 14550)))
        self.http_scan_check.setChecked(self.settings.value("http_scan", "true") == "true")
        self.mavlink_scan_check.setChecked(self.settings.value("mavlink_scan", "true") == "true")
        self.token_edit.setText(os.environ.get("DRONEBRIDGE_SECRET_TOKEN", ""))

    def _connect_signals(self) -> None:
        """Connect widget signals to application slots."""
        self.scan_button.clicked.connect(self.enable_scanning_and_start)
        self.filter_edit.textChanged.connect(self.proxy.set_filter_text)
        self.update_rate_spin.valueChanged.connect(self._restart_scan_timer)
        self.activate_selected_button.clicked.connect(self.activate_selected)
        self.activate_all_button.clicked.connect(self.activate_all_visible)
        self.table.selectionModel().selectionChanged.connect(self.load_selected_details)
        self.settings_button.clicked.connect(self.show_column_menu)

    def _setup_timers(self) -> None:
        """Create recurring scan and license-server status timers."""
        self.scan_timer = QTimer(self)
        self.scan_timer.timeout.connect(self.start_scan)
        self._restart_scan_timer()
        self.server_timer = QTimer(self)
        self.server_timer.timeout.connect(self.check_license_server)
        self.server_timer.start(5000)
        QTimer.singleShot(250, self.check_license_server)

    def _restart_scan_timer(self) -> None:
        """Persist and apply the configured discovery interval."""
        self.settings.setValue("update_rate", self.update_rate_spin.value())
        if hasattr(self, "scan_timer"):
            self.scan_timer.start(self.update_rate_spin.value() * 1000)

    def enable_scanning_and_start(self) -> None:
        """
        Enable recurring discovery and start an immediate scan.

        :return: None. Subsequent timer ticks continue refreshing discovery.
        """
        self.scanning_enabled = True
        self.start_scan()

    def start_scan(self) -> None:
        """
        Start one discovery pass when no previous pass is running.

        Overlapping scans are skipped to avoid uncontrolled network load.
        """
        if not self.scanning_enabled:
            return
        if self.scan_running:
            return
        self._save_scan_settings()
        self.scan_running = True
        self.scan_status_label.setText("Scanning...")
        worker = DiscoveryWorker(
            subnet=self.subnet_edit.text().strip() or "192.168.1.0/24",
            mavlink_enabled=self.mavlink_scan_check.isChecked(),
            http_enabled=self.http_scan_check.isChecked(),
            esp32_port=self.esp32_port_spin.value(),
            local_port=self.local_port_spin.value(),
            http_timeout=1.0,
            http_workers=20,
        )
        worker.signals.finished.connect(self.on_scan_finished)
        worker.signals.error.connect(self.on_worker_error)
        self.pool.start(worker)

    def on_scan_finished(self, records: list[DeviceRecord]) -> None:
        """
        Merge discovery results into the model and update footer counters.

        :param records: Normalized device records returned by the discovery worker.
        """
        self.scan_running = False
        self.model.upsert_many(records)
        self.detected_label.setText(f"Detected ESP32s: {len(self.model.all_records())}")
        self.scan_status_label.setText("Idle")

    def check_license_server(self) -> None:
        """Start a non-blocking license-server availability check."""
        if self.server_check_running:
            return
        self.server_check_running = True
        worker = LicenseStatusWorker()
        worker.signals.finished.connect(self.on_license_server_status)
        worker.signals.error.connect(self.on_license_server_error)
        self.pool.start(worker)

    def on_license_server_status(self, online: bool) -> None:
        """
        Update the footer with the latest license-server status.

        :param online: True when the server is reachable.
        """
        self.server_check_running = False
        self.server_label.setText(f"License Server Status: {'online' if online else 'offline'}")
        self.server_label.setObjectName("FooterOk" if online else "FooterBad")
        self.server_label.style().unpolish(self.server_label)
        self.server_label.style().polish(self.server_label)

    def on_license_server_error(self, message: str) -> None:
        """
        Display a failed license-server status check.

        :param message: Error message emitted by the worker.
        """
        self.server_check_running = False
        self.server_label.setText(f"License Server Status: offline ({message})")
        self.server_label.setObjectName("FooterBad")
        self.server_label.style().unpolish(self.server_label)
        self.server_label.style().polish(self.server_label)

    def load_selected_details(self) -> None:
        """Fetch REST details for the first selected device."""
        records = self._selected_records()
        if not records:
            return
        record = records[0]
        self._populate_details({"record": record, "details": record.raw})
        worker = DeviceDetailsWorker(record, token=self.token_edit.text().strip() or None)
        worker.signals.finished.connect(self.on_details_loaded)
        worker.signals.error.connect(self.on_worker_error)
        self.pool.start(worker)

    def on_details_loaded(self, payload: dict[str, Any]) -> None:
        """
        Merge selected-device REST details into the table and details panel.

        :param payload: Worker payload with normalized record and raw details.
        """
        record = payload.get("record")
        if isinstance(record, DeviceRecord):
            self.model.upsert_many([record])
        self._populate_details(payload)

    def activate_selected(self) -> None:
        """Activate currently selected devices after confirmation."""
        self._activate_records(self._selected_records())

    def activate_all_visible(self) -> None:
        """Activate all devices currently visible through the active filter."""
        records = []
        for row in range(self.proxy.rowCount()):
            source_index = self.proxy.mapToSource(self.proxy.index(row, 0))
            record = self.model.record_at(source_index.row())
            if record is not None:
                records.append(record)
        self._activate_records(records)

    def _activate_records(self, records: list[DeviceRecord]) -> None:
        """
        Confirm and start activation for a set of devices.

        :param records: Selected or filtered device records.
        """
        if not records:
            QMessageBox.information(self, "Activation", "No devices selected.")
            return
        token = self.token_edit.text().strip()
        if not token:
            QMessageBox.warning(self, "Activation", "Enter a DroneBridge license server token first.")
            return
        license_type = self.license_type_combo.currentData()
        license_label = self.license_type_combo.currentText()
        answer = QMessageBox.question(
            self,
            "Confirm activation",
            f"Activate {len(records)} device(s) using {license_label}?",
        )
        if answer != QMessageBox.Yes:
            return
        for record in records:
            self.model.update_status(record.identity, "queued")
        worker = ActivationWorker(records, token, license_type)
        worker.signals.progress.connect(self.on_activation_progress)
        worker.signals.finished.connect(lambda _ok: self.scan_status_label.setText("Activation complete"))
        worker.signals.error.connect(self.on_worker_error)
        self.pool.start(worker)

    def on_activation_progress(self, payload: dict[str, Any]) -> None:
        """
        Update one row from activation progress.

        :param payload: Worker payload containing identity and status.
        """
        identity = payload.get("identity")
        status = payload.get("status", "")
        if identity and status:
            self.model.update_status(identity, str(status))
            self.scan_status_label.setText(f"Activation: {status}")

    def show_column_menu(self) -> None:
        """Show a menu for toggling table column visibility."""
        menu = QMenu(self)
        for index, (_attr, title) in enumerate(DeviceTableModel.COLUMNS):
            action = QAction(title, self)
            action.setCheckable(True)
            action.setChecked(not self.table.isColumnHidden(index))
            action.toggled.connect(lambda checked, col=index: self.table.setColumnHidden(col, not checked))
            menu.addAction(action)
        menu.exec(self.settings_button.mapToGlobal(self.settings_button.rect().bottomLeft()))

    def on_worker_error(self, message: str) -> None:
        """
        Show a worker error in the footer.

        :param message: Error emitted by a background worker.
        """
        self.scan_running = False
        self.scan_status_label.setText(f"Error: {message}")

    def closeEvent(self, event: Any) -> None:
        """Persist non-secret preferences when the window closes."""
        self._save_scan_settings()
        super().closeEvent(event)

    def _selected_records(self) -> list[DeviceRecord]:
        """
        Return all selected device records.

        :return: Selected records mapped from proxy rows to source rows.
        """
        rows = self.table.selectionModel().selectedRows()
        records = []
        for proxy_index in rows:
            source_index = self.proxy.mapToSource(proxy_index)
            record = self.model.record_at(source_index.row())
            if record is not None:
                records.append(record)
        return records

    def _populate_details(self, payload: dict[str, Any]) -> None:
        """
        Render raw device detail dictionaries in the right-side tree.

        :param payload: Detail payload or record raw data.
        """
        self.detail_tree.clear()
        details = payload.get("details") or {}
        record = payload.get("record")
        if isinstance(record, DeviceRecord):
            summary = QTreeWidgetItem(["Device", record.ip])
            for key in ("hostname", "activation_status", "firmware_version", "dronebridge_version",
                        "mavlink_sys_id", "wifi_ssid", "wifi_channel", "rssi", "mac", "source"):
                summary.addChild(QTreeWidgetItem([key, str(getattr(record, key))]))
            self.detail_tree.addTopLevelItem(summary)
        for group_name in ("system_info", "settings", "stats", "errors"):
            group_data = details.get(group_name)
            if isinstance(group_data, dict) and group_data:
                parent = QTreeWidgetItem([group_name, ""])
                for key, value in sorted(group_data.items()):
                    parent.addChild(QTreeWidgetItem([str(key), str(value)]))
                self.detail_tree.addTopLevelItem(parent)
        self.detail_tree.expandToDepth(1)

    def _save_scan_settings(self) -> None:
        """Persist non-secret discovery and view preferences."""
        self.settings.setValue("subnet", self.subnet_edit.text().strip())
        self.settings.setValue("update_rate", self.update_rate_spin.value())
        self.settings.setValue("esp32_port", self.esp32_port_spin.value())
        self.settings.setValue("local_port", self.local_port_spin.value())
        self.settings.setValue("http_scan", "true" if self.http_scan_check.isChecked() else "false")
        self.settings.setValue("mavlink_scan", "true" if self.mavlink_scan_check.isChecked() else "false")

    def _suite_version(self) -> str:
        """
        Return installed package version for the footer.

        :return: Package version or ``local`` when the project is not installed.
        """
        try:
            return version("DLSECommercialSupportSuite")
        except PackageNotFoundError:
            return "local"


def main() -> int:
    """
    Run the PySide6 application.

    :return: Qt application exit code.
    """
    app = QApplication(sys.argv)
    load_fonts()
    app.setStyleSheet(app_stylesheet())
    window = MainWindow()
    window.show()
    return app.exec()

"""Qt Quick application bootstrap for the DroneBridge Fleet Manager."""

from __future__ import annotations

import os
import sys
from pathlib import Path

os.environ.setdefault("QT_QUICK_CONTROLS_STYLE", "Basic")

from PySide6.QtCore import QUrl
from PySide6.QtGui import QFont, QFontDatabase, QGuiApplication, QIcon
from PySide6.QtQml import QQmlApplicationEngine

from ui.controller import FleetController


UI_ROOT = Path(__file__).resolve().parent
QML_ROOT = UI_ROOT / "qml"
RESOURCE_ROOT = UI_ROOT / "resources"
MATERIAL_FONT = (
    RESOURCE_ROOT
    / "Material_Symbols_Outlined"
    / "MaterialSymbolsOutlined[FILL,GRAD,opsz,wght].ttf"
)
GEIST_FONT_ROOT = RESOURCE_ROOT / "fonts" / "Geist"
GEIST_FONT = GEIST_FONT_ROOT / "Geist[wght].ttf"
GEIST_MONO_FONT = GEIST_FONT_ROOT / "GeistMono[wght].ttf"
BUNDLED_FONTS = (MATERIAL_FONT, GEIST_FONT, GEIST_MONO_FONT)
DEFAULT_FONT_PIXEL_SIZE = 13


def _initialize_webengine() -> None:
    """Initialize Qt WebEngine Quick when included in the PySide6 build."""
    try:
        from PySide6.QtWebEngineQuick import QtWebEngineQuick
    except ImportError:
        return
    QtWebEngineQuick.initialize()


def _load_fonts() -> None:
    """Register each available bundled font with Qt.

    Missing files and fonts rejected by Qt are skipped. The function performs
    no network access and returns no value.
    """
    for font_path in BUNDLED_FONTS:
        if font_path.is_file():
            QFontDatabase.addApplicationFont(str(font_path))


def _set_default_font(app: QGuiApplication) -> None:
    """Set ``app`` to the body size used by QML text without an override.

    The application is updated in place and the function does not return a
    value. Qt retains responsibility for scaling this logical pixel size for
    the active display.
    """
    default_font = QFont(app.font())
    default_font.setPixelSize(DEFAULT_FONT_PIXEL_SIZE)
    app.setFont(default_font)


def create_engine() -> tuple[QQmlApplicationEngine, FleetController]:
    """Create the QML engine and expose stable controller/model properties."""
    engine = QQmlApplicationEngine()
    controller = FleetController()
    engine.addImportPath(str(QML_ROOT))
    context = engine.rootContext()
    context.setContextProperty("fleetController", controller)
    context.setContextProperty("fleetModel", controller.fleet_model)
    context.setContextProperty("fleetCardModel", controller.card_model)
    engine.load(QUrl.fromLocalFile(str(QML_ROOT / "App.qml")))
    return engine, controller


def main() -> int:
    """Run the cross-platform Qt Quick application and return its exit code."""
    os.environ.setdefault("QT_ENABLE_HIGHDPI_SCALING", "1")
    _initialize_webengine()
    app = QGuiApplication(sys.argv)
    app.setOrganizationName("DroneBridge")
    app.setApplicationName("DLSECommercialSupportSuite")
    app.setApplicationDisplayName("DroneBridge DLSE Commercial Support Suite")
    icon_path = RESOURCE_ROOT / "images" / "app_icon.png"
    if icon_path.is_file():
        app.setWindowIcon(QIcon(str(icon_path)))
    _load_fonts()
    _set_default_font(app)
    engine, controller = create_engine()
    if not engine.rootObjects():
        return 1
    app._fleet_controller = controller
    app._qml_engine = engine
    return app.exec()

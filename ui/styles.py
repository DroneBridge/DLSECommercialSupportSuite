"""Qt stylesheet and resource helpers for the DroneBridge UI."""

from pathlib import Path

from PySide6.QtGui import QFontDatabase


UI_ROOT = Path(__file__).resolve().parent
RESOURCE_ROOT = UI_ROOT / "resources"
IMAGE_ROOT = RESOURCE_ROOT / "images"
MATERIAL_FONT = RESOURCE_ROOT / "Material_Symbols_Outlined" / "MaterialSymbolsOutlined[FILL,GRAD,opsz,wght].ttf"


def load_fonts() -> None:
    """
    Register bundled UI fonts with Qt.

    The function is best-effort because the UI can still run when the Material
    Symbols font is missing from a source checkout.
    """
    if MATERIAL_FONT.exists():
        QFontDatabase.addApplicationFont(str(MATERIAL_FONT))


def app_stylesheet() -> str:
    """
    Return the dark DroneBridge stylesheet used by the PySide6 application.

    :return: Qt stylesheet string using the colors defined in ``ui/requirements.md``.
    """
    return """
    QWidget {
        background: #081c30;
        color: #e8e8e8;
        font-family: Arial;
        font-size: 13px;
    }
    QFrame#Panel, QTableView, QTreeWidget, QLineEdit, QSpinBox, QComboBox {
        background: #1a1a1a;
        border: 1px solid #e7e7e7;
        border-radius: 5px;
    }
    QLabel#Brand {
        color: #ffa500;
        font-size: 16px;
        font-weight: regular;
    }
    QLabel#Heading {
        color: #ffffff;
        font-size: 16px;
        font-weight: bold;
    }
    QPushButton {
        background: #102942;
        border: 1px solid #e7e7e7;
        border-radius: 5px;
        padding: 7px 10px;
        color: #ffffff;
    }
    QPushButton:hover {
        border-color: #ffa500;
    }
    QPushButton:disabled {
        color: #777777;
        border-color: #555555;
    }
    QPushButton#Primary {
        background: #ffa500;
        color: #081c30;
        border-color: #ffa500;
        font-weight: bold;
    }
    QHeaderView::section {
        background: #102942;
        color: #ffffff;
        padding: 6px;
        border: 0;
        border-right: 1px solid #30465e;
        font-weight: bold;
    }
    QTableView {
        gridline-color: #30465e;
        selection-background-color: #ffa500;
        selection-color: #081c30;
        alternate-background-color: #142131;
    }
    QTreeWidget::item {
        padding: 4px;
    }
    QLineEdit, QSpinBox, QComboBox {
        padding: 5px;
    }
    QCheckBox {
        spacing: 7px;
    }
    QLabel#FooterOk {
        color: #51d88a;
        font-weight: bold;
    }
    QLabel#FooterBad {
        color: #ff7b7b;
        font-weight: bold;
    }
    """


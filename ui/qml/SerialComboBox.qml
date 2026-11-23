import QtQuick

AppComboBox {
    id: control
    indicator: Image {
        x: control.width - width - 10
        anchors.verticalCenter: parent.verticalCenter
        width: 16; height: 16
        source: Qt.resolvedUrl("../resources/images/keyboard_arrow_right_24dp.svg")
        rotation: 90
        opacity: control.enabled ? 0.8 : 0.35
    }
}

import QtQuick
import QtQuick.Controls

CheckBox {
    id: control

    spacing: 7
    hoverEnabled: true

    Theme { id: theme }

    indicator: Rectangle {
        implicitWidth: 17
        implicitHeight: 17
        x: control.leftPadding
        y: (control.height - height) / 2
        radius: 4
        color: control.checked ? theme.accent : "transparent"
        border.width: control.activeFocus ? 2 : 1
        border.color: control.activeFocus || control.hovered ? theme.accent : theme.border

        Text {
            anchors.centerIn: parent
            visible: control.checked
            text: "✓"
            color: theme.background
            font.pixelSize: 13
            font.bold: true
        }
    }

    contentItem: Text {
        leftPadding: control.indicator.width + control.spacing
        text: control.text
        color: control.enabled ? theme.secondaryText : theme.mutedText
        font.family: theme.dataFont
        font.pixelSize: 10
        verticalAlignment: Text.AlignVCenter
    }
}

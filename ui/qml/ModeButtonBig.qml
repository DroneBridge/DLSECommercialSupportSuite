import QtQuick
import QtQuick.Controls

Button {
    id: control

    property string title: "Direct Standalone"
    property string description: "The application detects and directly connects to each drone.\nUse for updating, activating, and configuring a DLSE fleet."

    implicitWidth: 400
    implicitHeight: 180
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus

    Theme { id: theme }

    background: Rectangle {
        radius: 5
        color: control.down ? theme.panel : (control.hovered ? Qt.rgba(10 / 255, 28 / 255, 46 / 255, 0.82) : "transparent")
        border.width: control.activeFocus ? 2 : 1
        border.color: control.activeFocus || control.hovered ? theme.accent : "#f0f0f0"
    }

    contentItem: Item {
        Text {
            id: titleText
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 24
            text: control.title
            color: "#f0f0f0"
            font.family: theme.bodyFont
            font.pixelSize: theme.headingTextSize
            font.bold: true
        }

        Text {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: titleText.bottom
            anchors.topMargin: 18
            anchors.leftMargin: 24
            anchors.rightMargin: 24
            text: control.description
            color: "#f0f0f0"
            font.family: theme.bodyFont
            font.pixelSize: theme.bodyTextSize
            wrapMode: Text.Wrap
        }
    }
}

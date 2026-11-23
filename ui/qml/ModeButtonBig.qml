import QtQuick
import QtQuick.Controls

Button {
    id: control

    property string title: "Direct Standalone"
    property string description: "The application detects and directly connects to each drone.\nUse for updating, activating, and configuring a DLSE fleet."
    property bool centerContent: false

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
            anchors.top: control.centerContent ? undefined : parent.top
            y: control.centerContent ? (parent.height - height - descriptionText.height - 8) / 2 : 0
            anchors.leftMargin: 24
            anchors.rightMargin: 24
            anchors.topMargin: 24
            text: control.title
            color: "#f0f0f0"
            font.family: theme.bodyFont
            font.pixelSize: theme.headingTextSize
            font.bold: true
        }

        Text {
            id: descriptionText
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: titleText.bottom
            anchors.topMargin: control.height <= 100 ? 8 : 18
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

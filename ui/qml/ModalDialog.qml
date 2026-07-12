import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Dialog {
    id: dialog

    default property alias bodyData: body.data
    property int preferredWidth: 520
    property bool autoCenter: true

    function centerInParent() {
        if (!autoCenter)
            return
        const owner = parent || Overlay.overlay
        if (!owner)
            return
        x = Math.max(24, Math.round((owner.width - width) / 2))
        y = Math.max(24, Math.round((owner.height - height) / 2))
    }

    width: Math.min(preferredWidth, parent ? parent.width - 48 : preferredWidth)
    modal: true
    closePolicy: Popup.CloseOnEscape
    padding: 18
    onOpened: centerTimer.restart()
    onHeightChanged: {
        if (opened)
            centerTimer.restart()
    }
    onWidthChanged: {
        if (opened)
            centerTimer.restart()
    }

    Timer {
        id: centerTimer
        interval: 0
        repeat: false
        onTriggered: dialog.centerInParent()
    }

    Theme { id: theme }

    background: Rectangle {
        color: theme.panel
        border.color: theme.border
        border.width: 1
        radius: 6
    }

    header: Rectangle {
        implicitHeight: 48
        color: theme.panel

        Text {
            anchors.left: parent.left
            anchors.right: closeButton.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 18
            text: dialog.title
            color: theme.primaryText
            font.family: theme.bodyFont
            font.pixelSize: 16
            font.bold: true
            elide: Text.ElideRight
        }

        ToolButton {
            id: closeButton
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 8
            text: "×"
            onClicked: dialog.close()
            contentItem: Text {
                text: closeButton.text
                color: theme.secondaryText
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle { color: closeButton.hovered ? theme.hover : "transparent" }
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 1
            color: theme.border
        }
    }

    contentItem: ColumnLayout {
        id: body
        spacing: 12
    }
}

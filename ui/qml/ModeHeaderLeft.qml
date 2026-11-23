import QtQuick
import QtQuick.Layouts

RowLayout {
    id: header

    property string modeLabel: "STANDALONE MODE"
    property string modeButtonObjectName: "standaloneModeButton"
    property int modeButtonWidth: 150
    signal backRequested()

    Layout.preferredWidth: implicitWidth
    Layout.preferredHeight: 64
    spacing: 12

    Theme { id: theme }

    Item {
        Layout.leftMargin: 12
        Layout.preferredWidth: 136
        Layout.fillHeight: true

        Image {
            objectName: "modeHeaderLogo"
            anchors.centerIn: parent
            width: 122; height: 32
            source: Qt.resolvedUrl("assets/droneBridgeLogo_1.png")
            fillMode: Image.PreserveAspectFit
            sourceSize.width: 122; sourceSize.height: 32
        }
    }

    FocusScope {
        id: modeButton
        objectName: header.modeButtonObjectName
        Layout.preferredWidth: header.modeButtonWidth
        Layout.preferredHeight: 30
        activeFocusOnTab: true
        Accessible.role: Accessible.Button
        Accessible.name: header.modeLabel
        Accessible.description: "Return to the start screen"

        Rectangle {
            anchors.fill: parent
            radius: 5
            color: modeMouse.containsMouse || modeButton.activeFocus ? theme.hover : "#35322e"

            Text {
                objectName: "modeHeaderLabel"
                anchors.centerIn: parent
                text: header.modeLabel
                color: theme.accent
                font.family: theme.bodyFont
                font.pixelSize: theme.smallTextSize
                font.bold: true
            }
        }

        MouseArea {
            id: modeMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onPressed: modeButton.forceActiveFocus()
            onClicked: header.backRequested()
        }

        Keys.onSpacePressed: header.backRequested()
        Keys.onReturnPressed: header.backRequested()
        Keys.onEnterPressed: header.backRequested()
    }
}

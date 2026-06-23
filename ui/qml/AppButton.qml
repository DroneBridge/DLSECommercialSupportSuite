import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Button {
    id: control

    property string iconSource: ""
    property bool emphasized: false
    property bool quiet: false
    property color accentColor: theme.accent
    readonly property color foregroundColor: !enabled
                                             ? theme.mutedText
                                             : (emphasized ? accentColor : theme.primaryText)

    implicitHeight: 34
    implicitWidth: Math.max(96, contentRow.implicitWidth + 28)
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus

    Theme { id: theme }

    background: Rectangle {
        radius: 5
        color: {
            if (!control.enabled)
                return theme.panel
            if (control.down)
                return Qt.darker(control.emphasized ? control.accentColor : theme.raised, 1.25)
            if (control.hovered)
                return control.emphasized ? Qt.rgba(control.accentColor.r, control.accentColor.g, control.accentColor.b, 0.16) : theme.hover
            if (control.quiet)
                return "transparent"
            return control.emphasized ? Qt.rgba(control.accentColor.r, control.accentColor.g, control.accentColor.b, 0.10) : theme.raised
        }
        border.width: control.activeFocus || control.emphasized ? 1 : (control.quiet ? 0 : 1)
        border.color: control.activeFocus || control.emphasized ? control.accentColor : theme.border
    }

    contentItem: RowLayout {
        id: contentRow
        spacing: 8

        Image {
            visible: control.iconSource.length > 0
            source: control.iconSource
            sourceSize.width: 18
            sourceSize.height: 18
            Layout.preferredWidth: visible ? 18 : 0
            Layout.preferredHeight: 18
            fillMode: Image.PreserveAspectFit
            opacity: control.enabled ? 1 : 0.35
        }

        Text {
            Layout.fillWidth: true
            text: control.text
            color: control.foregroundColor
            font.family: theme.bodyFont
            font.pixelSize: 12
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }
}

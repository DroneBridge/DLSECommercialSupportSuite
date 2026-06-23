import QtQuick
import QtQuick.Controls

TextField {
    id: control

    color: theme.primaryText
    placeholderTextColor: theme.mutedText
    selectionColor: theme.accent
    selectedTextColor: theme.background
    font.family: theme.bodyFont
    font.pixelSize: 12
    leftPadding: 10
    rightPadding: 10

    Theme { id: theme }

    background: Rectangle {
        radius: 5
        color: theme.panel
        border.width: control.activeFocus ? 1 : 1
        border.color: control.activeFocus ? theme.accent : theme.border
    }
}

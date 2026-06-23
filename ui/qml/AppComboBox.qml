import QtQuick
import QtQuick.Controls

ComboBox {
    id: control

    implicitHeight: 34
    leftPadding: 10
    rightPadding: 28
    font.family: theme.bodyFont
    font.pixelSize: 12

    Theme { id: theme }

    contentItem: Text {
        leftPadding: 2
        text: control.displayText
        color: theme.primaryText
        font: control.font
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    indicator: Text {
        x: control.width - width - 10
        anchors.verticalCenter: parent.verticalCenter
        text: "⌄"
        color: theme.secondaryText
        font.pixelSize: 16
    }

    background: Rectangle {
        radius: 5
        color: theme.panel
        border.width: 1
        border.color: control.activeFocus ? theme.accent : theme.border
    }

    popup: Popup {
        y: control.height + 2
        width: control.width
        implicitHeight: contentItem.implicitHeight + 8
        padding: 4

        contentItem: ListView {
            clip: true
            implicitHeight: Math.min(contentHeight, 240)
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex
            ScrollIndicator.vertical: ScrollIndicator {}
        }

        background: Rectangle {
            color: theme.panel
            border.color: theme.border
            radius: 5
        }
    }

    delegate: ItemDelegate {
        id: optionDelegate
        required property int index
        required property var modelData
        width: control.width - 8
        highlighted: control.highlightedIndex === optionDelegate.index
        contentItem: Text {
            text: control.textRole.length > 0 && optionDelegate.modelData
                  ? optionDelegate.modelData[control.textRole]
                  : optionDelegate.modelData
            color: theme.primaryText
            font: control.font
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            color: optionDelegate.highlighted ? theme.raised : "transparent"
        }
    }
}

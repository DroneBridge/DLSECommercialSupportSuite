import QtQuick
import QtQuick.Controls

ToolTip {
    id: settingToolTip

    property Item anchorItem

    Theme { id: theme }

    parent: anchorItem
    x: 0
    y: anchorItem ? anchorItem.height + 4 : 0
    contentItem: Text {
        text: settingToolTip.text
        color: theme.primaryText
        font: settingToolTip.font
        wrapMode: Text.Wrap
    }
    background: SettingTooltipBackground {}
}

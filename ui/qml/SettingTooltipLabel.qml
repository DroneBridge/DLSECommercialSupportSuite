import QtQuick
import QtQuick.Controls

Text {
    id: settingTooltipLabel

    property string tooltipText: ""

    SettingToolTip {
        anchorItem: settingTooltipLabel
        visible: labelHover.hovered && settingTooltipLabel.tooltipText.length > 0
        delay: 500
        text: settingTooltipLabel.tooltipText
    }

    HoverHandler { id: labelHover }
}

import QtQuick

Rectangle {
    id: badge

    property string status: ""
    property bool critical: false
    readonly property string normalized: status.toLowerCase()
    readonly property color backgroundColor: {
        if (critical)
            return "#52141e"
        if (normalized.indexOf("activated") >= 0 || normalized === "online" || normalized === "complete")
            return "#16554a"
        if (normalized.indexOf("evaluation") >= 0 || normalized.indexOf("waiting") >= 0 || normalized.indexOf("queued") >= 0)
            return "#43361b"
        if (normalized.indexOf("fail") >= 0 || normalized.indexOf("expired") >= 0 || normalized === "offline")
            return "#52141e"
        return "#162330"
    }
    readonly property color foregroundColor: {
        if (critical)
            return theme.error
        if (normalized.indexOf("activated") >= 0 || normalized === "online" || normalized === "complete")
            return theme.success
        if (normalized.indexOf("evaluation") >= 0 || normalized.indexOf("waiting") >= 0 || normalized.indexOf("queued") >= 0)
            return theme.warning
        if (normalized.indexOf("fail") >= 0 || normalized.indexOf("expired") >= 0 || normalized === "offline")
            return theme.error
        return theme.primaryText
    }

    implicitHeight: 22
    implicitWidth: label.implicitWidth + 14
    radius: 4
    color: backgroundColor

    Theme { id: theme }

    Text {
        id: label
        anchors.centerIn: parent
        text: badge.status.length ? badge.status.toUpperCase() : "-"
        color: badge.foregroundColor
        font.family: theme.dataFont
        font.pixelSize: 9
        font.bold: true
    }
}

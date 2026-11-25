import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: strip
    objectName: "otaStatusStrip"

    required property var controller
    required property real detailHeightLimit
    readonly property var batch: controller.otaProgress
    readonly property bool finished: batch.phase === "finished"
    property bool expanded: false

    visible: batch.phase !== ""
    onVisibleChanged: if (!visible) expanded = false
    implicitHeight: content.implicitHeight + 16
    color: theme.panel
    border.color: theme.border
    radius: 6

    Theme { id: theme }

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: 8
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 6

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Text {
                text: "OTA upgrade"
                color: theme.primaryText
                font.family: theme.bodyFont
                font.pixelSize: theme.bodyTextSize
                font.bold: true
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    objectName: "otaBatchSummary"
                    Layout.fillWidth: true
                    text: {
                        if (strip.batch.phase === "preparing")
                            return "Preparing release…"
                        if (!strip.batch.total)
                            return "Upgrade could not start"
                        const counts = [strip.batch.processed + " of " + strip.batch.total + " processed",
                                        strip.batch.accepted + " accepted", strip.batch.failed + " failed"]
                        if (!strip.finished)
                            counts.push(strip.batch.active + " active", strip.batch.queued + " queued")
                        if (strip.batch.skipped)
                            counts.push(strip.batch.skipped + " skipped")
                        if (strip.batch.cancelled)
                            counts.push(strip.batch.cancelled + " cancelled")
                        return counts.join("  ·  ")
                    }
                    color: strip.batch.error.length ? theme.error : theme.primaryText
                    font.family: theme.bodyFont
                    font.pixelSize: theme.smallTextSize
                    wrapMode: Text.Wrap
                }

                Rectangle {
                    id: progressTrack
                    Layout.fillWidth: true
                    Layout.preferredHeight: 3
                    visible: strip.batch.total > 0
                    color: theme.raised
                    radius: 1.5

                    Row {
                        anchors.fill: parent

                        Repeater {
                            model: [
                                { count: strip.batch.accepted, color: theme.success },
                                { count: strip.batch.failed, color: theme.error },
                                { count: strip.batch.skipped + strip.batch.cancelled, color: theme.secondaryText }
                            ]

                            Rectangle {
                                required property var modelData
                                width: strip.batch.total ? progressTrack.width * modelData.count / strip.batch.total : 0
                                height: progressTrack.height
                                color: modelData.color
                            }
                        }
                    }
                }
            }

            AppButton {
                objectName: "otaDetailsButton"
                visible: strip.batch.total > 0
                text: strip.expanded ? "Hide details" : "Details"
                quiet: true
                onClicked: strip.expanded = !strip.expanded
            }

            AppButton {
                objectName: "otaCancelQueuedButton"
                visible: strip.batch.phase === "running" || strip.batch.phase === "cancelling"
                enabled: strip.batch.phase === "running" && strip.batch.queued > 0
                text: "Cancel Queued"
                accentColor: theme.warning
                emphasized: true
                onClicked: strip.controller.cancelActiveOperation()
            }

            AppButton {
                objectName: "otaRetryFailedButton"
                visible: strip.finished && strip.batch.failed > 0
                enabled: strip.controller.activeOperation.length === 0
                text: "Retry Failed"
                onClicked: strip.controller.retryOtaFailures()
            }

            AppButton {
                objectName: "otaDismissButton"
                visible: strip.finished
                text: "Dismiss"
                quiet: true
                onClicked: strip.controller.dismissOtaSummary()
            }
        }

        Text {
            Layout.fillWidth: true
            visible: text.length > 0
            text: strip.batch.error || (strip.batch.phase === "cancelling" ? "Finishing active uploads…" : "")
            textFormat: Text.PlainText
            color: strip.batch.error.length ? theme.error : theme.secondaryText
            font.family: theme.bodyFont
            font.pixelSize: theme.smallTextSize
            wrapMode: Text.Wrap
        }

        ListView {
            objectName: "otaDeviceDetails"
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(strip.detailHeightLimit, Math.max(contentHeight, count * 26))
            visible: strip.expanded && strip.batch.total > 0
            clip: true
            model: visible ? strip.controller.otaDetails : null
            boundsBehavior: Flickable.StopAtBounds
            reuseItems: true
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

            delegate: Rectangle {
                id: detailRow
                required property var device
                width: ListView.view ? ListView.view.width - 12 : 0
                height: detailContent.implicitHeight + 10
                color: theme.background

                RowLayout {
                    id: detailContent
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: 12

                    Text {
                        Layout.preferredWidth: 248
                        text: detailRow.device.hostname
                              ? detailRow.device.hostname + "  ·  " + detailRow.device.ip
                              : detailRow.device.ip
                        textFormat: Text.PlainText
                        elide: Text.ElideRight
                        color: theme.primaryText
                        font.family: theme.dataFont
                        font.pixelSize: theme.smallTextSize
                    }

                    Text {
                        Layout.preferredWidth: 260
                        text: detailRow.device.stage + (detailRow.device.uploading ? "  " + detailRow.device.percent + "%" : "")
                        color: detailRow.device.state === "failed" ? theme.error
                             : detailRow.device.state === "active" ? theme.accent
                             : detailRow.device.state === "accepted" ? theme.success
                             : theme.secondaryText
                        font.family: theme.bodyFont
                        font.pixelSize: theme.smallTextSize
                    }

                    Text {
                        Layout.fillWidth: true
                        text: detailRow.device.message
                        textFormat: Text.PlainText
                        color: theme.error
                        font.family: theme.bodyFont
                        font.pixelSize: theme.smallTextSize
                        wrapMode: Text.Wrap
                    }
                }
            }
        }
    }
}

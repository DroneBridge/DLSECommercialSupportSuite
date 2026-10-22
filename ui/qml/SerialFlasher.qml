import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts

Item {
    id: page
    objectName: "serialFlasherScreen"
    signal backRequested()
    Theme { id: theme }
    property var defaults: serialController.preferences
    readonly property var modes: ["activated", "evaluation", "offline"]

    Connections {
        target: serialController
        function onStopped() { indexField.text = String(serialController.preferences.index) }
        function onChanged() {
            if (serialController.state === "review") reviewScrollTimer.restart()
        }
    }

    Timer {
        id: reviewScrollTimer
        interval: 50
        onTriggered: setupScroll.contentItem.contentY = Math.max(0, setupScroll.contentHeight - setupScroll.availableHeight)
    }

    function changedInput() { serialController.invalidateReview() }
    function prepareReview() {
        const options = serialController.releases
        const optionId = releaseSource.currentIndex === 1 && releasePicker.currentIndex >= 0
                         ? options[releasePicker.currentIndex].id : ""
        serialController.prepare(releaseField.text,
            settingsSource.currentIndex === 1 ? settingsField.text : "",
            indexField.text, baudField.text, modes[licenseMode.currentIndex], tokenField.text, optionId)
    }

    Rectangle { anchors.fill: parent; color: theme.background }
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 14

        RowLayout {
            Layout.fillWidth: true
            AppButton { objectName: "serialBackButton"; text: "‹ Back"; quiet: true; onClicked: page.backRequested() }
            Text { text: "Serial Batch Flasher"; color: theme.primaryText; font.family: theme.bodyFont; font.pixelSize: theme.headingTextSize; font.bold: true }
            Item { Layout.fillWidth: true }
            Text {
                objectName: "serialState"
                text: serialController.state.toUpperCase()
                color: serialController.state === "paused" ? theme.warning : theme.secondaryText
                font.family: theme.dataFont
            }
            AppButton {
                objectName: "serialStopButton"
                text: serialController.state === "stopping" ? "Stopping…" : "Stop"
                enabled: serialController.locked && serialController.state !== "stopping"
                onClicked: serialController.stop()
            }
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: activityRow.implicitHeight + 24
            color: theme.panel; radius: 6
            border.color: serialController.state === "paused" ? theme.warning : theme.border
            RowLayout {
                id: activityRow
                anchors.fill: parent; anchors.margins: 12; spacing: 12
                BusyIndicator {
                    objectName: "serialBusyIndicator"
                    running: serialController.busy
                    visible: running
                    Layout.preferredWidth: 32; Layout.preferredHeight: 32
                }
                ColumnLayout {
                    Layout.fillWidth: true; spacing: 4
                    Text { text: "CURRENT ACTIVITY"; color: theme.mutedText; font.family: theme.bodyFont; font.pixelSize: theme.smallTextSize }
                    Text {
                        objectName: "serialActivity"
                        Layout.fillWidth: true
                        text: serialController.activity
                        color: theme.primaryText; font.family: theme.bodyFont
                        font.pixelSize: theme.bodyTextSize; wrapMode: Text.Wrap
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true; Layout.fillHeight: true; spacing: 16

            Rectangle {
                Layout.preferredWidth: 370; Layout.fillHeight: true
                color: theme.panel; radius: 6; border.color: theme.border
                ScrollView {
                    id: setupScroll
                    objectName: "serialSetupScroll"
                    anchors.fill: parent; anchors.margins: 14
                    clip: true
                    contentWidth: availableWidth
                    contentHeight: setupForm.implicitHeight
                    ColumnLayout {
                        id: setupForm
                        objectName: "serialSetupForm"
                        width: setupScroll.availableWidth; height: implicitHeight; spacing: 10
                        Text { text: "1  Firmware and settings"; color: theme.primaryText; font.family: theme.bodyFont; font.bold: true; font.pixelSize: theme.headingTextSize }
                        ColumnLayout {
                            Layout.fillWidth: true; enabled: !serialController.locked
                            Text { text: "Firmware source"; color: theme.secondaryText; font.family: theme.bodyFont }
                            SerialComboBox {
                                id: releaseSource; Layout.fillWidth: true
                                model: ["Local release folder", "Cached / account release"]
                                onCurrentIndexChanged: page.changedInput()
                            }
                            RowLayout {
                                Layout.fillWidth: true; visible: releaseSource.currentIndex === 0
                                AppTextField {
                                    id: releaseField; objectName: "serialReleaseField"
                                    Layout.fillWidth: true; text: page.defaults.release
                                    placeholderText: "Extracted release root folder"
                                    onTextEdited: page.changedInput()
                                }
                                AppButton { text: "Browse"; onClicked: releaseFolder.open() }
                            }
                            ColumnLayout {
                                Layout.fillWidth: true; visible: releaseSource.currentIndex === 1
                                SerialComboBox {
                                    id: releasePicker; Layout.fillWidth: true
                                    model: serialController.releases; textRole: "label"
                                    onCurrentIndexChanged: page.changedInput()
                                }
                                AppButton { text: "Refresh releases"; onClicked: serialController.refreshReleases(tokenField.text) }
                            }
                            Text { text: "Settings template"; color: theme.secondaryText; font.family: theme.bodyFont }
                            SerialComboBox {
                                id: settingsSource; Layout.fillWidth: true
                                model: ["Release defaults", "Exported settings CSV"]
                                currentIndex: page.defaults.settings.length > 0 ? 1 : 0
                                onCurrentIndexChanged: page.changedInput()
                            }
                            RowLayout {
                                Layout.fillWidth: true; visible: settingsSource.currentIndex === 1
                                AppTextField {
                                    id: settingsField; Layout.fillWidth: true
                                    text: page.defaults.settings; placeholderText: "Exported settings CSV"
                                    onTextEdited: page.changedInput()
                                }
                                AppButton { text: "Browse"; onClicked: settingsFile.open() }
                            }
                            Text { text: "2  Licensing and batch"; Layout.topMargin: 8; color: theme.primaryText; font.family: theme.bodyFont; font.bold: true; font.pixelSize: theme.headingTextSize }
                            SerialComboBox {
                                id: licenseMode; objectName: "serialLicenseMode"
                                Layout.fillWidth: true
                                model: ["Permanent activation", "60-day evaluation", "Offline permanent-license recovery"]
                                currentIndex: page.modes.indexOf(page.defaults.mode)
                                onCurrentIndexChanged: page.changedInput()
                            }
                            Text {
                                Layout.fillWidth: true
                                text: licenseMode.currentIndex === 2
                                      ? "Offline recovery uses only a matching permanent license from cache or the board. Account firmware downloads still need online access."
                                      : licenseMode.currentIndex === 1
                                        ? "Evaluation requires server access. Licenses expire after 60 days."
                                        : "Permanent activation falls back to cache or device recovery only when the license server is unavailable."
                                color: theme.mutedText; font.family: theme.bodyFont; wrapMode: Text.Wrap
                            }
                            Text { text: "License server token"; color: theme.secondaryText; font.family: theme.bodyFont }
                            AppTextField {
                                id: tokenField; objectName: "serialTokenField"
                                Layout.fillWidth: true
                                text: fleetController.environmentToken; echoMode: TextInput.Password
                                placeholderText: licenseMode.currentIndex === 2 ? "Optional; needed for account downloads" : "Required for online licensing"
                                onTextEdited: page.changedInput()
                            }
                            Text { text: "Token is used for this session only."; color: theme.mutedText; font.family: theme.bodyFont; font.pixelSize: theme.smallTextSize }
                            RowLayout {
                                Layout.fillWidth: true
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    Text { text: "Starting index"; color: theme.secondaryText; font.family: theme.bodyFont }
                                    AppTextField {
                                        id: indexField; objectName: "serialIndexField"; Layout.fillWidth: true
                                        text: String(page.defaults.index); validator: IntValidator { bottom: 0 }
                                        onTextEdited: page.changedInput()
                                    }
                                }
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    Text { text: "Flash baud"; color: theme.secondaryText; font.family: theme.bodyFont }
                                    AppTextField {
                                        id: baudField; Layout.fillWidth: true; text: String(page.defaults.baud)
                                        validator: IntValidator { bottom: 1; top: 4000000 }
                                        onTextEdited: page.changedInput()
                                    }
                                }
                            }
                            AppButton { text: "Use 115200 baud"; quiet: true; onClicked: { baudField.text = "115200"; page.changedInput() } }
                            AppButton {
                                objectName: "serialPrepareButton"
                                Layout.fillWidth: true; text: "Prepare review"; emphasized: true
                                onClicked: page.prepareReview()
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true; visible: serialController.state === "review"
                            Text { text: "3  Review and confirm"; color: theme.primaryText; font.family: theme.bodyFont; font.bold: true; font.pixelSize: theme.headingTextSize }
                            Text {
                                Layout.fillWidth: true
                                text: (serialController.review.release || "") + "\nSettings: " + (serialController.review.settings || "")
                                      + "\nMode: " + (serialController.review.mode || "") + " · baud " + (serialController.review.baud || "")
                                color: theme.secondaryText; font.family: theme.bodyFont; wrapMode: Text.Wrap
                            }
                            Repeater {
                                model: serialController.review.previews || []
                                delegate: Text {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    text: "Index " + modelData.index + " · " + (modelData.ip || "No static IP")
                                          + "\n" + modelData.hostname + " · AP " + modelData.ap
                                    color: theme.primaryText; font.family: theme.dataFont; wrapMode: Text.Wrap
                                }
                            }
                            Repeater {
                                model: serialController.review.warnings || []
                                delegate: Text {
                                    required property string modelData
                                    Layout.fillWidth: true; text: modelData
                                    color: theme.warning; font.family: theme.bodyFont; wrapMode: Text.Wrap
                                }
                            }
                            AppButton { objectName: "serialArmButton"; Layout.fillWidth: true; text: "Start monitoring…"; emphasized: true; onClicked: armDialog.open() }
                        }
                        Text {
                            Layout.fillWidth: true
                            text: "Reconnect already-connected boards after starting. Only new connections are processed, one board at a time. Keep boards connected until they finish."
                            color: theme.warning; font.family: theme.bodyFont; wrapMode: Text.Wrap
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true; Layout.fillHeight: true; spacing: 10
                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        objectName: "serialCounts"
                        text: "Successful " + serialController.counts.success + "   Failed " + serialController.counts.failed
                              + "   Skipped " + serialController.counts.skipped + "   Queued " + serialController.counts.queued
                        color: theme.secondaryText; font.family: theme.bodyFont
                    }
                    Item { Layout.fillWidth: true }
                }
                RowLayout {
                    visible: serialController.state === "paused"
                    AppButton { objectName: "serialRetryButton"; text: "Retry board"; emphasized: true; enabled: serialController.canRetry; onClicked: serialController.retry() }
                    AppButton {
                        objectName: "serialSkipButton"; text: "Skip board"
                        enabled: serialController.canRetry
                        onClicked: { if (serialController.skipRequiresConfirmation) skipDialog.open(); else serialController.skip(false) }
                    }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    color: theme.panel; border.color: theme.border; radius: 6
                    Flickable {
                        id: tableViewport
                        anchors.fill: parent; anchors.margins: 10; clip: true
                        contentWidth: Math.max(width, 988)
                        contentHeight: height
                        flickableDirection: Flickable.HorizontalFlick
                        ScrollBar.horizontal: ScrollBar {}
                        ColumnLayout {
                            width: tableViewport.contentWidth; height: tableViewport.height; spacing: 8
                            Row {
                                Layout.fillWidth: true; spacing: 8
                                Repeater {
                                    model: ["Port", "Chip", "Index", "IP", "Hostname", "AP name", "Stage / outcome"]
                                    delegate: Text {
                                        required property int index
                                        required property string modelData
                                        width: [90, 80, 50, 120, 130, 130, 240][index]
                                        text: modelData; color: theme.mutedText; font.family: theme.bodyFont; font.bold: true
                                    }
                                }
                            }
                            ListView {
                                id: results
                                objectName: "serialResults"
                                Layout.fillWidth: true; Layout.fillHeight: true
                                clip: true; spacing: 2; model: serialResultModel
                                ScrollBar.vertical: ScrollBar {}
                                delegate: Rectangle {
                                    required property var record
                                    width: results.width; height: 66
                                    color: record.outcome === "failed" ? "#30221c" : "transparent"
                                    Row {
                                        anchors.verticalCenter: parent.verticalCenter; spacing: 8
                                        Repeater {
                                            model: [record.port, record.chip, String(record.index), record.ip, record.hostname, record.ap, record.stage + "\n" + record.outcome]
                                            delegate: Text {
                                                required property int index
                                                required property string modelData
                                                width: [90, 80, 50, 120, 130, 130, 240][index]
                                                text: modelData; color: index === 6 && record.outcome === "success" ? theme.success : theme.primaryText
                                                font.family: theme.dataFont; font.pixelSize: theme.smallTextSize
                                                wrapMode: Text.Wrap; maximumLineCount: 3; elide: Text.ElideRight
                                            }
                                        }
                                    }
                                }
                                Text {
                                    anchors.centerIn: parent; visible: results.count === 0
                                    text: "Newly connected boards will appear here."
                                    color: theme.mutedText; font.family: theme.bodyFont
                                }
                            }
                        }
                    }
                }
                Text { text: "ACTIVITY HISTORY"; color: theme.mutedText; font.family: theme.bodyFont; font.pixelSize: theme.smallTextSize }
                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: 150
                    color: theme.panel; border.color: theme.border; radius: 6
                    ListView {
                        id: historyView
                        objectName: "serialHistory"
                        anchors.fill: parent; anchors.margins: 10; clip: true
                        model: serialController.history; spacing: 5
                        onCountChanged: Qt.callLater(function() { historyView.positionViewAtEnd() })
                        ScrollBar.vertical: ScrollBar {}
                        delegate: Text {
                            required property string modelData
                            width: historyView.width; text: modelData
                            color: theme.secondaryText; font.family: theme.dataFont
                            font.pixelSize: theme.smallTextSize; wrapMode: Text.Wrap
                        }
                    }
                }
                Text {
                    Layout.fillWidth: true
                    text: serialController.logPath ? "Log: " + serialController.logPath : ""
                    color: theme.mutedText; font.family: theme.bodyFont; font.pixelSize: theme.smallTextSize
                    elide: Text.ElideMiddle
                }
            }
        }
    }

    ModalDialog {
        id: armDialog; objectName: "serialArmDialog"; title: "Start automatic serial flashing?"
        Text {
            Layout.fillWidth: true
            text: "Every newly connected supported board will be flashed with the reviewed firmware, settings and license. This replaces its firmware and settings. Confirm the template and any warnings before starting. Reconnect boards that are already attached."
            color: theme.warning; font.family: theme.bodyFont; wrapMode: Text.Wrap
        }
        RowLayout {
            Item { Layout.fillWidth: true }
            AppButton { text: "Cancel"; quiet: true; onClicked: armDialog.close() }
            AppButton { text: "Confirm and monitor"; emphasized: true; onClicked: { armDialog.close(); serialController.arm() } }
        }
    }
    ModalDialog {
        id: skipDialog; objectName: "serialSkipDialog"; title: "Reserve this index and skip?"
        Text {
            Layout.fillWidth: true
            text: "Writing began, so this board may have received its assigned settings. Skipping reserves its index to avoid assigning the same identity to another board."
            color: theme.warning; font.family: theme.bodyFont; wrapMode: Text.Wrap
        }
        RowLayout {
            Item { Layout.fillWidth: true }
            AppButton { text: "Cancel"; quiet: true; onClicked: skipDialog.close() }
            AppButton { text: "Reserve and skip"; onClicked: { skipDialog.close(); serialController.skip(true) } }
        }
    }
    FolderDialog {
        id: releaseFolder; title: "Choose the extracted DLSE release root"
        onAccepted: { releaseField.text = selectedFolder.toString(); page.changedInput() }
    }
    FileDialog {
        id: settingsFile; title: "Choose exported settings CSV"
        nameFilters: ["Settings CSV (*.csv)"]; fileMode: FileDialog.OpenFile
        onAccepted: { settingsField.text = selectedFile.toString(); page.changedInput() }
    }
}

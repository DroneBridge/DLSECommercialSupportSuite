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
    readonly property var baudRates: [115200, 230400, 460800, 921600, 1500000]

    Connections {
        target: serialController
        function onStopped() { indexField.value = serialController.preferences.index }
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
        serialController.prepare(releaseSource.currentIndex === 0 ? releaseField.text : "",
            settingsSource.currentIndex === 1 ? settingsField.text : "",
            String(indexField.value), String(baudRates[baudField.currentIndex]), licenseToggle.checked ? "activated" : "none", tokenField.text, optionId)
    }

    Rectangle { anchors.fill: parent; color: theme.background }
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 14

        AppButton {
            id: backButton
            objectName: "serialBackButton"; text: "‹ Back"; quiet: true
            Layout.alignment: Qt.AlignLeft
            implicitWidth: 64; leftPadding: 0; rightPadding: 0
            contentItem: Text {
                text: backButton.text; color: backButton.foregroundColor
                font.family: theme.bodyFont; font.pixelSize: theme.bodyTextSize; font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: page.backRequested()
        }
        RowLayout {
            Layout.fillWidth: true
            Text { text: "Serial Batch Flasher"; color: theme.primaryText; font.family: theme.bodyFont; font.pixelSize: theme.headingTextSize; font.bold: true }
            Item { Layout.fillWidth: true }
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
                objectName: "serialSettingsPanel"
                Layout.preferredWidth: Math.min(740, page.width * 0.56); Layout.fillHeight: true
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
                        Text { text: "1. Firmware and Settings"; color: theme.primaryText; font.family: theme.bodyFont; font.bold: true; font.pixelSize: theme.headingTextSize }
                        Text {
                            objectName: "serialLicenseStatus"
                            text: "License server: " + (fleetController.licenseStatus === "unknown" ? "Checking…" : fleetController.licenseStatus === "checking" ? "Checking…" : fleetController.licenseStatus === "online" ? "Online" : "Offline")
                            color: fleetController.licenseStatus === "online" ? theme.success
                                   : fleetController.licenseStatus === "offline" ? theme.error : theme.warning
                            font.family: theme.bodyFont
                        }
                        ColumnLayout {
                            Layout.fillWidth: true; enabled: !serialController.locked
                            Text { text: "Firmware source"; color: theme.secondaryText; font.family: theme.bodyFont }
                            SerialComboBox {
                                id: releaseSource; objectName: "serialReleaseSource"; Layout.fillWidth: true
                                model: ["Local release folder", "DLSE online releases"]
                                currentIndex: 1
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
                                model: ["Release defaults", "Custom Settings CSV"]
                                currentIndex: page.defaults.settings.length > 0 ? 1 : 0
                                onCurrentIndexChanged: page.changedInput()
                            }
                            RowLayout {
                                Layout.fillWidth: true; visible: settingsSource.currentIndex === 1
                                AppTextField {
                                    id: settingsField; Layout.fillWidth: true
                                    text: page.defaults.settings; placeholderText: "Custom Settings CSV"
                                    onTextEdited: page.changedInput()
                                }
                                AppButton { text: "Browse"; onClicked: settingsFile.open() }
                            }
                            Text { text: "2. Licensing"; Layout.topMargin: 8; color: theme.primaryText; font.family: theme.bodyFont; font.bold: true; font.pixelSize: theme.headingTextSize }
                            AppCheckBox {
                                id: licenseToggle; objectName: "serialLicenseToggle"
                                text: "Flash license"; checked: true
                                onToggled: page.changedInput()
                            }
                            Text {
                                Layout.fillWidth: true
                                text: licenseToggle.checked
                                      ? "Permanent activation automatically uses a matching license from received_licenses/ or the board when the license server is unavailable. Online activation and firmware downloads require a token."
                                      : "Firmware and settings will be flashed without a license. No license will be requested or embedded. Replacing settings also removes any existing license on the board. Online firmware downloads still require a token."
                                color: licenseToggle.checked ? theme.mutedText : theme.warning
                                font.family: theme.bodyFont; wrapMode: Text.Wrap
                            }
                            Text { text: "License server token"; color: theme.secondaryText; font.family: theme.bodyFont }
                            AppTextField {
                                id: tokenField; objectName: "serialTokenField"
                                Layout.fillWidth: true
                                text: fleetController.environmentToken; echoMode: TextInput.Password
                                placeholderText: licenseToggle.checked ? "Required for online activation and downloads" : "Only needed for online firmware downloads"
                                onTextEdited: page.changedInput()
                            }
                            Text { text: "Token is used for this session only."; color: theme.mutedText; font.family: theme.bodyFont; font.pixelSize: theme.smallTextSize }
                            RowLayout {
                                Layout.fillWidth: true
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    Text { text: "Starting index"; color: theme.secondaryText; font.family: theme.bodyFont }
                                    SpinBox {
                                        id: indexField; objectName: "serialIndexField"; Layout.fillWidth: true
                                        from: 0; to: 2147483647; value: page.defaults.index; editable: true
                                        font.family: theme.dataFont; font.pixelSize: theme.bodyTextSize
                                        palette.text: theme.primaryText; palette.buttonText: theme.primaryText
                                        palette.base: theme.panel; palette.button: theme.raised
                                        textFromValue: function(value, locale) { return String(value) }
                                        valueFromText: function(text, locale) { return Number(text) }
                                        onValueChanged: page.changedInput()
                                    }
                                }
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    Text { text: "Flash baud"; color: theme.secondaryText; font.family: theme.bodyFont }
                                    SerialComboBox {
                                        id: baudField; objectName: "serialBaudSelector"; Layout.fillWidth: true
                                        model: page.baudRates.map(String)
                                        currentIndex: page.baudRates.indexOf(page.defaults.baud) >= 0 ? page.baudRates.indexOf(page.defaults.baud) : 2
                                        onCurrentIndexChanged: page.changedInput()
                                    }
                                }
                            }
                            AppButton {
                                objectName: "serialPrepareButton"
                                Layout.fillWidth: true; text: "Check and Validate Configuration"; emphasized: true
                                onClicked: page.prepareReview()
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true; visible: serialController.state === "review"
                            Text { text: "3. Review and Confirm"; color: theme.primaryText; font.family: theme.bodyFont; font.bold: true; font.pixelSize: theme.headingTextSize }
                            Text {
                                Layout.fillWidth: true
                                text: (serialController.review.release || "") + "\nSettings: " + (serialController.review.settings || "")
                                      + "\nLicense: " + (serialController.review.mode === "none" ? "Disabled — no license installed" : "Permanent activation") + " · baud " + (serialController.review.baud || "")
                                color: theme.secondaryText; font.family: theme.bodyFont; wrapMode: Text.Wrap
                            }
                            Text { text: "Config preview"; color: theme.primaryText; font.family: theme.bodyFont; font.bold: true }
                            Text {
                                Layout.fillWidth: true
                                text: "Preview of the next board assignments. No boards have been flashed by this validation."
                                color: theme.mutedText; font.family: theme.bodyFont; wrapMode: Text.Wrap
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
                            AppButton { objectName: "serialArmButton"; Layout.fillWidth: true; text: "Start flashing…"; emphasized: true; onClicked: armDialog.open() }
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
                              + "   Skipped " + serialController.counts.skipped
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
                Text { text: "Newly Connected Boards"; color: theme.primaryText; font.family: theme.bodyFont; font.bold: true }
                Rectangle {
                    objectName: "serialConnectedPanel"
                    Layout.fillWidth: true; Layout.preferredHeight: 116
                    color: theme.panel; border.color: theme.border; radius: 6
                    Flickable {
                        id: tableViewport
                        anchors.fill: parent; anchors.margins: 10; clip: true
                        contentWidth: Math.max(width, 460)
                        contentHeight: height
                        flickableDirection: Flickable.HorizontalFlick
                        ScrollBar.horizontal: ScrollBar {}
                        ColumnLayout {
                            width: tableViewport.contentWidth; height: tableViewport.height; spacing: 8
                            Row {
                                Layout.fillWidth: true; spacing: 8
                                Repeater {
                                    model: ["Port", "Chip", "Index", "Stage"]
                                    delegate: Text {
                                        required property int index
                                        required property string modelData
                                        width: [80, 75, 50, tableViewport.contentWidth - 229][index]
                                        text: modelData; color: theme.mutedText; font.family: theme.bodyFont; font.bold: true
                                    }
                                }
                            }
                            ListView {
                                id: results
                                objectName: "serialResults"
                                Layout.fillWidth: true; Layout.fillHeight: true
                                clip: true; spacing: 2; model: serialConnectedModel
                                ScrollBar.vertical: ScrollBar {}
                                delegate: Rectangle {
                                    required property var record
                                    width: results.width; height: 32
                                    color: "transparent"
                                    Row {
                                        anchors.verticalCenter: parent.verticalCenter; spacing: 8
                                        Repeater {
                                            model: [record.port, record.chip, String(record.index), record.outcome === "queued" ? "Waiting for current board" : record.stage]
                                            delegate: Text {
                                                required property int index
                                                required property string modelData
                                                width: [80, 75, 50, tableViewport.contentWidth - 229][index]
                                                text: modelData; color: theme.primaryText
                                                font.family: theme.dataFont; font.pixelSize: theme.smallTextSize
                                                wrapMode: Text.Wrap; maximumLineCount: 2; elide: Text.ElideRight
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
                Text { text: "Flashed Boards / Results"; color: theme.primaryText; font.family: theme.bodyFont; font.bold: true }
                Rectangle {
                    objectName: "serialCompletedPanel"
                    Layout.fillWidth: true; Layout.preferredHeight: 100
                    color: theme.panel; border.color: theme.border; radius: 6
                    Flickable {
                        id: completedViewport
                        anchors.fill: parent; anchors.margins: 10; clip: true
                        contentWidth: Math.max(width, 450); contentHeight: height
                        flickableDirection: Flickable.HorizontalFlick
                        ScrollBar.horizontal: ScrollBar {}
                        ColumnLayout {
                            width: completedViewport.contentWidth; height: completedViewport.height; spacing: 6
                            Row {
                                spacing: 8
                                Repeater {
                                    model: ["Index", "Chip ID", "Configured IP", "Activation key", "Status"]
                                    delegate: Text {
                                        required property int index
                                        required property string modelData
                                        width: [44, 78, 112, 112, completedViewport.contentWidth - 378][index]
                                        text: modelData; color: theme.mutedText; font.family: theme.bodyFont
                                        font.pixelSize: theme.smallTextSize; font.bold: true
                                    }
                                }
                            }
                            ListView {
                                id: completedView; objectName: "serialCompletedResults"
                                Layout.fillWidth: true; Layout.fillHeight: true; clip: true
                                model: serialCompletedModel; spacing: 2
                                ScrollBar.vertical: ScrollBar {}
                                onCountChanged: Qt.callLater(function() { completedView.positionViewAtEnd() })
                                delegate: Row {
                                    required property var record
                                    width: completedView.width; height: 26; spacing: 8
                                    Repeater {
                                        model: [String(record.index), record.chip, record.ip || "—", record.activation_key || "—",
                                                record.outcome === "success" ? "Success" : record.outcome === "failed" ? "Fail" : "Skipped"]
                                        delegate: Text {
                                            required property int index
                                            required property string modelData
                                            width: [44, 78, 112, 112, completedViewport.contentWidth - 378][index]
                                            height: 26; verticalAlignment: Text.AlignVCenter
                                            text: modelData; elide: Text.ElideRight
                                            color: index !== 4 ? theme.primaryText : record.outcome === "success" ? theme.success : record.outcome === "failed" ? theme.error : theme.warning
                                            font.family: theme.dataFont; font.pixelSize: theme.smallTextSize
                                        }
                                    }
                                }
                                Text {
                                    anchors.centerIn: parent; visible: completedView.count === 0
                                    text: "Completed outcomes will appear here."
                                    color: theme.mutedText; font.family: theme.bodyFont
                                }
                            }
                        }
                    }
                }
                Text { text: "Activity History"; color: theme.primaryText; font.family: theme.bodyFont; font.bold: true }
                Rectangle {
                    objectName: "serialHistoryPanel"
                    Layout.fillWidth: true; Layout.fillHeight: true; Layout.minimumHeight: 130
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
            text: "Every newly connected supported board will be flashed with the reviewed firmware and settings"
                  + (licenseToggle.checked ? " and a permanent license." : " without a license. Any existing license on the board will be removed.")
                  + " This replaces its firmware and settings. Confirm the template and any warnings before starting. Reconnect boards that are already attached."
            color: theme.warning; font.family: theme.bodyFont; wrapMode: Text.Wrap
        }
        RowLayout {
            Item { Layout.fillWidth: true }
            AppButton { text: "Cancel"; quiet: true; onClicked: armDialog.close() }
            AppButton { text: "Confirm and start flashing"; emphasized: true; onClicked: { armDialog.close(); serialController.arm() } }
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
        id: settingsFile; title: "Choose Custom Settings CSV"
        nameFilters: ["Settings CSV (*.csv)"]; fileMode: FileDialog.OpenFile
        onAccepted: { settingsField.text = selectedFile.toString(); page.changedInput() }
    }
}

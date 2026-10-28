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
    Rectangle {
        id: serialHeader
        objectName: "serialHeader"
        anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right
        height: 64; color: theme.panel
        RowLayout {
            anchors.fill: parent; spacing: 12
            ModeHeaderLeft {
                modeLabel: "SERIAL BATCH FLASHER"
                modeButtonObjectName: "serialModeButton"
                modeButtonWidth: 190
                onBackRequested: page.backRequested()
            }
            Item { Layout.fillWidth: true }
            AppButton {
                objectName: "serialStopButton"
                Layout.rightMargin: 20
                text: serialController.state === "stopping" ? "Stopping…" : "Stop"
                enabled: serialController.locked && serialController.state !== "stopping"
                onClicked: serialController.stop()
            }
        }
    }
    ColumnLayout {
        anchors.top: serialHeader.bottom
        anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
        anchors.margins: 20
        spacing: 14

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: Math.max(48, activityRow.implicitHeight + 20)
            color: "#102a40"; radius: 6
            border.width: serialController.state === "paused" ? 1 : 0
            border.color: theme.error
            RowLayout {
                id: activityRow
                anchors.fill: parent; anchors.leftMargin: 14; anchors.rightMargin: 14; anchors.topMargin: 10; anchors.bottomMargin: 10; spacing: 12
                BusyIndicator {
                    objectName: "serialBusyIndicator"
                    running: serialController.busy
                    visible: running
                    Layout.preferredWidth: 32; Layout.preferredHeight: 32
                }
                Text {
                    text: "Current activity"; color: theme.secondaryText
                    font.family: theme.bodyFont; font.pixelSize: theme.smallTextSize; font.bold: true
                }
                Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 18; color: theme.border }
                Text {
                    objectName: "serialActivity"
                    Layout.fillWidth: true
                    text: serialController.activity
                    color: theme.primaryText; font.family: theme.bodyFont
                    font.pixelSize: theme.bodyTextSize; wrapMode: Text.Wrap
                }
            }
        }

        RowLayout {
            id: workspaceRow
            Layout.fillWidth: true; Layout.fillHeight: true; spacing: 16

            Rectangle {
                objectName: "serialSettingsPanel"
                Layout.preferredWidth: Math.min(620, page.width * 0.46)
                Layout.preferredHeight: Math.min(workspaceRow.height, setupForm.implicitHeight + 32)
                Layout.minimumHeight: Math.min(workspaceRow.height, 240); Layout.alignment: Qt.AlignTop
                color: theme.panel; radius: 6
                ScrollView {
                    id: setupScroll
                    objectName: "serialSetupScroll"
                    anchors.fill: parent; anchors.margins: 16
                    clip: true
                    contentWidth: availableWidth
                    contentHeight: setupForm.implicitHeight
                    ColumnLayout {
                        id: setupForm
                        objectName: "serialSetupForm"
                        width: setupScroll.availableWidth; height: implicitHeight; spacing: 12
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "1. Firmware and Settings"; color: theme.primaryText; font.family: theme.bodyFont; font.bold: true; font.pixelSize: theme.headingTextSize }
                            Item { Layout.fillWidth: true }
                            Text {
                                objectName: "serialLicenseStatus"
                                text: "License server: " + (fleetController.licenseStatus === "unknown" || fleetController.licenseStatus === "checking" ? "Checking…" : fleetController.licenseStatus === "online" ? "Online" : "Offline")
                                color: fleetController.licenseStatus === "online" ? theme.success
                                       : fleetController.licenseStatus === "offline" ? theme.error : theme.secondaryText
                                font.family: theme.bodyFont; font.pixelSize: theme.smallTextSize
                            }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true; enabled: !serialController.locked; spacing: 9
                            RowLayout {
                                Layout.fillWidth: true; spacing: 8
                                ColumnLayout {
                                    Layout.preferredWidth: 175; Layout.minimumWidth: 150; Layout.maximumWidth: 180
                                    Text { text: "Firmware source"; color: theme.secondaryText; font.family: theme.bodyFont }
                                    SerialComboBox {
                                        id: releaseSource; objectName: "serialReleaseSource"; Layout.fillWidth: true
                                        model: ["Local release folder", "DLSE online releases"]
                                        currentIndex: 1
                                        onCurrentIndexChanged: page.changedInput()
                                    }
                                }
                                ColumnLayout {
                                    Layout.fillWidth: true; visible: releaseSource.currentIndex === 1
                                    Text { text: "Release"; color: theme.secondaryText; font.family: theme.bodyFont }
                                    SerialComboBox {
                                        id: releasePicker; objectName: "serialReleasePicker"; Layout.fillWidth: true
                                        model: serialController.releases; textRole: "label"
                                        displayText: count ? currentText : "Select a release"
                                        popup.objectName: "serialReleasePopup"
                                        popup.width: Math.min(640, Math.max(releasePicker.width, page.width - releasePicker.mapToItem(page, 0, 0).x - 20))
                                        onCurrentIndexChanged: page.changedInput()
                                    }
                                }
                                ColumnLayout {
                                    Layout.fillWidth: true; visible: releaseSource.currentIndex === 0
                                    Text { text: "Release folder"; color: theme.secondaryText; font.family: theme.bodyFont }
                                    AppTextField {
                                        id: releaseField; objectName: "serialReleaseField"
                                        Layout.fillWidth: true; text: page.defaults.release
                                        placeholderText: "Extracted release folder"
                                        onTextEdited: page.changedInput()
                                    }
                                }
                                AppButton {
                                    objectName: "serialRefreshReleasesButton"
                                    visible: releaseSource.currentIndex === 1; Layout.alignment: Qt.AlignBottom
                                    text: "Refresh"; onClicked: serialController.refreshReleases(tokenField.text)
                                }
                                AppButton { visible: releaseSource.currentIndex === 0; Layout.alignment: Qt.AlignBottom; text: "Browse"; onClicked: releaseFolder.open() }
                            }
                            RowLayout {
                                Layout.fillWidth: true; spacing: 8
                                ColumnLayout {
                                    Layout.preferredWidth: 220; Layout.minimumWidth: 185; Layout.maximumWidth: 235
                                    Text { text: "Settings template"; color: theme.secondaryText; font.family: theme.bodyFont }
                                    SerialComboBox {
                                        id: settingsSource; objectName: "serialSettingsSource"; Layout.fillWidth: true
                                        model: ["Release defaults", "Custom Settings CSV"]
                                        currentIndex: page.defaults.settings.length > 0 ? 1 : 0
                                        onCurrentIndexChanged: page.changedInput()
                                    }
                                }
                                ColumnLayout {
                                    Layout.fillWidth: true; visible: settingsSource.currentIndex === 1
                                    Text { text: "Settings file"; color: theme.secondaryText; font.family: theme.bodyFont }
                                    AppTextField {
                                        id: settingsField; objectName: "serialSettingsField"; Layout.fillWidth: true
                                        text: page.defaults.settings; placeholderText: "Custom Settings CSV"
                                        onTextEdited: page.changedInput()
                                    }
                                }
                                AppButton { visible: settingsSource.currentIndex === 1; Layout.alignment: Qt.AlignBottom; text: "Browse"; onClicked: settingsFile.open() }
                                Item { Layout.fillWidth: true; visible: settingsSource.currentIndex === 0 }
                            }
                            Text { text: "2. Licensing"; Layout.topMargin: 10; color: theme.primaryText; font.family: theme.bodyFont; font.bold: true; font.pixelSize: theme.headingTextSize }
                            RowLayout {
                                Layout.fillWidth: true
                                AppCheckBox {
                                    id: licenseToggle; objectName: "serialLicenseToggle"
                                    text: "Flash license"; checked: true
                                    contentItem: Text {
                                        leftPadding: licenseToggle.indicator.width + licenseToggle.spacing
                                        text: licenseToggle.text; verticalAlignment: Text.AlignVCenter
                                        color: licenseToggle.enabled ? theme.primaryText : theme.mutedText
                                        font.family: theme.bodyFont; font.pixelSize: theme.bodyTextSize
                                    }
                                    onToggled: page.changedInput()
                                }
                                AppButton {
                                    id: licenseDetailsButton
                                    objectName: "serialLicenseDetailsButton"
                                    text: "License details"; quiet: true; textBold: false
                                    contentItem: Text {
                                        text: licenseDetailsButton.text + "  ›"
                                        color: licenseDetailsButton.enabled ? theme.link : theme.mutedText
                                        font.family: theme.bodyFont; font.pixelSize: theme.bodyTextSize
                                        font.underline: licenseDetailsButton.hovered
                                        horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                                    }
                                    onClicked: licenseDetails.open()
                                }
                                Item { Layout.fillWidth: true }
                            }
                            Text {
                                objectName: "serialNoLicenseWarning"
                                Layout.fillWidth: true; visible: !licenseToggle.checked
                                text: "Flashing without a license removes the board's existing license."
                                color: theme.error; font.family: theme.bodyFont; wrapMode: Text.Wrap
                            }
                            RowLayout {
                                Layout.fillWidth: true
                                Text { text: "License server token"; color: theme.secondaryText; font.family: theme.bodyFont }
                                Text { text: "Session only"; color: theme.mutedText; font.family: theme.bodyFont; font.pixelSize: theme.smallTextSize }
                                Item { Layout.fillWidth: true }
                            }
                            AppTextField {
                                id: tokenField; objectName: "serialTokenField"
                                Layout.fillWidth: true
                                text: fleetController.environmentToken; echoMode: TextInput.Password
                                placeholderText: "Token for online access"
                                onTextEdited: page.changedInput()
                            }
                            RowLayout {
                                Layout.fillWidth: true
                                ColumnLayout {
                                    Layout.preferredWidth: 180; Layout.maximumWidth: 180
                                    Text { text: "Starting index"; color: theme.secondaryText; font.family: theme.bodyFont }
                                    SpinBox {
                                        id: indexField; objectName: "serialIndexField"; Layout.fillWidth: true
                                        implicitHeight: 34; Layout.preferredHeight: 34
                                        from: 0; to: 2147483647; value: page.defaults.index; editable: true
                                        font.family: theme.bodyFont; font.pixelSize: theme.bodyTextSize
                                        palette.text: theme.primaryText; palette.buttonText: theme.primaryText
                                        palette.base: theme.panel; palette.button: theme.raised
                                        textFromValue: function(value, locale) { return String(value) }
                                        valueFromText: function(text, locale) { return Number(text) }
                                        onValueChanged: page.changedInput()
                                    }
                                }
                                ColumnLayout {
                                    Layout.preferredWidth: 210; Layout.maximumWidth: 210
                                    Text { text: "Flash baud"; color: theme.secondaryText; font.family: theme.bodyFont }
                                    SerialComboBox {
                                        id: baudField; objectName: "serialBaudSelector"; Layout.fillWidth: true
                                        model: page.baudRates.map(String)
                                        currentIndex: page.baudRates.indexOf(page.defaults.baud) >= 0 ? page.baudRates.indexOf(page.defaults.baud) : 2
                                        onCurrentIndexChanged: page.changedInput()
                                    }
                                }
                                Item { Layout.fillWidth: true }
                            }
                            AppButton {
                                objectName: "serialPrepareButton"
                                Layout.preferredWidth: 290; Layout.maximumWidth: 290; Layout.alignment: Qt.AlignLeft
                                text: "Check and Validate Configuration"; emphasized: true
                                onClicked: page.prepareReview()
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true; visible: serialController.state === "review"; spacing: 8
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
                                text: "Next assignments. Validation does not flash boards."
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
                            AppButton {
                                objectName: "serialArmButton"
                                Layout.preferredWidth: 290; Layout.maximumWidth: 290; Layout.alignment: Qt.AlignLeft
                                text: "Start flashing…"; emphasized: true; onClicked: armDialog.open()
                            }
                        }
                        Text {
                            Layout.fillWidth: true
                            text: "After starting, reconnect any boards already attached. Keep each board connected until it finishes."
                            color: theme.secondaryText; font.family: theme.bodyFont; font.pixelSize: theme.smallTextSize; wrapMode: Text.Wrap
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
                Text { text: "Newly Connected Boards"; color: theme.primaryText; font.family: theme.bodyFont; font.pixelSize: theme.bodyTextSize; font.bold: true }
                Rectangle {
                    objectName: "serialConnectedPanel"
                    Layout.fillWidth: true; Layout.preferredHeight: 116
                    color: "transparent"
                    Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; height: 1; color: theme.border }
                    Flickable {
                        id: tableViewport
                        anchors.fill: parent; anchors.topMargin: 4; anchors.bottomMargin: 8; clip: true
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
                                        text: modelData; color: theme.secondaryText; font.family: theme.bodyFont; font.pixelSize: theme.smallTextSize; font.bold: true
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
                                    text: serialController.armed ? "Waiting for a new board." : "Start flashing, then connect a board."
                                    color: theme.mutedText; font.family: theme.bodyFont
                                }
                            }
                        }
                    }
                }
                Text { text: "Flashed Boards / Results"; color: theme.primaryText; font.family: theme.bodyFont; font.pixelSize: theme.bodyTextSize; font.bold: true }
                Rectangle {
                    objectName: "serialCompletedPanel"
                    Layout.fillWidth: true; Layout.fillHeight: true
                    Layout.preferredHeight: 160; Layout.minimumHeight: 120
                    color: "transparent"
                    Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; height: 1; color: theme.border }
                    Flickable {
                        id: completedViewport
                        anchors.fill: parent; anchors.topMargin: 4; anchors.bottomMargin: 8; clip: true
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
                                        text: modelData; color: theme.secondaryText; font.family: theme.bodyFont
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
                                            color: index !== 4 ? theme.primaryText : record.outcome === "success" ? theme.success : record.outcome === "failed" ? theme.error : theme.secondaryText
                                            font.family: theme.dataFont; font.pixelSize: theme.smallTextSize
                                        }
                                    }
                                }
                                Text {
                                    anchors.centerIn: parent; visible: completedView.count === 0
                                    text: "No completed boards yet."
                                    color: theme.mutedText; font.family: theme.bodyFont
                                }
                            }
                        }
                    }
                }
                Text { text: "Activity History"; color: theme.primaryText; font.family: theme.bodyFont; font.pixelSize: theme.bodyTextSize; font.bold: true }
                Rectangle {
                    objectName: "serialHistoryPanel"
                    Layout.fillWidth: true; Layout.fillHeight: true
                    Layout.preferredHeight: 160; Layout.minimumHeight: 120
                    color: "#0c2337"; radius: 6
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
                        Text {
                            anchors.centerIn: parent; visible: historyView.count === 0
                            text: "Activity will appear here."; color: theme.mutedText; font.family: theme.bodyFont
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
        id: licenseDetails; objectName: "serialLicenseDetailsDialog"; title: "License details"
        Text {
            Layout.fillWidth: true
            text: "When the license server is unavailable, the flasher looks for a matching permanent license in local storage and then on the board."
            color: theme.primaryText; font.family: theme.bodyFont; wrapMode: Text.Wrap
        }
        Text {
            Layout.fillWidth: true
            text: "Online activation and account firmware downloads need a token. The token is used only for this session."
            color: theme.secondaryText; font.family: theme.bodyFont; wrapMode: Text.Wrap
        }
        Text {
            Layout.fillWidth: true
            text: "Turning off Flash license installs no license and removes any existing license from the board. Local license backups are kept."
            color: theme.error; font.family: theme.bodyFont; wrapMode: Text.Wrap
        }
        RowLayout {
            Item { Layout.fillWidth: true }
            AppButton { text: "Close"; onClicked: licenseDetails.close() }
        }
    }
    ModalDialog {
        id: armDialog; objectName: "serialArmDialog"; title: "Start automatic serial flashing?"
        Text {
            Layout.fillWidth: true
            text: "Every newly connected supported board will be flashed with the reviewed firmware and settings"
                  + (licenseToggle.checked ? " and a permanent license." : " without a license.")
                  + " This replaces its firmware and settings. Confirm the template and any warnings before starting. Reconnect boards that are already attached."
            color: theme.primaryText; font.family: theme.bodyFont; wrapMode: Text.Wrap
        }
        Text {
            objectName: "serialArmNoLicenseWarning"
            Layout.fillWidth: true; visible: !licenseToggle.checked
            text: "Any existing license on the board will be removed."
            color: theme.error; font.family: theme.bodyFont; wrapMode: Text.Wrap
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
            color: theme.error; font.family: theme.bodyFont; wrapMode: Text.Wrap
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

import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts

Item {
    id: dialogs
    objectName: "fleetDialogs"

    property var excludedKeys: ({})
    property string confirmationKind: ""
    property string resultTitle: ""
    property string resultMessage: ""
    property bool resultRetryable: false

    function center(dialog) {
        dialog.x = Math.max(24, (dialogs.width - dialog.width) / 2)
        dialog.y = Math.max(24, (dialogs.height - dialog.height) / 2)
    }

    function openScanSettings() {
        const values = fleetController.scanSettings
        subnetField.text = values.subnet
        mavlinkCheck.checked = values.mavlink
        httpCheck.checked = values.http
        esp32PortField.text = String(values.esp32_port)
        localPortField.text = String(values.local_port)
        intervalField.text = String(values.interval)
        timeoutField.text = String(values.http_timeout)
        workersField.text = String(values.workers)
        statsEnabledCheck.checked = values.stats_enabled
        statsIntervalField.text = String(values.stats_interval)
        statsTimeoutField.text = String(values.stats_timeout)
        statsWorkersField.text = String(values.stats_workers)
        statsFailureThresholdField.text = String(values.stats_failure_threshold)
        center(scanDialog)
        scanDialog.open()
    }

    function openActivation() {
        tokenField.text = fleetController.environmentToken
        activationScope.currentIndex = fleetController.selectedCount > 0 ? 0 : 1
        center(activationDialog)
        activationDialog.open()
    }

    function openReboot() {
        rebootScope.currentIndex = fleetController.selectedCount > 0 ? 0 : 1
        rebootMethod.currentIndex = 0
        center(rebootDialog)
        rebootDialog.open()
    }

    function openOta() {
        otaSource.currentIndex = 0
        releaseTokenField.text = fleetController.environmentToken
        otaScope.currentIndex = fleetController.selectedCount > 0 ? 0 : 1
        center(otaDialog)
        otaDialog.open()
    }

    function selectedOtaReleaseId() {
        const releases = fleetController.otaReleases
        if (otaReleasePicker.currentIndex < 0 || otaReleasePicker.currentIndex >= releases.length)
            return ""
        return releases[otaReleasePicker.currentIndex].id
    }

    function openColumns() {
        center(columnsDialog)
        columnsDialog.open()
    }

    function openClearFleet() {
        confirmationKind = "clear"
        confirmText.text = "Remove all devices from this session inventory?"
        center(confirmDialog)
        confirmDialog.open()
    }

    function openApplySettings() {
        confirmationKind = "settings"
        confirmText.text = "Apply the changed settings? The ESP32 will reboot automatically."
        center(confirmDialog)
        confirmDialog.open()
    }

    function openImportCsv() {
        importCsvDialog.open()
    }

    function openExportCsv() {
        exportCsvDialog.open()
    }

    function resetCsvExclusions(scope) {
        dialogs.excludedKeys = ({})
        const defaults = fleetController.defaultCsvExclusions(scope)
        for (let i = 0; i < defaults.length; ++i)
            dialogs.excludedKeys[defaults[i]] = true
    }

    function showToast(level, message) {
        toast.level = level
        toast.message = message
        toast.open()
        toastTimer.restart()
    }

    Connections {
        target: fleetController

        function onCsvTemplateReady() {
            csvScope.currentIndex = fleetController.selectedCount > 0 ? 0 : 1
            dialogs.resetCsvExclusions(
                csvScope.currentIndex === 0 ? "selected" : "visible"
            )
            dialogs.center(csvDialog)
            csvDialog.open()
        }

        function onToastRequested(level, message) {
            dialogs.showToast(level, message)
        }

        function onResultReady(title, message, retryable) {
            dialogs.resultTitle = title
            dialogs.resultMessage = message
            dialogs.resultRetryable = retryable
            dialogs.center(resultDialog)
            resultDialog.open()
        }

        function onOtaReleasesChanged() {
            if (otaReleasePicker.currentIndex < 0 && fleetController.otaReleases.length > 0)
                otaReleasePicker.currentIndex = 0
            if (otaReleasePicker.currentIndex >= fleetController.otaReleases.length)
                otaReleasePicker.currentIndex = Math.max(0, fleetController.otaReleases.length - 1)
        }
    }

    ModalDialog {
        id: scanDialog
        objectName: "scanDialog"
        title: "Scan Settings"
        preferredWidth: 600

        GridLayout {
            Layout.fillWidth: true
            columns: 2
            columnSpacing: 12
            rowSpacing: 10

            Text { text: "Discovery methods"; color: theme.secondaryText; font.family: theme.bodyFont }
            ColumnLayout {
                AppCheckBox { id: mavlinkCheck; text: "MAVLink broadcast" }
                AppCheckBox { id: httpCheck; text: "HTTP IP-range scan" }
                AppCheckBox { text: "UniFi discovery (future)"; enabled: false }
            }

            Text { text: "IPv4 subnet"; color: theme.secondaryText; font.family: theme.bodyFont }
            AppTextField { id: subnetField; Layout.fillWidth: true; placeholderText: "192.168.1.0/24" }

            Text { text: "ESP32 broadcast port"; color: theme.secondaryText; font.family: theme.bodyFont }
            AppTextField { id: esp32PortField; Layout.fillWidth: true; inputMethodHints: Qt.ImhDigitsOnly }

            Text { text: "Local receive port"; color: theme.secondaryText; font.family: theme.bodyFont }
            AppTextField { id: localPortField; Layout.fillWidth: true; inputMethodHints: Qt.ImhDigitsOnly }

            Text { text: "Discovery interval (s)"; color: theme.secondaryText; font.family: theme.bodyFont }
            AppTextField { id: intervalField; Layout.fillWidth: true; inputMethodHints: Qt.ImhDigitsOnly }

            Text { text: "HTTP timeout (s)"; color: theme.secondaryText; font.family: theme.bodyFont }
            AppTextField { id: timeoutField; Layout.fillWidth: true }

            Text { text: "HTTP concurrency"; color: theme.secondaryText; font.family: theme.bodyFont }
            AppTextField { id: workersField; Layout.fillWidth: true; inputMethodHints: Qt.ImhDigitsOnly }

            Rectangle {
                Layout.columnSpan: 2
                Layout.fillWidth: true
                Layout.topMargin: 8
                Layout.preferredHeight: 1
                color: theme.border
            }

            Text {
                Layout.columnSpan: 2
                text: "SYSTEM STATS POLLING  /api/system/stats"
                color: theme.primaryText
                font.family: theme.dataFont
                font.pixelSize: 10
                font.bold: true
            }

            Text { text: "Background polling"; color: theme.secondaryText; font.family: theme.bodyFont }
            AppCheckBox { id: statsEnabledCheck; text: "Enabled" }

            Text { text: "Target interval (s)"; color: theme.secondaryText; font.family: theme.bodyFont }
            AppTextField {
                id: statsIntervalField
                Layout.fillWidth: true
                enabled: statsEnabledCheck.checked
                inputMethodHints: Qt.ImhDigitsOnly
            }

            Text { text: "Request timeout (s)"; color: theme.secondaryText; font.family: theme.bodyFont }
            AppTextField {
                id: statsTimeoutField
                Layout.fillWidth: true
                enabled: statsEnabledCheck.checked
            }

            Text { text: "HTTP concurrency"; color: theme.secondaryText; font.family: theme.bodyFont }
            AppTextField {
                id: statsWorkersField
                Layout.fillWidth: true
                enabled: statsEnabledCheck.checked
                inputMethodHints: Qt.ImhDigitsOnly
            }

            Text { text: "Failures before offline"; color: theme.secondaryText; font.family: theme.bodyFont }
            AppTextField {
                id: statsFailureThresholdField
                Layout.fillWidth: true
                enabled: statsEnabledCheck.checked
                inputMethodHints: Qt.ImhDigitsOnly
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 6
            Item { Layout.fillWidth: true }
            AppButton { text: "Cancel"; quiet: true; onClicked: scanDialog.close() }
            AppButton {
                text: "Save"
                emphasized: true
                onClicked: {
                    const saved = fleetController.saveScanSettings(
                        subnetField.text,
                        mavlinkCheck.checked,
                        httpCheck.checked,
                        Number(esp32PortField.text),
                        Number(localPortField.text),
                        Number(intervalField.text),
                        Number(timeoutField.text),
                        Number(workersField.text),
                        statsEnabledCheck.checked,
                        Number(statsIntervalField.text),
                        Number(statsTimeoutField.text),
                        Number(statsWorkersField.text),
                        Number(statsFailureThresholdField.text)
                    )
                    if (saved)
                        scanDialog.close()
                }
            }
        }
    }

    ModalDialog {
        id: activationDialog
        objectName: "activationDialog"
        title: "OTA DLSE Activation"

        Text {
            Layout.fillWidth: true
            text: "Activation is sequential and duplicate activation keys are protected."
            color: theme.secondaryText
            wrapMode: Text.Wrap
            font.family: theme.bodyFont
        }

        Text { text: "Targets"; color: theme.secondaryText; font.family: theme.bodyFont }
        AppComboBox {
            id: activationScope
            Layout.fillWidth: true
            model: [
                "Selected devices (" + fleetController.selectedCount + ")",
                "All visible devices (" + fleetController.visibleCount + ")"
            ]
        }

        Text { text: "License server token"; color: theme.secondaryText; font.family: theme.bodyFont }
        AppTextField {
            id: tokenField
            Layout.fillWidth: true
            echoMode: TextInput.Password
            placeholderText: "Session-only token"
        }

        Text { text: "License type"; color: theme.secondaryText; font.family: theme.bodyFont }
        AppComboBox {
            id: activationType
            Layout.fillWidth: true
            model: ["Activated license", "Evaluation license (60 days)"]
        }

        RowLayout {
            Layout.fillWidth: true
            Item { Layout.fillWidth: true }
            AppButton { text: "Cancel"; quiet: true; onClicked: activationDialog.close() }
            AppButton {
                text: "Activate"
                emphasized: true
                onClicked: {
                    fleetController.startActivation(
                        tokenField.text,
                        activationScope.currentIndex === 0 ? "selected" : "visible",
                        activationType.currentIndex === 1 ? "evaluation" : "activated"
                    )
                    activationDialog.close()
                }
            }
        }
    }

    ModalDialog {
        id: rebootDialog
        objectName: "rebootDialog"
        title: "Reboot Devices"

        Text {
            Layout.fillWidth: true
            text: "REST confirms request acceptance per device. MAVLink sends one unverified broadcast command to all visible online devices."
            color: theme.warning
            wrapMode: Text.Wrap
            font.family: theme.bodyFont
        }

        Text { text: "Targets"; color: theme.secondaryText; font.family: theme.bodyFont }
        AppComboBox {
            id: rebootScope
            Layout.fillWidth: true
            model: [
                "Selected devices (" + fleetController.selectedCount + ")",
                "All visible devices (" + fleetController.visibleCount + ")"
            ]
        }

        Text { text: "Method"; color: theme.secondaryText; font.family: theme.bodyFont }
        AppComboBox {
            id: rebootMethod
            Layout.fillWidth: true
            model: ["REST per device", "MAVLink broadcast to all visible online devices"]
        }

        RowLayout {
            Layout.fillWidth: true
            Item { Layout.fillWidth: true }
            AppButton { text: "Cancel"; quiet: true; onClicked: rebootDialog.close() }
            AppButton {
                text: "Reboot"
                emphasized: true
                accentColor: theme.warning
                onClicked: {
                    fleetController.startReboot(
                        rebootScope.currentIndex === 0 ? "selected" : "visible",
                        rebootMethod.currentIndex === 1 ? "mavlink" : "rest"
                    )
                    rebootDialog.close()
                }
            }
        }
    }

    ModalDialog {
        id: otaDialog
        objectName: "otaDialog"
        title: "OTA Firmware Upgrade"
        preferredWidth: 610

        Text {
            Layout.fillWidth: true
            text: "Uploads WWW first, waits two seconds, uploads the application, then reboots. Active uploads finish when queued work is cancelled."
            color: theme.warning
            wrapMode: Text.Wrap
            font.family: theme.bodyFont
        }

        Text { text: "Input source"; color: theme.secondaryText; font.family: theme.bodyFont }
        AppComboBox {
            id: otaSource
            Layout.fillWidth: true
            model: ["DroneBridge account release", "Validated release folder", "Explicit WWW and application binaries"]
        }

        ColumnLayout {
            Layout.fillWidth: true
            visible: otaSource.currentIndex === 0
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                AppTextField {
                    id: releaseTokenField
                    Layout.fillWidth: true
                    placeholderText: "License server token"
                    echoMode: TextInput.Password
                }
                AppButton {
                    text: "Get Releases"
                    onClicked: fleetController.refreshOtaReleases(releaseTokenField.text)
                }
            }

            AppComboBox {
                id: otaReleasePicker
                Layout.fillWidth: true
                model: fleetController.otaReleases
                textRole: "label"
            }

            Text {
                Layout.fillWidth: true
                text: fleetController.otaReleaseStatus
                color: theme.secondaryText
                wrapMode: Text.Wrap
                font.family: theme.bodyFont
                font.pixelSize: 11
            }
        }

        RowLayout {
            Layout.fillWidth: true
            visible: otaSource.currentIndex === 1
            AppTextField { id: releaseField; Layout.fillWidth: true; placeholderText: "Release folder" }
            AppButton { text: "Browse"; onClicked: releaseFolderDialog.open() }
        }

        ColumnLayout {
            Layout.fillWidth: true
            visible: otaSource.currentIndex === 2
            RowLayout {
                Layout.fillWidth: true
                AppTextField { id: wwwField; Layout.fillWidth: true; placeholderText: "www.bin" }
                AppButton { text: "WWW"; onClicked: wwwFileDialog.open() }
            }
            RowLayout {
                Layout.fillWidth: true
                AppTextField { id: firmwareField; Layout.fillWidth: true; placeholderText: "db_esp32.bin" }
                AppButton { text: "App"; onClicked: firmwareFileDialog.open() }
            }
        }

        Text { text: "Only upgrade devices running the following firmware version (optional)"; color: theme.secondaryText; font.family: theme.bodyFont }
        AppTextField { id: targetVersionField; Layout.fillWidth: true; placeholderText: "e.g. 1.0.0-beta.4" }

        RowLayout {
            Layout.fillWidth: true
            Text { text: "Parallel updates"; color: theme.secondaryText; font.family: theme.bodyFont }
            AppTextField {
                id: otaWorkersField
                Layout.fillWidth: true
                text: "20"
                inputMethodHints: Qt.ImhDigitsOnly
            }
        }

        Text { text: "Targets"; color: theme.secondaryText; font.family: theme.bodyFont }
        AppComboBox {
            id: otaScope
            Layout.fillWidth: true
            model: [
                "Selected devices (" + fleetController.selectedCount + ")",
                "All visible devices (" + fleetController.visibleCount + ")"
            ]
        }

        RowLayout {
            Layout.fillWidth: true
            Item { Layout.fillWidth: true }
            AppButton { text: "Cancel"; quiet: true; onClicked: otaDialog.close() }
            AppButton {
                text: "Start Update"
                emphasized: true
                onClicked: {
                    if (otaSource.currentIndex === 0) {
                        fleetController.startOtaFromRelease(
                            dialogs.selectedOtaReleaseId(),
                            releaseTokenField.text,
                            targetVersionField.text,
                            Number(otaWorkersField.text),
                            otaScope.currentIndex === 0 ? "selected" : "visible"
                        )
                    } else {
                        fleetController.startOta(
                            otaSource.currentIndex === 1 ? releaseField.text : "",
                            otaSource.currentIndex === 2 ? wwwField.text : "",
                            otaSource.currentIndex === 2 ? firmwareField.text : "",
                            targetVersionField.text,
                            Number(otaWorkersField.text),
                            otaScope.currentIndex === 0 ? "selected" : "visible"
                        )
                    }
                    otaDialog.close()
                }
            }
        }
    }

    ModalDialog {
        id: columnsDialog
        title: "Configure Columns"
        preferredWidth: 520

        ListView {
            id: columnList
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(contentHeight, 430)
            clip: true
            spacing: 4
            model: fleetController.columns
            ScrollBar.vertical: ScrollBar {}

            delegate: RowLayout {
                required property var modelData
                width: columnList.width
                height: 32
                spacing: 8

                AppCheckBox {
                    Layout.fillWidth: true
                    text: modelData.title
                    checked: modelData.visible
                    onClicked: fleetController.setColumnVisible(modelData.key, checked)
                }

                ToolButton {
                    id: moveColumnUp
                    Layout.preferredWidth: 30
                    Layout.preferredHeight: 28
                    enabled: modelData.canMoveUp
                    opacity: enabled ? 1 : 0.28
                    text: "^"
                    onClicked: fleetController.moveColumn(modelData.key, -1)
                    contentItem: Text {
                        text: moveColumnUp.text
                        color: theme.secondaryText
                        font.family: theme.dataFont
                        font.pixelSize: 13
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        radius: 5
                        color: moveColumnUp.hovered ? theme.hover : theme.panel
                        border.width: 1
                        border.color: moveColumnUp.activeFocus ? theme.accent : theme.border
                    }
                }

                ToolButton {
                    id: moveColumnDown
                    Layout.preferredWidth: 30
                    Layout.preferredHeight: 28
                    enabled: modelData.canMoveDown
                    opacity: enabled ? 1 : 0.28
                    text: "v"
                    onClicked: fleetController.moveColumn(modelData.key, 1)
                    contentItem: Text {
                        text: moveColumnDown.text
                        color: theme.secondaryText
                        font.family: theme.dataFont
                        font.pixelSize: 13
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        radius: 5
                        color: moveColumnDown.hovered ? theme.hover : theme.panel
                        border.width: 1
                        border.color: moveColumnDown.activeFocus ? theme.accent : theme.border
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            AppButton {
                text: "Reset Widths"
                quiet: true
                onClicked: fleetController.resetColumnWidths()
            }
            Item { Layout.fillWidth: true }
            AppButton { text: "Done"; emphasized: true; onClicked: columnsDialog.close() }
        }
    }

    ModalDialog {
        id: csvDialog
        title: "Configuration Template Preview"
        preferredWidth: 620

        Text {
            Layout.fillWidth: true
            text: "Checked parameters are excluded. Bulk operations preselect static IP, subnet mask, gateway, hostname, and manual system ID."
            color: theme.secondaryText
            wrapMode: Text.Wrap
            font.family: theme.bodyFont
        }

        AppComboBox {
            id: csvScope
            Layout.fillWidth: true
            model: [
                "Selected devices (" + fleetController.selectedCount + ")",
                "All visible devices (" + fleetController.visibleCount + ")"
            ]
            onActivated: dialogs.resetCsvExclusions(
                currentIndex === 0 ? "selected" : "visible"
            )
        }

        ListView {
            id: csvList
            Layout.fillWidth: true
            Layout.preferredHeight: 390
            clip: true
            spacing: 3
            model: fleetController.csvParameters
            ScrollBar.vertical: ScrollBar {}

            delegate: AppCheckBox {
                required property var modelData
                width: csvList.width
                text: modelData.key + " = " + modelData.value
                checked: Boolean(dialogs.excludedKeys[modelData.key])
                onClicked: dialogs.excludedKeys[modelData.key] = checked
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Item { Layout.fillWidth: true }
            AppButton { text: "Cancel"; quiet: true; onClicked: csvDialog.close() }
            AppButton {
                text: "Apply Template"
                emphasized: true
                onClicked: {
                    const excluded = Object.keys(dialogs.excludedKeys).filter(
                        key => dialogs.excludedKeys[key]
                    )
                    fleetController.applyCsvTemplate(
                        excluded,
                        csvScope.currentIndex === 0 ? "selected" : "visible"
                    )
                    csvDialog.close()
                }
            }
        }
    }

    ModalDialog {
        id: confirmDialog
        title: confirmationKind === "clear" ? "Clear Fleet" : "Apply Settings"
        preferredWidth: 460

        Text {
            id: confirmText
            Layout.fillWidth: true
            color: theme.primaryText
            wrapMode: Text.Wrap
            font.family: theme.bodyFont
            font.pixelSize: 13
        }

        RowLayout {
            Layout.fillWidth: true
            Item { Layout.fillWidth: true }
            AppButton { text: "Cancel"; quiet: true; onClicked: confirmDialog.close() }
            AppButton {
                text: confirmationKind === "clear" ? "Clear Fleet" : "Apply and Reboot"
                emphasized: true
                accentColor: confirmationKind === "clear" ? theme.error : theme.accent
                onClicked: {
                    if (confirmationKind === "clear")
                        fleetController.clearFleet()
                    else
                        fleetController.applyEditedSettings()
                    confirmDialog.close()
                }
            }
        }
    }

    ModalDialog {
        id: resultDialog
        title: dialogs.resultTitle
        preferredWidth: 460

        Text {
            Layout.fillWidth: true
            text: dialogs.resultMessage
            color: theme.primaryText
            wrapMode: Text.Wrap
            font.family: theme.bodyFont
            font.pixelSize: 13
        }

        RowLayout {
            Layout.fillWidth: true
            AppButton {
                visible: dialogs.resultRetryable
                text: "Retry Failed"
                onClicked: {
                    resultDialog.close()
                    fleetController.retryFailed()
                }
            }
            Item { Layout.fillWidth: true }
            AppButton { text: "Close"; emphasized: true; onClicked: resultDialog.close() }
        }
    }

    FileDialog {
        id: importCsvDialog
        title: "Select Settings Template"
        nameFilters: ["CSV files (*.csv)"]
        fileMode: FileDialog.OpenFile
        onAccepted: fleetController.prepareCsvImport(selectedFile.toString())
    }

    FileDialog {
        id: exportCsvDialog
        title: "Export Settings"
        nameFilters: ["CSV files (*.csv)"]
        fileMode: FileDialog.SaveFile
        defaultSuffix: "csv"
        onAccepted: fleetController.exportSettings(selectedFile.toString())
    }

    FolderDialog {
        id: releaseFolderDialog
        title: "Select Release Folder"
        onAccepted: releaseField.text = selectedFolder.toString()
    }

    FileDialog {
        id: wwwFileDialog
        title: "Select WWW Binary"
        nameFilters: ["Binary files (*.bin)"]
        fileMode: FileDialog.OpenFile
        onAccepted: wwwField.text = selectedFile.toString()
    }

    FileDialog {
        id: firmwareFileDialog
        title: "Select Application Binary"
        nameFilters: ["Binary files (*.bin)"]
        fileMode: FileDialog.OpenFile
        onAccepted: firmwareField.text = selectedFile.toString()
    }

    Popup {
        id: toast

        property string level: "info"
        property string message: ""

        x: dialogs.width - width - 24
        y: 76
        width: Math.min(440, dialogs.width - 48)
        padding: 14
        closePolicy: Popup.NoAutoClose

        contentItem: Text {
            text: toast.message
            color: theme.primaryText
            wrapMode: Text.Wrap
            font.family: theme.bodyFont
            font.pixelSize: 12
        }

        background: Rectangle {
            color: theme.panel
            border.width: 1
            border.color: toast.level === "error" ? theme.error
                          : toast.level === "warning" ? theme.warning
                          : toast.level === "success" ? theme.success
                          : theme.secondaryText
            radius: 5
        }
    }

    Timer {
        id: toastTimer
        interval: 4500
        onTriggered: toast.close()
    }

    Theme { id: theme }
}

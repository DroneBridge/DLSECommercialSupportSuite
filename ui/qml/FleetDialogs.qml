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
    property bool csvSelectedOnly: false

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

    function openAlignSysIds() {
        if (fleetController.selectedCount <= 0) {
            showToast("info", "Select at least one device before aligning SYS IDs.")
            return
        }
        sysIdAlignmentMode.currentIndex = 0
        center(sysIdAlignmentDialog)
        sysIdAlignmentDialog.open()
    }

    function openStaticIpAssignment() {
        if (fleetController.eligibleStaticIpCount <= 0) {
            showToast("info", "Select a visible Evaluation or Activated device first.")
            return
        }
        staticIpStartField.text = ""
        staticIpNetmaskField.text = ""
        staticIpGatewayField.text = ""
        center(staticIpAssignmentDialog)
        staticIpAssignmentDialog.open()
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
        refreshColumnOrderModel()
        columnsDialog.open()
    }

    function refreshColumnOrderModel() {
        columnOrderModel.clear()
        const columns = fleetController.columns
        for (let i = 0; i < columns.length; ++i) {
            columnOrderModel.append({
                "columnKey": columns[i].key,
                "columnTitle": columns[i].title,
                "columnVisible": columns[i].visible
            })
        }
    }

    function applyColumnOrder() {
        const keys = []
        for (let i = 0; i < columnOrderModel.count; ++i) {
            const column = columnOrderModel.get(i)
            if (column.columnVisible)
                keys.push(column.columnKey)
        }
        fleetController.setColumnOrder(keys)
    }

    function updateDraggedColumnTarget(targetIndex) {
        const rowCount = columnOrderModel.count
        if (columnList.dragStartIndex < 0 || rowCount <= 1)
            return
        columnList.dragTargetIndex = Math.max(0, Math.min(rowCount - 1, targetIndex))
    }

    function finishDraggedColumn() {
        const startIndex = columnList.dragStartIndex
        const targetIndex = columnList.dragTargetIndex
        columnList.dragStartIndex = -1
        columnList.dragTargetIndex = -1
        columnList.dragContentY = -1
        columnList.draggingColumnKey = ""
        columnList.interactive = true
        if (startIndex < 0 || targetIndex < 0 || startIndex === targetIndex) {
            applyColumnOrder()
            return
        }
        columnOrderModel.move(startIndex, targetIndex, 1)
        applyColumnOrder()
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

    function openApplyCsvToSelected() {
        if (fleetController.selectedCount <= 0) {
            showToast("info", "Select at least one device before applying settings.")
            return
        }
        csvSelectedOnly = true
        importCsvDialog.open()
    }

    function openImportCsv() {
        csvSelectedOnly = false
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
            csvScope.currentIndex = dialogs.csvSelectedOnly || fleetController.selectedCount > 0 ? 0 : 1
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
                AppCheckBox { id: mavlinkCheck; text: "MAVLink broadcast (recommended)" }
                AppCheckBox { id: httpCheck; text: "HTTP IP-range scan (slow - robust)" }
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
        id: staticIpAssignmentDialog
        objectName: "staticIpAssignmentDialog"
        title: "Assign Static IPs"
        preferredWidth: 610

        Text {
            Layout.fillWidth: true
            text: "Visible selected devices: " + fleetController.selectedVisibleStaticIpCount
                  + ". Eligible: " + fleetController.eligibleStaticIpCount
                  + ". Excluded by license: " + fleetController.ineligibleStaticIpCount
                  + ". Hidden by filter: " + fleetController.filteredStaticIpCount + "."
            color: theme.secondaryText
            wrapMode: Text.Wrap
            font.family: theme.bodyFont
        }

        Text {
            Layout.fillWidth: true
            text: "Addresses are assigned in the current table order. The final octet increases from .1 through .254; after .254, the third octet increases and the final octet resumes at .1. Use a subnet mask large enough for the complete range."
            color: theme.secondaryText
            wrapMode: Text.Wrap
            font.family: theme.bodyFont
        }

        Text {
            Layout.fillWidth: true
            text: "Applying these settings reboots each DLSE. It will stop responding at its old IP, and the table updates to the new IP only after the device accepts the request."
            color: theme.warning
            wrapMode: Text.Wrap
            font.family: theme.bodyFont
        }

        Text { text: "Starting static IP"; color: theme.secondaryText; font.family: theme.bodyFont }
        AppTextField {
            id: staticIpStartField
            Layout.fillWidth: true
            placeholderText: "e.g. 192.168.1.1"
        }

        Text { text: "Subnet mask"; color: theme.secondaryText; font.family: theme.bodyFont }
        AppTextField {
            id: staticIpNetmaskField
            Layout.fillWidth: true
            placeholderText: "e.g. 255.255.255.0"
        }

        Text { text: "Gateway IP"; color: theme.secondaryText; font.family: theme.bodyFont }
        AppTextField {
            id: staticIpGatewayField
            Layout.fillWidth: true
            placeholderText: "e.g. 192.168.1.254"
        }

        RowLayout {
            Layout.fillWidth: true
            Item { Layout.fillWidth: true }
            AppButton { text: "Cancel"; quiet: true; onClicked: staticIpAssignmentDialog.close() }
            AppButton {
                text: "Assign Static IPs"
                emphasized: true
                enabled: fleetController.eligibleStaticIpCount > 0
                         && staticIpStartField.text.trim().length > 0
                         && staticIpNetmaskField.text.trim().length > 0
                         && staticIpGatewayField.text.trim().length > 0
                onClicked: {
                    const started = fleetController.startStaticIpAssignment(
                        staticIpStartField.text,
                        staticIpNetmaskField.text,
                        staticIpGatewayField.text
                    )
                    if (started)
                        staticIpAssignmentDialog.close()
                }
            }
        }
    }

    ModalDialog {
        id: sysIdAlignmentDialog
        objectName: "sysIdAlignmentDialog"
        title: "Align SYS IDs"
        preferredWidth: 610

        Text {
            Layout.fillWidth: true
            text: "Selected devices only: " + fleetController.selectedCount
                  + ". Eligible: " + fleetController.eligibleSysIdAlignmentCount
                  + ". Excluded by license status: " + fleetController.ineligibleSysIdAlignmentCount + "."
            color: theme.secondaryText
            wrapMode: Text.Wrap
            font.family: theme.bodyFont
        }

        Text {
            Layout.fillWidth: true
            text: "Only EVALUATION and ACTIVATED devices are processed. FC-changing modes write a MAVLink parameter and remotely reboot the FC after confirmation."
            color: theme.warning
            wrapMode: Text.Wrap
            font.family: theme.bodyFont
        }

        Text { text: "Set MAVLink SYS ID"; color: theme.secondaryText; font.family: theme.bodyFont }
        AppComboBox {
            id: sysIdAlignmentMode
            Layout.fillWidth: true
            model: [
                "Based on DLSE IP address",
                "Based on FC SYS ID",
                "Based on manual DLSE SYS ID"
            ]
        }

        Text {
            Layout.fillWidth: true
            text: sysIdAlignmentMode.currentIndex === 0
                  ? "Sets the FC SYS ID to the DLSE IP address last octet and enables DLSE SYS ID based on IP."
                  : sysIdAlignmentMode.currentIndex === 1
                    ? "Copies the cached FC SYS ID to the DLSE manual SYS ID and disables DLSE SYS ID based on IP."
                    : "Sets the FC SYS ID to the DLSE manual SYS ID and disables DLSE SYS ID based on IP."
            color: theme.secondaryText
            wrapMode: Text.Wrap
            font.family: theme.bodyFont
        }

        RowLayout {
            Layout.fillWidth: true
            Item { Layout.fillWidth: true }
            AppButton { text: "Cancel"; quiet: true; onClicked: sysIdAlignmentDialog.close() }
            AppButton {
                text: "Align SYS IDs"
                emphasized: true
                accentColor: theme.warning
                enabled: fleetController.eligibleSysIdAlignmentCount > 0
                onClicked: {
                    const modes = ["ip", "fc", "manual"]
                    fleetController.startSysIdAlignment(modes[sysIdAlignmentMode.currentIndex])
                    sysIdAlignmentDialog.close()
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

        ListModel {
            id: columnOrderModel
        }

        ListView {
            id: columnList
            property string draggingColumnKey: ""
            property int dragStartIndex: -1
            property int dragTargetIndex: -1
            property real dragContentY: -1

            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(contentHeight, 430)
            clip: true
            spacing: 4
            model: columnOrderModel
            ScrollBar.vertical: ScrollBar {}

            delegate: Item {
                id: columnRow

                required property int index
                required property string columnKey
                required property string columnTitle
                required property bool columnVisible

                width: columnList.width
                height: 36
                z: dragHandle.drag.active ? 10 : 0

                Rectangle {
                    id: rowFrame
                    width: parent.width
                    height: parent.height
                    y: 0
                    radius: 5
                    color: dragHandle.drag.active ? theme.hover : theme.background
                    border.width: 1
                    border.color: dragHandle.drag.active ? theme.accent : theme.border
                    opacity: columnRow.columnVisible ? 1 : 0.62

                    Drag.active: dragHandle.drag.active
                    Drag.source: dragHandle
                    Drag.hotSpot.x: width / 2
                    Drag.hotSpot.y: height / 2

                    MouseArea {
                        id: dragHandle
                        anchors.fill: parent
                        enabled: columnOrderModel.count > 1
                        hoverEnabled: true
                        preventStealing: true
                        cursorShape: Qt.SizeAllCursor
                        drag.target: rowFrame
                        drag.axis: Drag.YAxis
                        property string columnKey: columnRow.columnKey

                        onPressed: {
                            columnList.draggingColumnKey = columnRow.columnKey
                            columnList.dragStartIndex = columnRow.index
                            columnList.dragTargetIndex = columnRow.index
                            columnList.dragContentY = columnRow.y + columnRow.height / 2
                            columnList.interactive = false
                        }
                        onPositionChanged: {
                            if (!drag.active)
                                return
                            const center = rowFrame.mapToItem(
                                columnList.contentItem,
                                rowFrame.width / 2,
                                rowFrame.height / 2
                            )
                            columnList.dragContentY = center.y
                            let targetIndex = columnList.indexAt(center.x, center.y)
                            if (targetIndex < 0) {
                                targetIndex = center.y < 0
                                              ? 0
                                              : columnOrderModel.count - 1
                            }
                            dialogs.updateDraggedColumnTarget(targetIndex)
                        }
                        onReleased: {
                            rowFrame.y = 0
                            dialogs.finishDraggedColumn()
                        }
                        onCanceled: {
                            rowFrame.y = 0
                            columnList.draggingColumnKey = ""
                            columnList.dragStartIndex = -1
                            columnList.dragTargetIndex = -1
                            columnList.dragContentY = -1
                            columnList.interactive = true
                            dialogs.refreshColumnOrderModel()
                        }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 6
                        anchors.rightMargin: 6
                        spacing: 8

                        Item {
                            Layout.preferredWidth: 28
                            Layout.preferredHeight: 28
                            opacity: columnRow.columnVisible ? 1 : 0.28

                            Text {
                                anchors.centerIn: parent
                                text: "::"
                                color: theme.secondaryText
                                font.family: theme.dataFont
                                font.pixelSize: 15
                                font.bold: true
                            }
                        }

                        AppCheckBox {
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: 28
                            text: ""
                            checked: columnRow.columnVisible
                            onClicked: {
                                columnOrderModel.setProperty(columnRow.index, "columnVisible", checked)
                                fleetController.setColumnVisible(columnRow.columnKey, checked)
                                dialogs.applyColumnOrder()
                                dialogs.refreshColumnOrderModel()
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            text: columnRow.columnTitle
                            color: theme.secondaryText
                            font.family: theme.dataFont
                            font.pixelSize: 10
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                        }
                    }
                }
            }

            Timer {
                interval: 35
                repeat: true
                running: columnList.dragStartIndex >= 0
                onTriggered: {
                    const margin = 44
                    const step = 18
                    const maxContentY = Math.max(0, columnList.contentHeight - columnList.height)
                    const viewportY = columnList.dragContentY - columnList.contentY
                    if (viewportY < margin && columnList.contentY > 0) {
                        columnList.contentY = Math.max(0, columnList.contentY - step)
                        let targetIndex = columnList.indexAt(
                            columnList.width / 2,
                            columnList.contentY + 2
                        )
                        dialogs.updateDraggedColumnTarget(targetIndex < 0 ? 0 : targetIndex)
                    } else if (viewportY > columnList.height - margin
                               && columnList.contentY < maxContentY) {
                        columnList.contentY = Math.min(maxContentY, columnList.contentY + step)
                        let targetIndex = columnList.indexAt(
                            columnList.width / 2,
                            columnList.contentY + columnList.height - 2
                        )
                        dialogs.updateDraggedColumnTarget(
                            targetIndex < 0 ? columnOrderModel.count - 1 : targetIndex
                        )
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
            text: dialogs.csvSelectedOnly
                  ? "Checked parameters are excluded. This CSV will be applied to selected devices through the ESP32 REST API."
                  : "Checked parameters are excluded. Bulk operations preselect static IP, subnet mask, gateway, hostname, and manual system ID."
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
            enabled: !dialogs.csvSelectedOnly
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
                        dialogs.csvSelectedOnly || csvScope.currentIndex === 0 ? "selected" : "visible"
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
        objectName: "importCsvDialog"
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

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
    property var formatColumnTitle: function(value) { return value }

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
        unifiCheck.checked = values.unifi_enabled
        unifiGatewayField.text = values.unifi_gateway_url
        unifiTokenField.text = values.unifi_api_token
        unifiSiteField.text = values.unifi_site
        unifiVerifyTlsCheck.checked = values.unifi_verify_tls
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
        fleetController.resetRebootDialog()
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
                "columnTitle": dialogs.formatColumnTitle(columns[i].title.replace(/\n/g, " ")),
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
        if (fleetController.settingsTargetCount <= 0) {
            showToast("info", "Select a device before applying settings.")
            return
        }
        if (fleetController.settingsDirtyCount <= 0) {
            showToast("info", "Change at least one setting before applying.")
            return
        }
        confirmationKind = "settings"
        const targetDescription = fleetController.settingsUsesSelection
              ? fleetController.settingsTargetCount + " selected device(s)"
              : "the inspected ESP32"
        confirmText.text = "Apply " + fleetController.settingsDirtyCount
              + " changed setting(s) to " + targetDescription
              + "? Each ESP32 will reboot automatically after saving."
        center(confirmDialog)
        confirmDialog.open()
    }

    function confirmStaticIpAssignment() {
        confirmationKind = "static_ip_assign"
        confirmText.text = "Assign static IP settings to " + fleetController.eligibleStaticIpCount
                  + " eligible selected device(s)? Each device will reboot and stop responding at its current IP."
        center(confirmDialog)
        confirmDialog.open()
    }

    function confirmStaticIpClear() {
        confirmationKind = "static_ip_clear"
        confirmText.text = "Clear static IP, subnet mask, and gateway on "
                  + fleetController.eligibleStaticIpCount
                  + " eligible selected device(s)? Each device will reboot and use DHCP after reconnecting."
        center(confirmDialog)
        confirmDialog.open()
    }

    function confirmSysIdAlignment() {
        confirmationKind = "sys_id_alignment"
        confirmText.text = "Align SYS IDs for " + fleetController.eligibleSysIdAlignmentCount
                  + " eligible selected device(s)? This may write a MAVLink parameter and reboot each flight controller."
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

        ScrollView {
            id: scanSettingsScroll
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(scanSettingsGrid.implicitHeight, 430)
            clip: true
            ScrollBar.vertical.policy: ScrollBar.AsNeeded

            GridLayout {
                id: scanSettingsGrid
                width: scanSettingsScroll.availableWidth
            Layout.fillWidth: true
            columns: 2
            columnSpacing: 12
            rowSpacing: 8

            SettingTooltipLabel {
                text: "Discovery methods"
                tooltipText: "Choose one or both discovery methods. Both use the IPv4 subnet below."
                color: theme.secondaryText
                font.family: theme.bodyFont
            }
            ColumnLayout {
                AppCheckBox {
                    id: mavlinkCheck
                    text: "MAVLink broadcast (recommended) - UART must be configured"
                    SettingToolTip {
                        anchorItem: mavlinkCheck
                        visible: anchorItem.hovered
                        delay: 500
                        text: "Listens for DLSE devices advertising over MAVLink. The ESP32 UART must be configured to send these broadcasts."
                    }
                }
                AppCheckBox {
                    id: httpCheck
                    text: "HTTP IP-range scan (slow - robust)"
                    SettingToolTip {
                        anchorItem: httpCheck
                        visible: anchorItem.hovered
                        delay: 500
                        text: "Checks addresses in the subnet for DLSE devices over HTTP. This can find devices that aren’t advertising over MAVLink, but takes longer."
                    }
                }
            }

            SettingTooltipLabel {
                text: "IPv4 subnet"
                tooltipText: "The local IPv4 network to search, in CIDR notation—for example, 192.168.1.0/24. Used by both discovery methods."
                color: theme.secondaryText
                font.family: theme.bodyFont
            }
            AppTextField {
                id: subnetField
                Layout.fillWidth: true
                hoverEnabled: true
                placeholderText: "192.168.1.0/24"
                SettingToolTip {
                    anchorItem: subnetField
                    visible: anchorItem.hovered
                    delay: 500
                    text: "The local IPv4 network to search, in CIDR notation—for example, 192.168.1.0/24. Used by both discovery methods."
                }
            }

            SettingTooltipLabel {
                text: "ESP32 broadcast port"
                tooltipText: "UDP port on which DLSE devices send MAVLink discovery broadcasts. It must match the port configured on the devices."
                color: theme.secondaryText
                font.family: theme.bodyFont
            }
            AppTextField {
                id: esp32PortField
                Layout.fillWidth: true
                hoverEnabled: true
                inputMethodHints: Qt.ImhDigitsOnly
                SettingToolTip {
                    anchorItem: esp32PortField
                    visible: anchorItem.hovered
                    delay: 500
                    text: "UDP port on which DLSE devices send MAVLink discovery broadcasts. It must match the port configured on the devices."
                }
            }

            SettingTooltipLabel {
                text: "Local receive port"
                tooltipText: "UDP port this computer listens on for MAVLink broadcasts. Allow it through the computer’s firewall if needed."
                color: theme.secondaryText
                font.family: theme.bodyFont
            }
            AppTextField {
                id: localPortField
                Layout.fillWidth: true
                hoverEnabled: true
                inputMethodHints: Qt.ImhDigitsOnly
                SettingToolTip {
                    anchorItem: localPortField
                    visible: anchorItem.hovered
                    delay: 500
                    text: "UDP port this computer listens on for MAVLink broadcasts. Allow it through the computer’s firewall if needed."
                }
            }

            SettingTooltipLabel {
                text: "Discovery interval (s)"
                tooltipText: "How often the fleet manager starts a new discovery scan. A longer interval reduces network activity."
                color: theme.secondaryText
                font.family: theme.bodyFont
            }
            AppTextField {
                id: intervalField
                Layout.fillWidth: true
                hoverEnabled: true
                inputMethodHints: Qt.ImhDigitsOnly
                SettingToolTip {
                    anchorItem: intervalField
                    visible: anchorItem.hovered
                    delay: 500
                    text: "How often the fleet manager starts a new discovery scan. A longer interval reduces network activity."
                }
            }

            SettingTooltipLabel {
                text: "HTTP timeout (s)"
                tooltipText: "Maximum time to wait for each HTTP discovery request before treating it as a failure."
                color: theme.secondaryText
                font.family: theme.bodyFont
            }
            AppTextField {
                id: timeoutField
                Layout.fillWidth: true
                hoverEnabled: true
                SettingToolTip {
                    anchorItem: timeoutField
                    visible: anchorItem.hovered
                    delay: 500
                    text: "Maximum time to wait for each HTTP discovery request before treating it as a failure."
                }
            }

            SettingTooltipLabel {
                text: "HTTP concurrency"
                tooltipText: "Maximum number of simultaneous HTTP checks. Higher values can speed up large subnet scans but increase network activity."
                color: theme.secondaryText
                font.family: theme.bodyFont
            }
            AppTextField {
                id: workersField
                Layout.fillWidth: true
                hoverEnabled: true
                inputMethodHints: Qt.ImhDigitsOnly
                SettingToolTip {
                    anchorItem: workersField
                    visible: anchorItem.hovered
                    delay: 500
                    text: "Maximum number of simultaneous HTTP checks. Higher values can speed up large subnet scans but increase network activity."
                }
            }

            Rectangle {
                Layout.columnSpan: 2
                Layout.fillWidth: true
                Layout.topMargin: 8
                Layout.preferredHeight: 1
                color: theme.border
            }

            Text {
                Layout.columnSpan: 2
                text: "UNIFI AP OBSERVATIONS"
                color: theme.primaryText
                font.family: theme.dataFont
                font.pixelSize: theme.smallTextSize
                font.bold: true
            }

            SettingTooltipLabel {
                text: "Connect to UniFi"
                tooltipText: "Enables periodic queries to the UniFi Network API to show access-point observations for discovered devices."
                color: theme.secondaryText
                font.family: theme.bodyFont
            }
            AppCheckBox {
                id: unifiCheck
                objectName: "unifiEnabledCheck"
                text: "Enabled"
                SettingToolTip {
                    anchorItem: unifiCheck
                    visible: anchorItem.hovered
                    delay: 500
                    text: "Enables periodic queries to the UniFi Network API to show access-point observations for discovered devices."
                }
            }

            SettingTooltipLabel {
                text: "Gateway URL"
                tooltipText: "Base URL of the UniFi gateway or Network application, including https:// when applicable."
                color: theme.secondaryText
                font.family: theme.bodyFont
            }
            AppTextField {
                id: unifiGatewayField
                objectName: "unifiGatewayField"
                Layout.fillWidth: true
                hoverEnabled: true
                enabled: unifiCheck.checked
                placeholderText: "https://192.168.1.1"
                SettingToolTip {
                    anchorItem: unifiGatewayField
                    visible: anchorItem.hovered
                    delay: 500
                    text: "Base URL of the UniFi gateway or Network application, including https:// when applicable."
                }
            }

            SettingTooltipLabel {
                text: "API token"
                tooltipText: "UniFi Network API token used to retrieve access-point observations."
                color: theme.secondaryText
                font.family: theme.bodyFont
            }
            AppTextField {
                id: unifiTokenField
                objectName: "unifiTokenField"
                Layout.fillWidth: true
                hoverEnabled: true
                enabled: unifiCheck.checked
                echoMode: TextInput.Password
                placeholderText: "UniFi Network API token"
                SettingToolTip {
                    anchorItem: unifiTokenField
                    visible: anchorItem.hovered
                    delay: 500
                    text: "UniFi Network API token used to retrieve access-point observations."
                }
            }

            SettingTooltipLabel {
                text: "Site"
                tooltipText: "UniFi site name or identifier to query, commonly default."
                color: theme.secondaryText
                font.family: theme.bodyFont
            }
            AppTextField {
                id: unifiSiteField
                objectName: "unifiSiteField"
                Layout.fillWidth: true
                hoverEnabled: true
                enabled: unifiCheck.checked
                placeholderText: "default"
                SettingToolTip {
                    anchorItem: unifiSiteField
                    visible: anchorItem.hovered
                    delay: 500
                    text: "UniFi site name or identifier to query, commonly default."
                }
            }

            SettingTooltipLabel {
                text: "TLS certificate"
                tooltipText: "Checks the gateway’s TLS certificate. Turn this off only when using a trusted gateway with a self-signed certificate."
                color: theme.secondaryText
                font.family: theme.bodyFont
            }
            AppCheckBox {
                id: unifiVerifyTlsCheck
                objectName: "unifiVerifyTlsCheck"
                enabled: unifiCheck.checked
                text: "Verify certificate"
                SettingToolTip {
                    anchorItem: unifiVerifyTlsCheck
                    visible: anchorItem.hovered
                    delay: 500
                    text: "Checks the gateway’s TLS certificate. Turn this off only when using a trusted gateway with a self-signed certificate."
                }
            }

            Text {
                Layout.columnSpan: 2
                Layout.fillWidth: true
                text: "The API token is saved in this user's local application settings. Leave certificate verification off only for a trusted gateway using a self-signed certificate."
                color: theme.mutedText
                wrapMode: Text.Wrap
                font.family: theme.bodyFont
                font.pixelSize: theme.smallTextSize
            }

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
                font.pixelSize: theme.smallTextSize
                font.bold: true
            }

            SettingTooltipLabel {
                text: "Background polling"
                tooltipText: "Periodically requests /api/system/stats from known devices to refresh runtime values and online status."
                color: theme.secondaryText
                font.family: theme.bodyFont
            }
            AppCheckBox {
                id: statsEnabledCheck
                text: "Enabled"
                SettingToolTip {
                    anchorItem: statsEnabledCheck
                    visible: anchorItem.hovered
                    delay: 500
                    text: "Periodically requests /api/system/stats from known devices to refresh runtime values and online status."
                }
            }

            SettingTooltipLabel {
                text: "Target interval (s)"
                tooltipText: "Delay between polling rounds. Shorter intervals update stats sooner but create more network traffic."
                color: theme.secondaryText
                font.family: theme.bodyFont
            }
            AppTextField {
                id: statsIntervalField
                Layout.fillWidth: true
                hoverEnabled: true
                enabled: statsEnabledCheck.checked
                inputMethodHints: Qt.ImhDigitsOnly
                SettingToolTip {
                    anchorItem: statsIntervalField
                    visible: anchorItem.hovered
                    delay: 500
                    text: "Delay between polling rounds. Shorter intervals update stats sooner but create more network traffic."
                }
            }

            SettingTooltipLabel {
                text: "Request timeout (s)"
                tooltipText: "Maximum time to wait for each device’s stats response before counting the request as failed."
                color: theme.secondaryText
                font.family: theme.bodyFont
            }
            AppTextField {
                id: statsTimeoutField
                Layout.fillWidth: true
                hoverEnabled: true
                enabled: statsEnabledCheck.checked
                SettingToolTip {
                    anchorItem: statsTimeoutField
                    visible: anchorItem.hovered
                    delay: 500
                    text: "Maximum time to wait for each device’s stats response before counting the request as failed."
                }
            }

            SettingTooltipLabel {
                text: "HTTP concurrency"
                tooltipText: "Maximum number of devices queried for stats at the same time. Higher values can shorten a polling round but increase network load."
                color: theme.secondaryText
                font.family: theme.bodyFont
            }
            AppTextField {
                id: statsWorkersField
                Layout.fillWidth: true
                hoverEnabled: true
                enabled: statsEnabledCheck.checked
                inputMethodHints: Qt.ImhDigitsOnly
                SettingToolTip {
                    anchorItem: statsWorkersField
                    visible: anchorItem.hovered
                    delay: 500
                    text: "Maximum number of devices queried for stats at the same time. Higher values can shorten a polling round but increase network load."
                }
            }

            SettingTooltipLabel {
                text: "Failures before offline"
                tooltipText: "Number of consecutive failed stats requests before a device is marked offline. A successful response marks it online again."
                color: theme.secondaryText
                font.family: theme.bodyFont
            }
            AppTextField {
                id: statsFailureThresholdField
                Layout.fillWidth: true
                hoverEnabled: true
                enabled: statsEnabledCheck.checked
                inputMethodHints: Qt.ImhDigitsOnly
                SettingToolTip {
                    anchorItem: statsFailureThresholdField
                    visible: anchorItem.hovered
                    delay: 500
                    text: "Number of consecutive failed stats requests before a device is marked offline. A successful response marks it online again."
                }
            }
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
                        Number(statsFailureThresholdField.text),
                        unifiCheck.checked,
                        unifiGatewayField.text,
                        unifiTokenField.text,
                        unifiSiteField.text,
                        unifiVerifyTlsCheck.checked
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
            echoMode: TextInput.Normal
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
        preferredWidth: 560
        dismissible: fleetController.rebootState !== "running"

        Text {
            Layout.fillWidth: true
            visible: fleetController.rebootState === "ready"
            text: "REST confirms request acceptance per device. MAVLink sends one unverified broadcast command to all visible online devices."
            color: theme.warning
            wrapMode: Text.Wrap
            font.family: theme.bodyFont
        }

        ColumnLayout {
            Layout.fillWidth: true
            visible: fleetController.rebootState === "ready"
            spacing: 12

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
                    onClicked: fleetController.startReboot(
                        rebootScope.currentIndex === 0 ? "selected" : "visible",
                        rebootMethod.currentIndex === 1 ? "mavlink" : "rest"
                    )
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            visible: fleetController.rebootState !== "ready"
            spacing: 12

            Text {
                Layout.fillWidth: true
                text: fleetController.rebootState === "running"
                      ? "rebooting"
                      : "reboot accepted"
                color: theme.primaryText
                font.family: theme.dataFont
                font.pixelSize: theme.smallTextSize
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 21
                visible: fleetController.rebootMethod !== "mavlink"
                         || fleetController.rebootState === "running"

                Rectangle {
                    id: rebootProgressTrack
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 7
                    anchors.rightMargin: 7
                    anchors.verticalCenter: parent.verticalCenter
                    height: 7
                    radius: 3
                    color: theme.border
                    clip: true

                    Rectangle {
                        id: rebootProgressFill
                        height: parent.height
                        width: fleetController.rebootMethod === "mavlink"
                               && fleetController.rebootState === "running"
                               ? Math.min(parent.width, Math.max(16, parent.width * 0.28))
                               : parent.width * Math.max(
                                     0,
                                     Math.min(100, fleetController.rebootProgress)
                                 ) / 100
                        radius: parent.radius
                        color: fleetController.rebootFailedIps.length > 0
                               ? theme.error : theme.accent

                        SequentialAnimation on x {
                            running: fleetController.rebootMethod === "mavlink"
                                     && fleetController.rebootState === "running"
                            loops: Animation.Infinite
                            NumberAnimation {
                                from: 0
                                to: Math.max(0, rebootProgressTrack.width - rebootProgressFill.width)
                                duration: 700
                            }
                            NumberAnimation {
                                from: Math.max(0, rebootProgressTrack.width - rebootProgressFill.width)
                                to: 0
                                duration: 700
                            }
                        }
                    }
                }
            }

            Text {
                Layout.fillWidth: true
                text: fleetController.rebootProgressText
                color: theme.primaryText
                wrapMode: Text.Wrap
                font.family: theme.dataFont
                font.pixelSize: theme.smallTextSize
            }

            Text {
                Layout.fillWidth: true
                visible: fleetController.rebootMethod === "rest"
                text: "A successful HTTP response confirms that the request was accepted; it does not confirm that the device finished rebooting."
                color: theme.secondaryText
                wrapMode: Text.Wrap
                font.family: theme.bodyFont
            }

            ColumnLayout {
                Layout.fillWidth: true
                visible: fleetController.rebootFailedIps.length > 0
                spacing: 6

                Text {
                    text: "Failed device IPs (" + fleetController.rebootFailedIps.length + ")"
                    color: theme.error
                    font.family: theme.bodyFont
                    font.bold: true
                }

                ScrollView {
                    id: failedRebootIpsScroll
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.min(contentHeight, 170)
                    Layout.maximumHeight: 170
                    clip: true

                    Text {
                        width: failedRebootIpsScroll.availableWidth
                        text: fleetController.rebootFailedIps.join("\n")
                        color: theme.primaryText
                        font.family: theme.dataFont
                        font.pixelSize: theme.smallTextSize
                        wrapMode: Text.NoWrap
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                visible: fleetController.rebootState === "finished"
                AppButton {
                    visible: fleetController.rebootCanRetry
                    text: "Retry Failed"
                    onClicked: fleetController.retryFailed()
                }
                Item { Layout.fillWidth: true }
                AppButton {
                    text: "Close"
                    emphasized: true
                    onClicked: rebootDialog.close()
                }
            }
        }
    }

    ModalDialog {
        id: staticIpAssignmentDialog
        objectName: "staticIpAssignmentDialog"
        title: "Manage Static IPs"
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

        Text {
            Layout.fillWidth: true
            text: "Clear All Static IPs sends empty static IP, subnet mask, and gateway values to every eligible device. Each device reboots and will use DHCP after reconnecting."
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
                text: "Clear All Static IPs"
                quiet: true
                enabled: fleetController.eligibleStaticIpCount > 0
                onClicked: dialogs.confirmStaticIpClear()
            }
            AppButton {
                text: "Assign Static IPs"
                emphasized: true
                enabled: fleetController.eligibleStaticIpCount > 0
                         && staticIpStartField.text.trim().length > 0
                         && staticIpNetmaskField.text.trim().length > 0
                         && staticIpGatewayField.text.trim().length > 0
                onClicked: dialogs.confirmStaticIpAssignment()
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
                onClicked: dialogs.confirmSysIdAlignment()
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
                font.pixelSize: theme.bodyTextSize
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
                                font.pixelSize: theme.headingTextSize
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
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            text: columnRow.columnTitle
                            color: theme.secondaryText
                            font.family: theme.dataFont
                            font.pixelSize: theme.smallTextSize
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                        }
                    }
                }

                Rectangle {
                    id: dropIndicator
                    visible: columnList.dragStartIndex >= 0
                             && columnList.dragTargetIndex === columnRow.index
                             && columnList.dragStartIndex !== columnRow.index
                    x: 8
                    y: columnRow.index === 0 ? 0 : -2
                    width: parent.width - 16
                    height: 3
                    radius: 1.5
                    color: theme.accent
                    z: 20
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
        objectName: "confirmDialog"
        title: confirmationKind === "clear" ? "Clear Detected Devices"
             : confirmationKind === "settings" ? "Apply Settings"
             : confirmationKind === "static_ip_assign" ? "Assign Static IPs"
             : confirmationKind === "static_ip_clear" ? "Clear Static IPs"
             : "Align SYS IDs"
        preferredWidth: 460

        Text {
            id: confirmText
            objectName: "confirmText"
            Layout.fillWidth: true
            color: theme.primaryText
            wrapMode: Text.Wrap
            font.family: theme.bodyFont
            font.pixelSize: theme.bodyTextSize
        }

        RowLayout {
            Layout.fillWidth: true
            Item { Layout.fillWidth: true }
            AppButton { text: "Cancel"; quiet: true; onClicked: confirmDialog.close() }
            AppButton {
                text: confirmationKind === "clear" ? "Clear Detected Devices"
                    : confirmationKind === "settings" ? "Apply and Reboot"
                    : confirmationKind === "static_ip_assign" ? "Assign Static IPs"
                    : confirmationKind === "static_ip_clear" ? "Clear Static IPs"
                    : "Align SYS IDs"
                emphasized: true
                accentColor: confirmationKind === "clear" || confirmationKind === "static_ip_clear"
                             ? theme.error : theme.accent
                onClicked: {
                    if (confirmationKind === "clear")
                        fleetController.clearFleet()
                    else if (confirmationKind === "settings")
                        fleetController.applyEditedSettings()
                    else if (confirmationKind === "static_ip_assign") {
                        const started = fleetController.startStaticIpAssignment(
                            staticIpStartField.text,
                            staticIpNetmaskField.text,
                            staticIpGatewayField.text
                        )
                        if (started)
                            staticIpAssignmentDialog.close()
                    } else if (confirmationKind === "static_ip_clear") {
                        if (fleetController.clearStaticIpAssignments())
                            staticIpAssignmentDialog.close()
                    } else if (confirmationKind === "sys_id_alignment") {
                        const modes = ["ip", "fc", "manual"]
                        fleetController.startSysIdAlignment(modes[sysIdAlignmentMode.currentIndex])
                        sysIdAlignmentDialog.close()
                    }
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
            font.pixelSize: theme.bodyTextSize
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
            font.pixelSize: theme.bodyTextSize
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

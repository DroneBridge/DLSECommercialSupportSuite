import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: mainScreen
    objectName: "mainScreen"

    signal backRequested()

    property bool inspectorExpanded: true
    property int viewMode: 0
    property int sortColumn: 1
    property bool sortAscending: true
    property bool resizingColumn: false
    property bool resizingInspector: false

    function footerText(label, value, valueColor) {
        return "<font color=\"" + theme.secondaryText + "\">" + label
             + "</font>  <font color=\"" + valueColor + "\">" + value + "</font>"
    }

    function processStatusColor(value) {
        const normalized = String(value).toUpperCase()
        if (normalized === "ERROR")
            return theme.error
        if (normalized === "SCANNING" || normalized === "POLLING")
            return theme.accent
        if (normalized === "WAITING")
            return theme.warning
        return theme.secondaryText
    }

    /** Operation names shown in the footer, keyed by FleetController.activeOperation. */
    readonly property var operationLabels: ({
        "activation": "OTA DLSE ACTIVATION",
        "reboot": "REBOOTING DEVICES",
        "ota": "OTA FIRMWARE UPGRADE",
        "ota release": "RESOLVING RELEASE",
        "settings": "APPLYING SETTINGS",
        "static_ip": "ASSIGNING STATIC IPS",
        "sys_id_alignment": "ALIGNING SYS IDS"
    })

    /** True while an operation is cancelling its queued work. */
    readonly property bool activityCancelling: fleetController.statusText.indexOf("CANCELLING") === 0

    /**
     * Return the single most relevant activity: a running operation, then
     * discovery (scanning/waiting), then an error, otherwise idle.
     */
    readonly property string activityLabel: {
        const operation = fleetController.activeOperation
        if (activityCancelling)
            return "CANCELLING QUEUED WORK"
        if (operation.length > 0)
            return operationLabels[operation] || operation.toUpperCase()
        const discovery = fleetController.discoveryStatus
        if (discovery === "SCANNING" || discovery === "WAITING")
            return discovery
        if (discovery === "ERROR" || fleetController.statusText.indexOf("ERROR") >= 0)
            return "ERROR"
        return "IDLE"
    }

    /** Footer value color for the fused activity: orange busy, warning waiting, red error. */
    readonly property color activityColor: activityLabel === "ERROR" ? theme.error
                                           : activityLabel === "WAITING" ? theme.warning
                                           : activityLabel === "IDLE" ? theme.secondaryText
                                           : theme.accent

    /** Hover text explaining the fused activity value, including the raw discovery state. */
    function activityTooltip() {
        if (activityCancelling)
            return "Operations already running will finish; queued work is cancelled."
        if (fleetController.activeOperation.length > 0)
            return "Fleet operation in progress. Discovery: " + fleetController.discoveryStatus + "."
        if (activityLabel === "ERROR")
            return "The last scan or operation reported an error. See the notification for details."
        return "Discovery: " + fleetController.discoveryStatus + "."
    }

    /** Return a sentence-case header for the model value, preserving technical abbreviations. */
    function formatFleetHeader(value) {
        const abbreviations = {
            ap: "AP", apmode: "AP mode", cts: "CTS", db: "DB", dlse: "DLSE", esp: "ESP",
            fc: "FC", gpio: "GPIO", id: "ID", ip: "IP", led: "LED", mac: "MAC", mavlink: "MAVLink",
            rssi: "RSSI", rts: "RTS", rx: "RX", ssid: "SSID", sys: "SYS", tx: "TX", udp: "UDP", wifi: "Wi-Fi"
        }
        return String(value).toLowerCase().replace(/[a-z]+/g, function(word, offset) {
            if (abbreviations[word]) return abbreviations[word]
            return offset === 0 ? word.charAt(0).toUpperCase() + word.slice(1) : word
        })
    }

    /** Return the shared header and cell alignment for a fleet column key. */
    function fleetColumnAlignment(key) {
        const centered = ["selected", "activation_status", "online", "ap_band",
                          "led_cont_en", "adc_a_en", "adc_v_en", "power_mgmt",
                          "dlse_mavlink_heartbeat", "dlse_mavlink_sys_id_based_on_ip"]
        const numeric = ["mavlink_sys_id", "fc_sys_id", "wifi_channel", "rssi",
                         "ap_rssi", "ap_channel", "ap_live_throughput", "ap_rx_rate",
                         "ap_tx_rate", "baud", "gpio_cts", "gpio_rts", "gpio_tx",
                         "gpio_rx", "dlse_local_udp_port", "dlse_remote_udp_port"]
        return centered.indexOf(key) >= 0 ? Text.AlignHCenter
             : numeric.indexOf(key) >= 0 ? Text.AlignRight : Text.AlignLeft
    }

    function dlseParameterWarning(columnKey, display) {
        const value = String(display).trim()
        if (columnKey === "power_mgmt"
                || columnKey === "adc_a_en"
                || columnKey === "adc_v_en"
                || columnKey === "led_cont_en")
            return value.toLowerCase() === "disabled"
        if (columnKey === "dlse_mavlink_heartbeat")
            return value.toLowerCase() === "enabled"
        if (columnKey === "dlse_mode")
            return value !== "" && value.toUpperCase() !== "CLIENT"
        return false
    }

    Theme { id: theme }

    Rectangle {
        anchors.fill: parent
        color: theme.background
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 64
            color: theme.panel

            RowLayout {
                objectName: "statusFooter"
                anchors.fill: parent
                spacing: 12

                ModeHeaderLeft {
                    onBackRequested: mainScreen.backRequested()
                }

                Text {
                    Layout.preferredWidth: 158
                    text: "Version: " + fleetController.suiteVersion
                    color: theme.mutedText
                    font.family: theme.dataFont
                    font.pixelSize: theme.smallTextSize
                }

                AppTextField {
                    id: searchField
                    Layout.fillWidth: true
                    Layout.maximumWidth: 390
                    Layout.preferredHeight: 34
                    placeholderText: "Search SYS ID, MAC, IP, activation key..."
                    onTextChanged: searchDelay.restart()

                    Image {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: 9
                        width: 18
                        height: 18
                        source: Qt.resolvedUrl("../resources/images/search_24dp.svg")
                    }
                }

                Timer {
                    id: searchDelay
                    interval: 140
                    onTriggered: fleetController.setSearchText(searchField.text)
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    Layout.preferredWidth: 176
                    Layout.fillHeight: true
                    color: Qt.rgba(255 / 255, 142 / 255, 0, 0.04)
                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: 3
                        color: theme.accent
                    }
                    Text {
                        anchors.centerIn: parent
                        text: "FLEET MANAGER"
                        color: theme.primaryText
                        font.family: theme.bodyFont
                        font.pixelSize: theme.bodyTextSize
                        font.bold: true
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 198
                    Layout.fillHeight: true
                    color: "transparent"
                    opacity: 0.45
                    Text {
                        anchors.centerIn: parent
                        text: "NETWORK MANAGER"
                        color: theme.primaryText
                        font.family: theme.bodyFont
                        font.pixelSize: theme.bodyTextSize
                        font.bold: true
                    }
                }

                FocusScope {
                    id: headerSettingsFocus
                    Layout.preferredWidth: 48
                    Layout.preferredHeight: 63
                    activeFocusOnTab: true

                    SettingsTab {
                        id: headerSettingsTab
                        objectName: "headerSettingsTab"
                        anchors.fill: parent
                        eigenschaft_2: headerSettingsMouse.pressed
                                       || headerSettingsMouse.containsMouse
                                       || headerSettingsFocus.activeFocus
                                       ? SettingsTab.Eigenschaft_1.Eigenschaft_1_Variante2
                                       : SettingsTab.Eigenschaft_1.Eigenschaft_1_Standard
                    }

                    MouseArea {
                        id: headerSettingsMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onPressed: headerSettingsFocus.forceActiveFocus()
                        onClicked: fleetDialogs.openScanSettings()
                    }

                    Keys.onSpacePressed: fleetDialogs.openScanSettings()
                    Keys.onReturnPressed: fleetDialogs.openScanSettings()
                    Keys.onEnterPressed: fleetDialogs.openScanSettings()
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 20
            spacing: 14

            Rectangle {
                id: toolbarPanel
                objectName: "fleetToolbar"
                Layout.fillWidth: true
                implicitHeight: toolbarFlow.implicitHeight + 24
                color: theme.panel
                radius: 6

                // Wraps onto a second line below the minimum window width instead of clipping.
                Flow {
                    id: toolbarFlow
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 10

                    readonly property real gap: width - scanGroup.width - toolbarDivider.width - operationGroup.width
                                                - (cancelButton.visible ? cancelButton.width + spacing : 0) - 3 * spacing
                    readonly property bool singleLine: gap >= 0

                    Row {
                        id: scanGroup
                        spacing: 8

                        AppButton {
                            objectName: "scanButton"
                            width: 164
                            text: fleetController.scanning ? "Stop Scanning" : "Scan for Devices"
                            busy: fleetController.scanning
                            iconSource: Qt.resolvedUrl("../resources/images/radar_24dp.svg")
                            emphasized: true
                            onClicked: fleetController.toggleScanning()
                        }

                        AppButton {
                            objectName: "scanSettingsButton"
                            width: 36
                            implicitWidth: 36
                            iconSource: Qt.resolvedUrl("../resources/images/settings_24dp.svg")
                            Accessible.name: "Scan settings"
                            onClicked: fleetDialogs.openScanSettings()
                        }

                        AppButton {
                            objectName: "clearFleetButton"
                            text: "Clear Detected Devices"
                            enabled: fleetController.detectedCount > 0
                            onClicked: fleetDialogs.openClearFleet()
                        }
                    }

                    Item {
                        width: Math.max(0, toolbarFlow.gap)
                        height: 1
                        visible: toolbarFlow.singleLine
                    }

                    Rectangle {
                        id: toolbarDivider
                        width: 1
                        height: 34
                        color: theme.border
                        visible: toolbarFlow.singleLine
                    }

                    Row {
                        id: operationGroup
                        spacing: 8

                        AppButton {
                            objectName: "rebootButton"
                            text: "Reboot Devices"
                            iconSource: Qt.resolvedUrl("../resources/images/restart_alt_24dp.svg")
                            enabled: fleetController.detectedCount > 0 && fleetController.activeOperation.length === 0
                            onClicked: fleetDialogs.openReboot()
                        }

                        AppButton {
                            objectName: "assignStaticIpButton"
                            text: "Manage Static IPs"
                            iconSource: Qt.resolvedUrl("../resources/images/format_list_numbered.svg")
                            enabled: fleetController.eligibleStaticIpCount > 0
                                     && fleetController.activeOperation.length === 0
                            onClicked: fleetDialogs.openStaticIpAssignment()
                        }

                        AppButton {
                            objectName: "alignSysIdsButton"
                            text: "Align SYS IDs"
                            iconSource: Qt.resolvedUrl("sync_alt.svg")
                            enabled: fleetController.selectedCount > 0 && fleetController.activeOperation.length === 0
                            onClicked: fleetDialogs.openAlignSysIds()
                        }

                        AppButton {
                            objectName: "otaFirmwareButton"
                            text: "OTA Firmware Upgrade"
                            iconSource: Qt.resolvedUrl("../resources/images/computer_arrow_up_24dp.svg")
                            enabled: fleetController.detectedCount > 0 && fleetController.activeOperation.length === 0
                            onClicked: fleetDialogs.openOta()
                        }

                        AppButton {
                            objectName: "otaActivationButton"
                            text: "OTA DLSE Activation"
                            iconSource: Qt.resolvedUrl("../resources/images/key_24dp.svg")
                            enabled: fleetController.detectedCount > 0 && fleetController.activeOperation.length === 0
                            onClicked: fleetDialogs.openActivation()
                        }

                        AppButton {
                            objectName: "applySettingsButton"
                            text: "Apply Settings"
                            iconSource: Qt.resolvedUrl("../resources/images/upload_file_24dp.svg")
                            enabled: fleetController.selectedCount > 0 && fleetController.activeOperation.length === 0
                            onClicked: fleetDialogs.openApplyCsvToSelected()
                        }
                    }

                    AppButton {
                        id: cancelButton
                        objectName: "cancelQueuedButton"
                        visible: fleetController.canCancel
                        text: "Cancel Queued"
                        accentColor: theme.warning
                        emphasized: true
                        onClicked: fleetController.cancelActiveOperation()
                    }
                }
            }

            RowLayout {
                id: workspaceRow
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 16

                Rectangle {
                    id: tablePanel
                    objectName: "fleetTablePanel"
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: theme.panel
                    radius: 6
                    border.color: theme.border
                    border.width: 1
                    clip: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 1
                        spacing: 0

                        RowLayout {
                            id: selectionRow
                            objectName: "fleetSelectionRow"
                            Layout.fillWidth: true
                            Layout.preferredHeight: 44
                            Layout.leftMargin: 16
                            Layout.rightMargin: 12
                            spacing: 14

                            AppCheckBox {
                                objectName: "selectAllCheckbox"
                                text: "Select all"
                                textSize: theme.bodyTextSize
                                onClicked: fleetController.selectAll(checked)
                            }

                            AppCheckBox {
                                objectName: "selectVisibleCheckbox"
                                text: "Select visible"
                                textSize: theme.bodyTextSize
                                onClicked: fleetController.selectVisible(checked)
                            }

                            Item { Layout.fillWidth: true }

                            AppButton {
                                objectName: "configureColumnsButton"
                                text: "Configure columns"
                                quiet: true
                                textBold: false
                                textSize: theme.bodyTextSize
                                iconSource: Qt.resolvedUrl("../resources/images/settings_24dp.svg")
                                onClicked: fleetDialogs.openColumns()
                            }

                            Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 18; color: theme.border }

                            Rectangle {
                                id: viewModeSwitch
                                objectName: "viewModeSwitch"
                                Layout.preferredWidth: 156
                                Layout.preferredHeight: 28
                                radius: 5
                                color: theme.background
                                border.color: theme.border
                                border.width: 1

                                component ViewSegment: FocusScope {
                                    id: segment
                                    required property int mode
                                    required property string label
                                    required property string iconFile
                                    required property string iconObjectName
                                    readonly property bool current: mainScreen.viewMode === mode

                                    width: (viewModeSwitch.width - 4) / 2
                                    height: viewModeSwitch.height - 4
                                    activeFocusOnTab: true
                                    Accessible.role: Accessible.Button
                                    Accessible.name: label + " view"
                                    Accessible.checked: current

                                    Rectangle {
                                        anchors.fill: parent
                                        radius: 4
                                        color: segment.current ? theme.raised
                                               : segmentMouse.containsMouse || segment.activeFocus ? theme.hover : "transparent"
                                    }

                                    Row {
                                        anchors.centerIn: parent
                                        spacing: 6

                                        Image {
                                            objectName: segment.iconObjectName
                                            width: 16
                                            height: 16
                                            source: Qt.resolvedUrl("../resources/images/" + segment.iconFile)
                                            sourceSize.width: 16
                                            sourceSize.height: 16
                                            fillMode: Image.PreserveAspectFit
                                            opacity: segment.current ? 1 : 0.6
                                        }

                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: segment.label
                                            color: segment.current ? theme.primaryText : theme.secondaryText
                                            font.family: theme.bodyFont
                                            font.bold: false
                                        }
                                    }

                                    MouseArea {
                                        id: segmentMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onPressed: segment.forceActiveFocus()
                                        onClicked: mainScreen.viewMode = segment.mode
                                    }

                                    Keys.onSpacePressed: mainScreen.viewMode = mode
                                    Keys.onReturnPressed: mainScreen.viewMode = mode
                                    Keys.onEnterPressed: mainScreen.viewMode = mode
                                }

                                Row {
                                    anchors.fill: parent
                                    anchors.margins: 2

                                    ViewSegment {
                                        objectName: "listViewButton"
                                        mode: 0
                                        label: "List"
                                        iconFile: "list_24dp.svg"
                                        iconObjectName: "listViewIcon"
                                    }

                                    ViewSegment {
                                        objectName: "gridViewButton"
                                        mode: 1
                                        label: "Matrix"
                                        iconFile: "grid_view.svg"
                                        iconObjectName: "gridViewIcon"
                                    }
                                }
                            }
                        }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: theme.border }
                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true

                            StackLayout {
                                anchors.fill: parent
                                currentIndex: viewMode

                                Item {
                                    ColumnLayout {
                                        anchors.fill: parent
                                        spacing: 0

                                        HorizontalHeaderView {
                                            id: tableHeader
                                            Layout.fillWidth: true
                                            Layout.preferredHeight: 37
                                            syncView: tableView
                                            interactive: !mainScreen.resizingColumn && !mainScreen.resizingInspector
                                            resizableColumns: false
                                            clip: true

                                            delegate: Rectangle {
                                                id: headerCell
                                                objectName: "fleetHeaderCell_" + index

                                                required property var display
                                                required property int index
                                                readonly property string columnKey: index === 0 ? "selected"
                                                    : (fleetController.columns[index - 1] || {}).key || ""
                                                property real resizeStartX: 0
                                                property int resizeStartWidth: 0

                                                implicitWidth: fleetController.columnWidth(index)
                                                implicitHeight: 37
                                                color: theme.hover
                                                border.width: 0

                                                Text {
                                                    objectName: "fleetHeaderText_" + index
                                                    anchors.fill: parent
                                                    anchors.leftMargin: 8
                                                    anchors.rightMargin: 8
                                                    text: mainScreen.formatFleetHeader(display) + (mainScreen.sortColumn === index
                                                                     ? (mainScreen.sortAscending ? "  ↑" : "  ↓") : "")
                                                    color: theme.secondaryText
                                                    font.family: theme.bodyFont
                                                    font.pixelSize: theme.smallTextSize
                                                    font.bold: true
                                                    readonly property int columnAlignment: mainScreen.fleetColumnAlignment(headerCell.columnKey)
                                                    horizontalAlignment: columnAlignment
                                                    verticalAlignment: Text.AlignVCenter
                                                    elide: Text.ElideRight
                                                }

                                                MouseArea {
                                                    anchors.fill: parent
                                                    anchors.rightMargin: resizeHandle.width
                                                    onClicked: {
                                                        if (mainScreen.sortColumn === index)
                                                            mainScreen.sortAscending = !mainScreen.sortAscending
                                                        else {
                                                            mainScreen.sortColumn = index
                                                            mainScreen.sortAscending = true
                                                        }
                                                        fleetController.sortByColumn(index, mainScreen.sortAscending)
                                                    }
                                                }

                                                MouseArea {
                                                    id: resizeHandle
                                                    anchors.top: parent.top
                                                    anchors.right: parent.right
                                                    anchors.bottom: parent.bottom
                                                    width: 8
                                                    enabled: index > 0
                                                    hoverEnabled: true
                                                    preventStealing: true
                                                    cursorShape: Qt.SplitHCursor
                                                    z: 2

                                                    onPressed: function(mouse) {
                                                        mouse.accepted = true
                                                        mainScreen.resizingColumn = true
                                                        const point = resizeHandle.mapToItem(tableHeader, mouse.x, mouse.y)
                                                        headerCell.resizeStartX = point.x
                                                        headerCell.resizeStartWidth = fleetController.columnWidth(index)
                                                    }

                                                    onPositionChanged: function(mouse) {
                                                        if (!pressed)
                                                            return
                                                        const point = resizeHandle.mapToItem(tableHeader, mouse.x, mouse.y)
                                                        fleetController.setColumnWidth(
                                                            index,
                                                            headerCell.resizeStartWidth
                                                                + Math.round(point.x - headerCell.resizeStartX)
                                                        )
                                                        tableView.forceLayout()
                                                        tableHeader.forceLayout()
                                                    }

                                                    onReleased: mainScreen.resizingColumn = false
                                                    onCanceled: mainScreen.resizingColumn = false

                                                    onDoubleClicked: {
                                                        fleetController.resetColumnWidth(index)
                                                        tableView.forceLayout()
                                                        tableHeader.forceLayout()
                                                    }

                                                    Rectangle {
                                                        anchors.top: parent.top
                                                        anchors.bottom: parent.bottom
                                                        anchors.horizontalCenter: parent.horizontalCenter
                                                        width: 2
                                                        color: resizeHandle.pressed || resizeHandle.containsMouse
                                                               ? theme.accent : "transparent"
                                                    }
                                                }
                                            }
                                        }

                                        TableView {
                                            id: tableView
                                            objectName: "fleetTable"
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            clip: true
                                            reuseItems: true
                                            model: fleetModel
                                            interactive: !mainScreen.resizingColumn && !mainScreen.resizingInspector
                                            columnWidthProvider: function(column) {
                                                return fleetController.columnWidth(column)
                                            }
                                            rowHeightProvider: function(_row) { return 42 }
                                            ScrollBar.vertical: ScrollBar {}
                                            ScrollBar.horizontal: ScrollBar {}

                                            delegate: Rectangle {
                                                required property int row
                                                required property int column
                                                required property var display
                                                required property string columnKey
                                                required property string identity
                                                required property bool selected
                                                required property string activationStatus
                                                required property bool online
                                                required property bool fcSysIdMismatch
                                                required property string operation
                                                required property int operationProgress

                                                color: selected ? "#12304d"
                                                       : identity === fleetController.inspectedIdentity ? "#0f253a"
                                                       : "transparent"
                                                border.width: 0

                                                Rectangle {
                                                    anchors.left: parent.left
                                                    anchors.right: parent.right
                                                    anchors.bottom: parent.bottom
                                                    height: 1
                                                    color: theme.border
                                                }

                                                MouseArea {
                                                    anchors.fill: parent
                                                    onClicked: fleetController.inspectDevice(identity)
                                                }

                                                AppCheckBox {
                                                    anchors.centerIn: parent
                                                    visible: columnKey === "selected"
                                                    checked: selected
                                                    text: ""
                                                    z: 2
                                                    onClicked: {
                                                        fleetController.toggleSelection(identity)
                                                        fleetController.inspectDevice(identity)
                                                    }
                                                }

                                                StatusBadge {
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    x: mainScreen.fleetColumnAlignment(columnKey) === Text.AlignRight
                                                       ? Math.max(8, parent.width - width - 8)
                                                       : (parent.width - width) / 2
                                                    visible: columnKey === "activation_status"
                                                             || columnKey === "online"
                                                             || (fcSysIdMismatch
                                                                 && (columnKey === "mavlink_sys_id"
                                                                     || columnKey === "fc_sys_id"))
                                                    status: columnKey === "online" ? (online ? "online" : "offline")
                                                            : columnKey === "activation_status" ? activationStatus
                                                            : String(display)
                                                    critical: fcSysIdMismatch
                                                              && (columnKey === "mavlink_sys_id"
                                                                  || columnKey === "fc_sys_id")
                                                }

                                                Item {
                                                    anchors.fill: parent
                                                    anchors.margins: 7
                                                    visible: columnKey === "operation"

                                                    Rectangle {
                                                        anchors.left: parent.left
                                                        anchors.right: parent.right
                                                        anchors.bottom: parent.bottom
                                                        height: 5
                                                        radius: 3
                                                        color: theme.border

                                                        Rectangle {
                                                            height: parent.height
                                                            width: parent.width * Math.max(0, Math.min(100, operationProgress)) / 100
                                                            radius: parent.radius
                                                            color: operation.indexOf("fail") >= 0 ? theme.error : theme.accent
                                                        }
                                                    }
                                                }

                                                Text {
                                                    anchors.fill: parent
                                                    anchors.leftMargin: 8
                                                    anchors.rightMargin: 8
                                                    visible: columnKey !== "selected"
                                                             && columnKey !== "activation_status"
                                                             && columnKey !== "online"
                                                             && columnKey !== "operation_progress"
                                                             && !(fcSysIdMismatch
                                                                  && (columnKey === "mavlink_sys_id"
                                                                      || columnKey === "fc_sys_id"))
                                                    text: String(display)
                                                    color: columnKey === "rssi" || columnKey.indexOf("ap_") === 0 ? "white"
                                                         : dlseParameterWarning(columnKey, display) ? theme.warning
                                                         : theme.primaryText
                                                    font.family: theme.dataFont
                                                    font.pixelSize: theme.smallTextSize
                                                    verticalAlignment: Text.AlignVCenter
                                                    horizontalAlignment: mainScreen.fleetColumnAlignment(columnKey)
                                                    elide: Text.ElideRight
                                                }
                                            }
                                        }

                                        Connections {
                                            target: fleetController

                                            function onColumnsChanged() {
                                                tableView.forceLayout()
                                                tableHeader.forceLayout()
                                            }
                                        }
                                    }
                                }

                                GridView {
                                    id: matrixView
                                    objectName: "fleetMatrix"
                                    clip: true
                                    model: fleetCardModel
                                    cellWidth: Math.max(72, width / Math.max(1, Math.floor(width / 78)))
                                    cellHeight: 48
                                    ScrollBar.vertical: ScrollBar {}

                                    delegate: Rectangle {
                                        required property string identity
                                        required property string hostname
                                        required property string ip
                                        required property string activationStatus
                                        required property string mavlinkSysId
                                        required property string wifiSsid
                                        required property string rssi
                                        required property bool online
                                        required property bool selected
                                        required property string operation
                                        required property int operationProgress
                                        readonly property string compactIp: {
                                            var parts = ip.split(".")
                                            return parts.length === 4 ? parts[2] + "." + parts[3] : (ip || "-")
                                        }

                                        width: matrixView.cellWidth - 4
                                        height: matrixView.cellHeight - 4
                                        x: 2
                                        y: 2
                                        radius: 4
                                        color: selected ? theme.raised : theme.background
                                        border.color: selected ? theme.accent : theme.border
                                        border.width: selected ? 2 : 1
                                        ToolTip.visible: cardMouse.containsMouse
                                        ToolTip.delay: 250
                                        ToolTip.text: "Hostname: " + (hostname || "-")
                                                      + "\nRSSI: " + (rssi ? rssi + " dBm" : "-")
                                                      + "\nOnline Status: " + (online ? "Online" : "Offline")
                                                      + "\nActivation Status: " + (activationStatus || "-")
                                                      + "\nAP SSID: " + (wifiSsid || "-")
                                                      + "\nFull IP: " + (ip || "-")

                                        MouseArea {
                                            id: cardMouse
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            onClicked: fleetController.inspectDevice(identity)
                                        }

                                        ColumnLayout {
                                            anchors.fill: parent
                                            anchors.margins: 4
                                            spacing: 0

                                            Text {
                                                Layout.fillWidth: true
                                                Layout.fillHeight: true
                                                text: mavlinkSysId || "-"
                                                color: theme.primaryText
                                                font.family: theme.dataFont
                                                font.pixelSize: theme.headingTextSize
                                                font.bold: true
                                                verticalAlignment: Text.AlignVCenter
                                                horizontalAlignment: Text.AlignHCenter
                                                elide: Text.ElideRight
                                            }

                                            Text {
                                                Layout.fillWidth: true
                                                Layout.fillHeight: true
                                                text: compactIp
                                                color: theme.secondaryText
                                                font.family: theme.dataFont
                                                font.pixelSize: theme.bodyTextSize
                                                font.bold: true
                                                verticalAlignment: Text.AlignVCenter
                                                horizontalAlignment: Text.AlignHCenter
                                                elide: Text.ElideRight
                                            }
                                        }
                                    }
                                }
                            }

                            Column {
                                anchors.centerIn: parent
                                visible: fleetController.visibleCount === 0
                                spacing: 8

                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: fleetController.scanning ? "Scanning for DLSE devices..." : "No devices detected"
                                    color: theme.primaryText
                                    font.family: theme.bodyFont
                                    font.pixelSize: theme.headingTextSize
                                    font.bold: true
                                }

                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: fleetController.scanning
                                          ? "Results appear incrementally as discovery completes."
                                          : "Start scanning or adjust the discovery settings."
                                    color: theme.secondaryText
                                    font.family: theme.bodyFont
                                    font.pixelSize: theme.bodyTextSize
                                }
                            }
                        }
                    }
                }

                Item {
                    id: inspectorShell
                    objectName: "inspectorShell"
                    Layout.fillHeight: true
                    Layout.minimumWidth: 0
                    Layout.preferredWidth: inspectorExpanded ? fleetController.inspectorWidth : 0
                    Layout.maximumWidth: inspectorExpanded ? fleetController.inspectorWidth : 0
                    visible: inspectorExpanded

                    property real resizeStartX: 0
                    property int resizeStartWidth: 0

                    Config {
                        anchors.fill: parent
                        radius: 6
                        clip: true
                        onCollapseRequested: inspectorExpanded = false
                        onExportRequested: fleetDialogs.openExportCsv()
                        onImportRequested: fleetDialogs.openImportCsv()
                        onApplyRequested: fleetDialogs.openApplySettings()
                    }

                    MouseArea {
                        id: inspectorResizeHandle
                        objectName: "inspectorResizeHandle"
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: 10
                        hoverEnabled: true
                        preventStealing: true
                        cursorShape: Qt.SplitHCursor
                        z: 4

                        onPressed: function(mouse) {
                            mouse.accepted = true
                            mainScreen.resizingInspector = true
                            const point = inspectorResizeHandle.mapToItem(mainScreen, mouse.x, mouse.y)
                            inspectorShell.resizeStartX = point.x
                            inspectorShell.resizeStartWidth = fleetController.inspectorWidth
                        }

                        onPositionChanged: function(mouse) {
                            if (!pressed)
                                return
                            const point = inspectorResizeHandle.mapToItem(mainScreen, mouse.x, mouse.y)
                            fleetController.setInspectorWidth(
                                inspectorShell.resizeStartWidth
                                    - Math.round(point.x - inspectorShell.resizeStartX)
                            )
                        }

                        onReleased: mainScreen.resizingInspector = false
                        onCanceled: mainScreen.resizingInspector = false
                        onDoubleClicked: fleetController.resetInspectorWidth()

                        Rectangle {
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            width: 2
                            color: inspectorResizeHandle.pressed || inspectorResizeHandle.containsMouse
                                   ? theme.accent : "transparent"
                        }
                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.preferredWidth: inspectorExpanded ? 0 : 30
                    visible: !inspectorExpanded
                    color: theme.panel
                    border.color: theme.border

                    ToolButton {
                        id: expandInspectorButton
                        anchors.fill: parent
                        text: "‹"
                        onClicked: inspectorExpanded = true
                        contentItem: Text {
                            text: expandInspectorButton.text
                            color: theme.secondaryText
                            font.pixelSize: theme.iconGlyphSize
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignTop
                            topPadding: 8
                        }
                        background: Rectangle { color: expandInspectorButton.hovered ? theme.hover : "transparent" }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 28
            color: theme.panel

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                spacing: 10

                Text {
                    Layout.minimumWidth: 0
                    Layout.maximumWidth: implicitWidth
                    Layout.fillWidth: true
                    clip: true
                    elide: Text.ElideRight
                    objectName: "generalFooterStatus"
                    text: mainScreen.footerText(
                              "DETECTED DRONES:",
                              fleetController.detectedCount,
                              theme.primaryText)
                    textFormat: Text.StyledText
                    color: theme.primaryText
                    font.family: theme.dataFont
                    font.pixelSize: theme.smallTextSize
                }

                Rectangle { Layout.preferredWidth: 1; Layout.fillHeight: true; color: theme.border }

                Text {
                    Layout.minimumWidth: 0
                    Layout.maximumWidth: implicitWidth
                    Layout.fillWidth: true
                    clip: true
                    elide: Text.ElideRight
                    objectName: "offlineFooterStatus"
                    text: mainScreen.footerText(
                              "OFFLINE:",
                              fleetController.offlineCount,
                              fleetController.offlineCount === 0 ? theme.success : theme.accent)
                    textFormat: Text.StyledText
                    color: theme.primaryText
                    font.family: theme.dataFont
                    font.pixelSize: theme.smallTextSize
                    MouseArea {
                        id: offlineHover
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.NoButton
                    }
                    SettingToolTip {
                        anchorItem: offlineHover
                        y: -height - 4
                        visible: offlineHover.containsMouse
                        delay: 500
                        text: "Offline means the devices could not be reached within the timeouts configured in Settings."
                    }
                }

                Rectangle { Layout.preferredWidth: 1; Layout.fillHeight: true; color: theme.border }

                Text {
                    Layout.minimumWidth: 0
                    Layout.maximumWidth: implicitWidth
                    Layout.fillWidth: true
                    clip: true
                    elide: Text.ElideRight
                    objectName: "licenseFooterStatus"
                    text: mainScreen.footerText(
                              "SELECTED:",
                              fleetController.selectedCount,
                              theme.primaryText)
                    textFormat: Text.StyledText
                    color: theme.primaryText
                    font.family: theme.dataFont
                    font.pixelSize: theme.smallTextSize
                }

                Rectangle { Layout.preferredWidth: 1; Layout.fillHeight: true; color: theme.border }

                Text {
                    Layout.minimumWidth: 0
                    Layout.maximumWidth: implicitWidth
                    Layout.fillWidth: true
                    clip: true
                    elide: Text.ElideRight
                    id: activityFooter
                    objectName: "activityFooterStatus"
                    text: mainScreen.footerText("ACTIVITY:", mainScreen.activityLabel, mainScreen.activityColor)
                    textFormat: Text.StyledText
                    color: theme.primaryText
                    font.family: theme.dataFont
                    font.pixelSize: theme.smallTextSize

                    MouseArea {
                        id: activityHover
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.NoButton
                    }
                    SettingToolTip {
                        anchorItem: activityHover
                        y: -height - 4
                        visible: activityHover.containsMouse
                        delay: 500
                        text: mainScreen.activityTooltip()
                    }
                }

                Rectangle { Layout.preferredWidth: 1; Layout.fillHeight: true; color: theme.border }

                Text {
                    Layout.minimumWidth: 0
                    Layout.maximumWidth: implicitWidth
                    Layout.fillWidth: true
                    clip: true
                    elide: Text.ElideRight
                    objectName: "statsPollingFooterStatus"
                    text: mainScreen.footerText(
                              "STATS:",
                              fleetController.statsPollingStatus,
                              mainScreen.processStatusColor(
                                  fleetController.statsPollingStatus))
                    textFormat: Text.StyledText
                    color: theme.primaryText
                    font.family: theme.dataFont
                    font.pixelSize: theme.smallTextSize
                }

                Item { Layout.fillWidth: true }

                Text {
                    Layout.minimumWidth: 0
                    Layout.maximumWidth: implicitWidth
                    Layout.fillWidth: true
                    clip: true
                    elide: Text.ElideRight
                    objectName: "unifiFooterStatus"
                    text: mainScreen.footerText(
                              "UNIFI:",
                              fleetController.unifiStatus,
                              fleetController.unifiStatus === "ONLINE" ? theme.success
                              : fleetController.unifiStatus === "OFFLINE"
                                || fleetController.unifiStatus === "ERROR" ? theme.error
                              : fleetController.unifiStatus === "CHECKING" ? theme.accent
                              : theme.secondaryText)
                    textFormat: Text.StyledText
                    color: theme.primaryText
                    font.family: theme.dataFont
                    font.pixelSize: theme.smallTextSize
                }

                Rectangle { Layout.preferredWidth: 1; Layout.fillHeight: true; color: theme.border }

                Text {
                    Layout.minimumWidth: 0
                    Layout.maximumWidth: implicitWidth
                    Layout.fillWidth: true
                    clip: true
                    elide: Text.ElideRight
                    objectName: "licenseServerFooterStatus"
                    text: mainScreen.footerText(
                              "LICENSE SERVER STATUS:",
                              fleetController.licenseStatus.toUpperCase(),
                              fleetController.licenseStatus === "online" ? theme.success
                              : fleetController.licenseStatus === "offline" ? theme.error
                              : theme.primaryText)
                    textFormat: Text.StyledText
                    color: theme.primaryText
                    font.family: theme.dataFont
                    font.pixelSize: theme.smallTextSize
                }
            }
        }
    }

    FleetDialogs {
        id: fleetDialogs
        formatColumnTitle: mainScreen.formatFleetHeader
        anchors.fill: parent
        z: 100
    }
}

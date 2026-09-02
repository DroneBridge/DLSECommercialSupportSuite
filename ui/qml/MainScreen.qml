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

    function dlseParameterWarning(columnKey, display) {
        const value = String(display).trim()
        if (columnKey === "power_mgmt")
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

                Item {
                    Layout.leftMargin: 12
                    Layout.preferredWidth: 136
                    Layout.fillHeight: true

                    Image {
                        anchors.centerIn: parent
                        width: 122
                        height: 32
                        source: Qt.resolvedUrl("assets/droneBridgeLogo_1.png")
                        fillMode: Image.PreserveAspectFit
                        sourceSize.width: 122
                        sourceSize.height: 32
                    }
                }

                FocusScope {
                    id: standaloneModeButton
                    objectName: "standaloneModeButton"
                    Layout.preferredWidth: 126
                    Layout.preferredHeight: 30
                    activeFocusOnTab: true

                    Rectangle {
                        anchors.fill: parent
                        radius: 5
                        color: standaloneModeMouse.containsMouse || standaloneModeButton.activeFocus
                               ? theme.hover : "#35322e"

                        Text {
                            anchors.centerIn: parent
                            text: "STANDALONE MODE"
                            color: theme.accent
                            font.family: theme.bodyFont
                            font.pixelSize: theme.smallTextSize
                            font.bold: true
                        }
                    }

                    MouseArea {
                        id: standaloneModeMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onPressed: standaloneModeButton.forceActiveFocus()
                        onClicked: mainScreen.backRequested()
                    }

                    Keys.onSpacePressed: mainScreen.backRequested()
                    Keys.onReturnPressed: mainScreen.backRequested()
                    Keys.onEnterPressed: mainScreen.backRequested()
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
                    Layout.preferredWidth: 190
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

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 64
            color: theme.panel
            border.color: theme.border
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 13
                anchors.rightMargin: 13
                spacing: 10

                Row {
                    Layout.preferredWidth: 190
                    Layout.preferredHeight: 30
                    spacing: 0

                    FocusScope {
                        id: scanButtonFocus
                        width: 154
                        height: 30
                        activeFocusOnTab: true

                        Scan_Button {
                            id: scanButton
                            objectName: "scanButton"
                            anchors.fill: parent
                            labelText: fleetController.scanning ? "Scanning ..." : "Scan for Devices"
                            eigenschaft_2: fleetController.scanning || scanButtonMouse.pressed
                                           ? Scan_Button.Eigenschaft_1.Eigenschaft_1_Variante3
                                           : (scanButtonMouse.containsMouse || scanButtonFocus.activeFocus
                                              ? Scan_Button.Eigenschaft_1.Eigenschaft_1_Variante2
                                              : Scan_Button.Eigenschaft_1.Eigenschaft_1_Standard)
                        }

                        MouseArea {
                            id: scanButtonMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onPressed: scanButtonFocus.forceActiveFocus()
                            onClicked: fleetController.toggleScanning()
                        }

                        Keys.onSpacePressed: fleetController.toggleScanning()
                        Keys.onReturnPressed: fleetController.toggleScanning()
                        Keys.onEnterPressed: fleetController.toggleScanning()
                    }

                    FocusScope {
                        id: scanSettingsFocus
                        width: 36
                        height: 30
                        activeFocusOnTab: true

                        ScanSettingsButton {
                            id: scanSettingsButton
                            objectName: "scanSettingsButton"
                            anchors.fill: parent
                            eigenschaft_2: scanSettingsMouse.pressed
                                           ? ScanSettingsButton.Eigenschaft_1.Eigenschaft_1_Variante3
                                           : (scanSettingsMouse.containsMouse || scanSettingsFocus.activeFocus
                                              ? ScanSettingsButton.Eigenschaft_1.Eigenschaft_1_Variante2
                                              : ScanSettingsButton.Eigenschaft_1.Eigenschaft_1_Standard)
                        }

                        MouseArea {
                            id: scanSettingsMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onPressed: scanSettingsFocus.forceActiveFocus()
                            onClicked: fleetDialogs.openScanSettings()
                        }

                        Keys.onSpacePressed: fleetDialogs.openScanSettings()
                        Keys.onReturnPressed: fleetDialogs.openScanSettings()
                        Keys.onEnterPressed: fleetDialogs.openScanSettings()
                    }
                }

                AppButton {
                    text: "Clear Fleet"
                    enabled: fleetController.detectedCount > 0
                    quiet: true
                    onClicked: fleetDialogs.openClearFleet()
                }

                Item { Layout.fillWidth: true }

                FocusScope {
                    id: rebootButtonFocus
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 29
                    activeFocusOnTab: enabled
                    enabled: fleetController.detectedCount > 0 && fleetController.activeOperation.length === 0
                    opacity: enabled ? 1 : 0.42

                    OTA_Button_1 {
                        id: rebootButton
                        objectName: "rebootButton"
                        anchors.fill: parent
                        text_LabelText: "Reboot Devices"
                        text_LabelWidth: 100
                        keyIconVisible: false
                        eigenschaft_2: rebootMouse.pressed
                                       ? OTA_Button_1.Eigenschaft_1.Eigenschaft_1_Variante3
                                       : (rebootMouse.containsMouse || rebootButtonFocus.activeFocus
                                          ? OTA_Button_1.Eigenschaft_1.Eigenschaft_1_Variante2
                                          : OTA_Button_1.Eigenschaft_1.Eigenschaft_1_Standard)
                    }

                    Restart_alt_24dp_1 {
                        x: 9
                        y: 2.5
                    }

                    MouseArea {
                        id: rebootMouse
                        anchors.fill: parent
                        enabled: rebootButtonFocus.enabled
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onPressed: rebootButtonFocus.forceActiveFocus()
                        onClicked: fleetDialogs.openReboot()
                    }

                    Keys.onSpacePressed: if (enabled) fleetDialogs.openReboot()
                    Keys.onReturnPressed: if (enabled) fleetDialogs.openReboot()
                    Keys.onEnterPressed: if (enabled) fleetDialogs.openReboot()
                }

                FocusScope {
                    id: assignStaticIpButtonFocus
                    Layout.preferredWidth: 170
                    Layout.preferredHeight: 29
                    activeFocusOnTab: enabled
                    enabled: fleetController.eligibleStaticIpCount > 0
                             && fleetController.activeOperation.length === 0
                    opacity: enabled ? 1 : 0.42

                    OTA_Button_1 {
                        id: assignStaticIpButton
                        objectName: "assignStaticIpButton"
                        anchors.fill: parent
                        text_LabelText: "Assign Static IPs"
                        text_LabelWidth: 130
                        keyIconVisible: false
                        eigenschaft_2: assignStaticIpMouse.pressed
                                       ? OTA_Button_1.Eigenschaft_1.Eigenschaft_1_Variante3
                                       : (assignStaticIpMouse.containsMouse || assignStaticIpButtonFocus.activeFocus
                                          ? OTA_Button_1.Eigenschaft_1.Eigenschaft_1_Variante2
                                          : OTA_Button_1.Eigenschaft_1.Eigenschaft_1_Standard)
                    }

                    Format_list_numbered_24dp_1 {
                        x: 9
                        y: 2.5
                    }

                    MouseArea {
                        id: assignStaticIpMouse
                        anchors.fill: parent
                        enabled: assignStaticIpButtonFocus.enabled
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onPressed: assignStaticIpButtonFocus.forceActiveFocus()
                        onClicked: fleetDialogs.openStaticIpAssignment()
                    }

                    Keys.onSpacePressed: if (enabled) fleetDialogs.openStaticIpAssignment()
                    Keys.onReturnPressed: if (enabled) fleetDialogs.openStaticIpAssignment()
                    Keys.onEnterPressed: if (enabled) fleetDialogs.openStaticIpAssignment()
                }

                FocusScope {
                    id: alignSysIdsButtonFocus
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 29
                    activeFocusOnTab: enabled
                    enabled: fleetController.selectedCount > 0 && fleetController.activeOperation.length === 0
                    opacity: enabled ? 1 : 0.42

                    OTA_Button_1 {
                        id: alignSysIdsButton
                        objectName: "alignSysIdsButton"
                        anchors.fill: parent
                        text_LabelText: "Align SYS IDs"
                        text_LabelWidth: 100
                        keyIconVisible: false
                        eigenschaft_2: alignSysIdsMouse.pressed
                                       ? OTA_Button_1.Eigenschaft_1.Eigenschaft_1_Variante3
                                       : (alignSysIdsMouse.containsMouse || alignSysIdsButtonFocus.activeFocus
                                          ? OTA_Button_1.Eigenschaft_1.Eigenschaft_1_Variante2
                                          : OTA_Button_1.Eigenschaft_1.Eigenschaft_1_Standard)
                    }

                    Sync_alt {
                        x: 9
                        y: 2.5
                    }

                    MouseArea {
                        id: alignSysIdsMouse
                        anchors.fill: parent
                        enabled: alignSysIdsButtonFocus.enabled
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onPressed: alignSysIdsButtonFocus.forceActiveFocus()
                        onClicked: fleetDialogs.openAlignSysIds()
                    }

                    Keys.onSpacePressed: if (enabled) fleetDialogs.openAlignSysIds()
                    Keys.onReturnPressed: if (enabled) fleetDialogs.openAlignSysIds()
                    Keys.onEnterPressed: if (enabled) fleetDialogs.openAlignSysIds()
                }

                FocusScope {
                    id: otaFirmwareButtonFocus
                    Layout.preferredWidth: 208
                    Layout.preferredHeight: 29
                    activeFocusOnTab: enabled
                    enabled: fleetController.detectedCount > 0 && fleetController.activeOperation.length === 0
                    opacity: enabled ? 1 : 0.42

                    OTA_Button_1 {
                        id: otaFirmwareButton
                        objectName: "otaFirmwareButton"
                        anchors.fill: parent
                        text_LabelText: "OTA Firmware Upgrade"
                        text_LabelWidth: 158
                        keyIconVisible: false
                        eigenschaft_2: otaFirmwareMouse.pressed
                                       ? OTA_Button_1.Eigenschaft_1.Eigenschaft_1_Variante3
                                       : (otaFirmwareMouse.containsMouse || otaFirmwareButtonFocus.activeFocus
                                          ? OTA_Button_1.Eigenschaft_1.Eigenschaft_1_Variante2
                                          : OTA_Button_1.Eigenschaft_1.Eigenschaft_1_Standard)
                    }

                    Computer_arrow_up_24dp_1 {
                        x: 9
                        y: 2.5
                    }

                    MouseArea {
                        id: otaFirmwareMouse
                        anchors.fill: parent
                        enabled: otaFirmwareButtonFocus.enabled
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onPressed: otaFirmwareButtonFocus.forceActiveFocus()
                        onClicked: fleetDialogs.openOta()
                    }

                    Keys.onSpacePressed: if (enabled) fleetDialogs.openOta()
                    Keys.onReturnPressed: if (enabled) fleetDialogs.openOta()
                    Keys.onEnterPressed: if (enabled) fleetDialogs.openOta()
                }

                FocusScope {
                    id: otaActivationButtonFocus
                    Layout.preferredWidth: 190
                    Layout.preferredHeight: 29
                    activeFocusOnTab: enabled
                    enabled: fleetController.detectedCount > 0 && fleetController.activeOperation.length === 0
                    opacity: enabled ? 1 : 0.42

                    OTA_Button_1 {
                        id: otaActivationButton
                        objectName: "otaActivationButton"
                        anchors.fill: parent
                        text_LabelText: "OTA DLSE Activation"
                        text_LabelWidth: 140
                        keyIconVisible: false
                        eigenschaft_2: otaActivationMouse.pressed
                                       ? OTA_Button_1.Eigenschaft_1.Eigenschaft_1_Variante3
                                       : (otaActivationMouse.containsMouse || otaActivationButtonFocus.activeFocus
                                          ? OTA_Button_1.Eigenschaft_1.Eigenschaft_1_Variante2
                                          : OTA_Button_1.Eigenschaft_1.Eigenschaft_1_Standard)
                    }

                    Key_24dp_1 {
                        x: 9
                        y: 2.5
                    }

                    MouseArea {
                        id: otaActivationMouse
                        anchors.fill: parent
                        enabled: otaActivationButtonFocus.enabled
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onPressed: otaActivationButtonFocus.forceActiveFocus()
                        onClicked: fleetDialogs.openActivation()
                    }

                    Keys.onSpacePressed: if (enabled) fleetDialogs.openActivation()
                    Keys.onReturnPressed: if (enabled) fleetDialogs.openActivation()
                    Keys.onEnterPressed: if (enabled) fleetDialogs.openActivation()
                }

                FocusScope {
                    id: applySettingsButtonFocus
                    Layout.preferredWidth: 158
                    Layout.preferredHeight: 29
                    activeFocusOnTab: enabled
                    enabled: fleetController.selectedCount > 0 && fleetController.activeOperation.length === 0
                    opacity: enabled ? 1 : 0.42

                    OTA_Button_1 {
                        id: applySettingsButton
                        objectName: "applySettingsButton"
                        anchors.fill: parent
                        text_LabelText: "Apply Settings"
                        text_LabelWidth: 108
                        keyIconVisible: false
                        eigenschaft_2: applySettingsMouse.pressed
                                       ? OTA_Button_1.Eigenschaft_1.Eigenschaft_1_Variante3
                                       : (applySettingsMouse.containsMouse || applySettingsButtonFocus.activeFocus
                                          ? OTA_Button_1.Eigenschaft_1.Eigenschaft_1_Variante2
                                          : OTA_Button_1.Eigenschaft_1.Eigenschaft_1_Standard)
                    }

                    Upload_file_24dp_1 {
                        x: 9
                        y: 2.5
                    }

                    MouseArea {
                        id: applySettingsMouse
                        anchors.fill: parent
                        enabled: applySettingsButtonFocus.enabled
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onPressed: applySettingsButtonFocus.forceActiveFocus()
                        onClicked: fleetDialogs.openApplyCsvToSelected()
                    }

                    Keys.onSpacePressed: if (enabled) fleetDialogs.openApplyCsvToSelected()
                    Keys.onReturnPressed: if (enabled) fleetDialogs.openApplyCsvToSelected()
                    Keys.onEnterPressed: if (enabled) fleetDialogs.openApplyCsvToSelected()
                }

                AppButton {
                    visible: fleetController.canCancel
                    text: "Cancel Queued"
                    accentColor: theme.warning
                    emphasized: true
                    onClicked: fleetController.cancelActiveOperation()
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            color: theme.background

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 9
                anchors.rightMargin: 9
                spacing: 14

                AppCheckBox {
                    text: "SELECT ALL"
                    onClicked: fleetController.selectAll(checked)
                }

                AppCheckBox {
                    text: "SELECT VISIBLE"
                    onClicked: fleetController.selectVisible(checked)
                }

                Item { Layout.fillWidth: true }

                AppButton {
                    text: "CONFIGURE COLUMNS"
                    quiet: true
                    onClicked: fleetDialogs.openColumns()
                }

                Item { Layout.fillWidth: true }

                ControlsSwitch {
                    id: viewModeSwitch
                    objectName: "viewModeSwitch"
                    Layout.preferredWidth: 128
                    Layout.preferredHeight: 24
                    checked: viewMode === 1
                    onClicked: viewMode = checked ? 1 : 0
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

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

                                    required property var display
                                    required property int index
                                    property real resizeStartX: 0
                                    property int resizeStartWidth: 0

                                    implicitWidth: fleetController.columnWidth(index)
                                    implicitHeight: 37
                                    color: theme.panel
                                    border.width: 0

                                    Text {
                                        anchors.fill: parent
                                        anchors.leftMargin: 6
                                        anchors.rightMargin: 12
                                        text: display + (mainScreen.sortColumn === index
                                                         ? (mainScreen.sortAscending ? "  ↑" : "  ↓") : "")
                                        color: theme.secondaryText
                                        font.family: theme.dataFont
                                        font.pixelSize: theme.smallTextSize
                                        font.bold: true
                                        horizontalAlignment: Text.AlignHCenter
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
                                           : theme.background
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
                                        anchors.centerIn: parent
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
                                        visible: columnKey === "operation_progress"

                                        Rectangle {
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            anchors.verticalCenter: parent.verticalCenter
                                            height: 7
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
                                        color: columnKey === "rssi" ? "white"
                                             : dlseParameterWarning(columnKey, display) ? theme.warning
                                             : theme.primaryText
                                        font.family: "JetBrains Mono"
                                        font.pixelSize: theme.smallTextSize
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: columnKey === "hostname"
                                                             || columnKey === "activation_key"
                                                             || columnKey === "operation"
                                                             ? Text.AlignLeft : Text.AlignHCenter
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
                            color: selected ? theme.raised : theme.panel
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

            Item {
                id: inspectorShell
                objectName: "inspectorShell"
                Layout.fillHeight: true
                Layout.preferredWidth: inspectorExpanded ? fleetController.inspectorWidth : 0
                visible: inspectorExpanded

                property real resizeStartX: 0
                property int resizeStartWidth: 0

                Config {
                    anchors.fill: parent
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
                    objectName: "generalFooterStatus"
                    text: mainScreen.footerText(
                              "DETECTED DRONES:",
                              fleetController.detectedCount,
                              theme.primaryText)
                    textFormat: Text.StyledText
                    color: theme.primaryText
                    font.family: theme.dataFont
                    font.pixelSize: theme.smallTextSize
                    font.bold: true
                }

                Rectangle { Layout.preferredWidth: 1; Layout.fillHeight: true; color: theme.border }

                Text {
                    objectName: "licenseFooterStatus"
                    text: mainScreen.footerText(
                              "SELECTED:",
                              fleetController.selectedCount,
                              theme.primaryText)
                    textFormat: Text.StyledText
                    color: theme.primaryText
                    font.family: theme.dataFont
                    font.pixelSize: theme.smallTextSize
                    font.bold: true
                }

                Rectangle { Layout.preferredWidth: 1; Layout.fillHeight: true; color: theme.border }

                Text {
                    objectName: "discoveryFooterStatus"
                    text: mainScreen.footerText(
                              "DISCOVERY:",
                              fleetController.discoveryStatus,
                              mainScreen.processStatusColor(
                                  fleetController.discoveryStatus))
                    textFormat: Text.StyledText
                    color: theme.primaryText
                    font.family: theme.dataFont
                    font.pixelSize: theme.smallTextSize
                    font.bold: true
                }

                Rectangle { Layout.preferredWidth: 1; Layout.fillHeight: true; color: theme.border }

                Text {
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
                    font.bold: true
                }

                Rectangle { Layout.preferredWidth: 1; Layout.fillHeight: true; color: theme.border }

                Text {
                    text: mainScreen.footerText(
                              "STATUS:",
                              fleetController.statusText,
                              fleetController.statusText.indexOf("ERROR") >= 0
                              ? theme.error : theme.primaryText)
                    textFormat: Text.StyledText
                    color: theme.primaryText
                    font.family: theme.dataFont
                    font.pixelSize: theme.smallTextSize
                    font.bold: true
                }

                Item { Layout.fillWidth: true }

                Text {
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
                    font.bold: true
                }
            }
        }
    }

    FleetDialogs {
        id: fleetDialogs
        anchors.fill: parent
        z: 100
    }
}

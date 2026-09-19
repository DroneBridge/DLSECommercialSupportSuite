import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: config
    objectName: "configPanel"

    signal collapseRequested()
    signal exportRequested()
    signal importRequested()
    signal applyRequested()

    color: theme.panel
    border.color: theme.border
    border.width: 1

    Theme { id: theme }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            color: theme.panel

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                spacing: 6

                ToolButton {
                    id: collapseButton
                    text: ">"
                    onClicked: config.collapseRequested()
                    contentItem: Text {
                        text: collapseButton.text
                        color: theme.secondaryText
                        font.pixelSize: theme.iconGlyphSize
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }
                    background: Rectangle { color: collapseButton.hovered ? theme.hover : "transparent" }
                }

                Text {
                    Layout.fillWidth: true
                    text: fleetController.selectedDevice.ip
                          ? "ESP32 Configuration  " + fleetController.selectedDevice.ip
                          : "ESP32 Configuration"
                    color: theme.secondaryText
                    font.family: theme.bodyFont
                    font.pixelSize: theme.bodyTextSize
                    elide: Text.ElideRight
                }
            }
        }

        TabBar {
            id: tabs
            objectName: "configTabs"
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            background: Rectangle { color: theme.panel }

            Repeater {
                model: ["Settings", "Web-Interface", "Metrics"]
                TabButton {
                    id: tabControl
                    required property string modelData
                    text: modelData
                    contentItem: Text {
                        text: tabControl.text
                        color: tabControl.checked ? theme.primaryText : theme.secondaryText
                        font.family: theme.bodyFont
                        font.pixelSize: theme.bodyTextSize
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        color: tabControl.checked ? Qt.rgba(255 / 255, 142 / 255, 0, 0.04) : "transparent"
                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            height: 3
                            color: tabControl.checked ? theme.accent : "transparent"
                        }
                    }
                }
            }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: tabs.currentIndex

            Item {
                Text {
                    id: settingsEmptyState
                    objectName: "settingsEmptyState"
                    anchors.centerIn: parent
                    width: parent.width - 40
                    visible: fleetController.settingsFields.length === 0
                    text: "Select a detected ESP32 to inspect and edit its settings."
                    color: theme.secondaryText
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.Wrap
                    font.family: theme.bodyFont
                    font.pixelSize: theme.bodyTextSize
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 32
                        visible: fleetController.settingsFields.length > 0
                        color: theme.background

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8
                            spacing: 12

                            Text {
                                Layout.preferredWidth: Math.max(148, parent.width * 0.42)
                                text: "PARAMETER"
                                color: theme.secondaryText
                                font.family: theme.dataFont
                                font.pixelSize: theme.smallTextSize
                                font.bold: true
                                verticalAlignment: Text.AlignVCenter
                            }

                            Text {
                                Layout.fillWidth: true
                                text: "VALUE"
                                color: theme.secondaryText
                                font.family: theme.dataFont
                                font.pixelSize: theme.smallTextSize
                                font.bold: true
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }

                    ListView {
                        id: settingsTable
                        objectName: "settingsTable"
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        visible: fleetController.settingsFields.length > 0
                        clip: true
                        model: fleetController.settingsFields
                        ScrollBar.vertical: ScrollBar {}

                        delegate: Rectangle {
                            required property var modelData
                            width: settingsTable.width
                            height: 38
                            color: modelData.dirty ? Qt.rgba(255 / 255, 142 / 255, 0, 0.05) : "transparent"
                            border.width: 0

                            Rectangle {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                height: 1
                                color: modelData.dirty ? theme.accent : theme.border
                            }

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                anchors.rightMargin: 8
                                spacing: 12

                                Text {
                                    Layout.preferredWidth: Math.max(148, settingsTable.width * 0.42)
                                    text: modelData.label + (modelData.dirty ? "  *" : "")
                                    color: modelData.dirty ? theme.accent : theme.secondaryText
                                    font.family: theme.dataFont
                                    font.pixelSize: theme.smallTextSize
                                    verticalAlignment: Text.AlignVCenter
                                    elide: Text.ElideRight
                                }

                                Loader {
                                    id: editorLoader
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 30
                                    sourceComponent: modelData.editor === "boolean" ? booleanEditor : textEditor
                                }
                            }

                            Component {
                                id: booleanEditor
                                AppCheckBox {
                                    text: checked ? "Enabled" : "Disabled"
                                    checked: Boolean(modelData.value)
                                    onClicked: fleetController.setSettingValue(modelData.key, checked)
                                }
                            }

                            Component {
                                id: textEditor
                                AppTextField {
                                    text: String(modelData.value)
                                    echoMode: TextInput.Normal
                                    inputMethodHints: modelData.editor === "integer" || modelData.editor === "port"
                                                      ? Qt.ImhDigitsOnly : Qt.ImhNone
                                    onEditingFinished: fleetController.setSettingValue(modelData.key, text)
                                }
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        visible: fleetController.settingsFields.length === 0
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        AppButton {
                            Layout.fillWidth: true
                            text: "Import CSV"
                            enabled: fleetController.detectedCount > 0
                            onClicked: config.importRequested()
                        }

                        AppButton {
                            Layout.fillWidth: true
                            text: "Export CSV"
                            enabled: Boolean(fleetController.selectedDevice.ip)
                            onClicked: config.exportRequested()
                        }
                    }

                    AppButton {
                        objectName: "configApplySettingsButton"
                        Layout.fillWidth: true
                        text: "APPLY CHANGES"
                        emphasized: true
                        enabled: Boolean(fleetController.selectedDevice.ip)
                        onClicked: config.applyRequested()
                    }
                }
            }

            Item {
                Loader {
                    anchors.fill: parent
                    active: tabs.currentIndex === 1 && fleetController.webUrl.length > 0
                    source: active ? "WebPanel.qml" : ""
                }

                Text {
                    anchors.centerIn: parent
                    width: parent.width - 40
                    visible: fleetController.webUrl.length === 0
                    text: "Select an online ESP32 to open its web interface."
                    color: theme.secondaryText
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.Wrap
                    font.family: theme.bodyFont
                    font.pixelSize: theme.bodyTextSize
                }
            }

            Item {
                Text {
                    anchors.centerIn: parent
                    width: parent.width - 40
                    visible: fleetController.inspectedIdentity.length === 0
                    text: "Select a detected ESP32 to inspect its live metrics."
                    color: theme.secondaryText
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.Wrap
                    font.family: theme.bodyFont
                    font.pixelSize: theme.bodyTextSize
                }

                ScrollView {
                    id: metricsScroll
                    objectName: "metricsScroll"
                    anchors.fill: parent
                    visible: fleetController.inspectedIdentity.length > 0
                    clip: true
                    contentWidth: width
                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                    ScrollBar.vertical.policy: ScrollBar.AsNeeded

                    Column {
                        id: metricsCards
                        objectName: "metricsCards"
                        width: metricsScroll.width
                        padding: 12
                        spacing: 10

                        Repeater {
                            objectName: "metricsGroups"
                            model: fleetController.metrics

                            delegate: Rectangle {
                                id: metricCard
                                required property var modelData
                                objectName: "metricCard_" + modelData.id
                                width: metricsCards.width - 24
                                height: metricCardColumn.implicitHeight + 24
                                radius: 5
                                color: theme.background
                                border.color: theme.border
                                border.width: 1

                                ColumnLayout {
                                    id: metricCardColumn
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.top: parent.top
                                    anchors.margins: 12
                                    spacing: 9

                                    Text {
                                        Layout.fillWidth: true
                                        text: metricCard.modelData.title
                                        color: theme.accent
                                        font.family: theme.dataFont
                                        font.pixelSize: theme.smallTextSize
                                        font.bold: true
                                        elide: Text.ElideRight
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 1
                                        color: theme.border
                                    }

                                    GridLayout {
                                        id: metricGrid
                                        Layout.fillWidth: true
                                        columns: 2
                                        columnSpacing: 8
                                        rowSpacing: 8

                                        Repeater {
                                            model: metricCard.modelData.items

                                            delegate: Item {
                                                id: metricItem
                                                required property var modelData
                                                Layout.fillWidth: true
                                                Layout.columnSpan: modelData.wide ? 2 : 1
                                                Layout.preferredWidth: modelData.wide
                                                                       ? metricGrid.width
                                                                       : (metricGrid.width - metricGrid.columnSpacing) / 2
                                                Layout.preferredHeight: metricValue.implicitHeight + 22

                                                function statusColor(tone) {
                                                    if (tone === "success")
                                                        return theme.success
                                                    if (tone === "warning")
                                                        return theme.warning
                                                    if (tone === "error")
                                                        return theme.error
                                                    return theme.secondaryText
                                                }

                                                Column {
                                                    anchors.fill: parent
                                                    anchors.margins: 2
                                                    spacing: 3

                                                    Text {
                                                        width: parent.width
                                                        text: metricItem.modelData.label
                                                        color: theme.secondaryText
                                                        font.family: theme.bodyFont
                                                        font.pixelSize: theme.smallTextSize
                                                        elide: Text.ElideRight
                                                    }

                                                    TextEdit {
                                                        id: metricValue
                                                        width: parent.width
                                                        text: metricItem.modelData.value
                                                        color: metricItem.modelData.tone !== "neutral"
                                                               ? metricItem.statusColor(metricItem.modelData.tone)
                                                               : theme.primaryText
                                                        font.family: theme.dataFont
                                                        font.pixelSize: theme.smallTextSize
                                                        font.bold: metricItem.modelData.kind === "status"
                                                        readOnly: true
                                                        selectByMouse: true
                                                        activeFocusOnTab: false
                                                        selectionColor: theme.accent
                                                        selectedTextColor: theme.background
                                                        clip: true
                                                        wrapMode: metricItem.modelData.wide
                                                                  ? TextEdit.WrapAnywhere
                                                                  : TextEdit.NoWrap
                                                    }
                                                }

                                                ToolTip.visible: metricHover.containsMouse
                                                                 && !metricItem.modelData.wide
                                                ToolTip.text: metricItem.modelData.value
                                                ToolTip.delay: 500

                                                HoverHandler { id: metricHover }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

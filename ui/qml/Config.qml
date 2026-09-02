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
            Layout.preferredHeight: 31
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
                    font.family: theme.dataFont
                    font.pixelSize: theme.smallTextSize
                    elide: Text.ElideRight
                }
            }
        }

        TabBar {
            id: tabs
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            background: Rectangle { color: theme.panel }

            Repeater {
                model: ["SETTINGS", "WEB-INTERFACE", "METRICS"]
                TabButton {
                    id: tabControl
                    required property string modelData
                    text: modelData
                    contentItem: Text {
                        text: tabControl.text
                        color: tabControl.checked ? theme.primaryText : theme.secondaryText
                        font.family: theme.dataFont
                        font.pixelSize: theme.smallTextSize
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
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8

                    Text {
                        Layout.fillWidth: true
                        visible: fleetController.settingsFields.length === 0
                        text: "Select a detected ESP32 to inspect and edit its settings."
                        color: theme.secondaryText
                        wrapMode: Text.Wrap
                        font.family: theme.bodyFont
                        font.pixelSize: theme.bodyTextSize
                    }

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

            ListView {
                id: metricsList
                clip: true
                model: fleetController.metrics
                ScrollBar.vertical: ScrollBar {}

                delegate: Rectangle {
                    required property var modelData
                    required property int index
                    width: metricsList.width
                    height: 42
                    color: index % 2 ? "#091a2a" : theme.background
                    border.color: theme.border
                    border.width: 1

                    Column {
                        anchors.fill: parent
                        anchors.margins: 6
                        spacing: 2

                        Text {
                            text: modelData.group + " / " + modelData.key
                            color: theme.secondaryText
                            font.family: theme.dataFont
                            font.pixelSize: theme.smallTextSize
                            elide: Text.ElideRight
                            width: parent.width
                        }

                        Text {
                            text: modelData.value
                            color: theme.primaryText
                            font.family: theme.dataFont
                            font.pixelSize: theme.smallTextSize
                            elide: Text.ElideRight
                            width: parent.width
                        }
                    }
                }
            }
        }
    }
}

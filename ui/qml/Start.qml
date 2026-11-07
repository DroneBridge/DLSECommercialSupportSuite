import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.VectorImage

Item {
    id: start
    objectName: "startScreen"

    signal directStandaloneRequested()
    signal serialFlasherRequested()

    Theme { id: theme }

    Shape {
        id: background
        anchors.fill: parent

        ShapePath {
            strokeColor: "transparent"
            // Keep the circular glow centered on the top border as the page resizes.
            fillGradient: RadialGradient {
                centerX: background.width / 2
                centerY: 0
                focalX: centerX
                focalY: centerY
                centerRadius: Math.max(1, background.height, background.width / 2)
                GradientStop { position: 0.0; color: "#01457c" }
                GradientStop { position: 1.0; color: "#07101a" }
            }
            startX: 0
            startY: 0
            PathLine { x: background.width; y: 0 }
            PathLine { x: background.width; y: background.height }
            PathLine { x: 0; y: background.height }
            PathLine { x: 0; y: 0 }
        }
    }

    Text {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 16
        text: "DroneBridge DLSE Commercial Support Suite"
        color: theme.text
        font.family: theme.bodyFont
        font.pixelSize: theme.bodyTextSize
    }

    ColumnLayout {
        anchors.centerIn: parent
        width: Math.min(parent.width - 64, 816)
        spacing: 16

        VectorImage {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 245
            Layout.preferredHeight: 66
            source: Qt.resolvedUrl("../resources/images/DroneBridgeLogo_foremost_white.svg")
            fillMode: VectorImage.PreserveAspectFit
            preferredRendererType: VectorImage.CurveRenderer
        }

        Item { Layout.preferredHeight: 20 }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "How to Connect"
            color: "#f0f0f0"
            font.family: theme.bodyFont
            font.pixelSize: theme.headingTextSize
            font.bold: true
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Choose how you want to connect to your drone fleet"
            color: "#f0f0f0"
            font.family: theme.bodyFont
            font.pixelSize: theme.bodyTextSize
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 6
            spacing: 16

            ModeButtonBig {
                objectName: "directStandaloneButton"
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                onClicked: start.directStandaloneRequested()
            }

            ModeButtonBig {
                objectName: "monitoringModeButton"
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                title: "Monitoring Mode"
                description: "Monitor without additional radio traffic.\nPlanned for a future release."
                enabled: false
                opacity: 0.48
            }
        }

        ModeButtonBig {
            objectName: "serialFlasherButton"
            Layout.fillWidth: true
            Layout.preferredHeight: 90
            centerContent: true
            title: "Serial Batch Flasher"
            description: "Install firmware, settings and licenses over USB."
            onClicked: start.serialFlasherRequested()
        }
    }

    Text {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 20
        text: "UniFi is a registered trademark or trademark of Ubiquiti Networks, Inc."
        color: "#ffffff"
        opacity: 0.7
        font.family: theme.bodyFont
        font.pixelSize: theme.smallTextSize
    }
}

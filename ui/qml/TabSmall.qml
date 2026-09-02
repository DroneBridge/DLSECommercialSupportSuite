import QtQuick

Rectangle {
    Theme { id: theme }
    enum Eigenschaft_1 { Eigenschaft_1_Standard, Eigenschaft_1_Variante2, Eigenschaft_1_Variante3}

    id: tabSmall

    property alias settingsText: settings.text
    property alias settingsWidth: settings.width

    property int eigenschaft_2: TabSmall.Eigenschaft_1.Eigenschaft_1_Standard

    height: 40
    width: 108

    color: "#081624"

    states: [
        State {
            name: "Eigenschaft 1=Standard"
            when: tabSmall.eigenschaft_2 === TabSmall.Eigenschaft_1.Eigenschaft_1_Standard
    
            PropertyChanges {
                color: "#081624"
                target: tabSmall
            }
            PropertyChanges {
                source: Qt.resolvedUrl("assets/rectangle_12.png")
                target: rectangle_12
            }
            PropertyChanges {
                x: 0.12
    
                target: settings
            }
            PropertyChanges {
                color: "#deceb9"
                target: settings
            }
        },
        State {
            name: "Eigenschaft 1=Variante3"
            when: tabSmall.eigenschaft_2 === TabSmall.Eigenschaft_1.Eigenschaft_1_Variante3
    
            PropertyChanges {
                color: "transparent"
                target: tabSmall
            }
            PropertyChanges {
                source: Qt.resolvedUrl("assets/rectangle_14.png")
                target: rectangle_12
            }
            PropertyChanges {
                x: 0
    
                target: settings
            }
            PropertyChanges {
                color: "#deceb9"
                target: settings
            }
        },
        State {
            name: "Eigenschaft 1=Variante2"
            when: tabSmall.eigenschaft_2 === TabSmall.Eigenschaft_1.Eigenschaft_1_Variante2
    
            PropertyChanges {
                color: "transparent"
                target: tabSmall
            }
            PropertyChanges {
                source: Qt.resolvedUrl("assets/rectangle_13.png")
                target: rectangle_12
            }
            PropertyChanges {
                x: 0
    
                target: settings
            }
            PropertyChanges {
                color: "#ffffff"
                target: settings
            }
        }
    ]

    Image {
        id: rectangle_12

        source: Qt.resolvedUrl("assets/rectangle_12.png")
    }
    Text {
        id: settings

        x: 0.12
        y: 14

        height: 15
        width: 109

        color: "#deceb9"
        font.capitalization: Font.AllUppercase
        font.family: "JetBrains Mono"
        font.pixelSize: theme.bodyTextSize
        font.weight: Font.Bold
        horizontalAlignment: Text.AlignHCenter
        text: "Settings"
        textFormat: Text.PlainText
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.Wrap
    }
}
import QtQuick
import DesignTokens as Tokens

Rectangle {
    Theme { id: theme }
    enum Eigenschaft_1 { Eigenschaft_1_Standard, Eigenschaft_1_Variante2, Eigenschaft_1_Variante3}

    id: uniFiButton

    property int eigenschaft_2: UniFiButton.Eigenschaft_1.Eigenschaft_1_Standard

    height: 49
    width: 200

    border.color: "#f8ebeb"
    border.width: 1
    color: "#00ffa309"
    radius: Tokens.Collection_1.numbers.radius

    states: [
        State {
            name: "Eigenschaft 1=Standard"
            when: uniFiButton.eigenschaft_2 === UniFiButton.Eigenschaft_1.Eigenschaft_1_Standard
    
            PropertyChanges {
                color: "#00ffa309"
                target: uniFiButton
            }
            PropertyChanges {
                border.color: "#f8ebeb"
                target: uniFiButton
            }
            PropertyChanges {
                color: "#f8ebeb"
                target: unify_Connection_Label
            }
        },
        State {
            name: "Eigenschaft 1=Variante2"
            when: uniFiButton.eigenschaft_2 === UniFiButton.Eigenschaft_1.Eigenschaft_1_Variante2
    
            PropertyChanges {
                color: "#081624"
                target: uniFiButton
            }
            PropertyChanges {
                border.color: "#ffffff"
                target: uniFiButton
            }
            PropertyChanges {
                color: "#ffffff"
                target: unify_Connection_Label
            }
        },
        State {
            name: "Eigenschaft 1=Variante3"
            when: uniFiButton.eigenschaft_2 === UniFiButton.Eigenschaft_1.Eigenschaft_1_Variante3
    
            PropertyChanges {
                color: "#0a1c2e"
                target: uniFiButton
            }
            PropertyChanges {
                border.color: "#ffffff"
                target: uniFiButton
            }
            PropertyChanges {
                color: "#ffffff"
                target: unify_Connection_Label
            }
        }
    ]

    Image {
        id: uniFi_Light_1

        x: 19
        y: 19.50

        source: Qt.resolvedUrl("assets/uniFi_Light_2.png")
    }
    Text {
        id: unify_Connection_Label

        x: 64
        y: 16

        height: 17
        width: 118

        color: "#f8ebeb"
        font.family: theme.bodyFont
        font.pixelSize: theme.bodyTextSize
        font.weight: Font.DemiBold
        horizontalAlignment: Text.AlignLeft
        text: "Add UniFi Gateway"
        textFormat: Text.PlainText
        verticalAlignment: Text.AlignVCenter
    }
}

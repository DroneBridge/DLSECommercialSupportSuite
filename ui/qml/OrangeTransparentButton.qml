import QtQuick
import DesignTokens as Tokens

Rectangle {
    Theme { id: theme }
    enum Eigenschaft_1 { Eigenschaft_1_Eigenschaft4, Eigenschaft_1_Variante2, Eigenschaft_1_Variante3}

    id: orangeTransparentButton

    property alias apply_ChangesText: apply_Changes.text

    property int eigenschaft_2: OrangeTransparentButton.Eigenschaft_1.Eigenschaft_1_Eigenschaft4

    height: 34
    width: 315

    color: "transparent"

    states: [
        State {
            name: "Eigenschaft 1=Eigenschaft4"
            when: orangeTransparentButton.eigenschaft_2 === OrangeTransparentButton.Eigenschaft_1.Eigenschaft_1_Eigenschaft4
    
            PropertyChanges {
                color: "#1affa00a"
                target: rectangle_16
            }
            PropertyChanges {
                border.color: "#ff8e00"
                target: rectangle_16
            }
            PropertyChanges {
                color: "#ff8e00"
                target: apply_Changes
            }
        },
        State {
            name: "Eigenschaft 1=Variante2"
            when: orangeTransparentButton.eigenschaft_2 === OrangeTransparentButton.Eigenschaft_1.Eigenschaft_1_Variante2
    
            PropertyChanges {
                color: "#1ae2d5c8"
                target: rectangle_16
            }
            PropertyChanges {
                border.color: "#e2d5c8"
                target: rectangle_16
            }
            PropertyChanges {
                color: "#e2d5c8"
                target: apply_Changes
            }
        },
        State {
            name: "Eigenschaft 1=Variante3"
            when: orangeTransparentButton.eigenschaft_2 === OrangeTransparentButton.Eigenschaft_1.Eigenschaft_1_Variante3
    
            PropertyChanges {
                color: "#1a34d399"
                target: rectangle_16
            }
            PropertyChanges {
                border.color: "#34d399"
                target: rectangle_16
            }
            PropertyChanges {
                color: "#34d399"
                target: apply_Changes
            }
        }
    ]

    Rectangle {
        id: rectangle_16

        height: 34
        width: 315

        border.color: "#ff8e00"
        border.width: 1
        color: "#1affa00a"
        radius: Tokens.Collection_1.numbers.radius
    }
    Text {
        id: apply_Changes

        x: 100.28
        y: 9

        height: 16
        width: 118

        color: "#ff8e00"
        font.capitalization: Font.AllUppercase
        font.family: theme.bodyFont
        font.pixelSize: theme.bodyTextSize
        font.weight: Font.Bold
        horizontalAlignment: Text.AlignHCenter
        text: "Apply Changes"
        textFormat: Text.PlainText
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.Wrap
    }
}

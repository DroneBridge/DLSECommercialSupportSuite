import QtQuick

Rectangle {
    Theme { id: theme }
    enum Eigenschaft_1 { Eigenschaft_1_Standard, Eigenschaft_1_Variante2, Eigenschaft_1_Variante3}

    id: mainTab

    property int eigenschaft_2: MainTab.Eigenschaft_1.Eigenschaft_1_Standard

    height: 60
    width: 177

    color: "transparent"

    states: [
        State {
            name: "Eigenschaft 1=Standard"
            when: mainTab.eigenschaft_2 === MainTab.Eigenschaft_1.Eigenschaft_1_Standard
    
            PropertyChanges {
                height: 60
    
                target: mainTab
            }
            PropertyChanges {
                height: 60
    
                target: frame_8
            }
            PropertyChanges {
                target: rectangle_19
                visible: false
            }
        },
        State {
            name: "Eigenschaft 1=Variante2"
            when: mainTab.eigenschaft_2 === MainTab.Eigenschaft_1.Eigenschaft_1_Variante2
    
            PropertyChanges {
                height: 63
    
                target: mainTab
            }
            PropertyChanges {
                height: 63
    
                target: frame_8
            }
            PropertyChanges {
                target: rectangle_19
                visible: true
            }
        },
        State {
            name: "Eigenschaft 1=Variante3"
            when: mainTab.eigenschaft_2 === MainTab.Eigenschaft_1.Eigenschaft_1_Variante3
    
            PropertyChanges {
                height: 63
    
                target: mainTab
            }
            PropertyChanges {
                height: 63
    
                target: frame_8
            }
        }
    ]

    Rectangle {
        id: frame_8

        height: 60
        width: 177

        color: "transparent"

        Text {
            id: fleet_Manager

            height: 60
            width: 178

            color: "#e2d5c8"
            font.capitalization: Font.AllUppercase
            font.family: theme.bodyFont
            font.pixelSize: theme.bodyTextSize
            font.weight: Font.Bold
            horizontalAlignment: Text.AlignHCenter
            text: "Fleet Manager"
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignVCenter
        }
        Rectangle {
            id: rectangle_19

            y: 60

            height: 3
            width: 177

            color: "#ff8e00"
        }
    }
}

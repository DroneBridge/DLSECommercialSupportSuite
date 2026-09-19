import QtQuick

Rectangle {
    enum Eigenschaft_1 { Eigenschaft_1_Standard, Eigenschaft_1_Variante2}

    id: frame_10

    property int eigenschaft_2: Frame_10.Eigenschaft_1.Eigenschaft_1_Standard

    height: 63
    width: 47

    color: "transparent"

    states: [
        State {
            name: "Eigenschaft 1=Standard"
            when: frame_10.eigenschaft_2 === Frame_10.Eigenschaft_1.Eigenschaft_1_Standard
    
            PropertyChanges {
                color: "transparent"
                target: frame_10
            }
            PropertyChanges {
                _vector_ShapePath0FillColor: "#deceb9"
                target: settings_24dp_2
            }
        },
        State {
            name: "Eigenschaft 1=Variante2"
            when: frame_10.eigenschaft_2 === Frame_10.Eigenschaft_1.Eigenschaft_1_Variante2
    
            PropertyChanges {
                color: "#081624"
                target: frame_10
            }
            PropertyChanges {
                _vector_ShapePath0FillColor: "#ffa00a"
                target: settings_24dp_2
            }
        }
    ]

    Settings_24dp_1 {
        id: settings_24dp_2

        x: 12
        y: 19.50

        clip: true
    }
}
import QtQuick
import QtQuick.Shapes

Rectangle {
    enum Eigenschaft_1 { Eigenschaft_1_Standard, Eigenschaft_1_Variante2, Eigenschaft_1_Variante3}

    id: keyboard_arrow_right_24dp_1

    property int eigenschaft_2: Keyboard_arrow_right_24dp_1.Eigenschaft_1.Eigenschaft_1_Standard

    height: 24
    width: 24

    clip: true
    color: "transparent"

    states: [
        State {
            name: "Eigenschaft 1=Standard"
            when: keyboard_arrow_right_24dp_1.eigenschaft_2 === Keyboard_arrow_right_24dp_1.Eigenschaft_1.Eigenschaft_1_Standard
    
            PropertyChanges {
                fillColor: "#e2d5c8"
                target: _vector_ShapePath0
            }
        },
        State {
            name: "Eigenschaft 1=Variante2"
            when: keyboard_arrow_right_24dp_1.eigenschaft_2 === Keyboard_arrow_right_24dp_1.Eigenschaft_1.Eigenschaft_1_Variante2
    
            PropertyChanges {
                fillColor: "#ff8e00"
                target: _vector_ShapePath0
            }
        },
        State {
            name: "Eigenschaft 1=Variante3"
            when: keyboard_arrow_right_24dp_1.eigenschaft_2 === Keyboard_arrow_right_24dp_1.Eigenschaft_1.Eigenschaft_1_Variante3
    
            PropertyChanges {
                fillColor: "#34d399"
                target: _vector_ShapePath0
            }
        }
    ]

    Shape {
        id: _vector

        x: 8.69
        y: 6.69

        height: 10.62
        width: 6.02

        ShapePath {
            id: _vector_ShapePath0

            fillColor: "#e2d5c8"
            fillRule: ShapePath.WindingFill
            joinStyle: ShapePath.MiterJoin
            strokeColor: "#00000000"
            strokeStyle: ShapePath.SolidLine
            strokeWidth: 0.03

            PathSvg {
                id: _vector_ShapePath0_PathSvg0

                path: "M 4.600000145853277 5.307750225067139 L 0 0.7077499771145087 L 0.7077499614056367 0 L 6.015500068664551 5.307750225067139 L 0.7077499614056367 10.615500450134277 L 0 9.90775047301977 L 4.600000145853277 5.307750225067139 Z"
            }
        }
    }
}
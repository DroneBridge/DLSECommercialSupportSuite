import QtQuick
import QtQuick.Shapes

Rectangle {
    id: menu

    height: 24
    width: 24

    clip: true
    color: "transparent"

    Shape {
        id: icon

        x: 3
        y: 6

        height: 12
        width: 18

        ShapePath {
            id: icon_ShapePath0

            fillColor: "#1d1b20"
            fillRule: ShapePath.WindingFill
            joinStyle: ShapePath.MiterJoin
            strokeColor: "#00000000"
            strokeStyle: ShapePath.SolidLine
            strokeWidth: 0.03

            PathSvg {
                id: icon_ShapePath0_PathSvg0

                path: "M 0 12 L 0 10 L 18 10 L 18 12 L 0 12 Z M 0 7 L 0 5 L 18 5 L 18 7 L 0 7 Z M 0 2 L 0 0 L 18 0 L 18 2 L 0 2 Z"
            }
        }
    }
}
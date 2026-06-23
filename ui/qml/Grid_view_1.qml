import QtQuick
import QtQuick.Shapes

Rectangle {
    id: grid_view_1

    property alias _vectorHeight: _vector.height
    property alias _vectorWidth: _vector.width
    property alias _vectorX: _vector.x
    property alias _vectorY: _vector.y
    property alias _vector_ShapePath0_PathSvg0Path: _vector_ShapePath0_PathSvg0.path

    height: 24
    width: 24

    clip: true
    color: "transparent"

    Shape {
        id: _vector

        x: 4
        y: 4

        height: 16
        width: 16

        ShapePath {
            id: _vector_ShapePath0

            fillColor: "#deceb9"
            fillRule: ShapePath.WindingFill
            joinStyle: ShapePath.MiterJoin
            strokeColor: "#00000000"
            strokeStyle: ShapePath.SolidLine
            strokeWidth: 0.03

            PathSvg {
                id: _vector_ShapePath0_PathSvg0

                path: "M 0 7 L 0 0 L 7 0 L 7 7 L 0 7 Z M 0 16 L 0 9 L 7 9 L 7 16 L 0 16 Z M 9 7 L 9 0 L 16 0 L 16 7 L 9 7 Z M 9 16 L 9 9 L 16 9 L 16 16 L 9 16 Z M 1 6 L 6 6 L 6 1 L 1 1 L 1 6 Z M 10 6 L 15 6 L 15 1 L 10 1 L 10 6 Z M 10 15 L 15 15 L 15 10 L 10 10 L 10 15 Z M 1 15 L 6 15 L 6 10 L 1 10 L 1 15 Z"
            }
        }
    }
}
import QtQuick
import QtQuick.Shapes

Rectangle {
    id: search_24dp_1

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

        x: 3
        y: 3

        height: 18
        width: 18

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

                path: "M 16.6 18 L 10.3 11.700000000000001 C 9.8 12.100000000000001 9.225000000000001 12.416666674613953 8.575000000000001 12.65 C 7.925000000000001 12.883333325386047 7.233333349227905 13 6.5 13 C 4.683333396911621 13 3.1458333015441897 12.37083330154419 1.8875000000000002 11.1125 C 0.6291666984558106 9.854166698455812 0 8.316666603088379 0 6.5 C 0 4.683333396911621 0.6291666984558106 3.1458333015441897 1.8875000000000002 1.8875000000000002 C 3.1458333015441897 0.6291666984558106 4.683333396911621 0 6.5 0 C 8.316666603088379 0 9.854166698455812 0.6291666984558106 11.1125 1.8875000000000002 C 12.37083330154419 3.1458333015441897 13 4.683333396911621 13 6.5 C 13 7.233333349227905 12.883333325386047 7.925000000000001 12.65 8.575000000000001 C 12.416666674613953 9.225000000000001 12.100000000000001 9.8 11.700000000000001 10.3 L 18 16.6 L 16.6 18 Z M 6.5 11 C 7.75 11 8.8125 10.5625 9.6875 9.6875 C 10.5625 8.8125 11 7.75 11 6.5 C 11 5.25 10.5625 4.1875 9.6875 3.3125 C 8.8125 2.4375 7.75 2 6.5 2 C 5.25 2 4.1875 2.4375 3.3125 3.3125 C 2.4375 4.1875 2 5.25 2 6.5 C 2 7.75 2.4375 8.8125 3.3125 9.6875 C 4.1875 10.5625 5.25 11 6.5 11 Z"
            }
        }
    }
}
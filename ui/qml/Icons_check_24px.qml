import QtQuick
import QtQuick.Shapes

Rectangle {
    id: icons_check_24px

    property alias iconHeight: icon.height
    property alias iconWidth: icon.width
    property alias icon_ShapePath0FillColor: icon_ShapePath0.fillColor
    property alias icon_ShapePath0_PathSvg0Path: icon_ShapePath0_PathSvg0.path

    height: 24
    width: 24

    color: "transparent"

    Shape {
        id: icon

        x: 3.41
        y: 5.59

        height: 13.41
        width: 17.59

        ShapePath {
            id: icon_ShapePath0

            fillColor: "#000000"
            fillRule: ShapePath.WindingFill
            strokeColor: "#00000000"
            strokeWidth: 0

            PathSvg {
                id: icon_ShapePath0_PathSvg0

                path: "M 5.590000152587891 10.579999923706055 L 1.4199999570846558 6.409999847412109 L 0 7.820000171661377 L 5.590000152587891 13.40999984741211 L 17.59000015258789 1.409999966621399 L 16.18000030517578 0 L 5.590000152587891 10.579999923706055 Z"
            }
        }
    }
}
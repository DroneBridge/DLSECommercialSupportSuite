import QtQuick

Rectangle {
    id: formatListNumberedIcon

    objectName: "formatListNumberedIcon"
    height: 24
    width: 24
    color: "transparent"

    Image {
        id: formatListNumberedImage

        objectName: "formatListNumberedImage"
        x: 4
        y: 4
        height: 16
        width: 16
        fillMode: Image.PreserveAspectFit
        source: "../resources/images/format_list_numbered.svg"
    }
}

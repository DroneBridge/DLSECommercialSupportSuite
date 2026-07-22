import QtQuick

Rectangle {
    id: syncAlt

    objectName: "syncAltIcon"
    height: 24
    width: 24
    clip: true
    color: "transparent"

    Image {
        objectName: "syncAltImage"
        anchors.centerIn: parent
        height: 20
        fillMode: Image.PreserveAspectFit
        source: "sync_alt.svg"
        width: 20
    }
}

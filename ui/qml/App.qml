import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: window
    objectName: "appWindow"

    width: 1298
    height: 804
    minimumWidth: 1180
    minimumHeight: 720
    visible: true
    title: "DroneBridge DLSE Commercial Support Suite"
    color: "#081624"

    StackLayout {
        anchors.fill: parent
        currentIndex: navigation.currentPage

        Start {
            onDirectStandaloneRequested: navigation.currentPage = 1
        }

        MainScreen {
            onBackRequested: navigation.currentPage = 0
        }
    }

    QtObject {
        id: navigation
        property int currentPage: 0
    }
}

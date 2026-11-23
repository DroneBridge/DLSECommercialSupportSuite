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
    property bool leavingSerial: false
    property bool closingAfterSerial: false

    function requestSerialLeave(closeWindow) {
        if (serialController.locked) {
            closingAfterSerial = closeWindow
            leaveSerialDialog.open()
        } else {
            serialController.stop()
            if (closeWindow) window.close()
            else navigation.currentPage = 0
        }
    }

    onClosing: function(close) {
        if (serialController.locked) {
            close.accepted = false
            requestSerialLeave(true)
        } else if (serialController.state === "review") {
            serialController.stop()
        }
    }

    StackLayout {
        anchors.fill: parent
        currentIndex: navigation.currentPage

        Start {
            onDirectStandaloneRequested: navigation.currentPage = 1
            onSerialFlasherRequested: navigation.currentPage = 2
        }

        MainScreen {
            onBackRequested: navigation.currentPage = 0
        }

        Loader {
            active: navigation.currentPage === 2
            sourceComponent: serialPage
        }
    }

    Component {
        id: serialPage
        SerialFlasher {
            onBackRequested: window.requestSerialLeave(false)
        }
    }

    QtObject {
        id: navigation
        property int currentPage: 0
    }

    Connections {
        target: serialController
        function onStopped() {
            if (!window.leavingSerial) return
            window.leavingSerial = false
            if (window.closingAfterSerial) window.close()
            else navigation.currentPage = 0
        }
    }

    ModalDialog {
        id: leaveSerialDialog
        objectName: "leaveSerialDialog"
        title: "Stop serial flashing before leaving?"
        Text {
            Layout.fillWidth: true
            text: "Monitoring and queued work will stop. The active board or preparation job will finish before you leave."
            color: "#deceb9"; wrapMode: Text.Wrap
        }
        RowLayout {
            Item { Layout.fillWidth: true }
            AppButton { text: "Stay"; quiet: true; onClicked: leaveSerialDialog.close() }
            AppButton {
                objectName: "serialStopAndLeaveButton"
                text: "Stop and leave"
                onClicked: { window.leavingSerial = true; leaveSerialDialog.close(); serialController.stop() }
            }
        }
    }
}

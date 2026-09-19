import QtQuick.Templates as T
import QtQuick
import DesignTokens as Tokens
import QtQml

T.Switch {
    Theme { id: theme }
    enum Status { Status_Default, Status_Disabled, Status_Hovered, Status_Pressed}
    enum Check { Check_Off, Check_On}

    id: switchRoot

    property int check_1: ControlsSwitch.Check.Check_Off
    property int status_1: ControlsSwitch.Status.Status_Default

    height: 24
    width: 144

    background: Rectangle {
        id: controlsSwitch
    
        border.color: "#2e3a47"
        border.width: 1
        color: "#1ae2d5c8"
        radius: Tokens.Collection_1.numbers.radius
    }
    contentItem: Item {
        id: switchRootcontentItem

        z: 1
    
        Item {
            id: group_40
    
            x: 13
            y: 4
    
            height: 16
            width: 42.26
    
            List_24dp_1 {
                id: list_24dp_2

                visible: false
    
                height: 16
                width: 16
    
                _vectorHeight: 5.33
                _vectorWidth: 10.67
                _vectorX: 2.67
                _vectorY: 5.33
                _vector_ShapePath0_PathSvg0Path: "M 2.4358333042015605 0.7436666074494497 L 2.4358333042015605 0.07699992091456807 L 10.666666984558105 0.07699992091456807 L 10.666666984558105 0.7436666074494497 L 2.4358333042015605 0.7436666074494497 Z M 2.4358333042015605 3.0000000894069676 L 2.4358333042015605 2.3333334028720856 L 10.666666984558105 2.3333334028720856 L 10.666666984558105 3.0000000894069676 L 2.4358333042015605 3.0000000894069676 Z M 2.4358333042015605 5.256333571364485 L 2.4358333042015605 4.589666884829604 L 10.666666984558105 4.589666884829604 L 10.666666984558105 5.256333571364485 L 2.4358333042015605 5.256333571364485 Z M 0.4103332641820089 0.8204996989319625 C 0.2939999270637806 0.8204996989319625 0.19655558854010452 0.7799443477375605 0.11800003403425309 0.6988332320898736 C 0.039333368519942985 0.6177221164421867 0 0.5172773833258163 0 0.3974996049453694 C 0 0.28483293110627705 0.039333368519942985 0.19044420491986075 0.11800003403425309 0.11433309260009993 C 0.19655558854010452 0.03811086927188044 0.2939999270637806 0 0.4103332641820089 0 C 0.5265554902917785 0 0.6239443647050167 0.03811086927188044 0.7024999192108681 0.11433309260009993 C 0.7811665847251782 0.19044420491986075 0.8204999532451211 0.28483293110627705 0.8204999532451211 0.3974996049453694 C 0.8204999532451211 0.5172773833258163 0.7811665847251782 0.6177221164421867 0.7024999192108681 0.6988332320898736 C 0.6239443647050167 0.7799443477375605 0.5265554902917785 0.8204996989319625 0.4103332641820089 0.8204996989319625 Z M 0.4103332641820089 3.064166859711213 C 0.2939999270637806 3.064166859711213 0.19655558854010452 3.0260554818130156 0.11800003403425309 2.949833258484796 C 0.039333368519942985 2.8736110351565767 0 2.77922230897016 0 2.6666667461395264 C 0 2.5375556351012656 0.039333368519942985 2.4347778489622804 0.11800003403425309 2.3583334036171437 C 0.19655558854010452 2.281888958272007 0.2939999270637806 2.2436666521529336 0.4103332641820089 2.2436666521529336 C 0.5265554902917785 2.2436666521529336 0.6239443647050167 2.281888958272007 0.7024999192108681 2.3583334036171437 C 0.7811665847251782 2.4347778489622804 0.8204999532451211 2.5375556351012656 0.8204999532451211 2.6666667461395264 C 0.8204999532451211 2.77922230897016 0.7811665847251782 2.8736110351565767 0.7024999192108681 2.949833258484796 C 0.6239443647050167 3.0260554818130156 0.5265554902917785 3.064166859711213 0.4103332641820089 3.064166859711213 Z M 0.4103332641820089 5.333333492279053 C 0.2939999270637806 5.333333492279053 0.19655558854010452 5.292778141084651 0.11800003403425309 5.211667025436964 C 0.039333368519942985 5.130555909789277 0 5.030111176672907 0 4.91033339829246 C 0 4.797666724453368 0.039333368519942985 4.703277998266951 0.11800003403425309 4.62716688594719 C 0.19655558854010452 4.550944662618971 0.2939999270637806 4.512833284720774 0.4103332641820089 4.512833284720774 C 0.5265554902917785 4.512833284720774 0.6239443647050167 4.550944662618971 0.7024999192108681 4.62716688594719 C 0.7811665847251782 4.703277998266951 0.8204999532451211 4.797666724453368 0.8204999532451211 4.91033339829246 C 0.8204999532451211 5.030111176672907 0.7811665847251782 5.130555909789277 0.7024999192108681 5.211667025436964 C 0.6239443647050167 5.292778141084651 0.5265554902917785 5.333333492279053 0.4103332641820089 5.333333492279053 Z"
                clip: true
            }
            Image {
                id: listViewIcon

                objectName: "listViewIcon"
                width: 16
                height: 16
                fillMode: Image.PreserveAspectFit
                source: "../resources/images/list_24dp.svg"
            }
            Text {
                id: _list
    
                x: 16.56
                y: 1.36
    
                height: 13.28
                width: 26
    
                color: "#e2d5c8"
                font.capitalization: Font.AllUppercase
                font.family: theme.dataFont
                font.letterSpacing: -0.70
                font.pixelSize: theme.smallTextSize
                font.weight: Font.Bold
                horizontalAlignment: Text.AlignLeft
                text: "List"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignVCenter
            }
        }
        Item {
            id: group_39
    
            x: 77
            y: 4
    
            height: 15.99
            width: 60
    
            Grid_view_1 {
                id: grid_view_2

                visible: false
    
                height: 15.99
                width: 15.99
    
                _vectorHeight: 10.66
                _vectorWidth: 10.66
                _vectorX: 2.66
                _vectorY: 2.66
                _vector_ShapePath0_PathSvg0Path: "M 0 4.663273870944977 L 0 0 L 4.663273870944977 0 L 4.663273870944977 4.663273870944977 L 0 4.663273870944977 Z M 0 10.65891170501709 L 0 5.995637834072112 L 4.663273870944977 5.995637834072112 L 4.663273870944977 10.65891170501709 L 0 10.65891170501709 Z M 5.995637834072112 4.663273870944977 L 5.995637834072112 0 L 10.65891170501709 0 L 10.65891170501709 4.663273870944977 L 5.995637834072112 4.663273870944977 Z M 5.995637834072112 10.65891170501709 L 5.995637834072112 5.995637834072112 L 10.65891170501709 5.995637834072112 L 10.65891170501709 10.65891170501709 L 5.995637834072112 10.65891170501709 Z M 0.6661819815635681 3.9970918893814082 L 3.9970918893814082 3.9970918893814082 L 3.9970918893814082 0.6661819815635681 L 0.6661819815635681 0.6661819815635681 L 0.6661819815635681 3.9970918893814082 Z M 6.66181981563568 3.9970918893814082 L 9.992729723453522 3.9970918893814082 L 9.992729723453522 0.6661819815635681 L 6.66181981563568 0.6661819815635681 L 6.66181981563568 3.9970918893814082 Z M 6.66181981563568 9.992729723453522 L 9.992729723453522 9.992729723453522 L 9.992729723453522 6.66181981563568 L 6.66181981563568 6.66181981563568 L 6.66181981563568 9.992729723453522 Z M 0.6661819815635681 9.992729723453522 L 3.9970918893814082 9.992729723453522 L 3.9970918893814082 6.66181981563568 L 0.6661819815635681 6.66181981563568 L 0.6661819815635681 9.992729723453522 Z"
                clip: true
            }
            Image {
                id: gridViewIcon

                objectName: "gridViewIcon"
                width: 16
                height: 16
                fillMode: Image.PreserveAspectFit
                source: "../resources/images/grid_view.svg"
            }
            Text {
                id: matrix
    
                x: 17.54
                y: 1.21
    
                height: 13.27
                width: 45
    
                color: "#e2d5c8"
                font.capitalization: Font.AllUppercase
                font.family: theme.dataFont
                font.letterSpacing: -0.70
                font.pixelSize: theme.smallTextSize
                horizontalAlignment: Text.AlignLeft
                text: "Matrix"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
    indicator: Item {
        id: switchRootindicator

        z: 0
    
        Rectangle {
            id: indicator
    
            x: 2
            y: 2
    
            height: 20
            width: 72
    
            clip: true
            color: "#2e3a47"
            radius: 3
        }
    }

    states: [
        State {
            name: "Status=Default, Check=Off"
            when: switchRoot.status_1 === ControlsSwitch.Status.Status_Default && switchRoot.check_1 === ControlsSwitch.Check.Check_Off
    
            PropertyChanges {
                border.color: "#2e3a47"
                target: controlsSwitch
            }
            PropertyChanges {
                x: 2
    
                target: indicator
            }
            PropertyChanges {
                color: "#2e3a47"
                target: indicator
            }
        },
        State {
            name: "Status=Default, Check=On"
            when: switchRoot.status_1 === ControlsSwitch.Status.Status_Default && switchRoot.check_1 === ControlsSwitch.Check.Check_On
    
            PropertyChanges {
                border.color: "#2e3a47"
                target: controlsSwitch
            }
            PropertyChanges {
                x: 70
    
                target: indicator
            }
            PropertyChanges {
                color: "#2e3a47"
                target: indicator
            }
        },
        State {
            name: "Status=Hovered, Check=Off"
            when: switchRoot.status_1 === ControlsSwitch.Status.Status_Hovered && switchRoot.check_1 === ControlsSwitch.Check.Check_Off
    
            PropertyChanges {
                border.color: "#deceb9"
                target: controlsSwitch
            }
            PropertyChanges {
                x: 2
    
                target: indicator
            }
            PropertyChanges {
                color: "#2e3a47"
                target: indicator
            }
        },
        State {
            name: "Status=Hovered, Check=On"
            when: switchRoot.status_1 === ControlsSwitch.Status.Status_Hovered && switchRoot.check_1 === ControlsSwitch.Check.Check_On
    
            PropertyChanges {
                border.color: "#deceb9"
                target: controlsSwitch
            }
            PropertyChanges {
                x: 70
    
                target: indicator
            }
            PropertyChanges {
                color: "#2e3a47"
                target: indicator
            }
        },
        State {
            name: "Status=Pressed, Check=Off"
            when: switchRoot.status_1 === ControlsSwitch.Status.Status_Pressed && switchRoot.check_1 === ControlsSwitch.Check.Check_Off
    
            PropertyChanges {
                border.color: "#deceb9"
                target: controlsSwitch
            }
            PropertyChanges {
                x: 18
    
                target: indicator
            }
            PropertyChanges {
                color: "#2e3a47"
                target: indicator
            }
        },
        State {
            name: "Status=Pressed, Check=On"
            when: switchRoot.status_1 === ControlsSwitch.Status.Status_Pressed && switchRoot.check_1 === ControlsSwitch.Check.Check_On
    
            PropertyChanges {
                border.color: "#deceb9"
                target: controlsSwitch
            }
            PropertyChanges {
                x: 54
    
                target: indicator
            }
            PropertyChanges {
                color: "#2e3a47"
                target: indicator
            }
        },
        State {
            name: "Status=Disabled, Check=Off"
            when: switchRoot.status_1 === ControlsSwitch.Status.Status_Disabled && switchRoot.check_1 === ControlsSwitch.Check.Check_Off
    
            PropertyChanges {
                border.color: "#2e3a47"
                target: controlsSwitch
            }
            PropertyChanges {
                x: 2
    
                target: indicator
            }
            PropertyChanges {
                color: "#aeaeae"
                target: indicator
            }
        },
        State {
            name: "Status=Disabled, Check=On"
            when: switchRoot.status_1 === ControlsSwitch.Status.Status_Disabled && switchRoot.check_1 === ControlsSwitch.Check.Check_On
    
            PropertyChanges {
                border.color: "#2e3a47"
                target: controlsSwitch
            }
            PropertyChanges {
                x: 70
    
                target: indicator
            }
            PropertyChanges {
                color: "#aeaeae"
                target: indicator
            }
        }
    ]

    Binding {
        property: "status_1"
        target: switchRoot
        value: !switchRoot.enabled ? ControlsSwitch.Status.Status_Disabled
            : switchRoot.pressed ? ControlsSwitch.Status.Status_Pressed
            : switchRoot.hovered ? ControlsSwitch.Status.Status_Hovered
            : ControlsSwitch.Status.Status_Default
    }
    Binding {
        property: "check_1"
        target: switchRoot
        value: switchRoot.checked ? ControlsSwitch.Check.Check_On
            : ControlsSwitch.Check.Check_Off
    }
}

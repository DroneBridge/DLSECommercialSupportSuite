import QtQuick
import QtQuick.Shapes

Rectangle {
    Theme { id: theme }
    enum Status { Status_Default, Status_Disabled, Status_Hovered}
    enum Check { Check_Off, Check_On}

    id: controlsCheckbox

    property alias labelWidth: label.width

    property int check_1: ControlsCheckbox.Check.Check_Off
    property string labelText: "Checkbox"
    property int status_1: ControlsCheckbox.Status.Status_Default

    height: 16
    width: 120

    color: "transparent"

    states: [
        State {
            name: "Status=Default, Check=Off"
            when: controlsCheckbox.status_1 === ControlsCheckbox.Status.Status_Default && controlsCheckbox.check_1 === ControlsCheckbox.Check.Check_Off
    
            PropertyChanges {
                color: "#deceb9"
                target: label
            }
            PropertyChanges {
                color: "#00000000"
                target: indicator
            }
            PropertyChanges {
                border.width: 1
                target: indicator
            }
            PropertyChanges {
                border.color: "#2e3a47"
                target: indicator
            }
            PropertyChanges {
                target: checkmark
                visible: false
            }
        },
        State {
            name: "Status=Default, Check=On"
            when: controlsCheckbox.status_1 === ControlsCheckbox.Status.Status_Default && controlsCheckbox.check_1 === ControlsCheckbox.Check.Check_On
    
            PropertyChanges {
                color: "#deceb9"
                target: label
            }
            PropertyChanges {
                color: "#5434d399"
                target: indicator
            }
            PropertyChanges {
                border.width: 0
                target: indicator
            }
            PropertyChanges {
                border.color: "white"
                target: indicator
            }
            PropertyChanges {
                target: checkmark
                visible: true
            }
            PropertyChanges {
                fillColor: "#e2e2e2"
                target: checkmark_ShapePath0
            }
        },
        State {
            name: "Status=Hovered, Check=Off"
            when: controlsCheckbox.status_1 === ControlsCheckbox.Status.Status_Hovered && controlsCheckbox.check_1 === ControlsCheckbox.Check.Check_Off
    
            PropertyChanges {
                color: "#deceb9"
                target: label
            }
            PropertyChanges {
                color: "#00000000"
                target: indicator
            }
            PropertyChanges {
                border.width: 1
                target: indicator
            }
            PropertyChanges {
                border.color: "#deceb9"
                target: indicator
            }
            PropertyChanges {
                target: checkmark
                visible: false
            }
        },
        State {
            name: "Status=Hovered, Check=On"
            when: controlsCheckbox.status_1 === ControlsCheckbox.Status.Status_Hovered && controlsCheckbox.check_1 === ControlsCheckbox.Check.Check_On
    
            PropertyChanges {
                color: "#deceb9"
                target: label
            }
            PropertyChanges {
                color: "#34d399"
                target: indicator
            }
            PropertyChanges {
                border.width: 0
                target: indicator
            }
            PropertyChanges {
                border.color: "white"
                target: indicator
            }
            PropertyChanges {
                fillColor: "#e2e2e2"
                target: checkmark_ShapePath0
            }
        },
        State {
            name: "Status=Disabled, Check=Off"
            when: controlsCheckbox.status_1 === ControlsCheckbox.Status.Status_Disabled && controlsCheckbox.check_1 === ControlsCheckbox.Check.Check_Off
    
            PropertyChanges {
                color: "#26deceb9"
                target: label
            }
            PropertyChanges {
                color: "#00000000"
                target: indicator
            }
            PropertyChanges {
                border.width: 1
                target: indicator
            }
            PropertyChanges {
                border.color: "#2e3a47"
                target: indicator
            }
            PropertyChanges {
                target: checkmark
                visible: false
            }
        },
        State {
            name: "Status=Disabled, Check=On"
            when: controlsCheckbox.status_1 === ControlsCheckbox.Status.Status_Disabled && controlsCheckbox.check_1 === ControlsCheckbox.Check.Check_On
    
            PropertyChanges {
                color: "#26deceb9"
                target: label
            }
            PropertyChanges {
                color: "#2e3a47"
                target: indicator
            }
            PropertyChanges {
                border.width: 0
                target: indicator
            }
            PropertyChanges {
                border.color: "white"
                target: indicator
            }
            PropertyChanges {
                fillColor: "#787878"
                target: checkmark_ShapePath0
            }
        }
    ]

    Text {
        id: label

        x: 24
        y: 1

        height: 13
        width: 45

        color: "#deceb9"
        font.capitalization: Font.AllUppercase
        font.family: "JetBrains Mono"
        font.letterSpacing: -0.70
        font.pixelSize: theme.smallTextSize
        font.weight: Font.Bold
        horizontalAlignment: Text.AlignLeft
        text: controlsCheckbox.labelText
        verticalAlignment: Text.AlignTop
    }
    Rectangle {
        id: indicator

        height: 16
        width: 16

        border.color: "#2e3a47"
        border.width: 1
        clip: true
        color: "#00000000"
        radius: 4

        Shape {
            id: checkmark

            x: 3
            y: 4

            height: 8
            width: 10

            ShapePath {
                id: checkmark_ShapePath0

                fillColor: "#e2e2e2"
                fillRule: ShapePath.OddEvenFill
                joinStyle: ShapePath.MiterJoin
                strokeColor: "#00000000"
                strokeStyle: ShapePath.SolidLine
                strokeWidth: 1

                PathSvg {
                    id: checkmark_ShapePath0_PathSvg0

                    path: "M 9.793127059936523 0.17445886135101318 C 10.049681425094604 0.42551422119140625 10.070455446839333 0.8551411032676697 9.83952808380127 1.1340572834014893 L 4.434211254119873 7.662648677825928 C 4.074857085943222 8.096679925918579 3.4542014598846436 8.114365488290787 3.0744261741638184 7.70139741897583 L 0.18300943076610565 4.557267665863037 C -0.061041221022605896 4.291886746883392 -0.06099756062030792 3.86166650056839 0.183106929063797 3.596344232559204 C 0.4272114485502243 3.331021785736084 0.8229393661022186 3.3310691714286804 1.0669900178909302 3.596450090408325 L 3.7499983310699463 6.487332344055176 L 8.910462379455566 0.22490546107292175 C 9.14138974249363 -0.05401080846786499 9.536572098731995 -0.0765964686870575 9.793127059936523 0.17445886135101318 Z"
                }
            }
        }
    }
}
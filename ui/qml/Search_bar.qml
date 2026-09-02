import QtQuick
import QtQuick.Shapes

Rectangle {
    Theme { id: theme }
    enum State_1 { State_1_Enabled, State_1_Hovered, State_1_Pressed}
    enum Show_avatar { Show_avatar_False, Show_avatar_True}

    id: search_bar

    property alias contentHeight: content.height
    property alias contentWidth: content.width
    property alias contentX: content.x
    property alias contentY: content.y
    property alias search_barBorderColor: search_bar.border.color
    property alias search_barBorderWidth: search_bar.border.width
    property alias state_layerHeight: state_layer.height
    property alias supporting_textColor: supporting_text.color
    property alias supporting_textFontFamily: supporting_text.font.family
    property alias supporting_textFontLetterSpacing: supporting_text.font.letterSpacing
    property alias supporting_textFontPixelSize: supporting_text.font.pixelSize
    property alias supporting_textHeight: supporting_text.height
    property alias supporting_textLineHeight: supporting_text.lineHeight
    property alias supporting_textLineHeightMode: supporting_text.lineHeightMode
    property alias supporting_textWidth: supporting_text.width
    property alias supporting_textY: supporting_text.y
    property alias trailing_ElementsY: trailing_Elements.y

    property int _state: Search_bar.State_1.State_1_Enabled
    property string placeholder_text: "Hinted search text"
    property bool show_1st_trailing_icon: true
    property bool show_2nd_trailing_icon: false
    property int show_avatar_1: Search_bar.Show_avatar.Show_avatar_False
    property bool show_leading_icon: true

    height: 56
    width: 360

    border.color: "white"
    border.width: 0
    clip: true
    color: "#ece6f0"
    radius: 28

    states: [
        State {
            name: "State=Enabled, Show avatar=False"
            when: search_bar._state === Search_bar.State_1.State_1_Enabled && search_bar.show_avatar_1 === Search_bar.Show_avatar.Show_avatar_False
    
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                x: 308
    
                target: trailing_Elements
            }
            PropertyChanges {
                width: 48
    
                target: trailing_Elements
            }
            PropertyChanges {
                target: nd_trailing_icon
                visible: search_bar.show_2nd_trailing_icon
            }
            PropertyChanges {
                target: avatar_target
                visible: false
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "State=Pressed, Show avatar=True"
            when: search_bar._state === Search_bar.State_1.State_1_Pressed && search_bar.show_avatar_1 === Search_bar.Show_avatar.Show_avatar_True
    
            PropertyChanges {
                color: "#141d1b20"
                target: state_layer
            }
            PropertyChanges {
                x: 258
    
                target: trailing_Elements
            }
            PropertyChanges {
                width: 98
    
                target: trailing_Elements
            }
            PropertyChanges {
                target: nd_trailing_icon
                visible: false
            }
            PropertyChanges {
                target: avatar_target
                visible: true
            }
            PropertyChanges {
                target: ripple
                visible: true
            }
        },
        State {
            name: "State=Hovered, Show avatar=True"
            when: search_bar._state === Search_bar.State_1.State_1_Hovered && search_bar.show_avatar_1 === Search_bar.Show_avatar.Show_avatar_True
    
            PropertyChanges {
                color: "#141d1b20"
                target: state_layer
            }
            PropertyChanges {
                x: 258
    
                target: trailing_Elements
            }
            PropertyChanges {
                width: 98
    
                target: trailing_Elements
            }
            PropertyChanges {
                target: nd_trailing_icon
                visible: false
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "State=Enabled, Show avatar=True"
            when: search_bar._state === Search_bar.State_1.State_1_Enabled && search_bar.show_avatar_1 === Search_bar.Show_avatar.Show_avatar_True
    
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                x: 258
    
                target: trailing_Elements
            }
            PropertyChanges {
                width: 98
    
                target: trailing_Elements
            }
            PropertyChanges {
                target: nd_trailing_icon
                visible: false
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "State=Pressed, Show avatar=False"
            when: search_bar._state === Search_bar.State_1.State_1_Pressed && search_bar.show_avatar_1 === Search_bar.Show_avatar.Show_avatar_False
    
            PropertyChanges {
                color: "#141d1b20"
                target: state_layer
            }
            PropertyChanges {
                x: 308
    
                target: trailing_Elements
            }
            PropertyChanges {
                width: 48
    
                target: trailing_Elements
            }
            PropertyChanges {
                target: avatar_target
                visible: false
            }
        },
        State {
            name: "State=Hovered, Show avatar=False"
            when: search_bar._state === Search_bar.State_1.State_1_Hovered && search_bar.show_avatar_1 === Search_bar.Show_avatar.Show_avatar_False
    
            PropertyChanges {
                color: "#141d1b20"
                target: state_layer
            }
            PropertyChanges {
                x: 308
    
                target: trailing_Elements
            }
            PropertyChanges {
                width: 48
    
                target: trailing_Elements
            }
            PropertyChanges {
                target: avatar_target
                visible: false
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        }
    ]

    Rectangle {
        id: state_layer

        height: 56
        width: 360

        color: "transparent"

        Icon_button_standard {
            id: leading_icon

            x: 4
            y: 4

            _size: Icon_button_standard.Size.Size_Small
            _state: Icon_button_standard.State_1.State_1_Enabled
            _width: Icon_button_standard.Width.Width_Default
            show_focus_indicator: false
            state_layerOpacity: 1
            type_1: Icon_button_standard.Type.Type_Round
            visible: search_bar.show_leading_icon
        }
        Rectangle {
            id: content

            x: 36
            y: 4

            height: 48
            width: 320

            color: "transparent"

            Text {
                id: supporting_text

                x: 20
                y: 12

                height: 24
                width: 141

                color: "#49454f"
                font.family: theme.bodyFont
                font.letterSpacing: 0.50
                font.pixelSize: theme.headingTextSize
                font.weight: Font.Normal
                horizontalAlignment: Text.AlignLeft
                lineHeight: 24
                lineHeightMode: Text.FixedHeight
                text: search_bar.placeholder_text
                verticalAlignment: Text.AlignVCenter
            }
        }
        Rectangle {
            id: trailing_Elements

            x: 308
            y: 4

            height: 48
            width: 48

            color: "transparent"

            Icon_button_standard {
                id: st_trailing_icon

                _size: Icon_button_standard.Size.Size_Small
                _state: Icon_button_standard.State_1.State_1_Enabled
                _width: Icon_button_standard.Width.Width_Default
                show_focus_indicator: false
                state_layerOpacity: 1
                type_1: Icon_button_standard.Type.Type_Round
                visible: search_bar.show_1st_trailing_icon
            }
            Icon_button_standard {
                id: nd_trailing_icon

                x: 48

                _size: Icon_button_standard.Size.Size_Small
                _state: Icon_button_standard.State_1.State_1_Enabled
                _width: Icon_button_standard.Width.Width_Default
                show_focus_indicator: false
                state_layerOpacity: 1
                type_1: Icon_button_standard.Type.Type_Round
                visible: search_bar.show_2nd_trailing_icon
            }
            Rectangle {
                id: avatar_target

                x: 48

                height: 48
                width: 50

                color: "transparent"

                Generic_avatar {
                    id: avatar

                    x: 8
                    y: 9

                    height: 30
                    width: 30

                    clip: true
                    initialColor: "#ffffff"
                    initialFontLetterSpacing: 0.15
                    initialX: -5
                    initialY: -5
                    letter: "A"
                    style_1: Generic_avatar.Style.Style_Monogram
                }
            }
        }
        Shape {
            id: ripple

            y: -24

            height: 125
            width: 178

            transform: Scale {
                origin.x: ripple.width / 2
                origin.y: ripple.height / 2
                xScale: -1
            }

            ShapePath {
                id: ripple_ShapePath0

                fillColor: "#1a1d1b20"
                fillRule: ShapePath.WindingFill
                strokeColor: "#00000000"
                strokeWidth: 0

                PathSvg {
                    id: ripple_ShapePath0_PathSvg0

                    path: "M 178 13.945915869304113 L 178 111.48646899632045 C 178 118.94978199686324 172.0967807483673 125 164.81481079101562 125 L 0 125 C 0 55.964408602033345 54.60467643737792 0 121.96295944213867 0 C 142.16563758850097 0 161.22104671478272 5.034402438572474 178 13.945915869304113 Z"
                }
            }
        }
    }
}

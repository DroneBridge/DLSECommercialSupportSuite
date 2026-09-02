import QtQuick
import QtQuick.Shapes

Rectangle {
    Theme { id: theme }
    enum Style { Style_Check, Style_Monogram, Style_Avatar}

    id: generic_avatar

    property alias backgroundSource: background.source
    property alias initialColor: initial.color
    property alias initialFontLetterSpacing: initial.font.letterSpacing
    property alias initialX: initial.x
    property alias initialY: initial.y

    property string letter: "A"
    property int style_1: Generic_avatar.Style.Style_Avatar

    height: 40
    width: 40

    clip: true
    color: "#eaddff"
    radius: 100

    states: [
        State {
            name: "Style=Avatar"
            when: generic_avatar.style_1 === Generic_avatar.Style.Style_Avatar
    
            PropertyChanges {
                clip: true
                target: generic_avatar
            }
            PropertyChanges {
                color: "#eaddff"
                target: generic_avatar
            }
            PropertyChanges {
                radius: 100
                target: generic_avatar
            }
            PropertyChanges {
                target: avatar_Placeholder
                visible: true
            }
            PropertyChanges {
                target: background
                visible: false
            }
            PropertyChanges {
                target: initial
                visible: false
            }
            PropertyChanges {
                target: check
                visible: false
            }
        },
        State {
            name: "Style=Monogram"
            when: generic_avatar.style_1 === Generic_avatar.Style.Style_Monogram
    
            PropertyChanges {
                clip: true
                target: generic_avatar
            }
            PropertyChanges {
                color: "transparent"
                target: generic_avatar
            }
            PropertyChanges {
                radius: 0
                target: generic_avatar
            }
            PropertyChanges {
                target: avatar_Placeholder
                visible: false
            }
            PropertyChanges {
                target: background
                visible: true
            }
            PropertyChanges {
                target: initial
                visible: true
            }
            PropertyChanges {
                target: check
                visible: false
            }
        },
        State {
            name: "Style=Check"
            when: generic_avatar.style_1 === Generic_avatar.Style.Style_Check
    
            PropertyChanges {
                clip: true
                target: generic_avatar
            }
            PropertyChanges {
                color: "transparent"
                target: generic_avatar
            }
            PropertyChanges {
                radius: 0
                target: generic_avatar
            }
            PropertyChanges {
                target: avatar_Placeholder
                visible: false
            }
            PropertyChanges {
                target: initial
                visible: false
            }
            PropertyChanges {
                target: check
                visible: true
            }
        }
    ]

    Shape {
        id: avatar_Placeholder

        x: 5.91
        y: 10

        height: 25.63
        width: 28.18

        visible: true

        ShapePath {
            id: avatar_Placeholder_ShapePath0

            fillColor: "#4f378a"
            fillRule: ShapePath.OddEvenFill
            strokeColor: "#00000000"
            strokeWidth: 0

            PathSvg {
                id: avatar_Placeholder_ShapePath0_PathSvg0

                path: "M 20.092041015625 6 C 20.092041015625 9.313708305358887 17.405750274658203 12 14.092041015625 12 C 10.778332710266113 12 8.092041015625 9.313708305358887 8.092041015625 6 C 8.092041015625 2.686291456222534 10.778332710266113 0 14.092041015625 0 C 17.405750274658203 0 20.092041015625 2.686291456222534 20.092041015625 6 Z M 18.092041015625 6 C 18.092041015625 8.209138870239258 16.301179885864258 10 14.092041015625 10 C 11.882902145385742 10 10.092041015625 8.209138870239258 10.092041015625 6 C 10.092041015625 3.790860891342163 11.882902145385742 2 14.092041015625 2 C 16.301179885864258 2 18.092041015625 3.790860891342163 18.092041015625 6 Z"
            }
        }
        ShapePath {
            id: avatar_Placeholder_ShapePath1

            fillColor: "#4f378a"
            fillRule: ShapePath.WindingFill
            strokeColor: "#00000000"
            strokeWidth: 0

            PathSvg {
                id: avatar_Placeholder_ShapePath1_PathSvg0

                path: "M 14.092042922973633 15 C 7.617657661437988 15 2.1013152599334717 18.828411102294922 0 24.19204330444336 C 0.5118950605392456 24.700355529785156 1.0511384010314941 25.18115997314453 1.6153285503387451 25.632057189941406 C 3.180070161819458 20.707693099975586 8.08875846862793 17 14.092042922973633 17 C 20.0953311920166 17 25.004024505615234 20.707698822021484 26.568761825561523 25.63207244873047 C 27.132951736450195 25.18117332458496 27.672195434570312 24.700366973876953 28.184091567993164 24.192058563232422 C 26.082780838012695 18.82841682434082 20.566434860229492 15 14.092042922973633 15 Z"
            }
        }
    }
    Image {
        id: background

        source: Qt.resolvedUrl("assets/background.png")

        ShapePath {
            id: background_ShapePath0

            fillColor: "#eaddff"
            fillRule: ShapePath.OddEvenFill
            strokeColor: "#00000000"
            strokeWidth: 0

            PathSvg {
                id: background_ShapePath0_PathSvg0

                path: "M 20 40 C 31.045695304870605 40 40 31.045695304870605 40 20 C 40 8.954304695129395 31.045695304870605 0 20 0 C 8.954304695129395 0 0 8.954304695129395 0 20 C 0 31.045695304870605 8.954304695129395 40 20 40 Z"
            }
        }
    }
    Text {
        id: initial

        x: 0
        y: 0

        height: 40
        width: 42

        color: "#4f378a"
        font.family: theme.bodyFont
        font.letterSpacing: 0.10
        font.pixelSize: theme.headingTextSize
        font.weight: Font.Medium
        horizontalAlignment: Text.AlignHCenter
        lineHeight: 24
        lineHeightMode: Text.FixedHeight
        text: generic_avatar.letter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.Wrap
    }
    Icons_check_24px {
        id: check

        x: 8
        y: 8

        height: 24.21
        width: 24.21

        iconHeight: 13.53
        iconWidth: 17.74
        icon_ShapePath0FillColor: "#4f378a"
        icon_ShapePath0_PathSvg0Path: "M 5.638562013056799 10.671911079283428 L 1.4323358851525425 6.465685149630907 L 0 7.887934506025804 L 5.638562013056799 13.526495933532713 L 17.742809295654297 1.422248995660223 L 16.320560393862554 0 L 5.638562013056799 10.671911079283428 Z"
    }
}

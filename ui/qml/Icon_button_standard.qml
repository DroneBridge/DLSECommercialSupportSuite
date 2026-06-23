import QtQuick
import QtQuick.Shapes

Rectangle {
    enum Type { Type_Round, Type_Square}
    enum Size { Size_Large, Size_Medium, Size_Small, Size_XLarge, Size_XSmall}
    enum Width { Width_Narrow, Width_Default, Width_Wide}
    enum State_1 { State_1_Enabled, State_1_Hovered, State_1_Focused, State_1_Pressed, State_1_Disabled}

    id: icon_button_standard

    property alias state_layerOpacity: state_layer.opacity

    property int _size: Icon_button_standard.Size.Size_Small
    property int _state: Icon_button_standard.State_1.State_1_Enabled
    property int _width: Icon_button_standard.Width.Width_Default
    property bool show_focus_indicator: false
    property int type_1: Icon_button_standard.Type.Type_Round

    height: 48
    width: 48

    color: "transparent"
    visible: true

    states: [
        State {
            name: "Type=Round, Size=Small, Width=Default, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 4
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 8
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XLarge, Width=Wide, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 184
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 184
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 28
                target: content
            }
            PropertyChanges {
                width: 184
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 72
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XLarge, Width=Wide, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 184
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 184
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 28
                target: content
            }
            PropertyChanges {
                width: 184
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 72
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XLarge, Width=Wide, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 184
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 184
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 28
                target: content
            }
            PropertyChanges {
                width: 184
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 72
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: icon_button_standard.show_focus_indicator
            }
        },
        State {
            name: "Type=Square, Size=XLarge, Width=Wide, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 184
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 184
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 16
                target: content
            }
            PropertyChanges {
                width: 184
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 72
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: true
            }
            PropertyChanges {
                x: 66
    
                target: ripple
            }
            PropertyChanges {
                y: 54
    
                target: ripple
            }
            PropertyChanges {
                width: 118
    
                target: ripple
            }
            PropertyChanges {
                height: 82
    
                target: ripple
            }
            PropertyChanges {
                path: "M 118 9.148521508489337 L 118 82 L 0 82 C 0 36.71264757428851 36.19860175637638 0 80.85184792911305 0 C 94.24463483025046 0 106.87687353246352 3.302568418639048 118 9.148521508489337 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XLarge, Width=Wide, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 184
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 184
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 28
                target: content
            }
            PropertyChanges {
                width: 184
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 72
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XLarge, Width=Default, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 136
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 28
                target: content
            }
            PropertyChanges {
                width: 136
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 48
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XLarge, Width=Default, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 136
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 28
                target: content
            }
            PropertyChanges {
                width: 136
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 48
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XLarge, Width=Default, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 136
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 28
                target: content
            }
            PropertyChanges {
                width: 136
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 48
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XLarge, Width=Default, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 136
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 16
                target: content
            }
            PropertyChanges {
                width: 136
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 48
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                x: 18
    
                target: ripple
            }
            PropertyChanges {
                y: 54
    
                target: ripple
            }
            PropertyChanges {
                width: 118
    
                target: ripple
            }
            PropertyChanges {
                height: 82
    
                target: ripple
            }
            PropertyChanges {
                path: "M 118 9.148521508489337 L 118 82 L 0 82 C 0 36.71264757428851 36.19860175637638 0 80.85184792911305 0 C 94.24463483025046 0 106.87687353246352 3.302568418639048 118 9.148521508489337 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XLarge, Width=Default, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 136
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 28
                target: content
            }
            PropertyChanges {
                width: 136
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 48
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XLarge, Width=Narrow, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 104
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 104
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 28
                target: content
            }
            PropertyChanges {
                width: 104
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 32
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XLarge, Width=Narrow, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 104
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 104
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 28
                target: content
            }
            PropertyChanges {
                width: 104
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 32
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XLarge, Width=Narrow, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 104
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 104
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 28
                target: content
            }
            PropertyChanges {
                width: 104
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 32
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XLarge, Width=Narrow, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 104
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 104
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 16
                target: content
            }
            PropertyChanges {
                width: 104
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 32
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                x: -14
    
                target: ripple
            }
            PropertyChanges {
                y: 54
    
                target: ripple
            }
            PropertyChanges {
                width: 118
    
                target: ripple
            }
            PropertyChanges {
                height: 82
    
                target: ripple
            }
            PropertyChanges {
                path: "M 118 9.148521508489337 L 118 82 L 0 82 C 0 36.71264757428851 36.19860175637638 0 80.85184792911305 0 C 94.24463483025046 0 106.87687353246352 3.302568418639048 118 9.148521508489337 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XLarge, Width=Narrow, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 104
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 104
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 28
                target: content
            }
            PropertyChanges {
                width: 104
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 32
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Large, Width=Wide, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 128
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 128
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 28
                target: content
            }
            PropertyChanges {
                width: 128
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 48
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Large, Width=Wide, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 128
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 128
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 28
                target: content
            }
            PropertyChanges {
                width: 128
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 48
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Large, Width=Wide, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 128
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 128
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 28
                target: content
            }
            PropertyChanges {
                width: 128
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 48
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Large, Width=Wide, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 128
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 128
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 16
                target: content
            }
            PropertyChanges {
                width: 128
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 48
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                x: 46
    
                target: ripple
            }
            PropertyChanges {
                y: 38
    
                target: ripple
            }
            PropertyChanges {
                width: 82
    
                target: ripple
            }
            PropertyChanges {
                height: 58
    
                target: ripple
            }
            PropertyChanges {
                path: "M 82 6.470905457224165 L 82 58.00000000000001 L 0 58.00000000000001 C 0 25.96748243059431 25.154960542566634 0 56.185182459214154 0 C 65.49203437356388 0 74.27036974289838 2.3359630278178622 82 6.470905457224165 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Large, Width=Wide, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 128
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 128
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 28
                target: content
            }
            PropertyChanges {
                width: 128
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 48
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Large, Width=Default, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 96
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 28
                target: content
            }
            PropertyChanges {
                width: 96
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 32
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Large, Width=Default, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 96
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 28
                target: content
            }
            PropertyChanges {
                width: 96
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 32
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Large, Width=Default, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 96
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 28
                target: content
            }
            PropertyChanges {
                width: 96
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 32
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Large, Width=Default, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 96
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 16
                target: content
            }
            PropertyChanges {
                width: 96
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 32
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                x: 14
    
                target: ripple
            }
            PropertyChanges {
                y: 38
    
                target: ripple
            }
            PropertyChanges {
                width: 82
    
                target: ripple
            }
            PropertyChanges {
                height: 58
    
                target: ripple
            }
            PropertyChanges {
                path: "M 82 6.470905457224165 L 82 58.00000000000001 L 0 58.00000000000001 C 0 25.96748243059431 25.154960542566634 0 56.185182459214154 0 C 65.49203437356388 0 74.27036974289838 2.3359630278178622 82 6.470905457224165 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Large, Width=Default, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 96
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 28
                target: content
            }
            PropertyChanges {
                width: 96
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 32
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Large, Width=Narrow, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 64
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 64
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 28
                target: content
            }
            PropertyChanges {
                width: 64
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 16
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Large, Width=Narrow, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 64
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 64
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 28
                target: content
            }
            PropertyChanges {
                width: 64
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 16
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Large, Width=Narrow, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 64
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 64
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 28
                target: content
            }
            PropertyChanges {
                width: 64
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 16
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Large, Width=Narrow, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 64
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 64
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 16
                target: content
            }
            PropertyChanges {
                width: 64
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 16
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                x: -18
    
                target: ripple
            }
            PropertyChanges {
                y: 38
    
                target: ripple
            }
            PropertyChanges {
                width: 82
    
                target: ripple
            }
            PropertyChanges {
                height: 58
    
                target: ripple
            }
            PropertyChanges {
                path: "M 82 6.470905457224165 L 82 58.00000000000001 L 0 58.00000000000001 C 0 25.96748243059431 25.154960542566634 0 56.185182459214154 0 C 65.49203437356388 0 74.27036974289838 2.3359630278178622 82 6.470905457224165 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Large, Width=Narrow, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 64
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 64
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 28
                target: content
            }
            PropertyChanges {
                width: 64
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 16
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Medium, Width=Wide, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 72
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 72
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 16
                target: content
            }
            PropertyChanges {
                width: 72
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 24
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Medium, Width=Wide, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 72
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 72
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 16
                target: content
            }
            PropertyChanges {
                width: 72
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 24
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Medium, Width=Wide, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 72
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 72
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 16
                target: content
            }
            PropertyChanges {
                width: 72
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 24
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Medium, Width=Wide, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 72
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 72
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 72
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 24
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                x: 26
    
                target: ripple
            }
            PropertyChanges {
                y: 18
    
                target: ripple
            }
            PropertyChanges {
                width: 46
    
                target: ripple
            }
            PropertyChanges {
                height: 38
    
                target: ripple
            }
            PropertyChanges {
                path: "M 46 4.239558747836522 L 46 38 L 0 38 C 0 17.013178144182476 14.111319328756892 0 31.518516989315255 0 C 36.739433916877296 0 41.663865953333236 1.5304585354668756 46 4.239558747836522 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Medium, Width=Wide, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 72
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 72
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 16
                target: content
            }
            PropertyChanges {
                width: 72
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 24
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Medium, Width=Default, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 56
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 16
                target: content
            }
            PropertyChanges {
                width: 56
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 16
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Medium, Width=Default, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 56
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 16
                target: content
            }
            PropertyChanges {
                width: 56
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 16
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Medium, Width=Default, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 56
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 16
                target: content
            }
            PropertyChanges {
                width: 56
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 16
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Medium, Width=Default, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 56
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 56
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 16
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                x: 10
    
                target: ripple
            }
            PropertyChanges {
                y: 18
    
                target: ripple
            }
            PropertyChanges {
                width: 46
    
                target: ripple
            }
            PropertyChanges {
                height: 38
    
                target: ripple
            }
            PropertyChanges {
                path: "M 46 4.239558747836522 L 46 38 L 0 38 C 0 17.013178144182476 14.111319328756892 0 31.518516989315255 0 C 36.739433916877296 0 41.663865953333236 1.5304585354668756 46 4.239558747836522 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Medium, Width=Default, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 56
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 16
                target: content
            }
            PropertyChanges {
                width: 56
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 16
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Medium, Width=Narrow, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 48
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 16
                target: content
            }
            PropertyChanges {
                width: 48
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 12
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Medium, Width=Narrow, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 48
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 16
                target: content
            }
            PropertyChanges {
                width: 48
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 12
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Medium, Width=Narrow, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 48
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 16
                target: content
            }
            PropertyChanges {
                width: 48
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 12
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Medium, Width=Narrow, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 48
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 48
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 12
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                x: 2
    
                target: ripple
            }
            PropertyChanges {
                y: 18
    
                target: ripple
            }
            PropertyChanges {
                width: 46
    
                target: ripple
            }
            PropertyChanges {
                height: 38
    
                target: ripple
            }
            PropertyChanges {
                path: "M 46 4.239558747836522 L 46 38 L 0 38 C 0 17.013178144182476 14.111319328756892 0 31.518516989315255 0 C 36.739433916877296 0 41.663865953333236 1.5304585354668756 46 4.239558747836522 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Medium, Width=Narrow, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 48
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 16
                target: content
            }
            PropertyChanges {
                width: 48
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 12
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Small, Width=Wide, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 52
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 52
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 52
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 14
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Small, Width=Wide, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 52
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 52
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 52
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 14
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Small, Width=Wide, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 52
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 52
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 52
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 14
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Small, Width=Wide, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 52
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 52
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 8
                target: content
            }
            PropertyChanges {
                width: 52
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 14
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                x: 14
    
                target: ripple
            }
            PropertyChanges {
                y: 12
    
                target: ripple
            }
            PropertyChanges {
                width: 38
    
                target: ripple
            }
            PropertyChanges {
                height: 28
    
                target: ripple
            }
            PropertyChanges {
                path: "M 38 3.1238853931427 L 38 28 L 0 28 C 0 12.536026000976562 11.657176836799175 0 26.037035773782172 0 C 30.349967148724726 0 34.417976222318764 1.1277062892913818 38 3.1238853931427 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Small, Width=Wide, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 52
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 52
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 52
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 14
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Small, Width=Default, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 4
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 8
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Small, Width=Default, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 4
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 8
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Small, Width=Default, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 4
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 8
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Small, Width=Default, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 4
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 8
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 8
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                x: 2
    
                target: ripple
            }
            PropertyChanges {
                y: 12
    
                target: ripple
            }
            PropertyChanges {
                width: 38
    
                target: ripple
            }
            PropertyChanges {
                height: 28
    
                target: ripple
            }
            PropertyChanges {
                path: "M 38 3.1238853931427 L 38 28 L 0 28 C 0 12.536026000976562 11.657176836799175 0 26.037035773782172 0 C 30.349967148724726 0 34.417976222318764 1.1277062892913818 38 3.1238853931427 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Small, Width=Default, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 4
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 8
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Small, Width=Narrow, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 8
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 4
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Small, Width=Narrow, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 8
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 4
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Small, Width=Narrow, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 8
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 4
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Small, Width=Narrow, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 8
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 8
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 4
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                x: -6
    
                target: ripple
            }
            PropertyChanges {
                y: 12
    
                target: ripple
            }
            PropertyChanges {
                width: 38
    
                target: ripple
            }
            PropertyChanges {
                height: 28
    
                target: ripple
            }
            PropertyChanges {
                path: "M 38 3.1238853931427 L 38 28 L 0 28 C 0 12.536026000976562 11.657176836799175 0 26.037035773782172 0 C 30.349967148724726 0 34.417976222318764 1.1277062892913818 38 3.1238853931427 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=Small, Width=Narrow, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 8
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 4
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XSmall, Width=Wide, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 4
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 10
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XSmall, Width=Wide, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 4
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 10
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XSmall, Width=Wide, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 4
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 10
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XSmall, Width=Wide, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 4
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 8
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 10
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                x: 6
    
                target: ripple
            }
            PropertyChanges {
                y: 10
    
                target: ripple
            }
            PropertyChanges {
                width: 34
    
                target: ripple
            }
            PropertyChanges {
                height: 22
    
                target: ripple
            }
            PropertyChanges {
                path: "M 34 2.454481380326407 L 34 22 L 0 22 C 0 9.849734715053014 10.430105590820311 0 23.296295166015625 0 C 27.155233764648436 0 30.795031356811524 0.8860549415860857 34 2.454481380326407 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XSmall, Width=Wide, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 4
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 10
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XSmall, Width=Default, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 8
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 6
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XSmall, Width=Default, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 8
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 6
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XSmall, Width=Default, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 8
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 6
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XSmall, Width=Default, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 8
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 8
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 6
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                x: -2
    
                target: ripple
            }
            PropertyChanges {
                y: 10
    
                target: ripple
            }
            PropertyChanges {
                width: 34
    
                target: ripple
            }
            PropertyChanges {
                height: 22
    
                target: ripple
            }
            PropertyChanges {
                path: "M 34 2.454481380326407 L 34 22 L 0 22 C 0 9.849734715053014 10.430105590820311 0 23.296295166015625 0 C 27.155233764648436 0 30.795031356811524 0.8860549415860857 34 2.454481380326407 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XSmall, Width=Default, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 8
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 6
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XSmall, Width=Narrow, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 10
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 28
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 28
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 4
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XSmall, Width=Narrow, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 10
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 28
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 28
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 4
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XSmall, Width=Narrow, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 10
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 28
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 28
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 4
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XSmall, Width=Narrow, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 10
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 28
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 8
                target: content
            }
            PropertyChanges {
                width: 28
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 4
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                x: -6
    
                target: ripple
            }
            PropertyChanges {
                y: 10
    
                target: ripple
            }
            PropertyChanges {
                width: 34
    
                target: ripple
            }
            PropertyChanges {
                height: 22
    
                target: ripple
            }
            PropertyChanges {
                path: "M 34 2.454481380326407 L 34 22 L 0 22 C 0 9.849734715053014 10.430105590820311 0 23.296295166015625 0 C 27.155233764648436 0 30.795031356811524 0.8860549415860857 34 2.454481380326407 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Square, Size=XSmall, Width=Narrow, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Square && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 10
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 28
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 0
                target: content
            }
            PropertyChanges {
                width: 28
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 4
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XLarge, Width=Wide, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 184
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 184
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 184
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 72
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XLarge, Width=Wide, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 184
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 184
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 184
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 72
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XLarge, Width=Wide, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 184
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 184
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 184
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 72
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XLarge, Width=Wide, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 184
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 184
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 16
                target: content
            }
            PropertyChanges {
                width: 184
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 72
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                x: 66
    
                target: ripple
            }
            PropertyChanges {
                y: 54
    
                target: ripple
            }
            PropertyChanges {
                width: 118
    
                target: ripple
            }
            PropertyChanges {
                height: 82
    
                target: ripple
            }
            PropertyChanges {
                path: "M 118 9.148521508489337 L 118 82 L 0 82 C 0 36.71264757428851 36.19860175637638 0 80.85184792911305 0 C 94.24463483025046 0 106.87687353246352 3.302568418639048 118 9.148521508489337 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XLarge, Width=Wide, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 184
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 184
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 184
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 72
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XLarge, Width=Default, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 136
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 136
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 48
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XLarge, Width=Default, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 136
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 136
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 48
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XLarge, Width=Default, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 136
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 136
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 48
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XLarge, Width=Default, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 136
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 16
                target: content
            }
            PropertyChanges {
                width: 136
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 48
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                x: 18
    
                target: ripple
            }
            PropertyChanges {
                y: 54
    
                target: ripple
            }
            PropertyChanges {
                width: 118
    
                target: ripple
            }
            PropertyChanges {
                height: 82
    
                target: ripple
            }
            PropertyChanges {
                path: "M 118 9.148521508489337 L 118 82 L 0 82 C 0 36.71264757428851 36.19860175637638 0 80.85184792911305 0 C 94.24463483025046 0 106.87687353246352 3.302568418639048 118 9.148521508489337 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XLarge, Width=Default, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 136
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 136
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 48
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XLarge, Width=Narrow, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 104
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 104
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 104
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 32
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XLarge, Width=Narrow, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 104
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 104
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 104
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 32
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XLarge, Width=Narrow, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 104
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 104
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 104
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 32
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XLarge, Width=Narrow, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 104
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 104
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 16
                target: content
            }
            PropertyChanges {
                width: 104
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 32
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                x: -14
    
                target: ripple
            }
            PropertyChanges {
                y: 54
    
                target: ripple
            }
            PropertyChanges {
                width: 118
    
                target: ripple
            }
            PropertyChanges {
                height: 82
    
                target: ripple
            }
            PropertyChanges {
                path: "M 118 9.148521508489337 L 118 82 L 0 82 C 0 36.71264757428851 36.19860175637638 0 80.85184792911305 0 C 94.24463483025046 0 106.87687353246352 3.302568418639048 118 9.148521508489337 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XLarge, Width=Narrow, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XLarge && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 104
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 136
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 104
    
                target: content
            }
            PropertyChanges {
                height: 136
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 104
    
                target: state_layer
            }
            PropertyChanges {
                height: 136
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 32
    
                target: icon
            }
            PropertyChanges {
                y: 48
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 40
    
                target: icon
            }
            PropertyChanges {
                iconX: 3.33
                target: icon
            }
            PropertyChanges {
                iconY: 3.33
                target: icon
            }
            PropertyChanges {
                iconWidth: 33.33
                target: icon
            }
            PropertyChanges {
                iconHeight: 33.33
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 9.999999618530275 26.666665649414064 L 16.66666603088379 21.583332192103082 L 23.333332443237307 26.666665649414064 L 20.833332538604736 18.416666282018014 L 27.499998950958254 13.666665827433281 L 19.333333231608048 13.666665827433281 L 16.66666603088379 4.999999809265137 L 14.000000419616663 13.666665827433281 L 5.833333110809327 13.666665827433281 L 12.499999523162842 18.416666282018014 L 9.999999618530275 26.666665649414064 Z M 16.66666603088379 33.33333206176758 C 14.361110576523675 33.33333206176758 12.194443873299498 32.89583150227867 10.1666661198934 32.02083147605263 C 8.1388883664873 31.145831449826588 6.374999736944836 29.95833352168396 4.874999734560652 28.458333519299778 C 3.3749997321764686 26.958333516915594 2.1875000158945683 25.19444449000885 1.3124999896685268 23.16666673660275 C 0.4374999634424853 21.13888898319665 0 18.972221485243903 0 16.66666603088379 C 0 14.361110576523675 0.4374999634424853 12.194443873299498 1.3124999896685268 10.1666661198934 C 2.1875000158945683 8.1388883664873 3.3749997321764686 6.374999736944836 4.874999734560652 4.874999734560652 C 6.374999736944836 3.3749997321764686 8.1388883664873 2.1875000158945683 10.1666661198934 1.3124999896685268 C 12.194443873299498 0.4374999634424853 14.361110576523675 0 16.66666603088379 0 C 18.972221485243903 0 21.13888898319665 0.4374999634424853 23.16666673660275 1.3124999896685268 C 25.19444449000885 2.1875000158945683 26.958333516915594 3.3749997321764686 28.458333519299778 4.874999734560652 C 29.95833352168396 6.374999736944836 31.145831449826588 8.1388883664873 32.02083147605263 10.1666661198934 C 32.89583150227867 12.194443873299498 33.33333206176758 14.361110576523675 33.33333206176758 16.66666603088379 C 33.33333206176758 18.972221485243903 32.89583150227867 21.13888898319665 32.02083147605263 23.16666673660275 C 31.145831449826588 25.19444449000885 29.95833352168396 26.958333516915594 28.458333519299778 28.458333519299778 C 26.958333516915594 29.95833352168396 25.19444449000885 31.145831449826588 23.16666673660275 32.02083147605263 C 21.13888898319665 32.89583150227867 18.972221485243903 33.33333206176758 16.66666603088379 33.33333206176758 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Large, Width=Wide, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 128
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 128
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 128
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 48
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Large, Width=Wide, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 128
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 128
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 128
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 48
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Large, Width=Wide, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 128
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 128
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 128
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 48
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Large, Width=Wide, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 128
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 128
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 16
                target: content
            }
            PropertyChanges {
                width: 128
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 48
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                x: 46
    
                target: ripple
            }
            PropertyChanges {
                y: 38
    
                target: ripple
            }
            PropertyChanges {
                width: 82
    
                target: ripple
            }
            PropertyChanges {
                height: 58
    
                target: ripple
            }
            PropertyChanges {
                path: "M 82 6.470905457224165 L 82 58.00000000000001 L 0 58.00000000000001 C 0 25.96748243059431 25.154960542566634 0 56.185182459214154 0 C 65.49203437356388 0 74.27036974289838 2.3359630278178622 82 6.470905457224165 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Large, Width=Wide, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 128
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 128
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 128
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 48
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Large, Width=Default, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 96
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 96
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 32
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Large, Width=Default, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 96
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 96
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 32
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Large, Width=Default, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 96
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 96
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 32
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Large, Width=Default, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 96
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 16
                target: content
            }
            PropertyChanges {
                width: 96
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 32
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                x: 14
    
                target: ripple
            }
            PropertyChanges {
                y: 38
    
                target: ripple
            }
            PropertyChanges {
                width: 82
    
                target: ripple
            }
            PropertyChanges {
                height: 58
    
                target: ripple
            }
            PropertyChanges {
                path: "M 82 6.470905457224165 L 82 58.00000000000001 L 0 58.00000000000001 C 0 25.96748243059431 25.154960542566634 0 56.185182459214154 0 C 65.49203437356388 0 74.27036974289838 2.3359630278178622 82 6.470905457224165 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Large, Width=Default, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 96
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 96
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 32
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Large, Width=Narrow, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 64
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 64
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 64
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 16
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Large, Width=Narrow, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 64
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 64
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 64
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 16
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Large, Width=Narrow, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 64
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 64
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 64
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 16
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Large, Width=Narrow, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 64
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 64
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 16
                target: content
            }
            PropertyChanges {
                width: 64
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 16
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                x: -18
    
                target: ripple
            }
            PropertyChanges {
                y: 38
    
                target: ripple
            }
            PropertyChanges {
                width: 82
    
                target: ripple
            }
            PropertyChanges {
                height: 58
    
                target: ripple
            }
            PropertyChanges {
                path: "M 82 6.470905457224165 L 82 58.00000000000001 L 0 58.00000000000001 C 0 25.96748243059431 25.154960542566634 0 56.185182459214154 0 C 65.49203437356388 0 74.27036974289838 2.3359630278178622 82 6.470905457224165 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Large, Width=Narrow, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Large && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 64
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 96
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 64
    
                target: content
            }
            PropertyChanges {
                height: 96
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 64
    
                target: state_layer
            }
            PropertyChanges {
                height: 96
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 16
    
                target: icon
            }
            PropertyChanges {
                y: 32
    
                target: icon
            }
            PropertyChanges {
                width: 32
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                iconX: 2.67
                target: icon
            }
            PropertyChanges {
                iconY: 2.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 26.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 26.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 7.999999809265137 21.333332824707032 L 13.333333015441895 17.266666000684108 L 18.66666622161865 21.333332824707032 L 16.666666269302368 14.733333236376438 L 21.999999475479125 10.933332818349209 L 15.466666806538887 10.933332818349209 L 13.333333015441895 3.9999999046325687 L 11.200000495910627 10.933332818349209 L 4.666666555404663 10.933332818349209 L 9.999999761581421 14.733333236376438 L 7.999999809265137 21.333332824707032 Z M 13.333333015441895 26.66666603088379 C 11.488888625568814 26.66666603088379 9.755555238193939 26.316665578285864 8.133333012262984 25.61666554729145 C 6.511110786332029 24.916665516297037 5.099999862511954 23.9666671601931 3.899999843438468 22.766667141119616 C 2.699999824364983 21.56666712204613 1.7500000377496066 20.155555880334624 1.0500000067551924 18.53333365440367 C 0.34999997576077824 16.911111428472715 0 15.177777405314975 0 13.333333015441895 C 0 11.488888625568814 0.34999997576077824 9.755555238193939 1.0500000067551924 8.133333012262984 C 1.7500000377496066 6.511110786332029 2.699999824364983 5.099999862511954 3.899999843438468 3.899999843438468 C 5.099999862511954 2.699999824364983 6.511110786332029 1.7500000377496066 8.133333012262984 1.0500000067551924 C 9.755555238193939 0.34999997576077824 11.488888625568814 0 13.333333015441895 0 C 15.177777405314975 0 16.911111428472715 0.34999997576077824 18.53333365440367 1.0500000067551924 C 20.155555880334624 1.7500000377496066 21.56666712204613 2.699999824364983 22.766667141119616 3.899999843438468 C 23.9666671601931 5.099999862511954 24.916665516297037 6.511110786332029 25.61666554729145 8.133333012262984 C 26.316665578285864 9.755555238193939 26.66666603088379 11.488888625568814 26.66666603088379 13.333333015441895 C 26.66666603088379 15.177777405314975 26.316665578285864 16.911111428472715 25.61666554729145 18.53333365440367 C 24.916665516297037 20.155555880334624 23.9666671601931 21.56666712204613 22.766667141119616 22.766667141119616 C 21.56666712204613 23.9666671601931 20.155555880334624 24.916665516297037 18.53333365440367 25.61666554729145 C 16.911111428472715 26.316665578285864 15.177777405314975 26.66666603088379 13.333333015441895 26.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Medium, Width=Wide, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 72
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 72
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 72
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 24
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Medium, Width=Wide, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 72
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 72
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 72
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 24
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Medium, Width=Wide, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 72
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 72
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 72
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 24
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Medium, Width=Wide, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 72
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 72
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 72
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 24
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                x: 26
    
                target: ripple
            }
            PropertyChanges {
                y: 18
    
                target: ripple
            }
            PropertyChanges {
                width: 46
    
                target: ripple
            }
            PropertyChanges {
                height: 38
    
                target: ripple
            }
            PropertyChanges {
                path: "M 46 4.239558747836522 L 46 38 L 0 38 C 0 17.013178144182476 14.111319328756892 0 31.518516989315255 0 C 36.739433916877296 0 41.663865953333236 1.5304585354668756 46 4.239558747836522 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Medium, Width=Wide, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 72
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 72
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 72
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 24
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Medium, Width=Default, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 56
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 56
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 16
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Medium, Width=Default, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 56
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 56
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 16
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Medium, Width=Default, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 56
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 56
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 16
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Medium, Width=Default, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 56
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 56
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 16
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                x: 10
    
                target: ripple
            }
            PropertyChanges {
                y: 18
    
                target: ripple
            }
            PropertyChanges {
                width: 46
    
                target: ripple
            }
            PropertyChanges {
                height: 38
    
                target: ripple
            }
            PropertyChanges {
                path: "M 46 4.239558747836522 L 46 38 L 0 38 C 0 17.013178144182476 14.111319328756892 0 31.518516989315255 0 C 36.739433916877296 0 41.663865953333236 1.5304585354668756 46 4.239558747836522 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Medium, Width=Default, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 56
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 56
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 16
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Medium, Width=Narrow, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 48
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 48
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 12
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Medium, Width=Narrow, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 48
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 48
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 12
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Medium, Width=Narrow, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 48
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 48
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 12
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Medium, Width=Narrow, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 48
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 12
                target: content
            }
            PropertyChanges {
                width: 48
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 12
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                x: 2
    
                target: ripple
            }
            PropertyChanges {
                y: 18
    
                target: ripple
            }
            PropertyChanges {
                width: 46
    
                target: ripple
            }
            PropertyChanges {
                height: 38
    
                target: ripple
            }
            PropertyChanges {
                path: "M 46 4.239558747836522 L 46 38 L 0 38 C 0 17.013178144182476 14.111319328756892 0 31.518516989315255 0 C 36.739433916877296 0 41.663865953333236 1.5304585354668756 46 4.239558747836522 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Medium, Width=Narrow, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Medium && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 56
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 0
    
                target: content
            }
            PropertyChanges {
                width: 48
    
                target: content
            }
            PropertyChanges {
                height: 56
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 48
    
                target: state_layer
            }
            PropertyChanges {
                height: 56
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 12
    
                target: icon
            }
            PropertyChanges {
                y: 16
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Small, Width=Wide, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 52
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 52
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 52
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 14
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Small, Width=Wide, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 52
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 52
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 52
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 14
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Small, Width=Wide, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 52
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 52
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 52
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 14
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Small, Width=Wide, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 52
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 52
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 8
                target: content
            }
            PropertyChanges {
                width: 52
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 14
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                x: 14
    
                target: ripple
            }
            PropertyChanges {
                y: 12
    
                target: ripple
            }
            PropertyChanges {
                width: 38
    
                target: ripple
            }
            PropertyChanges {
                height: 28
    
                target: ripple
            }
            PropertyChanges {
                path: "M 38 3.1238853931427 L 38 28 L 0 28 C 0 12.536026000976562 11.657176836799175 0 26.037035773782172 0 C 30.349967148724726 0 34.417976222318764 1.1277062892913818 38 3.1238853931427 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Small, Width=Wide, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 52
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 0
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 52
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 52
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 14
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Small, Width=Default, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 4
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 8
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Small, Width=Default, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 4
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 8
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Small, Width=Default, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 4
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 8
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 8
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                x: 2
    
                target: ripple
            }
            PropertyChanges {
                y: 12
    
                target: ripple
            }
            PropertyChanges {
                width: 38
    
                target: ripple
            }
            PropertyChanges {
                height: 28
    
                target: ripple
            }
            PropertyChanges {
                path: "M 38 3.1238853931427 L 38 28 L 0 28 C 0 12.536026000976562 11.657176836799175 0 26.037035773782172 0 C 30.349967148724726 0 34.417976222318764 1.1277062892913818 38 3.1238853931427 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Small, Width=Default, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 4
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 8
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Small, Width=Narrow, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 8
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 4
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Small, Width=Narrow, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 8
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 4
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Small, Width=Narrow, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 8
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 4
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Small, Width=Narrow, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 8
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 8
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 4
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                x: -6
    
                target: ripple
            }
            PropertyChanges {
                y: 12
    
                target: ripple
            }
            PropertyChanges {
                width: 38
    
                target: ripple
            }
            PropertyChanges {
                height: 28
    
                target: ripple
            }
            PropertyChanges {
                path: "M 38 3.1238853931427 L 38 28 L 0 28 C 0 12.536026000976562 11.657176836799175 0 26.037035773782172 0 C 30.349967148724726 0 34.417976222318764 1.1277062892913818 38 3.1238853931427 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=Small, Width=Narrow, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_Small && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 8
    
                target: content
            }
            PropertyChanges {
                y: 4
    
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: content
            }
            PropertyChanges {
                height: 40
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: state_layer
            }
            PropertyChanges {
                height: 40
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 4
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                iconX: 2
                target: icon
            }
            PropertyChanges {
                iconY: 2
                target: icon
            }
            PropertyChanges {
                iconWidth: 20
                target: icon
            }
            PropertyChanges {
                iconHeight: 20
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 6 16 L 10 12.949999809265137 L 14 16 L 12.5 11.050000190734863 L 16.5 8.199999809265137 L 11.600000381469727 8.199999809265137 L 10 3 L 8.40000057220459 8.199999809265137 L 3.5 8.199999809265137 L 7.5 11.050000190734863 L 6 16 Z M 10 20 C 8.616666674613953 20 7.316666603088379 19.73749965429306 6.099999904632568 19.212499618530273 C 4.883333206176758 18.687499582767487 3.824999988079071 17.97500079870224 2.924999952316284 17.075000762939453 C 2.0249999165534973 16.175000727176666 1.3125000596046448 15.1166672706604 0.7875000238418579 13.90000057220459 C 0.26249998807907104 12.68333387374878 0 11.383333325386047 0 10 C 0 8.616666674613953 0.26249998807907104 7.316666603088379 0.7875000238418579 6.099999904632568 C 1.3125000596046448 4.883333206176758 2.0249999165534973 3.824999988079071 2.924999952316284 2.924999952316284 C 3.824999988079071 2.0249999165534973 4.883333206176758 1.3125000596046448 6.099999904632568 0.7875000238418579 C 7.316666603088379 0.26249998807907104 8.616666674613953 0 10 0 C 11.383333325386047 0 12.68333387374878 0.26249998807907104 13.90000057220459 0.7875000238418579 C 15.1166672706604 1.3125000596046448 16.175000727176666 2.0249999165534973 17.075000762939453 2.924999952316284 C 17.97500079870224 3.824999988079071 18.687499582767487 4.883333206176758 19.212499618530273 6.099999904632568 C 19.73749965429306 7.316666603088379 20 8.616666674613953 20 10 C 20 11.383333325386047 19.73749965429306 12.68333387374878 19.212499618530273 13.90000057220459 C 18.687499582767487 15.1166672706604 17.97500079870224 16.175000727176666 17.075000762939453 17.075000762939453 C 16.175000727176666 17.97500079870224 15.1166672706604 18.687499582767487 13.90000057220459 19.212499618530273 C 12.68333387374878 19.73749965429306 11.383333325386047 20 10 20 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XSmall, Width=Wide, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 4
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 10
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XSmall, Width=Wide, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 4
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 10
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XSmall, Width=Wide, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 4
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 10
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XSmall, Width=Wide, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 4
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 8
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 10
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                x: 6
    
                target: ripple
            }
            PropertyChanges {
                y: 10
    
                target: ripple
            }
            PropertyChanges {
                width: 34
    
                target: ripple
            }
            PropertyChanges {
                height: 22
    
                target: ripple
            }
            PropertyChanges {
                path: "M 34 2.454481380326407 L 34 22 L 0 22 C 0 9.849734715053014 10.430105590820311 0 23.296295166015625 0 C 27.155233764648436 0 30.795031356811524 0.8860549415860857 34 2.454481380326407 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XSmall, Width=Wide, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Wide && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 4
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 40
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 10
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XSmall, Width=Default, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 8
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 6
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XSmall, Width=Default, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 8
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 6
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XSmall, Width=Default, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 8
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 6
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XSmall, Width=Default, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 8
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 8
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 6
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                x: -2
    
                target: ripple
            }
            PropertyChanges {
                y: 10
    
                target: ripple
            }
            PropertyChanges {
                width: 34
    
                target: ripple
            }
            PropertyChanges {
                height: 22
    
                target: ripple
            }
            PropertyChanges {
                path: "M 34 2.454481380326407 L 34 22 L 0 22 C 0 9.849734715053014 10.430105590820311 0 23.296295166015625 0 C 27.155233764648436 0 30.795031356811524 0.8860549415860857 34 2.454481380326407 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XSmall, Width=Default, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Default && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 8
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 32
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 6
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XSmall, Width=Narrow, State=Enabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Enabled
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 10
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 28
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 28
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 4
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XSmall, Width=Narrow, State=Hovered"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Hovered
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 10
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 28
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 28
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 4
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XSmall, Width=Narrow, State=Focused"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Focused
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 10
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 28
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 28
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1a49454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 4
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XSmall, Width=Narrow, State=Pressed"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Pressed
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 10
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 28
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 8
                target: content
            }
            PropertyChanges {
                width: 28
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "#1449454f"
                target: state_layer
            }
            PropertyChanges {
                opacity: 1
                target: state_layer
            }
            PropertyChanges {
                x: 4
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#49454f"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                x: -6
    
                target: ripple
            }
            PropertyChanges {
                y: 10
    
                target: ripple
            }
            PropertyChanges {
                width: 34
    
                target: ripple
            }
            PropertyChanges {
                height: 22
    
                target: ripple
            }
            PropertyChanges {
                path: "M 34 2.454481380326407 L 34 22 L 0 22 C 0 9.849734715053014 10.430105590820311 0 23.296295166015625 0 C 27.155233764648436 0 30.795031356811524 0.8860549415860857 34 2.454481380326407 Z"
                target: ripple_ShapePath0_PathSvg0
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        },
        State {
            name: "Type=Round, Size=XSmall, Width=Narrow, State=Disabled"
            when: icon_button_standard.type_1 === Icon_button_standard.Type.Type_Round && icon_button_standard._size === Icon_button_standard.Size.Size_XSmall && icon_button_standard._width === Icon_button_standard.Width.Width_Narrow && icon_button_standard._state === Icon_button_standard.State_1.State_1_Disabled
    
            PropertyChanges {
                width: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                height: 48
    
                target: icon_button_standard
            }
            PropertyChanges {
                x: 10
    
                target: content
            }
            PropertyChanges {
                y: 8
    
                target: content
            }
            PropertyChanges {
                width: 28
    
                target: content
            }
            PropertyChanges {
                height: 32
    
                target: content
            }
            PropertyChanges {
                radius: 100
                target: content
            }
            PropertyChanges {
                width: 28
    
                target: state_layer
            }
            PropertyChanges {
                height: 32
    
                target: state_layer
            }
            PropertyChanges {
                color: "transparent"
                target: state_layer
            }
            PropertyChanges {
                opacity: 0.38
                target: state_layer
            }
            PropertyChanges {
                x: 4
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 20
    
                target: icon
            }
            PropertyChanges {
                iconX: 1.67
                target: icon
            }
            PropertyChanges {
                iconY: 1.67
                target: icon
            }
            PropertyChanges {
                iconWidth: 16.67
                target: icon
            }
            PropertyChanges {
                iconHeight: 16.67
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0FillColor: "#1d1b20"
                target: icon
            }
            PropertyChanges {
                icon_ShapePath0_PathSvg0Path: "M 4.999999809265137 13.333332824707032 L 8.333333015441895 10.791666096051541 L 11.666666221618653 13.333332824707032 L 10.416666269302368 9.208333141009007 L 13.749999475479127 6.8333329137166405 L 9.666666615804024 6.8333329137166405 L 8.333333015441895 2.4999999046325687 L 7.000000209808332 6.8333329137166405 L 2.9166665554046634 6.8333329137166405 L 6.249999761581421 9.208333141009007 L 4.999999809265137 13.333332824707032 Z M 8.333333015441895 16.66666603088379 C 7.1805552882618375 16.66666603088379 6.097221936649749 16.447915751139334 5.0833330599467 16.010415738026314 C 4.06944418324365 15.572915724913294 3.187499868472418 14.97916676084198 2.437499867280326 14.229166759649889 C 1.6874998660882343 13.479166758457797 1.0937500079472842 12.597222245004424 0.6562499948342634 11.583333368301375 C 0.21874998172124266 10.569444491598325 0 9.486110742621952 0 8.333333015441895 C 0 7.1805552882618375 0.21874998172124266 6.097221936649749 0.6562499948342634 5.0833330599467 C 1.0937500079472842 4.06944418324365 1.6874998660882343 3.187499868472418 2.437499867280326 2.437499867280326 C 3.187499868472418 1.6874998660882343 4.06944418324365 1.0937500079472842 5.0833330599467 0.6562499948342634 C 6.097221936649749 0.21874998172124266 7.1805552882618375 0 8.333333015441895 0 C 9.486110742621952 0 10.569444491598325 0.21874998172124266 11.583333368301375 0.6562499948342634 C 12.597222245004424 1.0937500079472842 13.479166758457797 1.6874998660882343 14.229166759649889 2.437499867280326 C 14.97916676084198 3.187499868472418 15.572915724913294 4.06944418324365 16.010415738026314 5.0833330599467 C 16.447915751139334 6.097221936649749 16.66666603088379 7.1805552882618375 16.66666603088379 8.333333015441895 C 16.66666603088379 9.486110742621952 16.447915751139334 10.569444491598325 16.010415738026314 11.583333368301375 C 15.572915724913294 12.597222245004424 14.97916676084198 13.479166758457797 14.229166759649889 14.229166759649889 C 13.479166758457797 14.97916676084198 12.597222245004424 15.572915724913294 11.583333368301375 16.010415738026314 C 10.569444491598325 16.447915751139334 9.486110742621952 16.66666603088379 8.333333015441895 16.66666603088379 Z"
                target: icon
            }
            PropertyChanges {
                target: ripple
                visible: false
            }
            PropertyChanges {
                target: focus_indicator
                visible: false
            }
        }
    ]

    Rectangle {
        id: content

        x: 4
        y: 4

        height: 40
        width: 40

        clip: true
        color: "transparent"
        radius: 100

        Rectangle {
            id: state_layer

            height: 40
            width: 40

            color: "transparent"
            opacity: 1

            Stars_filled {
                id: icon

                x: 8
                y: 8

                clip: true
                icon_ShapePath0FillColor: "#49454f"
            }
            Shape {
                id: ripple

                x: 66
                y: 54

                height: 82
                width: 118

                ShapePath {
                    id: ripple_ShapePath0

                    fillColor: "#1a49454f"
                    fillRule: ShapePath.WindingFill
                    strokeColor: "#00000000"
                    strokeWidth: 0

                    PathSvg {
                        id: ripple_ShapePath0_PathSvg0

                        path: "M 118 9.148521508489337 L 118 82 L 0 82 C 0 36.71264757428851 36.19860175637638 0 80.85184792911305 0 C 94.24463483025046 0 106.87687353246352 3.302568418639048 118 9.148521508489337 Z"
                    }
                }
            }
        }
    }
    Focus_indicator {
        id: focus_indicator

        x: -2
        y: -2

        height: 140
        width: 188

        radius: 30
        visible: icon_button_standard.show_focus_indicator
    }
}
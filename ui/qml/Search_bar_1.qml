import QtQuick

Rectangle {
    enum Eigenschaft_1 { Eigenschaft_1_Standard, Eigenschaft_1_Variante2}

    id: search_bar

    property int eigenschaft_2: Search_bar_1.Eigenschaft_1.Eigenschaft_1_Standard

    height: 30
    width: 360

    color: "transparent"

    states: [
        State {
            name: "Eigenschaft 1=Standard"
            when: search_bar.eigenschaft_2 === Search_bar_1.Eigenschaft_1.Eigenschaft_1_Standard
    
            PropertyChanges {
                border.color: "#2e3a47"
                target: search_bar_1
            }
        },
        State {
            name: "Eigenschaft 1=Variante2"
            when: search_bar.eigenschaft_2 === Search_bar_1.Eigenschaft_1.Eigenschaft_1_Variante2
    
            PropertyChanges {
                border.color: "#ff8e00"
                target: search_bar_1
            }
        }
    ]

    Search_bar {
        id: search_bar_1

        height: 30

        _state: Search_bar.State_1.State_1_Enabled
        clip: true
        color: "#0a1c2e"
        contentHeight: 30
        contentWidth: 352
        contentX: 4
        placeholder_text: "Search for SYS ID, MAC, IP ..."
        radius: 5
        search_barBorderColor: "#2e3a47"
        search_barBorderWidth: 1
        show_1st_trailing_icon: true
        show_2nd_trailing_icon: false
        show_avatar_1: Search_bar.Show_avatar.Show_avatar_False
        show_leading_icon: false
        state_layerHeight: 30
        supporting_textColor: "#deceb9"
        supporting_textFontLetterSpacing: 0
        supporting_textFontPixelSize: 12
        supporting_textHeight: 16
        supporting_textLineHeightMode: Text.ProportionalHeight
        supporting_textWidth: 155
        supporting_textY: 7
        trailing_ElementsY: -9
    }
}

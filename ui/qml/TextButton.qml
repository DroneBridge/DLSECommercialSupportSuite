import QtQuick

Rectangle {
    enum Eigenschaft_1 { Eigenschaft_1_Standard, Eigenschaft_1_Variante2}

    id: textButton

    property alias configure_ColumnsTextButtonFontUnderline: configure_ColumnsTextButton.font.underline
    property alias configure_ColumnsTextButtonWrapMode: configure_ColumnsTextButton.wrapMode

    property int eigenschaft_2: TextButton.Eigenschaft_1.Eigenschaft_1_Standard

    height: 19
    width: 150

    color: "transparent"

    states: [
        State {
            name: "Eigenschaft 1=Standard"
            when: textButton.eigenschaft_2 === TextButton.Eigenschaft_1.Eigenschaft_1_Standard
    
            PropertyChanges {
                target: configure_ColumnsTextButton
                wrapMode: Text.NoWrap
            }
            PropertyChanges {
                font.underline: false
                target: configure_ColumnsTextButton
            }
        },
        State {
            name: "Eigenschaft 1=Variante2"
            when: textButton.eigenschaft_2 === TextButton.Eigenschaft_1.Eigenschaft_1_Variante2
    
            PropertyChanges {
                target: configure_ColumnsTextButton
                wrapMode: Text.Wrap
            }
            PropertyChanges {
                font.underline: true
                target: configure_ColumnsTextButton
            }
        }
    ]

    Text {
        id: configure_ColumnsTextButton

        height: 19
        width: 151

        color: "#e2d5c8"
        font.capitalization: Font.AllUppercase
        font.family: "JetBrains Mono"
        font.pixelSize: 11
        font.underline: false
        font.weight: Font.Bold
        horizontalAlignment: Text.AlignHCenter
        text: "Configure Columns"
        textFormat: Text.PlainText
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.NoWrap
    }
}
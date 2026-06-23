import QtQuick

Rectangle {
    enum Eigenschaft_1 { Eigenschaft_1_Standard, Eigenschaft_1_Variante2}

    id: settingsTab

    property int eigenschaft_2: SettingsTab.Eigenschaft_1.Eigenschaft_1_Standard

    height: 63
    width: 48

    color: "transparent"

    states: [
        State {
            name: "Eigenschaft 1=Standard"
            when: settingsTab.eigenschaft_2 === SettingsTab.Eigenschaft_1.Eigenschaft_1_Standard
    
            PropertyChanges {
                color: "transparent"
                target: settingsTab
            }
            PropertyChanges {
                y: 19.50
    
                target: settings_24dp_2
            }
            PropertyChanges {
                _vector_ShapePath0FillColor: "#deceb9"
                target: settings_24dp_2
            }
            PropertyChanges {
                target: rectangle_19
                visible: false
            }
        },
        State {
            name: "Eigenschaft 1=Variante2"
            when: settingsTab.eigenschaft_2 === SettingsTab.Eigenschaft_1.Eigenschaft_1_Variante2
    
            PropertyChanges {
                color: "#081624"
                target: settingsTab
            }
            PropertyChanges {
                y: 19
    
                target: settings_24dp_2
            }
            PropertyChanges {
                _vector_ShapePath0FillColor: "#e2d5c8"
                target: settings_24dp_2
            }
            PropertyChanges {
                target: rectangle_19
                visible: true
            }
        }
    ]

    Settings_24dp_1 {
        id: settings_24dp_2

        x: 12
        y: 19.50

        clip: true
    }
    Rectangle {
        id: rectangle_19

        y: 60

        height: 3
        width: 48

        color: "#ff8e00"
    }
}
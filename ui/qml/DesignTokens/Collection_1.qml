pragma Singleton

import QtQuick

QtObject {
    id: collection_1

    property Collection_1Theme activeTheme: mode_1
    property Collection_1Numbers numbers: activeTheme.numbers

    property Collection_1Theme mode_1: Collection_1Theme {
        numbers: Collection_1Numbers {
            radius: 5
        }
    }
}
pragma Singleton

import QtQuick

QtObject {
    id: theme

    readonly property color bg: "#282a36"
    readonly property color bgAlt: "#21222c"
    readonly property color bgDark: "#191a21"

    readonly property color fg: "#f8f8f2"
    readonly property color fgAlt: "#e0e0e0"

    readonly property color cyan: "#8be9fd"
    readonly property color green: "#50fa7b"
    readonly property color orange: "#ffb86c"
    readonly property color pink: "#ff79c6"
    readonly property color purple: "#bd93f9"
    readonly property color red: "#ff5555"
    readonly property color yellow: "#f1fa8c"
    readonly property color comment: "#6272a4"
    readonly property color selection: "#44475a"

    readonly property var contextColors: ({
        "DEFAULT": comment,
        "DEV": cyan,
        "GAME": red
    })

    readonly property var contextIcons: ({
        "DEFAULT": "⚫",
        "DEV": "⚙",
        "GAME": "🎮"
    })

    readonly property string fontFamily: "FiraCode Nerd Font"
    readonly property string fontFamilyMono: "FiraCode Nerd Font Mono"

    readonly property int fontSizeSmall: 10
    readonly property int fontSizeMedium: 12
    readonly property int fontSizeLarge: 14

    readonly property int barHeight: 36
    readonly property int spacing: 8
    readonly property int paddingSmall: 4
    readonly property int paddingMedium: 8
    readonly property int paddingLarge: 12
    readonly property int borderRadius: 6
    readonly property int borderWidth: 1

    readonly property int animationDuration: 150
    readonly property int animationDurationFast: 80
    readonly property int animationDurationSlow: 280
}

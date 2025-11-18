import QtQuick
import Quickshell
import Quickshell.Io
import ".." as Neon

Rectangle {
    id: root
    width: 140
    height: parent ? parent.height * 0.8 : 28
    radius: Neon.Theme.borderRadius
    color: Neon.Theme.bgAlt
    border.width: Neon.Theme.borderWidth
    border.color: Neon.Theme.contextColors[currentContext] || Neon.Theme.comment

    property string currentContext: "DEFAULT"
    property bool isTransitioning: false

    Timer {
        id: transitionReset
        interval: 2000
        repeat: false
        onTriggered: root.isTransitioning = false
    }

    readonly property string stateFile: `${Quickshell.env("XDG_STATE_HOME") || (Quickshell.env("HOME") + "/.local/state")}/neon-niri/system-context`

    FileView {
        id: stateView
        path: root.stateFile
        blockLoading: true
        watchChanges: true
        onLoaded: applyState(text())
        onLoadFailed: stateRetry.restart()
    }

    Timer {
        id: stateRetry
        interval: 3000
        repeat: false
        onTriggered: stateView.reload()
    }

    Timer {
        id: statePoll
        interval: 2000
        running: true
        repeat: true
        onTriggered: stateView.reload()
    }

    function applyState(raw) {
        const ctx = raw.trim()
        if (ctx && ctx !== root.currentContext && !root.isTransitioning) {
            root.currentContext = ctx
        }
    }

    Row {
        anchors.centerIn: parent
        spacing: Neon.Theme.spacing / 2

        Text {
            text: Neon.Theme.contextIcons[root.currentContext] || "⚫"
            font.family: Neon.Theme.fontFamily
            font.pixelSize: Neon.Theme.fontSizeLarge
            color: Neon.Theme.contextColors[root.currentContext] || Neon.Theme.fg
            opacity: root.isTransitioning ? 0.6 : 1
        }

        Column {
            spacing: -2
            Text {
                text: root.currentContext
                font.family: Neon.Theme.fontFamily
                font.pixelSize: Neon.Theme.fontSizeMedium
                font.bold: true
                color: Neon.Theme.contextColors[root.currentContext] || Neon.Theme.fg
            }
            Text {
                text: root.isTransitioning ? "switching" : ""
                font.family: Neon.Theme.fontFamily
                font.pixelSize: Neon.Theme.fontSizeSmall
                color: Neon.Theme.comment
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: root.color = Neon.Theme.selection
        onExited: root.color = Neon.Theme.bgAlt
        onClicked: cycleContext()
    }

    function cycleContext() {
        const order = ["DEFAULT", "DEV", "GAME"]
        const idx = order.indexOf(root.currentContext)
        const next = order[(idx + 1) % order.length]
        root.isTransitioning = true
        Quickshell.execDetached(["context-switch", next.toLowerCase()])
        transitionReset.restart()
    }
}

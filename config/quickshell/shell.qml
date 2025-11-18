// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  NEON-NIRI v2 - QUICKSHELL ENTRY POINT
//  Autor: @Saiiru
//  Data: 2025-11-18
//  Descrição: Entry point do Quickshell, carrega todos os componentes
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import QtQuick
import Quickshell
import Quickshell.Wayland
import "." as Neon

ShellRoot {
    id: root

    WaylandWindow {
        id: topBar
        title: "NEON-NIRI Bar"

        WaylandLayerSurface.namespace: "quickshell"
        WaylandLayerSurface.layer: WaylandLayer.Top
        WaylandLayerSurface.keyboardFocus: WaylandKeyboardFocus.None
        WaylandLayerSurface.scope: "exclusive"

        anchors {
            top: true
            left: true
            right: true
        }

        exclusiveZone: Neon.Theme.barHeight
        width: Screen.width
        height: Neon.Theme.barHeight
        color: "transparent"

        Bar {
            anchors.fill: parent
        }
    }

    property string currentContext: "DEFAULT"

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            const stateFile = `${Quickshell.env("XDG_STATE_HOME")}/neon-niri/system-context`
            const result = Quickshell.run("cat", [stateFile])
            if (result.exitCode === 0) {
                const ctx = result.stdout.trim()
                if (ctx && ctx !== root.currentContext) {
                    root.currentContext = ctx
                    console.log("Context changed:", ctx)
                }
            }
        }
    }
}

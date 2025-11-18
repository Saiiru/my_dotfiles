// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  NEON-NIRI v2 - QUICKSHELL ENTRY POINT
//  Autor: @Saiiru
//  Data: 2025-11-18
//  Descrição: Entry point do Quickshell, carrega todos os componentes
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "." as Neon

ShellRoot {
    id: root

    PanelWindow {
        id: topBar

        WlrLayershell.namespace: "quickshell"
        WlrLayershell.layer: WlrLayershell.Top
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

        anchors.top: true
        anchors.left: true
        anchors.right: true
        exclusiveZone: Neon.Theme.barHeight
        implicitWidth: Screen.width
        implicitHeight: Neon.Theme.barHeight
        color: "transparent"

        Bar {
            anchors.fill: parent
        }
    }

    property string currentContext: "DEFAULT"
}

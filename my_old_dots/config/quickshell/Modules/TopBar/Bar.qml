import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import qs.Common
import qs.Services
import qs.Widgets

PanelWindow {
    id: topbar

    WlrLayershell.namespace: "quickshell:bar:blur"

    WlrLayershell.layer: WlrLayershell.Top
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    property var modelData
    screen: modelData
    color: "transparent"

    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: 32
    implicitWidth: 32

    // The actual bar content - dark mode
    Rectangle {
        id: bar
        anchors.fill: parent
        color: Qt.rgba(0.05, 0.05, 0.08, 0.18)  // Lighter transparent backdrop
        radius: 0  // Full width bar without rounded corners
        border.color: Qt.rgba(0.87, 0.0, 0.23, 0.35)
        border.width: 1
        layer.enabled: true
    }
}

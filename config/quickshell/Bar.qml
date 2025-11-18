import QtQuick
import Quickshell
import "./Widgets" as Widgets
import "." as Neon

Rectangle {
    id: bar
    color: Qt.rgba(Neon.Theme.bg.r, Neon.Theme.bg.g, Neon.Theme.bg.b, 0.92)
    radius: 0

    Row {
        id: leftSection
        anchors.left: parent.left
        anchors.leftMargin: Neon.Theme.paddingMedium
        anchors.verticalCenter: parent.verticalCenter
        spacing: Neon.Theme.spacing

        Widgets.Context {
            id: contextWidget
        }

        Widgets.Workspaces {
            id: workspacesWidget
        }
    }

    Row {
        id: centerSection
        anchors.centerIn: parent
        spacing: Neon.Theme.spacing

        Widgets.Clock {
            id: clockWidget
        }
    }

    Row {
        id: rightSection
        anchors.right: parent.right
        anchors.rightMargin: Neon.Theme.paddingMedium
        anchors.verticalCenter: parent.verticalCenter
        spacing: Neon.Theme.spacing

        Widgets.Performance {
            id: perfWidget
        }
    }
}

import QtQuick
import Quickshell
import Quickshell.Io
import ".." as Neon

Rectangle {
    id: root
    width: repeater.width + Neon.Theme.paddingMedium
    height: parent ? parent.height * 0.8 : 28
    color: "transparent"

    property int activeWorkspace: 1

    Timer {
        interval: 1500
        running: true
        repeat: true
        onTriggered: workspaceProcess.running = true
    }

    Process {
        id: workspaceProcess
        command: ["niri", "msg", "-j", "workspaces"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(text)
                    const focused = data.workspaces.find(ws => ws.focused)
                    if (focused) {
                        root.activeWorkspace = focused.idx + 1
                    }
                } catch (e) {
                    // ignore
                }
            }
        }
    }

    Row {
        id: repeater
        anchors.verticalCenter: parent.verticalCenter
        spacing: Neon.Theme.spacing / 2

        Repeater {
            model: 9
            delegate: Rectangle {
                width: 28
                height: parent ? parent.parent.height : 22
                radius: Neon.Theme.borderRadius
                property int workspaceNumber: index + 1
                property bool isActive: workspaceNumber === root.activeWorkspace
                color: isActive ? Neon.Theme.purple : Neon.Theme.bgDark
                border.width: Neon.Theme.borderWidth
                border.color: isActive ? Neon.Theme.purple : Neon.Theme.comment

                Text {
                    anchors.centerIn: parent
                    text: workspaceNumber
                    font.family: Neon.Theme.fontFamily
                    font.pixelSize: Neon.Theme.fontSizeMedium
                    color: isActive ? Neon.Theme.bg : Neon.Theme.fg
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: if (!parent.isActive) parent.color = Neon.Theme.selection
                    onExited: if (!parent.isActive) parent.color = Neon.Theme.bgDark
                    onClicked: Quickshell.run("niri", ["msg", "focus-workspace", workspaceNumber.toString()])
                }

                Behavior on color { ColorAnimation { duration: Neon.Theme.animationDuration } }
            }
        }
    }
}

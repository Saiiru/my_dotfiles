import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Common
import qs.Services
import qs.Widgets

Rectangle {
    id: root

    property string section: "left"
    property real widgetHeight: 30

    readonly property var context: ContextService.currentContextInfo
    readonly property color accentColor: context && context.accent ? context.accent : Theme.primary
    readonly property real paddingX: SettingsData.topBarNoBackground ? Math.max(2, Theme.spacingXS * 0.5) : Math.max(4, SettingsData.topBarInnerPadding * 0.25)

    height: widgetHeight
    radius: SettingsData.topBarNoBackground ? 0 : Theme.cornerRadius
    color: "transparent"
    border.width: 0

    implicitWidth: contentRow.implicitWidth + paddingX * 2
    width: implicitWidth

    Rectangle {
        id: accentBackground
        anchors.fill: parent
        radius: root.radius
        color: accentColor
        opacity: SettingsData.topBarNoBackground ? 0.22 : 0.18
    }

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 2
        radius: root.radius
        color: accentColor
        opacity: 0.6
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 1
        color: Qt.lighter(accentColor, 140)
        opacity: 0.9
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: Qt.darker(accentColor, 130)
        opacity: 0.85
    }

    RowLayout {
        id: contentRow
        z: 2
        anchors.centerIn: parent
        spacing: Math.max(2, Theme.spacingXS * 0.6)
        opacity: ContextService.busy ? 0.4 : 1

        DankIcon {
            id: stateIcon
            Layout.alignment: Qt.AlignVCenter
            name: context ? context.icon : "auto_mode"
            color: context ? context.accent : Theme.surfaceText
            size: Theme.iconSize - 6
        }

        Column {
            Layout.alignment: Qt.AlignVCenter
            spacing: -4

            StyledText {
                text: context ? `${context.id}` : "Context"
                font.bold: true
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.surfaceText
            }

            StyledText {
                text: context ? context.description : ""
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceTextSecondary
                elide: Text.ElideRight
                width: 100
            }
        }
    }

    BusyIndicator {
        anchors.centerIn: parent
        running: ContextService.busy
        visible: ContextService.busy
        width: Theme.iconSize - 8
        height: Theme.iconSize - 8
        z: 3
    }

    Menu {
        id: contextMenu
        Repeater {
            model: ContextService.contextDefinitions
            delegate: MenuItem {
                required property var modelData
                text: `${modelData.name} (${modelData.id})`
                checkable: true
                checked: ContextService.currentContext === modelData.id
                icon.name: modelData.icon
                onTriggered: ContextService.setContext(modelData.id)
            }
        }
    }

    ToolTip.visible: mouseArea.containsMouse
    ToolTip.text: context ? `${context.name} — ${context.description}\nState file: ${ContextService.stateFile}` : "System context"

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor

        onClicked: event => {
            if (event.button === Qt.LeftButton) {
                ContextService.cycle(1)
            } else if (event.button === Qt.RightButton) {
                contextMenu.popup()
            }
        }

        onWheel: wheel => {
            wheel.accepted = true
            if (wheel.angleDelta.y > 0 || wheel.angleDelta.x > 0) {
                ContextService.cycle(-1)
            } else {
                ContextService.cycle(1)
            }
        }

        onPressAndHold: {
            contextMenu.popup()
        }
    }
}

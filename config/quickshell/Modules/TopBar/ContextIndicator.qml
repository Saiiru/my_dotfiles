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
    readonly property real paddingX: SettingsData.topBarNoBackground ? Theme.spacingXS : Math.max(Theme.spacingXS, SettingsData.topBarInnerPadding * 0.3)

    height: widgetHeight
    radius: SettingsData.topBarNoBackground ? 0 : Theme.cornerRadius
    color: SettingsData.topBarNoBackground ? "transparent" : Qt.rgba(Theme.widgetBaseBackgroundColor.r,
                                                                     Theme.widgetBaseBackgroundColor.g,
                                                                     Theme.widgetBaseBackgroundColor.b,
                                                                     Theme.widgetTransparency)
    border.width: SettingsData.topBarNoBackground ? 0 : 1
    border.color: SettingsData.topBarNoBackground ? "transparent" : Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.65)

    implicitWidth: contentRow.implicitWidth + paddingX * 2
    width: implicitWidth

    RowLayout {
        id: contentRow
        anchors.centerIn: parent
        spacing: Theme.spacingXS
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
            spacing: -2

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
                width: 120
            }
        }
    }

    BusyIndicator {
        anchors.centerIn: parent
        running: ContextService.busy
        visible: ContextService.busy
        width: Theme.iconSize - 8
        height: Theme.iconSize - 8
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

import QtQuick 2.15
import QtQuick.Layouts 1.15
import Quickshell

Item {
    id: root
    property var notification
    property int toastWidth: 420

    property int fontSize: 11
    property string fontFamily: "Space Grotesk"

    // Cores injetadas pelo manager
    property color primaryColor: "#E6F5FF"
    property color secondaryColor: "#8A99B8"
    property color accentColor: "#7AA2F7"
    property color backgroundColor: "#050910"

    width: toastWidth
    opacity: notification && notification.closed ? 0.0 : 1.0

    signal requestClose()

    Timer {
        interval: 6500
        running: true
        repeat: false
        onTriggered: root.requestClose()
    }

    Behavior on opacity {
        NumberAnimation { duration: 140; easing.type: Easing.OutQuad }
    }

    Rectangle {
        id: card
        anchors.fill: parent
        radius: 14
        color: backgroundColor
        border.width: 1
        border.color: accentColor
        opacity: 0.92

        layer.enabled: true
        layer.smooth: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 6

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Rectangle {
                    Layout.preferredWidth: 4
                    Layout.fillHeight: true
                    radius: 2
                    color: accentColor
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Text {
                        Layout.fillWidth: true
                        text: notification ? notification.appName : "Unknown"
                        color: secondaryColor
                        font.pixelSize: 13
                        font.letterSpacing: 0.8
                        font.family: fontFamily
                        font.bold: true
                        elide: Text.ElideRight
                        opacity: 0.9
                    }

                    Text {
                        Layout.fillWidth: true
                        text: notification ? notification.summary : ""
                        color: accentColor
                        font.pixelSize: 17
                        font.bold: true
                        font.family: fontFamily
                        elide: Text.ElideRight
                    }
                }
            }

            Text {
                Layout.fillWidth: true
                visible: notification && notification.body && notification.body.length > 0
                text: notification ? notification.body : ""
                color: secondaryColor
                font.pixelSize: 13
                font.family: fontFamily
                wrapMode: Text.Wrap
                maximumLineCount: 4
                elide: Text.ElideRight
                opacity: 0.95
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 6

                Rectangle {
                    Layout.fillWidth: true
                    height: 2
                    radius: 1
                    color: accentColor
                    opacity: 0.35
                }

                Text {
                    text: Qt.formatTime(new Date(), "HH:mm")
                    color: secondaryColor
                    font.pixelSize: 10
                    font.family: fontFamily
                    opacity: 0.9
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: root.requestClose()
        }
    }

}

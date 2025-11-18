import QtQuick
import ".." as Neon

Rectangle {
    id: root
    width: 140
    height: parent ? parent.height * 0.8 : 28
    radius: Neon.Theme.borderRadius
    color: Neon.Theme.bgAlt
    border.width: Neon.Theme.borderWidth
    border.color: Neon.Theme.comment

    property string timeText: "--:--"
    property string dateText: "--"

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: updateTime()
    }

    Component.onCompleted: updateTime()

    function updateTime() {
        const now = new Date()
        root.timeText = Qt.formatTime(now, "hh:mm:ss")
        root.dateText = Qt.formatDate(now, "ddd, dd MMM")
    }

    Column {
        anchors.centerIn: parent
        spacing: -2
        Text {
            text: root.timeText
            font.family: Neon.Theme.fontFamilyMono
            font.pixelSize: Neon.Theme.fontSizeLarge
            color: Neon.Theme.fg
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
        }
        Text {
            text: root.dateText
            font.family: Neon.Theme.fontFamily
            font.pixelSize: Neon.Theme.fontSizeSmall
            color: Neon.Theme.comment
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
        }
    }
}

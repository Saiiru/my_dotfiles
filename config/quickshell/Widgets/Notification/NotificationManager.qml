import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtMultimedia
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications as Notifications

PanelWindow {
    id: window

    implicitWidth: notificationWidth
    implicitHeight: stack.implicitHeight
    anchors.top: true
    anchors.right: true
    margins.top: 24
    margins.right: 24
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusionMode: ExclusionMode.Ignore

    property int notificationWidth: 440
    property int notificationSpacing: 10
    property int maxVisible: 6
    property string fontFamily: "Space Grotesk"
    property int fontSize: 11

    // Paleta (pode trocar depois)
    readonly property color bgLow: "#071722E0"
    readonly property color bgNormal: "#050811E0"
    readonly property color bgCritical: "#18070CE0"
    readonly property color accentLow: "#00E6FF"
    readonly property color accentNormal: "#7AA2F7"
    readonly property color accentCritical: "#FF4B6E"
    readonly property color textPrimary: "#E6F5FF"
    readonly property color textSecondary: "#8A99B8"
    readonly property color textCritical: "#FFD6D9"

    // Script que toca o mp3 do repo
    readonly property url soundSource: Qt.resolvedUrl("../../scripts/../../sounds/cyberpunk_notification.mp3")

    // Modelo local (evita depender de propriedades específicas do server)
    ListModel { id: notificationList }

    Notifications.NotificationServer {
        id: server
        onNotification: function(notification) {
            if (notification) {
                console.log("[notification] incoming", notification.appName, notification.summary)
                notification.tracked = true
                notificationList.append({ notification: notification })
            }
        }
    }

    Column {
        id: stack
        spacing: notificationSpacing
        anchors.fill: parent

        Repeater {
            model: notificationList
            delegate: NotificationPopup {
                width: notificationWidth
                notification: model.notification
                fontFamily: window.fontFamily
                fontSize: window.fontSize
                backgroundColor: window.backgroundFor(notification)
                primaryColor: window.textColorFor(notification)
                secondaryColor: window.textSecondary
                accentColor: window.accentFor(notification)
                onRequestClose: {
                    var idx = index
                    if (idx >= 0 && idx < notificationList.count) {
                        notificationList.remove(idx)
                    }
                    if (notification && notification.close) {
                        notification.close()
                    }
                }
            }
        }
    }

    function urgencyOf(n) {
        if (!n || n.urgency === undefined || n.urgency === null) return 1
        var u = n.urgency
        if (u <= 0) return 0
        if (u >= 2) return 2
        return 1
    }
    function accentFor(n) {
        var u = urgencyOf(n)
        if (u === 0) return accentLow
        if (u === 2) return accentCritical
        return accentNormal
    }
    function backgroundFor(n) {
        var u = urgencyOf(n)
        if (u === 0) return bgLow
        if (u === 2) return bgCritical
        return bgNormal
    }
    function textColorFor(n) {
        var u = urgencyOf(n)
        if (u === 2) return textCritical
        return textPrimary
    }
    function kindFor(notification) {
        var kind = "normal"
        var u = urgencyOf(notification)
        if (u === 0) kind = "low"
        else if (u === 2) kind = "critical"
        return kind
    }

    function playSound(notification) {}
}

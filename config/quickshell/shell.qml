import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Services.Notifications
import QtQuick
import QtCore
import qs.Bar
import qs.Bar.Modules
import qs.Widgets
import qs.Widgets.Notification
import "Widgets/Notification" as Notif
import qs.Settings
import qs.Helpers

Scope {
    id: root

    property alias appLauncherPanel: appLauncherPanel
    property var notificationHistoryWin: notificationHistoryWin

    function updateVolume(vol) {
        volume = vol;
        if (defaultAudioSink && defaultAudioSink.audio) {
            defaultAudioSink.audio.volume = vol / 100;
        }
    }

    Component.onCompleted: {
        Quickshell.shell = root;
    }

    Bar {
        id: bar
        shell: root
        property var notificationHistoryWin: notificationHistoryWin
    }

    Applauncher {
        id: appLauncherPanel
        visible: false
    }

    LockScreen {
        id: lockScreen
    }

    // Toasts no canto superior direito (NotificationServer embutido)
    Notif.NotificationManager {
        id: notificationManager
    }

    // Notification History Window (mantido)
    NotificationHistory {
        id: notificationHistoryWin
    }

    property var defaultAudioSink: Pipewire.defaultAudioSink
    property int volume: defaultAudioSink && defaultAudioSink.audio && defaultAudioSink.audio.volume ? Math.round(defaultAudioSink.audio.volume * 100) : 0

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    IPCHandlers {
        appLauncherPanel: appLauncherPanel
        lockScreen: lockScreen
    }

    Connections {
        function onReloadCompleted() {
            Quickshell.inhibitReloadPopup();
        }

        function onReloadFailed() {
            Quickshell.inhibitReloadPopup();
        }

        target: Quickshell
    }
}

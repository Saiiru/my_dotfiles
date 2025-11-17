pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.Common

Singleton {
    id: hdrService

    property bool hdrEnabled: false
    property bool isChecking: false
    readonly property string hyprDir: Paths.expandTilde("~/.config/hypr")
    readonly property string monitorConfig: `${hyprDir}/monitors.conf`
    readonly property string hyprHdrScript: `${hyprDir}/hyprhdr.py`

    function checkHdrState() {
        isChecking = true
        checkProcess.running = true
    }

    function toggleHdr() {
        toggleProcess.running = true
    }

    Process {
        id: checkProcess
        command: ["sh", "-c", "test -f '" + monitorConfig + "' && grep -q \"cm\\\\s*=\\\\s*hdr\" '" + monitorConfig + "'"]
        onExited: (code, status) => {
            isChecking = false
            hdrEnabled = (code === 0)
        }
    }

    Process {
        id: toggleProcess
        command: ["python3", hyprHdrScript]
        onExited: (code, status) => {
            if (code === 0) {
                checkHdrState()
            }
        }
    }

    Component.onCompleted: {
        checkHdrState()
    }
}

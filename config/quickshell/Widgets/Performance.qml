import QtQuick
import Quickshell
import Quickshell.Io
import ".." as Neon

Rectangle {
    id: root
    width: 220
    height: parent ? parent.height * 0.8 : 28
    radius: Neon.Theme.borderRadius
    color: Neon.Theme.bgAlt
    border.width: Neon.Theme.borderWidth
    border.color: Neon.Theme.comment

    property string cpuUsage: "0%"
    property string cpuTemp: "0°C"
    property string gpuUsage: "0%"
    property string gpuTemp: "0°C"
    property string ramUsage: "0%"
    property bool showGpu: false

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: updateStats()
    }

    Component.onCompleted: {
        nvidiaDetect.running = true
        amdDetect.running = true
        updateStats()
    }

    Process {
        id: cpuUsageProcess
        command: ["sh", "-c", "top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\\([0-9.]*\\)%* id.*/\\1/' | awk '{print 100 - $1\"%\"}'"]
        stdout: StdioCollector {
            onStreamFinished: root.cpuUsage = text.trim()
        }
    }

    Process {
        id: cpuTempProcess
        command: ["sh", "-c", "sensors 2>/dev/null | grep -oP 'Package id 0.*?\\+\\K[0-9.]+' | head -1"]
        stdout: StdioCollector {
            onStreamFinished: {
                const cleaned = text.trim()
                if (cleaned.length > 0) {
                    root.cpuTemp = cleaned + "°C"
                }
            }
        }
    }

    Process {
        id: ramProcess
        command: ["sh", "-c", "free | grep Mem | awk '{printf \"%.0f%%\", ($3/$2)*100}'"]
        stdout: StdioCollector {
            onStreamFinished: root.ramUsage = text.trim()
        }
    }

    Process {
        id: gpuUsageProcess
        command: ["nvidia-smi", "--query-gpu=utilization.gpu", "--format=csv,noheader,nounits"]
        stdout: StdioCollector {
            onStreamFinished: root.gpuUsage = text.trim() + "%"
        }
    }

    Process {
        id: gpuTempProcess
        command: ["nvidia-smi", "--query-gpu=temperature.gpu", "--format=csv,noheader,nounits"]
        stdout: StdioCollector {
            onStreamFinished: root.gpuTemp = text.trim() + "°C"
        }
    }

    Process {
        id: nvidiaDetect
        command: ["which", "nvidia-smi"]
        stdout: StdioCollector {}
        onExited: function(exitCode) {
            if (exitCode === 0) {
                root.showGpu = true
            }
        }
    }

    Process {
        id: amdDetect
        command: ["sh", "-c", "test -f /sys/class/drm/card0/device/gpu_busy_percent"]
        stdout: StdioCollector {}
        onExited: function(exitCode) {
            if (exitCode === 0) {
                root.showGpu = true
            }
        }
    }

    function updateStats() {
        if (!cpuUsageProcess.running) cpuUsageProcess.running = true
        if (!cpuTempProcess.running) cpuTempProcess.running = true
        if (!ramProcess.running) ramProcess.running = true
        if (root.showGpu) {
            if (!gpuUsageProcess.running) gpuUsageProcess.running = true
            if (!gpuTempProcess.running) gpuTempProcess.running = true
        }
    }

    Row {
        anchors.centerIn: parent
        spacing: Neon.Theme.spacing

        Column {
            spacing: 2
            Text { text: "CPU"; font.pixelSize: Neon.Theme.fontSizeSmall; color: Neon.Theme.cyan; font.family: Neon.Theme.fontFamily }
            Text { text: root.cpuUsage; font.pixelSize: Neon.Theme.fontSizeMedium; color: Neon.Theme.green; font.family: Neon.Theme.fontFamilyMono }
            Text { text: root.cpuTemp; font.pixelSize: Neon.Theme.fontSizeSmall; color: Neon.Theme.comment; font.family: Neon.Theme.fontFamilyMono }
        }

        Column {
            spacing: 2
            visible: root.showGpu
            Text { text: "GPU"; font.pixelSize: Neon.Theme.fontSizeSmall; color: Neon.Theme.purple; font.family: Neon.Theme.fontFamily }
            Text { text: root.gpuUsage; font.pixelSize: Neon.Theme.fontSizeMedium; color: Neon.Theme.green; font.family: Neon.Theme.fontFamilyMono }
            Text { text: root.gpuTemp; font.pixelSize: Neon.Theme.fontSizeSmall; color: Neon.Theme.comment; font.family: Neon.Theme.fontFamilyMono }
        }

        Column {
            spacing: 2
            Text { text: "RAM"; font.pixelSize: Neon.Theme.fontSizeSmall; color: Neon.Theme.pink; font.family: Neon.Theme.fontFamily }
            Text { text: root.ramUsage; font.pixelSize: Neon.Theme.fontSizeMedium; color: Neon.Theme.green; font.family: Neon.Theme.fontFamilyMono }
        }
    }
}

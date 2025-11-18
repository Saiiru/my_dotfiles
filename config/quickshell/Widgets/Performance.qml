import QtQuick
import Quickshell
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
        detectGpu()
        updateStats()
    }

    function detectGpu() {
        const nvidia = Quickshell.run("which", ["nvidia-smi"])
        if (nvidia.exitCode === 0) {
            root.showGpu = true
            return
        }
        const amd = Quickshell.run("sh", ["-c", "test -f /sys/class/drm/card0/device/gpu_busy_percent"])
        root.showGpu = amd.exitCode === 0
    }

    function updateStats() {
        const cpu = Quickshell.run("sh", ["-c", "top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\\([0-9.]*\\)%* id.*/\\1/' | awk '{print 100 - $1\"%\"}'"])
        if (cpu.exitCode === 0) root.cpuUsage = cpu.stdout.trim()
        const temp = Quickshell.run("sh", ["-c", "sensors 2>/dev/null | grep -oP 'Package id 0.*?\\+\\K[0-9.]+' | head -1"])
        if (temp.exitCode === 0 && temp.stdout.trim() !== "") root.cpuTemp = temp.stdout.trim() + "°C"
        const ram = Quickshell.run("sh", ["-c", "free | grep Mem | awk '{printf \"%.0f%%\", ($3/$2)*100}'"])
        if (ram.exitCode === 0) root.ramUsage = ram.stdout.trim()

        if (root.showGpu) {
            const usage = Quickshell.run("nvidia-smi", ["--query-gpu=utilization.gpu", "--format=csv,noheader,nounits"])
            if (usage.exitCode === 0) root.gpuUsage = usage.stdout.trim() + "%"
            const gtemp = Quickshell.run("nvidia-smi", ["--query-gpu=temperature.gpu", "--format=csv,noheader,nounits"])
            if (gtemp.exitCode === 0) root.gpuTemp = gtemp.stdout.trim() + "°C"
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

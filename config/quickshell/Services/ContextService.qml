pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import QtCore
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Services

Singleton {
    id: root

    readonly property var contextDefinitions: [
        {
            "id": "DEFAULT",
            "name": "Default",
            "shortName": "Default",
            "description": "Balanced desktop profile with standard governor & compositor defaults.",
            "icon": "auto_mode",
            "accent": "#8BE9FD"
        },
        {
            "id": "DEV",
            "name": "Dev",
            "shortName": "Dev",
            "description": "Development workspace tuning focused on multitasking and tooling responsiveness.",
            "icon": "code",
            "accent": "#50FA7B"
        },
        {
            "id": "GAME",
            "name": "Game",
            "shortName": "Game",
            "description": "High performance profile with governor, GPU, GameMode + MangoHud tweaks.",
            "icon": "sports_esports",
            "accent": "#FF79C6"
        }
    ]

    readonly property string stateDir: StandardPaths.writableLocation(StandardPaths.GenericStateLocation) + "/neon-niri"
    readonly property string stateFile: stateDir + "/system-context"
    readonly property string logFile: stateDir + "/context-switch.log"
    readonly property string defaultBinary: StandardPaths.writableLocation(StandardPaths.HomeLocation) + "/.local/bin/context-switch"

    property string currentContext: "DEFAULT"
    property var currentContextInfo: contextDefinitions[0]
    property bool busy: false
    property string pendingContext: ""
    property string lastStdout: ""
    property string lastStderr: ""
    property string lastError: ""
    property string lastMessage: ""

    signal contextChanged(string newContext)

    Component.onCompleted: {
        stateFileView.path = stateFile
        Qt.callLater(() => stateFileView.reload())
    }

    function expandHome(path) {
        if (!path || path.length === 0)
            return ""
        if (path.startsWith("~/")) {
            return StandardPaths.writableLocation(StandardPaths.HomeLocation) + path.substring(1)
        }
        return path
    }

    function fileAccessible(path) {
        if (!path || path.length === 0)
            return false
        if (!path.startsWith("/"))
            return false
        try {
            const data = Quickshell.readFile(path)
            return data !== undefined
        } catch (e) {
            return false
        }
    }

    function pickBinary() {
        const override = expandHome(Quickshell.env("NEON_CONTEXT_SWITCH"))
        if (override)
            return override
        const expandedDefault = expandHome(defaultBinary)
        if (fileAccessible(expandedDefault))
            return expandedDefault
        return "context-switch"
    }

    function findContext(id, allowFallback = true) {
        const normalized = (id || "").toString().trim().toUpperCase()
        for (let i = 0; i < contextDefinitions.length; i++) {
            if (contextDefinitions[i].id === normalized)
                return contextDefinitions[i]
        }
        return allowFallback ? contextDefinitions[0] : null
    }

    function applyState(raw) {
        const info = findContext(raw)
        const previous = currentContext
        currentContext = info.id
        currentContextInfo = info
        if (previous !== info.id) {
            contextChanged(info.id)
        }
    }

    function refresh() {
        stateFileView.reload()
    }

    function next(step = 1) {
        const total = contextDefinitions.length
        if (total === 0)
            return contextDefinitions[0]
        const currentIndex = contextDefinitions.findIndex(entry => entry.id === currentContext)
        const idx = currentIndex === -1 ? 0 : (currentIndex + step + total) % total
        return contextDefinitions[idx]
    }

    function cycle(step = 1) {
        const destination = next(step)
        setContext(destination.id)
    }

    function setContext(targetId) {
        if (!targetId || busy)
            return

        const target = findContext(targetId, false)
        if (!target) {
            ToastService.showError(`Unknown context: ${targetId}`)
            return
        }
        if (target.id === currentContext) {
            ToastService.showInfo(`${target.name} context already active`)
            return
        }

        const binary = pickBinary()
        pendingContext = target.id
        busy = true
        lastStdout = ""
        lastStderr = ""
        lastError = ""
        lastMessage = `Switching to ${target.name}`
        ToastService.showInfo(lastMessage)

        const targetArg = target.id.toLowerCase()
        contextProcess.command = [binary, targetArg]
        contextProcess.running = true
    }

    function tailLog(lines = 16) {
        try {
            const raw = Quickshell.readFile(logFile)
            if (!raw)
                return []
            const entries = raw.trim().split("\n")
            return entries.slice(Math.max(0, entries.length - lines))
        } catch (e) {
            return []
        }
    }

    FileView {
        id: stateFileView
        blockLoading: true
        watchChanges: true
        path: root.stateFile

        onLoaded: {
            root.applyState(text())
            retryTimer.stop()
        }

        onLoadFailed: {
            retryTimer.restart()
        }
    }

    Timer {
        id: retryTimer
        interval: 4000
        repeat: false
        onTriggered: stateFileView.reload()
    }

    Process {
        id: contextProcess
        running: false

        stdout: StdioCollector {
            onStreamFinished: root.lastStdout = text.trim()
        }

        stderr: StdioCollector {
            onStreamFinished: root.lastStderr = text.trim()
        }

        onExited: exitCode => {
            const target = root.pendingContext
            root.busy = false
            root.pendingContext = ""

            if (exitCode === 0) {
                root.lastMessage = target ? `Context → ${target}` : "Context switch complete"
                ToastService.showInfo(root.lastMessage)
                root.refresh()
            } else {
                const detail = root.lastStderr || root.lastStdout || `context-switch failed (code ${exitCode})`
                root.lastError = detail
                ToastService.showError("Context switch failed", detail)
            }
        }
    }
}

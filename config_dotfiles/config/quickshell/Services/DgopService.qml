import QtQuick
import Quickshell.Io
import Quickshell.Wayland
import qs.Common
import qs.Services

Service {
    id: root

    property var refs: ({})
    property var availableGpus: []
    property var cpuModel: ""
    property real cpuTemperature: 0
    property real cpuUsage: 0
    property real memoryUsage: 0
    property real usedMemoryMB: 0
    property real totalMemoryMB: 0
    property real networkRxRate: 0
    property real networkTxRate: 0
    property var networkInterfaces: []
    property var disks: []
    property var processes: []
    property var cpuHistory: []
    property var memoryHistory: []
    property var networkHistory: []
    property var diskHistory: []
    property var processHistory: []
    property var gpuHistory: []
    property var gpuMemoryHistory: []
    property var gpuUsageHistory: []
    property var gpuTemperatureHistory: []
    property var gpuPowerHistory: []
    property var gpuFanHistory: []
    property var gpuClockHistory: []
    property var gpuMemoryClockHistory: []
    property var gpuVoltageHistory: []
    property var gpuLimitHistory: []
    property var gpuLoadHistory: []
    property var gpuMemoryLoadHistory: []
    property var gpuEncoderLoadHistory: []
    property var gpuDecoderLoadHistory: []
    property var gpuPowerDrawHistory: []
    property var gpuPowerLimitHistory: []
    property var gpuTemperatureLimitHistory: []
    property var gpuMemoryTemperatureHistory: []
    property var gpuHotspotTemperatureHistory: []
    property var gpuPowerUsageHistory: []
    property var gpuMemoryUsageHistory: []
    property var gpuEncoderUsageHistory: []
    property var gpuDecoderUsageHistory: []
    property var gpuVoltageUsageHistory: []
    property var gpuLimitUsageHistory: []
    property var gpuLoadUsageHistory: []
    property var gpuMemoryLoadUsageHistory: []
    property var gpuEncoderLoadUsageHistory: []
    property var gpuDecoderLoadUsageHistory: []
    property var gpuPowerDrawUsageHistory: []
    property var gpuPowerLimitUsageHistory: []
    property var gpuTemperatureLimitUsageHistory: []
    property var gpuMemoryTemperatureUsageHistory: []
    property var gpuHotspotTemperatureUsageHistory: []
    property var gpuPowerUsageUsageHistory: []
    property var gpuMemoryUsageUsageHistory: []
    property var gpuEncoderUsageUsageHistory: []
    property var gpuDecoderUsageUsageHistory: []
    property var gpuVoltageUsageUsageHistory: []
    property var gpuLimitUsageUsageHistory: []
    property var gpuLoadUsageUsageHistory: []
    property var gpuMemoryLoadUsageUsageHistory: []
    property var gpuEncoderLoadUsageUsageHistory: []
    property var gpuDecoderLoadUsageUsageHistory: []
    property var gpuPowerDrawUsageUsageHistory: []
    property var gpuPowerLimitUsageUsageHistory: []
    property var gpuTemperatureLimitUsageUsageHistory: []
    property var gpuMemoryTemperatureUsageUsageHistory: []
    property var gpuHotspotTemperatureUsageUsageHistory: []

    function addRef(what) {
        for (var i = 0; i < what.length; i++) {
            var key = what[i];
            if (refs[key]) {
                refs[key]++;
            } else {
                refs[key] = 1;
                if (key === "cpu") {
                    cpuTimer.running = true;
                } else if (key === "memory") {
                    memoryTimer.running = true;
                } else if (key === "network") {
                    networkTimer.running = true;
                } else if (key === "disk") {
                    diskTimer.running = true;
                } else if (key === "process") {
                    processTimer.running = true;
                } else if (key === "gpu") {
                    gpuTimer.running = true;
                }
            }
        }
    }

    function removeRef(what) {
        for (var i = 0; i < what.length; i++) {
            var key = what[i];
            if (refs[key]) {
                refs[key]--;
                if (refs[key] === 0) {
                    if (key === "cpu") {
                        cpuTimer.running = false;
                    } else if (key === "memory") {
                        memoryTimer.running = false;
                    } else if (key === "network") {
                        networkTimer.running = false;
                    } else if (key === "disk") {
                        diskTimer.running = false;
                    } else if (key === "process") {
                        processTimer.running = false;
                    } else if (key === "gpu") {
                        gpuTimer.running = false;
                    }
                }
            }
        }
    }

    Timer {
        id: cpuTimer
        interval: 2000
        running: false
        repeat: true
        onTriggered: {
            cpuModelProcess.running = true;
            cpuTemperatureProcess.running = true;
            cpuUsageProcess.running = true;
        }
    }

    Timer {
        id: memoryTimer
        interval: 2000
        running: false
        repeat: true
        onTriggered: {
            memoryUsageProcess.running = true;
        }
    }

    Timer {
        id: networkTimer
        interval: 2000
        running: false
        repeat: true
        onTriggered: {
            networkUsageProcess.running = true;
        }
    }

    Timer {
        id: diskTimer
        interval: 5000
        running: false
        repeat: true
        onTriggered: {
            diskUsageProcess.running = true;
        }
    }

    Timer {
        id: processTimer
        interval: 2000
        running: false
        repeat: true
        onTriggered: {
            processListProcess.running = true;
        }
    }

    Timer {
        id: gpuTimer
        interval: 2000
        running: false
        repeat: true
        onTriggered: {
            //nvmlCheckProcess.running = true;
        }
    }

    Process {
        id: cpuModelProcess
        command: ["cat", "/proc/cpuinfo"]
        running: false
        onExited: exitCode => {
            // Process completed
        }
        stdout: StdioCollector {
            onStreamFinished: {
                var lines = text.split("\n");
                for (var i = 0; i < lines.length; i++) {
                    if (lines[i].startsWith("model name")) {
                        root.cpuModel = lines[i].split(":")[1].trim();
                        break;
                    }
                }
            }
        }
    }

    Process {
        id: cpuTemperatureProcess
        command: ["sh", "-c", "cat /sys/class/thermal/thermal_zone*/temp"]
        running: false
        onExited: exitCode => {
            // Process completed
        }
        stdout: StdioCollector {
            onStreamFinished: {
                var lines = text.split("\n");
                var totalTemp = 0;
                var count = 0;
                for (var i = 0; i < lines.length; i++) {
                    var temp = parseInt(lines[i]);
                    if (!isNaN(temp)) {
                        totalTemp += temp;
                        count++;
                    }
                }
                if (count > 0) {
                    root.cpuTemperature = totalTemp / count / 1000;
                }
            }
        }
    }

    Process {
        id: cpuUsageProcess
        property var lastCpuStats: ({})
        command: ["cat", "/proc/stat"]
        running: false
        onExited: exitCode => {
            // Process completed
        }
        stdout: StdioCollector {
            onStreamFinished: {
                var lines = text.split("\n");
                var cpuLine = lines[0];
                var parts = cpuLine.split(/\s+/);
                var user = parseInt(parts[1]);
                var nice = parseInt(parts[2]);
                var system = parseInt(parts[3]);
                var idle = parseInt(parts[4]);
                var iowait = parseInt(parts[5]);
                var irq = parseInt(parts[6]);
                var softirq = parseInt(parts[7]);
                var steal = parseInt(parts[8]);
                var guest = parseInt(parts[9]);
                var guest_nice = parseInt(parts[10]);

                var total = user + nice + system + idle + iowait + irq + softirq + steal;
                var lastTotal = lastCpuStats.total || 0;
                var lastIdle = lastCpuStats.idle || 0;

                var totalDiff = total - lastTotal;
                var idleDiff = idle - lastIdle;

                if (totalDiff > 0) {
                    root.cpuUsage = (1 - idleDiff / totalDiff) * 100;
                }

                lastCpuStats.total = total;
                lastCpuStats.idle = idle;
            }
        }
    }

    Process {
        id: memoryUsageProcess
        command: ["cat", "/proc/meminfo"]
        running: false
        onExited: exitCode => {
            // Process completed
        }
        stdout: StdioCollector {
            onStreamFinished: {
                var lines = text.split("\n");
                var memTotal = 0;
                var memFree = 0;
                var buffers = 0;
                var cached = 0;
                for (var i = 0; i < lines.length; i++) {
                    if (lines[i].startsWith("MemTotal:")) {
                        memTotal = parseInt(lines[i].split(/\s+/)[1]);
                    } else if (lines[i].startsWith("MemFree:")) {
                        memFree = parseInt(lines[i].split(/\s+/)[1]);
                    } else if (lines[i].startsWith("Buffers:")) {
                        buffers = parseInt(lines[i].split(/\s+/)[1]);
                    } else if (lines[i].startsWith("Cached:")) {
                        cached = parseInt(lines[i].split(/\s+/)[1]);
                    }
                }
                var memUsed = memTotal - memFree - buffers - cached;
                root.memoryUsage = (memUsed / memTotal) * 100;
                root.usedMemoryMB = memUsed / 1024;
                root.totalMemoryMB = memTotal / 1024;
            }
        }
    }

    Process {
        id: networkUsageProcess
        property var lastNetworkStats: ({})
        command: ["cat", "/proc/net/dev"]
        running: false
        onExited: exitCode => {
            // Process completed
        }
        stdout: StdioCollector {
            onStreamFinished: {
                var lines = text.split("\n");
                var totalRx = 0;
                var totalTx = 0;
                var newInterfaces = [];
                for (var i = 2; i < lines.length; i++) {
                    var parts = lines[i].trim().split(/\s+/);
                    if (parts.length > 10) {
                        var iface = parts[0].replace(":", "");
                        var rx = parseInt(parts[1]);
                        var tx = parseInt(parts[9]);
                        totalRx += rx;
                        totalTx += tx;
                        newInterfaces.push({
                            name: iface,
                            rx: rx,
                            tx: tx
                        });
                    }
                }
                root.networkInterfaces = newInterfaces;

                var lastTotalRx = lastNetworkStats.totalRx || 0;
                var lastTotalTx = lastNetworkStats.totalTx || 0;
                var lastTime = lastNetworkStats.time || 0;
                var currentTime = new Date().getTime();

                if (lastTime > 0) {
                    var timeDiff = (currentTime - lastTime) / 1000;
                    if (timeDiff > 0) {
                        root.networkRxRate = (totalRx - lastTotalRx) / timeDiff;
                        root.networkTxRate = (totalTx - lastTotalTx) / timeDiff;
                    }
                }

                lastNetworkStats.totalRx = totalRx;
                lastNetworkStats.totalTx = totalTx;
                lastNetworkStats.time = currentTime;
            }
        }
    }

    Process {
        id: diskUsageProcess
        command: ["df", "-h"]
        running: false
        onExited: exitCode => {
            // Process completed
        }
        stdout: StdioCollector {
            onStreamFinished: {
                var lines = text.split("\n");
                var newDisks = [];
                for (var i = 1; i < lines.length; i++) {
                    var parts = lines[i].trim().split(/\s+/);
                    if (parts.length >= 6) {
                        newDisks.push({
                            filesystem: parts[0],
                            size: parts[1],
                            used: parts[2],
                            available: parts[3],
                            use: parts[4],
                            mounted: parts[5]
                        });
                    }
                }
                root.disks = newDisks;
            }
        }
    }

    Process {
        id: processListProcess
        command: ["ps", "aux"]
        running: false
        onExited: exitCode => {
            // Process completed
        }
        stdout: StdioCollector {
            onStreamFinished: {
                var lines = text.split("\n");
                var newProcesses = [];
                for (var i = 1; i < lines.length; i++) {
                    var parts = lines[i].trim().split(/\s+/);
                    if (parts.length >= 11) {
                        newProcesses.push({
                            user: parts[0],
                            pid: parts[1],
                            cpu: parts[2],
                            mem: parts[3],
                            vsz: parts[4],
                            rss: parts[5],
                            tty: parts[6],
                            stat: parts[7],
                            start: parts[8],
                            time: parts[9],
                            command: parts.slice(10).join(" ")
                        });
                    }
                }
                root.processes = newProcesses;
            }
        }
    }
/*
    Process {
        id: nvmlCheckProcess
        command: ["python", "-c", "import pynvml"]
        running: false
        onExited: exitCode => {
            if (exitCode === 0) {
                nvmlGpuProcess.running = true;
            } else {
                // pynvml not available, try amdgpu
                amdgpuProcess.running = true;
            }
        }
    }

    Process {
        id: nvmlGpuProcess
        command: ["/home/sairu/.config/quickshell/nvml_env/bin/python", "/home/sairu/.config/quickshell/scripts/nvidia_gpu_temp.py"]
        running: false
        onExited: exitCode => {
            // Process completed
        }
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.trim()) {
                    try {
                        const data = JSON.parse(text.trim());
                        if (data.gpus && Array.isArray(data.gpus)) {
                            root.availableGpus = data.gpus.map(gpu => ({
                                "driver": "nvidia",
                                "vendor": "NVIDIA",
                                "displayName": gpu.name || "Unknown NVIDIA GPU",
                                "fullName": gpu.name || "Unknown NVIDIA GPU",
                                "pciId": gpu.pci_id || "",
                                "temperature": gpu.temperature || 0,
                                "memoryUsed": gpu.memory_used || 0,
                                "memoryTotal": gpu.memory_total || 0,
                                "memoryUsedMB": gpu.memory_used_mb || 0,
                                "memoryTotalMB": gpu.memory_total_mb || 0
                            }));
                        }
                    } catch (e) {
                        // Failed to parse JSON
                    }
                }
            }
        }
    }
*/
    Process {
        id: amdgpuProcess
        command: ["python", "/home/sairu/dotfiles/config_dotfiles/config/quickshell/scripts/amd_gpu_temp.py"]
        running: false
        onExited: exitCode => {
            // Process completed
        }
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.trim()) {
                    try {
                        const data = JSON.parse(text.trim());
                        if (data.gpus && Array.isArray(data.gpus)) {
                            const amdGpus = data.gpus.map(gpu => ({
                                "driver": "amdgpu",
                                "vendor": "AMD",
                                "displayName": gpu.displayName || gpu.name || "Unknown AMD GPU",
                                "fullName": gpu.fullName || gpu.name || "Unknown AMD GPU",
                                "pciId": gpu.pciId || "",
                                "temperature": gpu.temperature || 0,
                                "memoryUsed": gpu.memoryUsed || 0,
                                "memoryTotal": gpu.memoryTotal || 0,
                                "memoryUsedMB": gpu.memoryUsedMB || 0,
                                "memoryTotalMB": gpu.memoryTotalMB || 0
                            }));
                            // Combine with existing GPUs if any
                            root.availableGpus = root.availableGpus.concat(amdGpus);
                        }
                    } catch (e) {
                        // Failed to parse JSON
                    }
                }
            }
        }
    }
}
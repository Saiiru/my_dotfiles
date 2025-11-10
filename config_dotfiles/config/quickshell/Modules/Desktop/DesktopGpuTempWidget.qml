import QtQuick
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import qs.Common
import qs.Services
import qs.Widgets

PanelWindow {
    id: root

    property var modelData: null
    property var screen: modelData
    property real widgetWidth: 256
    property real widgetHeight: 128
    property bool alwaysVisible: SettingsData.desktopGpuTempEnabled
    property string position: SettingsData.desktopGpuTempPosition
    property real widgetOpacity: SettingsData.desktopGpuTempOpacity
    property var positioningBox: null
    
    // Dynamic sizing based on widget dimensions
    property real scaleFactor: Math.min(widgetWidth / 256, widgetHeight / 128)
    property real baseFontSize: 16
    property real scaledFontSize: baseFontSize * scaleFactor
    property real baseSpacing: 8
    property real scaledSpacing: baseSpacing * scaleFactor
    property real basePadding: 16
    property real scaledPadding: basePadding * scaleFactor
    
    // Fixed height for 256x128 widget
    property real contentHeight: 128
    
    // GPU data properties
    property real currentGpuTemperature: (DgopService.availableGpus && DgopService.availableGpus.length > 0) ? (DgopService.availableGpus[0].temperature || -1) : -1
    property real currentGpuMemoryUsed: (DgopService.availableGpus && DgopService.availableGpus.length > 0) ? (DgopService.availableGpus[0].memoryUsedMB || 0) : 0
    property real currentGpuMemoryTotal: (DgopService.availableGpus && DgopService.availableGpus.length > 0) ? (DgopService.availableGpus[0].memoryTotalMB || 0) : 0
    
    // Graph data array for historical data
    property var gpuTempHistory: []
    property int maxHistoryPoints: 20

    implicitWidth: widgetWidth
    implicitHeight: contentHeight
    visible: alwaysVisible

    WlrLayershell.layer: WlrLayershell.Background
    WlrLayershell.namespace: "quickshell:desktop:gpuTemp"
    WlrLayershell.exclusiveZone: -1
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    color: "transparent"

    // Position using anchors and margins like notifications
    anchors {
        left: position.includes("left") ? true : false
        right: position.includes("right") ? true : false
        top: position.includes("top") ? true : false
        bottom: position.includes("bottom") ? true : false
    }

    margins {
        left: position.includes("left") ? 20 : 0
        right: position.includes("right") ? 20 : 0
        top: position.includes("top") ? (SettingsData.topBarHeight + SettingsData.topBarSpacing + SettingsData.topBarBottomGap + 20) : 0
        bottom: position.includes("bottom") ? (SettingsData.dockExclusiveZone + SettingsData.dockBottomGap + 20) : 0
    }

    Component.onCompleted: {
        DgopService.addRef(["gpu"]);
        startGpuMonitoring();
        
        // Initialize graph with some sample data
        for (var i = 0; i < 5; i++) {
            gpuTempHistory.push(0);
        }
    }

    // Update data when services change
    Connections {
        target: DgopService
        function onAvailableGpusChanged() {
            currentGpuTemperature = (DgopService.availableGpus && DgopService.availableGpus.length > 0) ? (DgopService.availableGpus[0].temperature || -1) : -1;
        }
    }

    // Update widget when settings change
    Connections {
        target: SettingsData
        function onDesktopGpuTempEnabledChanged() {
            alwaysVisible = SettingsData.desktopGpuTempEnabled;
        }
        function onDesktopGpuTempPositionChanged() {
            position = SettingsData.desktopGpuTempPosition;
        }
        function onDesktopGpuTempOpacityChanged() {
            widgetOpacity = SettingsData.desktopGpuTempOpacity;
        }
        function onDesktopGpuTempWidthChanged() {
            widgetWidth = SettingsData.desktopGpuTempWidth;
        }
        function onDesktopGpuTempHeightChanged() {
            widgetHeight = SettingsData.desktopGpuTempHeight;
        }
    }

    // Function to get GPU temperature
    function getGpuTemperature() {
        if (!DgopService.availableGpus || DgopService.availableGpus.length === 0) {
            return -1;
        }
        
        if (SettingsData.desktopGpuSelection === "auto") {
            const gpu = DgopService.availableGpus[0];
            return gpu.temperature !== undefined ? gpu.temperature : -1;
        }
        
        const options = SettingsData.getGpuDropdownOptions();
        const selectedIndex = options.indexOf(SettingsData.desktopGpuSelection);
        
        if (selectedIndex > 0 && selectedIndex <= DgopService.availableGpus.length) {
            const gpuIndex = selectedIndex - 1;
            const gpu = DgopService.availableGpus[gpuIndex];
            return gpu.temperature || -1;
        }
        
        return -1;
    }
    
    // Function to shorten GPU name
    function getShortGpuName() {
        if (!DgopService.availableGpus || DgopService.availableGpus.length === 0) {
            return "GPU";
        }
        
        const gpu = DgopService.availableGpus[0];
        const fullName = gpu.displayName || "GPU";
        
        // Check if this is a Radeon GPU that might be disabled in BIOS
        const isRadeon = /radeon/i.test(fullName) || /amd/i.test(fullName);
        
        // If it's a Radeon GPU, check if it's actually functional
        // Radeon GPUs disabled in BIOS typically show no temperature or very low values
        if (isRadeon) {
            const temperature = gpu.temperature || -1;
            const memoryTotal = gpu.memoryTotalMB || 0;
            
            // If temperature is -1 or 0 and no memory, likely disabled in BIOS
            if (temperature <= 0 && memoryTotal === 0) {
                return ""; // Return empty string to hide the GPU section
            }
        }
        
        // Remove common prefixes
        let shortName = fullName
            .replace(/^NVIDIA\s+GeForce\s+/i, "") // Remove "NVIDIA GeForce " prefix
            .replace(/^GeForce\s+/i, "") // Remove "GeForce " prefix (in case NVIDIA was already removed)
            .replace(/^AMD\s+Radeon\s+/i, "") // Remove "AMD Radeon " prefix
            .replace(/^Radeon\s+/i, "") // Remove "Radeon " prefix (in case AMD was already removed)
            .replace(/^Intel\s+Arc\s+/i, "") // Remove "Intel Arc " prefix
            .replace(/^Intel\s+UHD\s+/i, "") // Remove "Intel UHD " prefix
            .replace(/^Intel\s+HD\s+/i, "") // Remove "Intel HD " prefix
            .replace(/^NVIDIA\s+/i, "") // Remove "NVIDIA " prefix (fallback)
            .replace(/^AMD\s+/i, "") // Remove "AMD " prefix (fallback)
            .replace(/^Intel\s+/i, "") // Remove "Intel " prefix (fallback)
            .replace(/\s*\/\s*Max-Q.*$/i, "") // Remove "/ Max-Q" and anything after
            .trim();
        
        // If we removed everything, fall back to original
        if (!shortName) return fullName;
        
        return shortName;
    }

    // Function to start GPU monitoring
    function startGpuMonitoring() {
        gpuTempProcess.running = true;
    }

    Component.onDestruction: {
        DgopService.removeRef(["gpu"]);
    }

    // GPU temperature monitoring process
    Process {
        id: gpuTempProcess
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
                            if (!DgopService.availableGpus || DgopService.availableGpus.length === 0) {
                                const gpuList = [];
                                for (const gpu of data.gpus) {
                                    gpuList.push({
                                        "driver": gpu.driver || "amdgpu",
                                        "vendor": gpu.vendor || "AMD",
                                        "displayName": gpu.displayName || gpu.name || "Unknown GPU",
                                        "fullName": gpu.fullName || gpu.name || "Unknown GPU",
                                        "pciId": gpu.pciId || "",
                                        "temperature": gpu.temperature || 0,
                                        "memoryUsed": gpu.memoryUsed || 0,
                                        "memoryTotal": gpu.memoryTotal || 0,
                                        "memoryUsedMB": gpu.memoryUsedMB || 0,
                                        "memoryTotalMB": gpu.memoryTotalMB || 0
                                    });
                                }
                                DgopService.availableGpus = gpuList;
                            } else {
                                const updatedGpus = DgopService.availableGpus.slice();
                                for (var i = 0; i < updatedGpus.length; i++) {
                                    const existingGpu = updatedGpus[i];
                                    let amdGpu = data.gpus.find(g => g.pciId === existingGpu.pciId);
                                    if (!amdGpu && i < data.gpus.length) {
                                        amdGpu = data.gpus[i];
                                    }
                                    if (amdGpu) {
                                        updatedGpus[i] = Object.assign({}, existingGpu, {
                                            "temperature": amdGpu.temperature || 0,
                                            "memoryUsed": amdGpu.memoryUsed || 0,
                                            "memoryTotal": amdGpu.memoryTotal || 0,
                                            "memoryUsedMB": amdGpu.memoryUsedMB || 0,
                                            "memoryTotalMB": amdGpu.memoryTotalMB || 0
                                        });
                                    }
                                }
                                DgopService.availableGpus = updatedGpus;
                            }
                        }
                    } catch (e) {
                        // Failed to parse JSON
                    }
                }
            }
        }
    }

    // Timer for regular GPU updates
    Timer {
        id: gpuUpdateTimer
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            gpuTempProcess.running = true;
        }
    }

    // Timer for graph data updates
    Timer {
        id: graphUpdateTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            // Update GPU temperature history
            gpuTempHistory.push(currentGpuTemperature);
            if (gpuTempHistory.length > maxHistoryPoints) {
                gpuTempHistory.shift();
            }
            gpuTempHistoryChanged();
        }
    }

    // Main widget container - professional design
    Rectangle {
        width: widgetWidth
        height: contentHeight
        radius: Theme.cornerRadius
        color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g, Theme.surfaceContainer.b, widgetOpacity)
        border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.3)
        border.width: 1
        opacity: widgetOpacity

        // Professional gradient background
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(Theme.surfaceContainerHigh.r, Theme.surfaceContainerHigh.g, Theme.surfaceContainerHigh.b, widgetOpacity - 0.05) }
            GradientStop { position: 1.0; color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g, Theme.surfaceContainer.b, widgetOpacity) }
        }

        // Enhanced drop shadow
        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: 8
            radius: 24
            samples: 32
            color: Qt.rgba(0, 0, 0, 0.4)
            transparentBorder: true
        }

        // Clean content layout
        Column {
            anchors.fill: parent
            anchors.margins: scaledPadding
            spacing: scaledSpacing
            
            // GPU Name at top
            StyledText {
                text: getShortGpuName()
                font.pixelSize: 16 * scaleFactor
                color: Theme.surfaceTextMedium
                font.weight: Font.Bold
                anchors.horizontalCenter: parent.horizontalCenter
                elide: Text.ElideRight
                maximumLineCount: 1
            }
            
            // GPU Temperature and Graph side by side
            Row {
                width: parent.width
                height: parent.height - 24 * scaleFactor // Leave space for header
                spacing: 12 * scaleFactor
                
                // GPU Temperature (left)
                Column {
                    width: 80 * scaleFactor
                    height: parent.height
                    spacing: 4 * scaleFactor
                    
                    StyledText {
                        text: "TEMP"
                        font.pixelSize: 10 * scaleFactor
                        color: Theme.surfaceTextMedium
                        font.weight: Font.Bold
                        font.letterSpacing: 0.5
                    }
                    
                    StyledText {
                        text: currentGpuTemperature > 0 ? Math.round(currentGpuTemperature) + "°C" : "--°C"
                        font.pixelSize: 32 * scaleFactor
                        font.weight: Font.Bold
                        color: {
                            if (currentGpuTemperature > 85) return Theme.tempDanger
                            if (currentGpuTemperature > 70) return Theme.tempWarning
                            return Theme.surfaceText
                        }
                    }
                }
                
                // GPU Temperature Graph (right)
                Rectangle {
                    width: parent.width - 80 * scaleFactor - 12 * scaleFactor
                    height: parent.height
                    radius: Theme.cornerRadius * 0.3
                    color: Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, 0.8)
                    border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
                    border.width: 1
                    
                    Canvas {
                        id: gpuTempGraph
                        anchors.fill: parent
                        anchors.margins: 2
                        
                        onPaint: {
                            var ctx = getContext("2d");
                            ctx.clearRect(0, 0, width, height);
                            
                            if (gpuTempHistory.length < 2) return;
                            
                            ctx.strokeStyle = currentGpuTemperature > 85 ? Theme.tempDanger : (currentGpuTemperature > 70 ? Theme.tempWarning : Theme.primary);
                            ctx.lineWidth = 2;
                            ctx.beginPath();
                            
                            var stepX = width / (maxHistoryPoints - 1);
                            var maxValue = 100; // Assume max temp is 100°C for visualization
                            
                            for (var i = 0; i < gpuTempHistory.length; i++) {
                                var x = i * stepX;
                                var y = height - (gpuTempHistory[i] / maxValue) * height;
                                
                                if (i === 0) {
                                    ctx.moveTo(x, y);
                                } else {
                                    ctx.lineTo(x, y);
                                }
                            }
                            
                            ctx.stroke();
                        }
                        
                        onWidthChanged: requestPaint();
                        onHeightChanged: requestPaint();
                    }
                    
                    Connections {
                        target: root
                        function onGpuTempHistoryChanged() {
                            gpuTempGraph.requestPaint();
                        }
                    }
                }
            }
        }

        // Make the widget draggable
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.SizeAllCursor
            onPressed: {
                if (alwaysVisible) {
                    // Widget is always visible, no need to show/hide
                }
            }
        }
    }
}
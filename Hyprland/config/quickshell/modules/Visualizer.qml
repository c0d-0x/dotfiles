import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Item {
    id: root

    required property var colours
    property var panelWindow: null

    implicitWidth: toggleIcon.implicitWidth + 10
    implicitHeight: 22

    PersistentProperties {
        id: persistent
        property bool active: false
    }

    Process {
        id: cava
        command: ["cava", "-p", Quickshell.shellDir + "/modules/cava.conf"]
        running: persistent.active

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => root.processCavaFrame(data)
        }

        onExited: {
            if (persistent.active) restartTimer.restart()
        }
    }

    Timer {
        id: restartTimer
        interval: 1000
        onTriggered: {
            if (persistent.active) cava.running = true
        }
    }

    // --- Audio state ---
    property var spectrum: []
    property var smoothed: [] 
    property var rendered: []
    property real bassEnergy: 0
    property real midEnergy: 0
    property real highEnergy: 0
    property real previousBass: 0
    property real previousMid: 0
    property real previousHigh: 0
    property real beatPulse: 0

    readonly property int barCount: 64
    readonly property real sensitivity: 1.65
    readonly property real smoothing: 0.014
    readonly property real decay: 0.12
    readonly property real ridgeSharpness: 2.4
    readonly property real bassBoost: 1.7
    readonly property real midBoost: 1.0
    readonly property real highBoost: 1.5
    readonly property real waveSmooth: 0.25
    readonly property real beatSensitivity: 1.2
    readonly property real beatDecay: 0.11
    readonly property real frequencyCurve: 0.82
    readonly property real centerBassWeight: 0.45
    readonly property real centerBassEnergy: 0.35
    readonly property real beatPulseStrength: 0.7
    readonly property real transientThreshold: 0.018
    readonly property real transientMultiplier: 7.5
    readonly property real peakSharpen: 0.5
    readonly property real edgeFloor: 0.00
    readonly property real edgeFalloff: 0.7
    readonly property real maxHeightRatio: 0.7
    readonly property real limiterKnee: 0.10
    readonly property real topGapRatio: 0.015
    readonly property real restThreshold: 0.02
    readonly property real fadeRange: 0.08

    Text {
        id: toggleIcon
        anchors.centerIn: parent
        text: !persistent.active? "󰝛":""
        color: persistent.active
            ? (root.colours ? root.colours.border : "#ffffff")
            : (root.colours ? root.colours.foreground : "#ffffff")
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 15
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            persistent.active = !persistent.active
            if (!persistent.active) {
                root.spectrum = []
                root.smoothed = []
                root.rendered = []
                canvas.requestPaint()
            }
        }
    }

    function processCavaFrame(line) {
        if (!line) return
        const parts = line.trim().split(/\s+/)
        const values = []
        for (const part of parts) {
            const n = Number(part)
            if (!Number.isNaN(n))
                values.push(Math.max(0, Math.min(1, n / 1000)))
        }
        if (values.length < 2) return
        root.spectrum = values
        updateEnergy(values)
    }

    function updateEnergy(values) {
        const count = values.length
        if (count === 0) return

        const bassEnd = Math.max(1, Math.floor(count * 0.18))
        const midEnd = Math.max(bassEnd + 1, Math.floor(count * 0.62))

        let bass = 0, mid = 0, high = 0
        for (let i = 0; i < bassEnd; ++i) bass += values[i]
        for (let i = bassEnd; i < midEnd; ++i) mid += values[i]
        for (let i = midEnd; i < count; ++i) high += values[i]

        bass /= bassEnd
        mid /= Math.max(1, midEnd - bassEnd)
        high /= Math.max(1, count - midEnd)

        bass = Math.min(1, Math.pow(bass, 0.65) * root.bassBoost)
        mid = Math.min(1, Math.pow(mid, 0.78) * root.midBoost)
        high = Math.min(1, Math.pow(high, 0.72) * root.highBoost)

        root.bassEnergy = bass
        root.midEnergy = mid
        root.highEnergy = high

        const bassRise = Math.max(0, bass - root.previousBass)
        const midRise = Math.max(0, mid - root.previousMid)
        const highRise = Math.max(0, high - root.previousHigh)

        const transient = bassRise * 1.5 + midRise * 1.2 + highRise * 0.9
        if (transient > root.transientThreshold) {
            root.beatPulse = Math.max(root.beatPulse,
                Math.min(1, transient * root.transientMultiplier * root.beatSensitivity))
        }

        root.previousBass = bass
        root.previousMid = mid
        root.previousHigh = high
    }

    function spectrumAt(position) {
        if (spectrum.length === 0) return 0
        position = Math.max(0, Math.min(1, position))
        const p = position * (spectrum.length - 1)
        const a = Math.floor(p)
        const b = Math.min(spectrum.length - 1, a + 1)
        const t = p - a
        return spectrum[a] * (1 - t) + spectrum[b] * t
    }

    function targetFor(index) {
        if (spectrum.length === 0) return 0

        const normalized = index / Math.max(1, barCount - 1)
        const distance = Math.abs(normalized - 0.5) * 2
        const freqPos = Math.pow(distance, root.frequencyCurve)

        let value = spectrumAt(freqPos)
        const centerWeight = Math.pow(1 - distance, 2.2)
        value *= 1 + centerWeight * root.centerBassWeight
        value += root.bassEnergy * centerWeight * root.centerBassEnergy

        value = Math.pow(Math.max(0, value), root.ridgeSharpness)

        const energy = root.bassEnergy * 0.50 + root.midEnergy * 0.30 + root.highEnergy * 0.20
        value *= root.sensitivity * (0.70 + energy * 0.45)

        const envelope = root.edgeFloor + (1 - root.edgeFloor)
            * Math.pow(Math.max(0, Math.sin(Math.PI * normalized)), root.edgeFalloff)
        value *= envelope

        value = Math.max(0, value)
        if (value <= root.limiterKnee) return value
        const room = 1 - root.limiterKnee
        return root.limiterKnee + room * Math.tanh((value - root.limiterKnee) / room)
    }

    FrameAnimation {
        running: persistent.active

        onTriggered: {
            const n = root.barCount
            const old = root.smoothed.length === n
                ? root.smoothed
                : Array.from({ length: n }, () => 0)

            const sm = []
            for (let i = 0; i < n; ++i) {
                let target = root.targetFor(i)
                const normalized = i / Math.max(1, n - 1)
                const distance = Math.abs(normalized - 0.5) * 2
                target += root.bassEnergy * Math.pow(1 - distance, 4) * 0.30

                if (root.waveSmooth > 0) {
                    const l = root.targetFor(Math.max(0, i - 1))
                    const r = root.targetFor(Math.min(n - 1, i + 1))
                    target = target * (1 - root.waveSmooth) + ((l + r) / 2) * root.waveSmooth
                }

                target = Math.max(0, Math.min(1, target))

                const rising = target > old[i]
                const gap = Math.abs(target - old[i])
                const speed = rising ? root.smoothing / (1 + gap * 4) : root.decay
                const amount = 1 - Math.exp(-frameTime / Math.max(0.001, speed))
                let value = old[i] + (target - old[i]) * amount
                if (Math.abs(value - target) < 0.001) value = target

                sm.push(value)
            }

            if (n % 2 === 0 && sm.length >= 2) {
                const lc = n / 2 - 1
                const rc = n / 2
                const center = Math.max(sm[lc], sm[rc])
                sm[lc] = center
                sm[rc] = center
            }

            const out = []
            for (let i = 0; i < n; ++i) {
                const l = sm[Math.max(0, i - 1)]
                const r = sm[Math.min(n - 1, i + 1)]
                const sharp = sm[i] + (sm[i] - (l + r) / 2) * root.peakSharpen
                const v = sharp * (1 + root.beatPulse * root.beatPulseStrength)
                out.push(Math.max(0, Math.min(1, v)))
            }

            root.smoothed = sm
            root.rendered = out
            root.beatPulse *= Math.exp(-frameTime / Math.max(0.001, root.beatDecay))
            canvas.requestPaint()
        }
    }

    PanelWindow {
        id: vizOverlay

        screen: root.panelWindow ? root.panelWindow.screen : null
        visible: persistent.active
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        implicitHeight: screen ? screen.height * 0.12 : 100
        mask: Region {}

        Component.onCompleted: {
            if (vizOverlay.WlrLayershell != null) {
                vizOverlay.WlrLayershell.layer = WlrLayer.Overlay
                vizOverlay.WlrLayershell.namespace = "viz-overlay"
                vizOverlay.WlrLayershell.keyboardFocus = WlrKeyboardFocus.None
            }
        }

        anchors {
            bottom: true
            left: true
            right: true
        }

        margins {
            bottom: 4
            left: 5
            right: 5
        }

        Canvas {
            id: canvas
            anchors.fill: parent
            antialiasing: true
            renderStrategy: Canvas.Cooperative

            onWidthChanged: requestPaint()
            onHeightChanged: requestPaint()

            onPaint: {
                const ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                if (!persistent.active || root.rendered.length === 0) return

                // rest: nothing drawn
                let peak = 0
                for (let i = 0; i < root.rendered.length; ++i)
                    if (root.rendered[i] > peak) peak = root.rendered[i]
                if (peak < root.restThreshold) return
                const level = Math.min(1, (peak - root.restThreshold) / root.fadeRange)

                ctx.save()
                const topGap = height * root.topGapRatio
                ctx.beginPath()
                ctx.rect(0, topGap, width, height - topGap)
                ctx.clip()

                const count = root.rendered.length
                const spacing = width / Math.max(1, count - 1)
                const pad = 3
                const maxH = Math.min((height - pad) * root.maxHeightRatio, height - topGap - pad)
                const points = []

                for (let i = 0; i < count; ++i) {
                    const depth = Math.min(maxH, root.rendered[i] * maxH)
                    points.push({ x: i * spacing, y: Math.max(topGap, height - depth) })
                }

                const fg = root.colours ? root.colours.foreground : "#ffffff"
                const accent = root.colours ? root.colours.border : fg
                const gradient = ctx.createLinearGradient(0, 0, width, 0)
                gradient.addColorStop(0.0, fg)
                gradient.addColorStop(0.5, accent)
                gradient.addColorStop(1.0, fg)

                // fill: straight segments -> pointed tips
                ctx.fillStyle = gradient
                ctx.globalAlpha = 0.55 * level

                ctx.beginPath()
                ctx.moveTo(0, height)
                ctx.lineTo(points[0].x, points[0].y)

                for (let i = 0; i < points.length; ++i)
                    ctx.lineTo(points[i].x, points[i].y)

                ctx.lineTo(width, height)
                ctx.closePath()
                ctx.fill()

                // mitered outline
                ctx.globalAlpha = 0.9 * level
                ctx.lineWidth = 1.5
                ctx.lineJoin = "miter"
                ctx.miterLimit = 2
                ctx.strokeStyle = gradient
                ctx.beginPath()
                ctx.moveTo(points[0].x, points[0].y)
                for (let i = 1; i < points.length; ++i)
                    ctx.lineTo(points[i].x, points[i].y)
                ctx.stroke()

                ctx.restore()
            }
        }
    }

    onColoursChanged: canvas.requestPaint()
}

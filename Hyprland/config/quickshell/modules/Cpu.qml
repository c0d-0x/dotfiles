import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Rectangle {
    id: root

    color: "transparent"

    implicitWidth: layout.implicitWidth + 10
    implicitHeight: layout.implicitHeight
    required property var colours
    property string cpuBars: "▁▁▁▁▁▁▁▁"
    readonly property list<string> barChars: [
        "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█"
    ]

    property var previousCpu: []

    RowLayout {
        id: layout

        anchors.centerIn: parent
        spacing: 5

        Text {
            text: " " + root.cpuBars
            color: root.colours ? root.colours.foreground : "#ffffff"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 15
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            proc.running = true
        }
    }

    Process {
        id: proc

        command: [
            "bash",
            "-c",
            "awk '/^cpu[0-9]/ { " +
            "idle=$5; total=0; " +
            "for(i=2;i<=NF;i++) total+=$i; " +
            "printf \"%d %d \", total, idle " +
            "}' /proc/stat"
        ]

        stdout: SplitParser {
            onRead: data => {
                const values = data.trim().split(/\s+/)
                const current = []

                for (let i = 0; i + 1 < values.length; i += 2) {
                    current.push({
                        total: Number(values[i]),
                        idle: Number(values[i + 1])
                    })
                }

                if (root.previousCpu.length !== current.length) {
                    root.previousCpu = current
                    return
                }

                let newBars = ""

                for (let i = 0; i < current.length; i++) {
                    const previous = root.previousCpu[i]
                    const now = current[i]

                    const totalDelta = now.total - previous.total
                    const idleDelta = now.idle - previous.idle

                    if (totalDelta <= 0) {
                        newBars += root.barChars[0]
                        continue
                    }

                    const usage =
                        (totalDelta - idleDelta) / totalDelta

                    const level = Math.max(
                        0,
                        Math.min(
                            7,
                            Math.floor(usage * 8)
                        )
                    )

                    newBars += root.barChars[level]
                }

                root.previousCpu = current

                if (newBars !== "")
                    root.cpuBars = newBars
            }
        }
    }
}

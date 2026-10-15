import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Rectangle {
    id: root

    required property var colours
    property int barCount: 0
    property int maxBars: 0
    readonly property int coreCount: previousCpu.length
    property real totalUsage: 0
    property string cpuBars: root.barCount > 0 ? root.barChars[0].repeat(root.barCount) : ""
    readonly property var barChars: ["▁", "▂", "▃", "▄", "▅", "▆", "▇", "█"]
    property var previousCpu: []

    function calculateTargetBars(cores) {
        if (cores <= 0)
            return 0;

        if (root.barCount > 0)
            return Math.min(root.barCount, cores);

        if (root.maxBars > 0 && cores > root.maxBars)
            return root.maxBars;

        return cores;
    }

    color: "transparent"
    implicitWidth: layout.implicitWidth + 10
    implicitHeight: layout.implicitHeight

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
            proc.running = true;
        }
    }

    Process {
        id: proc

        command: ["bash", "-c", "awk 'BEGIN { c=0 } /^cpu[0-9]/ { c++; idle=$5; total=0; for(i=2;i<=NF;i++) total+=$i; printf \"%d %d \", total, idle } /^cpu / { agg_idle=$5; agg_total=0; for(i=2;i<=NF;i++) agg_total+=$i } END { if (c == 0) printf \"%d %d \", agg_total, agg_idle; printf \"\\n\" }' /proc/stat"]

        stdout: SplitParser {
            onRead: (data) => {
                const values = data.trim().split(/\s+/);
                const current = [];
                for (let i = 0; i + 1 < values.length; i += 2) {
                    current.push({
                        "total": Number(values[i]),
                        "idle": Number(values[i + 1])
                    });
                }
                if (current.length === 0)
                    return ;

                const targetBars = root.calculateTargetBars(current.length);
                if (root.previousCpu.length !== current.length) {
                    root.previousCpu = current;
                    if (targetBars > 0)
                        root.cpuBars = root.barChars[0].repeat(targetBars);

                    return ;
                }
                if (targetBars <= 0) {
                    root.previousCpu = current;
                    return ;
                }
                let newBars = "";
                let sumUsage = 0;
                for (let b = 0; b < targetBars; b++) {
                    const start = Math.floor(b * current.length / targetBars);
                    const end = Math.floor((b + 1) * current.length / targetBars);
                    let totalDelta = 0;
                    let idleDelta = 0;
                    for (let c = start; c < end; c++) {
                        const prev = root.previousCpu[c];
                        const now = current[c];
                        if (prev && now) {
                            totalDelta += (now.total - prev.total);
                            idleDelta += (now.idle - prev.idle);
                        }
                    }
                    if (totalDelta <= 0) {
                        newBars += root.barChars[0];
                        continue;
                    }
                    const usage = Math.max(0, Math.min(1, (totalDelta - idleDelta) / totalDelta));
                    sumUsage += usage;
                    const maxLevel = root.barChars.length - 1;
                    const level = Math.max(0, Math.min(maxLevel, Math.floor(usage * root.barChars.length)));
                    newBars += root.barChars[level];
                }
                root.totalUsage = targetBars > 0 ? (sumUsage / targetBars) : 0;
                root.previousCpu = current;
                if (newBars !== "")
                    root.cpuBars = newBars;

            }
        }

    }

}

import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Rectangle {
    id: root

    property string memoryUsage: "0"
    required property var colours

    color: "transparent"
    implicitWidth: layout.implicitWidth + 10
    implicitHeight: layout.implicitHeight

    RowLayout {
        id: layout

        anchors.centerIn: parent
        spacing: 5

        Text {
            text: " " + root.memoryUsage + "%"
            color: root.colours ? root.colours.foreground : "#ffffff"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 15
        }

    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            proc.running = true;
        }
    }

    Process {
        id: proc

        command: ["bash", "-c", "awk '/MemTotal/{t=$2} /MemAvailable/{a=$2} END{printf \"%d\", (1-a/t)*100}' /proc/meminfo"]

        stdout: SplitParser {
            onRead: (data) => {
                root.memoryUsage = data.trim();
            }
        }

    }

}

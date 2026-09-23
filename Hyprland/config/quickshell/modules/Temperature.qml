import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Rectangle {
    id: root

    property int tempVal: 0
    required property var colours

    color: "transparent"
    implicitWidth: layout.implicitWidth + 10
    implicitHeight: layout.implicitHeight

    RowLayout {
        id: layout

        anchors.centerIn: parent
        spacing: 5

        Text {
            text: " " + root.tempVal + "°C"
            color: root.tempVal > 80 ? "#ff0000" : (root.colours ? root.colours.foreground : "#ffffff")
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

        command: ["bash", "-c", "cat /sys/class/thermal/thermal_zone0/temp"]

        stdout: SplitParser {
            onRead: (data) => {
                let temp = parseInt(data.trim());
                if (!isNaN(temp))
                    root.tempVal = Math.round(temp / 1000);

            }
        }

    }

}

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Rectangle {
    id: root

    property string powerVal: "0"
    required property var colours

    color: "transparent"
    implicitWidth: layout.implicitWidth + 10
    implicitHeight: layout.implicitHeight
    visible: powerText.text !== " 0w"

    RowLayout {
        id: layout

        anchors.centerIn: parent
        spacing: 5

        Text {
            id: powerText

            text: " " + root.powerVal + "w"
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

        command: ["bash", "-c", "cat /sys/class/power_supply/BAT*/power_now 2>/dev/null || echo ''"]

        stdout: SplitParser {
            onRead: (data) => {
                let str = data.trim();
                if (str === "") {
                    root.visible = false;
                    return ;
                }
                let power = parseInt(str);
                if (!isNaN(power)) {
                    root.powerVal = (power / 1e+06).toFixed(1).replace(".0", "");
                    root.visible = true;
                }
            }
        }

    }

}

import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Rectangle {
    id: root

    property int brightness: 0
    property int maxBrightness: 100
    property var icons: ["󰃞", "󰃟", "󰃟", "󰃟", "󰃠"]
    required property var colours

    color: "transparent"
    implicitWidth: layout.implicitWidth + 10
    implicitHeight: layout.implicitHeight
    visible: true

    RowLayout {
        id: layout

        property string icon: {
            if (root.brightness >= 100)
                return icons[4];

            if (root.brightness >= 80)
                return icons[3];

            if (root.brightness >= 60)
                return icons[2];

            if (root.brightness >= 40)
                return icons[1];
            else
                return icons[0];
        }

        anchors.centerIn: parent
        spacing: 3

        Text {
            id: iconText

            text: layout.icon + " " + root.brightness + "%"
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

        command: ["bash", "-c", "light -G 2>/dev/null || echo ''"]

        stdout: SplitParser {
            onRead: (data) => {
                let str = data.trim();
                if (str === "") {
                    root.visible = false;
                    return ;
                }
                let val = parseInt(str);
                if (!isNaN(val)) {
                    root.brightness = val;
                    root.visible = true;
                }
            }
        }

    }

}

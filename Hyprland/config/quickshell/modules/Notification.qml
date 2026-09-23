import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Rectangle {
    id: root

    property string iconStr: "󰂚"
    required property var colours

    color: "transparent"
    implicitWidth: layout.implicitWidth + 10
    implicitHeight: layout.implicitHeight

    RowLayout {
        id: layout

        anchors.centerIn: parent
        spacing: 5

        Text {
            text: root.iconStr
            color: root.colours ? root.colours.foreground : "#ffffff"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 15
        }

    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            toggleProc.running = true;
        }
    }

    Process {
        id: toggleProc

        command: ["swaync-client", "-t", "-sw"]
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

        command: ["swaync-client", "-swb"]

        stdout: SplitParser {
            onRead: (data) => {
                try {
                    let state = JSON.parse(data.trim());
                    let dnd = state.dnd;
                    let count = state.count;
                    if (dnd)
                        root.iconStr = count > 0 ? "󰂛" : "󰂏";
                    else
                        root.iconStr = count > 0 ? "󰂢" : "󰂚";
                } catch (e) {
                    root.iconStr = "󰂚";
                }
            }
        }

    }

}

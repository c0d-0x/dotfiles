import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

Rectangle {
    id: root

    required property var colours
    color: colours? colours.foreground: "#ffffff"
    radius: 4

    property string activeTracker: ""
    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight+3

    readonly property list<string> persistent: [
        "1", "2", "3", "4", "5", "6", "7", "8", "9"
    ]

    readonly property var visibleWsps: root.persistent
    property string activeWorkspace: {
        (()=> {
                if (Hyprland.focusedWorkspace) 
                    return Hyprland.focusedWorkspace.name;
                
            
        })()
    }


    RowLayout {
        id: layout

        anchors.centerIn: parent
        spacing: 0

        Repeater {
            model: root.visibleWsps

            delegate: Item {
                id: wsItem

                required property string modelData
                readonly property bool active: root.activeWorkspace === modelData

                implicitWidth: label.implicitWidth + 10
                implicitHeight: label.implicitHeight + 4

                Text {
                    id: label

                    anchors.centerIn: parent
                    text: wsItem.active ? "" : ""
                    color: wsItem.active ? "#ff0000" : root.colours? root.colours.background : "#000000"

                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 15

                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        Hyprland.dispatch( "hl.dsp.focus({ workspace = " + wsItem.modelData + "})")
                    }
                }
            }
        }
    }
}

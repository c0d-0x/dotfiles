//@ pragma UseQApplication
//@ pragma ComponentBehavior:Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import "modules" as Modules

ShellRoot {
    id: root

    property var colours: null
    readonly property string colourPath: "file:///home/c0d_0x/.cache/hellwal/Colours.qml"

    Loader {
        id: colourLoader

        source: root.colourPath
        active: true
        asynchronous: false
        onLoaded: {
            if (colourLoader.item)
                root.colours = colourLoader.item;

        }

        Connections {
            function onRawEvent(event) {
                if (event.name === "configreloaded")
                    (() => {
                    colourLoader.source = "";
                    Qt.callLater(() => {
                        colourLoader.source = root.colourPath + "?t=" + Date.now();
                    });
                })();

            }

            target: Hyprland
        }

    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: win

            required property var modelData

            screen: modelData
            implicitHeight: Math.max(leftRow.implicitHeight, rightRow.implicitHeight, clockWidget.implicitHeight) + 6
            color: "transparent"
            exclusionMode: ExclusionMode.Auto
            Component.onCompleted: {
                if (win.WlrLayershell != null) {
                    win.WlrLayershell.layer = WlrLayer.Top;
                    win.WlrLayershell.namespace = "quickshell-bar";
                }
            }

            anchors {
                top: true
                left: true
                right: true
            }

            margins {
                top: 4
                left: 3
                right: 3
                bottom: 1
            }

            Rectangle {
                anchors.fill: parent
                color: root.colours ? root.colours.background : "#000000"
                border.color: root.colours ? root.colours.border : "#ffffff"
                border.width: 1
                topLeftRadius: 0
                topRightRadius: 0
                bottomLeftRadius: 10
                bottomRightRadius: 10

                RowLayout {
                    id: leftRow

                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    Text {
                        text: "\uf303"
                        color: "blue"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 20
                    }

                    Modules.Workspaces {
                        colours: root.colours
                    }

                    Modules.ActiveWindow {
                        colours: root.colours
                    }

                    Modules.IdleInhibitor {
                        panelWindow: win
                        colours: root.colours
                    }

                }

                Modules.Clock {
                    id: clockWidget

                    anchors.centerIn: parent
                    colours: root.colours
                }

                RowLayout {
                    id: rightRow

                    anchors.right: parent.right
                    anchors.rightMargin: 6
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    Modules.SysTray {
                        colours: root.colours
                    }

                    Modules.Notification {
                        colours: root.colours
                    }

                    Modules.Memory {
                        colours: root.colours
                    }

                    Modules.Cpu {
                        colours: root.colours
                    }

                    Modules.Temperature {
                        colours: root.colours
                    }

                    Modules.PowerDraw {
                        colours: root.colours
                    }

                    Modules.Backlight {
                        colours: root.colours
                    }

                    Modules.Audio {
                        colours: root.colours
                    }

                    Modules.Battery {
                        colours: root.colours
                    }

                }

            }

        }

    }

}

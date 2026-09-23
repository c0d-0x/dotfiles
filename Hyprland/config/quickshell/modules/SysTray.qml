import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

Rectangle {
    id: root

    required property var colours

    color: "transparent"
    implicitWidth: layout.implicitWidth + 10
    implicitHeight: layout.implicitHeight

    RowLayout {
        id: layout

        anchors.centerIn: parent
        spacing: 5

        Repeater {
            model: SystemTray.items

            delegate: Rectangle {
                id: trayDelegate

                required property var modelData

                radius: 5
                color: "transparent"
                implicitWidth: 24
                implicitHeight: 24

                IconImage {
                    anchors.centerIn: parent
                    source: trayDelegate.modelData.icon
                    implicitWidth: 18
                    implicitHeight: 18
                }

                MouseArea {
                    id: trayHover

                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    cursorShape: Qt.PointingHandCursor
                    onClicked: (mouse) => {
                        if (mouse.button === Qt.RightButton && trayDelegate.modelData.hasMenu)
                            trayMenu.open();
                        else
                            trayDelegate.modelData.activate();
                    }
                }

                QsMenuAnchor {
                    id: trayMenu

                    anchor.item: trayDelegate
                    menu: trayDelegate.modelData.menu
                }

            }

        }

    }

}

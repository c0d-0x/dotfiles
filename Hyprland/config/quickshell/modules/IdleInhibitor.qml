import QtQuick
import Quickshell
import Quickshell.Wayland

Item {
    id: root

    required property var panelWindow
    required property var colours

    implicitWidth: textItem.implicitWidth + 10
    implicitHeight: textItem.implicitHeight

    PersistentProperties {
        id: persistent

        property bool inhibiting: false
    }

    IdleInhibitor {
        enabled: persistent.inhibiting
        window: root.panelWindow
    }

    Text {
        id: textItem

        anchors.centerIn: parent
        text: persistent.inhibiting ? "󰈈" : "󰈉"
        color: root.colours ? root.colours.foreground : "#ffffff"
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 15
    }

    MouseArea {
        anchors.fill: parent
        onClicked: persistent.inhibiting = !persistent.inhibiting
    }

}

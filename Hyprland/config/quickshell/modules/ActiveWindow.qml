//@ pragma ComponentBehavior:Bound
import QtQuick
import Quickshell.Hyprland

Item {
    id: root
    required property var colours
    readonly property var toplevel: Hyprland.activeToplevel
    readonly property var focusedWorkspace: Hyprland.focusedWorkspace

    readonly property string appId:
        (root.toplevel?.wayland
        && root.focusedWorkspace
        && root.toplevel.workspace
        && root.toplevel.workspace.name === root.focusedWorkspace.name)
            ? (root.toplevel.wayland.appId || "") : ""

    implicitWidth: textItem.implicitWidth + 2
    implicitHeight: textItem.implicitHeight

    Text {
        id: textItem

        anchors.centerIn: parent
        text: " " + root.appId
        color: root.colours ? root.colours.foreground : "#ffffff"
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 15
        font.weight: Font.Medium
    }
}

import QtQuick
import Quickshell
import Quickshell.Services.UPower

Rectangle {
    id: batteryModule

    required property var colours
    property var bat: UPower.displayDevice
    property real pct: bat ? (bat.percentage <= 1 ? bat.percentage * 100 : bat.percentage) : 0
    property bool charging: bat ? (bat.state === UPowerDeviceState.Charging || bat.state === UPowerDeviceState.FullyCharged) : false
    property bool critical: pct <= 10 && !charging
    property string icon: {
        if (charging)
            return "󰂄";

        if (pct >= 95)
            return "󰁹";

        if (pct >= 80)
            return "󰂂";

        if (pct >= 60)
            return "󰂀";

        if (pct >= 40)
            return "󰁾";

        if (pct >= 20)
            return "󰁼";

        return "󰁺";
    }

    radius: 4
    topRightRadius: 0
    implicitWidth: batteryText.implicitWidth + 5
    implicitHeight: batteryText.implicitHeight + 7
    color: (charging) ? "#26a65b" : (batteryModule.colours ? batteryModule.colours.foreground : "#ffffff")

    SequentialAnimation {
        id: blinkAnim

        running: batteryModule.critical
        loops: Animation.Infinite

        ColorAnimation {
            target: batteryModule
            property: "color"
            to: "#ff0000"
            duration: 400
        }

        ColorAnimation {
            target: batteryModule
            property: "color"
            to: "#ffffff"
            duration: 400
        }

    }

    Text {
        id: batteryText

        anchors.centerIn: parent
        text: Math.round(batteryModule.pct) + "% " + batteryModule.icon
        color: batteryModule.charging ? "#ffffff" : (batteryModule.colours ? batteryModule.colours.background : "#000000")
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 15
        leftPadding: 5
        rightPadding: 5
    }

}

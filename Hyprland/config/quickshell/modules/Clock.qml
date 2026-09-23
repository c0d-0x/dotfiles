import QtQuick
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: clockModule

    property bool showDate: false
    required property var colours

    color: colours ? colours.foreground : "#ffffff"
    radius: 5
    implicitWidth: clockText.implicitWidth + 5
    implicitHeight: clockText.implicitHeight + 7

    SystemClock {
        id: clock

        precision: SystemClock.Seconds
    }

    Text {
        id: clockText

        anchors.centerIn: parent
        text: clockModule.showDate ? Qt.formatDateTime(clock.date, "dddd, MMMM dd, yyyy") : Qt.formatDateTime(clock.date, "hh:mm:ss AP")
        color: clockModule.colours ? clockModule.colours.background : "#000000"
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 15
        font.weight: Font.Medium
        leftPadding: 5
        rightPadding: 5
    }

    MouseArea {
        anchors.fill: parent
        onClicked: clockModule.showDate = !clockModule.showDate
    }

}

import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: audioModule

    property int volume: 0
    property bool muted: false
    property string volumeIcon: volume < 33 ? "🕨" : (volume < 66 ? "🕩" : "🕪")
    required property var colours

    function parseVolume(data) {
        let str = data.trim();
        if (str.startsWith("Volume:")) {
            let parts = str.split(" ");
            if (parts.length >= 2) {
                let vol = parseFloat(parts[1]);
                if (!isNaN(vol))
                    audioModule.volume = Math.round(vol * 100);

            }
            audioModule.muted = str.indexOf("[MUTED]") !== -1;
        }
    }

    implicitWidth: audioText.implicitWidth + 10
    implicitHeight: audioText.implicitHeight + 10

    Text {
        id: audioText

        anchors.centerIn: parent
        text: audioModule.muted ? "" : (audioModule.volume + "% " + audioModule.volumeIcon)
        color: audioModule.muted ? "#ff0000" : root.colours ? root.colours.foreground : "#ffffff"
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 15
    }

    // Process to toggle mute
    Process {
        id: toggleAudio

        command: ["bash", "-c", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && wpctl get-volume @DEFAULT_AUDIO_SINK@"]

        stdout: SplitParser {
            onRead: (data) => {
                parseVolume(data);
            }
        }

    }

    // Process to poll volume
    Process {
        id: getAudio

        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]

        stdout: SplitParser {
            onRead: (data) => {
                parseVolume(data);
            }
        }

    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            getAudio.running = true;
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            toggleAudio.running = true;
        }
    }

}

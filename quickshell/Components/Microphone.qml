import QtQuick
import Quickshell
import Quickshell.Io
import "../Themes"
import "../Popups" as Popups

Item {
    id: root

    property string audioSourceScript: Quickshell.shellDir + "/scripts/audio-source.sh"

    property string sourceName: ""
    property string sourceDescription: ""
    property string volume: ""
    property bool muted: false

    implicitWidth: sourceText.implicitWidth + volumeText.width
    implicitHeight: Math.max(sourceText.implicitHeight, volumeText.implicitHeight)

    function updateStatus() {
        if (!statusProcess.running)
            statusProcess.running = true
    }

    function volumeUp() {
        if (!volumeUpProcess.running)
            volumeUpProcess.running = true
    }

    function volumeDown() {
        if (!volumeDownProcess.running)
            volumeDownProcess.running = true
    }

    function toggleMute() {
        if (!muteProcess.running)
            muteProcess.running = true
    }

    Row {

        Text {
            id: sourceText

            text: root.sourceDescription
            color: root.muted ? Theme.microphone.mutedColor : Theme.microphone.textColor
            font.pixelSize: Theme.microphone.fontSize
            font.bold: Theme.microphone.fontBold
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        Text {
            id: volumeText

            width: Theme.microphone.widthVolumeText
            text: root.muted ? "MUTE" : root.volume + "%"
            color: root.muted ? Theme.microphone.mutedColor : Theme.microphone.textColor
            font.pixelSize: Theme.microphone.fontSize
            font.bold: Theme.microphone.fontBold
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }
    }

    MouseArea {
        anchors.fill: parent

        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: function(mouse) {
            if (mouse.button === Qt.LeftButton) {
                microphonePopup.toggle()
            } else if (mouse.button === Qt.RightButton) {
                root.toggleMute()
            }
        }

        onWheel: function(wheel) {
            if (wheel.angleDelta.y > 0) {
                root.volumeUp()
            } else if (wheel.angleDelta.y < 0) {
                root.volumeDown()
            }
        }
    }

    Process {
        id: statusProcess

        command: [root.audioSourceScript, "status"]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = this.text.trim().split("\n")

                if (lines.length < 4)
                    return

                root.sourceName = lines[0]
                root.sourceDescription = lines[1]
                root.volume = lines[2]
                root.muted = lines[3] === "yes"
            }
        }
    }

    Process {
        id: volumeUpProcess

        command: [root.audioSourceScript, "volume-up"]

        onExited: root.updateStatus()
    }

    Process {
        id: volumeDownProcess

        command: [root.audioSourceScript, "volume-down"]

        onExited: root.updateStatus()
    }

    Process {
        id: muteProcess

        command: [root.audioSourceScript, "mute"]

        onExited: root.updateStatus()
    }

    Process {
        id: subscribeProcess

        command: ["pactl", "subscribe"]

        stdout: SplitParser {
            onRead: function(line) {
                if (line.includes(" on source") || line.includes(" on server"))
                    root.updateStatus()
            }
        }
    }

    Popups.Microphone {
        id: microphonePopup

        target: root
        audioSourceScript: root.audioSourceScript

        onSourceChanged: root.updateStatus()
    }

    Component.onCompleted: {
        root.updateStatus()
        subscribeProcess.running = true
    }
}
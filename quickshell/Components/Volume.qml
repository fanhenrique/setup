import QtQuick
import Quickshell
import Quickshell.Io
import "../Themes"
import "../Popups" as Popups

Item {
    id: root

    property string audioSinkScript: Quickshell.shellDir + "/scripts/audio-sink.sh"

    property string sinkName: ""
    property string sinkDescription: ""
    property string volume: ""
    property bool muted: false
    property bool statusPending: false

    implicitWidth: sinkText.implicitWidth + volumeText.width
    implicitHeight: Math.max(
        sinkText.implicitHeight,
        volumeText.implicitHeight
    )

    function updateStatus() {
        statusPending = true

        if (!statusProcess.running) {
            statusPending = false
            statusProcess.running = true
        }
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
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        Text {
            id: sinkText

            text: root.sinkDescription
            color: root.muted ? Theme.volume.mutedColor : Theme.volume.textColor
            font.pixelSize: Theme.volume.fontSize
            font.bold: Theme.volume.fontBold
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        Text {
            id: volumeText

            width: Theme.volume.widthVolumeText
            text: root.muted ? "MUTE" : root.volume + "%"
            color: root.muted ? Theme.volume.mutedColor : Theme.volume.textColor
            font.pixelSize: Theme.volume.fontSize
            font.bold: Theme.volume.fontBold
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }
    }

    MouseArea {
        anchors.fill: parent

        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: function(mouse) {
            if (mouse.button === Qt.LeftButton) {
                volumePopup.toggle()
            } else if (mouse.button === Qt.RightButton) {
                root.toggleMute()
            }
        }

        onWheel: function(wheel) {
            if (wheel.angleDelta.y > 0)
                root.volumeUp()
            else if (wheel.angleDelta.y < 0)
                root.volumeDown()
        }
    }

    Process {
        id: statusProcess

        command: [root.audioSinkScript, "status"]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = this.text.trim().split("\n")

                if (lines.length < 4)
                    return

                root.sinkName = lines[0]
                root.sinkDescription = lines[1]
                root.volume = lines[2]
                root.muted = lines[3] === "yes"
            }
        }

        onExited: {
            if (root.statusPending) {
                root.statusPending = false

                Qt.callLater(function() {
                    root.updateStatus()
                })
            }
        }
    }

    Process {
        id: volumeUpProcess

        command: [root.audioSinkScript, "volume-up"]

        onExited: root.updateStatus()
    }

    Process {
        id: volumeDownProcess

        command: [root.audioSinkScript, "volume-down"]

        onExited: root.updateStatus()
    }

    Process {
        id: muteProcess

        command: [root.audioSinkScript, "mute"]

        onExited: root.updateStatus()
    }

    Process {
        id: subscribeProcess

        command: ["pactl", "subscribe"]

        stdout: SplitParser {
            onRead: function(line) {
                if (line.includes(" on sink") || line.includes(" on server"))
                    root.updateStatus()
            }
        }

        onExited: {
            Qt.callLater(function() {
                if (!subscribeProcess.running)
                    subscribeProcess.running = true
            })
        }
    }

    Popups.Volume {
        id: volumePopup

        target: root
        audioSinkScript: root.audioSinkScript

        onSinkChanged: root.updateStatus()
    }

    Component.onCompleted: {
        root.updateStatus()
        subscribeProcess.running = true
    }
}
import QtQuick
import Quickshell
import Quickshell.Io
import "../Popups" as Popups

Item {
    id: root

    property string audioScript:
        Quickshell.shellDir + "/scripts/audio.sh"

    property string sinkName: ""
    property string sinkDescription: ""
    property string volume: ""
    property bool muted: false

    implicitWidth: volumeText.implicitWidth
    implicitHeight: volumeText.implicitHeight

    function updateStatus() {
        if (!statusProcess.running)
            statusProcess.running = true
    }

    function volumeUp() {
        volumeUpProcess.running = true
    }

    function volumeDown() {
        volumeDownProcess.running = true
    }

    function toggleMute() {
        muteProcess.running = true
    }

    Text {
        id: volumeText

        anchors.fill: parent

        text: {
            if (muted)
                return sinkDescription + " MUTE"

            return sinkDescription + " " + volume
        }

        color: muted
            ? Theme.warning
            : Theme.textColor

        font.pixelSize: Theme.fontSize
        verticalAlignment: Text.AlignVCenter

        elide: Text.ElideRight
    }

    MouseArea {
        anchors.fill: parent

        acceptedButtons:
            Qt.LeftButton |
            Qt.RightButton

        onClicked: function(mouse) {
            if (mouse.button === Qt.LeftButton) {
                volumePopup.toggle()
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

        command: [
            root.audioScript,
            "status"
        ]

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
    }

    Process {
        id: volumeUpProcess

        command: [
            root.audioScript,
            "volume-up"
        ]

        onExited: {
            root.updateStatus()
        }
    }

    Process {
        id: volumeDownProcess

        command: [
            root.audioScript,
            "volume-down"
        ]

        onExited: {
            root.updateStatus()
        }
    }

    Process {
        id: muteProcess

        command: [
            root.audioScript,
            "mute"
        ]

        onExited: {
            root.updateStatus()
        }
    }

    Popups.Volume {
        id: volumePopup

        target: root
    }

    Connections {
        target: volumePopup

        function onSinkChanged() {
            root.updateStatus()
        }
    }

    Component.onCompleted: {
        root.updateStatus()
    }
}

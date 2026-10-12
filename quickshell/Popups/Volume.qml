import QtQuick
import Quickshell
import Quickshell.Io
import "../Themes"

Popup {
    id: root

    property string audioSinkScript

    signal sinkChanged()

    onVisibleChanged: {
        if (visible && !listProcess.running)
            listProcess.running = true
    }

    contentItem: Component {
        Menu {
            model: sinksModel

            onItemClicked: function(item) {
                root.setDefaultSink(item.sinkName)
            }
        }
    }

    ListModel {
        id: sinksModel
    }

    Process {
        id: listProcess

        command: [root.audioSinkScript, "list"]

        stdout: StdioCollector {
            onStreamFinished: root.updateSinks(this.text)
        }
    }

    Process {
        id: setSinkProcess

        onExited: function(exitCode, exitStatus) {
            if (exitCode === 0) {
                root.sinkChanged()
                root.close()
            } else {
                console.log("Failed to change default sink")
            }
        }
    }

    function updateSinks(output) {
        sinksModel.clear()

        const text = output.trim()

        if (!text)
            return

        const lines = text.split("\n")

        for (let i = 0; i < lines.length; ++i) {
            if (!lines[i].trim())
                continue

            const parts = lines[i].split("\t")

            if (parts.length < 5)
                continue

            sinksModel.append({
                sinkName: parts[0],
                description: parts[1],
                volume: parts[2],
                muted: parts[3],
                isDefault: parts[4]
            })
        }
    }

    function setDefaultSink(name) {
        if (setSinkProcess.running)
            return

        setSinkProcess.command = [
            root.audioSinkScript,
            "set-default",
            name
        ]

        setSinkProcess.running = true
    }

}
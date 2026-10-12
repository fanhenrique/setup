import QtQuick
import Quickshell
import Quickshell.Io
import "../Themes"

Popup {
    id: root

    property string audioSourceScript

    signal sourceChanged()

    onVisibleChanged: {
        if (visible)
            listProcess.running = true
    }

    contentItem: Component {
        Menu {
            model: sourcesModel

            onItemClicked: function(item) {
                root.setDefaultSource(item.sourceName)
            }
        }
    }

    ListModel {
        id: sourcesModel
    }

    Process {
        id: listProcess

        command: [root.audioSourceScript, "list"]

        stdout: StdioCollector {
            onStreamFinished: root.updateSources(this.text)
        }
    }

    Process {
        id: setSourceProcess

        onExited: function(exitCode, exitStatus) {
            if (exitCode === 0) {
                root.sourceChanged()
                root.close()
            } else {
                console.log("Failed to change default source")
            }
        }
    }

    function updateSources(output) {
        sourcesModel.clear()

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

            sourcesModel.append({
                sourceName: parts[0],
                description: parts[1],
                volume: parts[2],
                muted: parts[3],
                isDefault: parts[4]
            })
        }
    }

    function setDefaultSource(name) {
        if (!name || setSourceProcess.running)
            return

        setSourceProcess.command = [
            root.audioSourceScript,
            "set-default",
            name
        ]

        setSourceProcess.running = true
    }
}
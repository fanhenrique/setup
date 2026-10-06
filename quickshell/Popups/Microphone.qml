import QtQuick
import Quickshell
import Quickshell.Io
import "../Themes"

Popup {
    id: root

    property string audioScript

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

        command: [root.audioScript, "list"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.updateSources(this.text)
            }
        }
    }

    Process {
        id: setSourceProcess

        command: []

        onExited: {
            root.sourceChanged()
            root.close()
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
        if (setSourceProcess.running)
            return

        setSourceProcess.command = [
            root.audioScript,
            "set-default",
            name
        ]

        setSourceProcess.running = true
    }
}
import Quickshell
import Quickshell.I3
import Quickshell.Io
import QtQuick
import ".."

Text {
    id: root

    required property var monitor

    property string windowTitle: ""

    text: windowTitle

    color: Theme.textColor
    font.pixelSize: Theme.fontSize
    verticalAlignment: Text.AlignVCenter
    visible: windowTitle.length > 0
    elide: Text.ElideRight

    function updateFromTree() {
        treeProcess.running = true
    }

    Process {
        id: treeProcess

        command: [
            "swaymsg",
            "-t",
            "get_tree"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const tree = JSON.parse(this.text)
                    const focused = root.findFocused(tree)

                    if (focused && focused.name)
                        root.windowTitle = focused.name
                    else
                        root.windowTitle = ""
                } catch (error) {
                    console.log(
                        "FocusedWindow: JSON parse error:",
                        error
                    )
                }
            }
        }
    }

    function findFocused(node) {
        if (!node)
            return null

        if (node.type === "con" && node.focused === true)
            return node

        if (node.nodes) {
            for (let i = 0; i < node.nodes.length; ++i) {
                const result = findFocused(node.nodes[i])

                if (result)
                    return result
            }
        }

        if (node.floating_nodes) {
            for (let i = 0; i < node.floating_nodes.length; ++i) {
                const result = findFocused(node.floating_nodes[i])

                if (result)
                    return result
            }
        }

        return null
    }

    I3IpcListener {
        subscriptions: ["window", "workspace"]

        onIpcEvent: function(event) {
            if (event.type !== "window" && event.type !== "workspace") return

            let data

            try {
                data = JSON.parse(event.data)
            } catch (error) {
                console.log("FocusedWindow: event JSON parse error:",error)
                return
            }

            if (event.type === "workspace") {
                if (data.change === "focus" || data.change === "init") {
                    root.windowTitle = ""
                    root.updateFromTree()
                }
                return
            }

            if (data.change !== "focus" && data.change !== "title") return

            if (data.container && data.container.name) {
                root.windowTitle = data.container.name
            } else {
                root.windowTitle = ""
            }
        }
    }

    Component.onCompleted: {
        updateFromTree()
    }
}
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
        Item {
            implicitWidth: contentColumn.width
            implicitHeight: contentColumn.implicitHeight

            Column {
                id: contentColumn

                spacing: Theme.volume.spacing

                property int horizontalPadding: Theme.microphone.horizontalPadding

                width: {
                    var maxWidth = 0

                    for (var i = 0; i < children.length; ++i) {
                        var child = children[i]

                        if (child.implicitWidth > maxWidth)
                            maxWidth = child.implicitWidth
                    }

                    return maxWidth
                }

                Repeater {
                    model: sourcesModel

                    delegate: Rectangle {
                        required property string sourceName
                        required property string description
                        required property string volume
                        required property string muted
                        required property string isDefault

                        implicitWidth: descriptionText.implicitWidth
                            + contentColumn.horizontalPadding * 2

                        width: contentColumn.width
                        height: 38

                        radius: 5

                        color: isDefault === "yes"
                            ? Theme.primary
                            : "transparent"

                        MouseArea {
                            anchors.fill: parent

                            hoverEnabled: true

                            onEntered: {
                                if (isDefault !== "yes")
                                    parent.color = "#434c5e"
                            }

                            onExited: {
                                parent.color = isDefault === "yes"
                                    ? Theme.primary
                                    : "transparent"
                            }

                            onClicked: {
                                root.setDefaultSource(sourceName)
                            }
                        }

                        Text {
                            id: descriptionText

                            anchors.centerIn: parent

                            text: description

                            color: Theme.textColor

                            font.pixelSize: Theme.fontSize

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
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
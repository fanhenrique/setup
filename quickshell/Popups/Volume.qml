import QtQuick
import Quickshell
import Quickshell.Io
import "../Themes"

Popup {
    id: root

    property string audioScript

    signal sinkChanged()

    onVisibleChanged: {
        if (visible)
            listProcess.running = true
    }

    contentItem: Component {
        Item {
            implicitWidth: 300
            implicitHeight: contentColumn.implicitHeight

            Column {
                id: contentColumn

                anchors.fill: parent

                spacing: 4

                Text {
                    width: parent.width

                    text: "Saída de áudio"

                    color: Theme.textColor

                    font.pixelSize: Theme.fontSize
                    font.bold: true
                }

                Rectangle {
                    width: parent.width
                    height: 1

                    color: Theme.popup.borderColor
                }

                ListView {
                    id: sinkList

                    width: parent.width

                    height: Math.min(
                        sinksModel.count * 38,
                        250
                    )

                    clip: true

                    model: sinksModel

                    delegate: Rectangle {
                        required property string sinkName
                        required property string description
                        required property string volume
                        required property string muted
                        required property string isDefault

                        width: sinkList.width
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
                                root.setDefaultSink(sinkName)
                            }
                        }

                        Row {
                            anchors.fill: parent

                            anchors.leftMargin: 8
                            anchors.rightMargin: 8

                            spacing: 8

                            Text {
                                width: parent.width - volumeText.width - 16

                                anchors.verticalCenter:
                                    parent.verticalCenter

                                text: description

                                color: Theme.textColor

                                font.pixelSize: Theme.fontSize

                                elide: Text.ElideRight
                            }

                            Text {
                                id: volumeText

                                anchors.verticalCenter:
                                    parent.verticalCenter

                                text: muted === "yes"
                                    ? "MUTE"
                                    : volume

                                color: muted === "yes"
                                    ? Theme.warning
                                    : Theme.textColor

                                font.pixelSize: Theme.fontSize
                                font.bold: isDefault === "yes"
                            }
                        }
                    }
                }
            }
        }
    }

    ListModel {
        id: sinksModel
    }

    Process {
        id: listProcess

        command: [
            root.audioScript,
            "list"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                root.updateSinks(this.text)
            }
        }
    }

    Process {
        id: setSinkProcess

        command: []

        onExited: {
            root.sinkChanged()
            root.close()
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
            root.audioScript,
            "set-default",
            name
        ]

        setSinkProcess.running = true
    }
}
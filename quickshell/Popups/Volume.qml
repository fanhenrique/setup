import QtQuick
import Quickshell
import Quickshell.Io

PopupWindow {
    id: root

    required property var target

    signal sinkChanged()

    property string audioScript:
        Quickshell.shellDir + "/scripts/audio.sh"

    property int popupWidth: 300
    property int padding: Theme.popup.padding
    property int gap: Theme.popup.gap

    color: "transparent"

    implicitWidth: popupWidth
    implicitHeight: content.implicitHeight + padding * 2

    grabFocus: true

    anchor {
        item: root.target

        rect.x: root.target.width / 2
        rect.y: root.target.height + root.gap
        rect.width: 1
        rect.height: 1

        edges: Edges.Top
        gravity: Edges.Bottom
        adjustment: PopupAdjustment.All
    }

    Rectangle {
        anchors.fill: parent

        color: Theme.popup.color
        radius: Theme.popup.radius

        border {
            width: Theme.popup.borderWidth
            color: Theme.popup.borderColor
        }

        Column {
            id: content

            anchors.fill: parent
            anchors.margins: root.padding

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

                            anchors.verticalCenter: parent.verticalCenter

                            text: description

                            color: Theme.textColor

                            font.pixelSize: Theme.fontSize

                            elide: Text.ElideRight
                        }

                        Text {
                            id: volumeText

                            anchors.verticalCenter: parent.verticalCenter

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

        const lines = output.trim().split("\n")

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
        setSinkProcess.command = [
            root.audioScript,
            "set-default",
            name
        ]

        setSinkProcess.running = true
    }

    function open() {
        listProcess.running = true
        visible = true
    }

    function close() {
        visible = false
    }

    function toggle() {
        if (visible)
            close()
        else
            open()
    }
}

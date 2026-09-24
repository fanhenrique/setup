import Quickshell
import Quickshell.I3
import QtQuick

Row {
    required property var monitor

    anchors {
        left: parent.left
        leftMargin: 10
        verticalCenter: parent.verticalCenter
    }

    spacing: 8

    Repeater {
        model: I3.workspaces

        delegate: Rectangle {
            required property var modelData

            visible: modelData.monitor === monitor

            width: visible ? 24 : 0
            height: 24
            radius: 4

            color: modelData.focused
                ? "#bf616a"
                : modelData.urgent
                    ? "#ebcb8b"
                    : "transparent"

            Text {
                anchors.centerIn: parent

                text: modelData.number
                color: "#eceff4"
                font.pixelSize: 14
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    modelData.activate()
                }
            }
        }
    }
}
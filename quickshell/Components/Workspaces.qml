import Quickshell
import Quickshell.I3
import QtQuick

Row {
    id: root

    required property var monitor

    anchors {
        left: parent.left
        leftMargin: Theme.workspaces.leftMargin
        verticalCenter: parent.verticalCenter
    }

    spacing: Theme.workspaces.spacing

    Repeater {
        model: I3.workspaces

        delegate: Rectangle {
            required property var modelData

            visible: modelData.monitor
                     && root.monitor
                     && modelData.monitor.name === root.monitor.name

            width: visible ? Theme.workspaces.widthFocused : 0
            height: Theme.workspaces.heightFocused
            radius: Theme.workspaces.radiusFocused

            color: modelData.focused
                ? Theme.workspaces.focused
                : modelData.urgent
                ? Theme.workspaces.urgent
                : Theme.workspaces.unfocused

            Text {
                anchors.centerIn: parent

                text: modelData.number

                color: Theme.workspaces.textColor

                font.pixelSize: Theme.workspaces.fontSize
                font.bold: Theme.workspaces.fontBold
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
import Quickshell
import Quickshell.I3
import QtQuick
import ".."

Row {
    required property var monitor

    anchors {
        left: parent.left
        leftMargin: 4
        verticalCenter: parent.verticalCenter
    }

    spacing: Theme.spacingWorkspaces

    Repeater {
        model: I3.workspaces

        delegate: Rectangle {
            required property var modelData

            visible: modelData.monitor && monitor
                     && modelData.monitor.name === monitor.name

            width: visible ? Theme.widthWorkspacesActive : 0            
            height: Theme.heightWorkspacesActive
            radius: Theme.radiusWorkspacesActive

            color: modelData.focused 
                ? Theme.focusedWorkspaces 
                : modelData.urgent 
                ? Theme.urgentWorkspaces 
                : Theme.unfocusedWorkspaces 

            Text {
                anchors.centerIn: parent

                text: modelData.number
                color: Theme.textColorWorkspaces
                font.pixelSize: Theme.fontSizeWorkspaces
                font.bold: Theme.fontBoldWorkspaces
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
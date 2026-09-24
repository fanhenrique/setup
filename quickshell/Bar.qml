import Quickshell
import Quickshell.I3
import QtQuick
import "./components" as Components

PanelWindow {
    required property var modelData

    property var swayMonitor: I3.monitorFor(modelData)

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Theme.barHeight

    color: Theme.background

    Components.Workspaces {
        monitor: swayMonitor
    }

    Text {
        anchors.centerIn: parent


        text: modelData.name
        color: Theme.textColor
        font.pixelSize: 14
    }

    Components.Clock {
        anchors {
            right: parent.right
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }
    }
}
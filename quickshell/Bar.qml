import Quickshell
import Quickshell.I3
import QtQuick
import "./components" as Components

PanelWindow {
    id: root

    required property var modelData

    property var swayMonitor: I3.monitorFor(modelData)

    anchors {
        top: true
        bottom: false
        left: true
        right: true
    }

    implicitHeight: Theme.barHeight

    color: Theme.background

    Components.Workspaces {
        monitor: swayMonitor
    }

    Components.Clock {
        anchors.centerIn: parent
    }
    

    Text {
        anchors {
            right: tray.left
            rightMargin: 8
            verticalCenter: parent.verticalCenter
        }

        text: modelData.name
        color: Theme.textColor
        font.pixelSize: Theme.fontSize
    }

    Components.Tray {
        id: tray

        panelWindow: root

        anchors {
            right: parent.right
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }
    }
}
import Quickshell
import Quickshell.I3
import QtQuick
import "./components" as Components

PanelWindow {
    id: root

    required property var modelData

    property var swayMonitor: null

    function updateSwayMonitor() {
        const m = I3.monitorFor(modelData)

        if (m !== swayMonitor) {
            console.log(
                "Sway monitor:",
                modelData.name,
                "->",
                m ? m.name : "NULL"
            )

            swayMonitor = m
        }
    }

    anchors {
        top: true
        bottom: false
        left: true
        right: true
    }

    implicitHeight: Theme.barHeight

    color: Theme.background

    Component.onCompleted: {
        updateSwayMonitor()
    }

    Connections {
        target: I3

        function onConnected() {
            console.log("I3 connected")

            I3.refreshMonitors()
            I3.refreshWorkspaces()

            root.updateSwayMonitor()
        }

        function onRawEvent(event) {
            root.updateSwayMonitor()
        }
    }

    Components.Workspaces {
        id: workspaces

        monitor: root.swayMonitor
    }

    Components.FocusedWindow {
        id: focusedWindow

        monitor: root.swayMonitor

        anchors {
            left: workspaces.right
            leftMargin: 0
            top: parent.top
            bottom: parent.bottom
        }

        width: 500
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
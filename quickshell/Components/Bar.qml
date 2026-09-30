import Quickshell
import Quickshell.I3
import QtQuick
import "../Themes"

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
        top: Theme.bar.position === "top" 
            ? true : Theme.bar.position === "bottom" ? false : true
        bottom: Theme.bar.position === "bottom" ? true : false
        left: true
        right: true
    }

    implicitHeight: Theme.bar.height

    color: Theme.bar.background

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

    Workspaces {
        id: workspaces
        monitor: root.swayMonitor

        anchors {
            left: parent.left
            leftMargin: 4
            verticalCenter: parent.verticalCenter
        }
    }

    FocusedWindow {
        id: focusedWindow
        monitor: root.swayMonitor

        anchors {
            left: workspaces.right
            leftMargin: 4
            top: parent.top
            bottom: parent.bottom
        }
    }

    Clock {
        anchors{
            centerIn: parent
            top: parent.top
            bottom: parent.bottom
        }
    }

    Text {
        id: monitor
        text: modelData.name

        anchors {
            right: volume.left
            rightMargin: 8
            verticalCenter: parent.verticalCenter
        }

        color: Theme.textColor
        font.pixelSize: Theme.fontSize
    }

    Volume {
        id: volume

        anchors {
            right: tray.left
            rightMargin: 8
            verticalCenter: parent.verticalCenter
        }
    }

    Tray {
        id: tray
        panelWindow: root

        anchors {
            right: parent.right
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }
    }
}
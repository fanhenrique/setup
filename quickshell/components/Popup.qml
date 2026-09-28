import QtQuick
import Quickshell

PopupWindow {
    id: root

    required property var target

    property alias contentItem: contentLoader.sourceComponent

    property int popupWidth: 300
    property int popupHeight: 500
    property int gap: 5

    color: "transparent"

    implicitWidth: popupWidth
    implicitHeight: popupHeight



    anchor {
        item: root.target

        rect.x: root.target.width / 2
        rect.y: root.target.height + 15

        rect.width: 1
        rect.height: 1

        edges: Edges.Top
        gravity: Edges.Bottom

        adjustment: PopupAdjustment.All
    }


    Rectangle {
        anchors.fill: parent

        color: "#3b4252"
        radius: 6

        border {
            width: 1
            color: "#5e6779"
        }

        Loader {
            id: contentLoader

            anchors.fill: parent
        }
    }

    function toggle() {
        visible = !visible
    }

    function open() {
        visible = true
    }

    function close() {
        visible = false
    }
}

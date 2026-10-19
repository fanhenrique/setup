import QtQuick
import Quickshell
import "../Themes"

PopupWindow {
    id: root

    required property var target

    property alias contentItem: contentLoader.sourceComponent

    property int gap: Theme.popup.gap
    property int padding: Theme.popup.padding

    readonly property int borderWidth: Theme.popup.borderWidth
    readonly property int contentMargin: padding + borderWidth

    color: "transparent"

    implicitWidth: contentLoader.item
        ? contentLoader.item.implicitWidth + contentMargin * 2
        : 0

    implicitHeight: contentLoader.item
        ? contentLoader.item.implicitHeight + contentMargin * 2
        : 0

    grabFocus: Theme.popup.grabFocus

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
            width: root.borderWidth
            color: Theme.popup.borderColor
        }

        Loader {
            id: contentLoader

            anchors {
                fill: parent
                margins: root.contentMargin
            }
        }
    }

    function open() {
        PopupManager.open(root)
    }

    function close() {
        PopupManager.close(root)
    }

    function toggle() {
        PopupManager.toggle(root)
    }

    onVisibleChanged: {
        if (!visible && PopupManager.currentPopup === root)
            PopupManager.currentPopup = null
    }
}
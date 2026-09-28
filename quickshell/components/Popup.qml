import QtQuick
import Quickshell
import ".."

PopupWindow {
    id: root

    required property var target

    property alias contentItem: contentLoader.sourceComponent
    property int gap: Theme.popup.gap
    property int padding: Theme.popup.padding

    color: "transparent"
   
    implicitWidth: contentLoader.item
        ? contentLoader.item.implicitWidth + padding * 2
        : 0

    implicitHeight: contentLoader.item
        ? contentLoader.item.implicitHeight + padding * 2
        : 0

    // Close the popup when clicking outside it
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
            width: Theme.popup.borderWidth
            color: Theme.popup.borderColor
        }

        Loader {
            id: contentLoader
            anchors.fill: parent
        }
    }

    function toggle() {
        visible = !visible
    }
}
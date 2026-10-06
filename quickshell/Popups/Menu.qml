import QtQuick
import "../Themes"

Item {
    id: root

    required property var model

    signal itemClicked(var item)

    implicitWidth: menuColumn.width
    implicitHeight: menuColumn.implicitHeight

    Column {
        id: menuColumn

        spacing: Theme.menu.spacing

        width: {
            var maxWidth = 0

            for (var i = 0; i < children.length; ++i) {
                var child = children[i]

                if (child.implicitWidth > maxWidth)
                    maxWidth = child.implicitWidth
            }

            return maxWidth
        }

        Repeater {
            model: root.model

            delegate: Rectangle {
                required property var modelData

                readonly property string itemText: modelData["description"]
                readonly property bool selected: modelData["isDefault"] === "yes"

                implicitWidth: textItem.implicitWidth + Theme.menu.horizontalPadding * 2
                width: menuColumn.width
                height: Theme.menu.height

                radius: Theme.menu.radius

                color: selected ? Theme.menu.selectedColor : "transparent"

                MouseArea {
                    anchors.fill: parent

                    hoverEnabled: true

                    onEntered: {
                        if (!parent.selected)
                            parent.color = Theme.menu.hoverColor
                    }

                    onExited: {
                        parent.color = parent.selected ? Theme.menu.selectedColor : "transparent"
                    }

                    onClicked: {
                        root.itemClicked(parent.modelData)
                    }
                }

                Text {
                    id: textItem

                    anchors.centerIn: parent

                    text: parent.itemText

                    color: Theme.menu.textColor

                    font.pixelSize: Theme.menu.fontSize

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
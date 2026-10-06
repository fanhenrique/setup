import QtQuick
import "../Themes"

Item {
    id: root

    required property var model

    property int horizontalPadding: Theme.microphone.horizontalPadding
    property int itemHeight: Theme.microphone.height
    property int itemRadius: Theme.microphone.radius
    property int spacing: Theme.microphone.spacing

    property color selectedColor: Theme.primary
    property color hoverColor: "#434c5e"
    property color textColor: Theme.textColor

    property string textRole: "description"
    property string selectedRole: "isDefault"

    signal itemClicked(var item)

    implicitWidth: menuColumn.width
    implicitHeight: menuColumn.implicitHeight

    Column {
        id: menuColumn

        spacing: root.spacing

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

                readonly property string itemText: modelData[root.textRole]
                readonly property bool selected: modelData[root.selectedRole] === "yes"

                implicitWidth: textItem.implicitWidth + root.horizontalPadding * 2
                width: menuColumn.width
                height: root.itemHeight

                radius: root.itemRadius

                color: selected
                    ? root.selectedColor
                    : "transparent"

                MouseArea {
                    anchors.fill: parent

                    hoverEnabled: true

                    onEntered: {
                        if (!parent.selected)
                            parent.color = root.hoverColor
                    }

                    onExited: {
                        parent.color = parent.selected
                            ? root.selectedColor
                            : "transparent"
                    }

                    onClicked: {
                        root.itemClicked(parent.modelData)
                    }
                }

                Text {
                    id: textItem

                    anchors.centerIn: parent

                    text: parent.itemText

                    color: root.textColor

                    font.pixelSize: Theme.fontSize

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
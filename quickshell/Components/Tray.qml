import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import "../Themes"

Row {
    id: root

    property var panelWindow

    spacing: Theme.tray.spacing

    Repeater {
        model: SystemTray.items

        delegate: Item {
            required property var modelData

            width: Theme.tray.iconWidth
            height: Theme.tray.iconHeight

            Image {
                anchors.fill: parent

                source: modelData.icon

                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            MouseArea {
                anchors.fill: parent

                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onClicked: function(mouse) {
                    if (mouse.button === Qt.LeftButton) {
                        modelData.activate()

                    } else if (mouse.button === Qt.RightButton) {
                        if (modelData.hasMenu) {
                            menu.openMenu(modelData.menu)
                        }
                    }
                }
            }
        }
    }

    TrayMenu {
        id: menu

        panelWindow: root.panelWindow
    }
}
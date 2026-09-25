import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

Row {
    id: root

    property var panelWindow

    spacing: 6

    Repeater {
        model: SystemTray.items

        delegate: Item {
            required property var modelData

            width: 22
            height: 22

            Image {
                anchors.fill: parent

                source: modelData.icon

                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            MouseArea {
                anchors.fill: parent

                acceptedButtons: Qt.LeftButton |
                                 Qt.MiddleButton |
                                 Qt.RightButton

                onClicked: function(mouse) {
                    if (mouse.button === Qt.LeftButton) {
                        modelData.activate()

                    } else if (mouse.button === Qt.MiddleButton) {
                        modelData.secondaryActivate()

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
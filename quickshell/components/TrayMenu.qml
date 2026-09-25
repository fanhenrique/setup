import QtQuick
import Quickshell

PopupWindow {
    id: root

    required property var panelWindow

    property var currentMenu
    property var parentMenus: []

    property int menuWidth: 240
    property int rowHeight: 30

    color: "transparent"

    grabFocus: true

    implicitWidth: menuWidth
    implicitHeight: menuColumn.implicitHeight + 12

    anchor {
        window: root.panelWindow

        rect.x: root.panelWindow.width
        rect.y: root.panelWindow.height
        rect.width: 1
        rect.height: 1

        edges: Edges.Bottom | Edges.Right
        gravity: Edges.Bottom | Edges.Left

        adjustment: PopupAdjustment.All
    }

    QsMenuOpener {
        id: menuOpener

        menu: root.currentMenu
    }

    function openMenu(menuHandle) {
        root.currentMenu = menuHandle
        root.parentMenus = []
        root.visible = true
    }

    function openSubmenu(entry) {
        root.parentMenus = root.parentMenus.concat([
            root.currentMenu
        ])

        root.currentMenu = entry
    }

    function goBack() {
        if (root.parentMenus.length === 0)
            return

        var parents = root.parentMenus.slice()
        var previousMenu = parents.pop()

        root.parentMenus = parents
        root.currentMenu = previousMenu
    }

    function closeMenu() {
        root.visible = false
        root.currentMenu = null
        root.parentMenus = []
    }

    Rectangle {
        anchors.fill: parent

        color: "#3b4252"
        radius: 6

        border {
            width: 1
            color: "#5e6779"
        }

        Column {
            id: menuColumn

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 6
            }

            spacing: 2

            Rectangle {
                width: parent.width
                height: root.rowHeight

                visible: root.parentMenus.length > 0

                color: "transparent"

                Text {
                    anchors.centerIn: parent

                    text: "←  Back"

                    color: "#eceff4"

                    font.pixelSize: 14
                    font.bold: true
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        root.goBack()
                    }
                }
            }

            Repeater {
                model: menuOpener.children

                delegate: Item {
                    id: menuItem

                    required property var modelData

                    width: menuColumn.width

                    height: modelData.isSeparator
                        ? 9
                        : root.rowHeight

                    QsMenuOpener {
                        id: submenuOpener

                        menu: menuItem.modelData.hasChildren
                            ? menuItem.modelData
                            : null
                    }

                    Rectangle {
                        anchors {
                            left: parent.left
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }

                        height: 1

                        visible: menuItem.modelData.isSeparator

                        color: "#5e6779"
                    }

                    Rectangle {
                        anchors.fill: parent

                        radius: 4

                        visible: !menuItem.modelData.isSeparator

                        color: mouseArea.containsMouse
                            ? "#4c566a"
                            : "transparent"
                    }

                    Row {
                        anchors.fill: parent

                        anchors.leftMargin: 8
                        anchors.rightMargin: 8

                        spacing: 8

                        visible: !menuItem.modelData.isSeparator

                        Image {
                            width: 18
                            height: 18

                            anchors.verticalCenter: parent.verticalCenter

                            source: menuItem.modelData.icon

                            sourceSize.width: 18
                            sourceSize.height: 18

                            visible: menuItem.modelData.icon !== ""

                            fillMode: Image.PreserveAspectFit
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter

                            width: parent.width -
                                   18 -
                                   8 -
                                   20

                            text: menuItem.modelData.text

                            color: menuItem.modelData.enabled
                                ? "#eceff4"
                                : "#7b8494"

                            font.pixelSize: 14

                            elide: Text.ElideRight
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter

                            width: 20

                            text: menuItem.modelData.hasChildren
                                ? "›"
                                : ""

                            color: "#eceff4"

                            font.pixelSize: 18

                            horizontalAlignment: Text.AlignRight
                        }
                    }

                    MouseArea {
                        id: mouseArea

                        anchors.fill: parent

                        hoverEnabled: true

                        enabled:
                            !menuItem.modelData.isSeparator &&
                            menuItem.modelData.enabled

                        onClicked: {
                            var entry = menuItem.modelData

                            if (entry.hasChildren) {
                                root.openSubmenu(entry)
                            } else {
                                entry.triggered()
                                root.closeMenu()
                            }
                        }
                    }
                }
            }
        }
    }
}

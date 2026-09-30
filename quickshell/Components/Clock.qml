import QtQuick
import Quickshell
import "../Themes"
import "../Popups" as Popups

Text {
    id: root

    color: Theme.clock.textColor
    font.pixelSize: Theme.clock.fontSize
    font.bold: Theme.clock.fontBold

    function updateClock() {
        text = Qt.formatDateTime(new Date(), Theme.clock.format)
    }

    Timer {
        interval: Theme.clock.interval

        running: true
        repeat: true

        onTriggered: {
            root.updateClock()
        }
    }

    MouseArea {
        anchors.fill: parent

        onClicked: {
            calendarPopup.toggle()
        }
    }

    Popups.Calendar {
        id: calendarPopup

        target: root
    }
}
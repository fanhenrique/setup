import QtQuick
import Quickshell
import ".."
import "."

Text {
    id: root

    color: Theme.clock.textColor
    font.pixelSize: Theme.clock.fontSize
    font.bold: Theme.clock.fontBold

    function updateClock() {
        text = Qt.formatDateTime(
            new Date(),
            Theme.clock.format
        )
    }

    Timer {
        interval: Theme.clock.interval
        running: true
        repeat: true

        onTriggered: {
            updateClock()
        }
    }

    MouseArea {
        anchors.fill: parent

        onClicked: {
            calendarPopup.toggle()
        }
    }

    Popup {
        id: calendarPopup

        target: root

        contentItem: Component {
            Calendar {
                anchors.fill: parent
            }
        }
    }

    Component.onCompleted: {
        updateClock()
    }
}

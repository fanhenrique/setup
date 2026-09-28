import QtQuick
import ".."

Text {
    
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
            updateClock()
        }
    }

    Component.onCompleted: {
        updateClock()
    }
}
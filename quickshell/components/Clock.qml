import QtQuick

Text {
    color: "#eceff4"
    font.pixelSize: 14

    function updateClock() {
        text = Qt.formatDateTime(new Date(), "dd/MM HH:mm:ss")
    }

    Timer {
        interval: 1000
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
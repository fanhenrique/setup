import QtQuick
import ".."

Item {
    id: root

    property date currentDate: new Date()

    implicitWidth: 280
    implicitHeight: 300

    property int currentYear: currentDate.getFullYear()
    property int currentMonth: currentDate.getMonth()

    function monthName() {
        const date = new Date(currentYear, currentMonth, 1)

        return date.toLocaleDateString(
            Qt.locale(),
            "MMMM yyyy"
        )
    }

    function daysInMonth() {
        return new Date(
            currentYear,
            currentMonth + 1,
            0
        ).getDate()
    }

    function firstDayOfMonth() {
        return new Date(
            currentYear,
            currentMonth,
            1
        ).getDay()
    }

    Rectangle {
        anchors.fill: parent

        color: Theme.background
        radius: 6

        Column {
            anchors.fill: parent
            anchors.margins: 12

            spacing: 10

            Text {
                width: parent.width
                text: root.monthName()

                color: Theme.textColor
                font.pixelSize: 16
                font.bold: true

                horizontalAlignment: Text.AlignHCenter
            }

            Row {
                width: parent.width
                spacing: 0

                Repeater {
                    model: [
                        "Dom",
                        "Seg",
                        "Ter",
                        "Qua",
                        "Qui",
                        "Sex",
                        "Sáb"
                    ]

                    delegate: Text {
                        required property string modelData

                        width: parent.width / 7
                        text: modelData

                        color: Theme.textColor
                        font.pixelSize: 12
                        font.bold: true

                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }

            Grid {
                width: parent.width
                columns: 7
                rows: 6

                Repeater {
                    model: 42

                    delegate: Item {
                        required property int index

                        width: parent.width / 7
                        height: 36

                        readonly property int day:
                            index - root.firstDayOfMonth() + 1

                        readonly property bool validDay:
                            day >= 1 &&
                            day <= root.daysInMonth()

                        readonly property bool today:
                            validDay &&
                            day === new Date().getDate() &&
                            root.currentMonth === new Date().getMonth() &&
                            root.currentYear === new Date().getFullYear()

                        Rectangle {
                            anchors.centerIn: parent

                            width: 30
                            height: 30
                            radius: 15

                            color: today
                                ? Theme.primary
                                : "transparent"

                            visible: validDay

                            Text {
                                anchors.centerIn: parent

                                text: validDay ? day : ""

                                color: today
                                    ? "#ffffff"
                                    : Theme.textColor

                                font.pixelSize: 13
                            }
                        }
                    }
                }
            }
        }
    }
}

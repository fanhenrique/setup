import QtQuick
import ".."

Item {
    id: root

    property date currentDate: new Date()

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    property int currentYear: currentDate.getFullYear()
    property int currentMonth: currentDate.getMonth()

    function monthName() {
        const date = new Date(
            currentYear,
            currentMonth,
            1
        )

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

        color: "transparent"

        Column {
            id: content

            anchors.centerIn: parent

            spacing: Theme.calendar.spacing

            Text {
                width: 280

                text: root.monthName()

                color: Theme.calendar.monthTextColor
                font.pixelSize: Theme.calendar.monthFontSize
                font.bold: Theme.calendar.monthFontBold

                horizontalAlignment: Text.AlignHCenter
            }

            Row {
                width: 280

                spacing: Theme.calendar.weekSpacing

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

                        width: 40

                        text: modelData

                        color: Theme.calendar.weekTextColor
                        font.pixelSize: Theme.calendar.weekFontSize
                        font.bold: Theme.calendar.weekFontBold

                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }

            Grid {
                width: 280

                columns: 7
                rows: Math.ceil((root.firstDayOfMonth() + root.daysInMonth()) / 7)

                Repeater {
                    model: Math.ceil((root.firstDayOfMonth() + root.daysInMonth()) / 7) * 7

                    delegate: Item {
                        required property int index

                        width: 40
                        height: 40

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

                            radius: 0

                            visible: validDay

                            color: today ? Theme.primary : "transparent"

                            Text {
                                anchors.centerIn: parent

                                text: validDay ? day : ""
                                
                                color: Theme.calendar.dayTextColor

                                font.pixelSize: Theme.calendar.dayFontSize
                                font.bold: today ? Theme.calendar.todayFontBold : Theme.calendar.dayFontBold
                            }
                        }
                    }
                }
            }
        }
    }
}

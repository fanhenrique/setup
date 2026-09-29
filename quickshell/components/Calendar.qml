import QtQuick
import ".."

Item {
    id: root

    property date currentDate: new Date()

    property int currentYear: currentDate.getFullYear()
    property int currentMonth: currentDate.getMonth()

    readonly property var weekDays: [
        "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"
    ]

    readonly property int weekSpacing: Theme.calendar.weekSpacing
    readonly property int daySize: Theme.calendar.daySize

    TextMetrics {
        id: weekTextMetrics

        font.pixelSize: Theme.calendar.weekFontSize
        font.bold: Theme.calendar.weekFontBold
    }

    TextMetrics {
        id: dayTextMetrics

        font.pixelSize: Theme.calendar.dayFontSize
        font.bold: Theme.calendar.dayFontBold
    }

    readonly property real columnWidth:
        Math.max(
            weekTextMetrics.width,
            dayTextMetrics.width,
            daySize
        ) + weekSpacing

    readonly property real calendarWidth:
        (columnWidth + weekSpacing) * 7

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    function monthName() {
        const date = new Date(currentYear, currentMonth, 1)

        return date.toLocaleDateString(Qt.locale(), "MMMM yyyy")
    }

    function daysInMonth() {
        return new Date(currentYear, currentMonth + 1, 0).getDate()
    }

    function firstDayOfMonth() {
        return new Date(currentYear, currentMonth, 1).getDay()
    }

    Rectangle {
        anchors.fill: parent

        color: "transparent"

        Column {
            id: content

            anchors.centerIn: parent

            spacing: Theme.calendar.spacing

            Text {
                width: root.calendarWidth

                text: root.monthName()

                color: Theme.calendar.monthTextColor
                font.pixelSize: Theme.calendar.monthFontSize
                font.bold: Theme.calendar.monthFontBold

                horizontalAlignment: Text.AlignHCenter
            }

            Row {
                width: root.calendarWidth

                spacing: root.weekSpacing

                Repeater {
                    model: root.weekDays

                    delegate: Text {
                        required property string modelData

                        width: root.columnWidth

                        text: modelData

                        color: Theme.calendar.weekTextColor
                        font.pixelSize: Theme.calendar.weekFontSize
                        font.bold: Theme.calendar.weekFontBold

                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }

            Grid {
                width: root.calendarWidth

                columns: 7
                rows: Math.ceil((root.firstDayOfMonth() + root.daysInMonth()) / 7)

                Repeater {
                    model: Math.ceil((root.firstDayOfMonth() + root.daysInMonth()) / 7) * 7

                    delegate: Item {
                        required property int index

                        width: root.columnWidth + weekSpacing
                        height: root.columnWidth

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

                            width: root.daySize+weekSpacing
                            height: root.daySize

                            radius: Theme.calendar.todayRadius

                            visible: validDay

                            color: today ? Theme.calendar.todayColor : "transparent"

                            Text {
                                anchors.centerIn: parent

                                text: validDay ? day : ""

                                color: today ? Theme.calendar.todayTextColor : Theme.calendar.dayTextColor

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
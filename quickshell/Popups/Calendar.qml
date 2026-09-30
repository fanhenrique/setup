import QtQuick
import "../Themes"

Popup {
    id: root

    contentItem: Component {
        Item {
            implicitWidth: calendarWidth
            implicitHeight: content.implicitHeight

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

            readonly property real calendarWidth: (columnWidth + weekSpacing) * 7

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

            function resetDate() {
                currentDate = new Date()
            }

            Column {
                id: content

                anchors.centerIn: parent

                spacing: Theme.calendar.spacing

                Text {
                    width: parent.parent.calendarWidth

                    text: parent.parent.monthName()

                    color: Theme.calendar.monthTextColor

                    font.pixelSize: Theme.calendar.monthFontSize
                    font.bold: Theme.calendar.monthFontBold

                    horizontalAlignment: Text.AlignHCenter
                }

                Row {
                    width: parent.parent.calendarWidth

                    spacing: parent.parent.weekSpacing

                    Repeater {
                        model: parent.parent.weekDays

                        delegate: Text {
                            required property string modelData

                            width: parent.parent.parent.columnWidth

                            text: modelData

                            color: Theme.calendar.weekTextColor

                            font.pixelSize: Theme.calendar.weekFontSize

                            font.bold: Theme.calendar.weekFontBold

                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }

                Grid {
                    width: parent.parent.calendarWidth

                    columns: 7

                    rows: Math.ceil((parent.parent.firstDayOfMonth() + parent.parent.daysInMonth()) / 7)

                    Repeater {
                        model:
                            Math.ceil((parent.parent.parent.firstDayOfMonth() + parent.parent.parent.daysInMonth()) / 7) * 7

                        delegate: Item {
                            required property int index

                            width: parent.parent.parent.columnWidth + parent.parent.parent.weekSpacing

                            height: parent.parent.parent.columnWidth

                            readonly property int day: index - parent.parent.parent.firstDayOfMonth() + 1

                            readonly property bool validDay: day >= 1 && day <= parent.parent.parent.daysInMonth()

                            readonly property bool today:
                                validDay &&
                                day === new Date().getDate() &&
                                parent.parent.parent.currentMonth ===
                                    new Date().getMonth() &&
                                parent.parent.parent.currentYear ===
                                    new Date().getFullYear()

                            Rectangle {
                                anchors.centerIn: parent

                                width: parent.parent.parent.parent.daySize + parent.parent.parent.parent.weekSpacing

                                height: parent.parent.parent.parent.daySize

                                radius: Theme.calendar.todayRadius

                                visible: parent.validDay

                                color: parent.today ? Theme.calendar.todayColor : "transparent"

                                Text {
                                    anchors.centerIn: parent

                                    text: parent.parent.validDay ? parent.parent.day : ""

                                    color: parent.parent.today ? Theme.calendar.todayTextColor : Theme.calendar.dayTextColor

                                    font.pixelSize: Theme.calendar.dayFontSize

                                    font.bold: parent.parent.today ? Theme.calendar.todayFontBold : Theme.calendar.dayFontBold
                                }
                            }
                        }
                    }
                }
            }

            Component.onCompleted: {
                resetDate()
            }
        }
    }
}
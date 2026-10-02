import QtQuick
import "../Themes"

Popup {
    id: root

    contentItem: Component {
        Item {
            id: calendar

            property date currentDate: new Date()
            property int currentYear: currentDate.getFullYear()
            property int currentMonth: currentDate.getMonth()
            property bool showWeekNumber: true

            implicitHeight: content.implicitHeight
            implicitWidth: calendarWidth

            readonly property var weekDays: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            readonly property int weekSpacing: Theme.calendar.weekSpacing
            readonly property int weekNumberSpacing: Theme.calendar.weekNumberSpacing
            readonly property int daySize: Theme.calendar.daySize

            readonly property real columnWidth: Math.max(weekTextMetrics.width, dayTextMetrics.width, daySize)
            readonly property real dayColumnWidth: columnWidth
            readonly property real weekNumberWidth: weekNumberTextMetrics.width
            readonly property real weekColumnWidth: weekNumberWidth + weekNumberSpacing

            readonly property real calendarWidth: showWeekNumber ? weekColumnWidth + (dayColumnWidth * 7) + (weekSpacing * 6) : (dayColumnWidth * 7) + (weekSpacing * 6)

            TextMetrics {
                id: weekTextMetrics
                text: "Wed"
                font.pixelSize: Theme.calendar.weekFontSize
                font.bold: Theme.calendar.weekFontBold
            }

            TextMetrics {
                id: dayTextMetrics
                text: "31"
                font.pixelSize: Theme.calendar.dayFontSize
                font.bold: Theme.calendar.dayFontBold
            }

            TextMetrics {
                id: weekNumberTextMetrics
                text: "53"
                font.pixelSize: Theme.calendar.dayFontSize
                font.bold: Theme.calendar.dayFontBold
            }

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

            function weekNumber(date) {
                const value = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()))
                const day = value.getUTCDay() || 7
                value.setUTCDate(value.getUTCDate() + 4 - day)
                const yearStart = new Date(Date.UTC(value.getUTCFullYear(), 0, 1))
                return Math.ceil((((value - yearStart) / 86400000) + 1) / 7)
            }

            function weekDate(row) {
                return new Date(currentYear, currentMonth, row * 7 - firstDayOfMonth() + 1)
            }

            function resetDate() {
                currentDate = new Date()
            }

            Column {
                id: content

                anchors.centerIn: parent
                spacing: Theme.calendar.spacing

                Text {
                    width: calendar.calendarWidth
                    text: calendar.monthName()
                    color: Theme.calendar.monthTextColor
                    font.pixelSize: Theme.calendar.monthFontSize
                    font.bold: Theme.calendar.monthFontBold
                    horizontalAlignment: Text.AlignHCenter
                }

                Row {
                    width: calendar.calendarWidth
                    // spacing: 0

                    Column {
                        visible: calendar.showWeekNumber
                        width: calendar.weekColumnWidth

                        Text {
                            id: weekHeader

                            width: calendar.weekNumberWidth
                            text: "W"
                            color: Theme.primary
                            font.pixelSize: Theme.calendar.weekFontSize
                            font.bold: Theme.calendar.weekFontBold
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        Repeater {
                            model: Math.ceil((calendar.firstDayOfMonth() + calendar.daysInMonth()) / 7)

                            delegate: Text {
                                required property int index

                                width: calendar.weekNumberWidth
                                height: calendar.columnWidth
                                text: calendar.weekNumber(calendar.weekDate(index))
                                color: Theme.primary
                                font.pixelSize: Theme.calendar.weekFontSize
                                font.bold: Theme.calendar.weekFontBold
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }

                    Column {
                        width: calendar.dayColumnWidth * 7 + calendar.weekSpacing * 6

                        Row {
                            spacing: calendar.weekSpacing

                            Repeater {
                                model: calendar.weekDays

                                delegate: Text {
                                    required property string modelData

                                    width: calendar.dayColumnWidth
                                    text: modelData
                                    color: Theme.calendar.weekTextColor
                                    font.pixelSize: Theme.calendar.weekFontSize
                                    font.bold: Theme.calendar.weekFontBold
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                        }

                        Grid {
                            columns: 7
                            columnSpacing: calendar.weekSpacing

                            Repeater {
                                model: Math.ceil((calendar.firstDayOfMonth() + calendar.daysInMonth()) / 7) * 7

                                delegate: Item {
                                    required property int index

                                    readonly property int day: index - calendar.firstDayOfMonth() + 1
                                    readonly property bool validDay: day >= 1 && day <= calendar.daysInMonth()
                                    readonly property bool today: validDay && day === new Date().getDate() && calendar.currentMonth === new Date().getMonth() && calendar.currentYear === new Date().getFullYear()

                                    width: calendar.dayColumnWidth
                                    height: calendar.columnWidth

                                    Rectangle {
                                        visible: parent.validDay
                                        anchors.centerIn: parent
                                        width: calendar.daySize
                                        height: calendar.daySize
                                        radius: Theme.calendar.todayRadius
                                        color: parent.today ? Theme.calendar.todayColor : "transparent"

                                        Text {
                                            anchors.centerIn: parent
                                            text: parent.parent.day
                                            color: parent.parent.today ? Theme.calendar.todayTextColor : Theme.calendar.dayTextColor
                                            font.pixelSize: Theme.calendar.dayFontSize
                                            font.bold: parent.parent.today ? Theme.calendar.todayFontBold : Theme.calendar.dayFontBold
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
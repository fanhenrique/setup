import QtQuick
import Quickshell
import ".."

PopupWindow {
    id: root

    required property var target

    property date currentDate: new Date()

    property int currentYear: currentDate.getFullYear()
    property int currentMonth: currentDate.getMonth()

    readonly property var weekDays: [
        "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"
    ]

    readonly property int weekSpacing: Theme.calendar.weekSpacing
    readonly property int daySize: Theme.calendar.daySize

    property int padding: 12
    property int gap: 5

    color: "transparent"

    implicitWidth: content.implicitWidth + padding * 2
    implicitHeight: content.implicitHeight + padding * 2

    anchor {
        item: root.target

        rect.x: root.target.width / 2
        rect.y: root.target.height + root.gap
        rect.width: 1
        rect.height: 1

        edges: Edges.Top
        gravity: Edges.Bottom
        adjustment: PopupAdjustment.All
    }

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

    Rectangle {
        anchors.fill: parent

        color: Theme.background
        radius: 8

        border {
            width: 1
            color: "#4c566a"
        }

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

                rows: Math.ceil(
                    (
                        root.firstDayOfMonth() +
                        root.daysInMonth()
                    ) / 7
                )

                Repeater {
                    model:
                        Math.ceil(
                            (
                                root.firstDayOfMonth() +
                                root.daysInMonth()
                            ) / 7
                        ) * 7

                    delegate: Item {
                        required property int index

                        width: root.columnWidth + root.weekSpacing
                        height: root.columnWidth

                        readonly property int day:
                            index -
                            root.firstDayOfMonth() +
                            1

                        readonly property bool validDay:
                            day >= 1 &&
                            day <= root.daysInMonth()

                        readonly property bool today:
                            validDay &&
                            day === new Date().getDate() &&
                            root.currentMonth ===
                                new Date().getMonth() &&
                            root.currentYear ===
                                new Date().getFullYear()

                        Rectangle {
                            anchors.centerIn: parent

                            width: root.daySize + root.weekSpacing
                            height: root.daySize

                            radius: Theme.calendar.todayRadius

                            visible: validDay

                            color:
                                today
                                    ? Theme.calendar.todayColor
                                    : "transparent"

                            Text {
                                anchors.centerIn: parent

                                text: validDay ? day : ""

                                color:
                                    today
                                        ? Theme.calendar.todayTextColor
                                        : Theme.calendar.dayTextColor

                                font.pixelSize:
                                    Theme.calendar.dayFontSize

                                font.bold:
                                    today
                                        ? Theme.calendar.todayFontBold
                                        : Theme.calendar.dayFontBold
                            }
                        }
                    }
                }
            }
        }
    }

    function open() {
        currentDate = new Date()
        visible = true
    }

    function close() {
        visible = false
    }

    function toggle() {
        if (visible)
            close()
        else
            open()
    }
}

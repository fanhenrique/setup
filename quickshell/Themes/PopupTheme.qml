pragma Singleton

import QtQuick
import ".."

QtObject {
    id: root
    

    // ############################
    // Popup
    // ############################
    readonly property QtObject popup: QtObject {
        // Gap 
        readonly property int gap: 15
        
        // Color
        readonly property color color: Theme.background

        // Padding
        readonly property int padding: 8

        // Border
        readonly property int radius: 8
        readonly property int borderWidth: 2
        readonly property color borderColor: Theme.borderColor
        
        // Close the popup when clicking outside it
        readonly property bool grabFocus: true
    }

    // ############################
    // Popup Calendar
    // ############################
    readonly property QtObject calendar: QtObject {
        // Positions
        readonly property int spacing: 5
        readonly property int weekSpacing: 8
        readonly property int daySize: 20

        // Month
        readonly property int monthFontSize: 20
        readonly property bool monthFontBold: true
        readonly property color monthTextColor: Theme.textColor

        // Week
        readonly property int weekFontSize: 14
        readonly property bool weekFontBold: true
        readonly property color weekTextColor: Theme.textColor

        // Days
        readonly property int dayFontSize: 14
        readonly property bool dayFontBold: false
        readonly property color dayTextColor: Theme.textColor

        // Today (inherits dayFontSize from Days)
        readonly property bool todayFontBold: true
        readonly property color todayTextColor: "#000000"
        readonly property color todayColor: Theme.primary
        readonly property int todayRadius: 4
    }

    // ############################
    // Popup Volume
    // ############################
    readonly property QtObject volume: QtObject {
        readonly property int spacing: 6
        readonly property int fontSize: Theme.fontSize

        readonly property color textColor: Theme.textColor
        readonly property color mutedColor: Theme.primary
    }
}

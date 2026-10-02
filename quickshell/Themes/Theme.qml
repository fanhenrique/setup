pragma Singleton

import QtQuick

QtObject {
    id: root

    // Global colors
    readonly property color background: '#111111'
    readonly property color foreground: "#eceff4"
    readonly property color primary: "#0079b1"
    readonly property color urgent: "#bf616a"
    readonly property color warning: "#ebcb8b"
    readonly property color success: "#a3be8c"
    readonly property color borderColor: "#eceff4"

    // Default font
    readonly property color textColor: "#e4e4e4"
    readonly property int fontSizeSmall: 12
    readonly property int fontSize: 14
    readonly property int fontSizeLarge: 16
    
    // ############################
    // Components
    // ############################

    // Bar
    readonly property QtObject bar: QtObject {
        // Size
        readonly property int height: 36

        // Position (default = "top") -> "top" or "bottom"
        readonly property string position: "top"

        // Color
        readonly property color background: root.background
    }

    // Workspaces
    readonly property QtObject workspaces: QtObject {
        // Position
        readonly property int spacing: 0

        // Focused
        readonly property int widthFocused: 28
        readonly property int heightFocused: 28
        readonly property int radiusFocused: 8

        // Text
        readonly property color textColor: root.textColor
        readonly property int fontSize: root.fontSizeLarge
        readonly property bool fontBold: true

        // Colors
        readonly property color focused: root.primary
        readonly property color urgent: root.urgent
        readonly property color unfocused: "transparent"
    }

    // Component FocusedWindow
    readonly property QtObject focusedWindow: QtObject {

        // Size
        readonly property int width: 400
        
        // Text
        readonly property color textColor: root.textColor
        readonly property int fontSize: root.fontSize
        readonly property bool fontBold: true

        // Alignment
        readonly property int horizontalAlignment: Text.AlignLeft
        readonly property int verticalAlignment: Text.AlignVCenter
        
        // Text overflow
        readonly property int elide: Text.ElideMiddle
    }

    // Component Clock
    readonly property QtObject clock: QtObject {
        // Format
        readonly property string format: "dd/MM HH:mm"
        
        // Text
        readonly property color textColor: root.textColor
        readonly property int fontSize: root.fontSize
        readonly property bool fontBold: true

        // Interval (milliseconds)
        readonly property int interval: 1000
    }

    // Component Tray
    readonly property QtObject tray: QtObject {
        readonly property int iconWidth: 20
        readonly property int iconHeight: 20
        readonly property int spacing: 8
    }

      
    // ############################
    // Popups
    // ############################

    // Popup
    readonly property QtObject popup: QtObject {
        // Gap 
        readonly property int gap: 15
        
        // Color
        readonly property color color: root.background

        // Padding
        readonly property int padding: 8

        // Border
        readonly property int radius: 8
        readonly property int borderWidth: 2
        readonly property color borderColor: root.borderColor
        
        // Close the popup when clicking outside it
        readonly property bool grabFocus: true
    }

    // Calendar
    readonly property QtObject calendar: QtObject {
        // Positions
        readonly property int spacing: 12
        readonly property int weekSpacing: 8
        readonly property int weekNumberSpacing: 32

        readonly property int daySize: 20

        // Month
        readonly property int monthFontSize: 20
        readonly property bool monthFontBold: true
        readonly property color monthTextColor: root.textColor

        // Week
        readonly property int weekFontSize: 14
        readonly property bool weekFontBold: true
        readonly property color weekTextColor: root.textColor

        // Days
        readonly property int dayFontSize: 14
        readonly property bool dayFontBold: false
        readonly property color dayTextColor: root.textColor

        // Today (inherits dayFontSize from Days)
        readonly property bool todayFontBold: true
        readonly property color todayTextColor: "#000000"
        readonly property color todayColor: root.primary
        readonly property int todayRadius: 4
    }

    // Volume
    readonly property QtObject volume: QtObject {
        readonly property int spacing: 6
        readonly property int fontSize: root.fontSize
        readonly property bool fontBold: true
        readonly property color textColor: root.textColor
        readonly property color mutedColor: root.primary
    }

}

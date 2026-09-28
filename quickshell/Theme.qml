pragma Singleton

import QtQuick

QtObject {
    id: root

    // ############################
    // Global colors
    // ############################
    readonly property color background: "#464646"
    readonly property color foreground: "#eceff4"
    readonly property color primary: "#0079b1"
    readonly property color urgent: "#bf616a"
    readonly property color warning: "#ebcb8b"
    readonly property color success: "#a3be8c"

    // ############################
    // Default font
    // ############################
    readonly property color textColor: "#e4e4e4"
    readonly property int fontSizeSmall: 12
    readonly property int fontSize: 14
    readonly property int fontSizeLarge: 16

    // ############################
    // Bar
    // ############################
    readonly property QtObject bar: QtObject {
        // Size
        readonly property int height: 32

        // Position (default = "top") -> "top" or "bottom"
        readonly property string position: "top"

        // Color
        readonly property color background: root.background
    }

    // ############################
    // Component Workspaces
    // ############################
    readonly property QtObject workspaces: QtObject {
        // Position
        readonly property int leftMargin: 4
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

    // ############################
    // Component FocusedWindow
    // ############################
    readonly property QtObject focusedWindow: QtObject {
        // Position
        readonly property int leftMargin: 4

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

    // ############################
    // Component Clock
    // ############################
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

    // ############################
    // Component Tray
    // ############################
    readonly property QtObject tray: QtObject {
        readonly property int iconWidth: 20
        readonly property int iconHeight: 20
        readonly property int spacing: 8
    }

    // // ############################
    // // CPU
    // // ############################
    // readonly property QtObject cpu: QtObject {
    //     readonly property color textColor: root.textColor
    //     readonly property color warning: root.warning
    //     readonly property color critical: root.primary
    //     readonly property int fontSize: root.fontSize
    // }

    // // ############################
    // // Memory
    // // ############################

    // readonly property QtObject memory: QtObject {
    //     readonly property color textColor: root.textColor
    //     readonly property color warning: root.warning
    //     readonly property color critical: root.primary
    //     readonly property int fontSize: root.fontSize
    // }

    // // ############################
    // // Network
    // // ############################

    // readonly property QtObject network: QtObject {
    //     readonly property color textColor: root.textColor
    //     readonly property color warning: root.warning
    //     readonly property color critical: root.primary
    //     readonly property int fontSize: root.fontSize
    // }

}

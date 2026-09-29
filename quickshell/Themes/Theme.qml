pragma Singleton

import QtQuick

QtObject {
    id: root

    // ############################
    // Global colors
    // ############################
    readonly property color background: '#111111'
    readonly property color foreground: "#eceff4"
    readonly property color primary: "#0079b1"
    readonly property color urgent: "#bf616a"
    readonly property color warning: "#ebcb8b"
    readonly property color success: "#a3be8c"

    readonly property color borderColor: "#eceff4"

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
        readonly property int height: 36

        // Position (default = "top") -> "top" or "bottom"
        readonly property string position: "top"

        // Color
        readonly property color background: root.background
    }

}

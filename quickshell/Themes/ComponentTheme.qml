pragma Singleton

import QtQuick
import ".."

QtObject {
    id: root

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
        readonly property color textColor: Theme.textColor
        readonly property int fontSize: Theme.fontSizeLarge
        readonly property bool fontBold: true

        // Colors
        readonly property color focused: Theme.primary
        readonly property color urgent: Theme.urgent
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
        readonly property color textColor: Theme.textColor
        readonly property int fontSize: Theme.fontSize
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
        readonly property color textColor: Theme.textColor
        readonly property int fontSize: Theme.fontSize
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
}

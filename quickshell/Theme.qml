pragma Singleton

import QtQuick

QtObject {
    readonly property color background: '#464646'
    readonly property color foreground: "#eceff4"
    readonly property color primary: "#bf616a"
    readonly property color warning: "#ebcb8b"
    readonly property color success: "#a3be8c"

    readonly property color textColor: '#e4e4e4'


    readonly property int fontSize: 14
    readonly property int fontSizeSmall: 12
    readonly property int fontSizeLarge: 16

    readonly property int barHeight: 32
    readonly property int workspaceSize: 24
    readonly property int spacing: 8
}
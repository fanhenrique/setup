pragma Singleton

import QtQuick

QtObject {
    id: root

    property var currentPopup: null

    function open(popup) {
        if (currentPopup && currentPopup !== popup)
            currentPopup.visible = false

        currentPopup = popup
        popup.visible = true
    }

    function close(popup) {
        if (currentPopup === popup) {
            popup.visible = false
            currentPopup = null
            return
        }

        popup.visible = false
    }

    function toggle(popup) {
        if (popup.visible) {
            close(popup)
        } else {
            open(popup)
        }
    }
}
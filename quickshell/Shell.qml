//@ pragma UseQApplication

import Quickshell
import QtQuick
import "Components"

ShellRoot {
    Variants {
        model: Quickshell.screens

        Bar {
            screen: modelData
        }
    }
}
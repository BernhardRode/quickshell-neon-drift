import QtQuick
import Quickshell
import Quickshell.Wayland
import "./modules"

// Neon Drift — an animated live background for Quickshell/Omarchy.
//
// Run with:
//   qs -n -d -c neon-drift
//
// (`-c` resolves to ~/.config/quickshell/neon-drift/shell.qml, `-d`
// daemonizes, `-n` makes re-launching idempotent — see README.md.)
ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: background
            required property var modelData
            screen: modelData

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }
            color: "transparent"

            WlrLayershell.layer: WlrLayer.Background
            WlrLayershell.namespace: "quickshell:neon-drift"
            WlrLayershell.exclusionMode: ExclusionMode.Ignore

            DriftField {
                anchors.fill: parent
            }
        }
    }
}

import QtQuick
import QtQuick.Effects

// The "Neon Drift" visual: a dark gradient backdrop, a soft pulsing horizon
// glow, a fading synthwave grid, and a handful of neon streaks that drift
// across the screen at different lanes and speeds. Colors come from
// `Palette`, which mirrors the live Omarchy theme.
Item {
    id: root

    property int streakCount: 14
    property bool showGrid: true
    property bool showHorizonGlow: true
    // Multiplies streak/glow speed. >1 = faster drift, <1 = slower/dreamier.
    property real speedScale: 1.0

    readonly property var palette: Palette

    // --- Backdrop --------------------------------------------------------
    Rectangle {
        id: backdrop
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: root.palette.backgroundAlt }
            GradientStop { position: 1.0; color: root.palette.background }
        }
    }

    // --- Horizon glow ------------------------------------------------------
    Rectangle {
        id: horizonGlow
        visible: root.showHorizonGlow
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height * 0.62 - height / 2
        width: Math.min(parent.width, parent.height) * 0.9
        height: width
        radius: width / 2
        color: root.palette.accents[0]
        opacity: 0.35

        layer.enabled: true
        layer.effect: MultiEffect {
            blurEnabled: true
            blurMax: 64
            blur: 1.0
        }

        SequentialAnimation on opacity {
            running: root.showHorizonGlow
            loops: Animation.Infinite
            NumberAnimation { to: 0.55; duration: 4200 / root.speedScale; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.25; duration: 4200 / root.speedScale; easing.type: Easing.InOutSine }
        }
    }

    // --- Fading synthwave grid --------------------------------------------
    Item {
        id: grid
        visible: root.showGrid
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: parent.height * 0.38
        clip: true

        Repeater {
            model: 10
            delegate: Rectangle {
                id: gridLine
                required property int index
                readonly property real t: index / 9

                anchors.horizontalCenter: parent.horizontalCenter
                y: grid.height * (1 - Math.pow(t, 1.6))
                width: parent.width * (0.15 + t * 0.85)
                height: 1
                color: root.palette.accents[1 % root.palette.accents.length]
                opacity: 0.08 + t * 0.22
            }
        }
    }

    // --- Drifting neon streaks ---------------------------------------------
    Repeater {
        model: root.streakCount

        delegate: Item {
            id: streak
            required property int index

            readonly property real laneY: (root.height / (root.streakCount + 1)) * (index + 1)
                + Math.sin(index * 12.9898) * 18
            readonly property color streakColor: root.palette.accents[index % root.palette.accents.length]
            readonly property real streakSpeed: (9000 + (index % 5) * 2600) / root.speedScale
            readonly property real streakWidth: root.width * (0.16 + (index % 4) * 0.03)

            y: laneY
            x: -streakWidth
            width: streakWidth
            height: 2 + (index % 3)

            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 0.5; color: streak.streakColor }
                    GradientStop { position: 1.0; color: "transparent" }
                }
            }

            layer.enabled: true
            layer.effect: MultiEffect {
                blurEnabled: true
                blurMax: 24
                blur: 0.6
            }

            SequentialAnimation {
                running: true
                loops: Animation.Infinite
                PauseAnimation { duration: (streak.index % 7) * 420 }
                NumberAnimation {
                    target: streak
                    property: "x"
                    from: -streak.streakWidth
                    to: root.width + streak.streakWidth
                    duration: streak.streakSpeed
                    easing.type: Easing.InOutSine
                }
            }
        }
    }
}

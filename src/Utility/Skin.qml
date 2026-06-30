pragma Singleton

import QtQuick

QtObject {
    // Colors of the remote ui
    readonly property color black: "black"
    readonly property color dark: "#101010"
    readonly property color darkGray: "#202020"
    readonly property color gray1: "#303030"
    readonly property color gray2: "#363636"
    readonly property color gray3: "#505050"
    readonly property color lightGray: "#808080"
    readonly property color white: "white"
    readonly property color orange: "#f6a019"
    readonly property color brown: "#62400a"

    // Others colors
    readonly property color red: "#FF0000"
    readonly property color yellow: "#FFFF00"
    readonly property color green1: "#00FF00"
    readonly property color green2: "#6fae6a"
    readonly property color turquoise: "#00FFFF"
    readonly property color blue1: "#0000FF"
    readonly property color blue2: "#4f7374"
    readonly property color purple: "#FF00FF"
    readonly property color transparent: "transparent"
    readonly property color transparentPurple: "#a7dd0dFF"

    // Layout metrics — minimum interactive size for touch (Apple HIG 44 / Material 48)
    readonly property int minTouch: 44

    // Typography scale (point sizes) — a small, fixed set of steps so chrome
    // text stays consistent across desktop / web / tablet instead of ad-hoc
    // magic numbers. Roughly a 1.2 ratio: caption / body / label / title / heading.
    readonly property int fontCaption: 10  // panel headers, fine print
    readonly property int fontBody: 12     // secondary / supporting text
    readonly property int fontLabel: 14    // default control label
    readonly property int fontTitle: 16    // surface / section titles, empty-state heading
    readonly property int fontHeading: 18  // largest emphasis
}

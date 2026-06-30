/*
  * Play / Pause / Connect button :
  * - at the top left, doubles as the connect button when disconnected
  * - touch- and mouse-friendly: logical "mode" drives the base icon, the
  *   pressed/hovered state drives the highlight, and onClicked performs the
  *   action (so a tap acts and a slide-off cancels, on both touch and mouse)
  */

import QtQuick
import QtQuick.Controls

import Variable.Global 1.0

Button {
    id: control

    width: parent.width; height: parent.width
    padding: 0; topPadding: 0; bottomPadding: 0; leftPadding: 0; rightPadding: 0
    hoverEnabled: true

    // "connection" = disconnected, "play" = connected/stopped, "pause" = playing
    property string mode: "connection"

    function stopClicked() { control.mode = "play" }
    function isConnected() { return control.mode !== "connection" }
    function isPaused() { return control.mode === "play" }
    function playPressInScore() { control.mode = "pause" }
    function pausePressInScore() { control.mode = "play" }
    function connectedToScore() { control.mode = "play" }
    function disonnectedFromScore() { control.mode = "connection" }

    onClicked: {
        switch (control.mode) {
        case "connection":
            socket.active = !socket.active
            break
        case "play":
            socket.sendTextMessage('{ "Message": "Play" }')
            control.mode = "pause"
            break
        case "pause":
            socket.sendTextMessage('{ "Message": "Pause" }')
            control.mode = "play"
            break
        }
    }

    background: Rectangle { color: Skin.darkGray }

    contentItem: Image {
        id: pauseButton

        sourceSize { width: parent.width; height: parent.width }
        fillMode: Image.PreserveAspectFit
        clip: true
        source: control.mode === "connection"
                ? (control.down ? "../Icons/connection_on.png"
                   : control.hovered ? "../Icons/connection_hover.png"
                     : "../Icons/connection.png")
                : control.mode === "play"
                  ? (control.down ? "../Icons/play_glob_on.png"
                     : control.hovered ? "../Icons/play_glob_hover.png"
                       : "../Icons/play_glob_off.png")
                  : (control.down ? "../Icons/pause_hover.png"
                     : "../Icons/pause_on.png")
    }
}

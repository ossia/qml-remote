/*
  * Stop button :
  * - at the top left of the interface with others buttons
  * - synchronizes with score
  * - touch- and mouse-friendly: pressed/hovered drives the highlight,
  *   onClicked performs the stop
  */

import QtQuick
import QtQuick.Controls

import Variable.Global 1.0

Button {
    id: control

    width: parent.width; height: parent.width
    padding: 0; topPadding: 0; bottomPadding: 0; leftPadding: 0; rightPadding: 0
    hoverEnabled: true

    onClicked: {
        if (playPause.isConnected())
            playPause.stopClicked()
        socket.sendTextMessage('{ "Message": "Stop" }')
        scoreTimeline.stopTimeline()
    }

    background: Rectangle { color: Skin.darkGray }

    contentItem: Image {
        id: stopButton

        sourceSize { width: parent.width; height: parent.width }
        fillMode: Image.PreserveAspectFit
        clip: true
        source: control.down ? "../Icons/stop_on.png"
                : control.hovered ? "../Icons/stop_hover.png"
                  : "../Icons/stop_off.png"
    }
}

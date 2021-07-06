/*
  * button to hide the top panel :
  * - at the top right of the interface
  * - hide triggers, scoreSpeeds
  * - play and pause buttons and the main speed are always visible
  */

import QtQuick 2.0
import QtQuick.Controls 2.12

Button {
    id: scoreHideButton
    anchors.top: parent.top
    anchors.bottom: scoreSpeed.bottom
    anchors.right: parent.right
    anchors.rightMargin: 5
    anchors.topMargin: 5
    width: window.width <= 500 ? 20 : 30

    background: Rectangle {
        color: "#363636"
        width: parent.width
        height: parent.height
    }

    contentItem: Image {
        id: indicator
        anchors.verticalCenter: parent.verticalCenter
        width: parent.height
        height: parent.height
        source: !scoreTriggers.visible
                ? scoreHideButton.pressed
                  ? "../Icons/indicator_on.svg"
                  : "../Icons/indicator.svg"
                : scoreHideButton.pressed
                  ? "../Icons/indicator_hidden_on.svg"
                  : "../Icons/indicator_hidden.svg"
    }

    onReleased: {
        scoreTriggers.visible = ! scoreTriggers.visible
        scoreSpeeds.visible = ! scoreSpeeds.visible
        ipAdress.visible = ! ipAdress.visible
        window.state = scoreSpeeds.visible ? "" : "hidden"
        scorePlayPauseStop.state = scoreSpeeds.visible ? "" : "hidden"
    }
}

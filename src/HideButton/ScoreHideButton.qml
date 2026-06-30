/*
  * button to hide the top panel :
  * - at the top right of the interface
  * - hide triggers, scoreSpeeds
  * - play and pause buttons and the main speed are always visible
  */

import QtQuick
import QtQuick.Controls

import Variable.Global 1.0

Button {
    width: scoreSpeed.height
    padding: 0; topPadding: 0; bottomPadding: 0; leftPadding: 0; rightPadding: 0

    background: Rectangle {
        width: parent.width; height: parent.height
        color: Skin.gray2
    }

    // Same pattern as the (square, centered) play/pause/stop buttons.
    contentItem: Image {
        id: indicator

        sourceSize { width: parent.width; height: parent.width }
        fillMode: Image.PreserveAspectFit
        source: !window.panelsVisible
                ? scoreHideButton.pressed
                  ? "../Icons/indicator_on.png"
                  : "../Icons/indicator.png"
                : scoreHideButton.pressed
                  ? "../Icons/indicator_hidden_on.png"
                  : "../Icons/indicator_hidden.png"
    }

    onClicked: window.panelsVisible = !window.panelsVisible
}

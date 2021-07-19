/*
  * button to switch between main and mixer panels :
  * - at the top left of the interface
  */

import QtQuick 2.12
import QtQuick.Controls 2.12

import Variable.Global 1.0

Button {
    id: scroreButtonPanel

    background: Rectangle {
        width: parent.width; height: parent.height
        color: Skin.darkGray
    }

    contentItem: Image {
        id: indicator

        width: parent.height; height: parent.height
        anchors.verticalCenter: parent.verticalCenter
        source: !scoreControlSurfaceList.visible
                ? scroreButtonPanel.pressed
                  ? "../Icons/main_panel.png"
                  : "../Icons/main_panel_on.png"
                : scroreButtonPanel.pressed
                  ? "../Icons/audio_on.png"
                  : "../Icons/audio.png"
    }

    onReleased: {
        /*
        scoreTriggers.visible = ! scoreTriggers.visible
        scoreSpeeds.visible = ! scoreSpeeds.visible
        ipAddress.visible = ! ipAddress.visible
        window.state = scoreSpeeds.visible ? "" : "hidden"
        scorePlayPauseStop.state = scoreSpeeds.visible ? "" : "hidden"
        */
        scoreControlSurfaceList.visible = ! scoreControlSurfaceList.visible
    }
}


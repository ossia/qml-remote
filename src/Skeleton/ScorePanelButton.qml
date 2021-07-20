/*
  * button to switch between main and mixer panels :
  * - at the top left of the interface
  */

import QtQuick 2.12
import QtQuick.Controls 2.12

import Variable.Global 1.0

Button {
    id: scorePanelButton

    background: Rectangle {
        width: parent.width; height: parent.height
        color: Skin.darkGray
    }

    contentItem: Image {
        id: indicator

        width: parent.height; height: parent.height
        anchors.verticalCenter: parent.verticalCenter
        source: !scoreControlSurfaceList.visible
                ? scorePanelButton.pressed
                  ? "../Icons/main_panel_on.png"
                  : "../Icons/main_panel.png"
                : scorePanelButton.pressed
                  ? "../Icons/audio_on.png"
                  : "../Icons/audio.png"
    }

    onReleased: {
        ipAddress.visible = ! ipAddress.visible
        scoreTriggers.visible = ! scoreTriggers.visible
        scoreControlSurfaceList.visible = ! scoreControlSurfaceList.visible
        scoreSpeed.visible = ! scoreSpeed.visible
        scoreSpeeds.visible = ! scoreSpeeds.visible
        scoreHideButton.visible = ! scoreHideButton.visible
        scoreAudioPanel.visible = ! scoreAudioPanel.visible
        scoreTimeline.visible = ! scoreTimeline.visible
        window.state = window.state != "volume_panel" ? "volume_panel" : ""
        scorePlayPauseStop.state = scoreSpeed.visible ? "" : "hidden"
    }
}


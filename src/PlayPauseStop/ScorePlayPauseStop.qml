/*
  * Contains buttons that allow you to interract with time :
  * - Play, Pause buttons
  * - stop button
  * - has 2 states :
  *     - "" : horizontal button list
  *     - "hidden" : vertical button list
  */

import QtQuick 2.9
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.12

Item {
    id: playPauseStop

    ScorePlayPause {
        id: playPause
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width
    }

    ScoreStop {
        id: stop
        anchors.top: playPause.bottom
        anchors.left: parent.left
        width: parent.width
    }

    /* Same behavior as ScoreStop
    ScoreReinitialize {
        id: reinitialize
    }
    */

    Connections {
        target: scorePlayPauseStop
        function onPlayPauseStopMessageReceived(m) {
            var messageObject = m.Message
            switch (messageObject) {
            case "Start":
                //send signal to playPause Button
                playPause.clicked()
                break
            case "Stop":
                //send signal to stop Button
                stop.clicked()
                scoreControlSurfaceList.clearListModel()
                break

                /*
            case "Restart":
                //send signal to reinitialize Button
                reinitialize.clicked()
                break
            */
            }
        }
        function onScorePlayPauseStopMessageReceived(m) {
            var messageObject = m.Message
            switch (messageObject) {
            case "IntervalPaused":
                playPause.pausePressInScore()
                break
            case "IntervalResumed":
                playPause.playPressInScore()
                break
            }
        }

        // Connect play/pause buttons with the socket instance
        function onConnectedToScore() {
            playPause.connectedToScore()
        }

        function onDisconnectedFromScore() {
            playPause.disonnectedFromScore()
        }
    }

    states: [

        // State in which the top panel (triggers, speeds) is hidden
        // and the button list is vertical
        State {
            name: "hidden"

            PropertyChanges {
                target: playPause
                anchors.top: parent.top
                anchors.left: parent.left
                width: parent.width / 2
                height: parent.height
            }

            PropertyChanges {
                target: stop
                anchors.top: parent.top
                anchors.left: playPause.right
                width: parent.width / 2
                height: parent.height
            }
        }
    ]
}

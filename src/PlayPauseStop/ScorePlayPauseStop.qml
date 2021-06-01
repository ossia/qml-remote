import QtQuick 2.9
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.12

Column {
    id: playPauseStop
    ScorePlayPause {
        id: playPause
    }

    ScoreStop {
        id: stop
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
}

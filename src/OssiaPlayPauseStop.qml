import QtQuick 2.9
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtMultimedia 5.0
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.15


Column{
    OssiaPlayPause{id: playPause}
    //OssiaPlayGlob{id: playGlob}
    OssiaStop{id: stop}
    OssiaReinitialize{id: reinitialize}
    //onplayPauseStopMessageReceived(var n){}
    Connections {
        target: ossiaPlayPauseStop
        function onPlayPauseStopMessageReceived(n){
            var messageObject = m.Message
            switch (messageObject) {
            case "Start":
                //send signal to playPause Button
                playPause.clicked();
                break;
            case "Stop":
                //send signal to stop Button
                stop.clicked();
                break;
            case "Restart":
                //send signal to reinitialize Button
                reinitialize.clicked();
            }
        }
    }
}

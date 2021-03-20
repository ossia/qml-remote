import QtQuick 2.9
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtMultimedia 5.0
import QtQuick.Controls.Material 2.3
Item {
    Button {
        x:0; y:0;
        width: 50
        height: 50
        palette{
            button: "black"
        }
        Image{
            id:pauseButton
            //anchors.fill
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "Icons/play_off.svg"
            states: [
                    State {
                        name: "clicked"
                        PropertyChanges { target: pauseButton; source: "Icons/pause_on.svg" }
                    }
                ]
        }

        onClicked: pauseButton.state == 'clicked'? pauseButton.state = "" : pauseButton.state = 'clicked';

 }
    Button{
        x:0; y:50;
        width: 50
        height: 50
        palette{
            button: "black"
        }
        Image{
            id: playGlobButton
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source:"Icons/play_glob_off.svg"
            states: [
                    State {
                        name: "holdClickPause"
                        PropertyChanges { target: playGlobButton; source: "Icons/play_glob_on.svg" }
                    }
                ]
        }
        onPressed: playGlobButton.state = 'holdClickPause'
        onReleased: playGlobButton.state = ''
    }


    Button{
        x:0; y:100;
        width: 50
        height: 50
        palette{
            button: "black"
        }
        Image{
            id: stopButton
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source:"Icons/stop_off.svg"
            states: [
                    State {
                        name: "holdClickPause"
                        PropertyChanges { target: stopButton; source: "Icons/stop_on.svg" }
                    }
                ]
        }
        onPressed: stopButton.state = 'holdClickPause'
        onReleased: stopButton.state = ''
    }

    Button{
        x:0; y:150;
        width: 50
        height: 50
        palette{
            button: "black"
        }
        Image{
            id: reinitializeButton
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source:"Icons/reinitialize_off.svg"
            states: [
                    State {
                        name: "holdClickPause"
                        PropertyChanges { target: reinitializeButton; source: "Icons/reinitialize_on.svg" }
                    }
                ]
        }
        onPressed: reinitializeButton.state = 'holdClickPause'
        onReleased: reinitializeButton.state = ''
    }
}


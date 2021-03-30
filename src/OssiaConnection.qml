import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtQuick.Controls.Material 2.3


Button {
        id: start
       text: qsTr("Connexion")
       x:200
       onClicked: {
            if(text === "Connexion"){
                socket.active = !socket.active
                text = qsTr("Start");
            }
           else  if (text === "Start"){
                socket.sendTextMessage('{ "Message": "Pause" }');
                text = qsTr("Pause");
            }else if (text === "Pause"){
                socket.sendTextMessage('{ "Message": "Play" }');

                text = qsTr("Start");
            }
       }
   }
/*
Button {
    onClicked: {
        if(pauseButton.state == ""){
            socket.active = !socket.active
            pauseButton.state = "playConnection"
        } else if(pauseButton.state == "playConnection"){
            socket.sendTextMessage('{ "Message": "Play" }');
            pauseButton.state === "pause"
        } else if(pauseButton.state == "pause"){
            socket.sendTextMessage('{ "Message": "Pause" }');
            pauseButton.state === "play"
        } else if(pauseButton.state == "pause"){
            socket.sendTextMessage('{ "Message": "Play" }');
            pauseButton.state === "play"
        }
    }

    contentItem:    Image{
        id:pauseButton
        anchors.fill: zone
        source: "Icons/connection.svg"
        states: [
            State {
                name: "pause"
                PropertyChanges { target: pauseButton; source: "Icons/pause_on.svg" }
            },
            State{
                name: "play"
                PropertyChanges { target: pauseButton; source: "Icons/play_off.svg" }
            },
            State{
                name: "playConnection"
                PropertyChanges { target: pauseButton; source: "Icons/play_off.svg" }
            }
        ]
    }
    background: Rectangle{
        id: zone
        color:"#202020"
        width: 40
        height: 40
    }
}
*/

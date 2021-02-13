import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtMultimedia 5.0
import QtQuick.Controls.Material 2.3

Button {
    onClicked: {
        if(pauseButton.state === ''){
            pauseButton.state = 'play_off'
                            socket.active = !socket.active
        } else if(pauseButton.state == 'play_off'){
            pauseButton.state = 'pause_on'
                            socket.sendTextMessage('{ "Message": "Play" }');
        } else if(pauseButton.state == 'pause_on'){
            pauseButton.state = 'play_off'
                            socket.sendTextMessage('{ "Message": "Pause" }');
        }
    }
    contentItem:    Image{
        id:pauseButton
        anchors.fill: zone
        source: "Icons/connection.svg"
        states: [
            State {
                name: "play_off"
                PropertyChanges { target: pauseButton; source: "Icons/play_off.svg" }
            },
            State {
                name: "pause_on"
                PropertyChanges { target: pauseButton; source: "Icons/pause_on.svg" }
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




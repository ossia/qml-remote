import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtQuick.Controls.Material 2.3



Button {
    hoverEnabled: true // Allows to specify a behavior when going over a button
    function stopClicked() {
        pauseButton.state = 'playDisplayed';
    }
    function isConnected() {
        return (pauseButton.state !== '');
    }
    function isPaused() {
        return (pauseButton.state === 'hoveredPlayOff');
    }
    function playPressInScore() {
        pauseButton.state ='pauseDisplayed'
    }
    function pausePressInScore(){
        pauseButton.state = 'playDisplayed'
    }


    onHoveredChanged: {
        switch (pauseButton.state) {
        case 'connectionOn':
            pauseButton.state = ''
            break;
        case 'playPressed':
            pauseButton.state = 'playDisplayed'
            break;
        }
    }


    onPressed: {
        if (pauseButton.state === ''){
            pauseButton.state = 'connectionOn'
        }
        if (pauseButton.state === 'playDisplayed'){
            pauseButton.state = 'playPressed'
        }
    }

    onClicked: {
        switch (pauseButton.state) {
        case 'connectionOn':
            /* Connection to the websocket
              * socket is the id of the Websocket
              * instantiated in ScoreSkeleton
              */
            pauseButton.state = 'playDisplayed';
            socket.active = !socket.active;
            break;
        case 'playPressed':
            pauseButton.state = 'pauseDisplayed';
            socket.sendTextMessage('{ "Message": "Play" }');
            break;
        case 'pauseDisplayed':
            pauseButton.state = 'playDisplayed';
            socket.sendTextMessage('{ "Message": "Pause" }');
            break;
        default:
        }
    }

    contentItem: Image {
        id: pauseButton
        sourceSize.width: 30
        sourceSize.height: 30
        source: "Icons/connection.png"
        clip: true

        states: [
            State {
                name: "connectionOn"
                PropertyChanges {
                    target: pauseButton
                    source: "Icons/connection_hover.png"
                }
            },
            State {
                /* play symbol is displayed
                * "paused" is the scenario's state.
                */
                name: "playDisplayed"
                PropertyChanges {
                    target: pauseButton
                    source: "Icons/play_glob_off.png"
                }
            },
            State {
                name: "playPressed"
                PropertyChanges {
                    target: pauseButton
                    source: "Icons/play_glob_on.png"
                }
            },
            State {
                name: "hoveredConnection"
                PropertyChanges {
                    target: pauseButton
                    source: "Icons/connection_hover.png"
                }
            },
            State {
                /* pause symbol is displayed
                * "playing" is the scenario's state.
                */
                name: "pauseDisplayed"
                PropertyChanges {
                    target: pauseButton
                    source: "Icons/pause_on.png"
                }
            },
            State {
                name: "hoveredPlayOff"
                PropertyChanges {
                    target: pauseButton
                    source: "Icons/play_glob_hover.png"
                }
            },
            State {
                name: "hoveredPlayOn"
                PropertyChanges {
                    target: pauseButton
                    source: "Icons/pause_hover.png"
                }
            }
        ]
    }
    background: Rectangle {
        id: zone
        color: "#202020"
    }
}

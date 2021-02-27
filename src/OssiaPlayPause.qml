import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtMultimedia 5.0
import QtQuick.Controls.Material 2.3

Button {
    hoverEnabled: true // Allows to specify a behavior when going over a button
    function stopClicked() {
        pauseButton.state = 'playOff';
    }
    function isConnected() {
        return (pauseButton.state !== '');
    }
    function isPaused() {
        return (pauseButton.state === 'hoveredPlayOff');
    }

    onHoveredChanged: {
        switch (pauseButton.state) {
            case 'hoveredPlayOff':
                pauseButton.state = 'playOff';
                break;
            case 'playOff':
                pauseButton.state = 'hoveredPlayOff';
                break;
            case 'play_on':
                pauseButton.state = 'hoveredPlayOn';
                break;
            case 'pauseOn':
                pauseButton.state = 'hoveredPlayOn';
                break;
            case 'hoveredPlayOn':
                pauseButton.state = 'pauseOn';
                break;
            default:
        }
    }
    onClicked: {
        switch (pauseButton.state) {
        case '':
            /* Connection to the websocket
              * socket is the id of the Websocket
              * instantiated in OssiaSkeleton
              */
            pauseButton.state = 'hoveredPlayOff';
            socket.active = !socket.active;
            break;
        case 'hoveredPlayOff':
            pauseButton.state = 'hoveredPlayOn';
            socket.sendTextMessage('{ "Message": "Play" }');
            //fonction pour modifier timeline
            break;
        case 'hoveredPlayOn':
            pauseButton.state = 'hoveredPlayOff';
            socket.sendTextMessage('{ "Message": "Pause" }');
            //fonction pour modifier timeline
            break;
        default:
        }
    }

    contentItem: Image {
        id: pauseButton
        sourceSize.width: 30
        sourceSize.height: 30
        source: "Icons/connection.svg"
        clip: true

        states: [
            State {
                name: "playOff"                           //In this state, the button the play symbol, so the timeline should be paused
                PropertyChanges {
                    target: pauseButton
                    source: "Icons/play_glob_off.svg"
                }
            },
            State {
                name: "pauseOn"                           //In this state, the button display the pause symbol, so the timeline should be playing
                PropertyChanges {
                    target: pauseButton
                    source: "Icons/pause_on.svg"
                }
            },
            State {
                name: "hoveredPlayOff"                    //In this state the mouse is on the button and the timeline is paused
                PropertyChanges {
                    target: pauseButton
                    source: "Icons/play_glob_hover"
                }
            },
            State {
                name: "hoveredPlayOn"                      //In this state the mouse is on the button and the timeline is playing
                PropertyChanges {
                    target: pauseButton
                    source: "Icons/pause_hover"
                }
            }
        ]
    }
    background: Rectangle {
        id: zone
        color: "#202020"
    }
}

import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtMultimedia 5.0
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

    onHoveredChanged: {
        switch (pauseButton.state) {
            case 'hoveredPlayOff':
                pauseButton.state = 'playDisplayed';
                break;
            case 'playDisplayed':
                pauseButton.state = 'hoveredPlayOff';
                break;
            case 'play_on':
                pauseButton.state = 'hoveredPlayOn';
                break;
            case 'pauseDisplayed':
                pauseButton.state = 'hoveredPlayOn';
                break;
            case 'hoveredPlayOn':
                pauseButton.state = 'pauseDisplayed';
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
            ossiaTimeline.updateTimeline('play');
            break;
        case 'hoveredPlayOn':
            pauseButton.state = 'hoveredPlayOff';
            socket.sendTextMessage('{ "Message": "Pause" }');
            ossiaTimeline.updateTimeline('pause');
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
                /* play symbol is displayed
                * "paused" is the scenario's state.
                */
                name: "playDisplayed"
                PropertyChanges {
                    target: pauseButton
                    source: "Icons/play_glob_off.svg"
                }
            },
            State {
                /* pause symbol is displayed
                * "playing" is the scenario's state.
                */
                name: "pauseDisplayed"
                PropertyChanges {
                    target: pauseButton
                    source: "Icons/pause_on.svg"
                }
            },
            State {
                name: "hoveredPlayOff"
                PropertyChanges {
                    target: pauseButton
                    source: "Icons/play_glob_hover"
                }
            },
            State {
                name: "hoveredPlayOn"
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

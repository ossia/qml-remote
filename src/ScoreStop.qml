import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtQuick.Controls.Material 2.3

Button {
    hoverEnabled: true
    onHoveredChanged: {
        if (stopButton.state === 'hoveredStop'
                || stopButton.state === 'stopOn') {
            stopButton.state = ''
        } else {
            stopButton.state = 'hoveredStop'
        }
    }
    onPressed: {
        stopButton.state = 'stopOn'
        if (playPause.isConnected()) {
            playPause.stopClicked()
        }
        socket.sendTextMessage('{ "Message": "Stop" }')
        ossiaTimeline.stopTimeline();
        ossiaControlSurface .clearListModel();
    }

    onReleased: stopButton.state = 'hoveredStop'

    contentItem: Image {
        id: stopButton
        sourceSize.width: 30
        sourceSize.height: 30
        clip: true
        source: "Icons/stop_off.png"
        states: [
            State {
                name: "stopOn"
                PropertyChanges {
                    target: stopButton
                    source: "Icons/stop_on.png"
                }
            },
            State {
                name: "hoveredStop"
                PropertyChanges {
                    target: stopButton
                    source: "Icons/stop_hover.png"
                }
            }
        ]
    }
    background: Rectangle {
        id: zone
        color: "#202020"
    }
}

/*
  * Stop button :
  * - at the top left of the interface with others buttons
  * - synchronize with score
  * - stop button pressed :
  *     - stop in score
  *     - play button displayed instead of pause button
  */

import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Controls.Material

import Variable.Global 1.0

Button {

    width: parent.width; height: parent.width
    padding: 0; topPadding: 0; bottomPadding: 0; leftPadding: 0; rightPadding: 0
    hoverEnabled: true

    // Allow to click on buttons and leave while pressing
    onHoveredChanged: {
        if (stopButton.state === 'stopOn') {
            stopButton.state = ''
        }
    }

    // Change the button color when it is pressed
    onPressed: stopButton.state = 'stopOn'

    // Specify the behavior of a button when it is clicked on
    onClicked: {
        stopButton.state = ''
        if (playPause.isConnected()) {
            playPause.stopClicked()
        }
        socket.sendTextMessage('{ "Message": "Stop" }')
        scoreTimeline.stopTimeline()
    }

    background: Rectangle { id: zone; color: Skin.darkGray }

    contentItem: Image {
        id: stopButton

        sourceSize { width: parent.width; height: parent.width }
        fillMode: Image.PreserveAspectFit
        clip: true
        source: "../Icons/stop_off.png"

        states: [
            State {
                name: "stopOn"

                PropertyChanges {
                    target: stopButton
                    source: "../Icons/stop_on.png"
                }
            },
            State {
                name: "hoveredStop"

                PropertyChanges {
                    target: stopButton
                    source: "../Icons/stop_hover.png"
                }
            }
        ]
    }
}

import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtQuick.Controls.Material 2.3

Button {
    width: parent.width
    height: parent.width
    hoverEnabled: true

    onHoveredChanged: {
        if (reinitializeButton.state === 'reintializeOn') {
            reinitializeButton.state = ''
        }
    }

    onPressed: {
        reinitializeButton.state = 'reintializeOn'
        if (playPause.isConnected()) {
            playPause.stopClicked()
        }
        socket.sendTextMessage('{ "Message": "Stop" }')
        //fonction pour arrêter la timeline et la remettre à zero
    }

    onReleased: {
        reinitializeButton.state = ''
    }
    contentItem: Image {
        id: reinitializeButton
        sourceSize.width: parent.width
        sourceSize.height: parent.width
        clip: true
        source: "../Icons/reinitialize_off.png"
        states: [
            State {
                name: "reintializeOn"
                PropertyChanges {
                    target: reinitializeButton
                    source: "../Icons/reinitialize_on.png"
                }
            },
            State {
                name: "hoveredReinitialize"
                PropertyChanges {
                    target: reinitializeButton
                    source: "../Icons/reinitialize_hover.png"
                }
            }
        ]
    }
    background: Rectangle {
        id: zone
        color: Skin.darkGray
    }
}

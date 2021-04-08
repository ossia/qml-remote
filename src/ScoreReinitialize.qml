import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtQuick.Controls.Material 2.3

Button {
    hoverEnabled: true
//    onHoveredChanged: {
//        if (reinitializeButton.state === 'hoveredReinitialize'
//                || reinitializeButton.state === 'reintializeOn') {
//            reinitializeButton.state = ''
//        } else {
//            reinitializeButton.state = 'hoveredReinitialize'
//        }
//    }

    onPressed: {
        reinitializeButton.state = 'reintializeOn'
        if (playPause.isConnected()){
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
        sourceSize.width: 30
        sourceSize.height: 30
        clip: true
        source: "Icons/reinitialize_off.png"
        states: [
            State {
                name: "reintializeOn"
                PropertyChanges {
                    target: reinitializeButton
                    source: "Icons/reinitialize_on.png"
                }
            },
            State {
                name: "hoveredReinitialize"
                PropertyChanges {
                    target: reinitializeButton
                    source: "Icons/reinitialize_hover.png"
                }
            }
        ]
    }
    background: Rectangle {
        id: zone
        color: "#202020"
    }
}

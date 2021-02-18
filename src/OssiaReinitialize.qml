import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtMultimedia 5.0
import QtQuick.Controls.Material 2.3

Button {
    hoverEnabled: true
    onHoveredChanged: {if (reinitializeButton.state === 'hoveredReinitialize') {reinitializeButton.state = ''} else {reinitializeButton.state = 'hoveredReinitialize'}}
    onPressed: {
        reinitializeButton.state = 'holdClickPause'
        socket.sendTextMessage('{ "Message": "Stop" }')
    }
    onReleased: {
        reinitializeButton.state = ''
    }
    contentItem:    Image{
        id: reinitializeButton
        sourceSize.width: 30
        sourceSize.height: 30
        clip: true
        source:"Icons/reinitialize_off.svg"
        states: [
                State {
                    name: "holdClickPause"
                    PropertyChanges { target: reinitializeButton; source: "Icons/reinitialize_on.svg" }
                },
            State {
                name: "hoveredReinitialize"
                PropertyChanges {target: reinitializeButton; source: "Icons/reinitialize_hover.svg"}
            }

            ]
    }
    background: Rectangle{
        id: zone
        color:"#202020"
    }
}

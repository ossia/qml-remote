import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtMultimedia 5.0
import QtQuick.Controls.Material 2.3

Button {
    hoverEnabled: true
    onHoveredChanged: {if (stopButton.state === 'hoveredStop' || stopButton.state === 'holdClickPause')
                            {stopButton.state = ''}
                       else
                            {stopButton.state = 'hoveredStop'}}
    onPressed: {
        stopButton.state = 'holdClickPause'
        socket.sendTextMessage('{ "Message": "Stop" }')
    }

    onReleased: stopButton.state = 'hoveredStop'

    contentItem:    Image{
        id: stopButton
        sourceSize.width: 30
        sourceSize.height: 30
        clip: true
        source:"Icons/stop_off.svg"
        states: [
                State {
                    name: "holdClickPause"
                    PropertyChanges { target: stopButton; source: "Icons/stop_on.svg" }
                },
                State {
                    name: "hoveredStop"
                    PropertyChanges { target: stopButton; source: "Icons/stop_hover.svg"}
                }

            ]
    }
    background: Rectangle{
        id: zone
        color:"#202020"
    }
}

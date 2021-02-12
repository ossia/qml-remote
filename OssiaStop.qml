import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtMultimedia 5.0
import QtQuick.Controls.Material 2.3

Button {
    onPressed: stopButton.state = 'holdClickPause'
    onReleased: stopButton.state = ''

    contentItem:    Image{
        id: stopButton
        anchors.fill: zone
        source:"Icons/stop_off.svg"
        states: [
                State {
                    name: "holdClickPause"
                    PropertyChanges { target: stopButton; source: "Icons/stop_on.svg" }
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

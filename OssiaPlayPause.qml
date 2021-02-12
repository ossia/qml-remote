import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtMultimedia 5.0
import QtQuick.Controls.Material 2.3


Button {
    onClicked: pauseButton.state == 'clicked'? pauseButton.state = "" : pauseButton.state = 'clicked';

    contentItem:    Image{
        id:pauseButton
        anchors.fill: zone
        source: "Icons/play_off.svg"
        states: [
                State {
                    name: "clicked"
                    PropertyChanges { target: pauseButton; source: "Icons/pause_on.svg" }
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

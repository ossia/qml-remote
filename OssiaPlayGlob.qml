import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtMultimedia 5.0
import QtQuick.Controls.Material 2.3


Button {
    onPressed: {
        playGlobButton.state = 'holdClickPause'

    }
    onReleased: {
        playGlobButton.state = ''
    }
    contentItem:     Image{
        id: playGlobButton
        anchors.fill: zone
        source:"Icons/play_glob_off.svg"
        states: [
                State {
                    name: "holdClickPause"
                    PropertyChanges { target: playGlobButton; source: "Icons/play_glob_on.svg" }
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

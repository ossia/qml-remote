import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtMultimedia 5.0
import QtQuick.Controls.Material 2.3


Button {
    hoverEnabled: true
    onHoveredChanged: {if (playGlobButton.state === 'hoveredPlayGlob' || playGlobButton.state === 'holdClickPause')
                            {playGlobButton.state = ''}
                       else
                            {playGlobButton.state = 'hoveredPlayGlob'}}
    onPressed: {
        playGlobButton.state = 'holdClickPause'

    }
    onReleased: {
        playGlobButton.state = 'hoveredPlayGlob'
    }
    contentItem:     Image{
        id: playGlobButton
        sourceSize.width: 30
        sourceSize.height: 30
        clip: true
        source:"Icons/play_glob_off.svg"
        states: [
                State {
                    name: "holdClickPause"
                    PropertyChanges { target: playGlobButton; source: "Icons/play_glob_on.svg" }
                },
                State {
                    name: "hoveredPlayGlob"
                    PropertyChanges { target: playGlobButton; source: "Icons/play_glob_hover.svg" }
            }

            ]
    }
    background: Rectangle{
        id: zone
        color:"#202020"
    }
}

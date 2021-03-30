import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtMultimedia 5.0
import QtQuick.Controls.Material 2.3

Button {
    function playClicked(){
        if (playGlobButton.state === '' || !playPause.isPaused())
            playGlobButton.state = 'pausedPlayGlob'
        else if (!playPause.isConnected())
            playGlobButton.state = ''
        else
            playGlobButton.state ='disabledPlayGlob'
    }

    function stopClicked(){
        playGlobButton.state = 'play_off'
    }


    hoverEnabled: true
    onHoveredChanged: {if (playGlobButton.state === 'hoveredPlayGlob' || playGlobButton.state === 'holdClickPause')
        {playGlobButton.state = ''}
        else if (playGlobButton.state === 'pausedPlayGlob')
        {playGlobButton.state = 'pausedPlayGlob'}
        else if (playGlobButton.state === 'disabledPlayGlob')
        {playGlobButton.state = 'disabledPlayGlob'}
        else if (playGlobButton.state === 'pausedHover')
        {playGlobButton.state = 'pausedOn'}
        else if (playGlobButton.state === 'pausedOn')
        {playGlobButton.state = 'pausedHover'}
        else
        {playGlobButton.state = 'hoveredPlayGlob'}}
    onPressed: {
        if (playGlobButton.state === 'pausedPlayGlob')
        {playGlobButton.state = 'pausedPlayGlob'}
        else if (playGlobButton.state === 'disabledPlayGlob')
        {playGlobButton.state = 'disabledPlayGlob'}
        else if (playGlobButton.state === 'pausedHover')
        {playGlobButton.state = 'pausedHover'}
        else
        {playGlobButton.state = 'holdClickPause'}

    }
    onReleased: {
        if (playGlobButton.state === 'pausedPlayGlob')
        {playGlobButton.state = 'pausedPlayGlob'}
        else if (playGlobButton.state === 'disabledPlayGlob')
        {playGlobButton.state = 'disabledPlayGlob'}
        else if (playPause.isDisabled() && playGlobButton.state === 'hoveredPlayGlob')
        {playGlobButton.state = 'pausedHover'}
        else if (playPause.isDisabled() && playGlobButton.state === 'pausedHover')
        {playGlobButton.state = 'hoveredPlayGlob'}
        else
        {
            playGlobButton.state = 'pausedHover'
            playPause.playGlobClicked()

        }
    }
    contentItem:
        Image{
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
            },
            State {
                name: "pausedPlayGlob"
                PropertyChanges { target: playGlobButton; source: "Icons/pause_disabled.svg" }
            },
            State {
                name: 'pausedHover'
                PropertyChanges { target: playGlobButton; source: "Icons/pause_hover.svg"}
            },
            State {
                name: 'pausedOn'
                PropertyChanges { target: playGlobButton; source: "Icons/pause_on.svg"}
            },
            State {
                name: 'pausedOff'
                PropertyChanges { target: playGlobButton; source: "Icons/pause_off.svg"}
            },
            State {
                name: 'disabledPlayGlob'
                PropertyChanges {target: playGlobButton; source: "Icons/play_glob_disabled.svg"}
            }

        ]
    }
    background: Rectangle{
        id: zone
        color:"#202020"
    }
}

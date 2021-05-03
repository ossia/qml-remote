import QtQuick 2.12
import QtQuick.Window 2.12
import QtWebSockets 1.0
//import "content"
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import Qt.labs.settings 1.0

Item {
    id: window
    anchors.fill: parent
    Settings {
        id:settings
        property string  adresse_ip: "localhost"
    }

    ScoreWebSocket{
        id: socket
    }

    ScoreAdresseIp{
        id: adresseip
        anchors.top: parent.top
        anchors.left: parent.left
        //height: window / 10
        signal playPauseStopMessageReceived(var n)
    }
    ScorePlayPauseStop {
        id: scorePlayPauseStop
        anchors.top:  adresseip.bottom
        anchors.left: parent.left
        height: window / 5
        signal playPauseStopMessageReceived(var n)
        signal scorePlayPauseStopMessageReceived(var n)
        signal connectedToScore()
        signal disconnectedFromScore()
    }
    ScoreVolume {
        id: scoreVolume
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 5
        signal intervalMessageReceived(var n)
        signal intervalsMessageReceived(var n)

    }
    ScoreSpeed {
        id: scoreSpeed
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.rightMargin: 5
        signal intervalMessageReceived(var n)
        signal intervalsMessageReceived(var n)
    }
    TimeSet {
        id: scoreTimeSet
        anchors.top: scoreVolume.bottom
        anchors.topMargin: 5
        anchors.left: scorePlayPauseStop.right
        anchors.right: window.right //c'était ça arthur
        anchors.bottom: scorePlayPauseStop.bottom
        width: parent.width
        height: window.height / 5
        signal triggerMessageReceived(var n)
        signal intervalMessageReceived(var n)
        signal intervalsMessageReceived(var n)

    }
    ScoreControlSurfaces {
        id: scoreControlSurfaces
        anchors.top: scorePlayPauseStop.bottom
        anchors.bottom: scoreTimeline.top
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height
        signal controlSurfacesMessageReceived(var n)
    }
    ScoreTimeline {
        id: scoreTimeline
        anchors.bottom: parent.bottom
        signal intervalsMessageReceived(var n)
    }
}

import QtQuick 2.12
import QtQuick.Window 2.12
import QtWebSockets 1.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import Qt.labs.settings 1.0

import "../WebSocket"
import "../IpAdress"
import "../PlayPauseStop"
import "../Speed"
import "../TimeSet"
import "../ControlSurface"
import "../Timeline"


Item {
    id: window
    anchors.fill: parent

    // A field to save the IP adress
    Settings {
        id: settings
        property string ip_adress: "localhost"
    }

    // Creating the websocket
    ScoreWebSocket {
        id: socket
    }

    Column{
        id: scoreButtons
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width / 15
        //height: parent.height /5

        // Creating the IP adress button object
        ScoreIpAdress {
            id: ipAdress
            anchors.left: parent.left
            anchors.right: parent.right
            signal playPauseStopMessageReceived(var n)
        }

        // Creating play, pause and stop button objects
        ScorePlayPauseStop {
            id: scorePlayPauseStop
            anchors.left: parent.left
            anchors.right: parent.right
            //height: window / 5
            signal playPauseStopMessageReceived(var n)
            signal scorePlayPauseStopMessageReceived(var n)
            signal connectedToScore
            signal disconnectedFromScore
        }
    }


    /*
    // TODO : Creating the volume slider object
    ScoreVolume {
        id: scoreVolume
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 5
        signal intervalMessageReceived(var n)
        signal intervalsMessageReceived(var n)

    }*/

    // Creating the speed slider object
    ScoreSpeed {
        id: scoreSpeed
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.rightMargin: 5
        signal intervalMessageReceived(var n)
        signal intervalsMessageReceived(var n)
    }

    // Creating the timeSet object : trigger buttons and interval speed sliders
    TimeSet {
        id: scoreTimeSet
        anchors.top: scoreSpeed.bottom
        anchors.topMargin: 5
        anchors.left: scoreButtons.right
        anchors.right: window.right
        anchors.bottom: scoreButtons.bottom
        width: parent.width
        height: window.height / 5
        signal triggerMessageReceived(var n)
        signal intervalMessageReceived(var n)
        signal intervalsMessageReceived(var n)
    }

    // Creating the control surface list
    ScoreControlSurfaceList {
        id: scoreControlSurfaceList
        anchors.top: scoreButtons.bottom
        anchors.bottom: scoreTimeline.top
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height
        signal controlSurfacesMessageReceived(var n)
    }

    // Creating the timeline slider object
    ScoreTimeline {
        id: scoreTimeline
        anchors.bottom: parent.bottom
        signal intervalsMessageReceived(var n)
    }
}

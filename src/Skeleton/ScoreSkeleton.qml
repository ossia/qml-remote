import QtQuick 2.12
import QtQuick.Window 2.12
import QtWebSockets 1.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import Qt.labs.settings 1.0

import "qrc:/WebSocket"
import "qrc:/IpAdress"
import "qrc:/PlayPauseStop"
import "qrc:/Speed"
import "qrc:/ControlSurface"
import "qrc:/Timeline"
import "qrc:/Trigger"
import "qrc:/Speeds"

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

    // Creating the button list : Ip, (dis)connection, play, pause, stop
    Column{
        id: scoreButtons
        anchors.top: parent.top
        anchors.left: parent.left
        width: 20 + ( ( 0.3 * parent.width + 0.7 * parent.height ) / 20 )

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

    // Creating the trigger list
    ScoreTriggers {
        id: scoreTriggers
        anchors.margins: 10
        anchors.left: scoreButtons.right
        anchors.top: parent.top
        anchors.right: scoreSpeed.left
        anchors.bottom: scoreButtons.bottom
        //anchors.right: scoreSpeeds.left
        //anchors.rightMargin: 5
        signal triggerMessageReceived(var n)
    }

    ScoreSpeeds {
        id: scoreSpeeds
        anchors.topMargin: 10
        anchors.rightMargin: 10
        anchors.right: parent.right
        anchors.bottom: scoreButtons.bottom
        anchors.top: scoreSpeed.bottom
        anchors.left: scoreSpeed.left
        signal intervalMessageReceived(var n)
        signal intervalsMessageReceived(var n)
    }

    // Creating the speed slider object
    ScoreSpeed {
        id: scoreSpeed
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.rightMargin: 10
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

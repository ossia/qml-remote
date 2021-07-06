/*
  * Skeleton of the app all objects which are displayed
  * - Buttons (top left) :
  *     - Play, Pause, stop
  *     - IP, connection, disconnection
  * - list of triggers (top left)
  * - main speed (top right)
  * - list of speeds (top right)
  * - list of control surface (in the middle)
  * - time line (bottom)
  */

import QtQuick 2.12
import QtQuick.Window 2.12
import QtWebSockets 1.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import Qt.labs.settings 1.0

import Variable.Global 1.0

import "qrc:/WebSocket"
import "qrc:/IpAdress"
import "qrc:/PlayPauseStop"
import "qrc:/Trigger"
import "qrc:/Speed"
import "qrc:/Speeds"
import "qrc:/HideButton"
import "qrc:/ControlSurface"
import "qrc:/Timeline"

Item {
    id: window
    anchors.fill: parent

    // A field to save the IP adress
    Settings {
        id: settings
        property string ip_adress: "127.0.0.1"
    }

    // Creating the websocket
    ScoreWebSocket {
        id: socket
    }

    // Creating the IP adress button object
    ScoreIpAdress {
        id: ipAdress
        anchors.top: parent.top
        anchors.left: parent.left
        width: 20 + ( ( 0.3 * window.width + 0.7 * window.height ) / 20 )
        signal playPauseStopMessageReceived(var n)
    }

    // Creating play, pause and stop button objects
    ScorePlayPauseStop {
        id: scorePlayPauseStop
        anchors.left: ipAdress.left
        anchors.top: ipAdress.bottom
        height: 2 * this.width
        width: ipAdress.width
        signal playPauseStopMessageReceived(var n)
        signal scorePlayPauseStopMessageReceived(var n)
        signal connectedToScore()
        signal disconnectedFromScore()
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
        anchors.margins: 5
        anchors.left: ipAdress.right
        anchors.top: parent.top
        anchors.right: scoreSpeed.left
        anchors.bottom: scorePlayPauseStop.bottom
        signal triggerMessageReceived(var n)
        signal clearTriggerList()
    }

    // Creating the button to hide the top panel (triggers, speeds)
    ScoreHideButton {
        id: scoreHideButton
        anchors.top: parent.top
        anchors.bottom: scoreSpeed.bottom
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.topMargin: 5
        width: window.width <= 500 ? 20 : 30
    }

    // Creating the speed list
    ScoreSpeeds {
        id: scoreSpeeds
        anchors.topMargin: 5
        anchors.rightMargin: 5
        anchors.right: parent.right
        anchors.bottom: scorePlayPauseStop.bottom
        anchors.top: scoreSpeed.bottom
        anchors.left: scoreSpeed.left
        signal intervalMessageReceived(var n)
        signal intervalsMessageReceived(var n)
        signal clearSpeedList()
    }

    // Creating the main scenario speed slider object
    ScoreSpeed {
        id: scoreSpeed
        anchors.right: scoreHideButton.left
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.rightMargin: 5
        signal intervalMessageReceived(var n)
        signal intervalsMessageReceived(var n)
    }

    // Creating the control surface list
    ScoreControlSurfaceList {
        id: scoreControlSurfaceList
        anchors.top: scorePlayPauseStop.bottom
        anchors.bottom: scoreTimeline.top
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.right: parent.right
        signal controlSurfacesMessageReceived(var n)
        signal clearControlSurfaceList()
    }

    // Creating the timeline slider object
    ScoreTimeline {
        id: scoreTimeline
        anchors.bottom: parent.bottom
        signal intervalsMessageReceived(var n)
    }

    states: [
        // State in which the top panel (triggers, speeds) is hidden
        State {
            name: "hidden"

            PropertyChanges {
                target: ipAdress
                width: 1.4 * scoreHideButton.height
            }

            PropertyChanges {
                target: scorePlayPauseStop
                anchors.top: window.top
                anchors.left: window.left
                width: 2 * ipAdress.width
                height: ipAdress.width
            }

            PropertyChanges {
                target: scoreTriggers
                anchors.margins: 5
                anchors.left: scorePlayPauseStop.right
                anchors.top: parent.top
                anchors.right: scoreSpeed.left
                anchors.bottom: scorePlayPauseStop.bottom
            }

            PropertyChanges {
                target: scoreControlSurfaceList
                anchors.top: scoreHideButton.bottom
            }
        }
    ]

    // Called when the remote is disconnected from score
    function disconnect() {
        // Clear trigger, speed, control surface... lists
        scoreTriggers.clearTriggerList()
        scoreSpeeds.clearSpeedList()
        scoreControlSurfaceList.clearControlSurfaceList()
        // Reset timeline
        scoreTimeline.stopTimeline()

    }
}

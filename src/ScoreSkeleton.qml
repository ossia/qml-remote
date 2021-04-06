import QtQuick 2.12
import QtQuick.Window 2.12
import QtWebSockets 1.0
//import "content"
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4

Item {
    id: window
    anchors.fill: parent

    WebSocket {
        id: socket
        url: "ws://localhost:10212"
        //url: "ws://192.168.60.25:10212"

        onTextMessageReceived: {
            try {
                console.log("-----------------------------------------");
                console.log(message);
                console.log("-----------------------------------------");

                var jsonObject = JSON.parse(message);
                if (jsonObject.Intervals) {
                    /* Supposing the timeline receives the progress
                    * of all the intervals inclunding itself
                    */
                    scoreTimeline.intervalsMessageReceived(jsonObject);
                    scoreVolume.intervalsMessageReceived(jsonObject);
                    scoreSpeed.intervalsMessageReceived(jsonObject);

                } else {
                    var typeOfMessage = jsonObject.Message;
                    if (typeOfMessage === "TriggerRemoved"
                            || typeOfMessage === "TriggerAdded") {

                        scoreTimeSet.triggerMessageReceived(jsonObject);

                    } else if (typeOfMessage === "IntervalRemoved"
                               || typeOfMessage === "IntervalAdded") {
                        scoreSpeed.intervalMessageReceived(jsonObject);
                        scoreTimeSet.intervalMessageReceived(jsonObject);
                        scoreVolume.intervalMessageReceived(jsonObject);
                    } else if (typeOfMessage === "Play" || typeOfMessage === "Pause"
                               || typeOfMessage === "Restart") {
                        // (Play Pause Stop) are temporary. while waiting for the new version of score
                        scorePlayPauseStop.playPauseStopMessageReceived(jsonObject);

                    } else if (typeOfMessage === "ControlSurfaceRemoved"
                               || typeOfMessage === "ControlSurfaceAdded") {
                        //handling the ControlSurface messages
                        scoreControlSurface.controlSurfaceMessageReceived(
                                    jsonObject);

                    }

                }
                //TODO: hundle volume and the main speed messages
            } catch (error) {

            }
        }
        onStatusChanged: {
            switch (socket.status) {
            case WebSocket.Error:
                console.log("Error: " + socket.errorString);
                break;
            case WebSocket.Open:
                socket.sendTextMessage("Hello World");
                break;
            case WebSocket.Closed:
                console.log("The webSocket communication has been closed")
                break;
            default:
            }
        }
        active: false
    }
    ScorePlayPauseStop {
        id: scorePlayPauseStop
        anchors.left: parent.left
        height: window / 5
        signal playPauseStopMessageReceived(var n)
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
    }
    ScoreControlSurfaces {
        id: scoreControlSurface
        anchors.top: scorePlayPauseStop.bottom
        anchors.bottom: scoreTimeline.top
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height
        //anchors.margins: 5
        //height: window.height / 1.5
        signal controlSurfaceMessageReceived(var n)
    }
    ScoreTimeline {
        id: scoreTimeline
        anchors.bottom: parent.bottom
        signal intervalsMessageReceived(var n)
    }
}

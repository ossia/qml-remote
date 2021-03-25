import QtQuick 2.12
import QtQuick.Window 2.12
import QtWebSockets 1.0
//import "content"
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Styles 1.4

Item {
    id: window
    anchors.fill: parent

    WebSocket {
        id: socket
        url: "ws://localhost:10212"
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
                    ossiaTimeline.intervalsMessageReceived(jsonObject);
                } else {
                    var typeOfMessage = jsonObject.Message;
                    if (typeOfMessage === "TriggerRemoved"
                            || typeOfMessage === "TriggerAdded") {

                        ossiaTimeSet.triggerMessageReceived(jsonObject);

                    } else if (typeOfMessage === "IntervalRemoved"
                               || typeOfMessage === "IntervalAdded") {
                        ossiaSpeed.intervalMessageReceived(jsonObject);
                        ossiaTimeSet.intervalMessageReceived(jsonObject);


                    } else if (typeOfMessage === "Play" || typeOfMessage === "Pause"
                               || typeOfMessage === "Restart") {
                        // (Play Pause Stop) are temporary. while waiting for the new version of score
                        ossiaPlayPauseStop.playPauseStopMessageReceived(jsonObject);

                    } else if (typeOfMessage === "ControlSurfaceRemoved"
                               || typeOfMessage === "ControlSurfaceAdded") {
                        //handling the ControlSurface messages
                        ossiaControlSurface.controlSurfaceMessageReceived(
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
    OssiaPlayPauseStop {
        id: ossiaPlayPauseStop
        anchors.left: parent.left
        height: window / 5
        signal playPauseStopMessageReceived(var n)
    }
    OssiaVolume {
        id: ossiaVolume
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 5
    }
    OssiaSpeed {
        id: ossiaSpeed
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.rightMargin: 5
        signal intervalMessageReceived(var n)
    }
    TimeSet {
        id: ossiaTimeSet
        anchors.top: ossiaVolume.bottom
        anchors.topMargin: 5
        anchors.left: ossiaPlayPauseStop.right
        anchors.right: window.right //c'était ça arthur
        anchors.bottom: ossiaPlayPauseStop.bottom
        width: parent.width
        height: window.height / 5
        signal triggerMessageReceived(var n)
        signal intervalMessageReceived(var n)
    }
    OssiaControlSurfaces {
        id: ossiaControlSurface
        anchors.top: ossiaPlayPauseStop.bottom
        anchors.bottom: ossiaTimeline.top
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height
        //anchors.margins: 5
        //height: window.height / 1.5
        signal controlSurfaceMessageReceived(var n)
    }
    OssiaTimeline {
        id: ossiaTimeline
        anchors.bottom: parent.bottom
        signal intervalsMessageReceived(var n)
    }
}

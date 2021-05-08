import QtWebSockets 1.0

WebSocket {
    id: socket
    url: "ws://" + settings.ip_adress + ":10212"

    onTextMessageReceived: {
        try {
            /* Print messages send by score
            console.log("-----------------------------------------");
            console.log(message);
            console.log("-----------------------------------------");
            */
            var jsonObject = JSON.parse(message);
            if (jsonObject.Intervals) {
                /* Supposing the timeline receives the progress
                * of all the intervals inclunding itself
                */
                scoreTimeline.intervalsMessageReceived(jsonObject);
                // scoreVolume.intervalsMessageReceived(jsonObject);
                scoreSpeed.intervalsMessageReceived(jsonObject);
                scoreTimeSet.intervalsMessageReceived(jsonObject);

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
                           || typeOfMessage === "ControlSurfaceAdded"
                           || typeOfMessage === "ControlSurfaceControl") {
                    //handling the ControlSurface messages
                    scoreControlSurfaceList.controlSurfacesMessageReceived(
                                jsonObject);

                } else if (typeOfMessage === "IntervalPaused" || typeOfMessage === "IntervalResumed"){
                    scorePlayPauseStop.scorePlayPauseStopMessageReceived(jsonObject);
                    //playPause.clicked();
                }
                else{

                }

            }
            // TODO: handle volume
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
            ipAdress.connected();
            scorePlayPauseStop.connectedToScore();
            break;
        case WebSocket.Closed:
            console.log("The webSocket communication has been closed")
            ipAdress.disconnected();
            scorePlayPauseStop.disconnectedFromScore();
            break;
        default:
        }
    }
    active: false
}

import QtWebSockets 1.0

WebSocket {
    id: socket
    url: "ws://" + settings.ip_adress + ":10212"

    // Handling message from score
    onTextMessageReceived: {
        try {
            // Print messages send by score
            console.log("-----------------------------------------");
            console.log(message);
            console.log("-----------------------------------------");

            var jsonObject = JSON.parse(message)
            if (jsonObject.Intervals) {


                /* Supposing the timeline receives the progress
                * of all the intervals inclunding itself
                */
                scoreTimeline.intervalsMessageReceived(jsonObject)
                // scoreVolume.intervalsMessageReceived(jsonObject);
                scoreSpeed.intervalsMessageReceived(jsonObject)
                scoreSpeeds.intervalsMessageReceived(jsonObject)
            } else {
                var typeOfMessage = jsonObject.Message
                if (typeOfMessage === "TriggerRemoved"
                        || typeOfMessage === "TriggerAdded") {
                    // Handling messages about triggers
                    scoreTriggers.triggerMessageReceived(jsonObject)
                } else if (typeOfMessage === "IntervalRemoved"
                           || typeOfMessage === "IntervalAdded") {
                    // Handling messages about interval speeds
                    scoreSpeed.intervalMessageReceived(jsonObject)
                    scoreSpeeds.intervalMessageReceived(jsonObject)
                    scoreVolume.intervalMessageReceived(jsonObject)
                } else if (typeOfMessage === "Play" || typeOfMessage === "Pause"
                           || typeOfMessage === "Restart") {
                    // Handling messages about play, pause and stop
                    scorePlayPauseStop.playPauseStopMessageReceived(jsonObject)
                } else if (typeOfMessage === "ControlSurfaceRemoved"
                           || typeOfMessage === "ControlSurfaceAdded"
                           || typeOfMessage === "ControlSurfaceControl") {
                    // Handling  messages about control surfaces
                    scoreControlSurfaceList.controlSurfacesMessageReceived(
                                jsonObject)
                } else if (typeOfMessage === "IntervalPaused"
                           || typeOfMessage === "IntervalResumed") {
                    // Handling messages about play, pause and stop
                    scorePlayPauseStop.scorePlayPauseStopMessageReceived(
                                jsonObject)
                } else {

                }
            }
            // TODO: handle volume
        } catch (error) {

        }
    }

    // Dealing with message from the remote control
    onStatusChanged: {
        switch (socket.status) {
        case WebSocket.Error:
            console.log("Error: " + socket.errorString)
            break
        case WebSocket.Open:
            socket.sendTextMessage("Hello World")
            ipAdress.connected()
            scorePlayPauseStop.connectedToScore()
            break
        case WebSocket.Closed:
            console.log("The webSocket communication has been closed")
            ipAdress.disconnected()
            scorePlayPauseStop.disconnectedFromScore()
            break
        default:

        }
    }
    active: false
}

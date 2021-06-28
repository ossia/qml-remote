/*
  * WebSocket object :
  * - call some remote functions according to the socket state
  * - handle messages from score and call fonctions of the
  * correspondings objects
  */

import QtWebSockets 1.0

WebSocket {
    id: socket
    url: "ws://" + settings.ip_adress + ":10212"

    // Handling message from score
    onTextMessageReceived: {
        try {
            // Print messages send by score
            if(g_debugMessagesEnabled) {
                console.log("-----------------------------------------");
                console.log(message);
                console.log("-----------------------------------------");
            }

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

    // Calling remote functions according to the socket state
    onStatusChanged: {
        switch (socket.status) {
        case WebSocket.Error:
            break
        case WebSocket.Open:
            ipAdress.connected()
            scorePlayPauseStop.connectedToScore()
            break
        case WebSocket.Closed:
            window.state = ""
            ipAdress.disconnected()
            scorePlayPauseStop.disconnectedFromScore()
            break
        default:

        }
    }
    active: false
}

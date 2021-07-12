/*
  * WebSocket object :
  * - call some remote functions according to the socket state
  * - handle messages from score and call functions of the
  * corresponding objects
  */

import QtWebSockets 1.0

WebSocket {
    id: socket

    url: "ws://" + settings.ip_address + ":10212"
    active: false

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
            var typeOfMessage = jsonObject.Message
            if (jsonObject.Intervals) {
                // Supposing the timeline receives the progress
                // of all the intervals including itself
                scoreTimeline.intervalsMessageReceived(jsonObject)
                scoreSpeed.intervalsMessageReceived(jsonObject)
                scoreSpeeds.intervalsMessageReceived(jsonObject)
            } else {
                switch (true) {
                case (typeOfMessage === "TriggerRemoved" || typeOfMessage === "TriggerAdded"):
                    // Handling messages about triggers
                    scoreTriggers.triggerMessageReceived(jsonObject)
                    break

                case (typeOfMessage === "IntervalRemoved" || typeOfMessage === "IntervalAdded"):
                    // Handling messages about interval speeds
                    scoreSpeed.intervalMessageReceived(jsonObject)
                    scoreSpeeds.intervalMessageReceived(jsonObject)
                    break

                case (typeOfMessage === "Play" || typeOfMessage === "Pause" || typeOfMessage === "Restart"):
                    // Handling messages about play, pause and stop
                    scorePlayPauseStop.playPauseStopMessageReceived(jsonObject)
                    break

                case (typeOfMessage === "ControlSurfaceRemoved" || typeOfMessage === "ControlSurfaceAdded" || typeOfMessage === "ControlSurfaceControl"):
                    // Handling  messages about control surfaces
                    scoreControlSurfaceList.controlSurfacesMessageReceived(jsonObject)
                    break

                case (typeOfMessage === "IntervalPaused" || typeOfMessage === "IntervalResumed"):
                    // Handling messages about play, pause and stop
                    scorePlayPauseStop.scorePlayPauseStopMessageReceived(jsonObject)
                    break

                default:

                }
            }
        } catch (error) { }
    }

    // Calling remote functions according to the socket state
    onStatusChanged: {
        switch (socket.status) {
        case WebSocket.Error:
            break

        case WebSocket.Open:
            ipAddress.connected()
            scorePlayPauseStop.connectedToScore()
            break

        case WebSocket.Closed:
            window.state = ""
            ipAddress.disconnected()
            scorePlayPauseStop.disconnectedFromScore()
            break

        default:

        }
    }
}

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
            console.log(message)
            if (message === '"Message""DeviceTree""Nodes"{}') {
                messageBox.text = messageBox.text
                        + "\n      Received message vc traitement: " + message // nop
            }

            var jsonObject = JSON.parse(message)
            var aString = jsonObject.message
            messageBox.text = messageBox.text
                    + "\n       Received message vc traitement: " + aString
            console.log("Path: \n" + jsonObject.Path[0])
            name_name.text += "\n" + aString + "\n K " + jsonObject.Path[0]
            if (aString !== "TriggerRemoved") {
                walo.insert(0, {
                                "name": walo.a.toString(),
                                "color": "#696969",
                                "jsonObj": jsonObject
                            })
                walo.a += 1
            } else if (aString === "TriggerRemoved") {
                /* === returns true if both operands are of the same type
                 * and contain the same value
                 */
                walo.get(0).color = "#dcdcdc"
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
                    messageBox.text += "\n  Socket closed";
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
    }
    OssiaVolume {
        id: ossiaVolume
        anchors.horizontalCenter: parent.horizontalCenter
    }
    OssiaSpeed {
        id: ossiaSpeed
        anchors.right: parent.right
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
    }
    OssiaControlSurfaces {
        id: ossiaControlSurface
        anchors.top: ossiaPlayPauseStop.bottom
        anchors.bottom: ossiaTimeLine.top
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height
        //anchors.margins: 5
        //height: window.height/1.5
    }
    OssiaTimeLine {
        id: ossiaTimeLine
        anchors.bottom: parent.bottom

    }
}

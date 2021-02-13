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
        url:"ws://localhost:10212"
        onTextMessageReceived: {
        console.log(message);
            if(message === '"Message""DeviceTree""Nodes"{}')
                 messageBox.text = messageBox.text + "\n      Received message vc traitement: " + message;//do nothige
                   var jsonObject = JSON.parse(message);
                   var aString = jsonObject.message;
              messageBox.text = messageBox.text + "\n               Received message vc traitement: " + aString;
            console.log("Path: \n" + jsonObject.Path[0]);
              name_name.text += "\n" + aString + "\n K "+ jsonObject.Path[0];
              if( aString !== "TriggerRemoved"){
              walo.insert(0,{name:walo.a.toString(), color:"#696969",jsonObj:jsonObject})
                            walo.a+=1;
              }
              else if (aString ==="TriggerRemoved"){
                walo.get(0).color = "#dcdcdc";
              }
        }
        onStatusChanged: if (socket.status == WebSocket.Error) {
                             console.log("Error: " + socket.errorString)
                         } else if (socket.status == WebSocket.Open) {
                             socket.sendTextMessage("Hello World")
                         } else if (socket.status == WebSocket.Closed) {
                             messageBox.text += "\n  Socket closed"
                         }
        active: false
    }

    OssiaVolume{
        id: ossiaVolume
        anchors.horizontalCenter: parent.horizontalCenter
    }
    OssiaSpeed{
        id: ossiaSpeed
        anchors.right: parent.right
    }
    TimeSet{
        id: ossiaTimeSet
        anchors.top: ossiaVolume.bottom
        anchors.topMargin: 5
        width: parent.width
    }
    /*
    OssiaControlSurfaces{
        anchors.top: ossiaTimeSet.bottom
        anchors.topMargin: 5

    }
    */
    OssiaTimeLine{
        anchors.bottom: parent.bottom
    }
}

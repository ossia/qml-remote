import QtQuick 2.12
import QtQuick.Window 2.12
import QtWebSockets 1.0
//import "content"
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Styles 1.4

Window {
    id:wind
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")
    color: "grey"
    //ColorAnimation on color { to: "yellow"; duration: 10000 }
    Text {
        anchors.fill:parent
        id: myText
        font.family: "Helvetica"
        font.pointSize: 50
    }
    Rectangle {
        id: up
        width:  150
        height: 100
        color: "orange"
        Text {
            id: name_name
            text:socket.status == WebSocket.Open ? qsTr("Sending...") : qsTr("Welcome!")
        }
    }
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

    Button {
        id: start
        text: qsTr("Connexion")
        x:200
        onClicked: {
            if(text === "Connexion"){
                socket.active = !socket.active
                text = qsTr("Start");
            }
            else  if (text === "Start"){
                socket.sendTextMessage('{ "Message": "Pause" }');
                text = qsTr("Pause");
            }else if (text === "Pause"){
                socket.sendTextMessage('{ "Message": "Play" }');

                text = qsTr("Start");
            }
        }
    }

    Button {
        text: qsTr("restart ")
        x:350

        onClicked: {
            socket.sendTextMessage('{ "Message": "Stop" }');
            start.text = qsTr("Start");
        }
    }
    Button {
        text: qsTr("rsend vitesse")
        x:350
        y:100

        onClicked: {
            socket.sendTextMessage('{"Message": "Transport","Millionds": 40000}');
            console.log("Trying to send message for Transport\n");
        }
    }
    Text {
        x:10
        y:10
        id: messageBox
        text: socket.status == WebSocket.Open ? qsTr("Sending...") : qsTr("Welcome!")
        anchors.centerIn: parent
    }
    Slider {
        anchors.right: parent.right
        //maximumValue: 600.0
        from: -120.0
        value: 68
        to: 600.0
        orientation: Qt.Horizontal
        Layout.fillWidth: true
        Layout.fillHeight: true
        live: false
        snapMode: SnapAlways
        Text {
            id: slider
            anchors.top: parent.top - 1
            anchors.right:(parent.right + parent.left)/2
            text: qsTr("MonSLider  ")
        }
        onMoved: {
            slider.text = qsTr(value.toString());
            socket.sendTextMessage('{"Message": "Transport","Milliseconds": 2000}'+value.toString()+ '}');

            /*socket.sendTextMessage(' {    "Message": "IntervalSpeed", "Path": "[{"ObjectName":"Scenario::ScenarioDocumentModel","ObjectId":1},{"ObjectName":"Scenario::BaseScenario","ObjectId":0},{"ObjectName":"Scenario::IntervalModel","ObjectId":0},{"ObjectName":"Scenario","ObjectId":1},{"ObjectName":"Scenario::TimeSyncModel","ObjectId":1}]",
              "Speed": '+value.toString()+ '}');*/
            console.log(value.toString());
        }
    }
    ListView{
        y:300
        width: 600;height: 200
        orientation: ListView.Horizontal

        model:ListModel{
            id:walo
            property int a:1
        }
        delegate: Rectangle{
            color: model.color
            border.color : "black"
            radius: 10
            property var jsonObj;//stockage du message json responsable de sa creaction
            width: 200;height: 200
            Text {
                anchors.centerIn: parent
                //text: model.name
                text:model.jsonObj.Message + " " + model.name.toString();

            }
        }
    }

}

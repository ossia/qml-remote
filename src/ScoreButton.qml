import QtQuick 2.0
import QtQuick.Controls 2.15


Button{
    property string buttonName: "buttonName"
    property string buttonPath: "buttonPath"
    property string buttonId: "buttonId"



    contentItem: Text {
         text: buttonName
         color: "#ffffff"
         horizontalAlignment: Text.AlignHCenter
         verticalAlignment: Text.AlignVCenter
         elide: Text.ElideRight
     }

     background: Rectangle {
         implicitWidth: window.width/10
         implicitHeight: window.width/10
         color: "#303030"
         radius: 10
     }

    onClicked: {
        console.log("hhhhhhhhhhhhhhhhhhhhhhhhhhh")
        console.log('{ "Message": "ControlSurface","Path":'.concat(button.buttonPath,
                                                                   ', "id":',button.buttonId, ', "Value": {"Bool":true}}'))
        socket.sendTextMessage('{ "Message": "ControlSurface","Path":'.concat(button.buttonPath,
                                ', "id":',button.buttonId, ', "Value": {"Impulse":true}}'))
    }
}

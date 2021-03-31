import QtQuick 2.12
import QtQuick.Controls 2.12


Button {
    property string sliderName: "sliderName"
    property string ossiaPath: "vide"
    //id: slider
    contentItem: Text {
        text: sliderName
        color: "#ffffff"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: window.width/10
        implicitHeight: window.height/5
        color: "#303030"
        radius: 10
        Image{
            x: 5
            y: 5
            source:"Icons/scenario_trigger.png"
        }
    }
    onClicked: {
        socket.sendTextMessage('{ "Message": "Trigger","Path":'.concat(ossiaPath, '}'))
    }
}

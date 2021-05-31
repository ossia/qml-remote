import QtQuick 2.12
import QtQuick.Controls 2.12

Button {
    property string triggerName: "triggerName"
    property string scorePath: "vide"

    // Trigger name
    contentItem: Text {
        text: triggerName
        color: "#ffffff"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    // Trigger button
    background: Rectangle {
        implicitWidth: window.width / 10
        implicitHeight: window.height / 5
        color: "#303030"
        radius: 10
        Image {
            x: 5
            y: 5
            width: 20
            height: 20
            source: "../Icons/scenario_trigger.png"
        }
    }

    // Send a message when the trigger button is clicked on
    onClicked: {
        socket.sendTextMessage('{ "Message": "Trigger","Path":'.concat(
                                   scorePath, '}'))
    }
}

import QtQuick 2.12
import QtQuick.Controls 2.12

import Variable.Global 1.0

Button {
    id: button
    property string triggerName: "triggerName"
    property string scorePath: "vide"

    // Trigger name
    contentItem: Text {
        text: triggerName
        color: "#ffffff"
        verticalAlignment: Text.AlignVCenter
        anchors.left: parent.left
        anchors.leftMargin: background.height
        font.pointSize: window.width <= 500 ? 8 : parent.height / 2
        elide: Text.ElideRight
    }

    // Trigger button
    background: Rectangle {
        id: background
        width: parent.width
        height: parent.height
        color: Color.gray1
        radius: 5
        anchors.verticalCenter: parent.verticalCenter
        Image {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.height - 4
            height: parent.height - 4
            source: "../Icons/scenario_trigger.png"
        }
    }

    // Send a message when the trigger button is clicked on
    onClicked: {
        background.color = Color.brown
        socket.sendTextMessage('{ "Message": "Trigger","Path":'.concat(
                                   scorePath, '}'))
    }
}

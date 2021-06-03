import QtQuick 2.0
import QtQuick.Controls 2.15

Button {
    id: button
    property string buttonName: "buttonName"
    property string buttonPath: "buttonPath"
    property int buttonId
    property string buttonUuid

    contentItem: Text {
        text: buttonName
        color: "#ffffff"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: window.width / 10
        implicitHeight: window.width / 10
        color: "#303030"
        radius: 10
    }

    onHoveredChanged: {
        background.color = "#303030"
    }

    onPressed: {
        background.color = "#101010"
        /*
        console.log('{ "Message": "ControlSurface","Path":'.concat(
                        button.buttonPath, ', "id":', button.buttonId,
                        ', "Value": {"Impulse":null}}'))
                        */
        socket.sendTextMessage('{ "Message": "ControlSurface","Path":'.concat(
                                   button.buttonPath, ', "id":',
                                   button.buttonId,
                                   ', "Value": {"Impulse":null}}'))
    }

    onReleased: {
        background.color = "#303030"
    }
}

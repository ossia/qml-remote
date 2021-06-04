import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: button

    property string controlCustom
    property string controlDomain
    property string controlValueType
    property string controlValueData
    property int controlId
    property string controlUuid
    property string controlSurfacePath

    property bool isPressed: false

    contentItem: Text {
        text: controlCustom
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

    onIsPressedChanged: {
        // Todo : change the color when the button is pressed in score
    }

    onHoveredChanged: {
        background.color = "#303030"
    }

    onPressed: {
        background.color = "#101010"
        socket.sendTextMessage('{ "Message": "ControlSurface","Path":'.concat(
                                   button.controlSurfacePath, ', "id":',
                                   button.controlId,
                                   ', "Value": {"Impulse":null}}'))
    }

    onReleased: {
        background.color = "#303030"
    }
}

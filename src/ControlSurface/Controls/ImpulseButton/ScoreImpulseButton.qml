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
        implicitWidth: (window.width <= 500 ? 100 : (window.width >= 1200 ? 150 : 100 + ((window.width + window.height) / 100)))
        implicitHeight: this.implicitWidth
        color: "#303030"
        radius: 25
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

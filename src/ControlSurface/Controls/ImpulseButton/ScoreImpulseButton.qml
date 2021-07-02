/*
  * Impulse utton control  :
  * - in a list of impulse buttons in a control surface
  * - modify impulse button value in the remote modify
  * the value of this impulse button in score
  */

import QtQuick 2.15
import QtQuick.Controls 2.15

import Variable.Global 1.0

Button {
    id: button
    implicitWidth: (window.width <= 500
                    ? 75
                    : (window.width <= 1200
                       ? 100
                       : 100 + ((window.width + window.height) / 100)))
    implicitHeight: (window.width <= 500
                     ? 75
                     : (window.width <= 1200
                        ? 100
                        : 100 + ((window.width + window.height) / 100)))

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
        font.pointSize: parent.height === 0 ? 1 : parent.height / 12
        elide: Text.ElideRight
    }

    indicator: Rectangle {
        implicitWidth: parent.width - 10
        implicitHeight: parent.height - 10
        anchors.centerIn: parent
        radius: 25
        color: button.down ? Color.brown : Color.gray1
        border.width: 5
        border.color: Color.gray1
    }

    background: Rectangle {
        implicitWidth: parent.width
        implicitHeight: parent.height
        color: Color.gray1
        radius: 25
        border.color: Color.gray1
    }

    onIsPressedChanged: {

        // Todo : change the color when the button is pressed in score
    }

    onHoveredChanged: {
        background.color = Color.gray1
    }

    onPressed: {
        background.color = Color.brown
        socket.sendTextMessage('{ "Message": "ControlSurface","Path":'.concat(
                                   button.controlSurfacePath, ', "id":',
                                   button.controlId,
                                   ', "Value": {"Impulse":1}}'))
    }

    onReleased: {
        background.color = Color.gray1
    }
}

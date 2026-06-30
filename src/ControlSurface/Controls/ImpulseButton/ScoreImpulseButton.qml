/*
  * Impulse button control: momentary — flashes the accent while pressed.
  */

import QtQuick
import QtQuick.Controls

import Variable.Global 1.0

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

    implicitWidth: (window.width <= 500
                    ? 75
                    : (window.width <= 1200
                       ? 100
                       : 100 + ((window.width + window.height) / 100)))
    implicitHeight: implicitWidth

    onPressed: {
        socket.sendTextMessage(
                    `{ "Message": "ControlSurface","Path": ${button.controlSurfacePath}, "id": ${button.controlId}, "Value": {"Impulse":1} }`)
    }

    contentItem: Text {
        text: button.controlCustom
        color: button.down ? Skin.dark : Skin.white
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: parent.height === 0 ? 1 : parent.height / 12
        elide: Text.ElideRight
    }

    background: Rectangle {
        radius: 6
        color: button.down ? Skin.orange : Skin.gray2
        border { color: button.down ? Skin.orange : Skin.gray3; width: 1 }
    }
}

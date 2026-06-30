/*
  * Button control (toggle): flat filled button — accent fill + dark label when
  * on, neutral surface + white label when off.
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

    property bool isPressed
    property bool firstPressedFromScore: true
    property bool pressedFromScore
    property bool pressedFromRemote: false

    implicitWidth: (window.width <= 500
                    ? 75
                    : (window.width <= 1200
                       ? 100
                       : 100 + ((window.width + window.height) / 100)))
    implicitHeight: implicitWidth

    contentItem: Text {
        text: button.controlCustom
        color: button.isPressed ? Skin.dark : Skin.white
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: parent.height === 0 ? 1 : parent.height / 9
        elide: Text.ElideRight
    }

    background: Rectangle {
        radius: 6
        color: button.isPressed ? Skin.orange : (button.down ? Skin.gray3 : Skin.gray2)
        border { color: button.isPressed ? Skin.orange : Skin.gray3; width: 1 }
    }

    onClicked: {
        pressedFromRemote = true
        isPressed = !isPressed
        socket.sendTextMessage(
                    `{ "Message": "ControlSurface","Path": ${button.controlSurfacePath}, "id": ${button.controlId}, "Value": {"Bool": ${isPressed} }}`)
    }

    onPressedFromScoreChanged: {
        // Score-driven state sync intentionally left as before (see history).
    }
}

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

    // Same row height as the other control widgets (no oversized squares).
    implicitHeight: Math.max(Skin.minTouch, window.height <= 500 ? 30 : 5 + window.height / 25)
    implicitWidth: Math.round(implicitHeight * 2.4)

    // Material Button adds default padding + insets that push the centred label
    // up/left; zero them so it centres exactly in the flat background.
    padding: 0
    topInset: 0; bottomInset: 0; leftInset: 0; rightInset: 0

    onPressed: {
        socket.sendTextMessage(
                    `{ "Message": "ControlSurface","Path": ${button.controlSurfacePath}, "id": ${button.controlId}, "Value": {"Impulse":1} }`)
    }

    contentItem: Text {
        text: button.controlCustom
        color: button.down ? Skin.dark : Skin.white
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        // Shrink the label to fit rather than eliding it.
        fontSizeMode: Text.Fit
        minimumPointSize: 6
        font.pointSize: parent.height <= 34 ? Skin.fontCaption : Skin.fontBody
        font.family: Skin.font
        elide: Text.ElideRight
    }

    background: Rectangle {
        radius: 6
        color: button.down ? Skin.orange : Skin.gray2
        border { color: button.down ? Skin.orange : Skin.gray3; width: 1 }
    }
}

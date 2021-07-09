/*
  * Impulse button control  :
  * - in a list of impulse buttons in a control surface
  * - modify impulse button value in the remote modify
  * the value of this impulse button in score
  */

import QtQuick 2.15
import QtQuick.Controls 2.15

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
    implicitHeight: (window.width <= 500
                     ? 75
                     : (window.width <= 1200
                        ? 100
                        : 100 + ((window.width + window.height) / 100)))

    onHoveredChanged: background.color = Skin.gray1
    onReleased: background.color = Skin.gray1

    onPressed: {
        background.color = Skin.brown
        socket.sendTextMessage(
                    `{ "Message": "ControlSurface","Path": ${button.controlSurfacePath}, "id": ${button.controlId}, "Value": {"Impulse":1} }`)
    }

    contentItem: Text {
        text: controlCustom
        color: Skin.white
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: parent.height === 0 ? 1 : parent.height / 12
        elide: Text.ElideRight
    }

    indicator: Rectangle {
        implicitWidth: parent.width - 10; implicitHeight: parent.height - 10
        anchors.centerIn: parent
        radius: 25
        color: button.down ? Skin.brown : Skin.gray1
        border { width: 5; color: Skin.gray1 }
    }

    background: Rectangle {
        implicitWidth: parent.width; implicitHeight: parent.height
        color: Skin.gray1
        radius: 25
        border.color: Skin.gray1
    }
}

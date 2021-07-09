/*
  * Button control  :
  * - in a list of buttons in a control surface
  * - modify button value in the remote modify
  * the value of this button in score
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

    property bool isPressed
    property bool firstPressedFromScore: true
    property bool pressedFromScore
    property bool pressedFromRemote: false

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

    contentItem: Text {
        text: controlCustom
        color: Skin.white
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: parent.height === 0 ? 1 : parent.height / 9
        elide: Text.ElideRight
    }

    indicator: Rectangle {
        implicitWidth: parent.width - 10; implicitHeight: parent.height - 10
        anchors.centerIn: parent
        color: button.isPressed ? Skin.brown : Skin.gray1
        border { width: 5; color: Skin.gray1 }
    }

    background: Rectangle {
        implicitWidth: parent.width; implicitHeight: parent.height
        color: Skin.brown
    }

    onClicked: {
        pressedFromRemote = true
        indicator.color = isPressed ? Skin.gray1 : Skin.brown
        isPressed = ! isPressed
        socket.sendTextMessage(
                    `{ "Message": "ControlSurface","Path": ${button.controlSurfacePath}, "id": ${button.controlId}, "Value": {"Bool": ${isPressed} }}`)
    }

    onPressedFromScoreChanged: {
        // Almost works
        /*
        if (pressedFromRemote) {
            pressedFromRemote = false
            return
        }
        console.log("onPressedFromScoreChanged")
        if(firstPressedFromScore){
            if(!isPressed){
                //isPressed = true
            }
            indicator.color = isPressed ? Skin.orange : Skin.gray1
            firstPressedFromScore = false
            return
        }
        indicator.color = isPressed ? Skin.gray1 : Skin.orange
        isPressed = ! isPressed
        */
    }
}

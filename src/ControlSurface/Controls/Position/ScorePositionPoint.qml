/*
  * Define a colorpoint
  * Is located in a position in a Control Surface
  * All position of a same control surface in score share a common position display
  */

import QtQuick 2.12
import QtQuick.Controls 2.12

import Variable.Global 1.0

Rectangle {
    id: positionButton
    color: Color.brown

    property string controlCustom
    property string controlValueType
    property string controlValueData
    property int controlId
    property string controlUuid
    property string controlSurfacePath

    property real controlX: controlMin + vertical.x * (controlDomain / position.height)
    property real controlY: controlMin + horizontal.y * (controlDomain / position.height)
    property real controlDomain
    property real controlMin

    Text {
        id: positionName
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.horizontalCenter: positionButton.horizontalCenter
        text: controlCustom
        font.pointSize: parent.height * (9 / 40)
        color: Color.white
    }

    Text {
        id: positionValue
        anchors.top: positionName.bottom
        color: Color.white
        anchors.left: positionName.left
        text: "x,y:" + positionButton.controlX.toFixed(
                  2) + "," + positionButton.controlY.toFixed(2)
        font.pointSize: parent.height * (9 / 40)
    }

    MouseArea {
        id: positionMouseAreaButton
        anchors.fill: parent
        onClicked: positionButton.state = 'off'
    }

    states: [
        State {
            name: "off"
            PropertyChanges {
                target: positionButton
                controlX: controlX
                controlY: controlY
            }
            PropertyChanges {
                target: positionButton
                color: Color.gray1
            }
            PropertyChanges {
                target: positionMouseAreaButton
                onClicked: positionButton.state = 'on'
            }
        },
        State {
            name: "on"
            PropertyChanges {
                target: positionButton
                controlX: controlMin + vertical.x * (controlDomain / position.height)
                controlY: controlMin + horizontal.y * (controlDomain / position.height)
            }
        }
    ]
}

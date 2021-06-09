import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    id: positionButton
    width: background.width / 30
    height: positionButton.width
    color: "#a7dd0d"
    border.width: 5
    border.color: "#a7dd0d"

    property string controlCustom
    property string controlValueType
    property string controlValueData
    property int controlId
    property string controlUuid
    property string controlSurfacePath

    property int controlX
    property int controlY
    property int controlDomain

    Text {
        id: positionName
        anchors.left: positionButton.right
        anchors.leftMargin: 5
        anchors.horizontalCenter: positionButton.horizontalCenter
        text: controlCustom
        color: "#a7dd0d"
    }

    Text {
        id: positionValue
        anchors.top: positionName.bottom
        anchors.left: positionName.left
        text: "x,y:" + (vertical.x * (controlDomain / position.height)).toFixed(
                  2) + "," + (horizontal.y * (controlDomain / position.height)).toFixed(
                  2)
        color: "#a7dd0d"
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
                target: positionValue
                text: positionValue.text
            }
            PropertyChanges {
                target: positionButton
                color: "#363636"
            }
            PropertyChanges {
                target: positionMouseAreaButton
                onClicked: positionButton.state = 'on'
            }
        },
        State {
            name: "on"
            PropertyChanges {
                target: positionValue
                text: "x,y:" + (vertical.x * (controlDomain / position.height)).toFixed(
                          2) + "," + (horizontal.y * (controlDomain / position.height)).toFixed(
                          2)
            }
        }
    ]
}

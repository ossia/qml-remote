import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    id: positionButton
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

    property real controlX: controlMin + vertical.x * (controlDomain / position.height)
    property real controlY: controlMin + horizontal.y * (controlDomain / position.height)
    property real controlDomain
    property real controlMin

    Text {
        id: positionName
        anchors.left: positionButton.right
        anchors.leftMargin: 5
        anchors.horizontalCenter: positionButton.horizontalCenter
        text: controlCustom
        font.pointSize: background.height * (9 / 40)
        color: "#a7dd0d"
    }

    Text {
        id: positionValue
        anchors.top: positionName.bottom
        color: "#a7dd0d"
        anchors.left: positionName.left
        text: "x,y:" + positionButton.controlX.toFixed(
                  2) + "," + positionButton.controlY.toFixed(2)
        font.pointSize: background.height * (9 / 40)
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
                target: positionButton
                controlX: controlMin + vertical.x * (controlDomain / position.height)
                controlY: controlMin + horizontal.y * (controlDomain / position.height)
            }
        }
    ]
}

import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    property string _positionPointName: "PositionName"
    id: background
    width: (window.width <= 500
            ? (window.width - 10)
            : (window.width >= 1200
               ? 600
               : window.width / 2))

    height: background.width / 2
    color: "#363636"

    Rectangle {
        id: position
        anchors.left: parent.left
        width: position.height
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.margins: 5
        color: "black"

        MouseArea {
            anchors.fill: parent
            drag.target: this
            Rectangle {
                id: vertical
                anchors.top: parent.top
                x: Math.min(Math.max(parent.mouseX - width / 2., 0),
                            parent.width - width)
                //x: parent.mouseX - width/2.
                width: 5
                height: parent.height
                color: "white"
            }
            Rectangle {
                id: horizontal
                anchors.left: parent.left
                y: Math.min(Math.max(parent.mouseY - height / 2., 0),
                            parent.height - height)
                //y: parent.mouseY - height/2.
                width: parent.width
                height: 5
                color: "white"
            }
        }
    }

    // Create the column of position
    Column {
        anchors.left: position.right
        anchors.leftMargin: 5
        anchors.top: zone.top
        spacing: 20

        Repeater {
            width: parent.width
            id: colorPointList
            model: ListModel {
                id: colorPointListModel
            }

            delegate: Item {
                width: parent.width
                height: parent.width / 5

                ScorePositionPoint {
                    id: positionPoint
                    width: parent.width / 5
                    controlCustom: _custom
                    controlId: _id
                    controlUuid: _uuid
                    controlSurfacePath: path

                    /*
                    onControlXChanged: {
                        if (positionPoint.state === "on"
                                || positionPoint.state === "") {
                            socket.sendTextMessage(
                                        '{ "Message": "ControlSurface","Path":'.concat(
                                            colorPoint.controlSurfacePath,
                                            ', "id":', colorPoint.controlId,
                                            ', "Value": {"Vec4f":', hexToRGB(
                                                colorPoint.displayedColor),
                                            '}}'))
                        }
                    }
                    */
                }
            }
        }
    }
}

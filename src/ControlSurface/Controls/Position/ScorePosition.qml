import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    id: positionBackground
    width: (window.width <= 500
            ? (window.width - 10)
            : (window.width >= 1200
               ? 600
               : window.width / 2))

    height: positionBackground.width / 2
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
                width: 2
                height: parent.height
                color: "white"
            }

            Rectangle {
                id: horizontal
                anchors.left: parent.left
                y: Math.min(Math.max(parent.mouseY - height / 2., 0),
                            parent.height - height)
                width: parent.width
                height: 2
                color: "white"
            }
        }
    }

    // Create the column of position
    Column {
        anchors.left: position.right
        anchors.right: positionBackground.right
        anchors.leftMargin: 5
        anchors.top: positionBackground.top
        anchors.topMargin: 10
        spacing: 5
        width: (1 / 3) * positionBackground.width

        Repeater {
            width: parent.width
            model: ListModel {
                id: positionListModel
            }

            delegate: Item {
                id: background
                width: parent.width
                height: parent.width / 5

                ScorePositionPoint {
                    id: positionPoint
                    width: parent.width / 5
                    controlCustom: _custom
                    controlId: _id
                    controlUuid: _uuid
                    controlSurfacePath: path

                    controlMin: _controlMin
                    controlDomain: _controlDomain

                    onControlXChanged: {
                        if (positionPoint.state === "on"
                                || positionPoint.state === "") {
                            socket.sendTextMessage(
                                        '{ "Message": "ControlSurface","Path":'.concat(
                                            positionPoint.controlSurfacePath,
                                            ', "id":', positionPoint.controlId,
                                            ', "Value": {"Vec2f":[',
                                            positionPoint.controlX, ',',
                                            positionPoint.controlY, ']}}'))
                        }
                    }

                    onControlYChanged: {
                        if (positionPoint.state === "on"
                                || positionPoint.state === "") {
                            socket.sendTextMessage(
                                        '{ "Message": "ControlSurface","Path":'.concat(
                                            positionPoint.controlSurfacePath,
                                            ', "id":', positionPoint.controlId,
                                            ', "Value": {"Vec2f":[',
                                            positionPoint.controlX, ',',
                                            positionPoint.controlY, ']}}'))
                        }
                    }
                }
            }
        }
    }

    // Receving informations about colorpickers in control surface from score
    Connections {
        // Adding a colorpicker in the control surface
        function onAppendPosition(s) {
            function find(cond) {
                for (var i = 0; i < positionListModel.count; ++i)
                    if (cond(positionListModel.get(i)))
                        return i
                return null
            }
            //the index of m.Path in the listmodel
            var a = find(function (item) {
                return item.id === JSON.stringify(s.id)
            })
            if (a === null) {
                var tmpX = s.Value.Vec2f[0]
                var tmpY = s.Value.Vec2f[1]
                var tmpMin = s.Domain.Float.Min
                var tmpMax = s.Domain.Float.Max
                var tmpDomain = Math.abs(tmpMax - tmpMin)
                positionListModel.insert(positionListModel.count, {
                                             "_custom": s.Custom,
                                             "_id": s.id,
                                             "_uuid": s.uuid,
                                             "_controlX": tmpX,
                                             "_controlY": tmpY,
                                             "_controlDomain": tmpDomain,
                                             "_controlMin": tmpMin
                                         })
            }
        }
    }
}

import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    property string _positionPointName: "PositionName"
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

        Repeater {
            width: parent.width
            id: colorPointList
            model: ListModel {
                id: positionListModel
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

                    controlX: _controlX
                    controlY: _controlY
                    controlDomain: _controlDomain

                    /*
                    onControlXChanged: {
                        if (positionPoint.state === "on"
                                || positionPoint.state === "") {
                            socket.sendTextMessage(
                                        '{ "Message": "ControlSurface","Path":'.concat(
                                            positionPoint.controlSurfacePath,
                                            ', "id":', colorPoint.controlId,
                                            ', "Value": {"Vec4f":', hexToRGB(
                                                positionPoint.displayedColor),
                                            '}}'))
                        }
                    }
                    */
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
            var a = find(function (item) {
                return item.id === JSON.stringify(s.id)
            }) //the index of m.Path in the listmodel
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
                                             "_controlDomain": tmpDomain
                                         })
            }
        }

        /*
        // Modifying a colorpicker in the control surface
        function onModifyPosition(s) {
            for (var i = 0; i < positionListModel.count; ++i) {
                if (positionListModel.get(i)._id === s.Control) {
                    switch (positionListModel.get(i)._uuid) {
                    case Uuid.positionUUID:
                        // Float Colorpicker
                        var red = s.Value.Vec4f[0]
                        var green = s.Value.Vec4f[1]
                        var blue = s.Value.Vec4f[2]
                        var alpha = s.Value.Vec4f[3]
                        var newColor = Qt.rgba(red, green, blue, alpha)
                        break
                    default:
                        return
                    }
                    positionListModel.set(i, {
                                                "_color": colorpicker._fullColorString(
                                                              newColor, alpha)
                                            })
                }
            }
        }
        */
    }
}

/*
  * Define the position control
  * Is located in a Control Surface
  * All position of a same control surface in score share a common position display
  */

import QtQuick 2.12
import QtQuick.Controls 2.12

import "qrc:/Utility/utility.js" as Utility

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
    ListView {
        id: positionList
        anchors.left: position.right
        anchors.right: scrollBar.left
        anchors.margins: 5
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        spacing: 5
        orientation: ListView.Vertical
        clip: true
        snapMode: ListView.SnapToItem
        interactive: scrollBar.size < 1

        model: ListModel {
            id: positionListModel
        }

        delegate: ScorePositionPoint {
            id: positionPoint
            width: parent.width
            height: 5 + window.height / 20
            controlCustom: _custom
            controlId: _id
            controlUuid: _uuid
            controlSurfacePath: path

            controlMin: _controlMin
            controlDomain: _controlDomain

            state: _state

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

        ScrollBar.vertical: scrollBar
    }

    ScrollBar {
            id: scrollBar
            active: scrollBar.size < 1
            visible: scrollBar.size < 1
            width: window.width <= 500 ? 20 : 30
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 5

            anchors.right: parent.right
            interactive: scrollBar.size < 1
            policy: ScrollBar.AsNeeded
            snapMode: ScrollBar.NoSnap
            contentItem: Rectangle {
                id: scrollBarContentItem
                visible: scrollBar.size < 1
                color: scrollBar.pressed ? "#f6a019" : "#808080"
            }

            background: Rectangle {
                id: scrollBarBackground
                width: scrollBarContentItem.width
                anchors.fill: parent
                color: "#202020"
                border.color: "#101010"
                border.width: 2
            }
    }

    // Receving informations about colorpickers in control surface from score
    Connections {
        // Adding a colorpicker in the control surface
        function onAppendPosition(s) {
            //the index of m.Path in the listmodel
            var a = Utility.find(positionList.model, function (item) {
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
                                             "_controlMin": tmpMin,
                                             "_state": positionListModel.count <= 0 ? "" : "off"
                                         })
            }
        }
    }
}

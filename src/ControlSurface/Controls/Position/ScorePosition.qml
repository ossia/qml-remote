/*
  * Define the position control
  * Is located in a Control Surface
  * All positions of a same control surface in score share a common position display
  */

import QtQuick 2.12
import QtQuick.Controls 2.12

import "qrc:/Utility/utility.js" as Utility
import Variable.Global 1.0

Rectangle {
    id: positionBackground

    function onControlChanged(positionPoint){
        if (positionPoint.state === "on" || positionPoint.state === "") {
            socket.sendTextMessage(
                        `{ "Message": "ControlSurface","Path": ${positionPoint.controlSurfacePath}, "id": ${positionPoint.controlId}, "Value": {"Vec2f":[${positionPoint.controlX}, ${positionPoint.controlY} ]}}`)
        }
    }

    // Receiving information about position points in control surface from score
    Connections {
        // Adding a colorpicker in the control surface
        function onAppendPosition(s) {
            //the index of m.Path in the list model
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

    width: (parent.width <= 500
            ? (parent.width)
            : (parent.width >= 1200
               ? 600
               : parent.width / 2))

    height: positionBackground.width / 2
    color: Skin.gray2

    Rectangle {
        id: position

        width: position.height
        anchors {
            left: parent.left
            top: parent.top; bottom: parent.bottom
            margins: 5
        }
        color: Skin.black

        MouseArea {
            anchors.fill: parent
            drag.target: this

            Rectangle {
                id: vertical

                width: 2; height: parent.height
                anchors.top: parent.top
                x: Math.min(Math.max(parent.mouseX - width / 2., 0), parent.width - width)
                color: Skin.white
            }

            Rectangle {
                id: horizontal

                width: parent.width; height: 2
                anchors.left: parent.left
                y: Math.min(Math.max(parent.mouseY - height / 2., 0), parent.height - height)
                color: Skin.white
            }
        }
    }

    // Create the column of position
    ListView {
        id: positionList

        anchors {
            left: position.right; right: scrollBar.left
            top: parent.top; bottom: parent.bottom
            margins: 5
        }
        spacing: 5
        orientation: ListView.Vertical
        clip: true
        snapMode: ListView.SnapToItem
        interactive: scrollBar.size < 1
        ScrollBar.vertical: scrollBar

        model: ListModel {
            id: positionListModel
        }

        delegate: ScorePositionPoint {
            id: positionPoint

            width: parent.width; height: 5 + window.height / 20
            controlCustom: _custom
            controlId: _id
            controlUuid: _uuid
            controlSurfacePath: path
            controlMin: _controlMin
            controlDomain: _controlDomain
            state: _state
            onControlXChanged: positionBackground.onControlChanged(positionPoint)
            onControlYChanged: positionBackground.onControlChanged(positionPoint)
        }
    }

    ScrollBar {
        id: scrollBar

        width: window.width <= 500 ? 20 : 30
        anchors { right: parent.right; top: parent.top; bottom: parent.bottom; margins: 5 }
        active: scrollBar.size < 1
        visible: scrollBar.size < 1
        interactive: scrollBar.size < 1
        policy: ScrollBar.AsNeeded
        snapMode: ScrollBar.NoSnap

        contentItem: Rectangle {
            id: scrollBarContentItem
            visible: scrollBar.size < 1
            color: scrollBar.pressed ? Skin.orange : Skin.lightGray
        }

        background: Rectangle {
            id: scrollBarBackground

            width: scrollBarContentItem.width
            anchors.fill: parent
            color: Skin.darkGray
            border { color: Skin.dark; width: 2 }
        }
    }
}

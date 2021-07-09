/*
  * Define the colorpicker control
  * Is located in a Control Surface
  * All colorpickers of a same control surface in score share a common colorpanel
  */

import QtQuick 2.0
import QtQml.Models 2.12
 import QtQuick.Controls 2.15
import QtQml 2.15

import Variable.Global 1.0
import "qrc:/Utility/utility.js" as Utility

Rectangle {
    id: colorBackground

    // Receiving information about colorpickers in control surface from score
    Connections {

        // Adding a colorpicker in the control surface
        function onAppendColorpicker(s) {
            //the index of m.Path in the list model
            var a = Utility.find(colorPointListModel, function (item) {
                return item.id === JSON.stringify(s.id)
            })
            if (a === null) {
                var red = s.Value.Vec4f[0]
                var green = s.Value.Vec4f[1]
                var blue = s.Value.Vec4f[2]
                var alpha = s.Value.Vec4f[3]
                var newColor = Qt.rgba(red, green, blue, alpha)
                colorPointListModel.insert(colorPointListModel.count, {
                                               "_custom": s.Custom,
                                               "_id": s.id,
                                               "_uuid": s.uuid,
                                               "_color": colorpicker._fullColorString(
                                                             newColor, alpha),
                                               "_state": colorPointListModel.count <= 0 ? "" : "off"
                                           })
            }
        }

        // Modifying a colorpicker in the control surface
        function onModifyColorpicker(s) {
            for (var i = 0; i < colorPointListModel.count; ++i) {
                if (colorPointListModel.get(i)._id === s.Control) {
                    switch (colorPointListModel.get(i)._uuid) {
                    case Uuid.colorPickerUUID:
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
                    colorPointListModel.set(i, {"_color": colorpicker._fullColorString(newColor, alpha)})
                }
            }
        }
    }

    width: (parent.width <= 500 ? (parent.width)
                                : (parent.width >= 1200
                                   ? 600
                                   : parent.width / 2))
    height: colorBackground.width / 2
    color: Skin.gray2

    // Instantiate color picker window
    Colorpicker {
        id: colorpicker

        width: (2 / 3) * colorBackground.width
        anchors { left: parent.left; top: parent.top; bottom: parent.bottom}
    }

    // Create the column of color picker
    ListView {
        id: colorPointList

        anchors {
            left: colorpicker.right; right: scrollBar.left
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
            id: colorPointListModel
        }

        delegate: Item {
            id: background

            width: parent.width; height: 5 + window.height / 20

            ScoreColorPoint {
                id: colorPoint

                function hexToRGB(hex) {
                    return "[" + hex.r + ", " + hex.g + ", " + hex.b + ", " + hex.a + "]"
                }

                width: parent.width; height: 5 + window.height / 20
                controlCustom: _custom
                controlId: _id
                controlUuid: _uuid
                controlSurfacePath: path
                controlColor: _color
                displayedColor: colorpicker.colorValue
                state: _state

                onDisplayedColorChanged: {
                    if (colorPoint.state === "on" || colorPoint.state === "") {
                        socket.sendTextMessage(
                                    `{ "Message": "ControlSurface","Path": ${colorPoint.controlSurfacePath}, "id": ${colorPoint.controlId}, "Value": {"Vec4f": ${hexToRGB(colorPoint.displayedColor)} }}`)
                    }
                }
            }
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
            color: scrollBar.pressed ? Skin.orange : "#808080"
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

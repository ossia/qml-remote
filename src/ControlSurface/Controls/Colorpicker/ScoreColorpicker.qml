import QtQuick 2.0
import QtQml.Models 2.12
import QtQml 2.15

import Variable.Global 1.0

Rectangle {
    id: colorBackground
    width: (parent.width <= 500 ? (parent.width)
                                : (parent.width >= 1200
                                   ? 600
                                   : parent.width / 2))
    height: colorBackground.width / 2
    color: "#363636"

    // Instantiate color picker window
    Colorpicker {
        id: colorpicker
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: (2 / 3) * colorBackground.width
    }

    // Create the column of color picker
    Column {
        anchors.left: colorpicker.right
        anchors.right: colorBackground.right
        anchors.leftMargin: 5
        anchors.top: colorBackground.top
        anchors.topMargin: 10
        spacing: 5
        width: (1 / 3) * colorBackground.width

        Repeater {
            width: parent.width
            id: colorPointList
            model: ListModel {
                id: colorPointListModel
            }

            delegate: Item {
                id: background
                width: parent.width
                height: parent.width / 5

                ScoreColorPoint {
                    id: colorPoint
                    width: parent.width / 5
                    controlCustom: _custom
                    controlId: _id
                    controlUuid: _uuid
                    controlSurfacePath: path
                    controlColor: _color
                    displayedColor: colorpicker.colorValue

                    function hexToRGB(hex) {
                        return "[" + hex.r + ", " + hex.g + ", " + hex.b + ", " + hex.a + "]"
                    }

                    onDisplayedColorChanged: {

                        // le pb est de convertir un "#ffffffff" en [r,g, b, o] et inversement
                        if (colorPoint.state === "on"
                                || colorPoint.state === "") {
                            socket.sendTextMessage(
                                        '{ "Message": "ControlSurface","Path":'.concat(
                                            colorPoint.controlSurfacePath,
                                            ', "id":', colorPoint.controlId,
                                            ', "Value": {"Vec4f":', hexToRGB(
                                                colorPoint.displayedColor),
                                            '}}'))
                        }
                    }
                }
            }
        }
    }

    // Receving informations about colorpickers in control surface from score
    Connections {
        // Adding a colorpicker in the control surface
        function onAppendColorpicker(s) {
            function find(cond) {
                for (var i = 0; i < colorPointListModel.count; ++i)
                    if (cond(colorPointListModel.get(i)))
                        return i
                return null
            }
            var a = find(function (item) {
                return item.id === JSON.stringify(s.id)
            }) //the index of m.Path in the listmodel
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
                                                             newColor, alpha)
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
                    colorPointListModel.set(i, {
                                                "_color": colorpicker._fullColorString(
                                                              newColor, alpha)
                                            })
                }
            }
        }
    }
}

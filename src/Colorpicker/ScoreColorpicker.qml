import QtQuick 2.0
import QtQml.Models 2.12
import QtQml 2.15

Rectangle {
    property string _positionPointName: "ColorName"
    id: colorBackground
    width: 550
    height: 150

    color: "#363636"

    // Instantiate color picker window
    Colorpicker {
        id: colorpicker
        width: 70 * colorBackground.width / 100
        height: 98 * colorBackground.height / 100
    }

    // Create the column of color picker
    Column {
        anchors.left: colorpicker.right
        anchors.leftMargin: 5
        anchors.top: colorpicker.top
        anchors.topMargin: 5
        spacing: 20
        Repeater {
            id: colorPointList
            model: ListModel {
                id: colorPointListModel
            }

            delegate: ScoreColorPoint {
                id: colorPoint
                colorPointName: myName
                colorPointPath: path // path de la control surface et pas du color picker
                colorPointId: myId
                colorPointColor: myColor
                colorPointOpacity: myOpacity
                displayedColor: colorpicker.colorValue
                colorPointUuid: myUuid

                function hexToRGB(hex) {

                    return "[" + hex.r + ", " + hex.g + ", " + hex.b + ", " + hex.a + "]"
                }

                onDisplayedColorChanged: {

                    // le pb est de convertir un "#ffffffff" en [r,g, b, o] et inversement
                    if (colorPoint.state === "on" || colorPoint.state === "") {

                        socket.sendTextMessage(
                                    '{ "Message": "ControlSurface","Path":'.concat(
                                        colorPoint.colorPointPath, ', "id":',
                                        colorPoint.colorPointId,
                                        ', "Value": {"Vec4f":',
                                        hexToRGB(colorPoint.displayedColor),
                                        '}}'))
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
                                               "myName": s.Custom,
                                               "myId": s.id,
                                               "myColor": colorpicker._fullColorString(
                                                              newColor, alpha),
                                               "myOpacity": JSON.stringify(
                                                                s.Value.Vec4f),
                                               "myUuid": s.uuid
                                           })
            }
        }

        // Modifying a colorpicker in the control surface
        function onModifyColorpicker(s) {
            for (var i = 0; i < colorPointListModel.count; ++i) {
                if (colorPointListModel.get(i).myId === s.Control) {
                    switch (colorPointListModel.get(i).myUuid) {
                    case "8f38638e-9f9f-48b0-ae36-1cba86ef5703":
                        // Float Colorpicker
                        var red = s.Value.Vec4f[0]
                        var green = s.Value.Vec4f[1]
                        var blue = s.Value.Vec4f[2]
                        var alpha = s.Value.Vec4f[3]
                        var newColor = Qt.rgba(red, green, blue, alpha)
                        console.log(JSON.stringify(colorpicker._fullColorString(
                                                       newColor, alpha)))

                        break
                    default:
                        return
                    }
                    colorPointListModel.set(i, {
                                                "myColor": colorpicker._fullColorString(
                                                               newColor, alpha)
                                            })
                }
            }
        }
    }
}

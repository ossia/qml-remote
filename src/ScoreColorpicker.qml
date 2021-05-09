import QtQuick 2.0
import QtQml.Models 2.12

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
                onDisplayedColorChanged: {
                    // le pb est de convertir un "#ffffffff" en [r,g, b, o] et inversement
                    socket.sendTextMessage(
                                '{ "Message": "ControlSurface","Path":'.concat(
                                    colorPoint.colorPointPath, ', "id":',
                                    colorPoint.colorPointId, ', "Value": {"Vect4f":',
                                    colorPoint.displayedColor, '}}'))
                    console.log('{ "Message": "ControlSurface","Path":'.concat(
                                    colorPoint.colorPointPath, ', "id":',
                                    colorPoint.colorPointId, ', "Value": {"Vect4f":',
                                    colorPoint.displayedColor.rgb(), '}}'))
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
                console.log(JSON.stringify(s))
                colorPointListModel.insert(colorPointListModel.count, {
                                               "myName": s.Custom,
                                               "myId": JSON.stringify(s.id),
                                               "myColor": JSON.stringify(s.Value.Vec4f),
                                               "myOpacity":  JSON.stringify(s.Value.Vec4f)
                                           })
            }
        }
    }
}

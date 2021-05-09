import QtQuick 2.0
import QtQml.Models 2.12

Rectangle {
    property string _positionPointName: "ColorName"
    id: colorBackground
    width: 450
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
            id : colorPointList
            model: ListModel {
                id : colorPointListModel
            }

            delegate : ScoreColorPoint {
                _colorPointName: myName
                colorPointPath: myPath
                colorPointId: myId
                displayedColor: colorpicker.colorValue
            }
        }
     }

    function onAppendColorpicker(s) {
        function find(cond) {
            for (var i = 0; i < colorPointList.count; ++i)
                if (cond(colorPointList.get(i)))
                    return i
            return null
        }
        var a = find(function (item) {
            return item.id === JSON.stringify(s.id)
        }) //the index of m.Path in the listmodel
        if (a === null) {
            colorPointListModel.insert(colorPointListModel.count, {
                                       "myName": s.Custom,
                                       "myPath": JSON.stringify(s.Path),
                                       "myId": JSON.stringify(s.id)
                                   })
        }
    }
}

import QtQuick 2.0

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
            model: ["color1", "color", "color2"]
            ScoreColorPoint {
                _colorPointName: modelData
                displayedColor: colorpicker.colorValue
            }
        }
    }
}

import QtQuick 2.0

Rectangle {

    property string _positionPointName: "ColorName"
    id: colorBackground
    width: 450
    height: 150

    color: "#363636"

    Colorpicker{
        id: colorpicker
        width: 70*colorBackground.width/100
        height: 98*colorBackground.height/100
    }
    Column {
        anchors.left: colorpicker.right
        anchors.leftMargin: 5
        anchors.top: colorpicker.top
        spacing: 20
        Repeater {
            model: ["color1", "color", "color2"]
            OssiaColorPoint{
                _colorPointName: modelData
                displayedColor: colorpicker.colorValue
            }
        }
    }
}

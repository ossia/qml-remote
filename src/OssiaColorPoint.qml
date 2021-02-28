import QtQuick 2.15
import QtQuick.Controls 2.15



Rectangle {
    property string _colorPointName: "ColorPointName"
    id: colorButton
    width: colorBackground.width/30
    height: colorButton.width
    radius: colorButton.width/2
    color: "#a7dd0d"
    border.width: 2
    border.color: "#a7dd0d"

    Text {
         id: colorName
         anchors.left: colorButton.right
         anchors.leftMargin: 5
         anchors.horizontalCenter: colorButton.horizontalCenter
         text: _colorPointName
         color: "#a7dd0d"
     }
     Text {
         id: colorValue
         anchors.top: colorName.bottom
         anchors.left: colorName.left
         //text: "x,y:"+vertical.x.toFixed(0)+","+horizontal.y.toFixed(0)
         //text: "color"+_fullColorString(colorpicker.colorValue, colorpicker.picker.alphaPicker.alphaSlider.value)
        text: "yes"
         color: "#a7dd0d"
     }

    MouseArea{
        id: colorMouseAreaButton
        anchors.fill: parent
        onClicked:  colorButton.state = 'off'
    }

    states: [
        State {
            name: "off"
            PropertyChanges {
                target: colorValue;
                text: colorValue.text
            }
            PropertyChanges {
                target: colorButton;
                color: "#363636"
            }
            PropertyChanges{
                target: colorMouseAreaButton;
                onClicked: colorButton.state = 'on'
            }
        },
        State {
            name: "on"
            PropertyChanges {
                target: colorValue;
                //text: "x,y:"+vertical.x.toFixed(0)+","+horizontal.y.toFixed(0)}
                //text: "color : "+_fullColorString(colorpicker.colorValue, alphaSlider.value)
                text: "no"
            }
        }
    ]
}

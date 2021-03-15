import QtQuick 2.15
import QtQuick.Controls 2.15



Rectangle {
    property string _colorPointName: "ColorPointName"
    id: colorButton
    width: colorBackground.width/45
    height: colorButton.width
    color: "#a7dd0d"
    border.width: 2
    border.color: "#a7dd0d"
    //property string displayedColor: "#FFFFFFFF"
    property color displayedColor: "#FFFFFFFF"

    Text {
         id: colorName
         anchors.left: colorButton.right
         anchors.leftMargin: 5
         anchors.horizontalCenter: colorButton.horizontalCenter
         text: _colorPointName
         color: "#a7dd0d"
     }
     /*Text {
         id: colorValue
         anchors.top: colorName.bottom
         anchors.left: colorName.left
         //text: "x,y:"+vertical.x.toFixed(0)+","+horizontal.y.toFixed(0)
         //text: "color"+_fullColorString(colorpicker.colorValue, colorpicker.picker.alphaPicker.alphaSlider.value)
        text: displayedColor
         color: "#a7dd0d"
     }*/
     PanelBorder {
         width: 100
         height: 15
         anchors.top: colorName.bottom
         anchors.left: colorName.left
         //visible: enableAlphaChannel
         Checkerboard { cellSide: 5 }
         Rectangle {
             id: colorValue
             width: parent.width; height: 15
             border.width: 1; border.color: "black"
             color: colorButton.displayedColor
       }
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
                color: colorValue.color
            }
            PropertyChanges {
                target: colorButton;
                color: "#363636"
            }
            PropertyChanges{
                target: colorMouseAreaButton;
                onClicked: colorButton.state = "on"
            }
        },
        State {
            name: "on"
            PropertyChanges {
                target: colorValue;
                //text: "x,y:"+vertical.x.toFixed(0)+","+horizontal.y.toFixed(0)}
                //text: "color : "+_fullColorString(colorpicker.colorValue, alphaSlider.value)
                color: displayedColor
            }
        }
    ]
}

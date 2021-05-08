import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    property string _colorPointName: "ColorPointName"
    id: colorButton
    width: colorBackground.width / 45
    height: colorButton.width
    color: "#a7dd0d"
    border.width: 2
    border.color: "#a7dd0d"
    property color displayedColor: "#FFFFFFFF"

    Text {
        id: colorName
        anchors.left: colorButton.right
        anchors.leftMargin: 5
        anchors.horizontalCenter: colorButton.horizontalCenter
        text: _colorPointName
        color: "#a7dd0d"
    }
    PanelBorder {
        width: 100
        height: 15
        anchors.top: colorName.bottom
        anchors.left: colorName.left
        Checkerboard {
            cellSide: 5
        }
        Rectangle {
            id: colorValue
            width: parent.width
            height: 15
            border.width: 1
            border.color: "black"
            color: colorButton.displayedColor
        }
    }

    MouseArea {
        id: colorMouseAreaButton
        anchors.fill: parent
        onClicked: colorButton.state = 'off'
    }

    states: [
        State {
            name: "off"
            PropertyChanges {
                target: colorValue
                color: colorValue.color
            }
            PropertyChanges {
                target: colorButton
                color: "#363636"
            }
            PropertyChanges {
                target: colorMouseAreaButton
                onClicked: colorButton.state = "on"
            }
        },
        State {
            name: "on"
            PropertyChanges {
                target: colorValue
                color: displayedColor
            }
        }
    ]
}

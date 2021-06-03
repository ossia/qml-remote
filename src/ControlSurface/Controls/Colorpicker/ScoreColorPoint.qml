import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    property string colorPointName: "ColorPointName"
    property string colorPointPath: "path"
    property int colorPointId
    property string colorPointColor: "Color"
    property string colorPointOpacity: "Opacity"
    property string colorPointUuid
    id: colorButton
    height: colorButton.width
    color: "#a7dd0d"
    border.width: 5
    border.color: "#a7dd0d"
    property color displayedColor: "#a7dd0dFF"

    Text {
        id: colorName
        anchors.left: colorButton.right
        anchors.leftMargin: 5
        anchors.horizontalCenter: colorButton.horizontalCenter
        text: colorPointName
        font.pointSize: background.height * ( 9 / 40)
        color: "#a7dd0d"
    }
    PanelBorder {
        width: background.width * ( 2 / 3)
        height: parent.width / 2
        anchors.top: colorName.bottom
        anchors.left: colorName.left

        Rectangle {
            id: colorValue
            width: parent.width
            height: parent.height
            border.width: 1
            border.color: "black"
            color: colorButton.displayedColor
        }
    }

    MouseArea {
        id: colorMouseAreaButton
        anchors.fill: parent
        onClicked: colorButton.state = "off"
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
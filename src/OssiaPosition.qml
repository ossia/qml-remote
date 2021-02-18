import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    property string _positionPointName: "PositionName"
    id: background
    //width: 300
    //height: 150

    color: "#363636"
    Rectangle {
        id: zone

        width: 70*background.width/100
        height: 98*background.height/100
        color: "black"

        Column {
            anchors.left: zone.right
            anchors.leftMargin: 5
            anchors.top: zone.top
            spacing: 20
            Repeater {
                model: ["position1", "ps", "position2"]
                OssiaPositionPoint{_positionPointName: modelData}
            }
        }
        MouseArea{
            anchors.fill: parent
            Rectangle {
                id: vertical
                anchors.top: parent.top
                x: parent.mouseX
                width: 5
                height: parent.height
                color: "white"
            }
            Rectangle {
                id: horizontal
                anchors.left: parent.left
                y: parent.mouseY
                width: parent.width
                height: 5
                color: "white"
            }

        }
    }
}


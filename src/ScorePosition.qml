
import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    property string _positionPointName: "PositionName"
    id: background
    width: 300
    height: 150

    color: "#363636"
    Rectangle {
        id: zone
        anchors.left: parent.left
        width: 65*background.width/100
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.margins: 5
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
            drag.target: this
            Rectangle {
                id: vertical
                anchors.top: parent.top
                x: Math.min(Math.max(parent.mouseX - width/2., 0), parent.width - width)
                //x: parent.mouseX - width/2.
                width: 5
                height: parent.height
                color: "white"
            }
            Rectangle {
                id: horizontal
                anchors.left: parent.left
                y: Math.min(Math.max(parent.mouseY - height/2., 0), parent.height  - height)
                //y: parent.mouseY - height/2.
                width: parent.width
                height: 5
                color: "white"
            }
        }
    }
}

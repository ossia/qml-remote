import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    property string _positionPointName: "PositionName"
    id: background
    width: 300
    height: 150
    color: "#363636"
    Rectangle {
        id: zone
        x: background.width/100
        y: background.height/100
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

        Rectangle {
            id: cursor
            width: 5
            height: 5
            color: "white"
            radius: cursor.width/2

            MouseArea {
                anchors.fill: parent
                width: cursor.width * 2
                height: cursor.height*2
                drag.target: parent;
                drag.minimumX: -cursor.x
                drag.maximumX: zone.width - vertical.width
                drag.minimumY: -cursor.y
                drag.maximumY: zone.height - horizontal.height
            }
            Rectangle {
                id: vertical
                y: -cursor.y
                width: cursor.width
                height: zone.height
                color: "white"
            }
            Rectangle {
                id: horizontal
                x: -cursor.x
                width: zone.width
                height: cursor.height
                color: "white"
            }
        }
    }
}


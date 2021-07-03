//  Saturation/brightness picking box
import QtQuick 2.11

import Variable.Global 1.0

Item {
    id: root
    property color hueColor: "blue"
    property real saturation: pickerCursor.x / (width - 2 * r)
    property real brightness: 1 - pickerCursor.y / (height - 2 * r)
    property int r: colorHandleRadius

    Rectangle {
        x: r
        y: r + parent.height - 2 * r
        rotation: -90
        transformOrigin: Item.TopLeft
        width: parent.height - 2 * r
        height: parent.width - 2 * r
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: "#FFFFFF"
            }
            GradientStop {
                position: 1.0
                color: root.hueColor
            }
        }
    }

    Rectangle {
        id: colorlessGradient
        x: r
        y: r
        width: parent.width - 2 * r
        height: parent.height - 2 * r
        gradient: Gradient {
            GradientStop {
                position: 1.0
                color: "#FF000000"
            }
            GradientStop {
                position: 0.0
                color: "#00000000"
            }
        }
    }

    Item {
        id: pickerCursor
        Rectangle {
            width: r * 2
            height: r * 2
            radius: r
            border.color: Skin.black
            border.width: 2
            color: "transparent"
            Rectangle {
                anchors.fill: parent
                anchors.margins: 2
                border.color: Skin.white
                border.width: 2
                radius: width / 2
                color: "transparent"
            }
        }
    }

    MouseArea {
        anchors.fill: colorlessGradient
        x: r
        y: r
        drag.target: this
        function handleMouse(mouse) {
            if (mouse.buttons & Qt.LeftButton) {
                pickerCursor.x = Math.max(0, Math.min(width, mouse.x))
                pickerCursor.y = Math.max(0, Math.min(height,
                                                      mouse.y)) // - 1 * r
            }
        }
        onPositionChanged: handleMouse(mouse)
        onPressed: handleMouse(mouse)
    }
}

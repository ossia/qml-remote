// Vertical "slider" control used in colorpicker
import QtQuick 2.11

import Variable.Global 1.0

Item {

    property int cursorHeight: 7
    property real value: (1 - pickerCursor.y / height)

    onVisibleChanged: {
        if (visible) {
            pickerCursor.y = -cursorHeight * 0.5
        }
    }

    Item {
        id: pickerCursor

        width: parent.width

        Rectangle {
            width: parent.width + 4; height: cursorHeight
            x: -3;  y: -height * 0.5
            border { color: Skin.black; width: 1 }
            color: "transparent"

            Rectangle {
                anchors { fill: parent; margins: 2 }
                border { color: Skin.white; width: 1}
                color: "transparent"
            }
        }
    }

    MouseArea {
        function handleMouse(mouse) {
            if (mouse.buttons & Qt.LeftButton) {
                pickerCursor.y = Math.max(0, Math.min(height, mouse.y))
            }
        }

        anchors { left: parent.left; right: parent.right; top: parent.top; bottom: parent.bottom }
        drag.target: this
        y: -Math.round(cursorHeight / 2)
        onPositionChanged: handleMouse(mouse)
        onPressed: handleMouse(mouse)
    }
}

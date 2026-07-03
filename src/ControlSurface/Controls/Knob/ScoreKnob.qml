/*
  * Knob control (score Process::FloatKnob) :
  * - rotary dial in a list of knobs in a control surface
  * - moving it sends the new float value to score
  */

import QtQuick
import QtQuick.Controls

import Variable.Global 1.0

Item {
    id: root

    property string controlCustom
    property int controlId
    property string controlUuid
    property string controlSurfacePath
    property color controlColor: Skin.orange

    property alias from: dial.from
    property alias to: dial.to
    property alias value: dial.value

    implicitWidth: (controlSurfaceListColumn.width <= 500
                    ? controlSurfaceListColumn.width
                    : controlSurfaceListColumn.width >= 1200
                      ? 400
                      : controlSurfaceListColumn.width / 3)
    implicitHeight: implicitWidth <= 200 ? 90 : 110

    Text {
        id: label
        anchors { left: parent.left; top: parent.top; leftMargin: 4 }
        text: ' ' + root.controlCustom
        color: Skin.white
        font.pointSize: root.width <= 200 ? 10 : 12
        font.family: Skin.font
    }

    Dial {
        id: dial

        anchors { top: label.bottom; bottom: parent.bottom; horizontalCenter: parent.horizontalCenter }
        width: height

        background: Rectangle {
            radius: width / 2
            color: Skin.gray2
            border { color: Skin.gray3; width: 1 }
        }

        handle: Rectangle {
            id: handleItem
            x: dial.background.x + dial.background.width / 2 - width / 2
            y: dial.background.y + dial.background.height / 2 - height / 2
            width: 10; height: 10; radius: width / 2
            color: Skin.orange
            antialiasing: true
            transform: [
                Translate { y: -dial.background.height * 0.4 + handleItem.height / 2 },
                Rotation { angle: dial.angle; origin.x: handleItem.width / 2; origin.y: handleItem.height / 2 }
            ]
        }

        onMoved: socket.sendTextMessage(
            `{ "Message": "ControlSurface","Path": ${root.controlSurfacePath}, "id": ${root.controlId}, "Value": {"Float": ${dial.value.toFixed(3)} }}`)
    }

    Text {
        anchors { right: parent.right; top: parent.top; rightMargin: 4 }
        text: dial.value.toFixed(3)
        color: Skin.white
        font.pointSize: root.width <= 200 ? 10 : 12
        font.family: Skin.monoFont
    }
}

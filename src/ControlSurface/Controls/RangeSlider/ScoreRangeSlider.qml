/*
  * Range slider control (score *RangeSlider / *RangeSpinBox) :
  * - two-handle slider editing a Vec2f [low, high]
  * - flat-Skin styling to match the other controls
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
    property color controlColor: Skin.brown

    property bool isInt: false
    property real from: 0
    property real to: 1
    property real low: 0
    property real high: 1

    implicitWidth: (controlSurfaceListColumn.width <= 500
                    ? controlSurfaceListColumn.width
                    : controlSurfaceListColumn.width >= 1200
                      ? 400
                      : controlSurfaceListColumn.width / 3)
    implicitHeight: Math.max(Skin.minTouch, window.height <= 500 ? 36 : 8 + window.height / 22)

    function send() {
        var lo = root.isInt ? Math.round(slider.first.value) : Number(slider.first.value.toFixed(3))
        var hi = root.isInt ? Math.round(slider.second.value) : Number(slider.second.value.toFixed(3))
        socket.sendTextMessage(
            `{ "Message": "ControlSurface","Path": ${root.controlSurfacePath}, "id": ${root.controlId}, "Value": {"Vec2f":[${lo}, ${hi}]} }`)
    }

    Text {
        id: label
        anchors { left: parent.left; top: parent.top; leftMargin: 4 }
        text: ' ' + root.controlCustom + ' ['
              + (root.isInt ? Math.round(slider.first.value) : slider.first.value.toFixed(2)) + ', '
              + (root.isInt ? Math.round(slider.second.value) : slider.second.value.toFixed(2)) + ']'
        color: Skin.white
        font.pointSize: root.width <= 200 ? 10 : 12
    }

    RangeSlider {
        id: slider

        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; top: label.bottom }
        from: root.from
        to: root.to
        first.value: root.low
        second.value: root.high
        stepSize: root.isInt ? 1 : 0

        first.onMoved: root.send()
        second.onMoved: root.send()

        background: Rectangle {
            x: slider.leftPadding
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            width: slider.availableWidth
            height: 6
            color: Skin.gray2
            border.color: Skin.brown

            Rectangle {
                x: slider.first.position * parent.width
                width: slider.second.position * parent.width - x
                height: parent.height
                color: Skin.orange
            }
        }

        first.handle: Rectangle {
            x: slider.leftPadding + slider.first.visualPosition * (slider.availableWidth - width)
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            implicitWidth: 14; implicitHeight: 14; radius: width / 2
            color: slider.first.pressed ? Skin.orange : Skin.gray3
            border.color: Skin.orange
        }

        second.handle: Rectangle {
            x: slider.leftPadding + slider.second.visualPosition * (slider.availableWidth - width)
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            implicitWidth: 14; implicitHeight: 14; radius: width / 2
            color: slider.second.pressed ? Skin.orange : Skin.gray3
            border.color: Skin.orange
        }
    }
}

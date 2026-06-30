/*
  * Vector slider control (score XYZSlider / MultiSlider) :
  * - N labelled sub-sliders; axis names X/Y/Z for vectors, indices otherwise
  * - sends Vec3f for XYZSlider, Tuple of floats for MultiSlider
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

    property real from: 0
    property real to: 1
    property string valuesJson: "[]"
    readonly property bool isTuple: controlUuid === Uuid.multiSliderUUID

    // Working copy; refreshed when score pushes a new value.
    property var current: JSON.parse(valuesJson)
    onValuesJsonChanged: current = JSON.parse(valuesJson)

    readonly property var axisNames: ["X", "Y", "Z", "W"]

    implicitWidth: (controlSurfaceListColumn.width <= 500
                    ? controlSurfaceListColumn.width
                    : controlSurfaceListColumn.width >= 1200
                      ? 400
                      : controlSurfaceListColumn.width / 3)
    implicitHeight: label.implicitHeight + 4 + rows.implicitHeight

    function send() {
        var payload
        if (root.isTuple) {
            var parts = root.current.map(function (v) { return `{"Float": ${Number(v).toFixed(3)}}` })
            payload = `{"Tuple":[${parts.join(",")}]}`
        } else {
            payload = `{"Vec3f":[${root.current.map(function (v) { return Number(v).toFixed(3) }).join(", ")}]}`
        }
        socket.sendTextMessage(
            `{ "Message": "ControlSurface","Path": ${root.controlSurfacePath}, "id": ${root.controlId}, "Value": ${payload} }`)
    }

    Text {
        id: label
        anchors { left: parent.left; top: parent.top; leftMargin: 4 }
        text: ' ' + root.controlCustom
        color: Skin.white
        font.pointSize: root.width <= 200 ? 10 : 12
    }

    Column {
        id: rows
        anchors { left: parent.left; right: parent.right; top: label.bottom; topMargin: 2 }
        spacing: 3

        Repeater {
            model: root.current.length

            delegate: Row {
                width: rows.width
                spacing: 6

                Text {
                    width: 16
                    text: root.isTuple ? index : (root.axisNames[index] || index)
                    color: Skin.white
                    font.pointSize: root.width <= 200 ? 9 : 11
                    anchors.verticalCenter: parent.verticalCenter
                }

                Slider {
                    id: axisSlider
                    width: parent.width - 24
                    height: Skin.minTouch
                    anchors.verticalCenter: parent.verticalCenter
                    from: root.from
                    to: root.to
                    value: root.current[index]
                    onMoved: {
                        var c = root.current.slice()
                        c[index] = value
                        root.current = c
                        root.send()
                    }

                    handle: Rectangle {
                        x: axisSlider.leftPadding + axisSlider.visualPosition * (axisSlider.availableWidth - width)
                        y: axisSlider.topPadding + axisSlider.availableHeight / 2 - height / 2
                        implicitWidth: 12; implicitHeight: 12; radius: width / 2
                        color: axisSlider.pressed ? Skin.orange : Skin.gray3
                        border.color: Skin.orange
                    }
                    background: Rectangle {
                        x: axisSlider.leftPadding
                        y: axisSlider.topPadding + axisSlider.availableHeight / 2 - height / 2
                        width: axisSlider.availableWidth; height: 5
                        color: Skin.gray2
                        border.color: Skin.brown
                        Rectangle {
                            width: axisSlider.visualPosition * parent.width
                            height: parent.height
                            color: Skin.orange
                        }
                    }
                }
            }
        }
    }
}

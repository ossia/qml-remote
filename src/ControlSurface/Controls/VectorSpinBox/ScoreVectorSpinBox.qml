/*
  * Vector spinbox control (score XYSpinboxes / XYZSpinboxes) :
  * - one numeric field per component (X/Y/Z), flat-Skin styled
  * - sends Vec2f / Vec3f
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
    property string valuesJson: "[]"
    property var current: JSON.parse(valuesJson)
    onValuesJsonChanged: current = JSON.parse(valuesJson)

    readonly property var axisNames: ["X", "Y", "Z", "W"]

    implicitWidth: (controlSurfaceListColumn.width <= 500
                    ? controlSurfaceListColumn.width
                    : controlSurfaceListColumn.width >= 1200
                      ? 400
                      : controlSurfaceListColumn.width / 3)
    implicitHeight: label.implicitHeight + 4 + row.implicitHeight

    function commit(index, v) {
        if (isNaN(v))
            return
        if (root.isInt)
            v = Math.round(v)
        var c = root.current.slice()
        c[index] = v
        root.current = c
        var key = (root.controlUuid === Uuid.xyzSpinboxesUUID) ? "Vec3f" : "Vec2f"
        var body = c.map(function (x) { return root.isInt ? Math.round(x) : Number(x).toFixed(3) }).join(", ")
        socket.sendTextMessage(
            `{ "Message": "ControlSurface","Path": ${root.controlSurfacePath}, "id": ${root.controlId}, "Value": {"${key}":[${body}]} }`)
    }

    Text {
        id: label
        anchors { left: parent.left; top: parent.top; leftMargin: 4 }
        text: ' ' + root.controlCustom
        color: Skin.white
        font.pointSize: root.width <= 200 ? 10 : 12
        font.family: Skin.font
    }

    Row {
        id: row
        anchors { left: parent.left; right: parent.right; top: label.bottom; topMargin: 2 }
        spacing: 6

        Repeater {
            model: root.current.length

            delegate: Row {
                spacing: 3

                Text {
                    text: root.axisNames[index] || index
                    color: Skin.white
                    font.pointSize: root.width <= 200 ? 9 : 11
                    font.family: Skin.font
                    anchors.verticalCenter: parent.verticalCenter
                }

                TextField {
                    width: (row.width / root.current.length) - 24
                    height: Skin.minTouch
                    text: root.isInt ? String(Math.round(root.current[index]))
                                     : Number(root.current[index]).toFixed(3)
                    font.family: Skin.monoFont
                    color: Skin.white
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: TextInput.AlignVCenter
                    topPadding: 0; bottomPadding: 0
                    selectByMouse: true
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    validator: root.isInt ? intValidator : doubleValidator
                    background: Rectangle { color: Skin.darkGray; border.color: root.controlColor }
                    onEditingFinished: root.commit(index, parseFloat(text))
                }
            }
        }
    }

    IntValidator { id: intValidator }
    DoubleValidator { id: doubleValidator; decimals: 3; notation: DoubleValidator.StandardNotation }
}

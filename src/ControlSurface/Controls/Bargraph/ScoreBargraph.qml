/*
  * Bargraph control (score Bargraph, a ControlOutlet) :
  * - read-only horizontal level meter
  */

import QtQuick

import Variable.Global 1.0

Item {
    id: root

    property string controlCustom
    property int controlId
    property string controlUuid

    property real from: 0
    property real to: 1
    property real value: 0
    readonly property real ratio: (to > from) ? Math.max(0, Math.min(1, (value - from) / (to - from))) : 0

    implicitWidth: (controlSurfaceListColumn.width <= 500
                    ? controlSurfaceListColumn.width
                    : controlSurfaceListColumn.width >= 1200
                      ? 400
                      : controlSurfaceListColumn.width / 3)
    implicitHeight: Math.max(Skin.minTouch, window.height <= 500 ? 30 : 5 + window.height / 25)

    Rectangle {
        anchors.fill: parent
        color: Skin.gray2
        border.color: Skin.brown

        // Green level fill (distinct from the orange, draggable sliders)
        Rectangle {
            anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
            width: parent.width * root.ratio
            color: Skin.green2
        }
    }

    Text {
        anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 6 }
        text: root.controlCustom
        color: Skin.white
        style: Text.Outline; styleColor: Skin.dark
        font.pointSize: root.width <= 200 ? 10 : 12
    }

    Text {
        anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: 6 }
        text: root.value.toFixed(2)
        color: Skin.white
        style: Text.Outline; styleColor: Skin.dark
        font.pointSize: root.width <= 200 ? 10 : 12
    }
}

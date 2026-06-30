/*
  * Slider control (refined):
  * - label (left) and value (right) sit on the row, on a neutral surface
  * - a slim accent fill + a small grip run along the bottom edge, so the
  *   handle never crosses the label and the accent stays calm
  */

import QtQuick
import QtQuick.Controls

import "qrc:/Utility/utility.js" as Utility
import Variable.Global 1.0

Slider {
    id: slider

    property string controlCustom
    property string controlDomain
    property string controlValueType
    property string controlValueData
    property int controlId
    property string controlUuid
    property string controlSurfacePath
    property color controlColor: Skin.orange

    implicitWidth: 300; implicitHeight: 20

    readonly property string valueText: controlUuid === Uuid.logFloatSliderUUID
                                        ? Utility.logSlider(value, from, to).toFixed(3)
                                        : value.toFixed(3)
    readonly property int labelSize: height <= 34 ? Skin.fontCaption : Skin.fontBody

    background: Rectangle {
        implicitWidth: parent.width; implicitHeight: parent.height
        color: Skin.gray2
        radius: 4

        // Slim value track along the bottom
        Rectangle {
            anchors { left: parent.left; right: parent.right; bottom: parent.bottom; margins: 4 }
            height: 5; radius: 2
            color: Skin.gray3
            Rectangle {
                width: slider.visualPosition * parent.width
                height: parent.height; radius: 2
                color: slider.controlColor
            }
        }
    }

    handle: Rectangle {
        x: 4 + slider.visualPosition * (slider.width - 8 - width)
        y: slider.height - height - 1
        width: 10; height: 10; radius: 5
        color: Skin.white
        border { color: slider.controlColor; width: 2 }
    }

    Text {
        anchors { left: parent.left; leftMargin: 6
                  verticalCenter: parent.verticalCenter; verticalCenterOffset: -3 }
        width: parent.width * 0.6
        text: slider.controlCustom
        color: Skin.white
        elide: Text.ElideRight
        font.pointSize: slider.labelSize
    }
    Text {
        anchors { right: parent.right; rightMargin: 6
                  verticalCenter: parent.verticalCenter; verticalCenterOffset: -3 }
        text: slider.valueText
        color: Skin.white
        font.pointSize: slider.labelSize
    }
}

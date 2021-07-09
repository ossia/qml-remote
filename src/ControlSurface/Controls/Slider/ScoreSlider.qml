/*
  * Slider control  :
  * - in a list of sliders in a control surface
  * - modify slider value in the remote modify
  * the value of this slider in score
  */

import QtQuick 2.0
import QtQuick.Controls 2.12

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

    handle: Rectangle {} // No handle

    background: Rectangle {
        implicitWidth: parent.width; implicitHeight: parent.height
        color: Skin.gray2
        border { color: controlColor; width: 1 }

        Rectangle {
            height: parent.height; width: slider.visualPosition * parent.width - y
            color: controlColor
        }
    }

    Text {
        anchors { left: parent.left; verticalCenter: parent.verticalCenter }
        text: ' ' + controlCustom + ':'
        color: Skin.white
        font.pointSize: parent.width <= 200
                        ? 10
                        : parent.width >= 500
                          ? parent.height / 2
                          : 15
    }

    Text {
        anchors { right: parent.right; verticalCenter: parent.verticalCenter }
        text: slider.controlUuid === Uuid.logFloatSliderUUID
              ? Utility.logSlider(slider.value, slider.from, slider.to).toFixed(3) + " "
              : slider.value.toFixed(3) + " "
        color: Skin.white
        font.pointSize: parent.width <= 200
                        ? 10
                        : parent.width >= 500
                          ? parent.height / 2
                          : 15
    }
}

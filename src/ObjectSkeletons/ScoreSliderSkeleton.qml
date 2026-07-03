/*
  * Slider skeleton (refined) used by ScoreSpeed / ScoreVolume / ScoreSpeeds.
  * Same layout as ScoreSlider: label + value on the row, slim accent fill and
  * a small grip along the bottom.
  */

import QtQuick
import QtQuick.Controls

import Variable.Global 1.0

Slider {
    id: control

    property string controlName: "ControlName"
    property string controlPath: "ControlPath"
    property int controlId
    property string controlUuid
    property string controlUnit: ""
    property color controlColor: Skin.orange

    implicitWidth: 300; implicitHeight: 20

    readonly property int labelSize: height <= 34 ? Skin.fontCaption : Skin.fontBody

    background: Rectangle {
        implicitWidth: parent.width; implicitHeight: parent.height
        color: Skin.gray2
        radius: 4

        Rectangle {
            anchors { left: parent.left; right: parent.right; bottom: parent.bottom; margins: 4 }
            height: 5; radius: 2
            color: Skin.gray3
            Rectangle {
                width: control.visualPosition * parent.width
                height: parent.height; radius: 2
                color: control.controlColor
            }
        }
    }

    handle: Rectangle {
        x: 4 + control.visualPosition * (control.width - 8 - width)
        y: control.height - height - 1
        width: 10; height: 10; radius: 5
        color: Skin.white
        border { color: control.controlColor; width: 2 }
    }

    Text {
        anchors { left: parent.left; leftMargin: 6
                  verticalCenter: parent.verticalCenter; verticalCenterOffset: -3 }
        width: parent.width * 0.6
        text: control.controlName
        color: Skin.white
        elide: Text.ElideRight
        font.pointSize: control.labelSize
        font.family: Skin.font
    }
    Text {
        anchors { right: parent.right; rightMargin: 6
                  verticalCenter: parent.verticalCenter; verticalCenterOffset: -3 }
        text: control.value.toFixed(3) + (control.controlUnit ? ' ' + control.controlUnit : '')
        color: Skin.white
        font.pointSize: control.labelSize
        font.family: Skin.monoFont
    }
}

import QtQuick 2.0
import QtQuick.Controls 2.12

Slider {
    property string controlName: "ControlName"
    property string controlPath: "ControlPath"
    property string controlId: "ControlId"
    property string controlUnit: ""
    property string controlColor: "#e0b01e"
    id: control
    //value: 0.5
    Text {
        text: ' ' + controlName + ':'
        color: "#ffedb6"
        font.bold: true
        width: control.width
    }
    Text {
        text: control.value.toFixed(3) + ' ' + controlUnit
        color: "#ffedb6"
        font.bold: true
        width: control.width
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
    }

    handle: Rectangle {} // No handle

    background: Rectangle {
        implicitWidth: 300
        implicitHeight: 20
        width: control.width
        height: control.height
        color: "#363636"
        border.width: 1
        border.color: controlColor

        Rectangle {

            width: control.visualPosition * parent.width - y
            height: parent.height
            color: controlColor
        }
    }
}

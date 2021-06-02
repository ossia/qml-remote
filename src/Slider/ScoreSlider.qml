import QtQuick 2.0
import QtQuick.Controls 2.12

Slider {
    implicitWidth: 300
    implicitHeight: 20
    property string controlName: "ControlName"
    property string controlPath: "ControlPath"
    property int controlId
    property string controlUuid
    property string controlUnit: ""
    property string controlColor: "#e0b01e"
    id: control

    Text {
        text: ' ' + controlName + ':'
        color: "#ffedb6"
        font.bold: true
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        font.pointSize: ((parent.height + parent.width) / 30) >= parent.height / 2 ? parent.height / 2 : (parent.height + parent.width) / 30.0
    }

    Text {
        text: control.value.toFixed(3) + ' ' + controlUnit
        color: "#ffedb6"
        anchors.right: parent.right
        font.bold: true
        font.pointSize: ((parent.height + parent.width) / 30) >= parent.height / 2 ? parent.height / 2 : (parent.height + parent.width) / 30.0
        anchors.verticalCenter: parent.verticalCenter
    }

    handle: Rectangle {} // No handle

    background: Rectangle {
        implicitWidth: parent.width
        implicitHeight: parent.height
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

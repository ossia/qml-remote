import QtQuick 2.0
import QtQuick.Controls 2.12

Slider {
    id: slider
    implicitWidth: 300
    implicitHeight: 20

    property string controlCustom
    property string controlDomain
    property string controlValueType
    property string controlValueData
    property int controlId
    property string controlUuid
    property string controlSurfacePath

    property color controlColor: "#e0b01e"

    Text {
        text: ' ' + controlCustom + ':'
        color: "#ffedb6"
        font.bold: true
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        font.pointSize: ((parent.height + parent.width) / 30) >= parent.height / 2 ? parent.height / 2 : (parent.height + parent.width) / 30.0
    }

    Text {
        text: slider.value.toFixed(3)
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
            width: slider.visualPosition * parent.width - y
            height: parent.height
            color: controlColor
        }
    }
}

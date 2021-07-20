/*
  * Volume of a scenario :
  * - contains a vertical slider, a name and a value
  */

import QtQuick 2.0
import QtQuick.Controls 2.2

import Variable.Global 1.0

import "qrc:/ObjectSkeletons"

Slider {

    id: scoreVolume

    property string controlName: "ControlName"
    property string controlPath: "ControlPath"
    property int controlId
    property string controlUuid
    property string controlUnit: ""
    property color controlColor: Skin.brown

    property string path: "first"
    property double totalVolume // The total speed goes from -120 to 600

    /*
    Connections {
        target:
        height: lView.height; width: 5 + window.width / 25


        // To have the path
        function onIntervalMessageReceived(m) {
            var IntervalsObject = m
            if (scoreVolume.path === "first") {
                // The global path is the first one to be created by score
                scoreVolume.path = JSON.stringify(m.Path)
            }
        }

        // To set the volume from score
        function onIntervalsMessageReceived(m) {
            var IntervalsObject = m.Intervals
            if (IntervalsObject[0] && scoreVolume.path === JSON.stringify(
                        IntervalsObject[0].Path)) {
                // The global path is the first one to be created by score
                scoreVolume.value = 1 - JSON.stringify(IntervalsObject[0].Gain)
            }
        }
    }
    */

    orientation: Qt.Vertical

    // Slider value
    Text {
        anchors {
            bottom: parent.top; bottomMargin: 5
            horizontalCenter: parent.horizontalCenter
        }
        text: scoreVolume.value.toFixed(3) + ' ' + controlUnit
        color: Skin.white
        font.pointSize: 10
    }

    // No handle
    handle: Rectangle {}

    background: Rectangle {
        implicitWidth: parent.width; implicitHeight: parent.height
        color: Skin.darkGray
        border { width: 1; color: controlColor }

        Rectangle {
            width: parent.width; height: parent.height * ( 1 - scoreVolume.visualPosition )
            anchors.bottom: parent.bottom
            color: controlColor
        }
    }

    /*
    // Sends a message to Score to update volume
    onMoved: {
        socket.sendTextMessage(
                    `{ "Message": "IntervalGain", "Path": ${scoreVolume.path}, "Gain": ${scoreVolume.value} }`)
    }
    */
}


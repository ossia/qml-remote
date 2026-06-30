/*
  * Timeline :
  * - Additional functionality compared to score
  * - modify its value in the remote modify the value in score
  */

import QtQuick
import QtQuick.Controls
import QtQml

import Variable.Global 1.0

Slider {
    id: time

    // By default, the total duration is set to 10 min
    property int totalTime: 10 * 60 * 1000

    // Receives a message from Score to update the current value IRT
    Connections {
        target: scoreTimeline
        function onIntervalsMessageReceived(m) {
            var IntervalsObject = m.Intervals
            time.value = IntervalsObject[0] ? JSON.stringify(IntervalsObject[0].Progress) : 0
        }
    }

    // Called by ScoreStop
    function stopTimeline() {
        time.value = 0
    }

    // Convert milliseconds to a hh:mm:ss.zz format
    function msToTime(duration, currentDate) {
        var milliseconds = parseInt( ( duration % 1000 ) / 100 ),
        seconds = Math.floor((duration / 1000) % 60),
        minutes = Math.floor((duration / (1000 * 60)) % 60),
        hours = Math.floor((duration / (1000 * 60 * 60)) % 24)

        hours = (hours < 10) ? "0" + hours : hours
        minutes = (minutes < 10) ? "0" + minutes : minutes
        seconds = (seconds < 10) ? "0" + seconds : seconds

        return hours + ":" + minutes + ":" + seconds + "." + milliseconds
    }

    value: 0
    implicitWidth: window.width
    implicitHeight: Math.max(Skin.minTouch, window.height <= 600 ? 25 : 5 + window.height / 25)

    // Sends a message to Score to update its progress' timeline
    onMoved: {
        socket.sendTextMessage(
                    `{ "Message": "Transport", "Milliseconds": ${time.value * time.totalTime}}`)
    }

    // No handle
    handle: Rectangle {}

    background: Rectangle {
        implicitWidth: parent.width; implicitHeight: parent.height
        color: Skin.gray2
        border { width: 1; color: Skin.gray3 }

        Rectangle {
            width: time.visualPosition * parent.width - y; height: parent.height
            color: Skin.green2
        }
    }

    // Basically the slider's ratio times the totalTime (ms) gives the elasped time (ms)
    // Which must then be converted into a date type
    // Readable time chip (legible over both the track and the progress fill)
    Rectangle {
        anchors.centerIn: parent
        width: timeLabel.implicitWidth + 16
        height: timeLabel.implicitHeight + 4
        radius: 4
        color: Qt.rgba(0, 0, 0, 0.5)

        Text {
            id: timeLabel
            anchors.centerIn: parent
            text: msToTime(time.value * totalTime)
            color: Skin.white
            font.pointSize: time.height <= 0 ? 1 : Math.max(8, time.height / 2.8)
        }
    }
}

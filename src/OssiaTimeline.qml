import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQml 2.15


Slider {
    property int totalTime: 10 * 60 * 1000 // By default, the total duration is set to 10 min
    id: time
    value: 0
    implicitWidth: window.width
    implicitHeight: 20

    // Sends a message to Score to update its progress' timeline
    onMoved: {
        socket.sendTextMessage(('{ "Message": "Transport", "Milliseconds":').concat(time.value * time.totalTime, '}'));
        // console.log(('{ "Message": "Transport", "Milliseconds":').concat(time.value * time.totalTime, '}'));
    }

    // Receives a message from Score to update the current value IRT
    Connections {
        target: ossiaTimeline
        function onIntervalsMessageReceived(m) {
            var IntervalsObject = m.Intervals;
            if (IntervalsObject[0]) {
                // The timeline is positioned first in the JSON file
                time.value = JSON.stringify(IntervalsObject[0].Progress);
            }
        }
    }

    // Called by OssiaStop
    function stopTimeline() {
        time.value = 0;
    }

    // Convert milliseconds to a hh:mm:ss.zz format
    function msToTime(duration, currentDate) {
        var milliseconds = parseInt((duration % 1000) / 100),
        seconds = Math.floor((duration / 1000) % 60),
        minutes = Math.floor((duration / (1000 * 60)) % 60),
        hours = Math.floor((duration / (1000 * 60 * 60)) % 24);

        hours = (hours < 10) ? "0" + hours : hours;
        minutes = (minutes < 10) ? "0" + minutes : minutes;
        seconds = (seconds < 10) ? "0" + seconds : seconds;

        return hours + ":" + minutes + ":" + seconds + "." + milliseconds;
    }

    Text {
        // Basically the slider's ratio times the totalTime (ms) gives the elasped time (ms)
        // Which must then be converted into a date type
        text: msToTime(time.value * totalTime)
        color: "#f0f0f0"
        font.bold: true
        width: time.width
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    handle: Rectangle {} // No handle

    background: Rectangle {
        implicitWidth: 300
        implicitHeight: 20
        width: time.width
        height: time.height
        color: "#161514"
        border.width: 1
        border.color: "#62400a"

        Rectangle {
            width: time.visualPosition * parent.width - y
            height: parent.height
            color: "#62400a"
        }
    }

}

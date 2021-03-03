import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQml 2.15


Slider {
    property int totalTime: 10 * 60 * 1000 // assuming totalTime is given by ossia in milliseconds
    property date currentDate: new Date() // useless at some point
    id: time
    value: 0
    implicitWidth: window.width
    implicitHeight: 20

    Connections {
        target: ossiaTimeline
        function onIntervalsMessageReceived(m) {
            var IntervalsObject = m.Intervals;
            if (IntervalsObject[0]) {
                var progress = JSON.stringify(IntervalsObject[0].Progress); // The timeline is positioned first
                time.value = progress
            }
          }
    }

    function stopTimeline() {
        time.value = 0;
    }

    function msToDate(duration, currentDate) {
        var milliseconds = parseInt((duration % 1000) / 100),
        seconds = Math.floor((duration / 1000) % 60),
        minutes = Math.floor((duration / (1000 * 60)) % 60),
        hours = Math.floor((duration / (1000 * 60 * 60)) % 24);

        hours = (hours < 10) ? "0" + hours : hours;
        minutes = (minutes < 10) ? "0" + minutes : minutes;
        seconds = (seconds < 10) ? "0" + seconds : seconds;

        currentDate.setHours(hours);
        currentDate.setMinutes(minutes);
        currentDate.setSeconds(seconds);
        currentDate.setMilliseconds(milliseconds);

        return hours + ":" + minutes + ":" + seconds + "." + milliseconds;
    }

    Text {
        // Basically the slider's ratio times the totalTime (ms) gives the elasped time (ms)
        // Which must then be converted into a date type
        text: msToDate(time.value * totalTime, currentDate)
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
            width: time.visualPosition * parent.width - y // Changes with time
            height: parent.height
            color: "#62400a"
        }
    }

}

import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQml 2.15


Slider {
    property int totalTime: 10 * 60 * 1000 // assuming totalTime is given by ossia in milliseconds
    property date currentDate: new Date()
    id: time
    value: 0
    implicitWidth: window.width
    implicitHeight: 20

    // Let's say state is an enumerate : Play: 0, Pause: 1, Stop: 2
    function ossiaChangeState(state) {
        switch (state) {
        case 0:
            /* TODO:
              * If timeline already playing then nothing
              * If timeline
              */
            break;
        case 1:
            break;
        case 2:
            break;
        default:

        }
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
            width: time.visualPosition * parent.width - y
            height: parent.height
            color: "#62400a"
        }
    }
}

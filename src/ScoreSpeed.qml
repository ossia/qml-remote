import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQml 2.12

ScoreSlider{
    id: globalSpeed
    anchors.right: parent.right
    controlName: "Speed"
    height: 20; width: window.width/4
    from: -120
    value: 100
    to: 600
    property var path;
    controlColor: "#62400a"

    // Sends a message to Score to update its progress' timeline
    onMoved: {
        socket.sendTextMessage(('{ "Message": "IntervalSpeed", "Path":'.concat(globalSpeed.path, ', "Speed": ',globalSpeed.value*6/720, '}')))
    }

    Connections {
        target: ossiaSpeed
        function onIntervalMessageReceived(m) {
            var IntervalsObject = m.Intervals;
            console.log('speed changed on score');
            console.log(m);
            console.log('fin de message');
            if (globalSpeed.path == null){ // The global path is the first one to be created by score
                globalSpeed.value = JSON.stringify(m.Speed)*720/6;
                globalSpeed.path = JSON.stringify(m.Path);
            }

        }
    }

    Connections {
        target: scoreSpeed
        function onIntervalsMessageReceived(m) {
            var IntervalsObject = m.Intervals;
            if (IntervalsObject[0] && globalSpeed.path === JSON.stringify(IntervalsObject[0].Path)){ // The global path is the first one to be created by score
                globalSpeed.value = JSON.stringify(IntervalsObject[0].Speed)*720/6;
            }
        }
    }
}

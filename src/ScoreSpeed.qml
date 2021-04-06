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
    property var path: "5";
    controlColor: "#62400a"
    property double totalSpeed: globalSpeed.value*6/720; // The total speed goes from -120 to 600

    // Sends a message to Score to update its progress' timeline
    onMoved: {
        socket.sendTextMessage(('{ "Message": "IntervalSpeed", "Path":'.concat(globalSpeed.path, ', "Speed": ',globalSpeed.value*6/720, '}')))
    }

    //to have the path
    Connections {
        target: scoreSpeed
        function onIntervalMessageReceived(m) {
            var IntervalsObject = m;
            if (globalSpeed.path === "5"){ // The global path is the first one to be created by score
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


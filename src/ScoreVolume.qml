import QtQuick 2.0
import QtQuick.Layouts 1.12


ScoreSlider{
    id: scoreGlobalVolume
    anchors.horizontalCenter: parent.horizontalCenter
    controlName: "Volume"
    controlUnit: "dB "
    height: 20; width: window.width/4
    controlColor: "#62400a"
    from: -40
    value: -20
    to: 0
    property var path: "5";
    property double totalVolume; // The total speed goes from -120 to 600

    // Sends a message to Score to update volume

    onMoved: {
        socket.sendTextMessage(('{ "Message": "IntervalGain", "Path":'.concat(scoreGlobalVolume.path, ', "Gain": ',scoreGlobalVolume.value, '}')))
    }

    //to have the path
    Connections {
        target: scoreVolume
        function onIntervalMessageReceived(m) {
            var IntervalsObject = m;
            if (scoreGlobalVolume.path === "5"){ // The global path is the first one to be created by score
                scoreGlobalVolume.path = JSON.stringify(m.Path);
            }

        }
    }

    Connections {
        target: scoreVolume
        function onIntervalsMessageReceived(m) {
            var IntervalsObject = m.Intervals;
            if (IntervalsObject[0] && scoreGlobalVolume.path === JSON.stringify(IntervalsObject[0].Path)){ // The global path is the first one to be created by score
                scoreGlobalVolume.value = 1 -  JSON.stringify(IntervalsObject[0].Gain);
            }
        }
    }
}

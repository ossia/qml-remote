import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQml 2.15

OssiaSlider{
    id: speed
    anchors.right: parent.right
    controlName: "Speed"
    height: 20; width: window.width/4
    controlColor: "#62400a"
    property double totalSpeed: speed.value*720 - 120; // The total speed goes from -120 to 600

    // Sends a message to Score to update its progress' timeline
    onMoved: {
        socket.sendTextMessage(('{ "Message": "IntervalSpeed", "Path": "Scenario::ScenarioDocumentModel.1/Scenario::BaseScenario.0/Scenario::IntervalModel.0/", "Speed": ').concat(speed.value));
        //console.log(('{ "Message": "IntervalSpeed", "Path": "Scenario::ScenarioDocumentModel.1/Scenario::BaseScenario.0/Scenario::IntervalModel.0/", "Speed":').concat(speed.value));
    }

    /*Connections {
        target: ossiaSpeed
        function onSpeedMassageReceived(m) {
            var IntervalsObject = m.Intervals;
            console.log('speed changed on score');
            if (IntervalsObject[3]) {
                // position of speed in the JSON file?
                speed.value = JSON.stringify(IntervalsObject[3].Progress);
            }
        }

    }*/
}


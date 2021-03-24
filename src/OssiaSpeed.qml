import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQml 2.15

OssiaSlider{
    id: globalSpeed
    anchors.right: parent.right
    controlName: "Speed"
    height: 20; width: window.width/4
    from: -120
    value: 100
    to: 600
    controlColor: "#62400a"
    property double totalSpeed: globalSpeed.value*720 - 120; // The total speed goes from -120 to 600

    // Sends a message to Score to update its progress' timeline
    onMoved: {
        console.log("Speeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeed")
        console.log(('{ "Message": "IntervalSpeed", "Path":"Scenario::ScenarioDocumentModel.1/Scenario::BaseScenario.0/Scenario::IntervalModel.0/", "Speed": ').concat(globalSpeed.value*6/720, '}'));
        console.log("Speeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeed")
        socket.sendTextMessage(('{ "Message": "IntervalSpeed", "Path":"Scenario::ScenarioDocumentModel.1/Scenario::BaseScenario.0/Scenario::IntervalModel.0/", "Speed": ').concat(globalSpeed.value, '}'));


    }

    Connections {
        target: ossiaSpeed
        function onIntervalMessageReceived(m) {
            var IntervalsObject = m.Intervals;
            console.log('speed changed on score');
            globalSpeed.value = JSON.stringify(m.Speed)*720/6;
        }
    }
}


import QtQuick 2.0
import QtQuick.Layouts 1.12


ScoreSlider{
    id: scoreVolume
    anchors.horizontalCenter: parent.horizontalCenter
    controlName: "Volume"
    controlUnit: "dB"
    height: 20; width: window.width/4
    controlColor: "#62400a"
}


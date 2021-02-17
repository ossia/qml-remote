import QtQuick 2.12
import QtQuick.Controls 2.12


Button {
    property string sliderName: "sliderName"

    id: slider
    contentItem: Text {
        text: sliderName
        color: "#ffffff"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        border.color : "black" // separation entre triggers
        implicitWidth: window.width/10
        implicitHeight: window.height/5
        color: "#303030"
        radius: 10
        Image{
            x: 5
            y: 5
            source:"Icons/scenario_trigger.svg"
        }
    }
}


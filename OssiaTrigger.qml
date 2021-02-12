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
        implicitWidth: area.width/10
        implicitHeight: 9*area.height/10
        color: "#303030"
        radius: 10
    }
}



import QtQuick 2.0
import QtQuick.Layouts 1.12

Item{

    ScoreTriggers{
        id: scoreTrigger
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: scoreSpeed.left
        anchors.rightMargin: window.width/100
        anchors.bottom: parent.bottom
    }

    ScoreSpeeds{
        id:scoreSpeeds
        anchors.right: parent.right
    }

    function clearSpeedsListModel() {
        scoreSpeeds.clearSpeedsListModel()
    }
    }

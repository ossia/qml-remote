import QtQuick 2.0
import QtQuick.Layouts 1.12

import "../Trigger"
import "../Speeds"

Item {
    ScoreTriggers {
        id: scoreTrigger
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: scoreSpeeds.left
        anchors.rightMargin: 5
        anchors.bottom: parent.bottom
    }

    ScoreSpeeds {
        id: scoreSpeeds
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
    }

    function clearSpeedsListModel() {
        scoreSpeeds.clearSpeedsListModel()
    }
}

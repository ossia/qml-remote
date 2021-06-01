import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.1
import QtQuick.Controls 2.2
import QtQuick.Window 2.12
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.12

import "../Slider"

Rectangle {
    id: scoreSpeeds
    width: parent.width / 3
    height: parent.height
    color: "#202020"
    anchors.right: parent.right
    ListView {
        id: lView
        spacing: 10
        anchors.fill: parent
        anchors.margins: 5
        clip: true
        snapMode: ListView.SnapToItem
        // Create a list of sliders for the intervals' speeds
        model: ListModel {
            id: intervalsListModel
            // Initialized on false in order to know if the first (and main) interval has been added or not
            property bool hasStarted: false
            property string globalSpeedPath: "null"
        }
        delegate: ScoreSlider {
            id: speed
            controlName: name
            height: window.height / 25
            anchors.right: parent ? parent.right : undefined
            anchors.left: parent ? parent.left : undefined
            anchors.rightMargin: 25
            from: -120
            value: speedValue
            to: 600
            controlColor: "#62400a"
            controlPath: path
            // Managing the speeds from the app
            onMoved: {
                socket.sendTextMessage(
                            ('{ "Message": "IntervalSpeed", "Path":'.concat(
                                 speed.controlPath, ', "Speed": ',
                                 speed.value * 6 / 720, '}')))
            }
        }
        ScrollBar.vertical: ScrollBar {
            id: scrollBar
            width: 20
            anchors.right: parent.right
            policy: ScrollBar.AlwaysOn
            contentItem: Rectangle {
                radius: width / 2
                color: "#303030"
            }
        }
    }
    // Receiving and handling messages about intervals
    Connections {
        target: scoreTimeSet
        function onIntervalMessageReceived(m) {
            var messageObject = m.Message
            if (messageObject === "IntervalAdded") {
                // Adding an interval speed


                /* The timeline is a global interval
                  * The name of the timeline changes everytime ossia is refreshed...
                  * The only constant is that it contains "Untitled"
                  * The timeline should not be added with the other speeds */
                if (!(intervalsListModel.hasStarted)) {
                    intervalsListModel.hasStarted = true
                    intervalsListModel.globalSpeedPath = JSON.stringify(m.Path)
                    scoreTimeline.totalTime = m.DefaultDuration
                } else {
                    intervalsListModel.insert(0, {
                                                  "name": m.Name,
                                                  "path": JSON.stringify(
                                                              m.Path),
                                                  "speedValue": JSON.stringify(
                                                                    m.Speed) * 720 / 6
                                              })
                }
            } else if (messageObject === "IntervalRemoved") {
                // Removing an interval speed
                if (JSON.stringify(
                            m.Path) === intervalsListModel.globalSpeedPath) {
                    intervalsListModel.hasStarted = false
                } else {
                    function find(cond) {
                        for (var i = 0; i < intervalsListModel.count; ++i)
                            if (cond(intervalsListModel.get(i)))
                                return i
                        return null
                    }
                    var s = find(function (item) {
                        return item.path === JSON.stringify(m.Path)
                    }) //the index of m.Path in the listmodel
                    if (s !== null) {
                        intervalsListModel.remove(s)
                    }
                    // manque traitement a faire (passer la bonne vitesse de lecture .. )
                }
            }
        }
    }

    Connections {
        target: scoreTimeSet
        // Modifying an interval speed
        function onIntervalsMessageReceived(m) {
            var IntervalsObject = m.Intervals
            var count = 0
            while (IntervalsObject[count]) {
                for (var i = 0; i < intervalsListModel.count; ++i) {
                    if (intervalsListModel.get(i).path === JSON.stringify(
                                IntervalsObject[count].Path)) {
                        // The global path is the first one to be created by score
                        intervalsListModel.set(i, {
                                                   "speedValue": JSON.stringify(
                                                                     IntervalsObject[count].Speed)
                                                                 * 720 / 6
                                               })
                    }
                }
                count++
            }
        }
    }

    // Called by OssiaStop
    function clearSpeedsListModel() {
        intervalsListModel.clear()
        intervalsListModel.hasStarted = false
    }
}

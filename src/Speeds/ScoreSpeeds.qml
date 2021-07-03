/*
  * List of interval speeds  :
  * - at the top right of the interface
  * - modify a interval speed value in the remote modify
  * the value of this interval speed in score
  */

import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.1
import QtQuick.Controls 2.2
import QtQuick.Window 2.12
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.12


import "qrc:/ObjectSkeletons"
import Variable.Global 1.0

Rectangle {
    id: scoreSpeeds
    color: Skin.darkGray

    ListView {
        id: lView
        spacing: 10
        clip: true
        snapMode: ListView.SnapToItem
        height: parent.height
        anchors.right: scrollBar.left
        anchors.left: parent.left
        anchors.rightMargin: 5

        // Create a list of sliders for the intervals' speeds
        model: ListModel {
            id: intervalsListModel
            // Initialized on false in order to know if the first (and main) interval has been added or not
            property bool hasStarted: false
            property string globalSpeedPath: "null"
        }

        delegate: ScoreSliderSkeleton {
            id: speed
            controlName: name
            height: 5 + window.height / 25
            width: lView.width
            from: -120
            value: speedValue
            to: 600
            controlColor: Skin.brown
            controlPath: path
            // Managing the speeds from the app
            onMoved: {
                socket.sendTextMessage(
                            ('{ "Message": "IntervalSpeed", "Path":'.concat(
                                 speed.controlPath, ', "Speed": ',
                                 speed.value * 6 / 720, '}')))
            }
        }

        ScrollBar.vertical: scrollBar
    }

    ScrollBar {
            id: scrollBar
            active: true
            visible: lView.count > 0
            width: window.width <= 500 ? 20 : 30
            height: parent.height

            anchors.right: parent.right
            policy: ScrollBar.AsNeeded
            snapMode: ScrollBar.SnapAlways
            contentItem: Rectangle {
                id: scrollBarContentItem
                visible: scrollBar.size >= 1 ? false : true
                color: scrollBar.pressed ? Skin.orange : "#808080"
            }

            background: Rectangle {
                id: scrollBarBackground
                width: scrollBarContentItem.width
                anchors.fill: parent
                color: Skin.darkGray
                border.color: Skin.dark
                border.width: 2
            }
    }

    // Receiving and handling messages about intervals
    Connections {
        target: scoreSpeeds
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
        target: scoreSpeeds
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

        // Clear the speed list when the remote is disconnected from score
        function onClearSpeedList() {
            intervalsListModel.clear()
            intervalsListModel.hasStarted = false
        }
    }
}

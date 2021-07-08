/*
  * List of triggers  :
  * - at the top left of the interface
  * - pressed the trigger button in the remote trigger the event in score
  */

import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.12

import "qrc:/Utility/utility.js" as Utility
import Variable.Global 1.0

Rectangle {

    // Receiving informations about trigger from score
    Connections {
        target: scoreTriggers
        function onTriggerMessageReceived(m) {
            var messageObject = m.Message
            // Adding a trigger
            if (messageObject === "TriggerAdded") {
                triggerslistModel.insert(0, {
                                             "name": m.Name,
                                             "path": JSON.stringify(m.Path)
                                         })
            }
            // Removing a trigger
            else if (messageObject === "TriggerRemoved") {
                //the index of m.Path in the listmodel
                var s = Utility.find(triggerslistModel, function (item) {
                    return item.path === JSON.stringify(m.Path)
                })
                if (s !== null) {
                    triggerslistModel.remove(s)
                }
            }
        }

        // Clear the trigger list when the remote is disconnected from score
        function onClearTriggerList() {
            triggerslistModel.clear()
        }
    }

    radius: 9
    color: Skin.darkGray

    ListView {
        id: triggerslist

        height: parent.height
        anchors {left: parent.left; right: scrollBar.left; rightMargin: 5}
        orientation: ListView.Vertical
        clip: true
        spacing: 10
        snapMode: ListView.SnapToItem
        ScrollBar.vertical: scrollBar

        model: ListModel {
            id: triggerslistModel
        }

        delegate: ScoreTrigger {
            width: triggerslist.width;  height: 5 + window.height / 25
            scorePath: path
            triggerName: name
        }
    }

    ScrollBar {
        id: scrollBar

        width: window.width <= 500 ? 20 : 30; height: parent.height
        anchors.right: parent.right
        active: triggerslist.count > 0
        visible: triggerslist.count > 0
        policy: ScrollBar.AsNeeded
        snapMode: ScrollBar.SnapAlways

        contentItem: Rectangle {
            id: scrollBarContentItem

            visible: scrollBar.size < 1
            color: scrollBar.pressed ? Skin.orange : Skin.lightGray
        }

        background: Rectangle {
            id: scrollBarBackground

            width: scrollBarContentItem.width
            anchors.fill: parent
            color: Skin.darkGray
            border { color: Skin.dark; width: 2 }
        }
    }
}

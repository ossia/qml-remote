/*
  * List of triggers :
  * - at the top left of the interface
  * - pressed the trigger button in the remote triggers the event in score
  */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQml.Models

import "qrc:/Utility/utility.js" as Utility
import Variable.Global 1.0

Rectangle {

    property alias count: triggerList.count

    // Receiving information about trigger from score
    Connections {
        target: scoreTriggers
        function onTriggerMessageReceived(m) {
            var messageObject = m.Message
            // Adding a trigger
            if (messageObject === "TriggerAdded") {
                triggerListModel.insert(0, {
                                             "name": m.Name,
                                             "path": JSON.stringify(m.Path)
                                         })
            }
            // Removing a trigger
            else if (messageObject === "TriggerRemoved") {
                //the index of m.Path in the listmodel
                var s = Utility.find(triggerListModel, function (item) {
                    return item.path === JSON.stringify(m.Path)
                })
                if (s !== null) {
                    triggerListModel.remove(s)
                }
            }
        }

        // Clear the trigger list when the remote is disconnected from score
        function onClearTriggerList() {
            triggerListModel.clear()
        }
    }

    radius: 9
    color: Skin.darkGray

    // Panel header
    Text {
        id: header
        anchors { top: parent.top; left: parent.left; right: parent.right
                  topMargin: 6; leftMargin: 8; rightMargin: 8 }
        text: qsTr("Triggers")
        color: Skin.lightGray
        font.pointSize: Skin.fontCaption
        font.family: Skin.font
        font.capitalization: Font.AllUppercase
        font.bold: true
        elide: Text.ElideRight
    }

    ListView {
        id: triggerList

        anchors { top: header.bottom; bottom: parent.bottom; topMargin: 4; bottomMargin: 4
                  left: parent.left; right: scrollBar.left; rightMargin: 5 }
        orientation: ListView.Vertical
        clip: true
        spacing: 10
        snapMode: ListView.SnapToItem
        ScrollBar.vertical: scrollBar

        model: ListModel {
            id: triggerListModel
        }

        delegate: ScoreTrigger {
            width: triggerList.width;  height: Math.max(Skin.minTouch, 5 + window.height / 25)
            scorePath: path
            triggerName: name
        }
    }

    ScrollBar {
        id: scrollBar

        width: window.width <= 500 ? 20 : 30
        anchors { top: header.bottom; bottom: parent.bottom; topMargin: 4; bottomMargin: 4
                  right: parent.right }
        active: triggerList.count > 0
        visible: triggerList.count > 0
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

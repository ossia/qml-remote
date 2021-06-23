import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.12

Rectangle {
    radius: 9
    color: "#202020"

    ListView {
        id: triggerslist
        anchors.left: parent.left
        anchors.right: scrollBar.left
        anchors.rightMargin: 5
        height: parent.height
        orientation: ListView.Vertical
        clip: true
        spacing: 10
        snapMode: ListView.SnapToItem
        model: ListModel {
            id: triggerslistModel
        }

        delegate: ScoreTrigger {
            scorePath: path
            width: triggerslist.width
            height: 5 + window.height / 25
            triggerName: name
        }

        ScrollBar.vertical: scrollBar
    }

    ScrollBar {
            id: scrollBar
            active: triggerslist.count > 0
            visible: triggerslist.count > 0
            width: window.width <= 500 ? 20 : 30
            height: parent.height

            anchors.right: parent.right
            policy: ScrollBar.AsNeeded
            snapMode: ScrollBar.SnapAlways
            contentItem: Rectangle {
                id: scrollBarContentItem
                visible: scrollBar.size >= 1 ? false : true
                color: scrollBar.pressed ? "#f6a019" : "#808080"
            }

            background: Rectangle {
                id: scrollBarBackground
                width: scrollBarContentItem.width
                anchors.fill: parent
                color: "#202020"
                border.color: "#101010"
                border.width: 2
            }
    }

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
            } // Removing a trigger
            else if (messageObject === "TriggerRemoved") {
                function find(cond) {
                    for (var i = 0; i < triggerslistModel.count; ++i)
                        if (cond(triggerslistModel.get(i)))
                            return i
                    return null
                }
                //the index of m.Path in the listmodel
                var s = find(function (item) {
                    return item.path === JSON.stringify(m.Path)
                })
                if (s !== null) {
                    triggerslistModel.remove(s)
                }
            }
        }
    }
}

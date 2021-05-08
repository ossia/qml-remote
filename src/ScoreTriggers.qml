import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.12

Rectangle {
    radius: 9
    color: "#202020"
    anchors.fill: parent

    ListView {
        id: triggerslist
        width: parent.width
        height: parent.height
        orientation: ListView.Horizontal
        clip: true
        spacing: 5
        snapMode: ListView.SnapToItem
        model: ListModel {
            id: triggerslistModel
        }

        delegate: ScoreTrigger {
            scorePath: path
            height: triggerslist.height
            triggerName: name
        }
    }

    // Receiving informations about trigger from score
    Connections {
        target: scoreTimeSet
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

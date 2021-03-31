import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.1
import QtQuick.Controls 2.2

import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.12

Rectangle {
    id: speedList
    width: parent.width / 4
    height: parent.height
    color: "#202020"
    anchors.right: parent.right
    ListView {
        id: lView
        //width: speedList.width
        //height:speedList.height
        spacing: 10
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        //anchors.topMargin: parent.height/40
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        anchors.topMargin: 5
        anchors.bottomMargin: 5
        orientation: ListView.Vertical
        clip: true
        snapMode: ListView.SnapToItem

        model: ListModel {
            id: intervalsListModel

            /*ListElement {
                name: "Interval1"
            }
            ListElement {
                name: "Interval2"
            }
            ListElement {
                name: "Interval3"
            }
            ListElement {
                name: "Interval4"
            }
            ListElement {
                name: "Interval5"
            }
            ListElement {
                name: "Interval6"
            }*/
        }
        delegate: ScoreSlider {
            id: speed
            controlName: name
            height: 20
            anchors.right: parent.right
            anchors.rightMargin: 25
            anchors.left: parent.left
            controlColor: "#62400a"
            property var path : path;
            value : value;
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
    property int nb_interval : -1; // the first interval is the timeline's one, it will initialize the counter to 0
    //implementation de la fonction
    Connections {
        target: ossiaTimeSet

        function onIntervalMessageReceived(m) {
            var messageObject = m.Message
            if(messageObject === "IntervalAdded"){
                if (speedList.nb_interval === -1) {
                    //ossiaTimeline.totalTime = m.DefaultDuration;
                    speedList.nb_interval = 0;
                    /* I have to admit
                          * Niveau encapsulation on est bof :shrug: */
                } else {
                    intervalsListModel.insert(speedList.nb_interval, {
                                                  name:JSON.stringify(m.Name),path:JSON.stringify(m.Path),value:JSON.stringify(m.Speed)
                                              });
                    console.log(intervalsListModel[speedList.nb_interval]);
                    speedList.nb_interval++;
                }
            }
            else if(messageObject === "IntervalRemoved"){
                function find(cond) {
                    for(var i = 0; i < speedList.nb_interval; ++i) if (cond(triggerslistModel.get(i))) return i;
                    return null
                }
                var s = find(function (item) {
                    return item.path === JSON.stringify(m.Path)
                }) //the index of m.Path in the listmodel
                if(s !== null){
                    intervalsListModel.remove(s);
                    speedList.nb_interval --;
                }
                // manque traitement a faire (passer la bonne vitesse de lecture .. )
            }

        }
    }
}

import QtQuick 2.0
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.1
import QtQuick.Controls 2.2

import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.15

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

            ListElement {
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
            }
        }
        delegate: OssiaSlider {
            id: speed
            controlName: name
            height: 20
            anchors.right: parent.right
            anchors.rightMargin: 25
            anchors.left: parent.left
            controlColor: "#62400a"
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
    //implementation de la fonction
    Connections {
        target: ossiaTimeSet

        function find(cond) {
            for (var i = 0; i < intervalsListModel.count; ++i) {
                if (cond(intervalsListModel.get(i)))
                    return i;
            }
            return null;
        }

        function onIntervalMessageReceived(m) {
            var messageObject = m.Message;

            switch (messageObject) {
            case "IntervalAdded":
                /* The timeline is a global interval
                      * The name of the timeline changes everytime ossia is refreshed...
                      * The only constant is that it contains "Untitled"
                      * The timeline should not be added with the other speeds */
                if (m.Name.includes("Untitled")) {
                    ossiaTimeline.totalTime = m.DefaultDuration;
                    /* I have to admit
                          * Niveau encapsulation on est bof :shrug:
                          */

                } else {
                    intervalsListModel.insert(0, {
                                                  "name": JSON.stringify(m.Path)
                                              });
                }
                break;
            case "IntervalRemoved":
                var s = find(function (item) {
                    return item.name === JSON.stringify(m.Path)
                }) //the index of m.Path in the listmodel

                intervalsListModel.setProperty(s, "name", "desactivated")
                // manque traitement a faire (passer la bonne vitesse de lecture .. )
                break;
            default:
            }

        }
    }
}

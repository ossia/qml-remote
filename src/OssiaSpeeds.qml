import QtQuick 2.0
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.1
import QtQuick.Controls 2.2

import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.15

Rectangle{
    id: speedList
    width: parent.width/4
    height:parent.height
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

                model:ListModel {
                    id: triggerslist

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
          delegate:OssiaSlider{
              id: speed
              controlName: name
              height:20
              width: speedList.width*0.8
              controlColor: "#62400a"
          }
        ScrollBar.vertical: ScrollBar {
            id: scrollBar
            width: speedList.width/10
            anchors.right:  parent.right
            policy:  ScrollBar.AlwaysOn
            contentItem: Rectangle {
                radius: width / 2
                color: "#303030"
            }
        }
    }
}

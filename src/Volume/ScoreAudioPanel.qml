/*
  * Audio mixing panel :
  * - contains the interval volumes
  */

import QtQuick 2.0
import QtQuick.Controls 2.2

import "qrc:/ObjectSkeletons"

import Variable.Global 1.0

Rectangle {
    id: scoreAudioPanel

    color: Skin.darkGray

    Button {
        id: button

        width: 50; height: 50
        onClicked: {
            listModel.insert(0, { })
            /*
            onClicked: listModel.insert(0, {
                                            "name": "azeretr",
                                            "path": "azert",
                                            "speedValue": 0
                                        })
                                        */
        }

        background: Rectangle { id: zone; color: Skin.gray1 }
    }

    ListView {
        id: lView

        height: parent.height
        anchors {
            left: parent.left; right: parent.right;
            top: button.bottom; bottom: scrollBar.top; rightMargin: 5
        }
        spacing: 10
        clip: true
        snapMode: ListView.SnapToItem
        interactive: scrollBar.size < 1
        ScrollBar.horizontal: scrollBar
        orientation: ListView.Horizontal

        // Create a list of sliders for the intervals' speeds
        model: ListModel {
            id: listModel
        }

        delegate: Rectangle {
            width: 100 //window.width < 600 ? 100 : 2 * ( 5 + window.width / 25 )
            anchors {
                bottom: parent.bottom; top: parent.top
                bottomMargin: 5; topMargin: 5
            }
            color: Skin.gray1

            Rectangle {

                height: 30
                anchors {
                    left: parent.left; right: parent.right
                    top: parent.top; margins: 5
                }
                color: Skin.darkGray

                // Slider name
                Text {
                    anchors {
                        fill: parent; margins: 5
                        horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCente
                    }
                    text: "Volume111111111"
                    clip: true
                    color: Skin.white
                    font.pointSize: 10
                }
            }

            ScoreVolume {
                id: volume

                width: parent.width / 2; height: 3 * parent.height / 4
                anchors {
                    bottom: parent.bottom
                    bottomMargin: 5; topMargin: 5
                    horizontalCenter: parent.horizontalCenter
                }
                from: -120; value: 10; to: 600
            }
        }
    }

    ScrollBar {
        id: scrollBar

        width: parent.width; height: window.height <= 500 ? 20 : 30
        anchors { right: parent.right; bottom: parent.bottom }
        active: scrollBar.size < 1
        visible: scrollBar.size < 1
        interactive: scrollBar.size < 1
        policy: ScrollBar.AsNeeded
        snapMode: ScrollBar.SnapAlways
        orientation: Qt.Horizontal

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
            border { color: Skin.dark; width: 2}
        }
    }
}

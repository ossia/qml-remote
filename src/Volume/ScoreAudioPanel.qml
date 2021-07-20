/*
  * Audio mixing panel
  */

import QtQuick 2.0
import QtQuick.Controls 2.2

import "qrc:/ObjectSkeletons"

import Variable.Global 1.0

Rectangle {
    id: scoreAudioPanel

    color: Skin.darkGray

    /*
    color: Skin.darkGray

    ListView {
        id: lView

        height: parent.height
        anchors { left: parent.left; right: scrollBar.left; rightMargin: 5}
        spacing: 10
        clip: true
        snapMode: ListView.SnapToItem
        ScrollBar.vertical: scrollBar

        // Create a list of sliders for the intervals' speeds
        model: ListModel {
            id: listModel
        }

        delegate: ScoreSliderSkeleton {
            id: speed

            height: 5 + window.height / 25; width: lView.width
            controlName: name
            from: -120; value: speedValue; to: 600
        }
    }

    ScrollBar {
        id: scrollBar

        width: window.width <= 500 ? 20 : 30; height: parent.height
        anchors.right: parent.right
        active: true
        visible: lView.count > 0
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
            border { color: Skin.dark; width: 2}
        }
    }
    */
}

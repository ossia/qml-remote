/*
  * List of control surfaces :
  * - it is the element that takes up the most space on the screen
  * - it locates in the middle below the buttons and the lists of trigger and speed and above the time line
  */

import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.12

import Variable.Global 1.0

Item  {
    id: scoreControlSurfaceList

    // Receiving and handling messages about Control Surfaces from score
    Connections {
        target: scoreControlSurfaceList
        function onControlSurfacesMessageReceived(m) {
            var messageObject = m.Message
            function find(cond) {
                for (var i = 0; i < controlSurfacelist.count; ++i)
                    if (cond(controlSurfacelist.get(i)))
                        return i
                return null
            }

            //the index of m.Path in the listmodel
            var s = find(function (item) {
                return item.path === JSON.stringify(m.Path)
            })

            // Adding a control surface
            if (messageObject === "ControlSurfaceAdded") {
                if (s === null) {
                    let newSurfaceModel = controlSurfaceDataModel.createObject(
                            controlSurfacelist, {
                                name: m.Name,
                                path: JSON.stringify(m.Path),
                                m: m
                            })
                    controlSurfacelist.insert(0, newSurfaceModel)
                }
            }

            // Removing a control surface
            else if (messageObject === "ControlSurfaceRemoved") {
                if (s !== null) {
                    controlSurfacelist.remove(s)
                }
            }

            // Modifying a control in a control surface
            else if (messageObject === "ControlSurfaceControl") {
                if (s !== null) {
                    let controlSurface = controlSurfacelist.get(parseInt(s))
                    controlSurface.modifyControl(m)
                }
            }
        }

        // Clear the control surface list when the remote is disconnected from score
        function onClearControlSurfaceList() {
            controlSurfacelist.clear()
        }
    }

    anchors {
        left: parent.left; right: parent.right
        top: parent.top; bottom: parent.bottom;
        margins: 5
    }

    ListView {
        id: scoreControlSurfaceListView

        height: parent.height
        anchors { left: parent.left; right: scrollBar.left; margins: 5 }
        spacing: 5
        orientation: ListView.Vertical
        clip: true
        snapMode: ListView.SnapToItem
        ScrollBar.vertical: scrollBar

        // ObjectModel's "model" data is the actual item that is going to be displayed
        model: ObjectModel {
            id: controlSurfacelist
        }

        // The Component will serve as a factory to create the individual ControlSurface visual items & data model
        Component {
            id: controlSurfaceDataModel

            Loader {
                id: controlSurface

                property string name
                property var path
                property var m

                signal appendControls(var m)
                signal modifyControl(var m)

                width: scoreControlSurfaceListView.width
                source: "ScoreControlSurface.qml"

                onLoaded: {
                    controlSurface.appendControls(m)
                }
            }
        }
    }

    ScrollBar {
        id: scrollBar

        width: window.width <= 500 ? 20 : 30; height: parent.height
        anchors.right: parent.right
        active: true
        visible: scoreControlSurfaceListView.count > 0
        policy: ScrollBar.AsNeeded
        snapMode: ScrollBar.SnapAlways

        contentItem: Rectangle {
            id: scrollBarContentItem
            visible: scrollBar.size < 1
            color: scrollBar.pressed ? Skin.orange : "#808080"
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

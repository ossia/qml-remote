/*
  * Control Surface :
  * - a control surface located in score, shown in the remote
  * - controls are rendered in the score's authored order via a single
  *   ScoreControl delegate per control (which loads the matching widget)
  * - handles messages from score relayed by ScoreSkeleton.qml
  */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "qrc:/ControlSurface/Controls"

import Variable.Global 1.0

Column {
    id: controlSurfaceListColumn

    property string name
    // The controls, in score order (a JS array of control messages).
    property var controlsList: []

    // Receiving information about controls in a control surface from score
    Connections {
        target: controlSurface

        // Adding controls in a control surface (in order)
        function onAppendControls(m) {
            controlSurfaceName.text = m.Name
            controlSurfaceListColumn.controlsList = m.Controls ? m.Controls : []
        }

        // Modifying a control: broadcast to every control delegate (each
        // ignores it unless the id matches).
        function onModifyControl(m) {
            if (m.Message === "ControlSurfaceControl") {
                for (var i = 0; i < controlRepeater.count; ++i) {
                    var it = controlRepeater.itemAt(i)
                    if (it)
                        it.doModify(m)
                }
            }
        }
    }

    spacing: 5

    // Control surface name
    Button {
        id: controlSurfaceNameButton
        width: controlSurfaceListColumn.width
        height: Math.max(Skin.minTouch, window.height <= 600 ? 30 : 5 + window.height / 25)

        background: Rectangle {
            anchors.fill: parent
            color: Skin.gray1
        }

        contentItem: Item {
            anchors.fill: parent
            Text {
                id: controlSurfaceName
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 5
                text: name
                color: controlSurfaceNameButton.pressed ? Skin.orange : Skin.white
                font.pointSize:  window.width <= 500
                                 ? Skin.fontCaption
                                 : window.width <= 1200
                                   ? Skin.fontBody
                                   : Skin.fontTitle
            }

            Image {
                id: indicator
                anchors.verticalCenter: parent.verticalCenter
                width: parent.height
                height: parent.height
                anchors.right: parent.right
                anchors.rightMargin: 5
                source: !controlList.visible
                        ? controlSurfaceNameButton.pressed
                          ? "../Icons/indicator_on.png"
                          : "../Icons/indicator.png"
                        : controlSurfaceNameButton.pressed
                          ? "../Icons/indicator_hidden_on.png"
                          : "../Icons/indicator_hidden.png"
            }
        }

        onReleased: {
            controlList.visible = ! controlList.visible
        }
    }

    // Controls, rendered in score order
    Flow {
        id: controlList

        width: parent.width
        spacing: 5

        Repeater {
            id: controlRepeater
            model: controlSurfaceListColumn.controlsList
            delegate: ScoreControl {
                required property var modelData
                m: modelData
            }
        }
    }
}

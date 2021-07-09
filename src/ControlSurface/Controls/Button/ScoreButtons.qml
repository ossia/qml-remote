/*
  * List of buttons  :
  * - in a control surface
  * - modify button value in the remote modify
  * the value of this button in score
  */

import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.15
import QtQml.Models 2.12

import Variable.Global 1.0
import "qrc:/Utility/utility.js" as Utility

Flow {

    // Receving informations about buttons in control surface from score
    Connections {

        // Adding a button in the control surface
        function onAppendButton(s) {
            //the index of m.Path in the listmodel
            var a = Utility.find(buttonListModel, function (item) {
                return item.id === JSON.stringify(s.id)
            })
            if (a === null) {
                buttonListModel.insert(buttonListModel.count, {
                                           "_custom": s.Custom,
                                           "_id": s.id,
                                           "_isPressed": s.Value.Bool,
                                           "_pressedFromScore": s.Value.Bool,
                                           "_uuid": s.uuid
                                       })
            }
        }

        // Modifying a button in the control surface
        function onModifyButton(s) {
            for (var i = 0; i < buttonListModel.count; ++i) {
                if (buttonListModel.get(i)._id === s.Control) {
                    switch (buttonListModel.get(i)._uuid) {
                    case Uuid.buttonUUID:
                        // Button
                        buttonListModel.set(i, {
                                                "_pressedFromScore": s.Value.Bool
                                            })
                        break

                    default:
                        return
                    }
                }
            }
        }
    }

    width: parent.width
    spacing: 5

    Repeater {
        id: buttonList

        clip: true
        Layout.fillHeight: parent.height
        Layout.fillWidth: parent.height
        Layout.margins: 5

        model: ListModel {
            id: buttonListModel
        }

        delegate: ScoreButton {
            id: button

            controlCustom: _custom
            controlId: _id
            controlUuid: _uuid
            controlSurfacePath: path
            isPressed: _isPressed
            pressedFromScore: _pressedFromScore
        }
    }
}


/*
  * List of impulse buttons  :
  * - in a control surface
  * - modify impulse button value in the remote modify
  * the value of this impulse button in score
  */

import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.15
import QtQml.Models 2.12

import "qrc:/Utility/utility.js" as Utility
import Variable.Global 1.0

Flow {

    // Receiving information about impulse buttons in control surface from score
    Connections {
        // Adding an impulse button in the control surface
        function onAppendImpulseButton(s) {
            //the index of m.Path in the list model
            var a = Utility.find(impulseButtonList.model, function (item) {
                return item.id === JSON.stringify(s.id)
            })
            if (a === null) {
                impulseButtonlistModel.insert(impulseButtonlistModel.count, {
                                                  "_custom": s.Custom,
                                                  "_id": s.id,
                                                  "_isPressed": false,
                                                  "_uuid": s.uuid
                                              })
            }
        }

        // Modifying an impulse button in the control surface
        function onModifyImpulseButton(s) {
            for (var i = 0; i < impulseButtonlistModel.count; ++i) {
                if (impulseButtonlistModel.get(i)._id === s.Control) {
                    switch (impulseButtonlistModel.get(i)._uuid) {
                    case Uuid.impulseButtonUUID:
                        // Impulse Button
                        impulseButtonlistModel.set(i, {
                                                       "_isPressed": true
                                                   })
                        break

                    default:
                        return
                    }
                }
            }
        }
    }

    spacing: 5
    width: parent.width

    Repeater {
        id: impulseButtonList

        clip: true
        Layout.fillHeight: parent.height
        Layout.fillWidth: parent.height
        Layout.margins: 5

        model: ListModel {
            id: impulseButtonlistModel
        }

        delegate: ScoreImpulseButton {
            id: button

            controlCustom: _custom
            controlId: _id
            controlUuid: _uuid
            controlSurfacePath: path
            isPressed: _isPressed
        }
    }
}

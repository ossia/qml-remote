import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.15
import QtQml.Models 2.12

Flow {
    spacing: 5
    width: window.width - 10

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

    // Receving informations about impulse buttons in control surface from score
    Connections {
        // Adding an impluse button in the control surface
        function onAppendButton(s) {
            function find(cond) {
                for (var i = 0; i < buttonListModel.count; ++i)
                    if (cond(buttonListModel.get(i)))
                        return i
                return null
            }
            var a = find(function (item) {
                return item.id === JSON.stringify(s.id)
            }) //the index of m.Path in the listmodel
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
        // Modifying an impulse button in the control surface
        function onModifyButton(s) {
            for (var i = 0; i < buttonListModel.count; ++i) {
                if (buttonListModel.get(i)._id === s.Control) {
                    switch (buttonListModel.get(i)._uuid) {
                    case "fb27e4cb-ea7f-41e2-ad92-2354498c1b6b":
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
}

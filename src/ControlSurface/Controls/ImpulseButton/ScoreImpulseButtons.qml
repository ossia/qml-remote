import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.15
import QtQml.Models 2.12

Flow {
    spacing: 5
    width: window.width - 10

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

    // Receving informations about impulse buttons in control surface from score
    Connections {
        // Adding an impluse button in the control surface
        function onAppendImpulseButton(s) {
            function find(cond) {
                for (var i = 0; i < impulseButtonlistModel.count; ++i)
                    if (cond(impulseButtonlistModel.get(i)))
                        return i
                return null
            }
            var a = find(function (item) {
                return item.id === JSON.stringify(s.id)
            }) //the index of m.Path in the listmodel
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
                    case "7cd210d3-ebd1-4f71-9de6-cccfb639cbc3":
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
}

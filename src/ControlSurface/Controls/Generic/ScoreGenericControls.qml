/*
  * List of generic controls (score base ControlInlet, no specialized widget) :
  * - in a control surface
  * - each renders as an editable, type-aware line-edit (ScoreGenericControl)
  */

import QtQuick
import QtQuick.Layouts
import QtQml.Models

import "qrc:/Utility/utility.js" as Utility
import Variable.Global 1.0

ColumnLayout {
    id: genericColumn

    property alias model: genericListModel

    Connections {
        function onAppendGeneric(s, ind) {
            var a = Utility.find(genericListModel, function (item) {
                return item.id === JSON.stringify(s.id)
            })
            if (a === null) {
                genericListModel.insert(genericListModel.count, {
                                            "_custom": s.Custom,
                                            "_id": s.id,
                                            "_uuid": s.uuid,
                                            "_value": JSON.stringify(s.Value)
                                        })
            }
        }

        function onModifyGeneric(s) {
            for (var i = 0; i < genericListModel.count; ++i) {
                if (genericListModel.get(i)._id === s.Control) {
                    genericListModel.set(i, { "_value": JSON.stringify(s.Value) })
                }
            }
        }
    }

    implicitWidth: parent.width <= 500
                    ? (parent.width)
                    : (parent.width >= 1200 ? 400 : parent.width / 3)
    spacing: 5

    Repeater {
        id: genericList

        clip: true
        Layout.fillHeight: parent.height
        Layout.fillWidth: parent.height

        model: ListModel { id: genericListModel }

        delegate: ScoreGenericControl {
            controlCustom: _custom
            controlId: _id
            controlUuid: _uuid
            controlSurfacePath: path
            controlValue: _value
        }
    }
}

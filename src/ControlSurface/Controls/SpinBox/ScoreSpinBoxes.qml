/*
  * List of spinboxes :
  * - in a control surface (score IntSpinBox / FloatSpinBox / TimeChooser)
  * - editing a value in the remote modifies it in score
  */

import QtQuick
import QtQuick.Layouts
import QtQml.Models

import "qrc:/Utility/utility.js" as Utility
import Variable.Global 1.0

ColumnLayout {
    id: spinBoxColumn

    property alias model: spinBoxListModel

    Connections {
        function onAppendSpinBox(s, ind) {
            var a = Utility.find(spinBoxListModel, function (item) {
                return item.id === JSON.stringify(s.id)
            })
            if (a === null) {
                var isInt = s.uuid === Uuid.intSpinBoxUUID
                var dom = isInt ? s.Domain.Int : s.Domain.Float
                spinBoxListModel.insert(spinBoxListModel.count, {
                                            "_custom": s.Custom,
                                            "_id": s.id,
                                            "_uuid": s.uuid,
                                            "_isInt": isInt,
                                            "_from": (dom && dom.Min !== undefined) ? dom.Min : 0,
                                            "_to": (dom && dom.Max !== undefined) ? dom.Max : 0,
                                            "_value": isInt ? s.Value.Int : s.Value.Float
                                        })
            }
        }

        function onModifySpinBox(s) {
            for (var i = 0; i < spinBoxListModel.count; ++i) {
                if (spinBoxListModel.get(i)._id === s.Control) {
                    var isInt = spinBoxListModel.get(i)._isInt
                    spinBoxListModel.set(i, { "_value": isInt ? s.Value.Int : s.Value.Float })
                }
            }
        }
    }

    implicitWidth: parent.width <= 500
                    ? (parent.width)
                    : (parent.width >= 1200 ? 400 : parent.width / 3)
    spacing: 5

    Repeater {
        id: spinBoxList

        clip: true
        Layout.fillHeight: parent.height
        Layout.fillWidth: parent.height

        model: ListModel { id: spinBoxListModel }

        delegate: ScoreSpinBox {
            controlCustom: _custom
            controlId: _id
            controlUuid: _uuid
            controlSurfacePath: path

            isInt: _isInt
            from: _from
            to: _to
            value: _value
        }
    }
}

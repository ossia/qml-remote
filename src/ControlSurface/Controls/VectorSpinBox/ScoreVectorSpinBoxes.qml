/*
  * List of vector spinboxes :
  * - score XYSpinboxes (Vec2f) / XYZSpinboxes (Vec3f)
  * - N numeric fields; integral flag selects int vs float
  */

import QtQuick
import QtQuick.Layouts
import QtQml.Models

import "qrc:/Utility/utility.js" as Utility
import Variable.Global 1.0

ColumnLayout {
    id: vspinColumn

    property alias model: vspinListModel

    function componentsOf(s) {
        return (s.uuid === Uuid.xyzSpinboxesUUID ? s.Value.Vec3f : s.Value.Vec2f) || []
    }

    Connections {
        function onAppendVectorSpinBox(s, ind) {
            var a = Utility.find(vspinListModel, function (item) {
                return item.id === JSON.stringify(s.id)
            })
            if (a === null) {
                vspinListModel.insert(vspinListModel.count, {
                                          "_custom": s.Custom,
                                          "_id": s.id,
                                          "_uuid": s.uuid,
                                          "_isInt": s.Integral === true,
                                          "_valuesJson": JSON.stringify(vspinColumn.componentsOf(s))
                                      })
            }
        }

        function onModifyVectorSpinBox(s) {
            for (var i = 0; i < vspinListModel.count; ++i) {
                if (vspinListModel.get(i)._id === s.Control) {
                    vspinListModel.set(i, {
                        "_valuesJson": JSON.stringify(vspinColumn.componentsOf(s))
                    })
                }
            }
        }
    }

    implicitWidth: parent.width <= 500
                    ? (parent.width)
                    : (parent.width >= 1200 ? 400 : parent.width / 3)
    spacing: 5

    Repeater {
        id: vspinList

        clip: true
        Layout.fillHeight: parent.height
        Layout.fillWidth: parent.height

        model: ListModel { id: vspinListModel }

        delegate: ScoreVectorSpinBox {
            controlCustom: _custom
            controlId: _id
            controlUuid: _uuid
            controlSurfacePath: path
            isInt: _isInt
            valuesJson: _valuesJson
        }
    }
}

/*
  * List of knobs :
  * - in a control surface (score Process::FloatKnob)
  * - moving a knob in the remote modifies the value in score
  */

import QtQuick
import QtQuick.Layouts
import QtQml.Models

import "qrc:/Utility/utility.js" as Utility
import Variable.Global 1.0

ColumnLayout {
    id: knobColumn

    property alias model: knobListModel

    Connections {
        // Adding a knob in the control surface
        function onAppendKnob(s, ind) {
            var a = Utility.find(knobListModel, function (item) {
                return item.id === JSON.stringify(s.id)
            })
            if (a === null) {
                knobListModel.insert(knobListModel.count, {
                                         "_custom": s.Custom,
                                         "_id": s.id,
                                         "_from": s.Domain.Float.Min,
                                         "_value": s.Value.Float,
                                         "_to": s.Domain.Float.Max,
                                         "_uuid": s.uuid
                                     })
            }
        }

        // Live update from score
        function onModifyKnob(s) {
            for (var i = 0; i < knobListModel.count; ++i) {
                if (knobListModel.get(i)._id === s.Control) {
                    knobListModel.set(i, { "_value": s.Value.Float })
                }
            }
        }
    }

    implicitWidth: parent.width <= 500
                    ? (parent.width)
                    : (parent.width >= 1200 ? 400 : parent.width / 3)
    spacing: 5

    Repeater {
        id: knobList

        clip: true
        Layout.fillHeight: parent.height
        Layout.fillWidth: parent.height

        model: ListModel { id: knobListModel }

        delegate: ScoreKnob {
            controlCustom: _custom
            controlId: _id
            controlUuid: _uuid
            controlSurfacePath: path

            from: _from
            value: _value
            to: _to
        }
    }
}

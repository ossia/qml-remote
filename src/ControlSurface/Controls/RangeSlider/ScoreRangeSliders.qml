/*
  * List of range sliders :
  * - score IntRangeSlider / FloatRangeSlider / IntRangeSpinBox / FloatRangeSpinBox
  * - the value is a Vec2f [low, high]; the domain is a scalar Float/Int range
  */

import QtQuick
import QtQuick.Layouts
import QtQml.Models

import "qrc:/Utility/utility.js" as Utility
import Variable.Global 1.0

ColumnLayout {
    id: rangeColumn

    property alias model: rangeListModel

    Connections {
        function onAppendRangeSlider(s, ind) {
            var a = Utility.find(rangeListModel, function (item) {
                return item.id === JSON.stringify(s.id)
            })
            if (a === null) {
                var isInt = (s.uuid === Uuid.intRangeSliderUUID
                             || s.uuid === Uuid.intRangeSpinBoxUUID)
                var dom = isInt ? s.Domain.Int : s.Domain.Float
                rangeListModel.insert(rangeListModel.count, {
                                          "_custom": s.Custom,
                                          "_id": s.id,
                                          "_uuid": s.uuid,
                                          "_isInt": isInt,
                                          "_from": (dom && dom.Min !== undefined) ? dom.Min : 0,
                                          "_to": (dom && dom.Max !== undefined) ? dom.Max : 1,
                                          "_low": s.Value.Vec2f[0],
                                          "_high": s.Value.Vec2f[1]
                                      })
            }
        }

        function onModifyRangeSlider(s) {
            for (var i = 0; i < rangeListModel.count; ++i) {
                if (rangeListModel.get(i)._id === s.Control) {
                    rangeListModel.set(i, {
                                           "_low": s.Value.Vec2f[0],
                                           "_high": s.Value.Vec2f[1]
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
        id: rangeList

        clip: true
        Layout.fillHeight: parent.height
        Layout.fillWidth: parent.height

        model: ListModel { id: rangeListModel }

        delegate: ScoreRangeSlider {
            controlCustom: _custom
            controlId: _id
            controlUuid: _uuid
            controlSurfacePath: path

            isInt: _isInt
            from: _from
            to: _to
            low: _low
            high: _high
        }
    }
}

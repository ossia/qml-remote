/*
  * List of vector sliders :
  * - score XYZSlider (Vec3f) and MultiSlider (Tuple of floats)
  * - rendered as N labelled sub-sliders sharing a scalar domain
  */

import QtQuick
import QtQuick.Layouts
import QtQml.Models

import "qrc:/Utility/utility.js" as Utility
import Variable.Global 1.0

ColumnLayout {
    id: vectorColumn

    property alias model: vectorListModel

    function componentsOf(s) {
        if (s.uuid === Uuid.multiSliderUUID)
            return (s.Value.Tuple || []).map(function (e) { return e.Float })
        return s.Value.Vec3f || []
    }

    Connections {
        function onAppendVectorSlider(s, ind) {
            var a = Utility.find(vectorListModel, function (item) {
                return item.id === JSON.stringify(s.id)
            })
            if (a === null) {
                var dom = s.Domain.Float
                vectorListModel.insert(vectorListModel.count, {
                                           "_custom": s.Custom,
                                           "_id": s.id,
                                           "_uuid": s.uuid,
                                           "_from": (dom && dom.Min !== undefined) ? dom.Min : 0,
                                           "_to": (dom && dom.Max !== undefined) ? dom.Max : 1,
                                           "_valuesJson": JSON.stringify(vectorColumn.componentsOf(s))
                                       })
            }
        }

        function onModifyVectorSlider(s) {
            for (var i = 0; i < vectorListModel.count; ++i) {
                if (vectorListModel.get(i)._id === s.Control) {
                    vectorListModel.set(i, {
                        "_valuesJson": JSON.stringify(vectorColumn.componentsOf(s))
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
        id: vectorList

        clip: true
        Layout.fillHeight: parent.height
        Layout.fillWidth: parent.height

        model: ListModel { id: vectorListModel }

        delegate: ScoreVectorSlider {
            controlCustom: _custom
            controlId: _id
            controlUuid: _uuid
            controlSurfacePath: path

            from: _from
            to: _to
            valuesJson: _valuesJson
        }
    }
}

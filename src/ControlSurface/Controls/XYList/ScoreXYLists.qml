/*
  * List of XY-point lists :
  * - score MultiSliderXY / PathGeneratorXY (a Tuple of Vec2f points)
  * - Stage 1: live read-only 2D plot (point editing is a follow-up)
  */

import QtQuick
import QtQuick.Layouts
import QtQml.Models

import "qrc:/Utility/utility.js" as Utility
import Variable.Global 1.0

ColumnLayout {
    id: xyListColumn

    property alias model: xyListModel

    function pointsOf(s) {
        return (s.Value.Tuple || []).map(function (e) { return e.Vec2f })
    }

    Connections {
        function onAppendXYList(s, ind) {
            var a = Utility.find(xyListModel, function (item) {
                return item.id === JSON.stringify(s.id)
            })
            if (a === null) {
                var dom = s.Domain.Float
                xyListModel.insert(xyListModel.count, {
                                       "_custom": s.Custom,
                                       "_id": s.id,
                                       "_uuid": s.uuid,
                                       "_from": (dom && dom.Min !== undefined) ? dom.Min : 0,
                                       "_to": (dom && dom.Max !== undefined) ? dom.Max : 1,
                                       "_pointsJson": JSON.stringify(xyListColumn.pointsOf(s))
                                   })
            }
        }

        function onModifyXYList(s) {
            for (var i = 0; i < xyListModel.count; ++i) {
                if (xyListModel.get(i)._id === s.Control) {
                    xyListModel.set(i, {
                        "_pointsJson": JSON.stringify(xyListColumn.pointsOf(s))
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
        id: xyList

        clip: true
        Layout.fillHeight: parent.height
        Layout.fillWidth: parent.height

        model: ListModel { id: xyListModel }

        delegate: ScoreXYList {
            controlCustom: _custom
            controlId: _id
            controlUuid: _uuid
            from: _from
            to: _to
            pointsJson: _pointsJson
        }
    }
}

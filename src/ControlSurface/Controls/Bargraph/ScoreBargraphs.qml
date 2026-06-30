/*
  * List of bargraphs :
  * - score Bargraph (a ControlOutlet): read-only level meter
  * - value is pushed by score via ControlSurfaceControl
  */

import QtQuick
import QtQuick.Layouts
import QtQml.Models

import "qrc:/Utility/utility.js" as Utility
import Variable.Global 1.0

ColumnLayout {
    id: bargraphColumn

    property alias model: bargraphListModel

    Connections {
        function onAppendBargraph(s, ind) {
            var a = Utility.find(bargraphListModel, function (item) {
                return item.id === JSON.stringify(s.id)
            })
            if (a === null) {
                var dom = s.Domain.Float
                bargraphListModel.insert(bargraphListModel.count, {
                                             "_custom": s.Custom,
                                             "_id": s.id,
                                             "_uuid": s.uuid,
                                             "_from": (dom && dom.Min !== undefined) ? dom.Min : 0,
                                             "_to": (dom && dom.Max !== undefined) ? dom.Max : 1,
                                             "_value": s.Value.Float !== undefined ? s.Value.Float : 0
                                         })
            }
        }

        function onModifyBargraph(s) {
            for (var i = 0; i < bargraphListModel.count; ++i) {
                if (bargraphListModel.get(i)._id === s.Control) {
                    bargraphListModel.set(i, {
                        "_value": s.Value.Float !== undefined ? s.Value.Float : 0
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
        id: bargraphList

        clip: true
        Layout.fillHeight: parent.height
        Layout.fillWidth: parent.height

        model: ListModel { id: bargraphListModel }

        delegate: ScoreBargraph {
            controlCustom: _custom
            controlId: _id
            controlUuid: _uuid

            from: _from
            to: _to
            value: _value
        }
    }
}

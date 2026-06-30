/*
  * List of text fields :
  * - in a control surface (score LineEdit / ProgramEdit / *FileChooser /
  *   FolderChooser — all string-valued)
  * - editing the text in the remote modifies the value in score
  */

import QtQuick
import QtQuick.Layouts
import QtQml.Models

import "qrc:/Utility/utility.js" as Utility
import Variable.Global 1.0

ColumnLayout {
    id: lineEditColumn

    property alias model: lineEditListModel

    Connections {
        function onAppendLineEdit(s, ind) {
            var a = Utility.find(lineEditListModel, function (item) {
                return item.id === JSON.stringify(s.id)
            })
            if (a === null) {
                lineEditListModel.insert(lineEditListModel.count, {
                                             "_custom": s.Custom,
                                             "_id": s.id,
                                             "_uuid": s.uuid,
                                             "_value": s.Value.String !== undefined ? s.Value.String : ""
                                         })
            }
        }

        function onModifyLineEdit(s) {
            for (var i = 0; i < lineEditListModel.count; ++i) {
                if (lineEditListModel.get(i)._id === s.Control) {
                    lineEditListModel.set(i, {
                        "_value": s.Value.String !== undefined ? s.Value.String : ""
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
        id: lineEditList

        clip: true
        Layout.fillHeight: parent.height
        Layout.fillWidth: parent.height

        model: ListModel { id: lineEditListModel }

        delegate: ScoreLineEdit {
            controlCustom: _custom
            controlId: _id
            controlUuid: _uuid
            controlSurfacePath: path
            controlValue: _value
        }
    }
}

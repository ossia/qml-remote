import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.12

import "qrc:/Utility/utility.js" as Utility
import Variable.Global 1.0

ColumnLayout {
    id: comboBoxColumn
    implicitWidth: (window.width <= 500 ? (window.width - 10) : (window.width
                                                                 >= 1200 ? 400 : window.width / 3))
    spacing: 5
    property alias model: comboBoxListModel

    Repeater {
        id: comboBoxList
        clip: true
        Layout.fillHeight: parent.height
        Layout.fillWidth: parent.height

        model: ListModel {
            id: comboBoxListModel
        }

        delegate: ScoreComboBox {
            id: comboBox
            implicitHeight: 5 + window.height / 25
            implicitWidth: (window.width <= 500 ? (window.width - 10) : (window.width >= 1200 ? 400 : window.width / 3))
            width: (window.width <= 500 ? (window.width - 10) : (window.width
                                                                 >= 1200 ? 400 : window.width / 3))

            // Control values
            controlCustom: _custom
            controlId: _id
            controlUuid: _uuid
            controlSurfacePath: path
        }
    }

    // Receving informations about comboBoxs in control surface from score
    Connections {
        // Adding a comboBox in the control surface
        function onAppendComboBox(s, ind) {
            //the index of m.Path in the listmodel
            console.log("22222222222222222222222")
            var a = Utility.find(comboBoxList.model, function (item) {
                return item.id === JSON.stringify(s.id)
            })
            if (a === null) {
                console.log("111111111111111111")
                comboBoxListModel.insert(comboBoxListModel.count, {
                                           "_custom": s.Custom,
                                           "_id": s.id,
                                           "_uuid": s.uuid
                                       })
            }
        }
    }
}

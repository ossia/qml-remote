/*
  * List of comboboxes  :
  * - in a control surface
  * - modify combobox value in the remote modify
  * the value of this combobox in score
  */

import QtQuick 2.15
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.12

import "qrc:/Utility/utility.js" as Utility
import Variable.Global 1.0

ColumnLayout {
    id: scoreComboBoxList

    // Receiving information about comboboxes in control surface from score
    Connections {
        target: scoreComboBoxList

        // Adding a comboBox in the control surface
        function onAppendComboBox(s, ind) {
            //the index of m.Path in the list model
            var a = Utility.find(comboBoxList.model, function (item) {
                return item.id === JSON.stringify(s.id)
            })
            if (a === null) {
                comboBoxListModel.insert(comboBoxListModel.count, {
                                             "_custom": s.Custom,
                                             "_id": s.id,
                                             "_uuid": s.uuid,
                                             "_message": s
                                         })
            }
        }
    }

    implicitWidth: (window.width <= 500
                    ? (window.width - 10)
                    : (window.width >= 1200
                       ? 400
                       : window.width / 3))
    spacing: 5

    Repeater {
        id: comboBoxList

        clip: true
        Layout.fillHeight: parent.height
        Layout.fillWidth: parent.height

        model: ListModel {
            id: comboBoxListModel
        }

        delegate: Loader {
            id: comboBoxItem

            property var message: _message
            signal appendItems(var message, var path)

            source: "ScoreComboBox.qml"

            onLoaded: comboBoxItem.appendItems(message, path)
        }
    }
}

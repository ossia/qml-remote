import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.15
import QtQml.Models 2.12

RowLayout {
    spacing: 5
    height: 75
    width: window.width / 4

    Repeater {
        id: buttonList
        clip: true
        Layout.fillHeight: parent.height
        Layout.fillWidth: parent.height
        Layout.margins: 5

        model: ListModel {
            id: buttonlistModel
        }

        delegate: ScoreButton {
            id: button
            buttonPath: path
            buttonName: name
            buttonId: id
        }
    }

    // Receving informations about buttons in control surface from score
    Connections {
        // Adding a button in the control surface
        function onAppendButton(s) {
            function find(cond) {
                for (var i = 0; i < buttonlistModel.count; ++i)
                    if (cond(buttonlistModel.get(i)))
                        return i
                return null
            }
            var a = find(function (item) {
                return item.id === JSON.stringify(s.id)
            }) //the index of m.Path in the listmodel
            if (a === null) {
                buttonlistModel.insert(buttonlistModel.count, {
                                           "name": JSON.stringify(s.Custom),
                                           "path": JSON.stringify(s.Path),
                                           "id": JSON.stringify(s.id)
                                       })
                console.log(JSON.stringify(s.id))
            }
        }
        // Modifying a slider in the control surface
        function onModifyButton(s) {
            function find(cond) {
                for (var i = 0; i < buttonlistModel.count; ++i)
                    if (cond(buttonlistModel.get(i)))
                        return i
                return null
            }
            var a = find(function (item) {
                return item.id === JSON.stringify(s.id)
            }) //the index of m.Path in the listmodel
            if (a !== null) {
                buttonlistModel.set(a, {
                                        "myValue": JSON.stringify(tmpValue)
                                    })
            }
        }
    }
}

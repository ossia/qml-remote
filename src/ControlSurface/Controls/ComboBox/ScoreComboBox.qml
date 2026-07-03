/*
  * Combobox control :
  * - in a list of comboboxes in a control surface
  * - modify combobox value in the remote modify
  * the value of this combobox in score
  */

import QtQuick
import QtQuick.Controls

import Variable.Global 1.0

ComboBox {
    id: comboBox

    property string controlCustom
    property string controlDomain
    property string controlValueType
    property string controlValueData
    property int controlId
    property string controlUuid
    property string controlSurfacePath

    Connections {
        target: comboBoxItem

        function onAppendItems(message, path) {
            if (message) {
                controlCustom = message.Custom
                controlId = message.id
                controlUuid = message.uuid
                controlSurfacePath = path
                var i = 0
                if (message.uuid === Uuid.enumUUID
                        || message.uuid === Uuid.chooserToggleUUID) {
                    // Enum / ChooserToggle: Values is a flat list of strings; the value IS the string
                    var name = message.Values[i]
                    while (name !== undefined) {
                        comboBoxItemsListModel.append({
                                                          "_num": JSON.stringify({ "String": name }),
                                                          "_name": name
                                                      })
                        i++
                        name = message.Values[i]
                    }
                } else {
                    // ComboBox: Values is a list of [name, value] pairs
                    var itemMessage = message.Values[i]
                    while (itemMessage) {
                        comboBoxItemsListModel.append({
                                                          "_num": JSON.stringify(itemMessage[1]),
                                                          "_name": itemMessage[0]
                                                      })
                        i++
                        itemMessage = message.Values[i]
                    }
                }
            }

            // Initialize the current value of the combobox
            var currentVal = JSON.stringify(message.Value)
            for (var j = 0; j < comboBoxItemsListModel.count; ++j) {
                if (comboBoxItemsListModel.get(j)._num === currentVal) {
                    comboBox.currentIndex = j
                }
            }
        }
    }

    implicitHeight: Math.max(Skin.minTouch, window.height<= 500
                    ? 30
                    : 5 + window.height / 25)
    implicitWidth: (controlSurfaceListColumn.width <= 500
            ? (controlSurfaceListColumn.width)
            : (controlSurfaceListColumn.width >= 1200
               ? 400
               : controlSurfaceListColumn.width / 3))
    valueRole: '_num'
    textRole: '_name'

    model: ListModel {
        id: comboBoxItemsListModel
    }

    delegate: ItemDelegate {
        id: delegateItem

        property string num: _num
        property string name: _name

        width: comboBox.width; height: Skin.minTouch
        highlighted: comboBox.highlightedIndex === index

        contentItem: Text {
            text: name
            font.family: Skin.font
            color: delegateItem.highlighted ? Skin.dark : Skin.white
            font.pointSize: parent.width <= 200
                            ? 10
                            : parent.width >= 500
                              ? parent.height / 2
                              : 15
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }

        background: Rectangle {
            color: delegateItem.highlighted ? Skin.orange : Skin.gray2
        }
    }

    indicator: Image {
        id: indicator

        width: parent.height; height: parent.height
        anchors { right: parent.right; verticalCenter: parent.verticalCenter }
        source: !popup.visible
                ? comboBox.pressed
                  ? "../../../Icons/indicator_on.png"
                  : "../../../Icons/indicator.png"
                : comboBox.pressed
                  ? "../../../Icons/indicator_hidden_on.png"
                  : "../../../Icons/indicator_hidden.png"
    }

    contentItem: Text {
        leftPadding: 5
        rightPadding: comboBox.indicator.width + comboBox.spacing
        text: qsTr(controlCustom) + " " + comboBox.displayText
        font.family: Skin.font
        color: Skin.white
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        font.pointSize: parent.width <= 200
                        ? 10
                        : parent.width >= 500
                          ? parent.height / 2
                          : 15
    }

    background: Rectangle {
        implicitWidth: 120; implicitHeight: 40
        color: Skin.gray2
        radius: 4
        border.color: comboBox.pressed ? Skin.orange : Skin.gray3
    }

    popup: Popup {
        width: comboBox.width; height: 150
        y: comboBox.height - 1
        padding: 1

        contentItem: ListView {
            clip: true
            height: 150
            model: comboBox.popup.visible ? comboBox.delegateModel : null
            currentIndex: comboBox.highlightedIndex

            ScrollBar.vertical: ScrollBar {
                id: scrollBar

                width: 30
                anchors.right: parent.right
                active: true
                policy: ScrollBar.AsNeeded
                snapMode: ScrollBar.SnapAlways

                contentItem: Rectangle {
                    id: scrollBarContentItem
                    visible: scrollBar.size < 1
                    color: scrollBar.pressed ? Skin.orange : Skin.lightGray
                }

                background: Rectangle {
                    id: scrollBarBackground

                    width: scrollBarContentItem.width + 20
                    color: Skin.darkGray
                }
            }
        }

        background: Rectangle {
            color: Skin.gray2
            radius: 4
            border.color: Skin.gray3
        }
    }

    onCurrentValueChanged: {
        socket.sendTextMessage(
                    `{ "Message": "ControlSurface","Path": ${comboBox.controlSurfacePath}, "id": ${comboBox.controlId}, "Value": ${comboBox.currentValue} }`)
    }
}

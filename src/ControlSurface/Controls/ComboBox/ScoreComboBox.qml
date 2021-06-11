import QtQuick 2.15
import QtQuick.Controls 2.12

ComboBox {
    id: comboBox
    implicitHeight: 5 + window.height / 25
    implicitWidth: (window.width <= 500
                    ? (window.width - 10)
                    : (window.width >= 1200 ? 400 : window.width / 3))

    property string controlCustom
    property string controlDomain
    property string controlValueType
    property string controlValueData
    property int controlId
    property string controlUuid
    property string controlSurfacePath

    valueRole: '_num'
    textRole: '_name'

    model: ListModel {
        id: comboBoxItemsListModel
    }

    delegate: ItemDelegate {
        id: delegateItem
        width: comboBox.width
        height: 40
        contentItem: Text {
            text: name
            color: "#ffedb6"
            font.pointSize: ((comboBox.contentItem.height + comboBox.contentItem.width)
                             / 30) >= comboBox.contentItem.height / 2
                            ? comboBox.contentItem.height / 2
                            : (comboBox.contentItem.height
                               + comboBox.contentItem.width) / 30.0
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }

        background: Rectangle {
            opacity: delegateItem.highlighted ? 1 : 0.3
            color: delegateItem.highlighted ? "#f6a019" : "#303030"
            //height: parent.height
        }

        property string num: _num
        property string name: _name

        highlighted: comboBox.highlightedIndex === index
    }

    indicator: Canvas {
        id: canvas
        x: comboBox.width - width - comboBox.rightPadding
        y: comboBox.topPadding + (comboBox.availableHeight - height) / 2
        width: 12
        height: 8
        contextType: "2d"

        Connections {
            target: comboBox
            function onPressedChanged() {
                canvas.requestPaint()
            }
        }

        onPaint: {
            context.reset()
            context.moveTo(0, 0)
            context.lineTo(width, 0)
            context.lineTo(width / 2, height)
            context.closePath()
            context.fillStyle = comboBox.pressed ? "#ffedb6" : "#ffedb6"
            context.fill()
        }
    }

    contentItem: Text {
        leftPadding: 5
        rightPadding: comboBox.indicator.width + comboBox.spacing
        text: " " + "<b>" + qsTr(controlCustom)
              + ": " + "</b>" + comboBox.displayText
        color: comboBox.pressed ? "#ffedb6" : "#ffedb6"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        font.pointSize: ((parent.height + parent.width) / 30)
                        >= parent.height / 2
                        ? parent.height / 2
                        : (parent.height + parent.width) / 30.0
    }

    background: Rectangle {
        implicitWidth: 120
        implicitHeight: 40
        color: "#303030"
        border.color: comboBox.pressed ? "#f6a019" : "#f6a019"
    }

    popup: Popup {
        y: comboBox.height - 1
        width: comboBox.width
        height: 150
        padding: 1

        contentItem: ListView {
            clip: true
            height: 150
            model: comboBox.popup.visible ? comboBox.delegateModel : null
            currentIndex: comboBox.highlightedIndex

            ScrollBar.vertical: ScrollBar {
                id: scrollBar
                active: true
                width: 30 // parent.width / 15
                anchors.right: parent.right

                policy: ScrollBar.AsNeeded
                snapMode: ScrollBar.SnapAlways
                contentItem: Rectangle {
                    id: scrollBarContentItem
                    visible: scrollBar.size >= 1 ? false : true
                    color: scrollBar.pressed ? "#f6a019" : "#808080"
                }

                background: Rectangle {
                    id: scrollBarBackground
                    width: scrollBarContentItem.width + 20
                    color: "#202020"
                }
            }
        }

        background: Rectangle {
            color: "#303030"
            border.color: "#f6a019"
        }
    }

    onCurrentValueChanged: {
        socket.sendTextMessage(
                    '{ "Message": "ControlSurface","Path":'.concat(
                        comboBox.controlSurfacePath, ', "id":',
                        comboBox.controlId, ', "Value":',
                        comboBox.currentValue, '}'))
    }

    Connections {
        target: comboBoxItem
        function onAppendItems(message, path) {
            if (message) {
                controlCustom = message.Custom
                controlId = message.id
                controlUuid = message.uuid
                controlSurfacePath = path
                var i = 0
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

            // Initialize the current value of the combobox
            var currentVal = JSON.stringify(message.Value)
            for (var j = 0; j < comboBoxItemsListModel.count; ++j) {
                if (comboBoxItemsListModel.get(j)._num === currentVal) {
                    comboBox.currentIndex = j
                }
            }
        }
    }
}

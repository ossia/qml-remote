import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.12

import "../Control"

ColumnLayout {
    id: sliderColumn
    implicitWidth: (window.width <= 500 ? (window.width - 10) : (window.width
                                                                 >= 1200 ? 400 : window.width / 3))
    spacing: 5
    property alias model: sliderListModel

    Repeater {
        id: sliderList
        clip: true
        Layout.fillHeight: parent.height
        Layout.fillWidth: parent.height

        model: ListModel {
            id: sliderListModel
        }

        delegate: ScoreSlider {
            id: slider
            implicitHeight: 5 + window.height / 25
            implicitWidth: (window.width <= 500 ? (window.width - 10) : (window.width >= 1200 ? 400 : window.width / 3))
            width: (window.width <= 500 ? (window.width - 10) : (window.width
                                                                 >= 1200 ? 400 : window.width / 3))

            // Control values
            controlCustom: _custom
            controlId: _id
            controlUuid: _uuid
            controlSurfacePath: path
            controlColor: "#f6a019"

            // Specific variables to the sliders
            from: _from
            value: _value
            to: _to
            stepSize: _stepSize

            onMoved: {
                socket.sendTextMessage(
                            '{ "Message": "ControlSurface","Path":'.concat(
                                slider.controlSurfacePath, ', "id":',
                                slider.controlId, ', "Value": {"Float":',
                                slider.value, '}}'))
            }
        }
    }

    // Receving informations about sliders in control surface from score
    Connections {
        // Adding a slider in the control surface
        function onAppendSlider(s, ind) {
            function find(cond) {
                for (var i = 0; i < sliderListModel.count; ++i)
                    if (cond(sliderListModel.get(i)))
                        return i
                return null
            }
            var a = find(function (item) {
                return item.id === JSON.stringify(s.id)
            }) //the index of m.Path in the listmodel
            if (a === null) {
                var tmpFrom, tmpValue, tmpTo
                var tmpStepSize
                switch (s.uuid) {
                case "af2b4fc3-aecb-4c15-a5aa-1c573a239925":
                    // Float Slider
                    tmpFrom = s.Domain.Float.Min
                    tmpValue = s.Value.Float
                    tmpTo = s.Domain.Float.Max
                    tmpStepSize = 0.0
                    break
                case "348b80a4-45dc-4f70-8f5f-6546c85089a2":
                    // Int Slider
                    tmpFrom = s.Domain.Int.Min
                    tmpValue = s.Value.Int
                    tmpTo = s.Domain.Int.Max
                    tmpStepSize = 1
                    break
                }
                sliderListModel.insert(sliderListModel.count, {
                                           "_custom": s.Custom,
                                           "_id": s.id,
                                           "_from": tmpFrom,
                                           "_value": tmpValue,
                                           "_to": tmpTo,
                                           "_stepSize": tmpStepSize,
                                           "_uuid": s.uuid
                                       })
            }
        }
        // Modifying a slider in the control surface
        function onModifySlider(s) {
            for (var i = 0; i < sliderListModel.count; ++i) {
                if (sliderListModel.get(i)._id === s.Control) {
                    var tmpValue
                    switch (sliderListModel.get(i)._uuid) {
                        // Float Slider
                    case "af2b4fc3-aecb-4c15-a5aa-1c573a239925":
                        tmpValue = s.Value.Float
                        break
                        // Int Slider
                    case "348b80a4-45dc-4f70-8f5f-6546c85089a2":
                        tmpValue = s.Value.Int
                        break
                    default:
                        return
                    }
                    sliderListModel.set(i, {
                                            "_value": tmpValue
                                        })
                }
            }
        }
    }
}

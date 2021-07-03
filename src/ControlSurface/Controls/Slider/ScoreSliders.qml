/*
  * List of sliders  :
  * - in a control surface
  * - modify slider value in the remote modify
  * the value of this slider in score
  */

import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.12

import "qrc:/Utility/utility.js" as Utility
import Variable.Global 1.0

ColumnLayout {
    id: sliderColumn
    implicitWidth: (parent.width <= 500 ? (parent.width)
                                        : (parent.width >= 1200
                                           ? 400
                                           : parent.width / 3))
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
            implicitHeight: window.height <= 500
                            ? 30
                            : 5 + window.height / 25
            implicitWidth: (controlSurfaceListColumn.width <= 500
                    ? (controlSurfaceListColumn.width)
                    : (controlSurfaceListColumn.width >= 1200
                       ? 400
                       : controlSurfaceListColumn.width / 3))
            width: (controlSurfaceListColumn.width <= 500
                    ? (controlSurfaceListColumn.width)
                    : (controlSurfaceListColumn.width >= 1200
                       ? 400
                       : controlSurfaceListColumn.width / 3))

            // Control values
            controlCustom: _custom
            controlId: _id
            controlUuid: _uuid
            controlSurfacePath: path
            controlColor: Skin.brown

            // Specific variables to the sliders
            from: _from
            value: _value
            to: _to
            stepSize: _stepSize

            onMoved: {
                socket.sendTextMessage(
                            '{ "Message": "ControlSurface",
                                          "Path":'.concat(slider.controlSurfacePath, ', "id":',
                                                          slider.controlId, ', "Value": {"Float":',
                                                          (slider.controlUuid === Uuid.logFloatSliderUUID
                                                           ? Utility.logSlider(slider.value, slider.from, slider.to).toFixed(3) + " "
                                                           : slider.value.toFixed(3)) + " ", '}}'))
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
                case Uuid.floatSliderUUID:
                    // Float Slider
                    tmpFrom = s.Domain.Float.Min
                    tmpValue = s.Value.Float
                    tmpTo = s.Domain.Float.Max
                    tmpStepSize = 0.0
                    break
                case Uuid.intSliderUUID:
                    // Int Slider
                    tmpFrom = s.Domain.Int.Min
                    tmpValue = s.Value.Int
                    tmpTo = s.Domain.Int.Max
                    tmpStepSize = 1
                    break
                case Uuid.logFloatSliderUUID:
                    // LogFloat Slider
                    tmpFrom = s.Domain.Float.Min
                    tmpValue = s.Value.Float
                    tmpTo = s.Domain.Float.Max
                    tmpStepSize = 0.0
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
                    case Uuid.floatSliderUUID:
                        // Float Slider
                        tmpValue = s.Value.Float
                        break
                    case Uuid.intSliderUUID:
                        // Int Slider
                        tmpValue = s.Value.Int
                        break
                    case Uuid.logFloatSliderUUID:
                        // LogFloat Slider
                        tmpValue = s.Value.Float
                        break
                    default:
                        return
                    }


                    /*
                    sliderListModel.set(i, {
                                            "_value": tmpValue
                                        }
                    */
                }
            }
        }
    }
}

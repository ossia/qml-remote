import QtQuick 2.15
import QtQuick.Layouts 1.12

import "qrc:/ControlSurface/Controls/Colorpicker"
import "qrc:/ControlSurface/Controls/Slider"
import "qrc:/ControlSurface/Controls/Button"
import "qrc:/ControlSurface/Controls/Position"
import "qrc:/ControlSurface/Controls/ImpulseButton"
import "qrc:/ControlSurface/Controls/ComboBox"


import Variable.Global 1.0

Column {
    spacing: 5
    property string name

    Rectangle {
        width: parent.width
        height: 5
        color: "#303030"
    }

    // Control surface name
    Text {
        id: controlSurfaceName
        text: name
        color: "white"
        font.pointSize: parent.height === 0
                        ? font.default
                        : (0.55 * window.width + 0.45 * window.height) / 75
    }

    // List of controls
    Flow {
        id: controlList
        width: parent.width
        spacing: 5

        // List of sliders
        ScoreSliders {
            id: scoreSliders
            signal appendSlider(var msg)
            signal modifySlider(var msg)
        }

        // List of Impulse buttons
        ScoreImpulseButtons {
            id: scoreImpulseButtons
            signal appendImpulseButton(var msg)
            signal modifyImpulseButton(var msg)
        }

        // List of buttons
        ScoreButtons {
            id: scoreButtons
            signal appendButton(var msg)
            signal modifyButton(var msg)
        }

        // List of colorpickers
        ScoreColorpicker {
            visible: false
            id: scoreColorpicker
            signal appendColorpicker(var msg)
            signal modifyColorpicker(var msg)
        }

        // List of positions
        ScorePosition {
            visible: false
            id: scorePosition
            signal appendPosition(var msg)
            signal modifyPosition(var msg)
        }

        // List of comboBoxes
        ScoreComboBoxes {
            id: scoreComboBox
            signal appendComboBox(var msg)
        }
    }

    // Receiving informations about controls in a control surface from score
    Connections {
        target: controlSurface
        // Adding controls in a control surface
        function onAppendControls(m) {
            controlSurfaceName.text = m.Name
            var i = 0
            var controlMessage = m.Controls[i]
            while (controlMessage) {
                switch (controlMessage.uuid) {
                case Uuid.floatSliderUUID:
                    // Float Slider
                    scoreSliders.appendSlider(controlMessage, i)
                    break
                case Uuid.logFloatSliderUUID:
                    // Log Float Slider
                    scoreSliders.appendSlider(controlMessage, i)
                    break
                case Uuid.intSliderUUID:
                    // Int Slider
                    scoreSliders.appendSlider(controlMessage, i)
                    break

                case Uuid.impulseButtonUUID:
                    // Impulse Button
                    scoreImpulseButtons.appendImpulseButton(controlMessage)
                    break

                case Uuid.buttonUUID:
                    // Button
                    scoreButtons.appendButton(controlMessage)
                    break

                case Uuid.colorPickerUUID:
                    // Colorpicker
                    scoreColorpicker.visible = true
                    scoreColorpicker.appendColorpicker(controlMessage)
                    break

                case Uuid.positionUUID:
                    // Position
                    scorePosition.visible = true
                    scorePosition.appendPosition(controlMessage)
                    break

                case Uuid.comboBoxUUID:
                    // ComboBox
                    scoreComboBox.appendComboBox(controlMessage)
                    break

                default:
                    break;
                }
                i++
                controlMessage = m.Controls[i]
            }
        }
        // Modifying controls in a control surface
        function onModifyControl(m) {

            if (m.Message === "ControlSurfaceControl") {
                scoreSliders.modifySlider(m)
                scoreColorpicker.modifyColorpicker(m)
                scoreImpulseButtons.modifyImpulseButton(m)
                scoreButtons.modifyButton(m)
            }
        }
    }
}

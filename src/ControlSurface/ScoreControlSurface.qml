/*
  * Control Surface :
  * - main object of the remote
  * - a control located in a control surface in score
  * can be modified in the application
  * - a control surface contains :
  *     - a name
  *     - several control lists :
  *         - slider (int, float, log)
  *         - impulse button
  *         - button
  *         - colorpicker
  *         - position
  *         - combobox
  * - handle message from score relayed by ScoreSkeleton.qml
  */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "qrc:/ControlSurface/Controls/Colorpicker"
import "qrc:/ControlSurface/Controls/Slider"
import "qrc:/ControlSurface/Controls/Button"
import "qrc:/ControlSurface/Controls/Position"
import "qrc:/ControlSurface/Controls/ImpulseButton"
import "qrc:/ControlSurface/Controls/ComboBox"
import "qrc:/ControlSurface/Controls/Knob"
import "qrc:/ControlSurface/Controls/SpinBox"
import "qrc:/ControlSurface/Controls/LineEdit"
import "qrc:/ControlSurface/Controls/RangeSlider"
import "qrc:/ControlSurface/Controls/VectorSlider"
import "qrc:/ControlSurface/Controls/VectorSpinBox"
import "qrc:/ControlSurface/Controls/Bargraph"
import "qrc:/ControlSurface/Controls/XYList"


import Variable.Global 1.0

Column {
    id: controlSurfaceListColumn

    property string name

    // Receiving information about controls in a control surface from score
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
                case Uuid.enumUUID:
                case Uuid.chooserToggleUUID:
                    // ComboBox / Enum / ChooserToggle
                    scoreComboBox.appendComboBox(controlMessage)
                    break

                case Uuid.intRangeSliderUUID:
                case Uuid.floatRangeSliderUUID:
                case Uuid.intRangeSpinBoxUUID:
                case Uuid.floatRangeSpinBoxUUID:
                    // Range sliders (value is a Vec2f [low, high])
                    scoreRangeSliders.appendRangeSlider(controlMessage, i)
                    break

                case Uuid.xyzSliderUUID:
                case Uuid.multiSliderUUID:
                    // Vector / multi sliders (N sub-sliders)
                    scoreVectorSliders.appendVectorSlider(controlMessage, i)
                    break

                case Uuid.xySpinboxesUUID:
                case Uuid.xyzSpinboxesUUID:
                    // Vector spinboxes (N numeric fields)
                    scoreVectorSpinBoxes.appendVectorSpinBox(controlMessage, i)
                    break

                case Uuid.bargraphUUID:
                    // Read-only level meter
                    scoreBargraphs.appendBargraph(controlMessage, i)
                    break

                case Uuid.multiSliderXYUUID:
                case Uuid.pathGeneratorXYUUID:
                    // List of 2D points (read-only plot)
                    scoreXYLists.appendXYList(controlMessage, i)
                    break

                case Uuid.floatKnobUUID:
                    // Knob
                    scoreKnobs.appendKnob(controlMessage, i)
                    break

                case Uuid.intSpinBoxUUID:
                case Uuid.floatSpinBoxUUID:
                case Uuid.timeChooserUUID:
                    // Spinboxes (int/float) and time chooser
                    scoreSpinBoxes.appendSpinBox(controlMessage, i)
                    break

                case Uuid.realButtonUUID:
                    // Momentary button (score Button)
                    scoreButtons.appendButton(controlMessage)
                    break

                case Uuid.lineEditUUID:
                case Uuid.programEditUUID:
                case Uuid.fileChooserUUID:
                case Uuid.folderChooserUUID:
                case Uuid.audioFileChooserUUID:
                case Uuid.videoFileChooserUUID:
                    // Text fields and file/folder choosers
                    scoreLineEdits.appendLineEdit(controlMessage, i)
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
                scoreKnobs.modifyKnob(m)
                scoreSpinBoxes.modifySpinBox(m)
                scoreLineEdits.modifyLineEdit(m)
                scoreRangeSliders.modifyRangeSlider(m)
                scoreVectorSliders.modifyVectorSlider(m)
                scoreVectorSpinBoxes.modifyVectorSpinBox(m)
                scoreBargraphs.modifyBargraph(m)
                scoreXYLists.modifyXYList(m)
            }
        }
    }

    spacing: 5

    // Control surface name
    Button {
        id: controlSurfaceNameButton
        width: controlSurfaceListColumn.width
        height: window.height <= 600 ? 30 : 5 + window.height / 25

        background: Rectangle {
            anchors.fill: parent
            color: Skin.gray1
        }

        contentItem: Item {
            anchors.fill: parent
            Text {
                id: controlSurfaceName
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 5
                text: name
                color: controlSurfaceNameButton.pressed ? Skin.orange : Skin.white
                font.pointSize:  window.width <= 500
                                 ? 10
                                 : window.width <= 1200
                                   ? 12
                                   : 15
            }

            Image {
                id: indicator
                anchors.verticalCenter: parent.verticalCenter
                width: parent.height
                height: parent.height
                anchors.right: parent.right
                anchors.rightMargin: 5
                source: !controlList.visible
                        ? controlSurfaceNameButton.pressed
                          ? "../Icons/indicator_on.png"
                          : "../Icons/indicator.png"
                        : controlSurfaceNameButton.pressed
                          ? "../Icons/indicator_hidden_on.png"
                          : "../Icons/indicator_hidden.png"
            }
        }

        onReleased: {
            controlList.visible = ! controlList.visible
        }
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
            id: scoreColorpicker

            signal appendColorpicker(var msg)
            signal modifyColorpicker(var msg)

            visible: false
        }

        // List of positions
        ScorePosition {
            id: scorePosition

            signal appendPosition(var msg)
            signal modifyPosition(var msg)

            visible: false
        }

        // List of comboBoxes
        ScoreComboBoxes {
            id: scoreComboBox

            signal appendComboBox(var msg)
        }

        // List of knobs
        ScoreKnobs {
            id: scoreKnobs

            signal appendKnob(var msg, var ind)
            signal modifyKnob(var msg)
        }

        // List of spinboxes (int/float/time)
        ScoreSpinBoxes {
            id: scoreSpinBoxes

            signal appendSpinBox(var msg, var ind)
            signal modifySpinBox(var msg)
        }

        // List of text fields (line edit / program / file choosers)
        ScoreLineEdits {
            id: scoreLineEdits

            signal appendLineEdit(var msg, var ind)
            signal modifyLineEdit(var msg)
        }

        // List of range sliders
        ScoreRangeSliders {
            id: scoreRangeSliders

            signal appendRangeSlider(var msg, var ind)
            signal modifyRangeSlider(var msg)
        }

        // List of vector / multi sliders
        ScoreVectorSliders {
            id: scoreVectorSliders

            signal appendVectorSlider(var msg, var ind)
            signal modifyVectorSlider(var msg)
        }

        // List of vector spinboxes
        ScoreVectorSpinBoxes {
            id: scoreVectorSpinBoxes

            signal appendVectorSpinBox(var msg, var ind)
            signal modifyVectorSpinBox(var msg)
        }

        // List of bargraphs (read-only meters)
        ScoreBargraphs {
            id: scoreBargraphs

            signal appendBargraph(var msg, var ind)
            signal modifyBargraph(var msg)
        }

        // List of XY-point lists (read-only plots)
        ScoreXYLists {
            id: scoreXYLists

            signal appendXYList(var msg, var ind)
            signal modifyXYList(var msg)
        }
    }
}

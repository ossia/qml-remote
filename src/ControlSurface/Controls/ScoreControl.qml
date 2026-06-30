/*
  * Generic control delegate — renders ONE control (in score order) by loading
  * the matching widget for its uuid. Reuses the existing per-type widgets
  * (each instance holds a single control), so author order is preserved while
  * the widgets' append/modify logic stays unchanged.
  */

import QtQuick

import "qrc:/ControlSurface/Controls/Slider"
import "qrc:/ControlSurface/Controls/Knob"
import "qrc:/ControlSurface/Controls/SpinBox"
import "qrc:/ControlSurface/Controls/LineEdit"
import "qrc:/ControlSurface/Controls/ComboBox"
import "qrc:/ControlSurface/Controls/Button"
import "qrc:/ControlSurface/Controls/ImpulseButton"
import "qrc:/ControlSurface/Controls/Colorpicker"
import "qrc:/ControlSurface/Controls/Position"
import "qrc:/ControlSurface/Controls/RangeSlider"
import "qrc:/ControlSurface/Controls/VectorSlider"
import "qrc:/ControlSurface/Controls/VectorSpinBox"
import "qrc:/ControlSurface/Controls/Bargraph"
import "qrc:/ControlSurface/Controls/XYList"

import Variable.Global 1.0

Loader {
    id: ctrl

    property var m            // the control message
    signal doModify(var msg)  // broadcast of ControlSurfaceControl updates

    readonly property string uuid: m ? m.uuid : ""

    sourceComponent: {
        switch (uuid) {
        case Uuid.floatSliderUUID:
        case Uuid.intSliderUUID:
        case Uuid.logFloatSliderUUID:   return c_sliders
        case Uuid.floatKnobUUID:        return c_knobs
        case Uuid.intSpinBoxUUID:
        case Uuid.floatSpinBoxUUID:
        case Uuid.timeChooserUUID:      return c_spinboxes
        case Uuid.lineEditUUID:
        case Uuid.programEditUUID:
        case Uuid.fileChooserUUID:
        case Uuid.folderChooserUUID:
        case Uuid.audioFileChooserUUID:
        case Uuid.videoFileChooserUUID: return c_lineedits
        case Uuid.comboBoxUUID:
        case Uuid.enumUUID:
        case Uuid.chooserToggleUUID:    return c_comboboxes
        case Uuid.buttonUUID:
        case Uuid.realButtonUUID:       return c_buttons
        case Uuid.impulseButtonUUID:    return c_impulse
        case Uuid.colorPickerUUID:      return c_colorpicker
        case Uuid.positionUUID:         return c_position
        case Uuid.intRangeSliderUUID:
        case Uuid.floatRangeSliderUUID:
        case Uuid.intRangeSpinBoxUUID:
        case Uuid.floatRangeSpinBoxUUID: return c_ranges
        case Uuid.xyzSliderUUID:
        case Uuid.multiSliderUUID:      return c_vectorsliders
        case Uuid.xySpinboxesUUID:
        case Uuid.xyzSpinboxesUUID:     return c_vectorspinboxes
        case Uuid.bargraphUUID:         return c_bargraphs
        case Uuid.multiSliderXYUUID:
        case Uuid.pathGeneratorXYUUID:  return c_xylists
        default:                        return null
        }
    }

    Component { id: c_sliders
        ScoreSliders {
            signal appendSlider(var msg, var ind); signal modifySlider(var msg)
            Component.onCompleted: appendSlider(ctrl.m, 0)
            Connections { target: ctrl; function onDoModify(msg) { modifySlider(msg) } }
        }
    }
    Component { id: c_knobs
        ScoreKnobs {
            signal appendKnob(var msg, var ind); signal modifyKnob(var msg)
            Component.onCompleted: appendKnob(ctrl.m, 0)
            Connections { target: ctrl; function onDoModify(msg) { modifyKnob(msg) } }
        }
    }
    Component { id: c_spinboxes
        ScoreSpinBoxes {
            signal appendSpinBox(var msg, var ind); signal modifySpinBox(var msg)
            Component.onCompleted: appendSpinBox(ctrl.m, 0)
            Connections { target: ctrl; function onDoModify(msg) { modifySpinBox(msg) } }
        }
    }
    Component { id: c_lineedits
        ScoreLineEdits {
            signal appendLineEdit(var msg, var ind); signal modifyLineEdit(var msg)
            Component.onCompleted: appendLineEdit(ctrl.m, 0)
            Connections { target: ctrl; function onDoModify(msg) { modifyLineEdit(msg) } }
        }
    }
    Component { id: c_comboboxes
        ScoreComboBoxes {
            signal appendComboBox(var msg)
            Component.onCompleted: appendComboBox(ctrl.m)
        }
    }
    Component { id: c_buttons
        ScoreButtons {
            signal appendButton(var msg); signal modifyButton(var msg)
            Component.onCompleted: appendButton(ctrl.m)
            Connections { target: ctrl; function onDoModify(msg) { modifyButton(msg) } }
        }
    }
    Component { id: c_impulse
        ScoreImpulseButtons {
            signal appendImpulseButton(var msg); signal modifyImpulseButton(var msg)
            Component.onCompleted: appendImpulseButton(ctrl.m)
            Connections { target: ctrl; function onDoModify(msg) { modifyImpulseButton(msg) } }
        }
    }
    Component { id: c_colorpicker
        ScoreColorpicker {
            signal appendColorpicker(var msg); signal modifyColorpicker(var msg)
            Component.onCompleted: appendColorpicker(ctrl.m)
            Connections { target: ctrl; function onDoModify(msg) { modifyColorpicker(msg) } }
        }
    }
    Component { id: c_position
        ScorePosition {
            signal appendPosition(var msg); signal modifyPosition(var msg)
            Component.onCompleted: appendPosition(ctrl.m)
        }
    }
    Component { id: c_ranges
        ScoreRangeSliders {
            signal appendRangeSlider(var msg, var ind); signal modifyRangeSlider(var msg)
            Component.onCompleted: appendRangeSlider(ctrl.m, 0)
            Connections { target: ctrl; function onDoModify(msg) { modifyRangeSlider(msg) } }
        }
    }
    Component { id: c_vectorsliders
        ScoreVectorSliders {
            signal appendVectorSlider(var msg, var ind); signal modifyVectorSlider(var msg)
            Component.onCompleted: appendVectorSlider(ctrl.m, 0)
            Connections { target: ctrl; function onDoModify(msg) { modifyVectorSlider(msg) } }
        }
    }
    Component { id: c_vectorspinboxes
        ScoreVectorSpinBoxes {
            signal appendVectorSpinBox(var msg, var ind); signal modifyVectorSpinBox(var msg)
            Component.onCompleted: appendVectorSpinBox(ctrl.m, 0)
            Connections { target: ctrl; function onDoModify(msg) { modifyVectorSpinBox(msg) } }
        }
    }
    Component { id: c_bargraphs
        ScoreBargraphs {
            signal appendBargraph(var msg, var ind); signal modifyBargraph(var msg)
            Component.onCompleted: appendBargraph(ctrl.m, 0)
            Connections { target: ctrl; function onDoModify(msg) { modifyBargraph(msg) } }
        }
    }
    Component { id: c_xylists
        ScoreXYLists {
            signal appendXYList(var msg, var ind); signal modifyXYList(var msg)
            Component.onCompleted: appendXYList(ctrl.m, 0)
            Connections { target: ctrl; function onDoModify(msg) { modifyXYList(msg) } }
        }
    }
}

import QtQuick 2.15
import QtQuick.Layouts 1.12

ColumnLayout {
    spacing: 5
    property string name: "ControlSurfaceName"

    // Control surface name
    Text {
        id: controlSurfaceName
        text: name
        color: "white"
    }

    // List of controls
    Flow {
        width: window.width
        spacing: 5

        // List of sliders
        ScoreSliders {
            id: scoreSliders
            signal appendSlider(var msg)
            signal modifySlider(var msg)
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
    }

    // Receiving informations about controls in a control surface from score
    Connections {
        target: controlSurface
        // Adding controls in a control surface
        function onAppendControls(m) {
            controlSurfaceName.text = JSON.stringify(m.Name)
            var i = 0
            var controlMessage = m.Controls[i]
            while (controlMessage) {
                switch (controlMessage.uuid) {
                case "af2b4fc3-aecb-4c15-a5aa-1c573a239925":
                    // Float Slider
                    scoreSliders.appendSlider(controlMessage)
                    break
                case "5554eb67-bcc8-45ab-8ec2-37a3f191aa64":
                    // Log FLoat Slider
                    scoreSliders.appendSlider(controlMessage)
                    break
                case "348b80a4-45dc-4f70-8f5f-6546c85089a2":
                    // Int Slider
                    scoreSliders.appendSlider(controlMessage)
                    break
                case "feb87e84-e0d2-428f-96ff-a123ac964f59":
                    // Button
                    scoreButtons.appendButton(controlMessage)
                    break
                case "8f38638e-9f9f-48b0-ae36-1cba86ef5703":
                    // Colorpicker
                    scoreColorpicker.visible = true
                    scoreColorpicker.appendColorpicker(controlMessage)
                    break
                }
                i++
                controlMessage = m.Controls[i]
            }
        }
        // Modifying controls in a control surface
        function onModifyControl(m) {
            if (m === "ControlSurfaceControl") {
                scoreSliders.modifySlider(m)
            }
        }
    }
}

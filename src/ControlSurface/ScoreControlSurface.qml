import QtQuick 2.15
import QtQuick.Layouts 1.12

import "../Colorpicker"
import "../Slider"
import "../Button"


ColumnLayout {
    spacing: 5
    property string name

    //property var sliderControl: width
    Rectangle {
        width: window.width
        height: 5
        color: "#303030"
    }

    // Control surface name
    Text {
        id: controlSurfaceName
        text: name
        color: "white"
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
                case "af2b4fc3-aecb-4c15-a5aa-1c573a239925":
                    // Float Slider
                    scoreSliders.appendSlider(controlMessage, i)
                    break
                case "5554eb67-bcc8-45ab-8ec2-37a3f191aa64":
                    // Log FLoat Slider
                    scoreSliders.appendSlider(controlMessage, i)
                    break
                case "348b80a4-45dc-4f70-8f5f-6546c85089a2":
                    // Int Slider
                    scoreSliders.appendSlider(controlMessage, i)
                    break
                case "7cd210d3-ebd1-4f71-9de6-cccfb639cbc3":
                    // Button
                    scoreButtons.appendButton(controlMessage)
                    break
                case "8f38638e-9f9f-48b0-ae36-1cba86ef5703":
                    // Colorpicker
                    scoreColorpicker.visible = true
                    scoreColorpicker.appendColorpicker(controlMessage)
                    break

                    /*
                case "8093743c-584f-4bb9-97d4-6c7602f87116":
                    // Position
                    scorePosition.visible = true
                    scorePosition.appendPosition(controlMessage)
                    break
                    */
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
                //scoreButtons.modifyButton(m)
            }
        }
    }
}

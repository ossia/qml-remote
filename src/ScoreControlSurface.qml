import QtQuick 2.0
import QtQuick.Layouts 1.12



Column{
    spacing: 5
    property string name: "ControlSurfaceName"
    property string controlSurfaceMessage: "ControlSurfaceMessage"
    Text{
        id: controlSurfaceName
        text: name
        color: "white"
    }

    ScoreSliders{
        id: scoreSliders
        signal appendSlider(var msg)
    }

    // Add controls in th Control Surface
    Connections {
        target: controlSurface
        function onAppendControls(m){
            controlSurfaceName.text = JSON.stringify(m.Name)
            var i = 0
            var controlMessage = m.Controls[i]
            while(controlMessage){
                switch(controlMessage.uuid){
                    // Float Slider
                    case "af2b4fc3-aecb-4c15-a5aa-1c573a239925":
                        scoreSliders.appendSlider(controlMessage)
                        break
                    // Log FLoat Slider
                    case "5554eb67-bcc8-45ab-8ec2-37a3f191aa64":
                        scoreSliders.appendSlider(controlMessage)
                        break
                    // Int Slider
                    case "348b80a4-45dc-4f70-8f5f-6546c85089a2":
                        scoreSliders.appendSlider(controlMessage)
                        break
                }
                i++
                controlMessage = m.Controls[i]
            }
        }
    }
}

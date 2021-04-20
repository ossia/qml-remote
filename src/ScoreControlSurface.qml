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
            /*
    Grid{
        columns: 5
        spacing: 5


        OssiaPosition{
            id: positions
            width: 300
            height: 150
            //Layout.alignment: e
        }
        OssiaColorpicker{
            id: ossiaColorpicker
        }

    }
    */

    //A finir

    // Add controls in th Control Surface
    Connections {
        target: controlSurface
        function onAppendControls(m){
            console.log("uuuuuuuuuuuuuuuuuuu")
            controlSurfaceName.text = JSON.stringify(m.Name)
            var i = 0
            while(m.Controls[i]){
                scoreSliders.appendSlider(m.Controls[i])
                i++
            }
        }
    }
}

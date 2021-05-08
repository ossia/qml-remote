import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.12



ListView{
    id: scoreControlSurfaces
    //width: parent.width
    spacing: 20
    anchors.left: parent.left
    anchors.margins: 5
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    height: parent.height
    orientation:ListView.Vertical
    clip: true
    snapMode: ListView.SnapToItem
    model:ListModel {
        id: controlSurfacelist
    }
    delegate:
        Loader {
            id: controlSurface
            signal appendControls(var msg)
            signal modifyControl(var msg)
            source: "ScoreControlSurface.qml"
            onProgressChanged: {
                console.log("ooooooooooooooooooooooo")
                if (myValue !== "efef"){
                    console.log("kkkkkkkkkkkkkkkkkk")
                    controlSurface.modifyControl(m)
                }
            }
            onLoaded: {
                //à finir
                console.log("rrrrrrrrrrrrrrrrrr")
                if(m.Message === "ControlSurfaceAdded"){
                    console.log("iiiiiiiiiiiiiii")
                    controlSurface.appendControls(m)
                }
                else if (myValue !== "efef"){
                    controlSurface.modifyControl(m)
                }
            }
            property var myValue: "efef"
        }
            /*
            Connections {
                target: scoreControlSurfaces
                onTest: controlSurface.modifyControl(m)
            }
            */
        //}
    Connections {
        target: scoreControlSurfaces
        function onControlSurfacesMessageReceived(m){
            var messageObject = m.Message
            function find(cond) {
                for(var i = 0; i < controlSurfacelist.count; ++i) if (cond(controlSurfacelist.get(i))) return i;
                return null
            }
            var s = find(function (item) { return item.path === JSON.stringify(m.Path) }) //the index of m.Path in the listmodel
            if(messageObject === "ControlSurfaceAdded"){
                if(s === null){
                    controlSurfacelist.insert(0,{ "name":JSON.stringify(m.Name), "path":JSON.stringify(m.Path), m:m});
                }
            }
            else if(messageObject === "ControlSurfaceRemoved"){
                if(s !== null){
                    controlSurfacelist.remove(s)
                    //controlSurfacelist.clear()
                }
            }
            else if(messageObject === "ControlSurfaceControl"){
                if(s !== null){
                    console.log("eeeeeeeeeeeeeeeeeeeeeeeeeee")
                    console.log(controlSurfacelist.get(s).myValue)
                    controlSurfacelist.setProperty(s, "myValue", JSON.stringify(m.Value))
                    console.log(controlSurfacelist.get(s).myValue)
                }
                //controlSurfacelist.setProperty(s, "name", "desactivated")
                // manque traitement a faire (par exemple changer la couleur du background et le rendre immodifiable)
            }
        }
    }

    // Called by OssiaStop
    function clearListModel() {
        controlSurfacelist.clear()
    }
}



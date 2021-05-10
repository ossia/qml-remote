import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.12

ListView {
    id: scoreControlSurfaceList
    spacing: 20
    anchors.left: parent.left
    anchors.margins: 5
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    height: parent.height
    orientation: ListView.Vertical
    clip: true
    snapMode: ListView.SnapToItem
    model: ListModel {
        id: controlSurfacelist
    }
    delegate: Loader {
        id: controlSurface
        signal appendControls(var msg)
        signal modifyControl(var msg)
        source: "ScoreControlSurface.qml"
        onLoaded: {
            controlSurface.appendControls(m)
        }
        /*
        onActiveChanged: {
            controlSurface.modifyControl("le bon controle")
        }
        */
    }
    // Receiving and handling messages about Control Surfaces from score
    Connections {
        target: scoreControlSurfaceList
        function onControlSurfacesMessageReceived(m) {
            var messageObject = m.Message
            function find(cond) {
                for (var i = 0; i < controlSurfacelist.count; ++i)
                    if (cond(controlSurfacelist.get(i)))
                        return i
                return null
            }
            //the index of m.Path in the listmodel
            var s = find(function (item) {
                return item.path === JSON.stringify(m.Path)
            })
            // Adding a control surface
            if (messageObject === "ControlSurfaceAdded") {
                if (s === null) {
                    controlSurfacelist.insert(0, {
                                                  "name": JSON.stringify(
                                                              m.Name),
                                                  "path": JSON.stringify(
                                                              m.Path),
                                                  "m": m
                                                  //, sliders: ""
                                              })
                }
            } // Removing a control surface
            else if (messageObject === "ControlSurfaceRemoved") {
                if (s !== null) {
                    controlSurfacelist.remove(s)
                }
            }


            /* Modifying a control in a control surface            */
            else if(messageObject === "ControlSurfaceControl"){
                if(s !== null){
                    //controlSurfacelist.setProperty(s, "myValue", JSON.stringify(m.Value))
                    console.log("SurfaceControl")
                    console.log(JSON.stringify(controlSurfacelist.get(s))) // continuer la dessus
                    console.log("1111111111111111111111")
                    // Première technique

                    console.log(JSON.stringify(controlSurfacelist.get(s)))

                    // Deuxième Technique
                    /*
                    var newSurfaceControl = controlSurfacelist.get(s)
                    for (var i = 0; i < controlSurfacelist.count; ++i){
                        console.log(JSON.stringify(newSurfaceControl.m.Controls[i]))
                        if(controlSurfacelist.get(s).m.Controls[i].id === m.Control){
                            newSurfaceControl.m.Controls[i].Value.Float = m.Value.Float
                        }
                    }
                    console.log("newSurfaceControl")
                    console.log(JSON.stringify(newSurfaceControl))
                    controlSurfacelist.set(s, newSurfaceControl)
                    */
                }
            }
        }
    }
}

import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.12


Rectangle{
    id: scoreControlSurfaces
    radius:6
    color: "#262626"
    //width: parent.width
    //height: parent.height
    ListView{
        //width: parent.width
        spacing: 5
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
            Item{
                id: controlSurface
                signal appendControls(var msg)
                Loader {
                   id: myControlSurface
                   source: "ScoreControlSurface.qml"
                   //controlSurfaceMessage: 10
                   onLoaded: {
                       controlSurface.appendControls(m)
                   }
                }
                /*
                Connections {
                    target: myControlSurface.item
                    onAppendControlSurface: console.log(msg)
                }
                */
            }
    }
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
                    //scoreControlSurface.controlMessageReceived(m.Controls);
                    //controlSurfacelist.get(0).appendControls(m.Controls)
                    //ontrolSurfacelist.get(0).appendControls(m.Controls);

                }
            }
            else if(messageObject === "ControlSurfaceRemoved"){
                if(s !== null){
                    controlSurfacelist.remove(s)
                    //controlSurfacelist.clear()

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

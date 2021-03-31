import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.12


Rectangle{
    id: ossiaControlSurfaces
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
            ScoreControlSurface{
                controlSurfaceName: name
        }
    }
    Connections {
        target: ossiaControlSurface
        function onControlSurfaceMessageReceived(m){
            var messageObject = m.Message
            function find(cond) {
                for(var i = 0; i < controlSurfacelist.count; ++i) if (cond(controlSurfacelist.get(i))) return i;
                return null
            }
            var s = find(function (item) { return item.path === JSON.stringify(m.Path) }) //the index of m.Path in the listmodel
            if(messageObject === "ControlSurfaceAdded"){
                if(s === null){
                    controlSurfacelist.insert(0,{ name:JSON.stringify(m.Path), path:JSON.stringify(m.Path)});
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

    // Called by ScoreStop
    function clearListModel() {
        controlSurfacelist.clear()
    }
}

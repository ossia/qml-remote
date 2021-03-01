import QtQuick 2.0
import QtQuick.Layouts 1.15
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.15


Rectangle{
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

           ListElement {
               name: "Control Surface 1"
           }
           ListElement {
               name: "Control Surface 2"
           }
           ListElement {
               name: "Control Surface 3"
           }
           ListElement {
               name: "Control Surface 4"
           }
           ListElement {
               name: "Control Surface 5"
           }
           ListElement {
               name: "Control Surface 6"
           }
           ListElement {
               name: "Control Surface 7"
           }
               ListElement {
               name: "Control Surface 8"
           }
           ListElement {
               name: "Control Surface 9"
           }
           ListElement {
               name: "Control Surface 10"
           }
           ListElement {
               name: "Control Surface 11"
           }
           ListElement {
            name: "Control Surface 12"
           }
       }
       delegate:
           OssiaControlSurface{controlSurfaceName: name}
    }
    Connections {
        target: ossiaTimeSet
        function onControlSurfaceMessageReceived(m){
            var messageObject = m.Message
            if(messageObject === "ControlSurfaceAdded"){
                controlSurfacelist.insert(0,{ name:JSON.stringify(m.Path)});
            }
            else if(messageObject === "ControlSurfaceRemoved"){
                function find(cond) {
                  for(var i = 0; i < controlSurfacelist.count; ++i) if (cond(controlSurfacelist.get(i))) return i;
                  return null
                }
                var s = find(function (item) { return item.name === JSON.stringify(m.Path) }) //the index of m.Path in the listmodel
                controlSurfacelist.setProperty(s, "name", "desactivated")
                // manque traitement a faire (par exemple changer la couleur du background et le rendre immodifiable)
            }
          }
        }
}

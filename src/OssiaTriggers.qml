import QtQuick 2.0
import QtQuick.Layouts 1.15
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.15

Rectangle{
    radius:9
    color: "#202020"
    ListView{
        id:triggerslist
        width: parent.width ;height:parent.height
        orientation: ListView.Horizontal
        clip: true
        spacing: 5
        snapMode: ListView.SnapToItem
        model:ListModel {
            id: triggerslistModel
            /*
            ListElement {
                name: "Trigger133"
                path: "Trigger133"
            }
            ListElement {
                name: "Trigger2"
                path: "Trigger133"
            }
            ListElement {
                name: "Trigger3"
                path: "Trigger133"
            }
            ListElement {
                name: "Trigger133"
                path:"Trigger133"
            }
            ListElement {
            name: "Trigger2"
            path: "Trigger133"
            }
            ListElement {
                name: "Trigger3"
                path:"Trigger133"
            }
            ListElement {
                name: "Trigger133"
                path:"Trigger133"
          }
          ListElement {
              name: "Trigger2"
              path:"Trigger133"
          }
          ListElement {
              name: "Trigger3"
              path:"Trigger133"
          }
          ListElement {
              name: "Trigger133"
              path:"Trigger133"
          }
          ListElement {
              name: "Trigger2"
              path:"Trigger133"
          }
          ListElement {
              name: "Trigger3"
              path:"Trigger133"
          }*/
        }
        delegate:OssiaTrigger{
            ossiaPath:path
            height:triggerslist.height
            sliderName: name
        }
    }



    //implementation de la fonction
    Connections {
        target: ossiaTimeSet
        function onTriggerMessageReceived(m){
            var messageObject = m.Message
            var PathsObject = m.Path[0].ObjectName
            var new_path = ""
            var i = 0;
            while(i<5){
                new_path = new_path + m.Path[i].ObjectName + "." + m.Path[i].ObjectId +"/"
                /*
                console.log("---------_________________________________--------------------------------");
                 console.log(JSON.stringify(new_path));
                console.log("-----------___________________________________------------------------------");
                */
                i++
            }

            if(messageObject === "TriggerAdded"){
                triggerslistModel.insert(0,{ name:JSON.stringify(m.Name),path:JSON.stringify(new_path)});
                //triggerslistModel.insert(0,{ name:JSON.stringify(m.Name),path:JSON.stringify(PathsObject[0].ObjectName)});

            }
            else if(messageObject === "TriggerRemoved"){
                function find(cond) {
                    for(var i = 0; i < triggerslistModel.count; ++i) if (cond(triggerslistModel.get(i))) return i;
                    return null
                }
                var s = find(function (item) { return item.path === JSON.stringify(new_path) }) //the index of m.Path in the listmodel
                if(s !== null){
                    triggerslistModel.remove(s)
                }
            }
        }
    }
}


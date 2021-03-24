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
            */
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

            if(messageObject === "TriggerAdded"){
                triggerslistModel.insert(0,{ name:JSON.stringify(m.Name),path:JSON.stringify(m.Path)});
                //triggerslistModel.insert(0,{ name:JSON.stringify(m.Name),path:JSON.stringify(PathsObject[0].ObjectName)});

            }
            else if(messageObject === "TriggerRemoved"){
                function find(cond) {
                    for(var i = 0; i < triggerslistModel.count; ++i) if (cond(triggerslistModel.get(i))) return i;
                    return null
                }
                var s = find(function (item) { return item.path === JSON.stringify(m.Path) }) //the index of m.Path in the listmodel
                if(s !== null){
                    triggerslistModel.remove(s)
                }
            }
        }
    }
}


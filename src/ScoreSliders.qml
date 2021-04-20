import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.12

ColumnLayout{
    spacing: 5
    height: 200
    width: 300
    ListView{
        id:sliderList
        clip: true
        spacing: 10
        anchors.fill: parent
        anchors.margins: 5
        orientation: parent.Vertical
        snapMode: ListView.SnapToItem
        model: ListModel {
            id: sliderListModel
        }
        delegate: ScoreSlider{
            controlName: myName
            height: 20
            anchors.left: parent.left
            anchors.right: parent.right
            controlColor: "#f6a019"
            from: myFrom
            value: myValue
            to: myTo
        }
    }
    Connections{
        function onAppendSlider(s) {
            console.log("uuuuuuuuuuuuuuuuuu")
            console.log(JSON.stringify(s))
            console.log("uuuuuuuuuuuuuuuuuu")
            function find(cond) {
                for(var i = 0; i < sliderListModel.count; ++i) if (cond(sliderListModel.get(i))) return i;
                return null
            }
            var a = find(function (item) { return item.id === JSON.stringify(s.id) }) //the index of m.Path in the listmodel
            if(a === null){
                sliderListModel.insert(0,{ myName:JSON.stringify(s.Custom),
                                           myFrom: JSON.stringify(s.Domain.Float.Min),
                                           myValue: JSON.stringify(s.Value.Float),
                                           myTo: JSON.stringify(s.Domain.Float.Max)});
            }
        }
    }
}

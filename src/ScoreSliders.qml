import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.12

ColumnLayout{
    spacing: 5
    width: 300
    Repeater{
        id:triggerslist
        clip: true
        model: ListModel {
            id: slidersListModel
        }
        delegate: ScoreSlider{
            id: slider
            height: 20
            width: 300
            controlColor: "#f6a019"
        }
    }
    function appendSlider(s) {
        function find(cond) {
            for(var i = 0; i < slidersListModel.count; ++i) if (cond(slidersListModel.get(i))) return i;
            return null
        }
        var a = find(function (item) { return item.id === JSON.stringify(m.id) }) //the index of m.Path in the listmodel
        if(a === null){
            slidersListModel.insert(0,{ id:JSON.stringify(m.id)});
        }
    }
}

import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.1
import QtQuick.Controls 2.2
import QtQuick.Window 2.12


import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.12

Rectangle {
    id: speedList
    width: parent.width / 4
    height: parent.height
    color: "#202020"
    anchors.right: parent.right
    ListView {
        id: lView
        //width: speedList.width
        //height:speedList.height
        spacing: 10
        anchors.fill: parent
        anchors.margins: 5
        orientation: parent.Vertical
        clip: true
        snapMode: ListView.SnapToItem

        model: ListModel {
            id: intervalsListModel
        }
        delegate: ScoreSlider {
            id: speed
            controlName: name
            height: 20
            anchors.right: parent.right
            anchors.rightMargin: 25
            anchors.left: parent.left
            from: -120
            value: speedValue
            to: 600
            controlColor: "#62400a"
            controlPath : path
            onMoved: {
                console.log('bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb');
                console.log('{ "Message": "IntervalSpeed", "Path":'.concat(speed.controlPath, ', "Speed": ',speed.value*6/720, '}'));
                console.log('bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb');
                socket.sendTextMessage(('{ "Message": "IntervalSpeed", "Path":'.concat(speed.controlPath, ', "Speed": ',speed.value*6/720, '}')))
            }
        }
        ScrollBar.vertical: ScrollBar {
            id: scrollBar
            width: 20
            anchors.right: parent.right
            policy: ScrollBar.AlwaysOn
            contentItem: Rectangle {
                radius: width / 2
                color: "#303030"
            }
        }
    }
    //implementation de la fonction
    Connections {
        target: scoreTimeSet
        function onIntervalMessageReceived(m) {
            var messageObject = m.Message
            if(messageObject === "IntervalAdded"){
                console.log('rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
                console.log(JSON.stringify(m.Speed));
                console.log('rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
                intervalsListModel.insert(0, {
                                              name:JSON.stringify(m.Name),path:JSON.stringify(m.Path),speedValue:JSON.stringify(m.Speed)*720/6
                                          });
                console.log(intervalsListModel.get(0).value);
            }
            else if(messageObject === "IntervalRemoved"){
                function find(cond) {
                    for(var i = 0; i < intervalsListModel.count; ++i) if (cond(intervalsListModel.get(i))) return i;
                    return null
                }
                var s = find(function (item) {
                    return item.path === JSON.stringify(m.Path)
                }) //the index of m.Path in the listmodel
                if(s !== null){
                    intervalsListModel.remove(s);
                }
                // manque traitement a faire (passer la bonne vitesse de lecture .. )
            }

        }
    }

    Connections {
        target: scoreTimeSet
        function onIntervalsMessageReceived(m) {
            var IntervalsObject = m.Intervals;
            var count = 0;
            while(IntervalsObject[count]){
                for(var i = 0; i < intervalsListModel.count; ++i){
                    if (intervalsListModel.get(i).path === JSON.stringify(IntervalsObject[count].Path)){ // The global path is the first one to be created by score
                        intervalsListModel.set(i,{"speedValue": JSON.stringify(IntervalsObject[count].Speed)*720/6});
                    }
                }
            count++
            }
        }
    }

    // Called by OssiaStop
    function clearListModel() {
        intervalsListModel.clear()
    }
}

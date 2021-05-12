import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.12

ColumnLayout {
    spacing: 5

    property alias model: sliderListModel

    Repeater {
        id: sliderList
        clip: true
        Layout.fillHeight: parent.height
        Layout.fillWidth: parent.height
        Layout.margins: 5

        model: ListModel {
            id: sliderListModel
        }

        delegate: ScoreSlider {
            id: slider
            controlName: myName
            height: 20
            anchors.left: parent.left
            anchors.right: parent.right
            controlColor: "#f6a019"
            controlId: myId
            from: myFrom
            value: myValue
            to: myTo
            controlPath: path
            stepSize: myStepSize
            controlInd: myInd
            controlUuid: myUuid
            onMoved: {
                socket.sendTextMessage(
                            '{ "Message": "ControlSurface","Path":'.concat(
                                slider.controlPath, ', "id":',
                                slider.controlId, ', "Value": {"Float":',
                                slider.value, '}}'))
            }
        }
    }

    // Receving informations about sliders in control surface from score
    Connections {
        // Adding a slider in the control surface
        function onAppendSlider(s, ind) {
            function find(cond) {
                for (var i = 0; i < sliderListModel.count; ++i)
                    if (cond(sliderListModel.get(i)))
                        return i
                return null
            }
            var a = find(function (item) {
                return item.id === JSON.stringify(s.id)
            }) //the index of m.Path in the listmodel
            if (a === null) {
                var tmpFrom, tmpValue, tmpTo
                var tmpStepSize
                switch (s.uuid) {
                    // Float Slider
                case "af2b4fc3-aecb-4c15-a5aa-1c573a239925":
                    tmpFrom = s.Domain.Float.Min
                    tmpValue = s.Value.Float
                    tmpTo = s.Domain.Float.Max
                    tmpStepSize = 0.0
                    break
                    // Int Slider
                case "348b80a4-45dc-4f70-8f5f-6546c85089a2":
                    tmpFrom = s.Domain.Int.Min
                    tmpValue = s.Value.Int
                    tmpTo = s.Domain.Int.Max
                    tmpStepSize = 1
                    break
                }
                sliderListModel.insert(sliderListModel.count, {
                                           "myName": s.Custom,
                                           "myId": s.id,
                                           "myFrom": JSON.stringify(tmpFrom),
                                           "myValue": tmpValue,
                                           "myTo": JSON.stringify(tmpTo),
                                           "myStepSize": tmpStepSize,
                                           "myInd": ind,
                                           "myUuid": s.uuid
                                       })
            }
        }
        // Modifying a slider in the control surface
        function onModifySlider(s) {
            /*
            function find(cond) {
                for (var i = 0; i < sliderListModel.count; ++i)
                    if (cond(sliderListModel.get(i)))
                        return i
                return null
            }
            var a = find(function (item) {
                return item.id === JSON.stringify(s.id)
            }) //the index of m.Path in the listmodel
            if (a !== null) {
                var tmpValue
                switch (s.uuid) {
                    // Float Slider
                case "af2b4fc3-aecb-4c15-a5aa-1c573a239925":
                    tmpValue = s.Value.Float
                    break
                    // Int Slider
                case "348b80a4-45dc-4f70-8f5f-6546c85089a2":
                    tmpValue = s.Value.Int
                    break
                }
                sliderListModel.set(a, {
                                        "myValue": JSON.stringify(tmpValue)
                                    })
            }
            */
            console.log("333333333333333333333333")
            for (var i = 0; i < sliderListModel.count; ++i){
                if(sliderListModel.get(i).myId === s.Control){
                    console.log(JSON.stringify(sliderListModel.get(i)))
                    console.log(JSON.stringify(s))
                    console.log(JSON.stringify(sliderListModel.get(i).MyUuid))
                    var tmpValue
                    switch (sliderListModel.get(i).myUuid) {
                        // Float Slider
                    case "af2b4fc3-aecb-4c15-a5aa-1c573a239925":
                        tmpValue = s.Value.Float
                        break
                        // Int Slider
                    case "348b80a4-45dc-4f70-8f5f-6546c85089a2":
                        tmpValue = s.Value.Int
                        break
                    }
                    sliderListModel.set(i, {
                                            "myValue": tmpValue
                                        })
                }
            }
        }
    }
}

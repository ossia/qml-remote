import QtQuick 2.0
import QtQuick.Layouts 1.15

ColumnLayout{
    spacing: 5
    Repeater{
            model: ["Intervalle 1", "Intervalle 2", "Intervalle 3"]
            OssiaSlider{
                id: speed
                controlName: modelData
                height: 20; width:200
                controlColor: "#62400a"
            }
        }
}

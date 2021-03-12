import QtQuick 2.0
import QtQuick.Layouts 1.15

ColumnLayout{
    spacing: 5
    width: window.width/4
    Repeater{
            model: ["ze 1", "te 2", "etnen 3"]
            OssiaSlider{
                id: slider
                controlName: modelData
                height: 20; width: window.width/4
                controlColor: "#f6a019"
            }
        }
}

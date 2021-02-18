import QtQuick 2.0
import QtQuick.Layouts 1.15

Column{
    spacing: 5
    property string controlSurfaceName: "ControlSurfaceName"
    Text{
        text: controlSurfaceName
        color: "white"
    }
    Grid{
        columns: 3
        spacing: 5
        OssiaSliders{
            id: ossiaSlider
            //Layout.alignment: Qt.AlignTop
        }

        OssiaPosition{
            id: positions
            width: 300
            height: 150
            //Layout.alignment: e
        }
    }
}

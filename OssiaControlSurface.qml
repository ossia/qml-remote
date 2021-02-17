import QtQuick 2.0
import QtQuick.Layouts 1.15

ColumnLayout{
    spacing: 5
    property string controlSurfaceName: "ControlSurfaceName"
    Text{
        text: controlSurfaceName
        color: "white"
    }
    GridLayout{
        columns: 4
        OssiaSliders{
            //Layout.alignment: Qt.AlignTop
        }
        OssiaPosition{
            //Layout.alignment: e
        }
    }
}

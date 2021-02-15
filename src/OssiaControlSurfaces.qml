import QtQuick 2.0
import QtQuick.Layouts 1.15


ColumnLayout{
    spacing: 5
    Repeater{
            model: ["Control Surface 1", "Control Surface 2"]
            OssiaControlSurface{
                controlSurfaceName: modelData
            }
        }
}

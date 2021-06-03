import QtQuick 2.12
import QtQuick.Window 2.12

// Control Skeleton
Item {
    id: control
    // Variables send by score
    property string controlCustom
    property string controlDomain
    property string controlValueType
    property string controlValueData
    property int controlId
    property string controlUuid

    property string controlSurfacePath

    property string controlUnit: ""
    property color controlColor: "#e0b01e"
}

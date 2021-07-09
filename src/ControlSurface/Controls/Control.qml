import QtQuick 2.12
import QtQuick.Window 2.12

import Variable.Global 1.0

// Control Skeleton
Item {
    id: control

    // Variables sent by score
    property string controlCustom
    property string controlDomain
    property string controlValueType
    property string controlValueData
    property int controlId
    property string controlUuid
    property string controlSurfacePath
    property string controlUnit: ""
    property color controlColor: Skin.orange
}

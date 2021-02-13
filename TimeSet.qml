import QtQuick 2.0
import QtQuick.Layouts 1.15

Item{
    OssiaPlayPauseStop{
        id: ossiaPlayPauseStop
        anchors.left: parent.left
    }
    OssiaTriggers{
        id: ossiaTrigger
        anchors.left: ossiaPlayPauseStop.right
    }
    OssiaSpeeds{
        anchors.right: parent.right
    }
}

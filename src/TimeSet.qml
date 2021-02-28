
import QtQuick 2.0
import QtQuick.Layouts 1.15

Item{
    //width: window.width

    //property QQuickAnchorLine margeLeft: ossiaPlayPauseStop.right
    /*OssiaPlayPauseStop{
        id: ossiaPlayPauseStop
        anchors.left: parent.left
    }*/
    OssiaTriggers{
        id: ossiaTrigger
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: ossiaSpeed.left
        anchors.rightMargin: window.width/100
        anchors.bottom: parent.bottom
        //height: window.height/4.94

    }
    OssiaSpeeds{
        id:ossiaSpeed
        anchors.right: parent.right
    }
}

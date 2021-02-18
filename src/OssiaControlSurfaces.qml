import QtQuick 2.0
import QtQuick.Layouts 1.15
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.15


Rectangle{
    radius:6
    color: "#262626"
    //width: parent.width
    //height: parent.height
    ListView{
       //width: parent.width
       spacing: 5
       anchors.left: parent.left
       anchors.margins: 5
       anchors.right: parent.right
       anchors.top: parent.top
        anchors.bottom: parent.bottom
       height: parent.height
       orientation:ListView.Vertical
       clip: true
       snapMode: ListView.SnapToItem
       model:ListModel {
           id: controlSurfacelist

           ListElement {
               name: "Control Surface 1"
           }
           ListElement {
               name: "Control Surface 2"
           }
           ListElement {
               name: "Control Surface 3"
           }
           ListElement {
               name: "Control Surface 4"
           }
           ListElement {
               name: "Control Surface 5"
           }
           ListElement {
               name: "Control Surface 6"
           }
           ListElement {
               name: "Control Surface 7"
           }
               ListElement {
               name: "Control Surface 8"
           }
           ListElement {
               name: "Control Surface 9"
           }
           ListElement {
               name: "Control Surface 10"
           }
           ListElement {
               name: "Control Surface 11"
           }
           ListElement {
            name: "Control Surface 12"
           }
       }
       delegate:
           OssiaControlSurface{controlSurfaceName: name}
    }
}

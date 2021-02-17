import QtQuick 2.0
import QtQuick.Layouts 1.15
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.15

Rectangle{
    radius:6
    color: "grey"
    border.color: "black"
    width: parent.width ;height: parent.height
    ListView{
       anchors.leftMargin: window.height/5
       width: parent.width ;height: parent.height
       orientation:ListView.Vertical
       clip: true
       snapMode: ListView.SnapToItem
       model:ListModel {
           id: triggerslist

           ListElement {
               name: "Trigger133"
           }
           ListElement {
               name: "Trigger2"
           }
           ListElement {
               name: "Trigger3"
           }
           ListElement {
               name: "Trigger133"
           }
           ListElement {
               name: "Trigger2"
           }
           ListElement {
               name: "Trigger3"
           }
           ListElement {
               name: "Trigger133"
           }
               ListElement {
               name: "Trigger2"
           }
           ListElement {
               name: "Trigger3"
           }
           ListElement {
               name: "Trigger133"
           }
           ListElement {
               name: "Trigger2"
           }
           ListElement {
            name: "Trigger3"
           }
       }
       delegate:
           OssiaControlSurface{controlSurfaceName: name}
    }
}

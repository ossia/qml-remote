import QtQuick 2.0
import QtQuick.Layouts 1.15
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.15

Rectangle{
    radius:9
    color: "grey"
    border.color: "black"
    ListView{
        id:triggerslist
        width: parent.width ;height:parent.height
        orientation: ListView.Horizontal
        clip: true
        snapMode: ListView.SnapToItem
        model:ListModel {
            id: triggerslistModel

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
      delegate:OssiaTrigger{
          height:triggerslist.height
          sliderName: name
          }
    }
}

import QtQuick 2.15
import QtQuick.Layouts 1.15




 ListView {
        orientation: ListView.Horizontal
        spacing: 5
        //x:20
        implicitWidth: 400
        height: window/10
        model: OssiaTriggerModel{}
}

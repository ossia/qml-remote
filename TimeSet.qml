import QtQuick 2.0
import QtQuick.Layouts 1.15


RowLayout{
    id: area
    Layout.preferredWidth: window.width
    //Layout.minimumWidth: window.width
    OssiaPlayPauseStop{
        Layout.alignment: Qt.AlignTop
    }
    OssiaTriggers{
        Layout.alignment: Qt.AlignTop
    }
    OssiaSpeeds{
        Layout.alignment: Qt.AlignRight | Qt.AlignTop
    }
}

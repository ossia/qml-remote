import QtQuick 2.0
import QtQuick.Layouts 1.15

Item {
    id: window
    height: parent.height
    width: parent.width
    ColumnLayout{
        Layout.preferredWidth: parent.width
        Layout.preferredHeight: parent.height
        spacing: 10
        RowLayout{
            spacing: 0
            Layout.minimumWidth: window.width
            OssiaVolume{
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            }

            OssiaSpeed{
                Layout.alignment: Qt.AlignRight | Qt.AlignTop
            }

        }
        TimeSet{}
        OssiaControlSurfaces{}
    }
    OssiaTimeLine{
        anchors.bottom: parent.bottom
    }
}

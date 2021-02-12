import QtQuick 2.9
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtMultimedia 5.0
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.15


ColumnLayout{
    spacing: -25
    Layout.maximumWidth: 30
    Layout.minimumWidth: 35
    OssiaPlayPause{}
    OssiaPlayGlob{}
    OssiaStop{}
    OssiaReinitialize{}
}

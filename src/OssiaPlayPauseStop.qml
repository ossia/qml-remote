import QtQuick 2.9
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtMultimedia 5.0
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.15


Column{
    OssiaPlayPause{id: playPause}
    OssiaPlayGlob{id: playGlob}
    OssiaStop{id: stop}
    OssiaReinitialize{id: reinitialize}
}

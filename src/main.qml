import QtQuick 2.12
import QtQuick.Window 2.12

import "Skeleton"

import Variable.Global 1.0

// Creation of the main window of the application
Window {
    id: mainWindow
    width: 1000
    height: 600
    visible: true
    title: qsTr("Remote Control")
    color: Color.darkGray

    // Creation of the application's skeleton
    ScoreSkeleton {}
}

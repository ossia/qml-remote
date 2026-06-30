/*
  * Main window of the application :
  * - color, size, title, skeleton of the application are defined
  */

import QtQuick
import QtQuick.Window

import "Skeleton"

import Variable.Global 1.0

// Creation of the main window of the application
Window {
    id: mainWindow
    width: 1000
    height: 600
    visible: true
    title: qsTr("Remote Control")
    color: Skin.darkGray

    // The whole UI is rendered at a logical size and uniformly scaled by the
    // user's zoom factor (uiScale); all responsive sizing then runs on logical
    // pixels, so layout reflow + density both follow the zoom.
    ScoreSkeleton {
        id: skeleton
        transformOrigin: Item.TopLeft
        scale: skeleton.uiScale
        width: mainWindow.width / skeleton.uiScale
        height: mainWindow.height / skeleton.uiScale
    }
}

//  Fancy pseudo-3d control border

import QtQuick 2.9

import Variable.Global 1.0

Rectangle {
    width: 40; height: 15
    anchors { leftMargin: 1; topMargin: 3 }
    border { width: 1; color: Skin.black }
    radius: 2
    color: Skin.transparent
    clip: true

    Rectangle {
        anchors { fill: parent; leftMargin: -1; topMargin: -1; rightMargin: 0; bottomMargin: 0 }
        radius: 2
        border { width: 1; color: Skin.lightGray }
        color: Skin.transparent
    }
}

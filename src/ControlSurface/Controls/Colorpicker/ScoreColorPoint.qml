/*
  * Define a colorpoint
  * Is located in a colorpicker in a Control Surface
  * All colorpickers of a same control surface in score share a common colorpanel
  */

import QtQuick 2.12
import QtQuick.Controls 2.12

import Variable.Global 1.0

Rectangle {
    id: colorButton

    property string controlCustom
    property string controlDomain
    property string controlValueType
    property string controlValueData
    property int controlId
    property string controlUuid
    property string controlSurfacePath
    property color controlColor
    property color displayedColor: "#a7dd0dFF"

    color: Skin.brown

    Text {
        id: colorName

        anchors { left: colorButton.left; leftMargin: 5; horizontalCenter: colorButton.horizontalCenter }
        text: controlCustom
        font.pointSize: parent.width <= 200 ? 8 : 10
        color: Skin.white
    }

    PanelBorder {
        anchors {
            left: colorName.left; right: parent.right
            top: colorName.bottom; bottom: parent.bottom
            margins: 5
        }

        Rectangle {
            id: colorValue

            width: parent.width; height: parent.height
            border { color: Skin.black; width: 1 }
            color: colorButton.displayedColor
        }
    }

    MouseArea {
        id: colorMouseAreaButton

        anchors.fill: parent
        onClicked: colorButton.state = "off"
    }

    states: State {
        name: "off"

        PropertyChanges {
            target: colorValue
            color: colorValue.color
        }

        PropertyChanges {
            target: colorButton
            color: Skin.gray1
        }

        PropertyChanges {
            target: colorMouseAreaButton
            onClicked: colorButton.state = ""
        }
    }
}

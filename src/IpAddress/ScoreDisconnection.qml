/*
  * Disconnection Button :
  * - at the top left of the interface with others buttons
  * - visible when the remote is connected to score
  * - when the button is pressed: a window appears asking for confirmation
  * of the disconnection
  */

import QtQuick
import QtQuick.Controls

import Variable.Global 1.0

Button {
    id: control

    visible: false
    padding: 0; topPadding: 0; bottomPadding: 0; leftPadding: 0; rightPadding: 0
    hoverEnabled: true
    onClicked: disconnectDiag.open()
    background: Rectangle { color: Skin.darkGray }

    contentItem: Image {
        id: disconnect_image
        sourceSize { width: parent.width; height: parent.width }
        source: control.down ? "../Icons/disconnected_on.png" : "../Icons/disconnected.png"
        fillMode: Image.PreserveAspectFit
        clip: true
    }

    // Disconnection window
    Dialog {
        id: disconnectDiag

        title: qsTr("Disconnection")
        modal: true
        anchors.centerIn: Overlay.overlay
        width: 320

        standardButtons: Dialog.Ok | Dialog.Cancel

        onAccepted: {
            ip_button.visible = true
            window.disconnect()
            socket.active = false
        }

        Label {
            width: parent.width
            text: qsTr("Do you really want to disconnect?")
            color: Skin.white
            wrapMode: Text.WordWrap
        }
    }
}

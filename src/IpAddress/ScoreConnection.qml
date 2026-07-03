/*
  * Connection Button :
  * - at the top left of the interface with others buttons
  * - visible when the remote is disconnected form score
  * - when the button is pressed: a window appears asking for IP address
  */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Variable.Global 1.0

Button {
    id: control

    padding: 0; topPadding: 0; bottomPadding: 0; leftPadding: 0; rightPadding: 0
    hoverEnabled: true
    onClicked: ipDialog.open()
    background: Rectangle { color: Skin.darkGray }

    contentItem: Image {
        id: ipButton
        sourceSize { width: parent.width; height: parent.width }
        source: control.down ? "../Icons/ip_address_on.png" : "../Icons/ip_address.png"
        fillMode: Image.PreserveAspectFit
        clip: true
    }

    // Connection window
    Dialog {
        id: ipDialog

        title: qsTr("Connection")
        modal: true
        anchors.centerIn: Overlay.overlay
        width: 320

        standardButtons: Dialog.Ok | Dialog.Cancel

        onAccepted: settings.ip_address = ipInput.text
        onRejected: ipInput.text = settings.ip_address
        onOpened: {
            ipInput.text = settings.ip_address
            ipInput.selectAll()
            ipInput.forceActiveFocus()
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 12

            Label {
                text: qsTr("IP address")
                font.family: Skin.font
                color: Skin.white
            }

            TextField {
                id: ipInput
                Layout.fillWidth: true
                text: settings.ip_address
                font.family: Skin.font
                color: Skin.white
                verticalAlignment: TextInput.AlignVCenter
                inputMethodHints: Qt.ImhPreferNumbers
                onAccepted: ipDialog.accept()
                background: Rectangle {
                    color: Skin.darkGray
                    border.color: Skin.brown
                    // Non-floating placeholder (see ScoreLineEdit): empty-only.
                    Text {
                        anchors.fill: parent
                        leftPadding: ipInput.leftPadding; rightPadding: ipInput.rightPadding
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                        text: "127.0.0.1"
                        color: Skin.gray3
                        font: ipInput.font
                        visible: ipInput.text.length === 0
                    }
                }
            }
        }
    }
}

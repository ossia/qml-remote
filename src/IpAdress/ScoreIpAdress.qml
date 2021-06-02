import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.12

Column {
    width: parent.width

    Button {
        id: ip_button
        width: parent.width
        height: parent.width

        Dialog {
            id: ipDialog
            title: "Adresse IP:"
            standardButtons: StandardButton.Ok | StandardButton.Cancel
            Column {
                anchors.fill: parent
                Rectangle {
                    anchors.top: ipDialog.top
                    color: "#202020"
                    TextInput {
                        id: ipInput
                        text: settings.ip_adress
                    }
                }
            }

            onButtonClicked: {
                if (clickedButton === StandardButton.Ok) {
                    settings.ip_adress = ipInput.text
                } else {
                }
            }
        }
        hoverEnabled: true
        onPressed: {
            ipButton.state = "ip_on"
        }
        onReleased: {
            onClicked: ipDialog.open()
        }

        onHoveredChanged: {
            if (ipButton.state === 'ip_on') {
                ipButton.state = ""
            }
        }

        contentItem: Image {
            id: ipButton
            sourceSize.width: parent.width
            sourceSize.height: parent.width
            source: "../Icons/ip_adress.png"
            clip: true
            states: [
                State {

                    /* play symbol is displayed
                * "paused" is the scenario's state.
                */
                    name: "ip_on"
                    PropertyChanges {
                        target: ipButton
                        source: "../Icons/ip_adress_on.png"
                    }
                }
            ]
        }
        background: Rectangle {
            id: zone
            color: "#202020"
        }
    }

    Button {
        id: disconnectButton
        width: parent.width
        height: parent.width

        Dialog {
            id: disconnectDiag
            title: "Disconnection"
            standardButtons: StandardButton.Ok | StandardButton.Cancel
            Text {
                id: diagDisconnection
                text: qsTr("Confirm disconnection")
            }

            onButtonClicked: {
                if (clickedButton === StandardButton.Ok) {
                    ip_button.visible = true
                    socket.active = false
                } else {

                }
            }
        }

        contentItem: Image {
            id: disconnect_image
            sourceSize.width: parent.width
            sourceSize.height: parent.width
            source: "../Icons/disconnected.png"
            clip: true
            states: [
                State {
                    name: "disconnect"
                    PropertyChanges {
                        target: disconnect_image
                        source: "../Icons/disconnected.png"
                    }
                },
                State {
                    name: "disconnect_on"
                    PropertyChanges {
                        target: disconnect_image
                        source: "../Icons/disconnected_on.png"
                    }
                }
            ]
        }
        background: Rectangle {
            id: diagDisconnect
            color: "#202020"
        }
        onPressed: {
            disconnect_image.state = 'disconnect_on'
        }

        onReleased: {
            disconnectDiag.open()
        }
        hoverEnabled: true
        onHoveredChanged: {
            if (disconnect_image.state === 'disconnect_on') {
                disconnect_image.state = 'disconnect'
            }
        }
        visible: false
    }
    function connected() {
        ip_button.visible = !ip_button.visible
        disconnectButton.visible = !disconnectButton.visible
    }
    function disconnected() {
        ip_button.visible = true
        disconnectButton.visible = false
    }
}

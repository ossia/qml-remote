import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.12

Column {

    // Score Connection
    ScoreConnection {
        id: ip_button
        width: parent.width
        height: parent.width
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

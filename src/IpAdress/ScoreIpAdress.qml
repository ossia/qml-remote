import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.12

Column {

    Button {
        id: ip_button
        width: parent.width
        height: parent.width

        // Connection window
        Dialog {
            id: ipDialog
            title: "Connection"
            width: 300
            height: 100

            contentItem: Rectangle {
                anchors.fill: parent
                color: "#303030"

                Rectangle {
                    id: connectionWindow
                    anchors.fill: parent
                    anchors.margins: 10
                    color: "#303030"

                    Rectangle {
                        width: parent.width
                        height: 50
                        anchors.top: parent.top
                        color: "#303030"

                        Text {
                            id: ipText
                            text: "Ip adress"
                            color: "white"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        // TextField to enter the IP adress
                        TextField {
                            id: ipInput
                            text: settings.ip_adress
                            anchors.left: ipText.right
                            anchors.leftMargin: 10
                            width: parent.width <= 160 ? 65 : 100
                            anchors.verticalCenter: parent.verticalCenter
                            color: "white"

                            background: Rectangle {
                                anchors.fill: parent
                                color: "#202020"
                                border.color: "#62400a"
                            }
                        }
                    }

                    // OK button
                    Button {
                        id: okButton
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        width: 75
                        height: 30

                        contentItem: Text {
                            id: okButtonText
                            color: "white"
                            text: qsTr("OK")
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onPressed: {
                            switch (okButton.state) {
                            case "hoveredOK":
                                okButton.state = "pressedOK"
                                break
                            }
                        }

                        onReleased: {
                            settings.ip_adress = ipInput.text
                            ipDialog.close()
                        }

                        onHoveredChanged: {
                            switch (okButton.state) {
                            case "":
                                okButton.state = "hoveredOK"
                                break
                            case "hoveredOK":
                                okButton.state = ""
                                break
                            case "pressedOK":
                                okButton.state = ""
                                break
                            }
                        }

                        background: Rectangle {
                            id: okButtonBackground
                            anchors.fill: parent
                            color: "#202020"
                            border.color: "#505050"
                            border.width: 0.5
                        }

                        states: [
                            State {
                                name: "hoveredOK"
                                PropertyChanges {
                                    target: okButtonBackground
                                    border.color: "#62400a"
                                }
                            },
                            State {
                                name: "pressedOK"
                                PropertyChanges {
                                    target: okButtonBackground
                                    border.color: "#e0b01e"
                                    color: "#62400a"
                                }
                                PropertyChanges {
                                    target: okButtonText
                                    opacity: 0.5
                                }
                            }
                        ]
                    }
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

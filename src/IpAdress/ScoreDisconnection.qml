/*
  * Disconnection Button :
  * - at the top left of the interface with others buttons
  * - visible when the remote is connected to score
  * - when the button is pressed: a window appears asking for confirmation
  * of the disconnection
  */

import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.12

import Variable.Global 1.0

Button {
    // Disconnection window
    Dialog {
        id: disconnectDiag
        title: "Disconnection"
        width: 300
        height: 100

        contentItem: Rectangle {
            anchors.fill: parent
            color: Color.gray1

            Rectangle {
                id: connectionWindow
                anchors.fill: parent
                anchors.margins: 10
                color: Color.gray1

                Rectangle {
                    width: parent.width
                    height: 50
                    anchors.top: parent.top
                    color: Color.gray1

                    Text {
                        id: ipText
                        text: "Do you really want to disconnect?"
                        color: Color.white
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                // OK button
                Button {
                    id: okButton
                    anchors.right: cancelButton.left
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 10
                    width: 75
                    height: 30

                    contentItem: Text {
                        id: okButtonText
                        color: Color.white
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
                        ip_button.visible = true
                        window.disconnect()
                        socket.active = false
                        disconnectDiag.close()
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
                        color: Color.darkGray
                        border.color: "#505050"
                        border.width: 0.5
                    }

                    states: [
                        State {
                            name: "hoveredOK"
                            PropertyChanges {
                                target: okButtonBackground
                                border.color: Color.brown
                            }
                        },
                        State {
                            name: "pressedOK"
                            PropertyChanges {
                                target: okButtonBackground
                                border.color: "#e0b01e"
                                color: Color.brown
                            }
                            PropertyChanges {
                                target: okButtonText
                                opacity: 0.5
                            }
                        }
                    ]
                }

                // Cancel button
                Button {
                    id: cancelButton
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    width: 75
                    height: 30

                    contentItem: Text {
                        id: cancelButtonText
                        color: Color.white
                        text: qsTr("Cancel")
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onPressed: {
                        switch (cancelButton.state) {
                        case "hoveredCANCEL":
                            cancelButton.state = "pressedCANCEL"
                            break
                        }
                    }

                    onReleased: {
                        disconnectDiag.close()
                    }

                    onHoveredChanged: {
                        switch (cancelButton.state) {
                        case "":
                            cancelButton.state = "hoveredCANCEL"
                            break
                        case "hoveredCANCEL":
                            cancelButton.state = ""
                            break
                        case "pressedCANCEL":
                            cancelButton.state = ""
                            break
                        }
                    }

                    background: Rectangle {
                        id: cancelButtonBackground
                        anchors.fill: parent
                        color: Color.darkGray
                        border.color: "#505050"
                        border.width: 0.5
                    }

                    states: [
                        State {
                            name: "hoveredCANCEL"
                            PropertyChanges {
                                target: cancelButtonBackground
                                border.color: Color.brown
                            }
                        },
                        State {
                            name: "pressedCANCEL"
                            PropertyChanges {
                                target: cancelButtonBackground
                                border.color: "#e0b01e"
                                color: Color.brown
                            }
                            PropertyChanges {
                                target: cancelButtonText
                                opacity: 0.5
                            }
                        }
                    ]
                }
            }
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
        color: Color.darkGray
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

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

    background: Rectangle { id: diagDisconnect; color: Skin.darkGray }
    onPressed: disconnect_image.state = 'disconnect_on'
    onReleased: disconnectDiag.open()
    hoverEnabled: true
    visible: false

    onHoveredChanged: {
        if (disconnect_image.state === 'disconnect_on') {
            disconnect_image.state = 'disconnect'
        }
    }

    contentItem: Image {
        id: disconnect_image
        sourceSize { width: parent.width; height: parent.width }
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

    // Disconnection window
    Dialog {
        id: disconnectDiag

        title: "Disconnection"

        onButtonClicked: {
            if (clickedButton === StandardButton.Ok) {
                ip_button.visible = true
                socket.active = false
            }
        }

        contentItem: Rectangle {
            width: 300; height: 100
            color: Skin.gray1

            Rectangle {
                id: connectionWindow

                anchors { fill: parent; margins: 10 }
                color: Skin.gray1

                Rectangle {
                    width: parent.width; height: 50
                    anchors.top: parent.top
                    color: Skin.gray1

                    Text {
                        id: ipText

                        anchors { left: parent.left; verticalCenter: parent.verticalCenter }
                        text: "Do you really want to disconnect?"
                        color: Skin.white
                    }
                }

                // OK button
                Button {
                    id: okButton

                    width: 75; height: 30
                    anchors { right: cancelButton.left; bottom: parent.bottom; rightMargin: 10 }

                    contentItem: Text {
                        id: okButtonText

                        color: Skin.white
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
                        color: Skin.darkGray
                        border { color: Skin.gray3; width: 0.5}
                    }

                    states: [
                        State {
                            name: "hoveredOK"

                            PropertyChanges {
                                target: okButtonBackground
                                border.color: Skin.brown
                            }
                        },
                        State {
                            name: "pressedOK"

                            PropertyChanges {
                                target: okButtonBackground
                                border.color: "#e0b01e"
                                color: Skin.brown
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

                    width: 75; height: 30
                    anchors { right: parent.right; bottom: parent.bottom }

                    contentItem: Text {
                        id: cancelButtonText
                        color: Skin.white
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

                    onReleased: disconnectDiag.close()

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
                        color: Skin.darkGray
                        border { color: Skin.gray3; width: 0.5}
                    }

                    states: [
                        State {
                            name: "hoveredCANCEL"
                            PropertyChanges {
                                target: cancelButtonBackground
                                border.color: Skin.brown
                            }
                        },
                        State {
                            name: "pressedCANCEL"

                            PropertyChanges {
                                target: cancelButtonBackground
                                border.color: "#e0b01e"
                                color: Skin.brown
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
    }
}

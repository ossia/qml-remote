/*
  * Connection Button :
  * - at the top left of the interface with others buttons
  * - visible when the remote is disconnected form score
  * - when the button is pressed: a window appears asking for IP adress
  */

import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.12

import Variable.Global 1.0

Button {
    // Connection window
    Dialog {
        id: ipDialog
        title: "Connection"
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
                        text: "Ip adress"
                        color: Color.white
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
                        color: Color.white

                        background: Rectangle {
                            anchors.fill: parent
                            color: Color.darkGray
                            border.color: Color.brown
                        }
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
                        window.state = "connected"
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
                        ipInput.text = settings.ip_adress
                        ipDialog.close()
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
        color: Color.darkGray
    }
}

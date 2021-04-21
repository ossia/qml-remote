import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtMultimedia 5.0
import QtQuick.Controls.Material 2.3
import QtQuick.Dialogs 1.2

Button {
    Dialog {
        id: ipDialog
        title: "Adresse IP:"
        standardButtons: StandardButton.Ok | StandardButton.Cancel
        Column {
            anchors.fill: parent
            Rectangle{
                anchors.top : ipDialog.top
                color: "#202020"
                TextInput {
                    id: ipInput
                    text: settings.adresse_ip
                }
            }
        }

        onButtonClicked: {
            console.log("HELLO")
            if (clickedButton === StandardButton.Ok) {
                settings.adresse_ip = ipInput.text;
               // settings.setValue("settings.adresse_ip",socket.adresse_IP)
                console.log(" socket url " + socket.url)
                console.log("adresse ip = " + settings.adresse_ip)
            } else {
                console.log("Rejected url = " + socket.url)
            }
        }
    }
    hoverEnabled: true
    onPressed: {
            ipButton.state = "ip_on"
    }
    onReleased: {
        console.log("avant cc = " + settings.cc)
       onClicked: ipDialog.open()
    }

    onHoveredChanged: {
        if (ipButton.state === 'ip_on'){
            ipButton.state = ""
        }

    }

    contentItem: Image {
        id: ipButton
        sourceSize.width: 35
        sourceSize.height: 35
        source: "Icons/adresse_ip.png"
        clip: true
        states: [
            State {
                /* play symbol is displayed
                * "paused" is the scenario's state.
                */
                name: "ip_on"
                PropertyChanges {
                    target: ipButton
                    source: "Icons/adresse_ip_on.png"
                    }
                }
            ]
    }
    background: Rectangle {
        id: zone
        color: "#202020"
    }
}
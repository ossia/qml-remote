import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: button
    implicitWidth: (window.width <= 500 ? 100 : (window.width >= 1200 ? 150 : 100 + ((window.width + window.height) / 100)))
    implicitHeight: (window.width <= 500 ? 100 : (window.width >= 1200 ? 150 : 100 + ((window.width + window.height) / 100)))

    property string controlCustom
    property string controlDomain
    property string controlValueType
    property string controlValueData
    property int controlId
    property string controlUuid
    property string controlSurfacePath

    property bool isPressed
    property bool firstPressedFromScore: true
    property bool pressedFromScore
    property bool pressedFromRemote: false

    contentItem: Text {
        text: controlCustom
        color: "#ffffff"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: parent.height === 0 ? 1 : parent.height / 12
        elide: Text.ElideRight
    }

    indicator: Rectangle {
        implicitWidth: parent.width - 10
        implicitHeight: parent.height - 10
        anchors.centerIn: parent
        color: button.isPressed ? "#f6a019" : "#303030"
        border.width: 5
        border.color: "#303030"
    }

    background: Rectangle {
        implicitWidth: parent.width
        implicitHeight: parent.height
        color: "#f6a019"
    }

    onPressedFromScoreChanged: {

        // Almost works

        /*
        if (pressedFromRemote) {
            console.log("PressedFromRemote")
            pressedFromRemote = false
            return
        }
        console.log("onPressedFromScoreChanged")
        if(firstPressedFromScore){
            console.log("FirstPressedFromScore")
            if(!isPressed){
                //isPressed = true
            }
            indicator.color = isPressed ? "#f6a019" : "#303030"
            firstPressedFromScore = false
            return
        }
        console.log(indicator.color)
        console.log(isPressed)
        indicator.color = isPressed ? "#303030" : "#f6a019"
        console.log(indicator.color)
        console.log("PressedFromScore")
        if(isPressed){
            isPressed = false
        } else {
            isPressed = true
        }
        */
    }

    onClicked: {
        pressedFromRemote = true
        indicator.color = isPressed ? "#303030" : "#f6a019"
        if (isPressed) {
            isPressed = false
            socket.sendTextMessage(
                        '{ "Message": "ControlSurface","Path":'.concat(
                            button.controlSurfacePath, ', "id":',
                            button.controlId, ', "Value":{"Bool":false}}'))
        } else {
            isPressed = true
            socket.sendTextMessage(
                        '{ "Message": "ControlSurface","Path":'.concat(
                            button.controlSurfacePath, ', "id":',
                            button.controlId, ', "Value":{"Bool":true}}'))
        }
    }
}

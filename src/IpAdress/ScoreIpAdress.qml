/*
  * At the top left of the interface with others buttons
  * Contain ScoreConnection and ScoreDisconnection :
  * - ScoreConnection : a window which is asking for ip adress
  * - ScoreConnection : a window for disconnection
  *
  */

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

    // Score Disconnection
    ScoreDisconnection {
        id: disconnectButton
        width: parent.width
        height: parent.width
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

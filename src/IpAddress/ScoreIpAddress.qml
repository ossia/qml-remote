/*
  * At the top left of the interface with others buttons
  * Contain ScoreConnection and ScoreDisconnection :
  * - ScoreConnection : a window which is asking for ip address
  * - ScoreDisconnection : a window for disconnection
  */

import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Controls.Material
import QtQuick.Layouts

Column {

    function connected() {
        ip_button.visible = ! ip_button.visible
        disconnectButton.visible = ! disconnectButton.visible
    }

    function disconnected() {
        ip_button.visible = true
        disconnectButton.visible = false
    }

    // Score Connection
    ScoreConnection {
        id: ip_button
        width: parent.width; height: parent.width
    }

    // Score Disconnection
    ScoreDisconnection {
        id: disconnectButton
        width: parent.width; height: parent.width
    }
}

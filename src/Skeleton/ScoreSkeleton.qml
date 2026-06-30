/*
  * Skeleton of the app — a single responsive layout that adapts to
  * desktop / web / tablet (landscape and portrait):
  * - top bar: transport (connect / play-pause / stop) + main speed + hide,
  *   wrapping when the width is small
  * - collapsible trigger + speed panels
  * - control surfaces filling the remaining space
  * - timeline pinned to the bottom
  */

import QtQuick
import QtQuick.Window
import QtWebSockets
import QtQuick.Layouts
import QtQuick.Controls
import QtCore

import Variable.Global 1.0

import "qrc:/WebSocket"
import "qrc:/IpAddress"
import "qrc:/PlayPauseStop"
import "qrc:/Trigger"
import "qrc:/Speed"
import "qrc:/Speeds"
import "qrc:/HideButton"
import "qrc:/ControlSurface"
import "qrc:/Timeline"

Item {
    id: window

    // Narrow screens (phone / tablet portrait) stack the top bar vertically.
    readonly property bool compact: width < 720
    // Whether the trigger / speed panels are shown (toggled by the hide button).
    property bool panelsVisible: true
    // Whether the websocket is connected to score.
    readonly property bool connected: socket.status === WebSocket.Open
    // Transport button size (touch-friendly, capped so it isn't huge on big screens).
    readonly property int btn: Math.max(Skin.minTouch, Math.min(72, Math.round(width / 18)))
    readonly property int panelHeight: Math.max(Skin.minTouch * 2, Math.round(height * 0.16))
    readonly property int speedWidth: compact ? Math.max(Skin.minTouch, width - btn - 28)
                                              : Math.round(width / 3)
    // How many side panels actually have content (empty ones are hidden).
    readonly property int visiblePanelCount: (scoreTriggers.count > 0 ? 1 : 0)
                                           + (scoreSpeeds.count > 0 ? 1 : 0)

    // Called when the remote is disconnected from score
    function disconnect() {
        scoreTriggers.clearTriggerList()
        scoreSpeeds.clearSpeedList()
        scoreControlSurfaceList.clearControlSurfaceList()
        scoreTimeline.stopTimeline()
    }

    // Persisted global UI zoom. The window sizes + scales this item (main.qml),
    // so this multiplies the whole UI (sizes, fonts, spacing, touch targets).
    property alias uiScale: settings.uiScale

    // A field to save the IP address + UI zoom
    Settings {
        id: settings
        property string ip_address: "127.0.0.1"
        property real uiScale: 1.0
    }

    // Pinch (touch) and Ctrl+wheel (desktop / web) adjust the global zoom.
    PinchHandler {
        target: null
        property real base: 1
        onActiveChanged: if (active) base = settings.uiScale
        onActiveScaleChanged: settings.uiScale = Math.max(0.7, Math.min(1.6, base * activeScale))
    }
    WheelHandler {
        acceptedModifiers: Qt.ControlModifier
        onWheel: (ev) => {
            var s = settings.uiScale * (ev.angleDelta.y > 0 ? 1.08 : 1 / 1.08)
            settings.uiScale = Math.max(0.7, Math.min(1.6, s))
        }
    }

    // The websocket
    ScoreWebSocket {
        id: socket
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 5
        // Reserve space at the bottom on mobile so the timeline isn't hidden
        // behind the browser / system chrome.
        anchors.bottomMargin: is_mobile ? 50 : 5
        spacing: 5

        // ===== TOP BAR (wraps on narrow screens) =====
        Flow {
            Layout.fillWidth: true
            spacing: 8

            // Transport: connect / play-pause / stop, laid out horizontally
            Row {
                spacing: 4

                ScoreIpAddress {
                    id: ipAddress
                    signal playPauseStopMessageReceived(var n)
                    width: window.btn
                }

                ScorePlayPauseStop {
                    id: scorePlayPauseStop
                    signal playPauseStopMessageReceived(var n)
                    signal scorePlayPauseStopMessageReceived(var n)
                    signal connectedToScore()
                    signal disconnectedFromScore()

                    state: "hidden" // horizontal arrangement: play | stop
                    width: 2 * window.btn; height: window.btn
                }
            }

            // Main speed + hide button
            Row {
                spacing: 4

                ScoreSpeed {
                    id: scoreSpeed
                    signal intervalMessageReceived(var n)
                    signal intervalsMessageReceived(var n)

                    width: window.speedWidth; height: window.btn
                }

                ScoreHideButton {
                    id: scoreHideButton
                    width: window.btn; height: window.btn
                }
            }
        }

        // ===== TRIGGER + SPEED PANELS (collapsible) =====
        Flow {
            id: panels
            Layout.fillWidth: true
            spacing: 8
            // Only take space when shown and there is something to show.
            visible: window.panelsVisible && (scoreTriggers.count > 0 || scoreSpeeds.count > 0)

            ScoreTriggers {
                id: scoreTriggers
                signal triggerMessageReceived(var n)
                signal clearTriggerList()

                visible: count > 0
                width: (window.compact || window.visiblePanelCount < 2)
                       ? panels.width : (panels.width - panels.spacing) / 2
                height: window.panelHeight
            }

            ScoreSpeeds {
                id: scoreSpeeds
                signal intervalMessageReceived(var n)
                signal intervalsMessageReceived(var n)
                signal clearSpeedList()

                visible: count > 0
                width: (window.compact || window.visiblePanelCount < 2)
                       ? panels.width : (panels.width - panels.spacing) / 2
                height: window.panelHeight
            }
        }

        // ===== CONTROL SURFACES (fill remaining space) =====
        Item {
            id: csArea
            Layout.fillWidth: true
            Layout.fillHeight: true

            ScoreControlSurfaceList {
                id: scoreControlSurfaceList
                signal controlSurfacesMessageReceived(var n)
                signal clearControlSurfaceList()
            }

            // Empty / disconnected guidance
            Column {
                anchors.centerIn: parent
                width: Math.min(csArea.width - 40, 360)
                spacing: 10
                visible: scoreControlSurfaceList.surfaceCount === 0

                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    text: window.connected ? qsTr("Waiting for control surfaces…")
                                           : qsTr("Not connected to score")
                    color: Skin.lightGray
                    font.pointSize: Skin.fontTitle
                }
                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    visible: !window.connected
                    text: qsTr("Use the connection button at the top-left to set the IP address and connect.")
                    color: Skin.gray3
                    font.pointSize: Skin.fontBody
                }
            }
        }

        // ===== TIMELINE (bottom) =====
        ScoreTimeline {
            id: scoreTimeline
            signal intervalsMessageReceived(var n)

            Layout.fillWidth: true
        }
    }
}

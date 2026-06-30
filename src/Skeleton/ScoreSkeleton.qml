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
    // Transport button size (touch-friendly, capped so it isn't huge on big screens).
    readonly property int btn: Math.max(Skin.minTouch, Math.min(72, Math.round(width / 18)))
    readonly property int panelHeight: Math.max(Skin.minTouch * 2, Math.round(height * 0.16))
    readonly property int speedWidth: compact ? Math.max(Skin.minTouch, width - btn - 28)
                                              : Math.round(width / 3)

    // Called when the remote is disconnected from score
    function disconnect() {
        scoreTriggers.clearTriggerList()
        scoreSpeeds.clearSpeedList()
        scoreControlSurfaceList.clearControlSurfaceList()
        scoreTimeline.stopTimeline()
    }

    anchors {
        fill: parent
        // Reserve space at the bottom on mobile so the timeline isn't hidden
        // behind the browser / system chrome.
        bottomMargin: is_mobile ? 50 : 0
    }

    // A field to save the IP address
    Settings {
        id: settings
        property string ip_address: "127.0.0.1"
    }

    // The websocket
    ScoreWebSocket {
        id: socket
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 5
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
            visible: window.panelsVisible

            ScoreTriggers {
                id: scoreTriggers
                signal triggerMessageReceived(var n)
                signal clearTriggerList()

                width: window.compact ? panels.width : (panels.width - panels.spacing) / 2
                height: window.panelHeight
            }

            ScoreSpeeds {
                id: scoreSpeeds
                signal intervalMessageReceived(var n)
                signal intervalsMessageReceived(var n)
                signal clearSpeedList()

                width: window.compact ? panels.width : (panels.width - panels.spacing) / 2
                height: window.panelHeight
            }
        }

        // ===== CONTROL SURFACES (fill remaining space) =====
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ScoreControlSurfaceList {
                id: scoreControlSurfaceList
                signal controlSurfacesMessageReceived(var n)
                signal clearControlSurfaceList()
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

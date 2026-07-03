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
    // Each section has an always-visible top-bar toggle (Triggers / Speeds /
    // Controls) that shows or hides it independently.
    property bool triggersEnabled: true
    property bool speedsEnabled: true
    property bool controlsEnabled: true
    // The trigger / speed panels additionally need score to have sent content.
    readonly property bool trigShown: triggersEnabled && scoreTriggers.count > 0
    readonly property bool speedShown: speedsEnabled && scoreSpeeds.count > 0
    readonly property bool dualPanels: trigShown && speedShown
    // Whether the websocket is connected to score.
    readonly property bool connected: socket.status === WebSocket.Open
    // Transport button size (touch-friendly, capped so it isn't huge on big screens).
    readonly property int btn: Math.max(Skin.minTouch, Math.min(72, Math.round(width / 18)))
    // Floor height for the trigger / speed panels; they grow above this so as
    // many cues as possible are visible at once (see the panels Item below).
    readonly property int panelHeight: Math.max(Skin.minTouch * 2, Math.round(height * 0.18))
    readonly property int speedWidth: compact ? Math.max(Skin.minTouch, width - btn - 28)
                                              : Math.round(width / 3)

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
        // Default to the address score injects via SCORE_IP_ADDRESS (so the
        // remote auto-connects when served/launched by score); else localhost.
        property string ip_address: (score_ip_address && score_ip_address.length > 0)
                                    ? score_ip_address : "127.0.0.1"
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

        // ===== TOP BAR =====
        // Line 1: transport (left) + the view toggles (right, flush). In wide
        // (landscape) mode the main speed sits inline in the middle; in compact
        // (portrait) mode it drops to its own full-width line below so the
        // toggles stay on the transport line.
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            // Transport: connect / play-pause / stop
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

            // Inline main-speed slot (landscape only). The ScoreSpeed instance is
            // reparented in here (see below); in portrait it moves to its own line.
            Item {
                id: wideSpeedSlot
                visible: !window.compact
                Layout.preferredWidth: window.speedWidth
                Layout.preferredHeight: window.btn
            }

            // Spacer: pushes the toggles to the right edge in both layouts.
            Item { Layout.fillWidth: true }

            // View toggles (right): each shows/hides its section. Always visible.
            Row {
                spacing: 4

                ScoreViewToggle {
                    label: qsTr("Triggers")
                    height: window.btn
                    Component.onCompleted: checked = window.triggersEnabled
                    onToggled: window.triggersEnabled = checked
                }

                ScoreViewToggle {
                    label: qsTr("Speeds")
                    height: window.btn
                    Component.onCompleted: checked = window.speedsEnabled
                    onToggled: window.speedsEnabled = checked
                }

                ScoreViewToggle {
                    label: qsTr("Controls")
                    height: window.btn
                    Component.onCompleted: checked = window.controlsEnabled
                    onToggled: window.controlsEnabled = checked
                }
            }
        }

        // Line 2 (portrait only): the main speed on its own full-width line.
        Item {
            id: compactSpeedSlot
            visible: window.compact
            Layout.fillWidth: true
            Layout.preferredHeight: window.btn
        }

        // ===== TRIGGER + SPEED PANELS =====
        // Grows to share the vertical space with the control surfaces (capped so
        // the surfaces keep a fair share) so as many cues as possible are shown
        // at once. Laid out by hand (not a Flow) to keep the child heights from
        // feeding back into the container height.
        Item {
            id: panels
            property int spacing: 8

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: window.panelHeight
            // Capped so the control surfaces keep a fair share — but when the
            // Controls view is hidden, let the panels use the freed space.
            Layout.maximumHeight: window.controlsEnabled ? Math.round(window.height * 0.55)
                                                         : window.height
            visible: window.trigShown || window.speedShown

            ScoreTriggers {
                id: scoreTriggers
                signal triggerMessageReceived(var n)
                signal clearTriggerList()

                visible: window.trigShown
                x: 0; y: 0
                width: (window.compact || !window.dualPanels)
                       ? panels.width : (panels.width - panels.spacing) / 2
                height: (window.compact && window.dualPanels)
                        ? (panels.height - panels.spacing) / 2 : panels.height
            }

            ScoreSpeeds {
                id: scoreSpeeds
                signal intervalMessageReceived(var n)
                signal intervalsMessageReceived(var n)
                signal clearSpeedList()

                visible: window.speedShown
                x: (window.dualPanels && !window.compact)
                   ? (panels.width + panels.spacing) / 2 : 0
                y: (window.dualPanels && window.compact)
                   ? (panels.height + panels.spacing) / 2 : 0
                width: (window.compact || !window.dualPanels)
                       ? panels.width : (panels.width - panels.spacing) / 2
                height: (window.compact && window.dualPanels)
                        ? (panels.height - panels.spacing) / 2 : panels.height
            }
        }

        // ===== CONTROL SURFACES (fill remaining space) =====
        Item {
            id: csArea
            visible: window.controlsEnabled
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
                    font.family: Skin.font
                }
                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    visible: !window.connected
                    text: qsTr("Use the connection button at the top-left to set the IP address and connect.")
                    color: Skin.gray3
                    font.pointSize: Skin.fontBody
                    font.family: Skin.font
                }
            }
        }

        // Filler that absorbs the slack (keeping the top bar at the top and the
        // timeline at the bottom) when every section above is hidden and nothing
        // else is filling the vertical space.
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: !panels.visible && !csArea.visible
        }

        // ===== TIMELINE (bottom) =====
        ScoreTimeline {
            id: scoreTimeline
            signal intervalsMessageReceived(var n)

            Layout.fillWidth: true
        }
    }

    // The single main-speed slider, reparented into whichever slot is active:
    // inline on the top bar (landscape) or its own line below (portrait). One
    // instance so its score message handlers stay wired to `scoreSpeed` by id.
    ScoreSpeed {
        id: scoreSpeed
        signal intervalMessageReceived(var n)
        signal intervalsMessageReceived(var n)

        parent: window.compact ? compactSpeedSlot : wideSpeedSlot
        anchors.fill: parent
    }
}

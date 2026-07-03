/*
  * SpinBox control (score IntSpinBox / FloatSpinBox / TimeChooser) :
  * - Qt Quick Controls SpinBox styled with the app Skin (flat dark, brown
  *   borders, orange/brown accents) to match the other controls
  * - standard decimal pattern for floats; works with or without a domain
  */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Variable.Global 1.0

Item {
    id: root

    property string controlCustom
    property int controlId
    property string controlUuid
    property string controlSurfacePath

    property bool isInt: false
    property real from: 0
    property real to: 0
    property real value: 0
    readonly property bool bounded: to > from

    implicitWidth: (controlSurfaceListColumn.width <= 500
                    ? controlSurfaceListColumn.width
                    : controlSurfaceListColumn.width >= 1200
                      ? 400
                      : controlSurfaceListColumn.width / 3)
    implicitHeight: 44

    RowLayout {
        anchors.fill: parent
        spacing: 6

        Text {
            Layout.fillWidth: true
            Layout.leftMargin: 4
            text: root.controlCustom
            color: Skin.white
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            font.pointSize: root.width <= 200 ? 10 : 12
            font.family: Skin.font
        }

        SpinBox {
            id: spin

            Layout.preferredWidth: root.width * 0.5
            Layout.fillHeight: true
            editable: true

            readonly property int decimals: root.isInt ? 0 : 3
            readonly property int factor: Math.pow(10, decimals)
            // SpinBox from/to/value are 32-bit ints; clamp the scaled range.
            from: root.bounded ? Math.max(-2000000000, Math.round(root.from * factor)) : -2000000000
            to: root.bounded ? Math.min(2000000000, Math.round(root.to * factor)) : 2000000000
            stepSize: root.isInt ? 1 : Math.max(1, Math.round(factor / 100))

            validator: DoubleValidator {
                bottom: Math.min(spin.from, spin.to)
                top: Math.max(spin.from, spin.to)
                decimals: spin.decimals
                notation: DoubleValidator.StandardNotation
            }

            textFromValue: function(value, locale) {
                return Number(value / spin.factor).toLocaleString(locale, 'f', spin.decimals)
            }
            valueFromText: function(text, locale) {
                return Math.round(Number.fromLocaleString(locale, text) * spin.factor)
            }

            Component.onCompleted: value = Math.round(root.value * factor)

            Connections {
                target: root
                function onValueChanged() {
                    if (!spin.contentItem.activeFocus)
                        spin.value = Math.round(root.value * spin.factor)
                }
            }

            onValueModified: {
                var v = spin.value / spin.factor
                var payload = root.isInt ? `{"Int": ${Math.round(v)}}`
                                         : `{"Float": ${v.toFixed(spin.decimals)}}`
                socket.sendTextMessage(
                    `{ "Message": "ControlSurface","Path": ${root.controlSurfacePath}, "id": ${root.controlId}, "Value": ${payload} }`)
            }

            // --- App-Skin styling (darkGray field like the other text inputs) ---
            background: Rectangle {
                color: Skin.gray2
                radius: 4
                border.color: Skin.gray3
            }

            contentItem: TextInput {
                text: spin.displayText
                color: Skin.white
                selectionColor: Skin.orange
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                readOnly: !spin.editable
                validator: spin.validator
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                selectByMouse: true
                font.pointSize: root.width <= 200 ? 10 : 12
                font.family: Skin.monoFont
            }

            up.indicator: Rectangle {
                x: spin.width - width
                height: spin.height
                implicitWidth: spin.height
                color: spin.up.pressed ? Skin.orange : Skin.gray1
                border.color: Skin.gray3
                Text {
                    text: "+"
                    color: Skin.white
                    anchors.centerIn: parent
                    font.pointSize: 14
                    font.family: Skin.font
                }
            }

            down.indicator: Rectangle {
                x: 0
                height: spin.height
                implicitWidth: spin.height
                color: spin.down.pressed ? Skin.orange : Skin.gray1
                border.color: Skin.gray3
                Text {
                    text: "−"
                    color: Skin.white
                    anchors.centerIn: parent
                    font.pointSize: 14
                    font.family: Skin.font
                }
            }
        }
    }
}

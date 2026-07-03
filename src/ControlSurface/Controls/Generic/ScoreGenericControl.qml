/*
  * Generic control (score's base Process::ControlInlet — no specialized widget):
  * - an editable line-edit that displays the inlet's current value as text,
  *   whatever its ossia type (float / int / bool / string / vecN / list)
  * - committing the text sends a value back, re-typed to match the last value
  *   seen (or inferred from the text when the inlet started empty)
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
    // JSON string of the ossia value object, e.g. '{"Vec3f":[1,0,0]}' or '{}'.
    property string controlValue
    property color controlColor: Skin.blue2

    readonly property var _v: (controlValue && controlValue.length) ? JSON.parse(controlValue) : ({})

    // ossia value object -> display text
    function displayText(v) {
        if (!v) return ""
        if (v.Float !== undefined) return "" + v.Float
        if (v.Int !== undefined) return "" + v.Int
        if (v.Bool !== undefined) return v.Bool ? "true" : "false"
        if (v.String !== undefined) return v.String
        if (v.Vec2f !== undefined) return v.Vec2f.join(", ")
        if (v.Vec3f !== undefined) return v.Vec3f.join(", ")
        if (v.Vec4f !== undefined) return v.Vec4f.join(", ")
        if (v.List !== undefined) return JSON.stringify(v.List)
        return "" // Impulse / empty {}
    }

    // ossia value object -> type tag (for round-tripping on send)
    function valueType(v) {
        if (!v) return ""
        if (v.Float !== undefined) return "Float"
        if (v.Int !== undefined) return "Int"
        if (v.Bool !== undefined) return "Bool"
        if (v.String !== undefined) return "String"
        if (v.Vec2f !== undefined) return "Vec2f"
        if (v.Vec3f !== undefined) return "Vec3f"
        if (v.Vec4f !== undefined) return "Vec4f"
        return ""
    }

    // text + type tag -> ossia value JSON. Falls back to inferring the type
    // from the text when the inlet had no value yet (type === "").
    function toValueJson(text, type) {
        var t = ("" + text).trim()
        function nums(s) {
            return s.split(/[,\s]+/).filter(function (x) { return x.length }).map(Number)
        }
        switch (type) {
        case "Float": return '{"Float": ' + (parseFloat(t) || 0) + '}'
        case "Int":   return '{"Int": ' + (parseInt(t) || 0) + '}'
        case "Bool":  return '{"Bool": ' + (/^(true|1)$/i.test(t)) + '}'
        case "String": return '{"String": ' + JSON.stringify(text) + '}'
        case "Vec2f": case "Vec3f": case "Vec4f":
            return '{"' + type + '": [' + nums(t).join(", ") + ']}'
        default:
            if (t.length === 0) return '{"String": ""}'
            if (/^-?[0-9]+$/.test(t)) return '{"Int": ' + parseInt(t) + '}'
            if (!isNaN(Number(t))) return '{"Float": ' + parseFloat(t) + '}'
            if (/^(true|false)$/i.test(t)) return '{"Bool": ' + (/true/i.test(t)) + '}'
            var ns = nums(t)
            if (ns.length >= 2 && ns.length <= 4 && ns.every(function (n) { return !isNaN(n) }))
                return '{"Vec' + ns.length + 'f": [' + ns.join(", ") + ']}'
            return '{"String": ' + JSON.stringify(text) + '}'
        }
    }

    implicitWidth: (controlSurfaceListColumn.width <= 500
                    ? controlSurfaceListColumn.width
                    : controlSurfaceListColumn.width >= 1200
                      ? 400
                      : controlSurfaceListColumn.width / 3)
    implicitHeight: Math.max(Skin.minTouch, window.height <= 500 ? 30 : 5 + window.height / 25)

    RowLayout {
        anchors.fill: parent
        spacing: 4

        Text {
            Layout.leftMargin: 4
            text: root.controlCustom
            color: Skin.white
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            font.pointSize: root.width <= 200 ? Skin.fontCaption : Skin.fontBody
            font.family: Skin.font
        }

        TextField {
            id: field
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: root.displayText(root._v)
            color: Skin.white
            font.family: Skin.monoFont
            verticalAlignment: TextInput.AlignVCenter
            topPadding: 0; bottomPadding: 0
            selectByMouse: true
            background: Rectangle {
                color: Skin.darkGray; border.color: root.controlColor
                // Non-floating placeholder (see ScoreLineEdit): empty-only, behind
                // the text, so Material's floating label can't overlap the value.
                Text {
                    anchors.fill: parent
                    leftPadding: field.leftPadding; rightPadding: field.rightPadding
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    text: qsTr("value")
                    color: Skin.gray3
                    font: field.font
                    visible: field.text.length === 0
                }
            }

            onEditingFinished: socket.sendTextMessage(
                `{ "Message": "ControlSurface","Path": ${root.controlSurfacePath}, "id": ${root.controlId}, "Value": ${root.toValueJson(field.text, root.valueType(root._v))} }`)

            // Sync when the value changes from score (unless being edited)
            Connections {
                target: root
                function onControlValueChanged() {
                    if (!field.activeFocus)
                        field.text = root.displayText(root._v)
                }
            }
        }
    }
}

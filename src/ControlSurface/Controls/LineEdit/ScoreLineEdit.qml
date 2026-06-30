/*
  * Text field control (score LineEdit / ProgramEdit / file & folder choosers) :
  * - editable string field
  * - committing the text sends the new string value to score
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
    property string controlValue
    property color controlColor: Skin.brown

    implicitWidth: (controlSurfaceListColumn.width <= 500
                    ? controlSurfaceListColumn.width
                    : controlSurfaceListColumn.width >= 1200
                      ? 400
                      : controlSurfaceListColumn.width / 3)
    // Material TextField needs room; keep a sane minimum so the text isn't clipped
    implicitHeight: Math.max(44, window.height <= 500 ? 30 : 5 + window.height / 25)

    RowLayout {
        anchors.fill: parent
        spacing: 4

        Text {
            Layout.leftMargin: 4
            text: root.controlCustom
            color: Skin.white
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            font.pointSize: root.width <= 200 ? 10 : 12
        }

        TextField {
            id: field
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: root.controlValue
            color: Skin.white
            verticalAlignment: TextInput.AlignVCenter
            topPadding: 0; bottomPadding: 0
            selectByMouse: true
            placeholderText: qsTr("set value…")
            placeholderTextColor: Skin.gray3
            background: Rectangle {
                color: Skin.gray2; radius: 4
                border.color: field.activeFocus ? Skin.orange : Skin.gray3
            }

            onEditingFinished: socket.sendTextMessage(
                `{ "Message": "ControlSurface","Path": ${root.controlSurfacePath}, "id": ${root.controlId}, "Value": {"String": ${JSON.stringify(field.text)} } }`)

            // Sync when the value changes from score (unless being edited)
            Connections {
                target: root
                function onControlValueChanged() {
                    if (!field.activeFocus)
                        field.text = root.controlValue
                }
            }
        }
    }
}

/*
  * View toggle — a small checkable button that shows/hides one of the top
  * panels (Triggers, Speeds). Replaces the single fold-everything arrow so each
  * panel can be enabled independently. Orange when the view is enabled.
  */

import QtQuick
import QtQuick.Controls

import Variable.Global 1.0

Button {
    id: root

    property string label: ""

    checkable: true

    // Explicit paddings/insets: the Material style overrides the `padding`
    // shorthand with its own (larger) horizontal padding, which would clip the
    // label — set them directly and size the button to include them.
    topPadding: 0; bottomPadding: 0
    leftPadding: 10; rightPadding: 10
    topInset: 0; bottomInset: 0; leftInset: 0; rightInset: 0

    // Width from the label's natural size (TextMetrics, so it doesn't collapse
    // under the contentItem's own elide) plus the horizontal padding.
    implicitWidth: Math.max(height, Math.ceil(labelMetrics.width) + leftPadding + rightPadding)

    TextMetrics {
        id: labelMetrics
        font: contentText.font
        text: root.label
    }

    contentItem: Text {
        id: contentText
        text: root.label
        color: root.checked ? Skin.dark : Skin.white
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: Skin.fontBody
        font.family: Skin.font
        elide: Text.ElideRight
    }

    background: Rectangle {
        radius: 6
        color: root.checked ? Skin.orange : (root.down ? Skin.gray3 : Skin.gray2)
        border { color: root.checked ? Skin.orange : Skin.gray3; width: 1 }
    }
}

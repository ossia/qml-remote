/*
  * XY-point list control (score MultiSliderXY / PathGeneratorXY) :
  * - live read-only 2D plot of a Tuple of Vec2f points
  * - PathGeneratorXY additionally connects the points as a path
  */

import QtQuick

import Variable.Global 1.0

Item {
    id: root

    property string controlCustom
    property int controlId
    property string controlUuid

    property real from: 0
    property real to: 1
    property string pointsJson: "[]"
    property var points: JSON.parse(pointsJson)
    onPointsJsonChanged: { points = JSON.parse(pointsJson); plot.requestPaint() }

    readonly property bool isPath: controlUuid === Uuid.pathGeneratorXYUUID

    implicitWidth: (controlSurfaceListColumn.width <= 500
                    ? controlSurfaceListColumn.width
                    : controlSurfaceListColumn.width >= 1200
                      ? 400
                      : controlSurfaceListColumn.width / 3)
    implicitHeight: label.implicitHeight + 4 + plot.height

    Text {
        id: label
        anchors { left: parent.left; top: parent.top; leftMargin: 4 }
        text: ' ' + root.controlCustom + ' (' + root.points.length + ' pts)'
        color: Skin.white
        font.pointSize: root.width <= 200 ? 10 : 12
    }

    Canvas {
        id: plot
        anchors { left: parent.left; right: parent.right; top: label.bottom; topMargin: 2 }
        height: width / 2

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.fillStyle = Skin.gray2
            ctx.fillRect(0, 0, width, height)
            ctx.strokeStyle = Skin.brown
            ctx.lineWidth = 1
            ctx.strokeRect(0, 0, width, height)

            var span = (root.to > root.from) ? (root.to - root.from) : 1
            function px(p) { return { x: (p[0] - root.from) / span * width,
                                      y: height - (p[1] - root.from) / span * height } }

            if (root.isPath && root.points.length > 1) {
                ctx.strokeStyle = Skin.brown
                ctx.lineWidth = 2
                ctx.beginPath()
                var p0 = px(root.points[0])
                ctx.moveTo(p0.x, p0.y)
                for (var k = 1; k < root.points.length; ++k) {
                    var pk = px(root.points[k])
                    ctx.lineTo(pk.x, pk.y)
                }
                ctx.stroke()
            }

            ctx.fillStyle = Skin.orange
            for (var i = 0; i < root.points.length; ++i) {
                var pt = px(root.points[i])
                ctx.beginPath()
                ctx.arc(pt.x, pt.y, 4, 0, 2 * Math.PI)
                ctx.fill()
            }
        }
    }
}

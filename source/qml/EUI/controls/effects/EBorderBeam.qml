import EUI 1.0
import QtQuick 2.15

Item {
    id: control
    default property alias content: body.data

    property int count: 1
    property real outset: 0
    property real radius: 8
    property real size: 100
    property real duration: 6
    property real lineWidth: 2
    property bool running: true
    property bool reducedMotion: false
    property var color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)

    readonly property var stops: normalizeStops()
    readonly property int beamCount: Math.max(1, Math.min(64, count))
    readonly property real beamSize: isFinite(size) ? Math.max(0, size) : 100
    readonly property real expansion: isFinite(outset) ? Math.max(0, outset) : 0
    readonly property real strokeWidth: isFinite(lineWidth) ? Math.max(0, lineWidth) : 2

    function colorAt(position) {
        if (position <= stops[0].offset)
            return stops[0].color

        for (let index = 1; index < stops.length; ++index) {
            const right = stops[index]
            const left = stops[index - 1]
            if (position > right.offset)
                continue

            const ratio = (position - left.offset) / Math.max(0.0001, right.offset - left.offset)
            return Qt.rgba(left.color.r
                + (right.color.r - left.color.r) * ratio, left.color.g
                + (right.color.g - left.color.g) * ratio, left.color.b
                + (right.color.b - left.color.b) * ratio, left.color.a
                + (right.color.a - left.color.a) * ratio)
        }
        return stops[stops.length - 1].color
    }

    function normalizeStops() {
        const values = EDataUtils.isArray(color) ? color : [{
            "color": color,
            "percent": 100
        }]
        const result = values.filter(function(value) {
            return value && isFinite(value.percent) && EValueUtils.parseColor(String(value.color)).length > 0
        }).map(function(value) {
            return {
                "offset": Math.max(0, Math.min(100, Number(value.percent))) / 100,
                "color": Qt.darker(EValueUtils.parseColor(String(value.color)), 1)
            }
        }).sort(function(left, right) {
            return left.offset - right.offset
        })
        return result.length ? result : [{
            "offset": 1,
            "color": EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
        }]
    }

    implicitWidth: body.childrenRect.width
    implicitHeight: body.childrenRect.height

    onStopsChanged: canvas.requestPaint()
    onRadiusChanged: canvas.requestPaint()
    onBeamSizeChanged: canvas.requestPaint()
    onBeamCountChanged: canvas.requestPaint()
    onStrokeWidthChanged: canvas.requestPaint()

    Item {
        id: body

        anchors.fill: parent
    }
    Canvas {
        id: canvas

        property real phase: 0

        readonly property real frameWidth: Math.max(0, width - control.strokeWidth)
        readonly property real frameHeight: Math.max(0, height - control.strokeWidth)
        readonly property real perimeter: 2 * (frameWidth + frameHeight - 4 * corner) + 2 * Math.PI * corner
        readonly property real corner: Math.max(0, Math.min(isFinite(control.radius) ? control.radius
            : 0, frameWidth / 2, frameHeight / 2))

        function pointAt(distance) {
            let offset = ((distance % perimeter) + perimeter) % perimeter
            const horizontal = frameWidth - 2 * corner
            const vertical = frameHeight - 2 * corner
            const arc = Math.PI * corner / 2
            const lengths = [horizontal, arc, vertical, arc, horizontal, arc, vertical, arc]
            let segment = 0
            while (segment < 7 && offset > lengths[segment]) {
                offset -= lengths[segment]
                ++segment
            }
            let x = 0
            let y = 0
            if (segment === 0) {
                x = corner + offset
                y = 0
            } else if (segment === 2) {
                x = frameWidth
                y = corner + offset
            } else if (segment === 4) {
                x = frameWidth - corner - offset
                y = frameHeight
            } else if (segment === 6) {
                x = 0
                y = frameHeight - corner - offset
            } else {
                const angle = (segment - 3) * Math.PI / 4 + (corner > 0 ? offset / corner : 0)
                const centerX = segment < 4 ? frameWidth - corner : corner
                const centerY = segment === 1 || segment === 7 ? corner : frameHeight - corner
                x = centerX + Math.cos(angle) * corner
                y = centerY + Math.sin(angle) * corner
            }
            return Qt.point(x + control.strokeWidth / 2, y + control.strokeWidth / 2)
        }

        z: 1
        x: -control.expansion
        y: -control.expansion
        objectName: "borderBeamCanvas"
        width: control.width + 2 * control.expansion
        height: control.height + 2 * control.expansion
        visible: control.enabled && !control.reducedMotion

        onPhaseChanged: requestPaint()
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        onVisibleChanged: requestPaint()
        onPaint: {
            const context = getContext("2d")
            context.clearRect(0, 0, width, height)
            if (!visible || perimeter <= 0 || control.strokeWidth <= 0 || control.beamSize <= 0)
                return

            context.lineCap = "round"
            context.lineWidth = control.strokeWidth
            const length = Math.min(perimeter, control.beamSize)
            const segments = Math.max(1, Math.min(256, Math.ceil(length / 2)))
            for (let beam = 0; beam < control.beamCount; ++beam) {
                const head = (phase + beam / control.beamCount) * perimeter
                for (let index = 0; index < segments; ++index) {
                    const ratio = (index + 1) / segments
                    const start = pointAt(head - length + length * index / segments)
                    const end = pointAt(head - length + length * ratio)
                    const tint = control.colorAt(ratio)
                    context.strokeStyle = Qt.rgba(tint.r, tint.g, tint.b, tint.a * ratio * ratio)
                    context.beginPath()
                    context.moveTo(start.x, start.y)
                    context.lineTo(end.x, end.y)
                    context.stroke()
                }
            }
        }

        NumberAnimation on phase {
            to: 1
            from: 0
            loops: Animation.Infinite
            duration: Math.max(1, isFinite(control.duration) ? control.duration * 1000 : 6000)
            running: control.running
                && control.enabled
                && control.visible
                && canvas.visible
                && control.width > 0
                && control.height > 0
        }
    }
}

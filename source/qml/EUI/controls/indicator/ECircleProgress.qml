import EUI 1.0
import QtQuick 2.15
import QtQml 2.15

Item {
    id: control
    default property alias content: customText.data

    property var value: 0
    property var percentage
    property var format: null
    property string status: ""
    property int duration: 3000
    property int startAngle: 90
    property int strokeWidth: 6
    property bool clockwise: true
    property bool showText: false
    property bool dashboard: false
    property bool indeterminate: false
    property bool showBackground: true
    property string strokeLinecap: "round"
    property int styleType: EStyle.Primary
    property var color: EPaletteManager.BasePalette.transparent

    readonly property color effectiveColor: resolveColor()
    readonly property string displayText: typeof format === "function" ? String(format(normalizedValue * 100))
        : Math.round(normalizedValue * 100) + "%"
    readonly property int effectiveStyle: status === "success" ? EStyle.Success
        : status === "exception" ? EStyle.Danger : status === "warning" ? EStyle.Warning : styleType
    readonly property real normalizedValue: {
        const number = percentage === undefined ? Number(value) : Number(percentage) / 100
        return isFinite(number) ? Math.max(0, Math.min(1, number)) : 0
    }

    function resolveColor() {
        let selected = color
        try {
            if (typeof color === "function")
                selected = color(normalizedValue * 100)
            else if (EDataUtils.isArray(color)) {
                const colors = color.filter(function(item) {
                    return item && isFinite(item.percentage)
                })
                    .slice().sort(function(left, right) {
                        return left.percentage - right.percentage
                    })
                if (colors.length > 0) {
                    selected = colors[colors.length - 1].color
                    for (let index = 0; index < colors.length; ++index) {
                        if (normalizedValue * 100 <= colors[index].percentage) {
                            selected = colors[index].color
                            break
                        }
                    }
                } else {
                    selected = EPaletteManager.BasePalette.transparent
                }
            }
        } catch (error) {
            selected = EPaletteManager.BasePalette.transparent
        }
        return EPaletteManager.StatePalette.computeBackgroundColor(
            EPaletteManager.createStateObject(this, EStyle.Color)
                .setDark(ETheme.dark)
                .setEnabled(enabled)
                .setColor(selected || EPaletteManager.BasePalette.transparent)
                .setComponentStyle(effectiveStyle)
        )
    }

    implicitWidth: 126
    implicitHeight: 126

    onClockwiseChanged: canvas.requestPaint()
    onDashboardChanged: canvas.requestPaint()
    onStartAngleChanged: canvas.requestPaint()
    onStrokeWidthChanged: canvas.requestPaint()
    onStrokeLinecapChanged: canvas.requestPaint()
    onEffectiveColorChanged: canvas.requestPaint()
    onShowBackgroundChanged: canvas.requestPaint()
    onNormalizedValueChanged: canvas.requestPaint()

    QtObject {
        id: inside

        property real phase: 0

        readonly property color backgroundColor: EPaletteManager.StatePalette.computeBackgroundColor(
            EPaletteManager.createStateObject(this, EStyle.BackgroundColor)
                .setDark(ETheme.dark)
                .setPlain(true)
                .setColor(EPaletteManager.ThemePalette.fetchInverseThemeColor(ETheme.dark))
        )

        onPhaseChanged: canvas.requestPaint()
        onBackgroundColorChanged: canvas.requestPaint()
    }
    Canvas {
        id: canvas

        antialiasing: true
        anchors.fill: parent
        objectName: "circleProgressCanvas"

        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        onPaint: {
            const ctx = getContext("2d")
            const strokeWidth = Math.max(0, Math.min(control.strokeWidth, Math.min(width, height)))
            const r = Math.max(0, Math.min(width, height) / 2 - strokeWidth / 2)
            const cx = width / 2
            const cy = height / 2
            ctx.reset()
            ctx.clearRect(0, 0, width, height)
            ctx.lineCap = ["round", "butt", "square"].indexOf(control.strokeLinecap) >= 0
                ? control.strokeLinecap
                : "round"
            ctx.lineWidth = strokeWidth
            const totalRad = control.dashboard ? Math.PI * 1.5 : 2 * Math.PI
            let startRad = control.startAngle * Math.PI / 180
            if (control.dashboard)
                startRad = control.clockwise ? 3 * Math.PI / 4 : Math.PI / 4
            const backgroundStart = startRad
            if (control.indeterminate)
                startRad += inside.phase * 2 * Math.PI
            const v = control.indeterminate ? 0.25 : control.normalizedValue
            const bgEndRad = control.clockwise ? backgroundStart + totalRad : backgroundStart - totalRad
            const endRad = control.clockwise ? startRad + totalRad * v : startRad - totalRad * v
            if (control.showBackground) {
                ctx.beginPath()
                ctx.strokeStyle = inside.backgroundColor
                ctx.arc(cx, cy, r, backgroundStart, bgEndRad, !control.clockwise)
                ctx.stroke()
            }
            if (v > 0 && strokeWidth > 0 && r > 0) {
                ctx.beginPath()
                ctx.strokeStyle = control.effectiveColor
                ctx.arc(cx, cy, r, startRad, endRad, !control.clockwise)
                ctx.stroke()
            }
        }
    }
    EText {
        font.pixelSize: 18
        anchors.centerIn: parent
        text: control.displayText
        color: EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
        visible: control.showText && customText.children.length === 0
    }
    Item {
        id: customText

        anchors.centerIn: parent
        width: childrenRect.width
        height: childrenRect.height
    }
    NumberAnimation {
        to: 1
        from: 0
        target: inside
        property: "phase"
        loops: Animation.Infinite
        duration: Math.max(100, control.duration)
        running: control.indeterminate && control.visible && control.enabled
    }
    Behavior on value {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutQuad
        }
    }
}

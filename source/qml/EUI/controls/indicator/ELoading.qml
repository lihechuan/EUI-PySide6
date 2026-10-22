import EUI 1.0
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Item {
    id: control

    property url svg: ""
    property bool lock: true
    property string text: ""
    property Item target: null
    property int duration: 1000
    property bool loading: true
    property int strokeWidth: 6
    property int sweepAngle: 180
    property bool clockwise: true
    property bool material: false
    property var beforeClose: null
    property bool fullscreen: false
    property bool showBackground: true
    property int styleType: EStyle.Primary
    property Component textComponent: null
    property Component spinnerComponent: null
    property color color: EPaletteManager.BasePalette.transparent
    property color backgroundColor: {
        const themeColor = EPaletteManager.ThemePalette.fetchThemeColor(ETheme.dark)
        return Qt.rgba(themeColor.r, themeColor.g, themeColor.b, 0.8)
    }

    readonly property int angle: animationState.angle
    readonly property real animPhase: animationState.animPhase
    readonly property real lastPhase: animationState.lastPhase
    readonly property bool overlayMode: target !== null || fullscreen
    readonly property real cycleOffsetDeg: animationState.cycleOffsetDeg

    signal closed()

    function close() {
        if (typeof beforeClose === "function" && beforeClose() === false)
            return false
        loading = false
        closed()
        return true
    }

    visible: loading

    onAngleChanged: canvas.requestPaint()
    onColorChanged: canvas.requestPaint()
    onClockwiseChanged: canvas.requestPaint()
    onSweepAngleChanged: canvas.requestPaint()
    onStrokeWidthChanged: canvas.requestPaint()
    onShowBackgroundChanged: canvas.requestPaint()
    onAnimPhaseChanged: {
        if (animPhase < lastPhase) {
            const delta = (canvas.maxSweep - canvas.minSweep) * (control.clockwise ? 1 : -1)
            animationState.cycleOffsetDeg = (animationState.cycleOffsetDeg + delta) % 360
        }
        animationState.lastPhase = animPhase
        canvas.requestPaint()
    }

    QtObject {
        id: animationState

        property int angle: 0
        property real animPhase: 0
        property real lastPhase: 0
        property real cycleOffsetDeg: 0
    }
    QtObject {
        id: inside

        property color progressColor: EPaletteManager.StatePalette.computeBackgroundColor(
            EPaletteManager.createStateObject(this, EStyle.Color)
                .setDark(ETheme.dark)
                .setEnabled(control.enabled)
                .setColor(control.color)
                .setComponentStyle(control.styleType)
        )
        property color backgroundColor: EPaletteManager.StatePalette.computeBackgroundColor(
            EPaletteManager.createStateObject(this, EStyle.BackgroundColor)
                .setDark(ETheme.dark)
                .setPlain(true)
                .setColor(EPaletteManager.ThemePalette.fetchInverseThemeColor(ETheme.dark))
        )

        onProgressColorChanged: canvas.requestPaint()
        onBackgroundColorChanged: canvas.requestPaint()
    }
    Item {
        id: overlay

        z: 1000
        width: parent ? parent.width : 0
        height: parent ? parent.height : 0
        visible: control.overlayMode && control.visible
        parent: control.fullscreen ? control.Overlay.overlay : control.target || control

        Rectangle {
            anchors.fill: parent
            color: control.backgroundColor
        }
        MouseArea {
            anchors.fill: parent
            enabled: control.lock

            onWheel: function(wheel) {
                wheel.accepted = true
            }
        }
        Loader {
            width: parent.width
            y: parent.height / 2 + 28
            sourceComponent: control.textComponent
        }
        EText {
            text: control.text
            width: parent.width
            wrapMode: Text.WordWrap
            y: parent.height / 2 + 28
            visible: !control.textComponent
            horizontalAlignment: Text.AlignHCenter
            color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
        }
    }
    Image {
        x: spinnerLayer.x
        y: spinnerLayer.y
        source: control.svg
        rotation: control.angle
        width: spinnerLayer.width
        height: spinnerLayer.height
        fillMode: Image.PreserveAspectFit
        parent: control.overlayMode ? overlay : control
        visible: !control.spinnerComponent && source.toString().length > 0
    }
    Loader {
        x: spinnerLayer.x
        y: spinnerLayer.y
        width: spinnerLayer.width
        height: spinnerLayer.height
        sourceComponent: control.spinnerComponent
        parent: control.overlayMode ? overlay : control
    }
    Item {
        id: spinnerLayer

        rotation: control.angle
        transformOrigin: Item.Center
        parent: control.overlayMode ? overlay : control
        width: control.overlayMode ? 32 : control.width
        height: control.overlayMode ? 32 : control.height
        x: control.overlayMode ? (overlay.width - width) / 2 : 0
        visible: !control.spinnerComponent && control.svg.toString().length === 0
        y: control.overlayMode ? (overlay.height - height) / 2 - (control.text.length > 0 ? 12 : 0) : 0

        Canvas {
            id: canvas

            property int minSweep: 15
            property int maxSweep: 270

            antialiasing: true
            anchors.fill: parent

            onWidthChanged: requestPaint()
            onHeightChanged: requestPaint()
            onVisibleChanged: if (visible)
                requestPaint()
            onPaint: {
                const ctx = getContext("2d")

                ctx.reset()
                ctx.clearRect(0, 0, canvas.width, canvas.height)

                const strokeWidth = Math.max(0, control.strokeWidth)
                ctx.lineWidth = strokeWidth
                ctx.lineCap = "round"

                const cx = width / 2
                const cy = height / 2
                const r = Math.max(0, Math.min(spinnerLayer.width, spinnerLayer.height) / 2 - strokeWidth / 2)
                const direction = control.clockwise ? 1 : -1

                if (control.showBackground) {
                    ctx.strokeStyle = inside.backgroundColor
                    ctx.beginPath()
                    ctx.arc(cx, cy, r, 0, Math.PI * 2, false)
                    ctx.stroke()
                }

                ctx.beginPath()
                ctx.strokeStyle = inside.progressColor

                let startRad = 0
                let sweepRad = 0
                let endRad = 0

                if (control.material) {
                    const phase = control.animPhase
                    let startDeg, sweepDeg

                    if (phase <= 0.5) {
                        const t = phase * 2
                        sweepDeg = canvas.minSweep + (canvas.maxSweep - canvas.minSweep) * t
                        startDeg = 0
                    } else {
                        const t = (phase - 0.5) * 2
                        sweepDeg = canvas.maxSweep - (canvas.maxSweep - canvas.minSweep) * t
                        const headAdvance = (canvas.maxSweep - canvas.minSweep) * t
                        startDeg = direction * headAdvance
                    }

                    startDeg = (control.cycleOffsetDeg + startDeg) % 360
                    startRad = (-Math.PI / 2) + (startDeg * Math.PI / 180)
                    sweepRad = direction * sweepDeg * Math.PI / 180
                } else {
                    startRad = -Math.PI / 2
                    sweepRad = direction * Math.min(
                        canvas.maxSweep,
                        Math.max(0, control.sweepAngle)
                    ) * Math.PI / 180
                }

                endRad = startRad + sweepRad
                ctx.arc(cx, cy, r, startRad, endRad, !control.clockwise)

                ctx.stroke()
            }
        }
    }
    NumberAnimation {
        property: "angle"
        target: animationState
        running: control.visible
        loops: Animation.Infinite
        easing.type: Easing.Linear
        from: animationState.angle
        duration: Math.max(1, control.duration)
        to: animationState.angle + (control.clockwise ? 360 : -360)
    }
    NumberAnimation {
        to: 1
        from: 0
        property: "animPhase"
        target: animationState
        loops: Animation.Infinite
        easing.type: Easing.OutQuad
        duration: Math.max(1, control.duration)
        running: control.material && control.visible
    }
}

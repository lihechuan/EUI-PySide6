import EUI 1.0
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control

    property real from: 0
    property real to: 100
    property real value: 0
    property real stepSize: 1
    property string suffix: ""
    property int strokeWidth: 10
    property bool readOnly: false
    property color color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)

    readonly property real maximum: Math.max(from, to)
    readonly property real minimum: Math.min(from, to)
    readonly property real effectiveValue: isFinite(value) ? Math.max(minimum, Math.min(maximum, value)) : minimum

    signal moved(real value)

    function valueAt(x, y) {
        let angle = Math.atan2(y - height / 2, x - width / 2) * 180 / Math.PI
        angle = (angle - 135 + 360) % 360
        if (angle > 270)
            angle = angle > 315 ? 0 : 270
        return minimum + (maximum - minimum) * angle / 270
    }

    function setValue(next) {
        if (!enabled || readOnly || !isFinite(next) || !isFinite(from) || !isFinite(to))
            return false
        const step = isFinite(stepSize) && stepSize > 0 ? stepSize : 1
        const normalized = Math.max(minimum, Math.min(maximum,
            minimum + Math.round((next - minimum) / step) * step))
        if (normalized === value)
            return false
        value = normalized
        moved(value)
        return true
    }

    implicitWidth: 120
    implicitHeight: 120
    activeFocusOnTab: true
    focusPolicy: Qt.StrongFocus
    Accessible.role: Accessible.Slider
    Accessible.name: String(effectiveValue) + suffix

    onToChanged: dial.requestPaint()
    onFromChanged: dial.requestPaint()
    onColorChanged: dial.requestPaint()
    onValueChanged: dial.requestPaint()
    onEnabledChanged: dial.requestPaint()
    onStrokeWidthChanged: dial.requestPaint()
    Keys.onUpPressed: setValue(effectiveValue + stepSize)
    Keys.onDownPressed: setValue(effectiveValue - stepSize)
    Keys.onLeftPressed: setValue(effectiveValue - stepSize)
    Keys.onRightPressed: setValue(effectiveValue + stepSize)
    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Home || event.key === Qt.Key_End) {
            setValue(event.key === Qt.Key_Home ? minimum : maximum)
            event.accepted = true
        }
    }

    Canvas {
        id: dial

        anchors.fill: parent

        onPaint: {
            const context = getContext("2d")
            context.reset()
            const radius = Math.max(0, (Math.min(width, height) - control.strokeWidth - 4) / 2)
            const start = Math.PI * 0.75
            context.lineWidth = Math.max(1, control.strokeWidth)
            context.lineCap = "round"
            context.strokeStyle = EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
            context.beginPath()
            context.arc(width / 2, height / 2, radius, start, start + Math.PI * 1.5)
            context.stroke()
            const fraction = control.maximum > control.minimum
                ? (control.effectiveValue - control.minimum) / (control.maximum - control.minimum) : 0
            if (fraction > 0) {
                context.strokeStyle = control.enabled ? control.color
                    : EPaletteManager.ThemePalette.textDisabled(ETheme.dark)
                context.beginPath()
                context.arc(width / 2, height / 2, radius, start, start + Math.PI * 1.5 * fraction)
                context.stroke()
            }
        }
    }
    EText {
        font.bold: true
        font.pixelSize: 26
        anchors.centerIn: parent
        text: Number(control.effectiveValue.toFixed(6)) + control.suffix
        color: control.enabled ? EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
            : EPaletteManager.ThemePalette.textDisabled(ETheme.dark)
    }
    MouseArea {
        anchors.fill: parent
        enabled: !control.readOnly
        cursorShape: Qt.PointingHandCursor

        onPositionChanged: function(mouse) {
            if (pressed)
                control.setValue(control.valueAt(mouse.x, mouse.y))
        }
        onPressed: function(mouse) {
            control.forceActiveFocus()
            control.setValue(control.valueAt(mouse.x, mouse.y))
        }
        onWheel: function(wheel) {
            control.setValue(control.effectiveValue + (wheel.angleDelta.y > 0 ? 1 : -1) * control.stepSize)
            wheel.accepted = true
        }
    }
    Connections {
        function onDarkChanged() { dial.requestPaint() }

        target: ETheme
    }
}

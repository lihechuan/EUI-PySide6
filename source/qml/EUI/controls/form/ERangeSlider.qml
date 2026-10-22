import EUI 1.0
import EUI.Private 1.0
import "../indicator" as IndicatorControls
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQuick.Controls

RangeSlider {
    id: control

    property var marks: ({})
    property var step: undefined
    property bool showStops: false
    property bool showTooltip: true
    property var formatTooltip: null
    property bool validateEvent: true
    property int styleType: EStyle.Primary
    property int size: EControlConfig.sizeFor(control)
    property color color: EPaletteManager.BasePalette.transparent
    property int trackSize: EDefaultConfig.sliderTrackSize(control.size)
    property int handleSize: EDefaultConfig.sliderHandleSize(control.size)

    readonly property var markValues: Object.keys(marks || {})
            .map(Number)
            .filter(function(key) {
                return isFinite(key)
                    && key >= Math.min(control.from, control.to)
                    && key <= Math.max(control.from, control.to)
            })
            .sort(function(left, right) {
                return left - right
            })
    readonly property var stopValues: {
        const values = []
        const step = Math.abs(stepSize)
        const minimum = Math.min(from, to)
        const maximum = Math.max(from, to)
        if (showStops && step > 0 && (maximum - minimum) / step <= 2000)
            for (let key = minimum + step; key < maximum; key += step)
                values.push(key)
        return values
    }

    function markPosition(value) {
        const position = to === from ? 0 : (value - from) / (to - from)
        return horizontal ? (mirrored ? 1 - position : position) : 1 - position
    }

    function closestMark(value, minimum, maximum) {
        const marks = markValues.filter(function(mark) {
            return mark >= minimum && mark <= maximum
        })
        return marks.reduce(function(closest, mark) {
            return Math.abs(mark - value) < Math.abs(closest - value) ? mark : closest
        }, marks.length > 0 ? marks[0] : value)
    }

    function tooltipText(value) {
        if (typeof formatTooltip === "function")
            return String(formatTooltip(value))
        const stepText = String(stepSize)
        const precision = Math.min(12, Math.max(2, (stepText.split(".")[1] || "").length,
            Number(stepText.split("e-")[1]) || 0))
        return String(Number(Number(value).toFixed(precision)))
    }

    function moveToMark(event, target, minimum, maximum) {
        if (step !== "mark")
            return
        const forward = [Qt.Key_Right, Qt.Key_Up, Qt.Key_PageUp].indexOf(event.key) >= 0
        const backward = [Qt.Key_Left, Qt.Key_Down, Qt.Key_PageDown].indexOf(event.key) >= 0
        if (!forward && !backward && event.key !== Qt.Key_Home && event.key !== Qt.Key_End)
            return
        const marks = markValues.filter(function(mark) {
            return mark >= minimum && mark <= maximum
        })
        if (marks.length === 0)
            return
        const reverse = to < from
        const mirroredKey = horizontal && mirrored && [Qt.Key_Left, Qt.Key_Right].indexOf(event.key) >= 0
        const direction = (forward ? 1 : -1) * (reverse ? -1 : 1) * (mirroredKey ? -1 : 1)
        let next = target.value
        if (event.key === Qt.Key_Home || event.key === Qt.Key_End)
            next = marks[(event.key === Qt.Key_End) !== reverse ? marks.length - 1 : 0]
        else if (direction > 0)
            next = marks.find(function(mark) {
                return mark > target.value
            })
        else
            next = marks.slice(0).reverse().find(function(mark) {
                return mark < target.value
            })
        if (next !== undefined) {
            target.value = next
            target.moved()
        }
        event.accepted = true
    }

    hoverEnabled: true
    Keys.priority: Keys.BeforeItem
    bottomPadding: horizontal && markValues.length > 0 ? 24 : 0
    implicitWidth: horizontal ? 160 : handleSize + rightPadding
    rightPadding: !horizontal && markValues.length > 0 ? 64 : 0
    implicitHeight: horizontal ? handleSize + bottomPadding : 160
    background: SliderTrack {
        slider: control
        toPosition: control.second.visualPosition
        fromPosition: control.first.visualPosition
        width: control.horizontal ? control.availableWidth : control.trackSize
        height: control.horizontal ? control.trackSize : control.availableHeight
        x: control.horizontal ? control.leftPadding
            : control.leftPadding + (control.availableWidth - width) / 2
        y: control.horizontal ? control.topPadding + (control.availableHeight - height) / 2
            : control.topPadding
    }
    first.handle: SliderHandle {
        slider: control
        pressed: control.first.pressed
        anchors.verticalCenter: undefined
        anchors.horizontalCenter: undefined
        position: control.first.visualPosition
        x: control.horizontal ? control.leftPadding + (control.availableWidth - width) * position
            : control.leftPadding + (control.availableWidth - width) / 2
        y: control.horizontal ? control.topPadding + (control.availableHeight - height) / 2
            : control.topPadding + (control.availableHeight - height) * position

        IndicatorControls.EToolTip {
            text: control.tooltipText(control.first.value)
            visible: control.showTooltip && control.enabled && control.first.pressed && text.trim().length > 0
        }
    }
    second.handle: SliderHandle {
        slider: control
        pressed: control.second.pressed
        anchors.verticalCenter: undefined
        anchors.horizontalCenter: undefined
        position: control.second.visualPosition
        x: control.horizontal ? control.leftPadding + (control.availableWidth - width) * position
            : control.leftPadding + (control.availableWidth - width) / 2
        y: control.horizontal ? control.topPadding + (control.availableHeight - height) / 2
            : control.topPadding + (control.availableHeight - height) * position

        IndicatorControls.EToolTip {
            text: control.tooltipText(control.second.value)
            visible: control.showTooltip && control.enabled && control.second.pressed && text.trim().length > 0
        }
    }

    onStepChanged: if (typeof step === "number" && isFinite(step) && step > 0)
        stepSize = step
    first.onValueChanged: if (step === "mark")
        first.value = closestMark(first.value, Math.min(from, to), second.value)
    second.onValueChanged: if (step === "mark")
        second.value = closestMark(second.value, first.value, Math.max(from, to))
    Keys.onPressed: function(event) {
        const target = second.handle && second.handle.activeFocus ? second : first
        moveToMark(event, target, target === first ? Math.min(from, to) : first.value,
            target === first ? second.value : Math.max(from, to))
    }

    Repeater {
        model: control.stopValues
        delegate: ERectangle {
            width: 4
            height: 4
            radius: 2
            objectName: "sliderStop"
            color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
            x: control.horizontal
                ? control.leftPadding + control.availableWidth * control.markPosition(modelData) - width / 2
                : control.leftPadding + (control.availableWidth - width) / 2
            y: control.horizontal ? control.topPadding + (control.availableHeight - height) / 2
                : control.topPadding + control.availableHeight * control.markPosition(modelData) - height / 2
        }
    }
    Repeater {
        model: control.markValues
        delegate: EText {
            font.pixelSize: 12
            objectName: "sliderMark"
            color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
            text: typeof control.marks[modelData] === "object" ? control.marks[modelData].label
                : control.marks[modelData]
            y: control.horizontal ? control.height - control.bottomPadding + 4
                : control.topPadding + control.availableHeight * control.markPosition(modelData) - height / 2
            x: control.horizontal
                ? Math.max(0, Math.min(control.width - width, control.leftPadding
                    + control.availableWidth * control.markPosition(modelData) - width / 2))
                : control.width - control.rightPadding + 8
        }
    }
}

import EUI 1.0
import EUI.Private 1.0
import "." as FormControls
import "../indicator" as IndicatorControls
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQuick.Controls

Slider {
    id: control

    property var marks: ({})
    property var step: undefined
    property bool showInput: false
    property bool showStops: false
    property bool showTooltip: true
    property var formatTooltip: null
    property bool validateEvent: true
    property bool showInputControls: true
    property int styleType: EStyle.Primary
    property int size: EControlConfig.sizeFor(control)
    property color color: EPaletteManager.BasePalette.transparent
    property int trackSize: EDefaultConfig.sliderTrackSize(control.size)
    property int handleSize: EDefaultConfig.sliderHandleSize(control.size)
    property int inputPrecision: Math.max(0, Math.min(6, (String(stepSize).split(".")[1] || "").length))

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
    implicitWidth: control.horizontal ? 160 : control.handleSize + rightPadding
    rightPadding: horizontal && showInput ? inputField.width + 8
        : !horizontal && markValues.length > 0 ? 64
        : 0
    implicitHeight: control.horizontal
        ? Math.max(control.handleSize, control.showInput ? inputField.implicitHeight : 0)
            + topPadding + bottomPadding
        : 160
    background: SliderTrack {
        slider: control
        toPosition: control.visualPosition
        fromPosition: control.horizontal && !control.mirrored ? 0 : 1
        width: control.horizontal ? control.availableWidth : control.trackSize
        height: control.horizontal ? control.trackSize : control.availableHeight
        x: control.horizontal ? control.leftPadding
            : control.leftPadding + (control.availableWidth - width) / 2
        y: control.horizontal ? control.topPadding + (control.availableHeight - height) / 2
            : control.topPadding
    }
    handle: SliderHandle {
        slider: control
        pressed: control.pressed
        position: control.visualPosition
        anchors.verticalCenter: undefined
        anchors.horizontalCenter: undefined
        x: control.horizontal ? control.leftPadding + (control.availableWidth - width) * position
            : control.leftPadding + (control.availableWidth - width) / 2
        y: control.horizontal ? control.topPadding + (control.availableHeight - height) / 2
            : control.topPadding + (control.availableHeight - height) * position

        IndicatorControls.EToolTip {
            text: control.tooltipText(control.value)
            visible: control.showTooltip && control.enabled && text.trim().length > 0
                && (control.pressed || control.hovered)
        }
    }

    onStepChanged: if (typeof step === "number" && isFinite(step) && step > 0)
        stepSize = step
    Keys.onPressed: function(event) {
        moveToMark(event, control, Math.min(from, to), Math.max(from, to))
    }
    onValueChanged: if (step === "mark")
        value = closestMark(value, Math.min(from, to), Math.max(from, to))
    onMarkValuesChanged: if (step === "mark")
        value = closestMark(value, Math.min(from, to), Math.max(from, to))

    FormControls.ESpinBox {
        id: inputField

        editable: true
        size: control.size
        x: control.width - width
        objectName: "sliderInput"
        numberValue: control.value
        precision: control.inputPrecision
        width: Math.max(96, implicitWidth)
        numberTo: Math.max(control.from, control.to)
        numberFrom: Math.min(control.from, control.to)
        visible: control.horizontal && control.showInput
        numberStep: control.stepSize > 0 ? control.stepSize : 1
        controls: control.showInputControls && control.step !== "mark"
        y: control.topPadding + (control.availableHeight - height) / 2
        to: control.inputPrecision > 0 ? scaledNumber(numberTo) : Math.round(numberTo)
        from: control.inputPrecision > 0 ? scaledNumber(numberFrom) : Math.round(numberFrom)

        onNumberModified: function(numberValue) {
            control.value = numberValue
        }
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
                ? Math.max(0, Math.min(control.leftPadding
                    + control.availableWidth - width, control.leftPadding
                    + control.availableWidth * control.markPosition(modelData) - width / 2))
                : control.width - control.rightPadding + 8
        }
    }
}

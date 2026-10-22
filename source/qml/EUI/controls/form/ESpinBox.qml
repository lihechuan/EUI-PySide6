import EUI 1.0
import "../indicator" as IndicatorControls
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

SpinBox {
    id: control

    property var parser: null
    property int precision: 0
    property string prefix: ""
    property string suffix: ""
    property real numberFrom: 0
    property real numberStep: 1
    property real numberTo: 100
    property var numberValue: 0
    property bool controls: true
    property var formatter: null
    property bool readOnly: false
    property string align: "center"
    property bool stepStrictly: false
    property bool validateEvent: true
    property bool selectByMouse: false
    property string placeholderText: ""
    property string validationMessage: ""
    property int styleType: EStyle.Default
    property bool disabledScientific: false
    property string controlsPosition: "both"
    property Component prefixComponent: null
    property Component suffixComponent: null
    property int indicatorHeight: control.height - 2
    property int size: EControlConfig.sizeFor(control)
    property int validationState: EValidationState.None
    property int iconSize: EDefaultConfig.iconSize(control.size)
    property int indicatorWidth: EDefaultConfig.controlHeight(control.size)
    property var valueOnClear: EControlConfig.valueFor(control, "valueOnClear", null)
    property int incIcon: controlsPosition === "right" ? EIcons.CHEVRON_UP : EIcons.PLUS
    property int decIcon: controlsPosition === "right" ? EIcons.CHEVRON_DOWN : EIcons.MINUS
    property color textColor: EPaletteManager.StatePalette.defaultTextColor(
        EPaletteManager.createStateObject(this, EStyle.TextColor)
            .setDark(ETheme.dark)
            .setEnabled(control.enabled)
    )

    readonly property bool empty: numberValue === null || numberValue === undefined
    readonly property int numberScale: Math.pow(10, Math.max(0, Math.min(6, precision)))
    readonly property bool hasValidationError: validationState === EValidationState.Error

    signal inputRejected(string text)
    signal numberModified(real numberValue)
    signal businessValueModified(var numberValue)

    function scaledNumber(number) {
        return Math.max(-2147483647, Math.min(2147483647, Math.round(number * numberScale)))
    }

    function normalizedNumber(number) {
        const step = precision > 0 ? Math.abs(numberStep) : Math.abs(stepSize)
        return stepStrictly && step > 0 ? Math.round(number / step) * step : number
    }

    function syncNumberValue() {
        if (!inside.completed || inside.syncing)
            return
        inside.syncing = true
        if (!empty && typeof numberValue === "number" && isFinite(numberValue)) {
            const next = scaledNumber(normalizedNumber(numberValue))
            if (value !== next)
                value = next
            if (numberValue !== value / numberScale)
                numberValue = value / numberScale
        }
        inside.syncing = false
    }

    function commitInput(input) {
        if (!enabled || readOnly || !editable)
            return false
        let text = String(input).trim()
        if (prefix && text.indexOf(prefix) === 0)
            text = text.slice(prefix.length)
        if (suffix && text.slice(-suffix.length) === suffix)
            text = text.slice(0, -suffix.length)
        if (text.trim().length === 0) {
            const next = typeof valueOnClear === "function" ? valueOnClear() : valueOnClear
            numberValue = next === "min" ? Math.min(from, to) / numberScale
                : next === "max" ? Math.max(from, to) / numberScale : next
        } else {
            try {
                const parsed = typeof parser === "function" ? parser(text) : text
                if (disabledScientific && /[eE]/.test(String(parsed))) {
                    inputRejected(input)
                    return false
                }
                const number = typeof parsed === "number" ? parsed
                    : Number.fromLocaleString(locale, String(parsed))
                numberValue = isFinite(number) ? number : null
            } catch (error) {
                inputRejected(input)
                return false
            }
        }
        businessValueModified(numberValue)
        if (!empty)
            numberModified(numberValue)
        contentItem.text = Qt.binding(function() {
            return control.empty ? "" : control.displayText
        })
        return true
    }

    Keys.priority: Keys.BeforeItem
    Accessible.role: Accessible.SpinBox
    to: precision > 0 ? scaledNumber(numberTo) : 99
    Accessible.description: control.validationMessage
    from: precision > 0 ? scaledNumber(numberFrom) : 0
    implicitHeight: EDefaultConfig.controlHeight(control.size)
    font.pixelSize: EDefaultConfig.controlFontPixelSize(control.size)
    stepSize: precision > 0 ? Math.max(1, Math.abs(scaledNumber(numberStep))) : 1
    validator: prefix || suffix || typeof formatter === "function" || typeof parser === "function" ? null
        : numberValidator
    implicitWidth: Math.max(implicitBackgroundWidth
        + leftInset
        + rightInset, Math.max(64, implicitContentWidth)
        + leftPadding
        + rightPadding)
    rightPadding: (controls ? up.indicator.implicitWidth + Math.max(padding, inside.borderWidth)
        : EDefaultConfig.horizontalPadding(size))
        + (suffixLoader.active ? suffixLoader.width + 6 : 0)
    leftPadding: (controls && controlsPosition === "both" ? down.indicator.implicitWidth + Math.max(padding, inside.borderWidth)
        : EDefaultConfig.horizontalPadding(size))
        + (prefixLoader.active ? prefixLoader.width + 6 : 0)
    textFromValue: function(value, locale) {
        const number = value / numberScale
        const text = typeof formatter === "function" ? String(formatter(number))
            : Number(number).toLocaleString(locale, "f", Math.max(0, Math.min(6, precision)))
        return prefix + text + suffix
    }
    background: ERectangle {
        radius: 4
        border.width: inside.borderWidth
        border.color: control.validationState !== EValidationState.None
            ? EPaletteManager.StatePalette.validationColor(control.validationState)
            : EPaletteManager.StatePalette.resolveRectBorderColor(
                EPaletteManager.createStateObject(this, EStyle.BorderColor)
                    .setDark(ETheme.dark)
                    .setHovered(control.hovered)
                    .setActiveFocus(control.activeFocus || inside.isLeftHovered || inside.isRightHovered)
                    .setComponentStyle(control.styleType)
            )
    }
    valueFromText: function(text, locale) {
        try {
            let input = String(text)
            if (prefix && input.indexOf(prefix) === 0)
                input = input.slice(prefix.length)
            if (suffix && input.slice(-suffix.length) === suffix)
                input = input.slice(0, -suffix.length)
            const parsed = typeof parser === "function" ? parser(input) : input
            const number = typeof parsed === "number" ? parsed
                : Number.fromLocaleString(locale, String(parsed))
            return isFinite(number) ? scaledNumber(normalizedNumber(number)) : control.value
        } catch (error) { return control.value }
    }
    contentItem: TextInput {
        clip: true
        font: control.font
        objectName: "spinBoxEditor"
        validator: control.validator
        verticalAlignment: Qt.AlignVCenter
        selectByMouse: control.selectByMouse
        inputMethodHints: control.inputMethodHints
        text: control.empty ? "" : control.displayText
        readOnly: !control.editable || control.readOnly
        selectionColor: EPaletteManager.BasePalette.blue
        selectedTextColor: EPaletteManager.BasePalette.white
        horizontalAlignment: control.align === "left" ? Qt.AlignLeft
            : control.align === "right" ? Qt.AlignRight
            : Qt.AlignHCenter
        color: EPaletteManager.StatePalette.computeEffectiveTextColor(
            EPaletteManager.createStateObject(this, EStyle.Color)
                .setDark(ETheme.dark)
                .setEnabled(control.enabled)
                .setPlain(true)
                .setColor(textColor)
        )

        onEditingFinished: control.commitInput(text)

        EText {
            font: control.font
            anchors.fill: parent
            text: control.placeholderText
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: parent.horizontalAlignment
            visible: control.empty && parent.text.length === 0
            color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
        }
    }
    up.indicator: Item {
        anchors.top: parent.top
        visible: control.controls
        anchors.right: parent.right
        anchors.topMargin: inside.borderWidth
        anchors.rightMargin: inside.borderWidth
        implicitWidth: control.controls ? Math.max(0, control.indicatorWidth) : 0
        enabled: control.enabled && !control.readOnly && (control.wrap || control.value < control.to)
        height: Math.max(0, control.indicatorHeight) / (control.controlsPosition === "right" ? 2 : 1)

        onEnabledChanged: {
            inside.isRightHovered = false
        }

        EIcon {
            iconSource: incIcon
            width: parent.width
            height: parent.height
            iconSize: Math.max(0, control.iconSize)
            color: EPaletteManager.StatePalette.computeTextColor(
                EPaletteManager.createStateObject(this, EStyle.Color)
                    .setDark(ETheme.dark)
                    .setHovered(inside.isRightHovered)
                    .setEnabled(parent.enabled)
                    .setComponentStyle(control.styleType)
            )

            ERectangle {
                height: parent.height
                anchors.left: parent.left
                width: inside.borderWidth
                color: inside.indicatorBorderColor
            }
        }
        HoverHandler {
            cursorShape: Qt.PointingHandCursor
            acceptedDevices: PointerDevice.Mouse

            onHoveredChanged: inside.isRightHovered = hovered
        }
    }
    down.indicator: Item {
        visible: control.controls
        anchors.leftMargin: inside.borderWidth
        anchors.rightMargin: inside.borderWidth
        implicitWidth: control.controls ? Math.max(0, control.indicatorWidth) : 0
        anchors.left: control.controlsPosition === "right" ? undefined : parent.left
        anchors.right: control.controlsPosition === "right" ? parent.right : undefined
        anchors.topMargin: control.controlsPosition === "right" ? 0 : inside.borderWidth
        anchors.top: control.controlsPosition === "right" ? parent.verticalCenter : parent.top
        height: Math.max(0, control.indicatorHeight) / (control.controlsPosition === "right" ? 2 : 1)
        enabled: control.enabled && !control.readOnly && (control.wrap || control.value > control.from)

        onEnabledChanged: {
            inside.isLeftHovered = false
        }

        EIcon {
            iconSource: decIcon
            width: parent.width
            height: parent.height
            iconSize: Math.max(0, control.iconSize)
            color: EPaletteManager.StatePalette.computeTextColor(
                EPaletteManager.createStateObject(this, EStyle.Color)
                    .setDark(ETheme.dark)
                    .setHovered(inside.isLeftHovered)
                    .setEnabled(parent.enabled)
                    .setComponentStyle(control.styleType)
            )

            ERectangle {
                height: parent.height
                width: inside.borderWidth
                color: inside.indicatorBorderColor
                anchors.left: control.controlsPosition === "right" ? parent.left : parent.right
            }
        }
        HoverHandler {
            cursorShape: Qt.PointingHandCursor
            acceptedDevices: PointerDevice.Mouse

            onHoveredChanged: inside.isLeftHovered = hovered
        }
    }

    onNumberStepChanged: syncNumberValue()
    onNumberValueChanged: syncNumberValue()
    onStepStrictlyChanged: syncNumberValue()
    onPrecisionChanged: if (inside.completed)
        syncNumberValue()
    onValueModified: {
        numberModified(value / numberScale)
        businessValueModified(numberValue)
    }
    Component.onCompleted: {
        inside.completed = true
        if (precision > 0 || numberValue !== 0)
            syncNumberValue()
        else
            numberValue = value
    }
    Keys.onPressed: function(event) {
        if (readOnly
            && [Qt.Key_Up, Qt.Key_Down, Qt.Key_PageUp, Qt.Key_PageDown].indexOf(event.key) >= 0)
            event.accepted = true
    }
    onValueChanged: {
        if (!inside.completed || inside.syncing)
            return
        inside.syncing = true
        if (stepStrictly) {
            const next = scaledNumber(normalizedNumber(value / numberScale))
            if (value !== next)
                value = next
        }
        numberValue = value / numberScale
        inside.syncing = false
    }

    IndicatorControls.EToolTip {
        delay: 300
        triggerKeys: []
        trigger: "manual"
        reference: control
        text: control.validationMessage
        objectName: "inputValidationTooltip"
        visible: control.enabled && control.validationState !== EValidationState.None
            && control.validationState !== EValidationState.Success
            && control.validationMessage.length > 0
            && (control.hovered || control.activeFocus)
    }
    Loader {
        id: prefixLoader

        readonly property var input: control
        readonly property real contentWidth: active && item ? item.implicitWidth : 0
        readonly property real contentHeight: active && item ? item.implicitHeight : 0

        width: contentWidth
        height: contentHeight
        objectName: "spinBoxPrefix"
        y: (control.height - height) / 2
        active: control.prefixComponent !== null
        sourceComponent: control.prefixComponent
        x: control.controls && control.controlsPosition === "both"
            ? control.down.indicator.width + control.padding
            : EDefaultConfig.horizontalPadding(control.size)
    }
    Loader {
        id: suffixLoader

        readonly property var input: control
        readonly property real contentWidth: active && item ? item.implicitWidth : 0
        readonly property real contentHeight: active && item ? item.implicitHeight : 0

        width: contentWidth
        height: contentHeight
        objectName: "spinBoxSuffix"
        y: (control.height - height) / 2
        active: control.suffixComponent !== null
        sourceComponent: control.suffixComponent
        x: control.width - width - (control.controls ? control.up.indicator.width + control.padding
            : EDefaultConfig.horizontalPadding(control.size))
    }
    QtObject {
        id: inside

        property int borderWidth: 1
        property bool syncing: false
        property bool completed: false
        property bool isLeftHovered: false
        property bool isRightHovered: false
        property color indicatorBorderColor: EPaletteManager.StatePalette.resolveRectBorderColor(
            EPaletteManager.createStateObject(this, EStyle.BorderColor)
                .setDark(ETheme.dark)
        )
    }
    DoubleValidator {
        id: numberValidator

        locale: control.locale.name
        decimals: Math.max(0, Math.min(6, control.precision))
        top: Math.max(control.from, control.to) / control.numberScale
        bottom: Math.min(control.from, control.to) / control.numberScale
    }
}

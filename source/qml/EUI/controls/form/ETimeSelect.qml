import EUI 1.0
import "." as FormControls
import "EPickerFormats.js" as PickerFormats
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQuick.Controls

FormControls.ESelect {
    id: control

    property var step: 30
    property string maxTime: ""
    property string minTime: ""
    property string format: "HH:mm"
    property bool includeEndTime: false
    property int prefixIcon: EIcons.CLOCK
    property string end: EValueUtils.formatTime(18, 30, 0, false)
    property string start: EValueUtils.formatTime(8, 30, 0, false)

    function formattedOptions() {
        return timeOptions().map(function(text) {
            return {label: control.optionLabel(text), value: text}
        })
    }

    function optionLabel(text) {
        const date = PickerFormats.parseDate(text, "HH:mm", locale)
        return date ? PickerFormats.formatDate(date, format, locale) : ""
    }

    function minutes(text) {
        if (!EValueUtils.validTime(text, false))
            return -1
        const parts = EValueUtils.parseTime(text, false)
        return parts.hour * 60 + parts.minute
    }

    function commitInput(text) {
        if (!enabled || !editable)
            return false
        const date = PickerFormats.parseDate(String(text).trim(), format, locale)
        const key = date ? PickerFormats.formatDate(date, "HH:mm", locale) : ""
        const options = timeOptions()
        if (!key || options.indexOf(key) < 0) {
            editText = value ? optionLabel(value) : ""
            return false
        }
        value = key
        currentIndex = indexOfValue(key)
        editText = optionLabel(key)
        changed(key)
        return true
    }

    function timeOptions() {
        const result = []
        const first = minutes(start)
        const last = minutes(end)
        const interval = typeof step === "string" ? minutes(step) : Number(step)
        if (first < 0
            || last < first
            || !isFinite(interval)
            || interval < 1
            || Math.floor(interval) !== interval
                || (minTime && minutes(minTime) < 0) || (maxTime && minutes(maxTime) < 0)) return result
        const values = []
        for (let minute = first; minute <= last; minute += interval)
            values.push(minute)
        if (includeEndTime && values[values.length - 1] !== last)
            values.push(last)
        for (let index = 0; index < values.length; ++index) {
            const minute = values[index]
            const text = EValueUtils.formatTime(Math.floor(minute / 60), minute % 60, 0, false)
            if ((!minTime || text > minTime) && (!maxTime || text < maxTime))
                result.push(text)
        }
        return result
    }

    textRole: "label"
    valueRole: "value"
    model: formattedOptions()
    leftPadding: EDefaultConfig.horizontalPadding(size) + (prefixIcon > 0 ? 22 : 0)
    placeholderText: EControlConfig.textFor(control, "SelectATimeSlot", ELocale.texts)
    locale: Qt.locale(PickerFormats.localeName(
        EControlConfig.valueFor(control, "locale", ELocale.language),
        ELocale.language
    ))
    contentItem: TextField {
        padding: 0
        background: null
        font: control.font
        selectByMouse: true
        readOnly: !control.editable
        objectName: "timeSelectEditor"
        placeholderText: control.placeholderText
        text: control.currentIndex >= 0 ? control.displayText : ""
        placeholderTextColor: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
        color: control.enabled ? EPaletteManager.ThemePalette.textRegular(ETheme.dark)
            : EPaletteManager.ThemePalette.textDisabled(ETheme.dark)

        onEditingFinished: if (control.editable) {
            control.commitInput(text)
            text = Qt.binding(function() {
                return control.value ? control.optionLabel(control.value) : ""
            })
        }

        EIcon {
            x: -22
            width: 16
            height: 16
            iconSize: 16
            iconSource: control.prefixIcon
            visible: control.prefixIcon > 0
            y: (parent.height - height) / 2
        }
    }
}

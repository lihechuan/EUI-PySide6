import EUI 1.0
import EUI.Private 1.0
import "." as FormControls
import "EPickerFormats.js" as PickerFormats
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Window 2.15
import QtQuick.Controls

FormControls.EInput {
    id: control

    property var value: ""
    property string role: ""
    property string format: ""
    property string maxTime: ""
    property string minTime: ""
    property bool isRange: false
    property var defaultValue: null
    property bool saveOnBlur: false
    property bool showSeconds: true
    property string valueFormat: ""
    property bool arrowControl: true
    property var comparingDate: null
    property var disabledHours: null
    property var disabledMinutes: null
    property var disabledSeconds: null
    property string endPlaceholder: ""
    property string startPlaceholder: ""
    property string rangeSeparator: " — "
    property string placement: "bottom-start"
    property var fallbackPlacements: ["top-start", "bottom-start"]
    property var valueOnClear: EControlConfig.valueFor(control, "valueOnClear", undefined)
    property var emptyValues: EControlConfig.valueFor(control, "emptyValues", [undefined, null, ""])

    readonly property var popup: timePopup
    readonly property string displayFormat: format || canonicalFormat
    readonly property string canonicalFormat: showSeconds ? "HH:mm:ss" : "HH:mm"
    readonly property var calendarLocale: Qt.locale(PickerFormats.localeName(
        EControlConfig.valueFor(control, "locale", ELocale.language),
        ELocale.language
    ))
    readonly property bool draftValid: isValidTime(draftTime("start"), "start")
        && (!isRange || isValidTime(draftTime("end"), "end") && draftTime("end") >= draftTime("start"))

    signal picked(var value)
    signal changed(var value)
    signal inputRejected(string text)
    signal popupVisibleChanged(bool visible)

    function close() {
        timePopup.close()
    }

    function padded(number) {
        return EValueUtils.paddedNumber(number)
    }

    function syncText() {
        text = EDataUtils.isArray(value) ? value.map(displayValue).join(rangeSeparator) : displayValue(value)
    }

    function displayValue(item) {
        const date = parseValue(item)
        return date ? PickerFormats.formatDate(date, displayFormat, calendarLocale) : ""
    }

    function draftTime(which) {
        const parts = which === "end" ? internal.end : internal.start
        return EValueUtils.formatTime(parts[0], parts[1], parts[2], showSeconds)
    }

    function clearValue() {
        value = typeof valueOnClear === "function" ? valueOnClear()
            : valueOnClear !== undefined ? valueOnClear
            : isRange ? []
            : ""
        changed(value)
        syncText()
    }

    function parseValue(item) {
        if (EDataUtils.isArray(emptyValues) && emptyValues.indexOf(item) >= 0)
            return null
        return PickerFormats.parseDate(item, valueFormat || canonicalFormat, calendarLocale)
    }

    function canonicalTime(item) {
        const date = parseValue(item) || PickerFormats.parseDate(item, canonicalFormat, calendarLocale)
        return date ? PickerFormats.formatDate(date, canonicalFormat, calendarLocale) : ""
    }

    function timeOptions(part, which) {
        const result = []
        for (let number = 0; number < (part === 0 ? 24 : 60); ++number)
            result.push({label: padded(number), value: number, disabled: !choiceAllowed(part, number, which)})
        return result
    }

    function blocked(callback, args) {
        try {
            const result = typeof callback === "function" ? callback.apply(null, args) : []
            return EDataUtils.isArray(result) ? result : []
        } catch (error) {
            const unavailable = []
            for (let number = 0; number < 60; ++number)
                unavailable.push(number)
            return unavailable
        }
    }

    function selectTime(time) {
        if (!enabled || !isValidTime(time, "start"))
            return false
        const date = EValueUtils.validTime(time, showSeconds)
            ? PickerFormats.parseDate(time, canonicalFormat, calendarLocale)
            : parseValue(time)
        value = PickerFormats.formatDate(date, valueFormat || canonicalFormat, calendarLocale)
        picked(value)
        changed(value)
        syncText()
        close()
        return true
    }

    function setDraft(part, number, which, direction) {
        const parts = (which === "end" ? internal.end : internal.start).slice()
        const limit = part === 0 ? 24 : 60
        let candidate = number
        while (candidate >= 0 && candidate < limit && !choiceAllowed(part, candidate, which)) {
            if (!direction)
                return false
            candidate += direction
        }
        if (candidate < 0 || candidate >= limit)
            return false
        parts[part] = candidate
        if (which === "end")
            internal.end = parts
        else
            internal.start = parts
        return true
    }

    function selectRange(start, end) {
        const first = canonicalTime(start)
        const last = canonicalTime(end)
        if (!enabled
            || !isRange
            || !isValidTime(start, "start")
            || !isValidTime(end, "end")
            || !first
            || !last
            || last < first)
            return false
        value = [start, end].map(function(item) {
            const date = control.parseValue(item)
                || PickerFormats.parseDate(item, control.canonicalFormat, control.calendarLocale)
            return PickerFormats.formatDate(date, control.valueFormat
                || control.canonicalFormat, control.calendarLocale)
        })
        picked(value)
        changed(value)
        syncText()
        close()
        return true
    }

    function open() {
        if (!enabled)
            return
        const first = EDataUtils.isArray(value) ? value[0] : value
        const last = EDataUtils.isArray(value) ? value[1] : value
        const fallback = EDataUtils.isArray(defaultValue) ? defaultValue : [defaultValue, defaultValue]
        const start = parseValue(first)
            || PickerFormats.parseDate(fallback[0], canonicalFormat, calendarLocale)
            || new Date(2000, 0, 1)
        const end = parseValue(last)
            || PickerFormats.parseDate(fallback[1], canonicalFormat, calendarLocale)
            || start
        internal.start = [start.getHours(), start.getMinutes(), start.getSeconds()]
        internal.end = [end.getHours(), end.getMinutes(), end.getSeconds()]
        timePopup.open()
    }

    function commitInput(input) {
        if (!enabled || readOnly)
            return false
        const text = String(input).trim()
        if (!text) {
            clearValue()
            return true
        }
        const parts = isRange ? text.split(rangeSeparator) : [text]
        const dates = parts.map(function(part) {
            return PickerFormats.parseDate(part.trim(), displayFormat, calendarLocale)
        })
        if (dates.some(function(date) {
            return !date
        }) || (isRange && dates.length !== 2)) {
            inputRejected(text)
            syncText()
            return false
        }
        const times = dates.map(function(date) {
            return PickerFormats.formatDate(date, control.valueFormat
                || control.canonicalFormat, control.calendarLocale)
        })
        const accepted = isRange ? selectRange(times[0], times[1]) : selectTime(times[0])
        if (!accepted) {
            inputRejected(text)
            syncText()
        }
        return accepted
    }

    function isValidTime(time, which) {
        const canonical = EValueUtils.validTime(time, showSeconds) ? time : canonicalTime(time)
        if (!canonical || !EValueUtils.validTime(canonical, showSeconds))
            return false
        if ((minTime && (!EValueUtils.validTime(minTime, showSeconds) || canonical < minTime))
                || (maxTime
                    && (!EValueUtils.validTime(maxTime, showSeconds) || canonical > maxTime))) return false
        const parts = EValueUtils.parseTime(canonical, showSeconds)
        const selectedRole = role || (isRange ? which || "start" : "")
        if (blocked(disabledHours, [selectedRole, comparingDate]).indexOf(parts.hour) >= 0)
            return false
        if (blocked(disabledMinutes, [parts.hour, selectedRole, comparingDate]).indexOf(parts.minute) >= 0)
            return false
        return blocked(
            disabledSeconds,
            [parts.hour, parts.minute, selectedRole, comparingDate]
        ).indexOf(parts.second) < 0
    }

    function choiceAllowed(part, number, which) {
        const parts = (which === "end" ? internal.end : internal.start).slice()
        parts[part] = number
        const selectedRole = role || (isRange ? which : "")
        if (blocked(disabledHours, [selectedRole, comparingDate]).indexOf(parts[0]) >= 0)
            return false
        if (part > 0
            && blocked(disabledMinutes, [parts[0], selectedRole, comparingDate]).indexOf(parts[1]) >= 0)
            return false
        if (part > 1
            && blocked(
                disabledSeconds,
                [parts[0], parts[1], selectedRole, comparingDate]
            ).indexOf(parts[2]) >= 0)
            return false
        const first = EValueUtils.formatTime(parts[0], part > 0 ? parts[1]
            : 0, part > 1 ? parts[2]
            : 0, showSeconds)
        const last = EValueUtils.formatTime(parts[0], part > 0 ? parts[1]
            : 59, part > 1 ? parts[2]
            : showSeconds ? 59
            : 0, showSeconds)
        return (!minTime || EValueUtils.validTime(minTime, showSeconds) && last >= minTime)
            && (!maxTime || EValueUtils.validTime(maxTime, showSeconds) && first <= maxTime)
    }

    readOnly: true
    clearable: true
    prefixIcon: EIcons.CLOCK
    Keys.priority: Keys.BeforeItem
    implicitWidth: isRange ? 320 : 220
    text: EDataUtils.isArray(value) ? value.map(displayValue).join(rangeSeparator) : displayValue(value)
    placeholderText: isRange && (startPlaceholder || endPlaceholder)
        ? startPlaceholder + rangeSeparator + endPlaceholder
        : EControlConfig.textFor(control, "SelectATime", ELocale.texts)

    onCleared: clearValue()
    onValueChanged: syncText()
    onFormatChanged: syncText()
    onValueFormatChanged: syncText()
    onEnabledChanged: if (!enabled)
        close()
    onCalendarLocaleChanged: if (control)
        syncText()
    onRangeSeparatorChanged: if (control)
        syncText()
    onEditingFinished: if (!readOnly)
        commitInput(text)
    onActiveFocusChanged: if (!activeFocus && saveOnBlur && !value && !timePopup.visible)
        selectTime(EValueUtils.formatTime(
            new Date().getHours(),
            new Date().getMinutes(),
            new Date().getSeconds(),
            showSeconds
        ))
    Keys.onPressed: {
        if (event.key === Qt.Key_Down
            || readOnly && (event.key === Qt.Key_Return || event.key === Qt.Key_Space)) {
            open()
            event.accepted = true
        } else if (!readOnly && (event.key === Qt.Key_Return || event.key === Qt.Key_Enter)) {
            commitInput(text)
            event.accepted = true
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: control.readOnly
        cursorShape: Qt.PointingHandCursor
        anchors.rightMargin: control.clearable && control.text.length > 0 ? 34 : 0

        onClicked: {
            control.forceActiveFocus()
            control.open()
        }
    }
    MouseArea {
        height: parent.height
        enabled: !control.readOnly
        width: control.leftPadding
        cursorShape: Qt.PointingHandCursor

        onClicked: control.open()
    }
    PickerPopup {
        id: timePopup

        readonly property var position: PickerFormats.popupPosition(
            control,
            this,
            control.Window.window,
            control.placement,
            control.fallbackPlacements
        )

        padding: 12
        x: position.x
        y: position.y
        objectName: "timePickerPopup"
        contentItem: Column {
            spacing: 12

            Repeater {
                model: control.isRange ? 2 : 1
                delegate: Row {
                    id: timeRow

                    readonly property string role: index === 0 ? "start" : "end"
                    readonly property var values: internal ? index === 0 ? internal.start
                        : internal.end
                        : [0, 0, 0]

                    spacing: 8

                    Repeater {
                        model: control.showSeconds ? 3 : 2
                        delegate: Loader {
                            id: timeColumn

                            readonly property int part: index
                            readonly property string timeRole: timeRow ? timeRow.role : "start"
                            readonly property var timeParts: timeRow ? timeRow.values : [0, 0, 0]

                            width: 100
                            sourceComponent: control.arrowControl ? spinColumn : selectColumn
                        }
                    }
                }
            }
            Row {
                spacing: 8
                anchors.right: parent.right

                EButton {
                    text: EControlConfig.textFor(control, "Cancel", ELocale.texts)

                    onClicked: control.close()
                }
                EButton {
                    styleType: EStyle.Primary
                    enabled: control.draftValid
                    objectName: "timePickerConfirm"
                    text: EControlConfig.textFor(control, "Confirm", ELocale.texts)

                    onClicked: {
                        const first = control.draftTime("start")
                        const last = control.draftTime("end")
                        if (control.isRange)
                            control.selectRange(first, last)
                        else
                            control.selectTime(first)
                    }
                }
            }
        }

        onVisibleChanged: if (control)
            control.popupVisibleChanged(visible)
    }
    Component {
        id: selectColumn

        FormControls.ESelect {
            filterable: true
            textRole: "label"
            valueRole: "value"
            value: parent ? parent.timeParts[parent.part] : 0
            objectName: "timePickerChoices" + parent.timeRole + parent.part
            model: control && parent ? control.timeOptions(parent.part, parent.timeRole) : []
            Accessible.name: EControlConfig.textFor(
                control,
                ["Hours", "Minutes", "Seconds"][parent.part],
                ELocale.texts
            )

            onChanged: function(selectedValue) {
                control.setDraft(parent.part, selectedValue, parent.timeRole, 0)
                value = Qt.binding(function() {
                    return parent ? parent.timeParts[parent.part] : 0
                })
            }
        }
    }
    Component {
        id: spinColumn

        FormControls.ESpinBox {
            id: spin

            from: 0
            editable: true
            width: parent.width
            to: parent.part === 0 ? 23 : 59
            value: parent ? parent.timeParts[parent.part] : 0
            objectName: "timePickerSpin" + parent.timeRole + parent.part
            Accessible.name: EControlConfig.textFor(
                control,
                ["Hours", "Minutes", "Seconds"][parent.part],
                ELocale.texts
            )

            onNumberModified: {
                control.setDraft(parent.part, value, parent.timeRole, 0)
                value = Qt.binding(function() {
                    return parent ? parent.timeParts[parent.part] : 0
                })
            }
            onValueModified: {
                const previous = parent.timeParts[parent.part]
                control.setDraft(parent.part, value, parent.timeRole, value < previous ? -1 : 1)
                value = Qt.binding(function() {
                    return parent ? parent.timeParts[parent.part] : 0
                })
            }
        }
    }
    QtObject {
        id: internal

        property var end: [0, 0, 0]
        property var start: [0, 0, 0]
    }
}

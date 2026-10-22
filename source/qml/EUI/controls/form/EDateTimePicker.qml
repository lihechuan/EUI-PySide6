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
    property var shortcuts: []
    property string maxDate: ""
    property string maxTime: ""
    property string minDate: ""
    property string minTime: ""
    property bool showNow: true
    property bool isRange: false
    property var defaultTime: null
    property bool showFooter: true
    property var defaultValue: null
    property var disabledDate: null
    property bool showConfirm: true
    property bool arrowControl: true
    property var disabledHours: null
    property bool singlePanel: false
    property bool unlinkPanels: false
    property var disabledMinutes: null
    property var disabledSeconds: null
    property string endPlaceholder: ""
    property bool showWeekNumber: false
    property string startPlaceholder: ""
    property string rangeSeparator: " — "
    property Component cellComponent: null
    property string timeFormat: "HH:mm:ss"
    property string dateFormat: "YYYY-MM-DD"
    property string placement: "bottom-start"
    property string format: "YYYY-MM-DD HH:mm:ss"
    property int prevMonthIcon: EIcons.CHEVRON_LEFT
    property int prevYearIcon: EIcons.CHEVRONS_LEFT
    property int nextMonthIcon: EIcons.CHEVRON_RIGHT
    property int nextYearIcon: EIcons.CHEVRONS_RIGHT
    property string valueFormat: "YYYY-MM-DD HH:mm:ss"
    property var fallbackPlacements: ["top-start", "bottom-start"]
    property var valueOnClear: EControlConfig.valueFor(control, "valueOnClear", undefined)
    property var emptyValues: EControlConfig.valueFor(control, "emptyValues", [undefined, null, ""])

    readonly property var panel: datePanel
    readonly property var popup: dateTimePopup
    readonly property var endPanel: secondPanel
    readonly property var calendarLocale: Qt.locale(PickerFormats.localeName(
        EControlConfig.valueFor(control, "locale", ELocale.language),
        ELocale.language
    ))

    signal picked(var value)
    signal changed(var value)
    signal calendarChanged(var value)
    signal inputRejected(string text)
    signal popupVisibleChanged(bool visible)
    signal viewChanged(var date, string mode)

    function close() {
        dateTimePopup.close()
    }

    function syncText() {
        text = EDataUtils.isArray(value) ? value.map(displayValue).join(rangeSeparator) : displayValue(value)
    }

    function canonicalValue(input) {
        return parseValue(input) || PickerFormats.parseDate(input, "YYYY-MM-DD HH:mm:ss", calendarLocale)
    }

    function displayValue(input) {
        const date = parseValue(input)
        return date ? PickerFormats.formatDate(date, format, calendarLocale) : ""
    }

    function clearValue() {
        value = typeof valueOnClear === "function" ? valueOnClear()
            : valueOnClear !== undefined ? valueOnClear
            : isRange ? []
            : ""
        changed(value)
        syncText()
    }

    function rangeSelection(values) {
        internal.dates = values
        datePanel.value = values
        secondPanel.value = values
        calendarChanged(values.map(function(item) {
            return datePanel.parseDate(item)
        }))
    }

    function parseValue(input) {
        if (EDataUtils.isArray(emptyValues) && emptyValues.indexOf(input) >= 0)
            return null
        return PickerFormats.parseDate(input, valueFormat || "YYYY-MM-DD HH:mm:ss", calendarLocale)
    }

    function combinedDate(key, clock) {
        const date = datePanel.parseDate(key)
        const time = PickerFormats.parseDate(clock, "HH:mm:ss", calendarLocale)
        if (!date || !time)
            return null
        date.setHours(time.getHours(), time.getMinutes(), time.getSeconds(), 0)
        return date
    }

    function selectDateTime(input) {
        if (!enabled || !isValidDateTime(input, "start"))
            return false
        value = PickerFormats.formatDate(canonicalValue(input), valueFormat
            || "YYYY-MM-DD HH:mm:ss", calendarLocale)
        picked(value)
        changed(value)
        syncText()
        close()
        return true
    }

    function isValidDateTime(input, role) {
        const date = canonicalValue(input)
        const field = role === "end" ? endTime : timeField
        return date && datePanel.dateAllowed(date)
            && field.isValidTime(PickerFormats.formatDate(date, "HH:mm:ss", calendarLocale), role || "start")
    }

    function confirm() {
        const values = isRange ? internal.dates : [datePanel.value]
        if (!EDataUtils.isArray(values) || values.length !== (isRange ? 2 : 1))
            return false
        const first = combinedDate(values[0], timeField.value)
        const last = isRange ? combinedDate(values[1], endTime.value) : null
        return isRange ? selectDateTimeRange(first, last) : selectDateTime(first)
    }

    function linkPanels(source, date, mode) {
        if (isRange && !singlePanel && !unlinkPanels) {
            const shifted = EValueUtils.shiftMonth(date.getFullYear(), date.getMonth(), source === datePanel
                ? 1
                : -1)
            const target = source === datePanel ? secondPanel : datePanel
            target.setView(new Date(shifted.year, shifted.month, 1))
            target.viewMode = mode
        }
        viewChanged(date, mode)
    }

    function selectDateTimeRange(start, end) {
        const first = canonicalValue(start)
        const last = canonicalValue(end)
        if (!enabled
            || !isRange
            || !first
            || !last
            || !isValidDateTime(start, "start")
            || !isValidDateTime(end, "end")
            || last < first)
            return false
        value = [first, last].map(function(date) {
            return PickerFormats.formatDate(date, control.valueFormat
                || "YYYY-MM-DD HH:mm:ss", control.calendarLocale)
        })
        picked(value)
        changed(value)
        syncText()
        close()
        return true
    }

    function defaultDate(index) {
        const initial = EDataUtils.isArray(defaultValue) ? defaultValue[index] : defaultValue
        const date = parseValue(initial)
            || PickerFormats.parseDate(initial, "YYYY-MM-DD", calendarLocale)
            || new Date()
        const defaultClock = EDataUtils.isArray(defaultTime) ? defaultTime[index] : defaultTime
        const clock = PickerFormats.parseDate(defaultClock, "HH:mm:ss", calendarLocale)
            || new Date(2000, 0, 1)
        date.setHours(clock.getHours(), clock.getMinutes(), clock.getSeconds(), 0)
        return date
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
            return PickerFormats.parseDate(part.trim(), control.format, control.calendarLocale)
        })
        const valid = !dates.some(function(date) {
            return !date
        }) && (!isRange || dates.length === 2)
            && (isRange ? selectDateTimeRange(dates[0], dates[1]) : selectDateTime(dates[0]))
        if (!valid) {
            inputRejected(text)
            syncText()
        }
        return valid
    }

    function open() {
        if (!enabled)
            return
        const first = parseValue(EDataUtils.isArray(value) ? value[0] : value) || defaultDate(0)
        const last = parseValue(EDataUtils.isArray(value) ? value[1] : null) || defaultDate(1)
        const selected = isRange
            ? EDataUtils.isArray(value) && value.length === 2
            ? [EValueUtils.formatDate(first), EValueUtils.formatDate(last)]
            : []
            : EValueUtils.formatDate(first)
        internal.dates = selected
        datePanel.value = selected
        secondPanel.value = selected
        datePanel.setView(first)
        const shifted = EValueUtils.shiftMonth(first.getFullYear(), first.getMonth(), 1)
        secondPanel.setView(unlinkPanels ? last : new Date(shifted.year, shifted.month, 1))
        timeField.value = PickerFormats.formatDate(first, "HH:mm:ss", calendarLocale)
        endTime.value = PickerFormats.formatDate(last, "HH:mm:ss", calendarLocale)
        dateTimePopup.open()
    }

    readOnly: true
    clearable: true
    prefixIcon: EIcons.CALENDAR
    Keys.priority: Keys.BeforeItem
    implicitWidth: isRange ? 440 : 280
    text: EDataUtils.isArray(value) ? value.map(displayValue).join(rangeSeparator) : displayValue(value)
    placeholderText: isRange && (startPlaceholder || endPlaceholder)
        ? startPlaceholder + rangeSeparator + endPlaceholder
        : EControlConfig.textFor(control, "SelectADateAndTime", ELocale.texts)

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
    Keys.onPressed: {
        if (event.key === Qt.Key_Down
            || readOnly && (event.key === Qt.Key_Return || event.key === Qt.Key_Space)) {
            open()
            datePanel.focusCalendar()
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
        id: dateTimePopup

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
        objectName: "dateTimePickerPopup"
        contentItem: Column {
            spacing: 12

            Flow {
                spacing: 6
                width: dateRows.implicitWidth
                visible: control.shortcuts.length > 0

                Repeater {
                    model: control.shortcuts
                    delegate: ETextButton {
                        text: modelData.text || ""

                        onClicked: {
                            const next = typeof modelData.value === "function" ? modelData.value()
                                : modelData.value
                            if (control.isRange && EDataUtils.isArray(next))
                                control.selectDateTimeRange(next[0], next[1])
                            else
                                control.selectDateTime(next)
                        }
                    }
                }
            }
            Row {
                id: dateRows

                spacing: 12

                Column {
                    spacing: 8

                    FormControls.EDatePickerPanel {
                        id: datePanel

                        showFooter: false
                        maxDate: control.maxDate
                        minDate: control.minDate
                        fixedView: control.isRange
                        disabledDate: control.disabledDate
                        nextYearIcon: control.nextYearIcon
                        prevYearIcon: control.prevYearIcon
                        cellComponent: control.cellComponent
                        nextMonthIcon: control.nextMonthIcon
                        prevMonthIcon: control.prevMonthIcon
                        showWeekNumber: control.showWeekNumber
                        type: control.isRange ? "daterange" : "date"

                        onPicked: if (!control.showConfirm)
                            control.confirm()
                        onHoverValueChanged: secondPanel.hoverValue = hoverValue
                        onPanelChanged: control.linkPanels(datePanel, date, mode)
                        onCalendarChanged: function(value) {
                            control.rangeSelection(value)
                        }
                    }
                    FormControls.EInput {
                        width: datePanel.width
                        objectName: "dateTimeStartDate"
                        text: {
                            const key = control.isRange ? internal.dates[0] : datePanel.value
                            const date = datePanel.parseDate(key || "")
                            return date
                                ? PickerFormats.formatDate(date, control.dateFormat, control.calendarLocale)
                                : ""
                        }

                        onEditingFinished: {
                            const date = PickerFormats.parseDate(
                                text,
                                control.dateFormat,
                                control.calendarLocale
                            )
                            if (date && datePanel.dateAllowed(date)) {
                                if (control.isRange)
                                    control.rangeSelection([EValueUtils.formatDate(date), internal.dates[1]].filter(function(item) {
                                        return !!item
                                    }))
                                else
                                    datePanel.value = EValueUtils.formatDate(date)
                            }
                            text = Qt.binding(function() {
                                const date = datePanel.parseDate(control.isRange ? internal.dates[0] || ""
                                    : datePanel.value)
                                return date
                                    ? PickerFormats.formatDate(
                                        date,
                                        control.dateFormat,
                                        control.calendarLocale
                                    )
                                    : ""
                            })
                        }
                    }
                    FormControls.ETimePicker {
                        id: timeField

                        role: "start"
                        readOnly: false
                        width: datePanel.width
                        maxTime: control.maxTime
                        minTime: control.minTime
                        format: control.timeFormat
                        arrowControl: control.arrowControl
                        disabledHours: control.disabledHours
                        disabledMinutes: control.disabledMinutes
                        disabledSeconds: control.disabledSeconds
                        comparingDate: datePanel.parseDate(control.isRange ? internal.dates[1] || ""
                            : datePanel.value)
                    }
                }
                Column {
                    spacing: 8
                    visible: control.isRange

                    FormControls.EDatePickerPanel {
                        id: secondPanel

                        fixedView: true
                        showFooter: false
                        type: "daterange"
                        maxDate: control.maxDate
                        minDate: control.minDate
                        visible: !control.singlePanel
                        disabledDate: control.disabledDate
                        nextYearIcon: control.nextYearIcon
                        prevYearIcon: control.prevYearIcon
                        cellComponent: control.cellComponent
                        nextMonthIcon: control.nextMonthIcon
                        prevMonthIcon: control.prevMonthIcon
                        showWeekNumber: control.showWeekNumber

                        onPicked: if (!control.showConfirm)
                            control.confirm()
                        onHoverValueChanged: datePanel.hoverValue = hoverValue
                        onPanelChanged: control.linkPanels(secondPanel, date, mode)
                        onCalendarChanged: function(value) {
                            control.rangeSelection(value)
                        }
                    }
                    FormControls.EInput {
                        width: datePanel.width
                        objectName: "dateTimeEndDate"
                        text: {
                            const date = datePanel.parseDate(internal.dates[1] || "")
                            return date
                                ? PickerFormats.formatDate(date, control.dateFormat, control.calendarLocale)
                                : ""
                        }

                        onEditingFinished: {
                            const date = PickerFormats.parseDate(
                                text,
                                control.dateFormat,
                                control.calendarLocale
                            )
                            if (date && datePanel.dateAllowed(date) && internal.dates.length)
                                control.rangeSelection([internal.dates[0], EValueUtils.formatDate(date)].sort())
                            text = Qt.binding(function() {
                                const date = datePanel.parseDate(internal.dates[1] || "")
                                return date
                                    ? PickerFormats.formatDate(
                                        date,
                                        control.dateFormat,
                                        control.calendarLocale
                                    )
                                    : ""
                            })
                        }
                    }
                    FormControls.ETimePicker {
                        id: endTime

                        role: "end"
                        readOnly: false
                        width: datePanel.width
                        maxTime: control.maxTime
                        minTime: control.minTime
                        format: control.timeFormat
                        arrowControl: control.arrowControl
                        disabledHours: control.disabledHours
                        disabledMinutes: control.disabledMinutes
                        disabledSeconds: control.disabledSeconds
                        comparingDate: datePanel.parseDate(internal.dates[0] || "")
                    }
                }
            }
            Row {
                spacing: 8
                anchors.right: parent.right
                visible: control.showFooter

                EButton {
                    textButton: true
                    visible: control.showNow
                    text: EControlConfig.textFor(control, "Now", ELocale.texts)

                    onClicked: {
                        if (control.isRange)
                            control.selectDateTimeRange(new Date(), new Date())
                        else
                            control.selectDateTime(new Date())
                    }
                }
                EButton {
                    styleType: EStyle.Primary
                    visible: control.showConfirm
                    objectName: "dateTimePickerConfirm"
                    text: EControlConfig.textFor(control, "Confirm", ELocale.texts)
                    enabled: control.isRange ? internal.dates.length === 2
                        && control.isValidDateTime(
                            control.combinedDate(internal.dates[0], timeField.value),
                            "start"
                        )
                        && control.isValidDateTime(
                            control.combinedDate(internal.dates[1], endTime.value),
                            "end"
                        )
                        && control.combinedDate(
                            internal.dates[1],
                            endTime.value
                        ) >= control.combinedDate(internal.dates[0], timeField.value)
                        : control.isValidDateTime(
                            control.combinedDate(datePanel.value, timeField.value),
                            "start"
                        )

                    onClicked: control.confirm()
                }
            }
        }

        onVisibleChanged: if (control)
            control.popupVisibleChanged(visible)
    }
    QtObject {
        id: internal

        property var dates: []
    }
}

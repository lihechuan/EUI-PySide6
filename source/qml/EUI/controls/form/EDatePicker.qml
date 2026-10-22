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
    property string format: ""
    property var shortcuts: []
    property string maxDate: ""
    property string minDate: ""
    property string type: "date"
    property var defaultTime: null
    property bool showFooter: true
    property var defaultValue: null
    property var disabledDate: null
    property bool showConfirm: true
    property string valueFormat: ""
    property bool singlePanel: false
    property bool unlinkPanels: false
    property string endPlaceholder: ""
    property bool showWeekNumber: false
    property string startPlaceholder: ""
    property string rangeSeparator: " — "
    property bool automaticDropdown: false
    property Component cellComponent: null
    property string placement: "bottom-start"
    property int prevMonthIcon: EIcons.CHEVRON_LEFT
    property int prevYearIcon: EIcons.CHEVRONS_LEFT
    property int nextMonthIcon: EIcons.CHEVRON_RIGHT
    property int nextYearIcon: EIcons.CHEVRONS_RIGHT
    property var fallbackPlacements: ["top-start", "bottom-start"]
    property var valueOnClear: EControlConfig.valueFor(control, "valueOnClear", undefined)
    property var emptyValues: EControlConfig.valueFor(control, "emptyValues", [undefined, null, ""])

    readonly property var panel: datePanel
    readonly property var popup: datePopup
    readonly property var endPanel: secondPanel
    readonly property bool isRange: type.indexOf("range") >= 0
    readonly property string displayFormat: format || canonicalFormat
    readonly property bool multiple: ["dates", "months", "years", "quarters"].indexOf(type) >= 0
    readonly property var calendarLocale: Qt.locale(PickerFormats.localeName(
        EControlConfig.valueFor(control, "locale", ELocale.language),
        ELocale.language
    ))
    readonly property string canonicalFormat: type.indexOf("year") === 0 ? "YYYY"
        : type.indexOf("month") === 0 ? "YYYY-MM" : type.indexOf("quarter") === 0 ? "YYYY-[Q]Q" : "YYYY-MM-DD"

    signal picked(var value)
    signal changed(var value)
    signal calendarChanged(var value)
    signal inputRejected(string text)
    signal popupVisibleChanged(bool visible)
    signal viewChanged(var date, string mode)

    function close() {
        datePopup.close()
    }

    function syncText() {
        text = EDataUtils.isArray(value) ? value.map(displayValue).join(isRange ? rangeSeparator : ", ")
            : displayValue(value)
    }

    function displayValue(item) {
        const date = parseValue(item)
        return date ? PickerFormats.formatDate(date, displayFormat, calendarLocale) : ""
    }

    function formatValue(date) {
        if (!PickerFormats.validDate(date))
            return ""
        return PickerFormats.formatDate(date, valueFormat || canonicalFormat, calendarLocale)
    }

    function parseValue(item) {
        if (EDataUtils.isArray(emptyValues) && emptyValues.indexOf(item) >= 0)
            return null
        return PickerFormats.parseDate(item, valueFormat || canonicalFormat, calendarLocale)
    }

    function panelSelection(input) {
        internal.draft = input
        datePanel.value = input
        secondPanel.value = input
        calendarChanged(EDataUtils.isArray(input) ? input.map(function(item) {
            return datePanel.parseDate(item)
        }) : input)
    }

    function clearValue() {
        value = typeof valueOnClear === "function" ? valueOnClear()
            : valueOnClear !== undefined ? valueOnClear
            : isRange || multiple ? []
            : ""
        internal.draft = isRange || multiple ? [] : ""
        changed(value)
        syncText()
    }

    function canonicalValues() {
        function canonical(item) {
            const date = control.parseValue(item)
            return date ? datePanel.valueFor(date) : ""
        }
        return EDataUtils.isArray(value) ? value.map(canonical).filter(function(item) {
            return !!item
        }) : canonical(value)
    }

    function linkPanels(source, date, mode) {
        if (isRange && !singlePanel && !unlinkPanels) {
            const step = type.indexOf("year") === 0 ? 12
                : type.indexOf("month") === 0 || type.indexOf("quarter") === 0 ? 12
                : 1
            const shifted = EValueUtils.shiftMonth(date.getFullYear(), date.getMonth(), source === datePanel
                ? step
                : -step)
            const target = source === datePanel ? secondPanel : datePanel
            target.setView(new Date(shifted.year, shifted.month, 1))
            target.viewMode = mode
        }
        viewChanged(date, mode)
    }

    function commitInput(input) {
        if (readOnly || !enabled)
            return false
        const text = String(input).trim()
        if (!text) {
            clearValue()
            return true
        }
        const parts = isRange ? text.split(rangeSeparator) : multiple ? text.split(/,\s*/) : [text]
        const dates = parts.map(function(part) {
            return PickerFormats.parseDate(part.trim(), displayFormat, calendarLocale)
        })
        if (dates.some(function(date) {
            return !date
        }) || (isRange && (dates.length !== 2 || dates[1] < dates[0]))) {
            inputRejected(text)
            syncText()
            return false
        }
        const valid = commitDate(dates.map(function(date) {
            return datePanel.valueFor(date)
        }))
        if (!valid) {
            inputRejected(text)
            syncText()
        }
        return valid
    }

    function commitDate(input) {
        const values = EDataUtils.isArray(input) ? input : [input]
        const dates = values.map(function(item) {
            return datePanel.parseDate(item)
        })
        if (dates.some(function(date) {
            return !date || !datePanel.periodDate(date)
        })
            || (isRange && dates.length !== 2))
            return false
        const encoded = dates.map(function(date, index) {
            const clock = EDataUtils.isArray(control.defaultTime) ? control.defaultTime[index]
                : control.defaultTime
            const time = PickerFormats.parseDate(clock, "HH:mm:ss", control.calendarLocale)
            if (time && control.isRange)
                date.setHours(time.getHours(), time.getMinutes(), time.getSeconds(), 0)
            return control.formatValue(date)
        })
        value = isRange || multiple ? encoded : encoded[0] || ""
        picked(value)
        changed(value)
        syncText()
        if (!multiple || !showConfirm)
            close()
        return true
    }

    function open() {
        if (!enabled)
            return
        internal.draft = canonicalValues()
        datePanel.value = internal.draft
        secondPanel.value = internal.draft
        const selected = EDataUtils.isArray(value) ? value[0] : value
        const fallback = EDataUtils.isArray(defaultValue) ? defaultValue[0] : defaultValue
        const start = parseValue(selected)
            || PickerFormats.parseDate(fallback, canonicalFormat, calendarLocale)
            || new Date()
        datePanel.setView(start)
        const endDefault = EDataUtils.isArray(defaultValue) ? defaultValue[1] : null
        const end = unlinkPanels && EDataUtils.isArray(value) && parseValue(value[1])
            || PickerFormats.parseDate(endDefault, canonicalFormat, calendarLocale)
        const step = type.indexOf("year") === 0 ? 12
            : type.indexOf("month") === 0 || type.indexOf("quarter") === 0 ? 12
            : 1
        const shifted = EValueUtils.shiftMonth(start.getFullYear(), start.getMonth(), step)
        secondPanel.setView(end || new Date(shifted.year, shifted.month, 1))
        datePopup.open()
    }

    readOnly: true
    clearable: true
    prefixIcon: EIcons.CALENDAR
    Keys.priority: Keys.BeforeItem
    implicitWidth: isRange ? 360 : 220
    text: EDataUtils.isArray(value) ? value.map(displayValue).join(isRange ? rangeSeparator : ", ")
        : displayValue(value)
    placeholderText: isRange && (startPlaceholder || endPlaceholder)
        ? startPlaceholder + rangeSeparator + endPlaceholder
        : EControlConfig.textFor(control, "SelectADate", ELocale.texts)

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
    onActiveFocusChanged: if (activeFocus && automaticDropdown)
        open()
    Keys.onPressed: function(event) {
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
        id: datePopup

        readonly property var position: PickerFormats.popupPosition(
            control,
            this,
            control.Window.window,
            control.placement,
            control.fallbackPlacements
        )

        padding: 0
        x: position.x
        y: position.y
        objectName: "datePickerPopup"
        contentItem: Column {
            spacing: 8

            Flow {
                spacing: 6
                width: panelsRow.implicitWidth
                visible: control.shortcuts.length > 0

                Repeater {
                    model: control.shortcuts
                    delegate: ETextButton {
                        text: modelData.text || ""

                        onClicked: {
                            const next = typeof modelData.value === "function" ? modelData.value()
                                : modelData.value
                            const dates = EDataUtils.isArray(next) ? next : [next]
                            const canonical = dates.map(function(item) {
                                const date = control.parseValue(item)
                                return date ? datePanel.valueFor(date) : ""
                            })
                            control.commitDate(control.isRange || control.multiple ? canonical : canonical[0])
                        }
                    }
                }
            }
            Row {
                id: panelsRow

                FormControls.EDatePickerPanel {
                    id: datePanel

                    showConfirm: false
                    type: control.type
                    maxDate: control.maxDate
                    minDate: control.minDate
                    fixedView: control.isRange
                    showFooter: control.showFooter
                    disabledDate: control.disabledDate
                    nextYearIcon: control.nextYearIcon
                    prevYearIcon: control.prevYearIcon
                    cellComponent: control.cellComponent
                    nextMonthIcon: control.nextMonthIcon
                    prevMonthIcon: control.prevMonthIcon
                    showWeekNumber: control.showWeekNumber

                    onPicked: function(value) {
                        control.commitDate(value)
                    }
                    onHoverValueChanged: secondPanel.hoverValue = hoverValue
                    onCalendarChanged: function(value) {
                        control.panelSelection(value)
                    }
                    onPanelChanged: function(date, mode) {
                        control.linkPanels(datePanel, date, mode)
                    }
                }
                FormControls.EDatePickerPanel {
                    id: secondPanel

                    fixedView: true
                    showConfirm: false
                    type: control.type
                    maxDate: control.maxDate
                    minDate: control.minDate
                    showFooter: control.showFooter
                    disabledDate: control.disabledDate
                    nextYearIcon: control.nextYearIcon
                    prevYearIcon: control.prevYearIcon
                    cellComponent: control.cellComponent
                    nextMonthIcon: control.nextMonthIcon
                    prevMonthIcon: control.prevMonthIcon
                    showWeekNumber: control.showWeekNumber
                    visible: control.isRange && !control.singlePanel

                    onPicked: function(value) {
                        control.commitDate(value)
                    }
                    onHoverValueChanged: datePanel.hoverValue = hoverValue
                    onCalendarChanged: function(value) {
                        control.panelSelection(value)
                    }
                    onPanelChanged: function(date, mode) {
                        control.linkPanels(secondPanel, date, mode)
                    }
                }
            }
            EButton {
                anchors.right: parent.right
                text: EControlConfig.textFor(control, "Confirm", ELocale.texts)
                visible: control.multiple && control.showFooter && control.showConfirm

                onClicked: datePopup.close()
            }
        }

        onVisibleChanged: if (control)
            control.popupVisibleChanged(visible)
    }
    QtObject {
        id: internal

        property var draft: control.isRange || control.multiple ? [] : ""
    }
}

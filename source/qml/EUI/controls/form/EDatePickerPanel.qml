import EUI 1.0
import EUI.Private 1.0
import "EPickerFormats.js" as PickerFormats
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control

    property var value: ""
    property string maxDate: ""
    property string minDate: ""
    property string type: "date"
    property bool fixedView: false
    property string hoverValue: ""
    property string rangeStart: ""
    property bool showFooter: true
    property var disabledDate: null
    property bool showConfirm: false
    property bool showWeekNumber: false
    property Component cellComponent: null
    property int month: new Date().getMonth()
    property int year: new Date().getFullYear()
    property int prevMonthIcon: EIcons.CHEVRON_LEFT
    property int prevYearIcon: EIcons.CHEVRONS_LEFT
    property int nextMonthIcon: EIcons.CHEVRON_RIGHT
    property int nextYearIcon: EIcons.CHEVRONS_RIGHT
    property int size: EControlConfig.sizeFor(control)
    property date focusedDate: new Date(year, month, 1)
    property string viewMode: type.indexOf("year") === 0 ? "year"
        : type.indexOf("month") === 0 || type.indexOf("quarter") === 0 ? "month"
        : "date"
    property var calendarLocale: Qt.locale(PickerFormats.localeName(
        EControlConfig.valueFor(control, "locale", ELocale.language),
        ELocale.language
    ))

    readonly property bool periodView: viewMode !== "date"
    readonly property var selectedDate: parseDate(EDataUtils.isArray(value) ? value[0] || "" : value)

    signal picked(var value)
    signal calendarChanged(var value)
    signal panelChanged(var date, string mode)

    function hoverDate(date) {
        hoverValue = rangeStart && dateAllowed(date) ? valueFor(date) : ""
    }

    function dateAllowed(date) {
        return EValueUtils.dateAllowed(date, minDate, maxDate, disabledDate)
    }

    function focusCalendar() {
        focusedDate = selectedDate || new Date(year, month, 1)
        forceActiveFocus()
    }

    function isSelectedDate(date) {
        const key = valueFor(date)
        return EDataUtils.isArray(value) ? value.indexOf(key) >= 0 : value === key
    }

    function setView(date) {
        if (!date || isNaN(date.getTime()))
            return false
        year = date.getFullYear()
        month = date.getMonth()
        focusedDate = new Date(date)
        return true
    }

    function selectPeriod(date) {
        if ((viewMode === "year" && type.indexOf("year") !== 0)
                || (viewMode === "month" && type.indexOf("month") !== 0 && type.indexOf("quarter") !== 0)) {
            setView(date)
            viewMode = viewMode === "year" ? "month" : "date"
            return true
        }
        return selectDate(date)
    }

    function isInRange(date) {
        if (type.indexOf("range") < 0)
            return false
        const endpoints = rangeStart && hoverValue ? [rangeStart, hoverValue].sort()
            : EDataUtils.isArray(value) ? value
            : []
        if (endpoints.length !== 2)
            return false
        const key = valueFor(date)
        return key > endpoints[0] && key < endpoints[1]
    }

    function shiftMonth(offset) {
        const shift = viewMode === "year" ? offset * 144 : viewMode === "month" ? offset * 12 : offset
        const parts = EValueUtils.shiftMonth(year, month, shift)
        year = parts.year
        month = parts.month
        focusedDate = new Date(year, month, Math.min(focusedDate.getDate(), new Date(year, month
            + 1, 0).getDate()))
        panelChanged(new Date(year, month, 1), viewMode)
    }

    function parseDate(text) {
        const input = String(text)
        if (/^\d{4}$/.test(input))
            return EValueUtils.parseDate(input + "-01-01")
        if (/^\d{4}-\d{2}$/.test(input))
            return EValueUtils.parseDate(input + "-01")
        const quarter = /^(\d{4})-Q([1-4])$/.exec(input)
        if (quarter)
            return EValueUtils.parseDate(quarter[1]
                + "-"
                + EValueUtils.paddedNumber((Number(quarter[2]) - 1) * 3 + 1)
                + "-01")
        return EValueUtils.parseDate(input)
    }

    function valueFor(date) {
        if (type === "year" || type === "years" || type === "yearrange")
            return String(date.getFullYear())
        if (type === "quarter" || type === "quarters" || type === "quarterrange")
            return String(date.getFullYear()) + "-Q" + (Math.floor(date.getMonth() / 3) + 1)
        if (type === "month" || type === "months" || type === "monthrange")
            return Qt.formatDate(date, "yyyy-MM")
        if (type === "week") {
            const monday = new Date(date.getFullYear(), date.getMonth(), date.getDate())
            monday.setDate(monday.getDate() - (monday.getDay() + 6) % 7)
            return EValueUtils.formatDate(monday)
        }
        return EValueUtils.formatDate(date)
    }

    function selectDate(date) {
        if (!enabled)
            return false
        const allowed = periodDate(date)
        if (!allowed)
            return false
        date = allowed
        const key = valueFor(date)
        if (type.indexOf("range") >= 0) {
            if (!rangeStart) {
                rangeStart = key
                value = [key]
                calendarChanged(value)
                return true
            }
            value = [rangeStart, key].sort()
            rangeStart = ""
        } else if (type === "dates" || type === "months" || type === "years" || type === "quarters") {
            const values = EDataUtils.isArray(value) ? value : []
            value = values.indexOf(key) >= 0 ? values.filter(function(item) {
                return item !== key
            }) : values.concat([key])
        } else value = key
        if (!fixedView)
            setView(date)
        focusedDate = new Date(date)
        hoverValue = ""
        if (type.indexOf("range") >= 0)
            calendarChanged(value)
        picked(value)
        return true
    }

    function navigate(offset) {
        const candidate = new Date(focusedDate)
        if (viewMode === "year")
            candidate.setFullYear(candidate.getFullYear() + offset)
        else if (viewMode === "month")
            candidate.setMonth(candidate.getMonth() + offset)
        else
            candidate.setDate(candidate.getDate() + offset)
        const direction = offset < 0 ? -1 : 1
        for (let attempt = 0; attempt < 3660; ++attempt) {
            if (direction < 0 && minDate && EValueUtils.formatDate(candidate) < minDate
                    || direction > 0 && maxDate && EValueUtils.formatDate(candidate) > maxDate) return false
            if (periodDate(candidate)) {
                setView(candidate)
                hoverDate(candidate)
                return true
            }
            if (viewMode === "year")
                candidate.setFullYear(candidate.getFullYear() + direction)
            else if (viewMode === "month")
                candidate.setMonth(candidate.getMonth() + direction)
            else
                candidate.setDate(candidate.getDate() + direction)
        }
        return false
    }

    function periodDate(date, mode) {
        if (!date || isNaN(date.getTime()))
            return null
        const period = mode || type
        if (period.indexOf("month") !== 0 && period.indexOf("year") !== 0 && period.indexOf("quarter") !== 0)
            return dateAllowed(date) ? date : null
        const yearly = period.indexOf("year") === 0
        const quarterly = period.indexOf("quarter") === 0
        const firstMonth = yearly ? 0 : quarterly ? Math.floor(date.getMonth() / 3) * 3 : date.getMonth()
        let first = new Date(date.getFullYear(), firstMonth, 1)
        let last = new Date(date.getFullYear(), firstMonth + (yearly ? 12 : quarterly ? 3 : 1), 0)
        const minimum = parseDate(minDate)
        const maximum = parseDate(maxDate)
        if (minimum && minimum > first)
            first = minimum
        if (maximum && maximum < last)
            last = maximum
        if (first > last)
            return null
        for (let candidate = new Date(first); candidate <= last; candidate.setDate(candidate.getDate() + 1))
            if (dateAllowed(candidate))
                return new Date(candidate)
        return null
    }

    padding: 12
    implicitWidth: 300
    background: FieldSurface {}
    focusPolicy: Qt.StrongFocus
    Keys.priority: Keys.BeforeItem
    implicitHeight: calendarColumn.implicitHeight + topPadding + bottomPadding
    Accessible.name: EControlConfig.textFor(control, "DateSelection", ELocale.texts)
    contentItem: Column {
        id: calendarColumn

        spacing: 6

        Row {
            width: parent.width

            EButton {
                width: 28
                height: 32
                textButton: true
                implicitWidth: 28
                iconSource: control.prevYearIcon
                Accessible.name: EControlConfig.textFor(control, "Previous", ELocale.texts)

                onClicked: {
                    const parts = EValueUtils.shiftMonth(control.year, control.month, control.viewMode === "year"
                        ? -144
                        : -12)
                    control.setView(new Date(parts.year, parts.month, 1))
                    control.panelChanged(new Date(parts.year, parts.month, 1), control.viewMode)
                }
            }
            EButton {
                width: 28
                height: 32
                textButton: true
                implicitWidth: 28
                iconSource: control.prevMonthIcon
                visible: control.viewMode === "date"

                onClicked: control.shiftMonth(-1)
            }
            ETextButton {
                height: 32
                font.bold: true
                width: parent.width - (control.viewMode === "date" ? 112 : 56)
                text: control.viewMode === "year"
                    ? String(Math.floor(control.year / 12) * 12)
                        + " – "
                        + (Math.floor(control.year / 12) * 12 + 11)
                    : control.viewMode === "month" ? String(control.year)
                        : EControlConfig.textFor(
                            control,
                            "Value12",
                            ELocale.texts
                        ).arg(control.year).arg(control.month
                            + 1)

                onClicked: control.viewMode = control.viewMode === "date" ? "month" : "year"
            }
            EButton {
                width: 28
                height: 32
                textButton: true
                implicitWidth: 28
                iconSource: control.nextMonthIcon
                visible: control.viewMode === "date"

                onClicked: control.shiftMonth(1)
            }
            EButton {
                width: 28
                height: 32
                textButton: true
                implicitWidth: 28
                iconSource: control.nextYearIcon
                Accessible.name: EControlConfig.textFor(control, "Next", ELocale.texts)

                onClicked: {
                    const parts = EValueUtils.shiftMonth(control.year, control.month, control.viewMode === "year"
                        ? 144
                        : 12)
                    control.setView(new Date(parts.year, parts.month, 1))
                    control.panelChanged(new Date(parts.year, parts.month, 1), control.viewMode)
                }
            }
        }
        ERectangle {
            height: 1
            width: parent.width
            color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
        }
        Grid {
            columns: 3
            spacing: 6
            width: parent.width
            visible: control.periodView

            Repeater {
                model: !control.periodView ? 0 : control.type.indexOf("quarter") === 0
                    && control.viewMode !== "year" ? 4 : 12
                delegate: EButton {
                    readonly property bool years: control.viewMode === "year"
                    readonly property bool quarters: !years && control.type.indexOf("quarter") === 0
                    readonly property date dateValue: new Date(yearValue, years ? 0
                        : quarters ? index * 3
                        : index, 1)
                    readonly property int yearValue: years ? Math.floor(control.year / 12) * 12 + index
                        : control.year

                    height: 40
                    textButton: true
                    objectName: "datePickerPeriod"
                    enabled: control.periodDate(dateValue, control.viewMode) !== null
                    width: parent ? Math.max(0, (parent.width - parent.spacing * 2) / 3) : 0
                    styleType: control.isSelectedDate(dateValue) ? EStyle.Primary : EStyle.Default
                    text: years ? String(yearValue)
                        : quarters ? "Q" + (index + 1)
                        : control.calendarLocale.standaloneMonthName(index, Locale.ShortFormat)

                    onClicked: control.selectPeriod(dateValue)
                }
            }
        }
        DayOfWeekRow {
            id: weekRow

            height: 24
            padding: 0
            width: parent.width - x
            spacing: monthGrid.spacing
            visible: !control.periodView
            locale: control.calendarLocale
            x: control.showWeekNumber ? 24 : 0
            delegate: EText {
                font.pixelSize: 12
                text: model.shortName
                height: weekRow.availableHeight
                objectName: "datePickerWeekday"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                width: Math.max(0, (weekRow.availableWidth - weekRow.spacing * 6) / 7)
            }
        }
        MonthGrid {
            id: monthGrid

            height: 192
            year: control.year
            month: control.month
            width: parent.width - x
            visible: weekRow.visible
            locale: control.calendarLocale
            objectName: "datePickerMonthGrid"
            x: control.showWeekNumber ? 24 : 0
            delegate: Item {
                id: cell

                readonly property date dateValue: model.date
                readonly property bool inRange: control.isInRange(model.date)
                readonly property bool currentMonth: model.month === control.month
                readonly property bool selected: control.isSelectedDate(model.date)
                readonly property bool available: control.enabled && control.dateAllowed(model.date)

                objectName: "datePickerDay"
                width: Math.max(0, (monthGrid.availableWidth - monthGrid.spacing * 6) / 7)
                height: Math.max(0, (monthGrid.availableHeight - monthGrid.spacing * 5) / 6)

                ERectangle {
                    height: 24
                    width: parent.width
                    visible: cell.inRange
                    anchors.verticalCenter: parent.verticalCenter
                    color: Qt.rgba(EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary).r,
                        EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary).g,
                        EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary).b, 0.12)
                }
                ERectangle {
                    width: 24
                    height: 24
                    radius: 12
                    anchors.centerIn: parent
                    border.color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                    border.width: control.activeFocus
                        && EValueUtils.formatDate(control.focusedDate) === EValueUtils.formatDate(model.date)
                        ? 1
                        : 0
                    color: !cell.available ? EPaletteManager.ThemePalette.surfaceDisabled(ETheme.dark)
                        : cell.selected ? EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                        : EPaletteManager.BasePalette.transparent

                    EText {
                        text: model.day
                        font.pixelSize: 12
                        font.bold: model.today
                        anchors.centerIn: parent
                        visible: control.cellComponent === null
                        color: !cell.available ? EPaletteManager.ThemePalette.textDisabled(ETheme.dark)
                            : cell.selected ? EPaletteManager.BasePalette.white
                            : model.today || dayHover.hovered
                                ? EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                            : !cell.currentMonth ? EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
                            : EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                    }
                }
                Loader {
                    readonly property var cellData: ({date: cell.dateValue, text: model.day, disabled: !cell.available,
                        isSelected: cell.selected, inRange: cell.inRange, isCurrent: cell.currentMonth,
                        row: Math.floor(index / 7), column: index % 7, timestamp: cell.dateValue.getTime(), type: model.today
                            ? "today"
                            : cell.currentMonth ? "normal"
                            : "other-month"})

                    anchors.fill: parent
                    active: control.cellComponent !== null
                    sourceComponent: control.cellComponent
                }
                HoverHandler {
                    id: dayHover

                    enabled: cell.available
                    cursorShape: Qt.PointingHandCursor

                    onHoveredChanged: if (hovered)
                        control.hoverDate(model.date)
                }
            }

            onClicked: function(date) {
                control.selectDate(date)
            }
        }
        Column {
            x: -24
            width: 24
            parent: monthGrid
            visible: control.showWeekNumber && weekRow.visible

            Repeater {
                model: control.showWeekNumber && weekRow.visible ? 6 : 0
                delegate: EText {
                    width: 24
                    font.pixelSize: 10
                    height: monthGrid.height / 6
                    objectName: "datePickerWeekNumber"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
                    text: {
                        const first = new Date(control.year, control.month, 1)
                        first.setDate(first.getDate() - (first.getDay()
                            + 7 - control.calendarLocale.firstDayOfWeek % 7) % 7
                            + index * 7)
                        return PickerFormats.weekNumber(first)
                    }
                }
            }
        }
        ERectangle {
            height: 1
            width: parent.width
            color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
        }
        Row {
            spacing: 8
            width: parent.width
            visible: control.showFooter

            EButton {
                textButton: true
                size: EStyle.Small
                enabled: control.periodDate(new Date()) !== null
                text: EControlConfig.textFor(control, "Today", ELocale.texts)

                onClicked: control.selectDate(new Date())
            }
            EButton {
                size: EStyle.Small
                visible: control.showConfirm
                text: EControlConfig.textFor(control, "Confirm", ELocale.texts)
                enabled: control.type.indexOf("range") < 0
                    || EDataUtils.isArray(control.value) && control.value.length === 2

                onClicked: control.picked(control.value)
            }
        }
    }

    onValueChanged: {
        rangeStart = type.indexOf("range") >= 0 && EDataUtils.isArray(value) && value.length === 1 ? value[0] : ""
        if (selectedDate && !fixedView)
            setView(selectedDate)
    }
    onTypeChanged: {
        viewMode = type.indexOf("year") === 0 ? "year"
            : type.indexOf("month") === 0 || type.indexOf("quarter") === 0 ? "month"
            : "date"
        rangeStart = ""
        value = type.indexOf("range") >= 0
            || type === "dates"
            || type === "months"
            || type === "years"
            || type === "quarters"
            ? []
            : ""
    }
    Keys.onPressed: function(event) {
        let offset = 0
        if (event.key === Qt.Key_Left)
            offset = -1
        else if (event.key === Qt.Key_Right)
            offset = 1
        else if (event.key === Qt.Key_Up)
            offset = viewMode === "date" ? -7 : -3
        else if (event.key === Qt.Key_Down)
            offset = viewMode === "date" ? 7 : 3
        else if (event.key === Qt.Key_Home)
            offset = -(focusedDate.getDay() + 6) % 7
        else if (event.key === Qt.Key_End)
            offset = 6 - (focusedDate.getDay() + 6) % 7
        else if (event.key === Qt.Key_PageUp || event.key === Qt.Key_PageDown) {
            shiftMonth(event.key === Qt.Key_PageUp ? -1 : 1)
            event.accepted = true
            return
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
            selectPeriod(focusedDate)
            event.accepted = true
            return
        } else return
        navigate(offset)
        event.accepted = true
    }
}

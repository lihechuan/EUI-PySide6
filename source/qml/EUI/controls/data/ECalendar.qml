import EUI 1.0
import EUI.Private 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

EDatePickerPanel {
    id: control

    property var range: []
    property var formatter: null
    property Component headerDelegate: null
    property string controllerType: "button"
    property Component dateCellDelegate: null

    readonly property var selectedDay: selectedDate
    readonly property var validatedRange: calculateValidatedDateRange(range)
    readonly property int displayedMonths: validatedRange.length === 2
        && validatedRange[0].getMonth() !== validatedRange[1].getMonth() ? 2 : 1

    signal dateSelected(string value)

    function pickDay(day) {
        return selectDate(day)
    }

    function dateObject(value) {
        if (value instanceof Date)
            return isFinite(value.getTime()) ? value : null
        return parseDate(String(value))
    }

    function dateAllowed(date) {
        return EValueUtils.dateAllowed(date, minDate, maxDate, disabledDate)
            && (validatedRange.length !== 2 || date >= validatedRange[0] && date <= validatedRange[1])
    }

    function selectDate(input) {
        if (!enabled)
            return false
        const offsets = { "prev-month": -1, "next-month": 1, "prev-year": -12, "next-year": 12 }
        if (typeof input === "string" && offsets[input] !== undefined) {
            shiftMonth(offsets[input])
            return true
        }
        const date = input === "today" ? new Date() : dateObject(input)
        if (!date || !dateAllowed(date))
            return false
        value = Qt.formatDate(date, "yyyy-MM-dd")
        year = date.getFullYear()
        month = date.getMonth()
        picked(value)
        return true
    }

    function calculateValidatedDateRange(values) {
        if (!EDataUtils.isArray(values) || values.length !== 2)
            return []
        const first = dateObject(values[0])
        const last = dateObject(values[1])
        if (!first || !last || first > last)
            return []
        const distance = (last.getFullYear() - first.getFullYear()) * 12 + last.getMonth() - first.getMonth()
        const weekStart = Qt.locale(ELocale.language === "zh" ? "zh_CN" : "en_US").firstDayOfWeek
        if (distance > 1 || first.getDay() !== weekStart || last.getDay() !== (weekStart + 6) % 7)
            return []
        return [first, last]
    }

    implicitWidth: 440
    implicitHeight: displayedMonths === 2 ? 760 : 480
    contentItem: Column {
        id: calendarColumn

        spacing: 16

        Loader {
            property int year: control.year
            property int month: control.month

            width: parent.width
            active: sourceComponent !== null
            sourceComponent: control.headerDelegate
        }
        Row {
            spacing: 4
            width: parent.width
            visible: !control.headerDelegate && control.controllerType !== "none"

            EText {
                height: 32
                font.pixelSize: 18
                verticalAlignment: Text.AlignVCenter
                width: Math.max(0, parent.width - 128)
                visible: control.controllerType !== "select"
                color: EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
                text: Qt.formatDate(new Date(control.year, control.month, 1), "yyyy-MM")
            }
            ESelect {
                currentIndex: 100
                width: Math.max(80, parent.width - 228)
                visible: control.controllerType === "select"
                model: {
                    const years = []
                    for (let index = control.year - 100; index <= control.year + 100; ++index)
                        years.push(typeof control.formatter === "function" ? control.formatter(index, "year")
                            : String(index))
                    return years
                }

                onActivated: control.year += index - 100
            }
            ESelect {
                width: 96
                currentIndex: control.month
                visible: control.controllerType === "select"
                model: {
                    const months = []
                    for (let index = 0; index < 12; ++index)
                        months.push(typeof control.formatter === "function"
                            ? control.formatter(index + 1, "month")
                            : Qt.locale(ELocale.language === "zh" ? "zh_CN"
                                : "en_US").standaloneMonthName(index, Locale.ShortFormat))
                    return months
                }

                onActivated: control.month = index
            }
            EButton {
                implicitWidth: 36
                text: EControlConfig.textFor(control, "PreviousGlyph", ELocale.texts)

                onClicked: control.shiftMonth(-1)
            }
            EButton {
                implicitWidth: 36
                iconSource: EIcons.CALENDAR
                enabled: control.dateAllowed(new Date())

                onClicked: control.selectDate("today")
            }
            EButton {
                implicitWidth: 36
                text: EControlConfig.textFor(control, "NextGlyph", ELocale.texts)

                onClicked: control.shiftMonth(1)
            }
        }
        Repeater {
            model: control.displayedMonths

            Column {
                id: monthColumn

                readonly property date displayDate: control.validatedRange.length === 2
                    ? new Date(control.validatedRange[0].getFullYear(), control.validatedRange[0].getMonth()
                        + index, 1)
                    : new Date(control.year, control.month, 1)

                spacing: 8
                width: calendarColumn.width
                height: Math.max(0, (control.availableHeight - calendarColumn.children[0].height
                    - (control.controllerType === "none" ? 0
                        : 32) - calendarColumn.spacing * control.displayedMonths) / control.displayedMonths)

                DayOfWeekRow {
                    id: weekdays

                    height: 24
                    padding: 0
                    width: parent.width
                    locale: Qt.locale(ELocale.language === "zh" ? "zh_CN" : "en_US")
                    delegate: EText {
                        font: control.font
                        text: model.shortName
                        height: weekdays.availableHeight
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                        width: Math.max(0, (weekdays.availableWidth - weekdays.spacing * 6) / 7)
                    }
                }
                MonthGrid {
                    id: days

                    padding: 0
                    spacing: 0
                    width: parent.width
                    month: monthColumn.displayDate.getMonth()
                    year: monthColumn.displayDate.getFullYear()
                    locale: Qt.locale(ELocale.language === "zh" ? "zh_CN" : "en_US")
                    height: Math.max(0, parent.height - weekdays.height - parent.spacing)
                    delegate: ERectangle {
                        id: cell

                        readonly property date dateValue: model.date
                        readonly property bool selected: control.value === Qt.formatDate(
                            dateValue,
                            "yyyy-MM-dd"
                        )

                        border.width: 1
                        objectName: "calendarDay"
                        width: Math.max(0, days.availableWidth / 7)
                        height: Math.max(0, days.availableHeight / 6)
                        border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
                        color: selected ? EPaletteManager.ThemePalette.surfacePressed(ETheme.dark)
                            : EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)

                        EText {
                            x: 10
                            y: 10
                            text: model.day
                            font: control.font
                            visible: !dateSlot.active
                            opacity: model.month === days.month && control.dateAllowed(cell.dateValue) ? 1
                                : 0.35
                            color: cell.selected || model.today
                                ? EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                                : EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                        }
                        Loader {
                            id: dateSlot

                            property date date: cell.dateValue
                            property bool isSelected: cell.selected
                            property string day: Qt.formatDate(date, "yyyy-MM-dd")
                            property string type: model.month === days.month ? "current-month"
                                : date < monthColumn.displayDate ? "prev-month" : "next-month"

                            anchors.fill: parent
                            active: sourceComponent !== null
                            sourceComponent: control.dateCellDelegate
                        }
                    }

                    onClicked: control.selectDate(date)
                }
            }
        }
    }

    onPicked: function(value) {
        dateSelected(value)
    }
    onRangeChanged: {
        if (validatedRange.length === 2) {
            year = validatedRange[0].getFullYear()
            month = validatedRange[0].getMonth()
        }
    }
}

import EUI 1.0
import EUI 1.0 as FormControls
import EUI 1.0 as ConfigControls
import "../../source/qml/EUI/controls/form/EPickerFormats.js" as PickerFormats
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Controls 2.15

TestCase {
    id: testCase

    function init() {
        verify(waitForItemPolished(window.contentItem))
    }

    function test_timeSelectEditableOnlyExistingChoices() {
        const item = createTemporaryObject(timeSelectComponent, window.contentItem,
            {editable: true, start: "09:00", end: "10:00", format: "hh:mm A"})
        verify(item.commitInput("09:30 AM"))
        compare(item.value, "09:30")
        verify(!item.commitInput("09:45 AM"))
        compare(item.value, "09:30")
        const editor = findChild(item, "timeSelectEditor")
        verify(editor !== null)
        verify(!editor.readOnly)
        item.editable = false
        verify(editor.readOnly)
    }

    function test_formattedDateInputAndInvalidRestore() {
        const item = createTemporaryObject(dateComponent, window.contentItem,
            {readOnly: false, format: "DD/MM/YYYY", valueFormat: "YYYYMMDD", value: "20261011"})
        compare(item.text, "11/10/2026")
        verify(item.commitInput("20/10/2026"))
        compare(item.value, "20261020")
        verify(!item.commitInput("30/02/2026"))
        compare(item.value, "20261020")
        compare(item.text, "20/10/2026")
        item.maxDate = "2026-10-25"
        verify(!item.commitInput("26/10/2026"))
    }

    function test_formatOnlyUsesRequestedLocaleNames() {
        let calls = 0
        const locale = {
            monthName: function() {
                ++calls
                return "October"
            },
            dayName: function() {
                ++calls
                return "Sunday"
            }
        }
        const date = new Date(2026, 9, 11, 23, 45)
        compare(PickerFormats.formatDate(date, "HH:mm", locale), "23:45")
        compare(calls, 0)
        compare(PickerFormats.formatDate(date, "DD MMMM YYYY", locale), "11 October 2026")
        compare(calls, 1)
        compare(PickerFormats.formatDate(date, "[MMMM] HH:mm", locale), "MMMM 23:45")
        compare(calls, 1)
    }

    function test_timeSelectFormatStepAndEnd() {
        const item = createTemporaryObject(timeSelectComponent, window.contentItem,
            {start: "09:00", end: "10:10", step: "00:30", format: "hh:mm A"})
        compare(item.timeOptions(), ["09:00", "09:30", "10:00"])
        compare(item.textAt(0), "09:00 AM")
        item.includeEndTime = true
        compare(item.timeOptions(), ["09:00", "09:30", "10:00", "10:10"])
        item.step = "invalid"
        compare(item.count, 0)
        item.step = 30
        item.minTime = "09:30"
        compare(item.timeOptions(), ["10:00", "10:10"])
    }

    function test_calendarViewsWeekNumberAndCellSlot() {
        const panel = createTemporaryObject(panelComponent, window.contentItem,
            {showWeekNumber: true, cellComponent: cellComponent})
        panel.setView(new Date(2026, 9, 11))
        tryVerify(function() {
            return findChild(panel, "customDateCell") !== null
        })
        verify(findChild(panel, "datePickerWeekNumber") !== null)
        panel.viewMode = "year"
        verify(panel.selectPeriod(new Date(2027, 0, 1)))
        compare(panel.viewMode, "month")
        verify(panel.selectPeriod(new Date(2027, 3, 1)))
        compare(panel.viewMode, "date")
        compare(panel.month, 3)
    }

    function test_popupPlacementFallbackAndPeriodTypes() {
        const item = createTemporaryObject(dateComponent, window.contentItem,
            {y: 650, placement: "bottom-start", fallbackPlacements: ["top-start"]})
        item.open()
        verify(item.popup.y < 0)
        item.close()
        item.type = "quarterrange"
        item.open()
        compare(item.panel.viewMode, "month")
        verify(item.panel.selectDate(new Date(2026, 9, 1)))
        verify(item.endPanel.selectDate(new Date(2027, 0, 1)))
        compare(item.value, ["2026-Q4", "2027-Q1"])
        compare(PickerFormats.parseDate("2026-W41", "YYYY-[W]WW", Qt.locale("en_US")).getDay(), 1)
    }

    function test_timeRangeRolesAndConfirmValidity() {
        const item = createTemporaryObject(timeComponent, window.contentItem,
            {isRange: true, value: ["09:00:00", "10:00:00"], disabledHours: function(role) {
                return role === "end" ? [11] : []
            }})
        verify(!item.selectRange("09:00:00", "11:00:00"))
        verify(item.selectRange("09:00:00", "12:00:00"))
        item.open()
        verify(item.setDraft(0, 11, "end", 1))
        compare(item.draftTime("end"), "12:00:00")
        verify(!item.setDraft(0, 11, "end", 0))
        item.minTime = "10:00:00"
        verify(!item.draftValid)
        verify(!findChild(item.popup, "timePickerConfirm").enabled)
    }

    function test_keyboardAndHoverRange() {
        const panel = createTemporaryObject(panelComponent, window.contentItem,
            {type: "daterange", disabledDate: function(date) {
                return date.getDate() === 12
            }})
        panel.setView(new Date(2026, 9, 11))
        panel.forceActiveFocus()
        keyClick(Qt.Key_Right)
        compare(panel.focusedDate.getDate(), 13)
        keyClick(Qt.Key_Return)
        compare(panel.value, ["2026-10-13"])
        panel.hoverDate(new Date(2026, 9, 20))
        verify(panel.isInRange(new Date(2026, 9, 16)))
        keyClick(Qt.Key_Right)
        keyClick(Qt.Key_Return)
        compare(panel.value, ["2026-10-13", "2026-10-14"])
        panel.value = []
        compare(panel.rangeStart, "")
    }

    function test_rangePanelsLinkedUnlinkedAndSingle() {
        const item = createTemporaryObject(dateComponent, window.contentItem,
            {type: "daterange", defaultValue: new Date(2026, 9, 11)})
        item.open()
        compare(item.panel.month, 9)
        compare(item.endPanel.month, 10)
        item.panel.shiftMonth(1)
        compare(item.panel.month, 10)
        compare(item.endPanel.month, 11)
        item.unlinkPanels = true
        item.panel.shiftMonth(-1)
        compare(item.endPanel.month, 11)
        item.singlePanel = true
        verify(!item.endPanel.visible)
        verify(item.panel.selectDate(new Date(2026, 9, 20)))
        verify(item.panel.selectDate(new Date(2026, 9, 10)))
        compare(item.value, ["2026-10-10", "2026-10-20"])
        verify(!item.popup.visible)
    }

    function test_keyboardEditableCommitAndReopenSpinBinding() {
        const item = createTemporaryObject(
            dateComponent,
            window.contentItem,
            {readOnly: false, format: "DD/MM/YYYY"}
        )
        item.forceActiveFocus()
        item.text = "20/10/2026"
        keyClick(Qt.Key_Return)
        compare(item.value, "2026-10-20")
        const time = createTemporaryObject(timeComponent, window.contentItem, {value: "09:00:00"})
        time.open()
        const hour = findChild(time.popup.contentItem, "timePickerSpinstart0")
        verify(hour !== null)
        verify(waitForRendering(hour))
        mouseClick(hour.up.indicator, hour.up.indicator.width / 2, hour.up.indicator.height / 2)
        compare(time.draftTime("start"), "10:00:00")
        time.close()
        time.value = "15:30:00"
        time.open()
        compare(hour.value, 15)
    }

    function test_panelCreatesOnlyVisibleModes() {
        const panel = Qt.createQmlObject('import EUI 1.0; EDatePickerPanel {width: 300}', window.contentItem)
        verify(panel !== null)
        compare(findChild(panel, "datePickerPeriod"), null)
        compare(findChild(panel, "datePickerWeekNumber"), null)
        verify(findChild(panel, "datePickerDay") !== null)
        panel.showWeekNumber = true
        tryVerify(function() { return findChild(panel, "datePickerWeekNumber") !== null })
        panel.viewMode = "year"
        tryVerify(function() { return findChild(panel, "datePickerPeriod") !== null })
        compare(findChild(panel, "datePickerWeekNumber"), null)
        panel.viewMode = "date"
        tryCompare(panel, "periodView", false)
        compare(findChild(panel, "datePickerPeriod"), null)
        panel.destroy()
    }

    function test_clearEmptyValuesCustomValueFormatAndDefaultRangeTime() {
        const item = createTemporaryObject(dateComponent, window.contentItem,
            {type: "daterange", valueFormat: "YYYY-MM-DD HH:mm:ss", valueOnClear: null,
                defaultTime: [new Date(2000, 0, 1, 9), new Date(2000, 0, 1, 18)]})
        item.open()
        item.panel.selectDate(new Date(2026, 9, 11))
        item.endPanel.selectDate(new Date(2026, 9, 12))
        compare(item.value, ["2026-10-11 09:00:00", "2026-10-12 18:00:00"])
        item.clearValue()
        compare(item.value, null)
        compare(item.text, "")
        const time = createTemporaryObject(timeComponent, window.contentItem,
            {isRange: true, readOnly: false, valueFormat: "hh:mm A", format: "HH:mm"})
        verify(time.commitInput("09:00 — 18:30"))
        compare(time.value, ["09:00 AM", "06:30 PM"])
    }

    function test_formatLiteralNamesAndTimeBoundaries() {
        const locale = Qt.locale("en_US")
        const date = PickerFormats.parseDate(
            "2026 year October 11 at 11:45 PM",
            "YYYY [year] MMMM DD [at] hh:mm A",
            locale
        )
        verify(date !== null)
        compare(date.getHours(), 23)
        compare(PickerFormats.formatDate(date, "DD/MM/YYYY HH:mm", locale), "11/10/2026 23:45")
        verify(!PickerFormats.parseDate("2026-02-30", "YYYY-MM-DD", locale))
        verify(!PickerFormats.parseDate("25:00", "HH:mm", locale))
        verify(!PickerFormats.parseDate("00:00 AM", "hh:mm A", locale))
        compare(PickerFormats.parseDate("2024-02-29", "yyyy-MM-dd", locale).getDate(), 29)
        verify(!PickerFormats.parseDate("2026/10/11", "YYYY-MM-DD", locale))
        compare(PickerFormats.parseDate("2026 literal.* 10", "YYYY [literal.*] MM", locale).getMonth(), 9)
    }

    function test_datetimeFormattingDefaultTimeAndRange() {
        const item = createTemporaryObject(dateTimeComponent, window.contentItem,
            {isRange: true, readOnly: false, format: "DD/MM/YYYY HH:mm", valueFormat: "YYYY-MM-DD HH:mm:ss",
                defaultValue: [new Date(2026, 9, 11), new Date(2026, 10, 11)],
                defaultTime: [new Date(2000, 0, 1, 9, 30), new Date(2000, 0, 1, 18, 45)]})
        item.open()
        verify(item.panel.selectDate(new Date(2026, 9, 11)))
        verify(item.endPanel.selectDate(new Date(2026, 10, 11)))
        verify(item.confirm())
        compare(item.value, ["2026-10-11 09:30:00", "2026-11-11 18:45:00"])
        verify(item.commitInput("12/10/2026 08:00 — 13/10/2026 19:00"))
        compare(item.value, ["2026-10-12 08:00:00", "2026-10-13 19:00:00"])
        verify(!item.commitInput("14/10/2026 08:00 — 13/10/2026 19:00"))
        item.disabledSeconds = function(hour, minute, role) {
            return role === "end" ? [0] : []
        }
        verify(!item.selectDateTimeRange("2026-10-12 08:00:00", "2026-10-13 19:00:00"))
    }

    function test_timeFormattingEditingDefaultsAndDisabledOptions() {
        const item = createTemporaryObject(timeComponent, window.contentItem,
            {readOnly: false, arrowControl: false, format: "hh:mm A", valueFormat: "HH:mm:ss",
                value: "09:30:00", defaultValue: new Date(2000, 0, 1, 8, 15), disabledHours: function() {
                    return [10]
                }})
        compare(item.text, "09:30 AM")
        verify(item.commitInput("11:45 PM"))
        compare(item.value, "23:45:00")
        verify(!item.commitInput("10:00 AM"))
        compare(item.value, "23:45:00")
        item.value = ""
        item.open()
        compare(item.draftTime("start"), "08:15:00")
        const options = item.timeOptions(0, "start")
        verify(options[10].disabled)
        verify(!options[9].disabled)
        tryVerify(function() {
            return findChild(item.popup.contentItem, "timePickerChoicesstart0") !== null
        })
        const choices = findChild(item.popup.contentItem, "timePickerChoicesstart0")
        verify(!choices.selectValue(10))
        compare(item.draftTime("start"), "08:15:00")
        verify(choices.selectValue(9))
        compare(item.draftTime("start"), "09:15:00")
    }

    function test_providerLocaleAcrossPopupAndDynamicSwitch() {
        const provider = createTemporaryObject(providerComponent, window.contentItem,
            {locale: {name: "en", texts: {SelectADate: "Local date", SelectATime: "Local time", Confirm: "Local confirm"}}})
        const date = createTemporaryObject(
            dateComponent,
            provider,
            {value: "2026-10-11", format: "DD MMMM YYYY"}
        )
        const time = createTemporaryObject(timeComponent, provider)
        compare(date.placeholderText, "Local date")
        compare(time.placeholderText, "Local time")
        time.open()
        compare(findChild(time.popup.contentItem, "timePickerConfirm").text, "Local confirm")
        provider.locale = {name: "zh", texts: {SelectADate: "局部日期", SelectATime: "局部时间", Confirm: "局部确认"}}
        tryCompare(date, "placeholderText", "局部日期")
        tryCompare(time, "placeholderText", "局部时间")
        tryCompare(findChild(time.popup.contentItem, "timePickerConfirm"), "text", "局部确认")
        compare(date.calendarLocale.name, "zh_CN")
        compare(
            date.text,
            PickerFormats.formatDate(new Date(2026, 9, 11), "DD MMMM YYYY", Qt.locale("zh_CN"))
        )
    }

    width: 900
    height: 760
    visible: true
    when: windowShown
    name: "EUI.web_form_dates"

    Item {
        id: window

        readonly property alias contentItem: window

        width: 900
        height: 760
        visible: true
    }
    Component {
        id: dateComponent

        FormControls.EDatePicker { y: 20 }
    }
    Component {
        id: panelComponent

        FormControls.EDatePickerPanel { y: 20 }
    }
    Component {
        id: dateTimeComponent

        FormControls.EDateTimePicker { y: 20 }
    }
    Component {
        id: timeComponent

        FormControls.ETimePicker { y: 20 }
    }
    Component {
        id: timeSelectComponent

        FormControls.ETimeSelect { y: 20 }
    }
    Component {
        id: providerComponent

        ConfigControls.EConfigProvider {}
    }
    Component {
        id: cellComponent

        EText {
            text: parent.cellData.text
            objectName: "customDateCell"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }
}

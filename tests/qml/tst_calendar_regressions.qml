import EUI 1.0
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function init() {
        ELocale.language = "en"
    }

    function test_invalidDateRejected() {
        const calendar = createTemporaryObject(calendarComponent, testCase)
        verify(calendar !== null)
        verify(!calendar.dateAllowed(null))
        verify(!calendar.dateAllowed(undefined))
        verify(!calendar.dateAllowed(new Date(NaN)))
    }

    function test_gridClickSelectsDay() {
        const calendar = createTemporaryObject(calendarComponent, testCase)
        verify(calendar !== null)
        wait(30)
        mouseClick(calendar, 12 + 5.5 * (calendar.width - 24) / 7,
            92 + 2.5 * (calendar.height - 104) / 6)
        compare(calendar.value, "2024-02-16")
    }

    function test_outsideRangeRejected() {
        const calendar = createTemporaryObject(calendarComponent, testCase)
        verify(calendar !== null)
        verify(!calendar.dateAllowed(new Date(2024, 1, 3, 23, 59, 59)))
        verify(!calendar.dateAllowed(new Date(2024, 1, 25, 0, 0, 0)))
        verify(!calendar.selectDate(new Date(2024, 1, 25, 0, 0, 0)))
        compare(calendar.value, "2024-02-15")
    }

    function test_lastDayIncludesTime() {
        const calendar = createTemporaryObject(calendarComponent, testCase)
        verify(calendar !== null)
        compare(calendar.validatedRange.length, 2)
        verify(calendar.dateAllowed(new Date(2024, 1, 24, 12, 30, 0)))
        verify(calendar.dateAllowed(new Date(2024, 1, 24, 23, 59, 59)))
        verify(calendar.selectDate(new Date(2024, 1, 24, 12, 30, 0)))
        compare(calendar.value, "2024-02-24")
    }

    function test_rangeTimesDoNotExcludeFirstDay() {
        const calendar = createTemporaryObject(calendarComponent, testCase, {
            range: [new Date(2024, 1, 4, 20, 0, 0), new Date(2024, 1, 24, 8, 0, 0)]
        })
        verify(calendar !== null)
        compare(calendar.validatedRange.length, 2)
        verify(calendar.dateAllowed(new Date(2024, 1, 4, 0, 0, 0)))
        verify(calendar.dateAllowed(new Date(2024, 1, 24, 23, 59, 59)))
        verify(calendar.selectDate(new Date(2024, 1, 4, 0, 0, 0)))
        compare(calendar.value, "2024-02-04")
    }

    width: 640
    height: 520
    visible: true
    when: windowShown
    name: "CalendarRegressions"

    Component {
        id: calendarComponent

        ECalendar {
            value: "2024-02-15"
            range: ["2024-02-04", "2024-02-24"]
        }
    }
}

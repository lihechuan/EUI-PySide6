import EUI 1.0
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    property int loadCount: 0
    property int loadedSlides: 0

    function test_statisticFormatting() {
        compare(statistic.displayValue, "12,345.67")
        statistic.value = -1000.25
        compare(statistic.displayValue, "-1,000.25")
        statistic.precision = -1
        compare(statistic.displayValue, "-1,000")
        statistic.value = Infinity
        compare(statistic.displayValue, "—")
    }

    function init() {
        infiniteScroll.visible = false
        carousel.enabled = true
        carousel.currentIndex = 0
        carousel.loop = true
        collapse.enabled = true
        collapse.accordion = false
        collapse.activeNames = []
        segmented.enabled = true
        segmented.currentIndex = 0
        infiniteScroll.finished = false
        infiniteScroll.loading = false
        calendar.enabled = true
        calendar.value = "2026-10-10"
        statistic.value = 12345.67
        statistic.precision = 2
        loadCount = 0
        finishedSpy.clear()
    }

    function test_carouselLoopAndDisabled() {
        compare(carousel.count, 3)
        verify(!carousel.setCurrentIndex(NaN))
        verify(!carousel.setCurrentIndex(Infinity))
        verify(carousel.previous())
        compare(carousel.currentIndex, 2)
        verify(carousel.next())
        compare(carousel.currentIndex, 0)
        carousel.loop = false
        verify(!carousel.previous())
        verify(carousel.setCurrentIndex(999))
        compare(carousel.currentIndex, 2)
        carousel.enabled = false
        verify(!carousel.previous())
    }

    function test_carouselDefersDistantDelegates() {
        const model = []
        for (let index = 0; index < 100; ++index)
            model.push(index)
        const largeCarousel = createTemporaryObject(carouselComponent, testCase, { model: model })
        verify(largeCarousel !== null)
        wait(0)
        verify(loadedSlides > 0)
        verify(loadedSlides <= 3)
        verify(largeCarousel.setCurrentIndex(50))
        wait(0)
        compare(largeCarousel.currentIndex, 50)
        verify(loadedSlides <= 3)
        largeCarousel.model = []
        tryCompare(testCase, "loadedSlides", 0)
    }

    function test_calendarAndTour() {
        verify(calendar.selectDate(new Date(2026, 9, 11)))
        compare(calendar.value, "2026-10-11")
        verify(!calendar.selectDate(new Date(2025, 9, 11)))
        calendar.enabled = false
        verify(!calendar.selectDate(new Date(2026, 9, 12)))
        verify(tour.start())
        compare(tour.currentStep, 0)
        verify(!tour.previous())
        verify(tour.next())
        compare(tour.currentStep, 1)
        verify(tour.previous())
        verify(tour.goTo(1))
        verify(tour.next())
        compare(finishedSpy.count, 1)
        verify(!tour.goTo(999))
        verify(!tour.goTo(NaN))
    }

    function test_infiniteScrollRequestsOnceUntilCompleted() {
        infiniteScroll.enabled = false
        infiniteScroll.loading = false
        infiniteScroll.finished = false
        infiniteScroll.visible = true
        infiniteScroll.contentY = 0
        wait(0)
        loadCount = 0
        infiniteScroll.enabled = true
        infiniteScroll.checkLoad()
        tryCompare(testCase, "loadCount", 1)
        compare(infiniteScroll.loading, true)
        verify(!infiniteScroll.checkLoad())
        infiniteScroll.finishLoad(true)
        compare(infiniteScroll.loading, false)
        compare(infiniteScroll.finished, true)
        verify(!infiniteScroll.checkLoad())
        infiniteScroll.visible = false
    }

    function test_collapseAndSegmentedDisabledOptions() {
        collapse.activeNames = null
        verify(!collapse.isExpanded("one"))
        verify(collapse.toggle("one"))
        verify(collapse.toggle("two"))
        compare(collapse.activeNames, ["one", "two"])
        collapse.accordion = true
        compare(collapse.activeNames, ["one"])
        verify(collapse.toggle("one"))
        verify(collapse.toggle("one"))
        compare(collapse.activeNames, ["one"])
        verify(!collapse.toggle("disabled"))
        verify(segmented.select(1))
        compare(segmented.currentValue, "grid")
        verify(!segmented.select(2))
        verify(!segmented.select(-1))
        verify(!segmented.select(NaN))
        verify(!segmented.select(0.5))
        segmented.enabled = false
        verify(!segmented.select(0))
        segmented.enabled = true
        const options = segmented.model
        segmented.model = []
        compare(segmented.currentIndex, -1)
        compare(segmented.currentValue, null)
        segmented.model = options
        compare(segmented.currentIndex, 0)
        compare(segmented.currentValue, "list")
    }

    width: 700
    height: 500
    visible: true
    when: windowShown
    name: "EUIExtendedData"

    EStatistic {
        id: statistic

        visible: false
    }
    Component {
        id: carouselComponent

        ECarousel {
            autoplay: false
            delegate: Component {
                Item {
                    Component.onCompleted: ++testCase.loadedSlides
                    Component.onDestruction: --testCase.loadedSlides
                }
            }
        }
    }
    ECalendar {
        id: calendar

        visible: false
        maxDate: "2026-12-31"
        minDate: "2026-01-01"
    }
    ECarousel {
        id: carousel

        visible: false
        autoplay: false
        model: ["", "", ""]
    }
    ECollapse {
        id: collapse

        visible: false
        model: [{
            "name": "one",
            "title": "One"
        }, {
            "name": "two",
            "title": "Two"
        }, {
            "name": "disabled",
            "disabled": true
        }]
    }
    ESegmented {
        id: segmented

        visible: false
        model: [{
            "label": "List",
            "value": "list"
        }, {
            "label": "Grid",
            "value": "grid"
        }, {
            "label": "Disabled",
            "value": "disabled",
            "disabled": true
        }]
    }
    EInfiniteScroll {
        id: infiniteScroll

        height: 300
        model: [1, 2]
        visible: false

        onLoadMore: ++testCase.loadCount
    }
    ETour {
        id: tour

        steps: [{
            "title": "First"
        }, {
            "title": "Second"
        }]
    }
    EDescriptions {
        visible: false
        model: [{
            "label": "Key",
            "value": "Value"
        }]
    }
    EImage {
        visible: false
    }
    EResult {
        visible: false
    }
    ETable {
        visible: false
    }
    ETree {
        visible: false
    }
    ETimeline {
        visible: false
        model: [{
            "content": "Event",
            "timestamp": "2026-10-10"
        }]
    }
    SignalSpy {
        id: finishedSpy

        target: tour
        signalName: "finished"
    }
}

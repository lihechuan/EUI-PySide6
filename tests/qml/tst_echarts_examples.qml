import EUI 1.0
import "GalleryTestUtils.js" as GalleryUtils
import "../../example/qml/component" as Gallery
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function test_catalogAndSources() {
        ELocale.language = "en"
        const english = exampleData.models.EChartsTypes.map(function(entry) { return entry.label })
        for (const language of ["en", "zh"]) {
            ELocale.language = language
            const entries = exampleData.models.EChartsTypes
            compare(entries.length, 36)
            const page = createTemporaryObject(pageComponent, testCase)
            verify(page !== null)
            verify(waitForItemPolished(page))
            tryCompare(page, "exampleCount", entries.length + 1)
            GalleryUtils.loadExamples(testCase, page)
            const seen = {}
            for (let index = 0; index < entries.length; ++index) {
                const entry = entries[index]
                verify(!seen[entry.value])
                seen[entry.value] = true
                verify(entry.label.length > 0)
                verify(entry.category.length > 0)
                if (language === "zh")
                    verify(entry.label !== english[index])
                const scenario = findChild(page, "showcaseEECharts" + index)
                verify(scenario !== null)
                compare(scenario.title, entry.label)
                const source = Qt.createQmlObject(scenario.code, sourceHost)
                verify(source !== null)
                compare(source.option, exampleData.models.EChartsOptions[entry.value])
                source.destroy()
            }
            page.destroy()
            wait(0)
        }
        ELocale.language = "en"
    }

    function test_liveDataAndViewportLoading() {
        const page = createTemporaryObject(pageComponent, testCase)
        verify(page !== null)
        verify(waitForItemPolished(page))
        GalleryUtils.loadExamples(testCase, page)
        const selector = findChild(page, "galleryChartType")
        const live = findChild(page, "galleryChartLive")
        const chart = findChild(page, "galleryApacheChart")
        const entries = exampleData.models.EChartsTypes
        const first = findChild(page, "galleryChartPreview0")
        const last = findChild(page, "galleryChartPreview" + (entries.length - 1))
        verify(first !== null && last !== null)
        compare(last.active, false)
        for (let index = 0; index < entries.length; ++index) {
            selector.currentIndex = index
            compare(live.enabled, entries[index].live)
            tryCompare(live, "checked", false)
            tryCompare(chart, "option", exampleData.models.EChartsOptions[entries[index].value])
            const card = findChild(page, "galleryChartExample")
            verify(typeof card.updateData === "function")
            const original = JSON.stringify(chart.option)
            card.updateData()
            if (!entries[index].live)
                compare(JSON.stringify(chart.option), original)
            else
                for (const series of chart.option.series)
                    for (const point of series.data) {
                        const value = Array.isArray(point) ? point[1]
                            : typeof point === "object" ? point.value : point
                        verify(typeof value === "number" && isFinite(value))
                    }
            live.checked = true
        }
        verify(waitForItemPolished(page))
        for (let index = 0; index < entries.length; ++index) {
            const preview = findChild(page, "galleryChartPreview" + index)
            page.contentY = preview.mapToItem(page.contentItem, 0, 0).y - 32
            tryCompare(preview, "active", true)
            let active = 0
            for (let other = 0; other < entries.length; ++other)
                if (findChild(page, "galleryChartPreview" + other).active)
                    ++active
            verify(active <= 2)
        }
        page.contentY = last.mapToItem(page.contentItem, 0, 0).y - 32
        tryCompare(last, "active", true)
        compare(first.active, false)
        page.contentY = 0
        tryCompare(last, "active", false)
        compare(last.item, null)
    }

    height: 820
    width: 1100
    visible: true
    when: windowShown
    name: "EUIEChartsExamples"

    Component {
        id: pageComponent

        Gallery.EEChartsExamples {
            height: 820
            width: 1100
            selectedComponent: "EECharts"
        }
    }
    Item {
        id: sourceHost

        width: 640
        height: 360
    }
}

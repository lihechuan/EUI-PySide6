import EUI 1.0
import "../../example/qml/component" as Gallery
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

TestCase {
    id: testCase

    function initTestCase() {
        if (!testOpenGlAvailable)
            skip("The current platform cannot create an OpenGL context for WebEngine.")
    }

    property var page: null
    property var frame: null

    function option(chart) {
        return evaluate(chart, "chart.getOption()")
    }

    function chartData(chart) {
        return option(chart).series.map(function(series) {
            return series.data
        })
    }

    function cleanup() {
        if (frame) {
            frame.close()
            frame.destroy()
            frame = null
            page = null
            wait(0)
        }
        ETheme.dark = false
        ELocale.language = "en"
    }

    function chartInPage() {
        tryVerify(function() {
            return findChild(page, "galleryApacheChart") !== null
        })
        return findChild(page, "galleryApacheChart")
    }

    function prepareChart(chart) {
        verify(chart.visible)
        tryCompare(chart, "ready", true, 15000)
        compare(chart.errorString, "")
        frame.update()
        waitForRendering(chart, 1000)
        compare(evaluate(chart, "chart.getWidth()"), Math.round(chart.width))
    }

    function liveTimer(chart) {
        const content = chart.parent.data
        for (let index = 0; index < content.length; ++index) {
            const item = content[index]
            if (typeof item.running === "boolean" && typeof item.interval === "number")
                return item
        }
        return null
    }

    function createPage() {
        if (!frame) {
            frame = windowComponent.createObject(null)
            verify(frame !== null)
        }
        page = pageComponent.createObject(frame.contentItem, {
            width: frame.width,
            height: frame.height,
            selectedComponent: "EECharts"
        })
        verify(page !== null)
        return chartInPage()
    }

    function evaluate(chart, expression) {
        let done = false
        let result = null
        const script = "(function() { const chart = echarts.getInstanceByDom(document.getElementById('chart')); "
            + "return " + expression + "; }())"
        chart.contentItem.item.runJavaScript(script, function(value) {
            result = value
            done = true
        })
        tryVerify(function() {
            return done
        }, 10000)
        return result
    }

    function chooseType(index) {
        const selector = findChild(page, "galleryChartType")
        mouseClick(selector)
        tryCompare(selector.popup, "visible", true)
        const list = findChild(selector.popup, "selectOptionList")
        verify(list !== null)
        tryVerify(function() {
            return list.itemAtIndex(index) !== null
        })
        mouseClick(list.itemAtIndex(index))
        compare(selector.currentIndex, index)
        tryCompare(selector.popup, "visible", false)
    }

    function test_fastNavigationBeforeReadyCanRecover() {
        if (!testOpenGlAvailable) {
            skip("The current background platform lacks this native capability.")
            return
        }
        ELocale.language = "en"
        const chart = createPage()
        compare(chart.ready, false)
        page.showComponent("EButton")
        wait(100)
        compare(findChild(page, "galleryApacheChart"), null)
        page.showComponent("EECharts")
        const recreated = chartInPage()
        compare(recreated.ready, false)
        prepareChart(recreated)
        compare(findChild(page, "galleryChartLive").checked, false)
        compare(liveTimer(recreated).running, false)
        compare(option(recreated).series[0].type, "line")
        verifyData(option(recreated))
    }

    function verifyData(current) {
        verify(current.series.length > 0)
        for (let series = 0; series < current.series.length; ++series) {
            const data = current.series[series].data
            verify(data.length > 0)
            for (let index = 0; index < data.length; ++index) {
                const point = data[index]
                const values = EDataUtils.isArray(point) ? point
                    : typeof point === "object" ? [point.value] : [point]
                if (EDataUtils.isArray(point))
                    compare(point.length, 2)
                if (typeof point === "object" && !EDataUtils.isArray(point))
                    verify(typeof point.name === "string" && point.name.length > 0)
                for (let value = 0; value < values.length; ++value) {
                    compare(typeof values[value], "number")
                    verify(isFinite(values[value]))
                }
            }
        }
    }

    function test_navigationUnloadsLiveChartAndReselectsFreshState() {
        if (!testOpenGlAvailable) {
            skip("The current background platform lacks this native capability.")
            return
        }
        ELocale.language = "en"
        const chart = createPage()
        prepareChart(chart)
        mouseClick(findChild(page, "galleryChartLive"))
        compare(liveTimer(chart).running, true)
        page.showComponent("EButton")
        tryVerify(function() {
            return findChild(page, "galleryApacheChart") === null
        })
        compare(findChild(page, "galleryChartLive"), null)
        page.showComponent("EECharts")
        const recreated = chartInPage()
        compare(recreated.ready, false)
        compare(findChild(page, "galleryChartType").currentIndex, 0)
        compare(findChild(page, "galleryChartLive").checked, false)
        compare(liveTimer(recreated).running, false)
        prepareChart(recreated)
        compare(option(recreated).series[0].type, "line")
        verifyData(option(recreated))
    }

    function test_pageDestructionAndRecreationStartFresh() {
        if (!testOpenGlAvailable) {
            skip("The current background platform lacks this native capability.")
            return
        }
        ELocale.language = "en"
        const first = createPage()
        prepareChart(first)
        chooseType(1)
        tryVerify(function() {
            return option(first).series[0].type === "bar"
        })
        mouseClick(findChild(page, "galleryChartLive"))
        compare(liveTimer(first).running, true)
        page.destroy()
        page = null
        wait(0)
        const recreated = createPage()
        compare(recreated.ready, false)
        compare(findChild(page, "galleryChartType").currentIndex, 0)
        compare(findChild(page, "galleryChartLive").checked, false)
        compare(liveTimer(recreated).running, false)
        prepareChart(recreated)
        compare(option(recreated).series[0].type, "line")
        compare(chartData(recreated), exampleData.models.EChartsOptions.line.series.map(function(series) {
            return series.data
        }))
    }

    function test_scrollbarDragAcrossAllCharts() {
        if (!testOpenGlAvailable) {
            skip("The current background platform lacks this native capability.")
            return
        }
        const chart = createPage()
        prepareChart(chart)
        const bar = page.ScrollBar.vertical
        bar.policy = ScrollBar.AlwaysOn
        const x = bar.width / 2
        for (let cycle = 0; cycle < 3; ++cycle) {
            page.contentY = 0
            mousePress(bar, x, bar.height * bar.visualSize / 2)
            for (let step = 1; step <= 80; ++step)
                mouseMove(bar, x, Math.min(bar.height - 1, bar.height * step / 80), 35)
            for (let step = 79; step >= 0; --step)
                mouseMove(bar, x, Math.max(1, bar.height * step / 80), 35)
            mouseRelease(bar, x, 1)
            compare(chart.errorString, "")
        }
        const last = findChild(page, "galleryChartPreview35")
        page.contentY = last.mapToItem(page.contentItem, 0, 0).y - 32
        tryCompare(last, "active", true)
        tryCompare(last.item, "ready", true, 15000)
        compare(last.item.errorString, "")
    }

    function test_liveUpdatesRequireOptInAndResetStopsThem() {
        if (!testOpenGlAvailable) {
            skip("The current background platform lacks this native capability.")
            return
        }
        ELocale.language = "en"
        const chart = createPage()
        prepareChart(chart)
        const live = findChild(page, "galleryChartLive")
        const reset = findChild(page, "galleryChartReset")
        const timer = liveTimer(chart)
        verify(timer !== null)
        compare(live.checked, false)
        compare(timer.running, false)
        const original = chartData(chart)
        wait(timer.interval + 150)
        compare(chartData(chart), original)
        mouseClick(live)
        compare(live.checked, true)
        compare(timer.running, true)
        tryVerify(function() {
            return JSON.stringify(chartData(chart)) !== JSON.stringify(original)
        },
            timer.interval * 3 + 500)
        verifyData(option(chart))
        mouseClick(reset)
        compare(live.checked, false)
        compare(timer.running, false)
        tryVerify(function() {
            return JSON.stringify(chartData(chart)) === JSON.stringify(original)
        })
        wait(timer.interval + 150)
        compare(chartData(chart), original)
        compare(chart.errorString, "")
    }

    function test_typeSwitchingAndBilingualLabelsUseRealOptions() {
        if (!testOpenGlAvailable) {
            skip("The current background platform lacks this native capability.")
            return
        }
        ELocale.language = "en"
        const chart = createPage()
        prepareChart(chart)
        const selector = findChild(page, "galleryChartType")
        const live = findChild(page, "galleryChartLive")
        const reset = findChild(page, "galleryChartReset")
        const englishLabels = exampleData.models.EChartsTypes.map(function(type) {
            return type.label
        })
        const englishLive = live.text
        const englishReset = reset.text
        const types = ["line", "bar", "pie", "scatter"]
        for (let language of ["en", "zh"]) {
            ELocale.language = language
            compare(live.text, exampleData.ui.LiveData)
            compare(reset.text, exampleData.ui.ResetChart)
            if (language === "zh") {
                verify(live.text !== englishLive)
                verify(reset.text !== englishReset)
            }
            compare(selector.count, exampleData.models.EChartsTypes.length)
            for (let index = 0; index < types.length; ++index) {
                chooseType(index)
                const entry = exampleData.models.EChartsTypes[index]
                const expected = exampleData.models.EChartsOptions[entry.value]
                compare(selector.currentText, entry.label)
                if (language === "zh")
                    verify(selector.currentText !== englishLabels[index])
                tryVerify(function() {
                    const current = option(chart)
                    return current.series.length === expected.series.length
                        && current.series.every(function(series) {
                            return series.type === types[index]
                        })
                        && JSON.stringify(current.series.map(function(series) {
                            return series.data
                        }))
                            === JSON.stringify(expected.series.map(function(series) {
                                return series.data
                            }))
                })
                const current = option(chart)
                verifyData(current)
                for (let series = 0; series < expected.series.length; ++series)
                    if (expected.series[series].name !== undefined)
                        compare(current.series[series].name, expected.series[series].name)
                if (expected.xAxis && expected.xAxis.data !== undefined)
                    compare(current.xAxis[0].data, expected.xAxis.data)
                compare(chart.errorString, "")
            }
        }
    }

    height: 820
    width: 1100
    visible: true
    when: windowShown
    name: "EUIEChartsGallery"

    Component {
        id: pageComponent

        Gallery.EEChartsExamples {}
    }
    Component {
        id: windowComponent

        Window {
            height: 820
            width: 1100
            visible: true
            flags: Qt.Tool | Qt.WindowDoesNotAcceptFocus
            color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
        }
    }
}

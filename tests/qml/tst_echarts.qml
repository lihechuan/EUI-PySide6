import EUI 1.0
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function initTestCase() {
        if (!testOpenGlAvailable)
            skip("The current platform cannot create an OpenGL context for WebEngine.")
    }

    property var chart: null

    function option(chart) {
        return evaluate(chart, "chart.getOption()")
    }

    function cleanup() {
        chart = null
        ETheme.dark = false
        ELocale.language = "en"
    }

    function createChart(option, extra) {
        const settings = extra || {}
        settings.option = option
        const item = createTemporaryObject(chartComponent, testCase, settings)
        verify(item !== null)
        chart = item
        tryCompare(item, "ready", true, 15000)
        compare(item.errorString, "")
        return item
    }

    function barOption() {
        return {
            animation: false,
            legend: { data: ["Alpha", "Beta"] },
            xAxis: { type: "category", data: ["A", "B", "C"] },
            yAxis: {},
            dataZoom: [{ type: "inside" }],
            series: [
                { id: "a", name: "Alpha", type: "bar", data: [10, 20, 30] },
                { id: "b", name: "Beta", type: "line", data: [2, 4, 6] }
            ]
        }
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

    function test_commandsFromReadyAndOptionUpdate() {
        if (!testOpenGlAvailable) {
            skip("The current background platform lacks this native capability.")
            return
        }
        const item = createChart(barOption(), { actOnReady: true })
        tryVerify(function() {
            return option(item).legend[0].selected.Alpha === false
        })
        item.setOption({ legend: { data: ["Gamma"] }, animation: false,
            series: [{ name: "Gamma", type: "pie", data: [1, 2, 3] }] })
        item.dispatchAction({ type: "legendUnSelect", name: "Gamma" })
        tryVerify(function() {
            return option(item).series[0].type === "pie"
        })
        compare(option(item).legend[0].selected.Gamma, false)
    }

    function test_appendDataSurvivesReconfiguration() {
        if (!testOpenGlAvailable) {
            skip("The current background platform lacks this native capability.")
            return
        }
        const item = createChart({ animation: false, xAxis: {}, yAxis: {},
            series: [{ type: "scatter", data: [[0, 1], [1, 2]] }] })
        item.appendData({ seriesIndex: 0, data: [[2, 3], [3, 4]] })
        tryVerify(function() {
            return option(item).series[0].data.length === 4
        })
        ETheme.dark = true
        item.renderer = "svg"
        ELocale.language = "zh"
        tryVerify(function() {
            return evaluate(item, "chart.getZr().painter.getType()") === "svg"
        })
        compare(option(item).series[0].data.length, 4)
        compare(item.errorString, "")
    }

    function test_invalidOptionRecoversAndClear() {
        if (!testOpenGlAvailable) {
            skip("The current background platform lacks this native capability.")
            return
        }
        const item = createChart(barOption())
        item.setOption({ animation: false, series: [{ type: "line", data: [1, 2] }] })
        tryVerify(function() {
            return item.errorString.length > 0
        })
        compare(item.ready, false)
        item.setOption(barOption())
        tryCompare(item, "ready", true)
        compare(option(item).series.length, 2)
        compare(option(item).series[0].type, "bar")
        compare(item.errorString, "")
        item.clear()
        tryVerify(function() {
            return !option(item).series || option(item).series.length === 0
        })
        ETheme.dark = true
        item.renderer = "svg"
        tryVerify(function() {
            return evaluate(item, "chart.getZr().painter.getType()") === "svg"
        })
        verify(!option(item).series || option(item).series.length === 0)
        compare(item.errorString, "")
    }

    function test_realEngineClickLegendZoomAndResize() {
        if (!testOpenGlAvailable) {
            skip("The current background platform lacks this native capability.")
            return
        }
        const item = createChart(barOption())
        compare(evaluate(item, "echarts.version"), "6.1.0")
        waitForRendering(item, 1000)
        const point = evaluate(item, "chart.convertToPixel({seriesIndex: 0}, ['A', 5])")
        mouseMove(item.contentItem.item, point[0], point[1])
        mouseClick(item.contentItem.item, point[0], point[1])
        tryVerify(function() {
            return clicked.count > 0
        })
        compare(clicked.signalArguments[0][0].name, "A")
        item.dispatchAction({ type: "legendToggleSelect", name: "Alpha" })
        tryVerify(function() {
            return legend.count > 0
        })
        item.dispatchAction({ type: "dataZoom", start: 20, end: 80 })
        tryVerify(function() {
            return zoom.count > 0
        })
        item.width = 620
        tryVerify(function() {
            return evaluate(item, "chart.getWidth()") === 620
        })
        compare(item.errorString, "")
    }

    function test_partialUpdateAndInteractionSurviveTheme() {
        if (!testOpenGlAvailable) {
            skip("The current background platform lacks this native capability.")
            return
        }
        const item = createChart(barOption())
        item.setOption({ series: [{ id: "b", data: [5, 6, 7] }] }, { notMerge: false })
        item.dispatchAction({ type: "legendUnSelect", name: "Beta" })
        item.dispatchAction({ type: "dataZoom", start: 20, end: 75 })
        tryVerify(function() {
            return option(item).series[1].data[0] === 5
        })
        const before = option(item)
        ETheme.dark = true
        tryVerify(function() {
            return option(item).backgroundColor !== before.backgroundColor
        })
        let current = option(item)
        compare(current.series.length, 2)
        compare(current.series[1].data, [5, 6, 7])
        compare(current.legend[0].selected.Beta, false)
        compare(current.dataZoom[0].start, 20)
        compare(current.dataZoom[0].end, 75)
        item.renderer = "svg"
        ELocale.language = "zh"
        tryVerify(function() {
            return evaluate(item, "chart.getZr().painter.getType()") === "svg"
        })
        current = option(item)
        compare(current.series.length, 2)
        compare(current.series[1].data, [5, 6, 7])
        compare(current.legend[0].selected.Beta, false)
        compare(current.dataZoom[0].start, 20)
        compare(current.dataZoom[0].end, 75)
        compare(item.errorString, "")
    }

    width: 700
    height: 460
    visible: true
    when: windowShown
    name: "EUIECharts"

    Component {
        id: chartComponent

        EECharts {
            property bool actOnReady: false

            width: 680
            height: 400

            onReadyChanged: {
                if (ready && actOnReady)
                    dispatchAction({ type: "legendUnSelect", name: "Alpha" })
            }
        }
    }
    SignalSpy {
        id: clicked

        signalName: "clicked"
        target: testCase.chart
    }
    SignalSpy {
        id: legend

        target: testCase.chart
        signalName: "legendSelected"
    }
    SignalSpy {
        id: zoom

        target: testCase.chart
        signalName: "dataZoomed"
    }
}

import EUI 1.0
import QtQuick 2.15
import QtTest 1.2

TestCase {
    function test_softwareBackendExplainsRequirement() {
        compare(chart.supported, false)
        compare(chart.ready, false)
        ELocale.language = "en"
        tryCompare(chart.contentItem, "status", Loader.Ready)
        compare(chart.errorString, ELocale.texts.ChartRequiresOpenGl)
        compare(chart.contentItem.item.text, chart.errorString)
        ELocale.language = "zh"
        tryCompare(chart.contentItem.item, "text", ELocale.texts.ChartRequiresOpenGl)
        chart.setOption({ series: [{ type: "pie", data: [1, 2, 3] }] })
        chart.dispatchAction({ type: "legendUnSelect", name: "missing" })
        chart.clear()
        compare(chart.ready, false)
        ELocale.language = "en"
    }

    width: 640
    height: 360
    visible: true
    when: windowShown
    name: "EUIEChartsSoftware"

    EECharts {
        id: chart

        anchors.fill: parent
    }
}

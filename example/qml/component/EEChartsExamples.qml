import EUI 1.0
import QtQuick 2.15

ExamplePage {
    title: exampleData.ui.EChartsTitle
    description: exampleData.ui.EChartsDescription

    ExampleSection {
        componentName: "EECharts"

        ExampleCard {
            id: chartExample

            property var currentOption: null

            readonly property bool canUpdate: chartType.currentIndex >= 0
                && exampleData.models.EChartsTypes[chartType.currentIndex].live
            readonly property var selectedOption: {
                const types = exampleData.models.EChartsTypes
                const options = exampleData.models.EChartsOptions
                if (!chartType || !types || !options || chartType.currentIndex < 0)
                    return ({})
                const selected = types[chartType.currentIndex]
                return selected ? options[selected.value] : ({})
            }

            function resetChart() {
                if (liveData)
                    liveData.checked = false
                currentOption = JSON.parse(JSON.stringify(selectedOption))
            }

            function updateData() {
                if (!canUpdate)
                    return
                const next = JSON.parse(JSON.stringify(currentOption || selectedOption))
                if (!next.series)
                    return
                for (let series = 0; series < next.series.length; ++series) {
                    next.series[series].data = next.series[series].data.map(function(value) {
                        if (Array.isArray(value))
                            return [value[0], Math.max(1, value[1] + Math.round(Math.random() * 10 - 5))]
                        if (typeof value === "object") {
                            value.value = Math.max(1, value.value + Math.round(Math.random() * 60 - 30))
                            return value
                        }
                        return Math.max(1, value + Math.round(Math.random() * 30 - 15))
                    })
                }
                currentOption = next
            }

            objectName: "galleryChartExample"
            code: chartShowcase.sourceCode(selectedOption)
            introduction: exampleData.ui.EChartsIntroduction

            onSelectedOptionChanged: Qt.callLater(resetChart)

            Row {
                spacing: 20
                width: parent.width

                Column {
                    spacing: 8

                    EText {
                        font.pixelSize: 14
                        text: exampleData.ui.ChartType
                        color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                    }
                    ESelect {
                        id: chartType

                        width: 280
                        currentIndex: 0
                        textRole: "label"
                        objectName: "galleryChartType"
                        model: exampleData.models.EChartsTypes
                    }
                }
                Row {
                    spacing: 8
                    anchors.verticalCenter: parent.verticalCenter

                    ESwitch {
                        id: liveData

                        text: exampleData.ui.LiveData
                        objectName: "galleryChartLive"
                        enabled: chartExample.canUpdate
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                EButton {
                    objectName: "galleryChartReset"
                    text: exampleData.ui.ResetChart
                    anchors.verticalCenter: parent.verticalCenter

                    onClicked: chartExample.resetChart()
                }
            }
            EECharts {
                id: chart

                height: 400
                width: parent.width
                objectName: "galleryApacheChart"
                option: chartExample.currentOption || chartExample.selectedOption

                onDataZoomed: chartResult.text = exampleData.ui.ChartZoomed
                onLegendSelected: function(params) {
                    chartResult.text = exampleData.ui.ChartLegend.arg(params.name)
                }
                onClicked: function(params) {
                    chartResult.text = exampleData.ui.ChartClicked.arg(params.name).arg(String(params.value))
                }
            }
            EText {
                id: chartResult

                font.pixelSize: 14
                text: exampleData.ui.Waiting
                color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
            }
            EText {
                font.pixelSize: 14
                width: parent.width
                text: chart.errorString
                wrapMode: Text.WordWrap
                visible: text.length > 0
                color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Danger)
            }
            Timer {
                repeat: true
                interval: 1500
                running: liveData.checked && chart.ready && chartExample.canUpdate

                onTriggered: chartExample.updateData()
            }
        }
    }
    EEChartsShowcase {
        id: chartShowcase
    }
}

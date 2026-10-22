import EUI 1.0
import QtQuick 2.15

Column {
    id: showcase

    readonly property var page: {
        let ancestor = parent
        while (ancestor) {
            if (ancestor.examplePage === true)
                return ancestor
            ancestor = ancestor.parent
        }
        return null
    }

    function sourceCode(option) {
        const json = JSON.stringify(option, null, 4).replace(/\n/g, "\n    ")
        return "import EUI 1.0\nimport QtQuick 2.15\n\nEECharts {\n    height: 360\n"
            + "    width: parent.width\n    option: (" + json + ")\n}\n"
    }

    spacing: 24
    width: parent.width

    Repeater {
        model: exampleData.models.EChartsTypes

        ExampleSection {
            componentName: "EECharts"

            ExampleCase {
                id: scenario

                readonly property var chartOption: exampleData.models.EChartsOptions[modelData.value]

                title: modelData.label
                description: modelData.category
                objectName: "showcaseEECharts" + index
                code: showcase ? showcase.sourceCode(chartOption) : ""

                Loader {
                    id: preview

                    readonly property real contentPosition: {
                        if (!showcase || !showcase.page)
                            return 0
                        showcase.page.contentHeight
                        return mapToItem(showcase.page.contentItem, 0, 0).y
                    }

                    height: 360
                    width: parent.width
                    objectName: "galleryChartPreview" + index
                    sourceComponent: EECharts {
                        height: 360
                        width: preview.width
                        option: scenario.chartOption
                    }
                    active: showcase && (!showcase.page || contentPosition < showcase.page.contentY + showcase.page.height
                        && contentPosition + height > showcase.page.contentY)
                }
            }
        }
    }
}

import EUI 1.0
import "GalleryTestUtils.js" as GalleryUtils
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function test_componentCoverage_data() {
        const result = []
        exampleCatalog.groups.forEach(function(group) {
            group.children.forEach(function(entry) {
                if (!entry.demo)
                    result.push({tag: entry.index, entry: entry})
            })
        })
        compare(result.length, 152)
        return result
    }

    function descendants(root) {
        const result = []
        const pending = [root]
        while (pending.length > 0) {
            const item = pending.pop()
            result.push(item)
            const children = item.children || []
            for (let index = 0; index < children.length; ++index)
                pending.push(children[index])
        }
        return result
    }

    function test_componentCoverage(data) {
        const definition = Qt.createComponent("../../example/qml/component/" + data.entry.source)
        tryCompare(definition, "status", Component.Ready)
        const page = createTemporaryObject(definition, testCase, {
            width: width,
            height: height,
            selectedComponent: data.entry.index
        })
        verify(page !== null)
        verify(waitForItemPolished(page))
        tryVerify(function() { return page.exampleCount >= 5 })
        GalleryUtils.loadExamples(testCase, page)
        const all = descendants(page)
        const added = all.filter(function(item) {
            return item.objectName.indexOf("showcase" + data.entry.index) === 0
                && item.code !== undefined
        })
        verify(added.length >= 2)
        for (const item of all) {
            if (item.componentName !== undefined && item.loadedCard !== undefined
                && item.objectName !== "galleryApiLoader")
                compare(item.loadedCard !== null, item.componentName === data.entry.index)
        }
        for (const scenario of added) {
            verify(scenario.visible)
            verify(scenario.implicitHeight >= 96)
            const source = Qt.createQmlObject(scenario.code, sourceHost, scenario.objectName)
            verify(source !== null)
            if (source.ready !== undefined && data.entry.index === "EECharts" && source.supported)
                tryCompare(source, "ready", true, 15000)
            source.destroy()
            wait(0)
        }
        definition.destroy()
    }

    height: 820
    width: 1040
    visible: true
    when: windowShown
    name: "EUIGalleryShowcase"

    Item {
        id: sourceHost

        width: 640
        height: 480
    }
}

import EUI 1.0
import "GalleryTestUtils.js" as GalleryUtils
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function test_examples_data() {
        return ["EApp", "EBorderBeam", "EFlex", "EFlexItem", "EFloatButton", "EFloatButtonGroup", "EList", "EListItem", "EListy"].map(function(name) {
            return {
                "tag": name,
                "componentName": name
            }
        })
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

    function test_examples(data) {
        const entry = exampleCatalog.find(data.componentName)
        verify(entry !== null)
        const definition = Qt.createComponent("../../example/qml/component/" + entry.source)
        tryCompare(definition, "status", Component.Ready)
        const page = createTemporaryObject(definition, testCase, {
            "width": 1040,
            "height": 720,
            "selectedComponent": data.componentName
        })
        verify(page !== null, definition.errorString())
        tryVerify(function() { return page.exampleCount >= 5 })
        GalleryUtils.loadExamples(testCase, page)
        const cases = descendants(page).filter(function(item) {
            return item.objectName.indexOf("showcase" + data.componentName) === 0 && item.code !== undefined
        })
        verify(cases.length >= 5)
        for (const scenario of cases) {
            verify(scenario.title.length > 0)
            const sample = Qt.createQmlObject(scenario.code, sourceHost, scenario.objectName)
            verify(sample !== null)
            if (typeof sample.forceLayout === "function")
                sample.forceLayout()
            verify(waitForItemPolished(sample))
            wait(20)
            sample.destroy()
            wait(0)
        }
        ELocale.language = "zh"
        const firstTitle = cases[0].title
        ELocale.language = "en"
        tryVerify(function() {
            return cases[0].title !== firstTitle
        })
        definition.destroy()
    }

    height: 720
    width: 1040
    visible: true
    when: windowShown
    name: "AntDesignGallery"

    Item {
        id: sourceHost

        width: 560
        height: 400
    }
}

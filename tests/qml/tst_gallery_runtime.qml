import EUI 1.0
import "GalleryTestUtils.js" as GalleryUtils
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    property var performanceWindow: null

    function cleanup() {
        tryVerify(function() { return galleryTest.incubatingObjectCount(testCase) === 0 })
    }

    function test_closeWhileLoading_data() {
        return [{tag: "startup", component: ""}, {tag: "navigation", component: "EAvatar"}, {tag: "table", component: "ETable"}]
    }

    function cleanupTestCase() {
        if (performanceWindow) {
            performanceWindow.close()
            performanceWindow.destroy()
            performanceWindow = null
            wait(0)
            wait(0)
        }
        tryVerify(function() { return galleryTest.incubatingObjectCount(testCase) === 0 })
    }

    function test_allComponentsOpenWithinOneSecond_data() {
        const result = []
        for (const group of exampleCatalog.groups) {
            for (const entry of group.children)
                result.push({tag: entry.index, entry: entry})
        }
        compare(result.length, exampleCatalog.groups.reduce(function(count, group) { return count + group.children.length }, 0))
        return result
    }

    function test_avatarFallback() {
        const definition = Qt.createComponent("../../example/qml/component/DataExamples.qml")
        compare(definition.status, Component.Ready, definition.errorString())
        const page = createTemporaryObject(definition, testCase, {selectedComponent: "EAvatar", width: 1040, height: 820})
        verify(page !== null)
        GalleryUtils.loadExamples(testCase, page)
        const fallback = findChild(page, "showcaseEAvatar2")
        verify(fallback !== null)
        const avatar = Qt.createQmlObject(fallback.code, testCase)
        verify(avatar !== null)
        compare(avatar.source.toString(), "")
        compare(avatar.text, "UI")
        compare(avatar.loaded, false)
        avatar.destroy()
        definition.destroy()
    }

    function test_closeWhileLoading(data) {
        const definition = Qt.createComponent("../../example/qml/component/App.qml")
        compare(definition.status, Component.Ready, definition.errorString())
        const window = createTemporaryObject(definition, null)
        verify(window !== null)
        if (data.component)
            window.showComponent(exampleCatalog.find(data.component))
        const loader = findChild(window, "galleryLoader")
        verify(loader !== null)
        compare(loader.active, true)
        compare(loader.status, window.asynchronousLoading ? Loader.Loading : Loader.Ready)
        compare(loader.asynchronous, window.asynchronousLoading)
        if (window.asynchronousLoading && loader.item)
            compare(loader.item.previewsReady, false)
        window.close()
        compare(loader.active, false)
        compare(loader.status, Loader.Null)
        compare(loader.item, null)
        window.destroy()
        wait(0)
        definition.destroy()
    }

    function test_allComponentsOpenWithinOneSecond(data) {
        if (!performanceWindow) {
            const definition = Qt.createComponent("../../example/qml/component/App.qml")
            compare(definition.status, Component.Ready, definition.errorString())
            performanceWindow = definition.createObject(null)
            verify(performanceWindow !== null)
            tryCompare(findChild(performanceWindow, "galleryLoader"), "status", Loader.Ready)
            definition.destroy()
        }
        const window = performanceWindow
        const loader = findChild(window, "galleryLoader")
        tryCompare(loader, "status", Loader.Ready)
        const started = Date.now()
        window.showComponent(data.entry)
        tryCompare(loader, "status", Loader.Ready)
        tryVerify(function() {
            const pending = [loader.item]
            while (pending.length > 0) {
                const item = pending.pop()
                const children = item.children || []
                for (let index = 0; index < children.length; ++index) {
                    const child = children[index]
                    if (item.objectName === "galleryPreviewContent" && child.visible
                        && child.height > 0 && child.loadedCard === undefined)
                        return true
                    pending.push(child)
                }
            }
            return false
        })
        window.update()
        verify(waitForRendering(loader.item))
        const elapsed = Date.now() - started
        console.log("OPEN", data.entry.index, elapsed)
        verify(elapsed < 1000, data.entry.index + " took " + elapsed + " ms")
    }

    function test_tableNavigationAndViewportLoading() {
        const definition = Qt.createComponent("../../example/qml/component/App.qml")
        compare(definition.status, Component.Ready, definition.errorString())
        const window = createTemporaryObject(definition, null, {
            currentComponent: "EAvatar", currentSource: "DataExamples.qml"
        })
        verify(window !== null)
        const loader = findChild(window, "galleryLoader")
        tryCompare(loader, "status", Loader.Ready, 20000)
        window.showComponent(exampleCatalog.find("ETable"))
        compare(loader.status, window.asynchronousLoading ? Loader.Loading : Loader.Ready)
        tryCompare(loader, "status", Loader.Ready, 20000)
        compare(loader.item.selectedComponent, "ETable")
        verify(waitForItemPolished(loader.item))
        tryVerify(function() { return findChild(loader.item, "advancedSectionVirtual") !== null })
        compare(findChild(loader.item, "advancedVirtualTable"), null)
        const virtualSection = findChild(loader.item, "advancedSectionVirtual")
        loader.item.contentY = virtualSection.mapToItem(loader.item.contentItem, 0, 0).y - 16
        tryVerify(function() { return findChild(loader.item, "advancedVirtualTable") !== null })
        const table = findChild(loader.item, "advancedVirtualTable")
        verify(table !== null)
        compare(table.rowCount, 10000)
        verify(table.renderColumnIndexes.length < 20)
        verify(table.selectRow(9999))
        compare(table.currentRow.id, 10000)
        const page = loader.item
        page.contentY = 100
        window.showComponent(exampleCatalog.find("ETable"))
        compare(loader.status, Loader.Ready)
        compare(loader.item, page)
        compare(page.contentY, 0)
        window.showComponent(exampleCatalog.find("EAvatar"))
        compare(loader.status, window.asynchronousLoading ? Loader.Loading : Loader.Ready)
        tryCompare(loader, "status", Loader.Ready, 20000)
        compare(loader.item.selectedComponent, "EAvatar")
        window.close()
        compare(loader.status, Loader.Null)
        window.destroy()
        wait(0)
        definition.destroy()
    }

    height: 820
    width: 1040
    when: windowShown
    name: "EUIGalleryRuntime"
}

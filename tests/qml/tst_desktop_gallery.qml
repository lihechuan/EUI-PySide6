import EUI 1.0
import "GalleryTestUtils.js" as GalleryUtils
import "../../example/qml/component" as Gallery
import "../../example/qml/component/PrimeSamples.js" as Samples
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function cleanup() {
        ETheme.setDark(false)
        ELocale.language = "zh"
    }

    function test_localizedNavigationBadge_data() {
        return [{tag: "zh", language: "zh"}, {tag: "en", language: "en"}]
    }

    function test_newComponents_data() {
        const entries = []
        exampleCatalog.groups.forEach(function(group) {
            group.children.forEach(function(entry) {
                if (entry.introducedIn === "1.3.0")
                    entries.push({tag: entry.index, name: entry.index})
            })
        })
        compare(entries.length, 26)
        return entries
    }

    function test_overviewNewComponents() {
        const overview = createTemporaryObject(overviewComponent, testCase, {width: 960, height: 720})
        const expected = []
        exampleCatalog.groups.forEach(function(group) {
            group.children.forEach(function(entry) {
                const isNew = entry.introducedIn === exampleUpdater.currentVersion
                compare(entry.isNew, isNew, entry.index)
                if (isNew)
                    expected.push(entry.index)
            })
        })
        compare(overview.newComponents.map(function(entry) { return entry.index }).sort(), expected.sort())
        for (const name of ["EFilePicker", "EFolderPicker", "EToolBar", "ECodeView", "ECommandPalette", "EWizard"]) {
            compare(exampleCatalog.find(name).introducedIn, "1.2.0")
            compare(exampleCatalog.find(name).isNew, exampleUpdater.currentVersion === "1.2.0")
        }
        compare(findChild(overview, "galleryNewComponents").visible, expected.length > 0)
    }

    function test_localizedNavigationBadge(data) {
        ELocale.language = data.language
        const app = createTemporaryObject(appComponent, null)
        verify(app !== null)
        app.showComponent(exampleCatalog.find("ECompare"))
        verify(waitForItemPolished(app.contentItem))
        const pending = [app.contentItem]
        let badge = null
        while (pending.length > 0) {
            const item = pending.pop()
            if (item.objectName === "galleryNavEntry" && item.entry.index === "ECompare")
                badge = findChild(item, "galleryNavNewBadge")
            const children = item.children || []
            for (let index = 0; index < children.length; ++index)
                pending.push(children[index])
        }
        verify(badge !== null)
        compare(badge.visible, exampleUpdater.currentVersion === "1.3.0")
        compare(badge.text, data.language === "zh" ? "新增" : "New")
        const loader = findChild(app.contentItem, "galleryLoader")
        tryVerify(function() { return loader.item !== null && loader.item.selectedComponent === "ECompare" })
        let captured = false
        verify(loader.item.grabToImage(function(image) {
            captured = image !== null
        }))
        tryVerify(function() { return captured })
        app.close()
    }

    function test_newComponents(data) {
        const entry = exampleCatalog.find(data.name)
        compare(entry.introducedIn, "1.3.0")
        compare(entry.isNew, exampleUpdater.currentVersion === "1.3.0")
        compare(entry.demo, false)
        const definition = Qt.createComponent("../../example/qml/component/" + entry.source)
        tryCompare(definition, "status", Component.Ready)
        const page = createTemporaryObject(definition, testCase,
            {width: 960, height: 760, selectedComponent: data.name})
        verify(waitForItemPolished(page))
        GalleryUtils.loadExamples(testCase, page)
        const expectedCount = Samples.definitions[data.name].cases.length
        verify(expectedCount >= 5)
        tryCompare(page, "exampleCount", expectedCount)
        const badge = findChild(page, "galleryDetailNewBadge")
        verify(badge !== null)
        compare(badge.visible, exampleUpdater.currentVersion === "1.3.0")
        verify(badge.text.indexOf("1.3.0") >= 0)
        for (let index = 0; index < expectedCount; ++index) {
            const scenario = findChild(page, "showcase" + data.name + index)
            verify(scenario !== null)
            const object = createTemporaryQmlObject(scenario.code, sourceHost, scenario.objectName)
            verify(object !== null)
        }
        compare(exampleCatalog.find("EButton").isNew, false)
        compare(exampleCatalog.find("EAnimation").isNew, false)
        definition.destroy()
    }

    height: 820
    width: 1040
    visible: true
    when: windowShown
    name: "DesktopGallery"

    Item {
        id: sourceHost

        width: 640
        height: 480
    }
    Component {
        id: overviewComponent

        Gallery.Overview {}
    }
    Component {
        id: appComponent

        Gallery.App {}
    }
}

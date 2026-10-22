import "../../example/qml/component" as Gallery
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Window 2.15

TestCase {
    id: testCase

    function test_resize_data() {
        return [{tag: "overview", component: ""}, {tag: "text", component: "EText"},
            {tag: "float-buttons", component: "EFloatButtonGroup"}]
    }

    function test_resize(data) {
        const window = createTemporaryObject(windowComponent, null)
        verify(window !== null)
        if (data.component)
            window.showComponent(exampleCatalog.find(data.component))
        const loader = findChild(window, "galleryLoader")
        tryCompare(loader, "status", Loader.Ready)
        const page = loader.item
        const overview = data.component.length === 0
        const margin = overview ? 24 : 28
        const panelName = overview ? "galleryOverviewHero" : "galleryExamplePanel"
        tryVerify(function() { return findChild(page, panelName) !== null })
        const panel = findChild(page, panelName)
        const column = overview ? panel.parent : findChild(page, "galleryPageColumn")
        const api = findChild(page, "galleryApiLoader")
        const categories = findChild(page, "galleryCategoryGrid")
        verify(column !== null && (overview ? categories !== null : api !== null))
        for (const width of [1280, 1920, 1280, 820]) {
            window.width = width
            tryCompare(page, "width", width - window.navigationWidth)
            tryCompare(column, "width", page.width - margin * 2)
            compare(column.x, margin)
            compare(panel.width, column.width)
            compare((overview ? categories : api).width, column.width)
            if (api)
                compare(api.x, column.x)
            compare(page.contentWidth, page.width)
        }
        for (const expanded of [false, true]) {
            window.navigationExpanded = expanded
            tryCompare(page, "width", window.width - window.navigationWidth)
            tryCompare(column, "width", page.width - margin * 2)
            compare(panel.width, column.width)
            compare((overview ? categories : api).width, column.width)
        }
        window.width = 1280
        const maximize = findChild(window, "eAppBarMaximizeButton")
        verify(maximize !== null)
        mouseClick(maximize)
        tryCompare(window, "visibility", Qt.platform.os === "osx" ? Window.FullScreen : Window.Maximized)
        tryCompare(page, "width", window.width - window.navigationWidth)
        tryCompare(column, "width", page.width - margin * 2)
        compare(panel.width, column.width)
        compare((overview ? categories : api).width, column.width)
        mouseClick(maximize)
        tryCompare(window, "visibility", Window.Windowed)
        tryCompare(window, "width", 1280)
        tryCompare(column, "width", page.width - margin * 2)
        window.close()
    }

    width: 1920
    height: 1040
    when: windowShown
    name: "EUIGalleryResize"

    Component {
        id: windowComponent

        Gallery.App { }
    }
}

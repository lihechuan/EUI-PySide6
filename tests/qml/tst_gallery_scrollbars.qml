import EUI 1.0
import "GalleryTestUtils.js" as GalleryUtils
import "../../example/qml/component" as Gallery
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Controls 2.15

TestCase {
    id: testCase

    function test_nestedRegions_data() {
        return [{tag: "source", kind: "source"}, {tag: "icons", kind: "icons"}, {tag: "api", kind: "api"}]
    }

    function test_galleryNavigationAndLongPage() {
        const window = createTemporaryObject(windowComponent, null)
        verify(window !== null)
        const loader = findChild(window, "galleryLoader")
        tryCompare(loader, "status", Loader.Ready)
        dragHandle(loader.item, false)
        window.showComponent(exampleCatalog.find("EECharts"))
        tryCompare(loader, "status", Loader.Ready)
        GalleryUtils.loadExamples(testCase, loader.item)
        verify(loader.item.contentHeight > loader.item.height * 10)
        dragHandle(loader.item, false)
        const navigation = findChild(window, "galleryNavigation")
        tryVerify(function() { return navigation.contentHeight > navigation.height })
        navigation.contentY = 0
        dragHandle(navigation, false)
        window.close()
    }

    function dragHandle(view, horizontal) {
        const bar = horizontal ? view.ScrollBar.horizontal : view.ScrollBar.vertical
        verify(bar.visible)
        verify((horizontal ? bar.height : bar.width) >= 16)
        const thumb = bar.contentItem
        verify((horizontal ? thumb.width : thumb.height) >= 36)
        verify(thumb.opacity > 0)
        const start = bar.mapToItem(view, horizontal ? thumb.x + thumb.width / 2 : 1,
            horizontal ? 1 : thumb.y + thumb.height / 2)
        mousePress(view, start.x, start.y)
        compare(bar.pressed, true)
        const initial = horizontal ? view.contentX : view.contentY
        mouseMove(view, start.x + (horizontal ? 70 : 0), start.y + (horizontal ? 0 : 70), 30)
        mouseRelease(view, start.x + (horizontal ? 70 : 0), start.y + (horizontal ? 0 : 70))
        compare(bar.pressed, false)
        verify((horizontal ? view.contentX : view.contentY) > initial)
    }

    function test_nestedRegions(data) {
        let view = null
        if (data.kind === "source") {
            const panel = createTemporaryObject(sourceComponent, testCase)
            const lines = []
            for (let index = 0; index < 50; ++index)
                lines.push('    text: "' + "long source ".repeat(30) + '"')
            panel.code = "EText {\n" + lines.join("\n") + "\n}"
            panel.expanded = true
            view = findChild(panel, "gallerySourceViewport")
            tryVerify(function() { return view.contentHeight > view.height && view.contentWidth > view.width })
            dragHandle(view, false)
            dragHandle(view, true)
            compare(findChild(panel, "gallerySourceText").selectedText, "")
        } else if (data.kind === "icons") {
            const browser = createTemporaryObject(iconComponent, testCase)
            view = findChild(browser, "galleryIconGrid")
            verify(waitForItemPolished(view))
            dragHandle(view, false)
        } else {
            const api = createTemporaryObject(apiComponent, testCase)
            view = findChild(api, "galleryApiTableViewport")
            verify(waitForItemPolished(view))
            verify(view.contentWidth > view.width)
            dragHandle(view, true)
        }
    }

    height: 820
    width: 1040
    visible: true
    when: windowShown
    name: "EUIGalleryScrollbars"

    Component {
        id: apiComponent

        Gallery.ExampleApi {
            width: 540
            componentName: "EIcon"
        }
    }
    Component {
        id: iconComponent

        Gallery.IconGallery {
            width: 700
            height: implicitHeight
        }
    }
    Component {
        id: sourceComponent

        Gallery.CodeExpander {
            width: 700
            height: implicitHeight
        }
    }
    Component {
        id: windowComponent

        Gallery.App {
            height: 600
        }
    }
}

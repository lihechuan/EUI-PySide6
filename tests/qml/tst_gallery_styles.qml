import EUI 1.0
import "GalleryTestUtils.js" as GalleryUtils
import "../../example/qml/component" as Gallery
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function cleanup() {
        ETheme.setDark(false)
        ELocale.language = "zh"
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

    function test_resize_data() {
        const rows = []
        for (const dark of [false, true]) {
            for (const component of ["", "EAnimation", "EIcon", "EInput", "EForm", "ETable", "EFlex"])
                rows.push({tag: (dark ? "dark-" : "light-") + (component || "overview"), dark, component})
        }
        return rows
    }

    function test_pages_data() {
        const rows = []
        for (const dark of [false, true]) {
            for (const pageWidth of [1040, 640]) {
                for (const group of exampleCatalog.groups) {
                    for (const entry of group.children) {
                        if (!entry.demo)
                            rows.push({tag: (dark ? "dark" : "light") + "-" + pageWidth + "-" + entry.index,
                                dark: dark, pageWidth: pageWidth, entry: entry})
                    }
                }
            }
        }
        compare(rows.length, exampleCatalog.groups.reduce(function(count, group) {
            return count + group.children.filter(function(entry) { return !entry.demo }).length
        }, 0) * 4)
        return rows
    }

    function test_resize(data) {
        ETheme.setDark(data.dark)
        ELocale.language = data.dark ? "en" : "zh"
        const entry = exampleCatalog.find(data.component)
        const definition = Qt.createComponent("../../example/qml/component/" + (entry ? entry.source : "Overview.qml"))
        tryCompare(definition, "status", Component.Ready)
        const frame = createTemporaryObject(frameComponent, testCase, {width: 1040})
        const properties = {width: frame.width, height: frame.height}
        if (entry)
            properties.selectedComponent = entry.index
        const page = createTemporaryObject(definition, frame, properties)
        verify(page !== null, definition.errorString())
        if (entry)
            GalleryUtils.loadExamples(testCase, page)
        const content = entry ? findChild(page, "galleryPageColumn") : findChild(page, "galleryOverviewHero").parent
        verify(content !== null)
        for (const pageWidth of [640, 1040, 1920, 2560, 1040, 640]) {
            frame.width = pageWidth
            page.width = pageWidth
            verify(waitForItemPolished(page))
            compare(content.x, entry ? 28 : 24)
            compare(content.width, pageWidth - (entry ? 56 : 48))
            if (entry) {
                const api = findChild(page, "galleryApiLoader")
                compare(api.x, content.x)
                compare(api.width, content.width)
                const panels = descendants(page).filter(function(item) {
                    return item.objectName === "galleryExamplePanel" && item.visible
                })
                verify(panels.length >= 5)
                for (const panel of panels)
                    compare(panel.width, content.width)
            } else {
                compare(findChild(page, "galleryOverviewHero").width, content.width)
                compare(findChild(page, "galleryCategoryGrid").width, content.width)
            }
        }
        page.destroy()
        frame.destroy()
        wait(0)
        definition.destroy()
        wait(0)
    }

    function test_pages(data) {
        ETheme.setDark(data.dark)
        ELocale.language = data.dark ? "en" : "zh"
        const frame = createTemporaryObject(frameComponent, testCase, {width: data.pageWidth})
        const definition = Qt.createComponent("../../example/qml/component/" + data.entry.source)
        tryCompare(definition, "status", Component.Ready)
        const page = createTemporaryObject(definition, frame, {
            width: data.pageWidth, height: frame.height, selectedComponent: data.entry.index
        })
        verify(page !== null, definition.errorString())
        GalleryUtils.loadExamples(testCase, page)
        verify(page.exampleCount >= 5)
        const previews = descendants(page).filter(function(item) {
            return item.objectName === "galleryPreviewContent" && item.visible
        })
        verify(previews.length >= 5)
        for (const preview of previews) {
            for (let index = 0; index < preview.children.length; ++index) {
                const child = preview.children[index]
                if (!child.visible || child.height <= 0)
                    continue
                verify(isFinite(child.width) && isFinite(child.height))
                verify(child.x >= -1 && child.x + child.width <= preview.width + 1,
                    data.entry.index + " preview overflows at width " + data.pageWidth)
            }
        }
        if (data.entry.index === "EPagination") {
            const example = findChild(page, "showcaseEPagination0")
            const pagination = findChild(example, "galleryPreviewContent").children[0]
            const left = findChild(pagination, "paginationLeft")
            verify(left !== null)
            verify(left.width <= pagination.availableWidth + 1)
        }
        page.contentY = 0
        verify(waitForItemPolished(frame))
        let rendered = false
        verify(frame.grabToImage(function(result) { rendered = result.url.toString().length > 0 }))
        tryVerify(function() { return rendered })
        page.destroy()
        frame.destroy()
        wait(0)
        definition.destroy()
        wait(0)
    }

    height: 820
    width: 1040
    visible: true
    when: windowShown
    name: "GalleryStyles"

    Component {
        id: frameComponent

        Rectangle {
            height: 820
            color: Gallery.GalleryStyle.canvas
        }
    }
}

import EUI 1.0
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Window 2.15

TestCase {
    id: testCase

    function cleanup() {
        ETheme.setDark(false)
    }

    function test_switchThemesAndInteraction_data() {
        return [{ tag: "light", dark: false }, { tag: "dark", dark: true }]
    }

    function test_popupArrowsFollowTheme_data() {
        return [{ tag: "popover", dropdown: false }, { tag: "dropdown", dropdown: true }]
    }

    function test_switchSizesAndLabels_data() {
        return [{ tag: "small", size: EStyle.Small, height: 16 },
            { tag: "medium", size: EStyle.Medium, height: 20 },
            { tag: "large", size: EStyle.Large, height: 24 }]
    }

    function namedItems(item, name) {
        let items = item.objectName === name ? [item] : []
        for (let index = 0; index < item.children.length; ++index)
            items = items.concat(namedItems(item.children[index], name))
        return items
    }

    function findCanvas(item) {
        if (typeof item.getContext === "function")
            return item
        for (let index = 0; index < item.children.length; ++index) {
            const canvas = findCanvas(item.children[index])
            if (canvas)
                return canvas
        }
        return null
    }

    function test_drawerFooterStaysInsideContent_data() {
        return [{ tag: "side-header", edge: Qt.RightEdge, header: true },
            { tag: "top-header", edge: Qt.TopEdge, header: true },
            { tag: "bottom-no-header", edge: Qt.BottomEdge, header: false },
            { tag: "side-header-implicit", edge: Qt.RightEdge, header: true, implicit: true }]
    }

    function test_galleryExamples_data() {
        return [{ tag: "linear", name: "EProgress", object: "galleryLinearProgress", values: [0.25, 0.5, 0.76] },
            { tag: "circle", name: "ECircleProgress", object: "galleryCircleProgress", values: [0.35, 0.68, 0.72] },
            { tag: "loading", name: "ELoading", object: "galleryLoadingCase", values: [] }]
    }

    function test_switchTrackOnlyCustomization() {
        const item = createTemporaryObject(switchComponent, testCase, { width: 76, height: 30 })
        const thumb = findChild(item, "switchThumb")
        compare(item.indicator.width, 76)
        compare(item.indicator.height, 30)
        compare(thumb.width, 26)
        compare(thumb.x, 2)
        item.checked = true
        tryCompare(thumb, "x", 48)
    }

    function test_linearProgressBounds_data() {
        return [{ tag: "empty", value: 0, fraction: 0 },
            { tag: "quarter", value: 0.25, fraction: 0.25 },
            { tag: "complete", value: 1, fraction: 1 },
            { tag: "negative", value: -1, fraction: 0 },
            { tag: "overflow", value: 2, fraction: 1 },
            { tag: "invalid", value: NaN, fraction: 0 },
            { tag: "infinite", value: Infinity, fraction: 0 }]
    }

    function test_linearProgressBounds(data) {
        const item = createTemporaryObject(progressComponent, testCase, { value: data.value })
        const track = findChild(item, "progressTrack")
        const fill = findChild(item, "progressFill")
        verify(item.height > 0)
        compare(track.height, item.height)
        tryCompare(fill, "width", item.width * data.fraction)
        item.width = 320
        tryCompare(fill, "width", 320 * data.fraction)
        item.height = 4
        compare(track.height, 4)
    }

    function test_loadingDefaultOverlayFollowsTheme() {
        const item = createTemporaryObject(loadingComponent, testCase)
        const custom = createTemporaryObject(loadingComponent, testCase,
            {backgroundColor: Qt.rgba(0.2, 0.3, 0.4, 0.6)})
        for (let dark = 0; dark < 2; ++dark) {
            ETheme.setDark(Boolean(dark))
            const themeColor = EPaletteManager.ThemePalette.fetchThemeColor(Boolean(dark))
            compare(item.backgroundColor, Qt.rgba(themeColor.r, themeColor.g, themeColor.b, 0.8))
            compare(custom.backgroundColor, Qt.rgba(0.2, 0.3, 0.4, 0.6))
        }
    }

    function test_switchThemesAndInteraction(data) {
        ETheme.setDark(data.dark)
        const item = createTemporaryObject(switchComponent, testCase, { text: "Automatic updates" })
        const label = item.contentItem
        const thumb = findChild(item, "switchThumb")
        compare(label.color, EPaletteManager.ThemePalette.textRegular(data.dark))
        mouseClick(item, item.indicator.x + 10, item.height / 2)
        compare(item.checked, true)
        tryCompare(thumb, "x", item.indicator.width - thumb.width - 2)
        item.enabled = false
        compare(label.color, EPaletteManager.ThemePalette.textDisabled(data.dark))
        mouseClick(item, item.indicator.x + 10, item.height / 2)
        compare(item.checked, true)
        item.enabled = true
        mouseClick(item, item.indicator.x + 10, item.height / 2)
        compare(item.checked, false)
        tryCompare(thumb, "x", 2)
    }

    function test_switchSizesAndLabels(data) {
        const item = createTemporaryObject(switchComponent, testCase, { size: data.size })
        compare(item.implicitWidth, data.height * 2)
        compare(item.implicitHeight, data.height)
        item.text = "Automatic updates"
        const label = item.contentItem
        compare(item.indicator.width, data.height * 2)
        compare(item.indicator.height, data.height)
        verify(item.implicitHeight >= data.height)
        verify(label.width >= label.implicitWidth)
        compare(label.leftPadding, item.indicator.width + item.spacing)
        compare(label.font.pixelSize, EDefaultConfig.controlFontPixelSize(data.size))
        item.mirror = true
        compare(item.indicator.x, item.width - item.indicator.width)
        compare(label.leftPadding, 0)
        compare(label.rightPadding, item.indicator.width + item.spacing)
        item.text = ""
        compare(item.implicitWidth, data.height * 2)
        compare(item.implicitHeight, data.height)
    }

    function test_galleryExamples(data) {
        const component = Qt.createComponent("../../example/qml/component/FeedbackExamples.qml")
        compare(component.status, Component.Ready, component.errorString())
        const page = createTemporaryObject(component, testCase,
            { width: 588, height: 620, selectedComponent: data.name })
        tryVerify(function() {
            return namedItems(page, data.object).length === 3
        })
        const items = namedItems(page, data.object)
        for (let index = 0; index < items.length; ++index) {
            verify(items[index].height > 0)
            if (data.values.length > 0)
                compare(items[index].value, data.values[index])
        }
        if (data.name === "ELoading") {
            page.width = 390
            verify(waitForItemPolished(findChild(page, "galleryLoadingGrid")))
            const grid = findChild(page, "galleryLoadingGrid")
            for (const item of items)
                verify(item.x + item.width <= grid.width + 1)
            verify(items[2].y > items[0].y)
            compare(namedItems(page, "galleryLoadingLabel").length, 3)
        }
    }

    function test_popupArrowsFollowTheme(data) {
        const item = createTemporaryObject(data.dropdown ? dropdownComponent : popoverComponent, testCase)
        const popup = data.dropdown ? item.menu : item
        item.open()
        tryCompare(popup, "opened", true)
        const arrow = findCanvas(popup.background)
        verify(arrow)
        for (let dark = 0; dark < 2; ++dark) {
            ETheme.setDark(Boolean(dark))
            testCase.Window.window.update()
            tryVerify(function() {
                const root = testCase.Window.window.contentItem
                const image = grabImage(root)
                const point = arrow.mapToItem(root, arrow.width / 2, arrow.height * 2 / 3)
                const expected = popup.background.color
                const x = Math.floor(point.x * image.width / root.width)
                const y = Math.floor(point.y * image.height / root.height)
                return x >= 0 && x < image.width && y >= 0 && y < image.height
                    && Math.abs(image.red(x, y) - Math.round(expected.r * 255)) <= 1
                    && Math.abs(image.green(x, y) - Math.round(expected.g * 255)) <= 1
                    && Math.abs(image.blue(x, y) - Math.round(expected.b * 255)) <= 1
            })
        }
        item.close()
        tryCompare(popup, "visible", false)
    }

    function test_drawerFooterStaysInsideContent(data) {
        const component = data.implicit ? drawerImplicitFooterComponent : drawerFooterComponent
        const item = createTemporaryObject(drawerComponent, testCase,
            {edge: data.edge, showHeader: data.header, footerComponent: component})
        try {
            item.open()
            tryCompare(item, "opened", true)
            verify(waitForItemPolished(item.contentItem))
            const footer = findChild(item.contentItem, "drawerStyleFooter")
            const body = findChild(item.contentItem, "drawerStyleBody")
            verify(footer)
            verify(body)
            const footerPosition = footer.mapToItem(item.contentItem, 0, 0)
            const bodyPosition = body.mapToItem(item.contentItem, 0, 0)
            compare(footerPosition.y - bodyPosition.y - body.height, item.contentItem.spacing)
            compare(footerPosition.y + footer.height, item.availableHeight)
            const footerLoader = footer.parent
            const footerArea = footerLoader.parent
            item.footerComponent = null
            tryCompare(footerLoader, "item", null)
            tryCompare(footerArea, "height", 0)
            tryVerify(function() {
                const position = body.mapToItem(item.contentItem, 0, 0)
                return Math.abs(position.y + body.height - item.availableHeight) <= 1
            })
            item.footerComponent = component
            tryVerify(function() {
                return footerLoader.item !== null
            })
            tryCompare(footerArea, "height", 32)
            tryCompare(footerLoader.item, "height", 32)
            tryVerify(function() {
                const footer = footerLoader.item
                const position = footer.mapToItem(item.contentItem, 0, 0)
                const bodyPosition = body.mapToItem(item.contentItem, 0, 0)
                return Math.abs(position.y + footer.height - item.availableHeight) <= 1
                    && Math.abs(position.y - bodyPosition.y - body.height - item.contentItem.spacing) <= 1
            })
        } finally {
            item.close()
            tryCompare(item, "visible", false)
        }
    }

    width: 640
    height: 480
    visible: true
    when: windowShown
    name: "FeedbackAppearance"

    Component {
        id: progressComponent

        EProgress {
            x: 24
            y: 24
            width: 240
        }
    }
    Component {
        id: switchComponent

        ESwitch {
            property bool mirror: false

            x: 24
            y: 48
            duration: 0
            LayoutMirroring.enabled: mirror
        }
    }
    EButton {
        id: popupReference

        x: 24
        y: 160
        text: "Popover"
    }
    Component {
        id: drawerFooterComponent

        Rectangle {
            height: 32
            width: parent.width
            objectName: "drawerStyleFooter"
        }
    }
    Component {
        id: drawerImplicitFooterComponent

        Rectangle {
            implicitHeight: 32
            width: parent.width
            objectName: "drawerStyleFooter"
        }
    }
    Component {
        id: drawerComponent

        EDrawer {
            drawerSize: 260
            title: "Drawer title"
            footerComponent: drawerFooterComponent

            Rectangle {
                anchors.fill: parent
                objectName: "drawerStyleBody"
            }
        }
    }
    Component {
        id: popoverComponent

        EPopover {
            showArrow: true
            title: "Popover title"
            text: "Popover content"
            reference: popupReference
        }
    }
    Component {
        id: dropdownComponent

        EDropdown {
            x: 320
            y: 160
            showArrow: true
            text: "Dropdown"
            model: [{text: "First"}, {text: "Second"}]
        }
    }
    Component {
        id: loadingComponent

        ELoading {
            loading: false
        }
    }
}

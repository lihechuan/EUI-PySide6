import EUI 1.0
import "../../example/qml/component" as Gallery
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

TestCase {
    id: testCase

    property var browser: null

    function pasteClipboard() {
        pasteTarget.clear()
        pasteTarget.paste()
        return pasteTarget.text
    }

    function initTestCase() {
        if (Qt.platform.os === "osx")
            testCase.Window.window.flags |= Qt.WindowStaysOnTopHint
    }

    function cleanup() {
        if (browser) {
            browser.destroy()
            browser = null
        }
        pasteTarget.clear()
        ELocale.language = "en"
        ETheme.dark = false
    }

    function init() {
        ELocale.language = "en"
        ETheme.dark = false
        browser = createTemporaryObject(browserComponent, testCase)
        verify(browser !== null)
        waitForRendering(browser)
    }

    function test_clickCopiesExactNameAndQml_data() {
        return [
            {tag: "semantic", iconName: "CIRCLE_Info_FILL"},
            {tag: "long_name", iconName: "BARS_DESCENDING_ALIGN_LEFT_ARROW_DOWN"}
        ]
    }

    function imageHasColor(image, color) {
        for (let y = 0; y < image.height; ++y) {
            for (let x = 0; x < image.width; ++x) {
                if (Qt.colorEqual(image.pixel(x, y), color))
                    return true
            }
        }
        return false
    }

    function tilesIn(item) {
        let tiles = item.objectName === "galleryIconTile" ? [item] : []
        for (let index = 0; index < item.children.length; ++index)
            tiles = tiles.concat(tilesIn(item.children[index]))
        return tiles
    }

    function test_themeLocaleAndNarrowLayout_data() {
        const cases = []
        for (const width of [384, 760]) {
            for (const language of ["en", "zh"]) {
                for (const dark of [false, true])
                    cases.push({tag: language
                        + "_"
                        + dark
                        + "_"
                        + width, language: language, dark: dark, width: width})
            }
        }
        return cases
    }

    function test_resultUsesExistingSemanticIcons() {
        const result = createTemporaryObject(resultComponent, testCase)
        const cases = [
            {style: EStyle.Info, icon: EIcons.CIRCLE_Info},
            {style: EStyle.Success, icon: EIcons.CIRCLE_CHECK},
            {style: EStyle.Warning, icon: EIcons.TRIANGLE_EXCLAMATION},
            {style: EStyle.Danger, icon: EIcons.CIRCLE_XMARK}
        ]
        for (const data of cases) {
            result.styleType = data.style
            compare(result.iconSource, data.icon)
        }
    }

    function dotPixelMatches(icon, layered, unlayered, color) {
        const x = Math.floor((icon.width / 2 + icon.font.pixelSize * 0.28125) * layered.width / icon.width)
        const y = Math.floor((icon.baselineOffset - icon.font.pixelSize * 0.65625) * layered.height / icon.height)
        if (x < 0 || y < 0 || x >= layered.width || y >= layered.height)
            return false
        return Math.abs(layered.red(x, y) - Math.round(color.r * 255)) <= 8
            && Math.abs(layered.green(x, y) - Math.round(color.g * 255)) <= 8
            && Math.abs(layered.blue(x, y) - Math.round(color.b * 255)) <= 8
            && !Qt.colorEqual(layered.pixel(x, y), unlayered.pixel(x, y))
    }

    function test_textOverridePreservesTextApi() {
        browser.visible = false
        const icon = createTemporaryObject(iconComponent, testCase, {
            iconSource: EIcons.ABLETON_DARK, text: "X", color: "#d63384"
        })
        icon.font.family = "Times New Roman"
        icon.font.pixelSize = 32
        compare(icon.text, "X")
        compare(icon.font.pixelSize, 32)
        compare(icon.font.family, "Times New Roman")
        compare(icon.width, icon.implicitWidth)
        compare(icon.height, icon.implicitHeight)
        compare(findChild(icon, "eIconGraphic").visible, false)
        compare(findChild(icon, "eIconDotLayer").visible, false)
        verify(waitForRendering(icon))
        verify(imageHasColor(grabImage(icon), icon.color))
    }

    function test_lastIconIsAccessibleAndKeyboardCopies() {
        const grid = findChild(browser, "galleryIconGrid")
        const last = exampleData.icons[exampleData.icons.length - 1]
        grid.positionViewAtEnd()
        let tile = null
        tryVerify(function() {
            tile = tilesIn(browser).find(function(item) {
                return item.entry.name === last.name
            })
            return tile !== undefined
        })
        mouseClick(tile)
        compare(browser.selectedIcon.name, last.name)
        compare(pasteClipboard(), "EIcons." + last.name)
        grid.positionViewAtBeginning()
        grid.currentIndex = 1
        grid.forceActiveFocus()
        keyClick(Qt.Key_Return)
        compare(pasteClipboard(), "EIcons." + exampleData.icons[1].name)
        verify(tilesIn(browser).length < 100)
    }

    function test_completePublicEnum() {
        const icons = exampleData.icons
        compare(icons.length, 1044)
        const names = ({})
        const values = ({})
        for (const icon of icons) {
            verify(icon.name.length > 0)
            verify(!names[icon.name])
            verify(!values[icon.value])
            compare(EIcons[icon.name], icon.value)
            names[icon.name] = true
            values[icon.value] = true
        }
        const grid = findChild(browser, "galleryIconGrid")
        compare(grid.count, icons.length)
        for (const layout of [{width: 384, columns: 2}, {width: 760, columns: 5}, {width: 944, columns: 6}]) {
            browser.width = layout.width
            tryCompare(grid, "columnCount", layout.columns)
            verify(waitForItemPolished(grid))
            const tiles = tilesIn(browser)
            verify(tiles.length > 0 && tiles.length < 100)
            for (const tile of tiles)
                compare(tile.height, 88)
        }
    }

    function test_searchClearAndEmpty() {
        const search = findChild(browser, "galleryIconSearch")
        const grid = findChild(browser, "galleryIconGrid")
        search.text = "eicons.aRrOw right"
        verify(grid.count > 0 && grid.count < exampleData.icons.length)
        for (const icon of browser.filteredIcons)
            verify(icon.name.toLowerCase().indexOf("arrow_right") >= 0)
        search.text = "no_such_icon_123456"
        compare(grid.count, 0)
        const empty = findChild(browser, "galleryIconEmptyState")
        verify(empty !== null && empty.visible)
        verify(grid.height >= empty.implicitHeight)
        search.text = "  "
        compare(grid.count, exampleData.icons.length)
        search.text = "CIRCLE_Info_FILL"
        compare(grid.count, 1)
        compare(browser.filteredIcons[0].name, "CIRCLE_Info_FILL")
        compare(grid.height, grid.cellHeight)
        search.clear()
        compare(grid.count, exampleData.icons.length)
    }

    function test_brandAlignmentRespectsTextPadding() {
        browser.visible = false
        const icon = createTemporaryObject(iconComponent, testCase, {
            width: 148, height: 132, iconSize: 24, iconSource: EIcons.ABLETON_DARK,
            leftPadding: 7, rightPadding: 13, topPadding: 11, bottomPadding: 17
        })
        const graphic = findChild(icon, "eIconGraphic")
        tryCompare(graphic, "status", Image.Ready)
        const horizontal = [
            {alignment: Text.AlignLeft, position: 7},
            {alignment: Text.AlignHCenter, position: 59},
            {alignment: Text.AlignRight, position: 111}
        ]
        const vertical = [
            {alignment: Text.AlignTop, position: 11},
            {alignment: Text.AlignVCenter, position: 51},
            {alignment: Text.AlignBottom, position: 91}
        ]
        for (const x of horizontal) {
            icon.horizontalAlignment = x.alignment
            for (const y of vertical) {
                icon.verticalAlignment = y.alignment
                compare(graphic.x, x.position)
                compare(graphic.y, y.position)
                compare(graphic.width, 24)
                compare(graphic.height, 24)
            }
        }
    }

    function test_clickCopiesExactNameAndQml(data) {
        const search = findChild(browser, "galleryIconSearch")
        search.text = data.iconName
        const grid = findChild(browser, "galleryIconGrid")
        tryCompare(grid, "count", 1)
        tryVerify(function() {
            return tilesIn(browser).length === 1
        })
        const tile = tilesIn(browser)[0]
        mouseClick(tile)
        compare(pasteClipboard(), "EIcons." + data.iconName)
        verify(browser.feedback.indexOf("Copied") === 0)
        compare(findChild(browser, "galleryIconCopyMessage").count, 1)
        mouseClick(findChild(browser, "galleryIconCopyCode"))
        const code = pasteClipboard()
        compare(code, browser.exampleCode)
        verify(code.indexOf("iconSource: EIcons." + data.iconName) >= 0)
        const pasted = Qt.createQmlObject("import EUI 1.0\nimport QtQuick 2.15\n" + code, testCase)
        verify(pasted !== null)
        compare(pasted.iconSource, EIcons[data.iconName])
        compare(pasted.iconSize, 24)
        pasted.destroy()
        mouseClick(findChild(browser, "galleryIconCopyName"))
        compare(pasteClipboard(), browser.reference)
    }

    function test_completeIconRenderingRoutes() {
        browser.visible = false
        const icon = createTemporaryObject(iconComponent, testCase)
        const graphic = findChild(icon, "eIconGraphic")
        const dot = findChild(icon, "eIconDotLayer")
        let brands = 0
        let semanticLayers = 0
        let singleGlyphs = 0
        for (const entry of exampleData.icons) {
            icon.iconSource = entry.value
            const source = EDefaultConfig.iconGraphic(entry.value)
            if (source.length > 0) {
                ++brands
                compare(graphic.source.toString(), source)
                tryCompare(graphic, "status", Image.Ready)
                compare(graphic.visible, true)
                compare(icon.text, " ")
                compare(dot.visible, false)
                compare(graphic.width, icon.iconSize)
                compare(graphic.height, icon.iconSize)
            } else {
                compare(graphic.visible, false)
                compare(icon.text, String.fromCharCode(entry.value))
                if (dot.visible) {
                    ++semanticLayers
                    compare(dot.text, String.fromCharCode(entry.value + 1))
                } else {
                    ++singleGlyphs
                    compare(dot.text, "")
                }
            }
        }
        compare(brands, 368)
        compare(semanticLayers, 3)
        compare(singleGlyphs, 673)
    }

    function test_brandGraphicsKeepLayerColors() {
        browser.visible = false
        const icon = createTemporaryObject(iconComponent, testCase, {iconSize: 96, color: "#d63384"})
        const graphic = findChild(icon, "eIconGraphic")
        const cases = [
            {value: EIcons.ABLETON_DARK, colors: ["#242938", "#ffffff"]},
            {value: EIcons.APPLE_DARK, colors: ["#34be2d", "#f41e34", "#00a0e2"]},
            {value: EIcons.AWS_DARK, colors: ["#242938", "#ff9900", "#ffffff"]},
            {value: EIcons.BUN_LIGHT, colors: ["#fbf0df", "#000000", "#b71422"]},
            {value: EIcons.ANDROIDSTUDIO_LIGHT, colors: ["#4285f4", "#3ddc84", "#073042"]},
            {value: EIcons.ZIG_LIGHT, colors: ["#f4f2ed", "#f7a41d"]}
        ]
        for (const data of cases) {
            icon.iconSource = data.value
            tryCompare(graphic, "status", Image.Ready)
            verify(waitForRendering(icon))
            const before = grabImage(icon)
            verify(before.width > 0 && before.height > 0)
            for (const color of data.colors)
                verify(imageHasColor(before, color), "Missing SVG color " + color)
            icon.color = "#0055ff"
            verify(waitForRendering(icon))
            verify(before.equals(grabImage(icon)), "Brand artwork must retain its own colors")
            icon.color = "#d63384"
        }
        for (const size of [16, 32, 64]) {
            icon.iconSize = size
            verify(icon.width >= size)
            verify(icon.height >= size)
            compare(graphic.width, size)
            compare(graphic.height, size)
            verify(waitForRendering(icon))
            const image = grabImage(icon)
            verify(image.width > 0 && image.height > 0)
            verify(imageHasColor(image, "#f7a41d"))
        }
    }

    function test_semanticDotIconsKeepBothLayers() {
        browser.visible = false
        const icon = createTemporaryObject(iconComponent, testCase, {iconSize: 64, color: "#d63384"})
        const dot = findChild(icon, "eIconDotLayer")
        const cases = [
            {value: EIcons.BELL_DOT, base: EIcons.BELL},
            {value: EIcons.CIRCLE_QUESTION_DOT, base: EIcons.CIRCLE_QUESTION},
            {value: EIcons.GEAR_DOT, base: EIcons.GEAR}
        ]
        for (const data of cases) {
            icon.iconSource = data.value
            compare(dot.visible, true)
            compare(dot.text, String.fromCharCode(data.value + 1))
            compare(dot.font.family, icon.font.family)
            compare(dot.color, icon.color)
            for (const size of [16, 32, 64]) {
                icon.iconSize = size
                verify(icon.implicitWidth > 0)
                verify(icon.implicitHeight > 0)
                compare(dot.font.pixelSize, size)
                compare(dot.width, icon.width)
                compare(dot.height, icon.height)
                compare(dot.baselineOffset, icon.baselineOffset)
                icon.color = size === 32 ? "#0055ff" : "#d63384"
                compare(dot.color, icon.color)
                verify(waitForRendering(icon))
                const layered = grabImage(icon)
                dot.opacity = 0
                verify(waitForRendering(icon))
                const unlayered = grabImage(icon)
                verify(!layered.equals(unlayered), "The dot layer must add visible pixels at size " + size)
                verify(dotPixelMatches(icon, layered, unlayered, icon.color),
                    "The dot must retain its color and original glyph position at size " + size)
                dot.opacity = 1
                icon.iconSource = data.base
                compare(dot.visible, false)
                verify(waitForRendering(icon))
                verify(!layered.equals(grabImage(icon)), "Dot icons must differ from their base icons")
                icon.iconSource = data.value
            }
        }
    }

    function test_themeLocaleAndNarrowLayout(data) {
        browser.width = data.width
        ETheme.dark = data.dark
        ELocale.language = data.language
        const search = findChild(browser, "galleryIconSearch")
        const grid = findChild(browser, "galleryIconGrid")
        const names = [
            "BARS_DESCENDING_ALIGN_LEFT_ARROW_DOWN",
            "LAYOUT_HEADER_CELLS_LARGE_THUNDERBOLT"
        ]
        compare(findChild(browser, "galleryIconDescription").font.pixelSize, 14)
        compare(findChild(browser, "galleryIconResultCount").font.pixelSize, 13)
        for (const name of names) {
            search.text = name
            tryCompare(grid, "count", 1)
            tryVerify(function() {
                const tiles = tilesIn(browser)
                return tiles.length === 1 && tiles[0].entry.name === name
            })
            const tile = tilesIn(browser)[0]
            const label = findChild(tile, "galleryIconName")
            verify(waitForItemPolished(label))
            compare(label.font.pixelSize, 13)
            compare(label.font.family, pasteTarget.font.family)
            compare(label.font.bold, false)
            compare(label.text.replace(/\u200b/g, ""), name)
            const fullName = createTemporaryObject(nameMetricsComponent, testCase, {
                font: label.font, text: label.text, width: label.width, renderType: label.renderType,
                lineHeight: label.lineHeight, lineHeightMode: label.lineHeightMode
            })
            verify(fullName !== null)
            verify(waitForItemPolished(fullName))
            compare(label.maximumLineCount, 2)
            compare(label.elide, Text.ElideRight)
            verify(label.lineCount > 0 && label.lineCount <= 2)
            compare(label.lineCount, Math.min(2, fullName.lineCount))
            compare(tile.ToolTip.text, "EIcons." + name)
            compare(tile.height, 88)
            compare(tile.contentItem.children[0].iconSize, 24)
            mouseClick(tile)
            compare(findChild(browser, "galleryIconReference").text, "EIcons." + name)
            compare(pasteClipboard(), "EIcons." + name)
            const bounds = label.mapToItem(tile, 0, 0)
            verify(bounds.x >= 0 && bounds.x + label.width <= tile.width + 1)
            verify(bounds.y >= 0 && bounds.y + label.height <= tile.height + 1)
            verify(tile.width > 0 && tile.x + tile.width <= grid.width + 1)
        }
        mouseClick(findChild(browser, "galleryIconCopyName"))
        verify(browser.feedback.indexOf(data.language === "zh" ? "已复制" : "Copied") === 0)
        compare(findChild(browser, "galleryIconCopyFeedback").font.pixelSize, 13)
    }

    width: 1000
    height: 1000
    visible: true
    when: windowShown
    name: "EUIIconGallery"

    TextEdit {
        id: pasteTarget

        y: 940
        height: 40
        width: 800
    }
    Component {
        id: browserComponent

        Gallery.IconGallery {
            x: 12
            y: 12
            width: 760
        }
    }
    Component {
        id: iconComponent

        EIcon {
            y: 20
            x: 790
            iconSize: 64
        }
    }
    Component {
        id: resultComponent

        EResult {}
    }
    Component {
        id: nameMetricsComponent

        Text {
            visible: false
            wrapMode: Text.WordWrap
        }
    }
}

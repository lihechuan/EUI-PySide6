import EUI 1.0
import "GalleryTestUtils.js" as GalleryUtils
import "../../example/qml/component" as Gallery
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Window 2.15

TestCase {
    id: testCase

    function cleanupTestCase() {
        tryVerify(function() { return galleryTest.incubatingObjectCount(testCase) === 0 })
    }

    function itemsNamed(item, name) {
        let items = item.objectName === name ? [item] : []
        const children = item.children || []
        for (let index = 0; index < children.length; ++index)
            items = items.concat(itemsNamed(children[index], name))
        return items
    }

    function sourceToolbarCount(item) {
        let count = item.objectName === "galleryCodeExpander" && item.code.length > 0 ? 1 : 0
        for (let index = 0; index < item.children.length; ++index)
            count += sourceToolbarCount(item.children[index])
        return count
    }

    function test_showcaseHeaderAndLayout_data() {
        return [
            { tag: "icon-wide", name: "EIcon", width: 1280 },
            { tag: "icon-narrow", name: "EIcon", width: 820 },
            { tag: "text-wide", name: "EText", width: 1280 },
            { tag: "text-narrow", name: "EText", width: 820 }
        ]
    }

    function test_overviewCategoryLayout_data() {
        const cases = []
        for (const width of [1280, 820]) {
            for (const language of ["zh", "en"]) {
                for (const dark of [false, true])
                    cases.push({tag: width
                        + "-"
                        + language
                        + "-"
                        + (dark ? "dark" : "light"), width, language, dark})
            }
        }
        return cases
    }

    function test_languageSwitch() {
        ELocale.language = "en"
        compare(ELocale.texts.BasicUsage, "Basic usage")
        compare(exampleCatalog.find("ETable").label, "Table")
        ELocale.language = "zh"
        compare(ELocale.texts.BasicUsage, "基础用法")
        compare(exampleCatalog.find("ETable").label, "表格")
        ELocale.language = "en"
    }

    function revealControl(page, item) {
        page.Window.window.update()
        verify(waitForRendering(page))
        const top = item.mapToItem(page.contentItem, 0, 0).y
        page.contentY = Math.max(0, Math.min(page.contentHeight - page.height, top - page.height / 2))
        page.Window.window.update()
        verify(waitForRendering(page))
    }

    function visibleSource(item) {
        if (item.objectName === "galleryCodeExpander" && item.visible && item.code.length > 0)
            return item
        const children = item.children || []
        for (let index = 0; index < children.length; ++index) {
            const found = visibleSource(children[index])
            if (found)
                return found
        }
        return null
    }

    function sectionsIn(item) {
        let sections = []
        if (item.componentName !== undefined && item.loadedCard !== undefined
            && item.objectName !== "galleryApiLoader")
            sections.push(item)
        for (let index = 0; index < item.children.length; ++index)
            sections = sections.concat(sectionsIn(item.children[index]))
        return sections
    }

    function test_allExamples_data() {
        const data = []
        const groups = exampleCatalog.groups
        for (let group = 0; group < groups.length; ++group) {
            const items = groups[group].children
            for (let position = 0; position < items.length; ++position)
                data.push({ tag: items[position].index, entry: items[position] })
        }
        return data
    }

    function test_catalogAndSearch() {
        ELocale.language = "en"
        const groups = exampleCatalog.groups
        compare(groups.length, 9)
        compare(exampleCatalog.filtered("date")[0].children.length, 3)
        compare(exampleCatalog.filtered("不存在的组件").length, 0)
        compare(exampleCatalog.find("ETable").label, "Table")
        compare(exampleCatalog.find("missing"), null)
    }

    function test_overviewReuse() {
        const component = Qt.createComponent("../../example/qml/component/App.qml")
        compare(component.status, Component.Ready, component.errorString())
        const window = createTemporaryObject(component, null)
        verify(window !== null, component.errorString())
        const loader = findChild(window, "galleryLoader")
        tryCompare(loader, "status", Loader.Ready)
        const overview = loader.item
        window.showOverview()
        compare(loader.item, overview)
        compare(window.currentComponent, "")
        window.close()
    }

    function verifyTiles(items, container) {
        const positions = items.map(function(item) {
            return item.mapToItem(container, 0, 0)
        })
        for (let index = 0; index < items.length; ++index) {
            const item = items[index]
            const position = positions[index]
            verify(item.width > 0 && item.height > 0, item.objectName)
            verify(position.x >= -1
                && position.x + item.width <= container.width + 1, item.objectName + " horizontal bounds")
            verify(position.y >= -1
                && position.y + item.height <= container.height + 1, item.objectName + " vertical bounds")
            for (let previous = 0; previous < index; ++previous) {
                const other = items[previous]
                const earlier = positions[previous]
                verify(position.x + item.width <= earlier.x + 1 || earlier.x + other.width <= position.x + 1
                    || position.y + item.height <= earlier.y + 1
                        || earlier.y + other.height <= position.y + 1,
                    item.objectName + " overlaps " + other.objectName)
            }
        }
    }

    function test_sampleDataAndSource() {
        ELocale.language = "en"
        compare(exampleData.models.ManyOptions.length, 1000)
        compare(exampleData.models.ManyRows.length, 1000)
        compare(exampleData.models.ManyNodes.length, 1000)
        const englishLabel = exampleData.models.ManyOptions[0]
        ELocale.language = "zh"
        verify(exampleData.models.ManyOptions[0] !== englishLabel)
        ELocale.language = "en"
        compare(exampleData.codeFor(""), "")
        compare(exampleData.codeFor("EButton {"), "")
        verify(exampleData.codeFor("EButton").indexOf("import EUI 1.0") === 0)
        const code = "EText { text: \"<unsafe>&value\" } /* open"
        const highlighted = exampleData.highlightCode(code, {
            plain: EPaletteManager.ThemePalette.textPrimary(false),
            string: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Warning)
        })
        verify(highlighted.indexOf("&lt;unsafe&gt;&amp;value") >= 0)
        verify(highlighted.indexOf("<unsafe>") < 0)
        verify(highlighted.indexOf("/*&nbsp;open") >= 0)
    }

    function test_formFeedbackAndReset() {
        ELocale.language = "en"
        const component = Qt.createComponent("../../example/qml/component/App.qml")
        compare(component.status, Component.Ready, component.errorString())
        const window = component.createObject(null)
        verify(window !== null, component.errorString())
        window.showComponent(exampleCatalog.find("EFormItem"))
        const loader = findChild(window, "galleryLoader")
        tryCompare(loader, "status", Loader.Ready)
        window.requestActivate()
        waitForRendering(window.contentItem)
        const item = findChild(loader.item, "galleryFormItem")
        const feedback = findChild(loader.item, "galleryFormFeedback")
        verify(item !== null)
        verify(feedback !== null)
        compare(item.fieldValue, "demo@example.com")
        item.field.text = "invalid"
        mouseClick(findChild(loader.item, "galleryFormValidate"))
        tryCompare(item, "hasValidationError", true)
        verify(item.effectiveMessage.length > 0)
        mouseClick(findChild(loader.item, "galleryFormReset"))
        tryCompare(item, "fieldValue", "demo@example.com")
        compare(item.hasValidationError, false)
        window.width = window.minimumWidth
        waitForRendering(window.contentItem)
        const preview = findChild(loader.item, "galleryPreview")
        verify(feedback.width <= preview.width)
        verify(preview.height >= findChild(preview, "galleryPreviewContent").implicitHeight)
        window.close()
        window.destroy()
    }

    function test_overviewFeaturedNavigation() {
        const component = Qt.createComponent("../../example/qml/component/App.qml")
        compare(component.status, Component.Ready, component.errorString())
        const window = createTemporaryObject(component, null)
        verify(window !== null, component.errorString())
        const loader = findChild(window, "galleryLoader")
        tryCompare(loader, "status", Loader.Ready)
        window.requestActivate()
        waitForRendering(window.contentItem)
        const input = findChild(loader.item, "galleryFeaturedInput")
        const table = findChild(loader.item, "galleryFeaturedTable")
        const theme = findChild(loader.item, "galleryFeaturedTheme")
        verify(input !== null && table !== null && theme !== null)
        compare(theme.y, input.y)
        window.width = 1000
        tryCompare(theme, "y", input.y)
        window.width = window.minimumWidth
        tryVerify(function() {
            return theme.y >= input.y + input.height
        })
        for (const card of [input, table, theme]) {
            const position = card.mapToItem(loader.item, 0, 0)
            verify(position.x >= 0 && position.x + card.width <= loader.item.width)
        }
        const entries = [{ name: "galleryFeaturedInput", component: "EInput" },
            { name: "galleryFeaturedTable", component: "ETable" },
            { name: "galleryFeaturedTheme", component: "EThemeSwitch" }]
        for (const entry of entries.concat(entries)) {
            const page = loader.item
            const card = findChild(page, entry.name)
            page.contentY = Math.max(0, card.mapToItem(page.contentItem, 0, 0).y - 24)
            waitForRendering(window.contentItem)
            mouseClick(card)
            tryCompare(loader, "status", Loader.Ready)
            tryCompare(loader, "opacity", 1)
            compare(window.currentComponent, entry.component)
            compare(loader.item.selectedComponent, entry.component)
            window.showOverview()
            tryCompare(loader, "status", Loader.Ready)
            tryCompare(loader, "opacity", 1)
        }
    }

    function test_tableFeedbackAndActions() {
        ELocale.language = "en"
        const component = Qt.createComponent("../../example/qml/component/App.qml")
        compare(component.status, Component.Ready, component.errorString())
        const window = createTemporaryObject(component, null)
        verify(window !== null, component.errorString())
        window.showComponent(exampleCatalog.find("ETable"))
        const loader = findChild(window, "galleryLoader")
        tryCompare(loader, "status", Loader.Ready)
        window.requestActivate()
        waitForRendering(window.contentItem)
        GalleryUtils.loadExamples(testCase, loader.item)
        const table = findChild(loader.item, "galleryTable")
        const selection = findChild(loader.item, "galleryTableSelection")
        const sortStatus = findChild(loader.item, "galleryTableSortStatus")
        const clearSelection = findChild(loader.item, "galleryTableClearSelection")
        const clearSorting = findChild(loader.item, "galleryTableClearSorting")
        verify(table !== null && selection !== null && sortStatus !== null)
        compare(selection.text, ELocale.texts.NoSelection)
        compare(clearSelection.enabled, false)
        compare(clearSorting.enabled, false)
        verify(table.selectRow(1))
        compare(selection.text, exampleData.ui.TableSelected.arg(table.currentRow.name))
        compare(clearSelection.enabled, true)
        verify(table.sort("age", "descending"))
        compare(sortStatus.text, exampleData.ui.TableDescending)
        compare(clearSorting.enabled, true)
        revealControl(loader.item, clearSelection)
        mouseClick(clearSelection)
        compare(table.currentRow, null)
        compare(selection.text, ELocale.texts.NoSelection)
        compare(clearSelection.enabled, false)
        mouseClick(clearSorting)
        compare(table.sortOrder, "")
        compare(sortStatus.text, exampleData.ui.TableOriginalOrder)
        compare(clearSorting.enabled, false)
        window.width = window.minimumWidth
        waitForRendering(window.contentItem)
        const preview = findChild(loader.item, "galleryPreview")
        verify(table.width <= preview.width)
    }

    function test_overviewCategoryNavigation() {
        ELocale.language = "en"
        ETheme.setDark(false)
        const component = Qt.createComponent("../../example/qml/component/App.qml")
        compare(component.status, Component.Ready, component.errorString())
        const window = createTemporaryObject(component, null)
        verify(window !== null)
        const loader = findChild(window, "galleryLoader")
        tryCompare(loader, "status", Loader.Ready)
        tryCompare(loader, "opacity", 1)
        window.requestActivate()
        tryCompare(window, "active", true)
        window.update()
        verify(waitForRendering(window.contentItem))
        const grid = findChild(loader.item, "galleryCategoryGrid")
        verify(grid !== null)
        window.width = 1000
        tryCompare(grid, "columns", 2)
        window.width = 1280
        tryCompare(grid, "columns", 3)
        const mouseLink = findChild(loader.item, "galleryCategoryLink")
        verify(mouseLink !== null)
        const mouseTarget = mouseLink.entry.index
        revealControl(loader.item, mouseLink)
        mouseClick(mouseLink)
        tryCompare(window, "currentComponent", mouseTarget)
        tryCompare(loader, "status", Loader.Ready)
        compare(loader.item.selectedComponent, mouseTarget)
        window.showOverview()
        tryCompare(loader, "status", Loader.Ready)
        tryCompare(loader, "opacity", 1)
        const page = loader.item
        const card = itemsNamed(page, "galleryCategoryCard").find(function(item) {
            return item.group.index === "form"
        })
        verify(card !== undefined)
        const toggle = findChild(card, "galleryCategoryToggle")
        verify(toggle !== null && toggle.visible)
        revealControl(page, toggle)
        mouseClick(toggle)
        tryCompare(card, "expanded", true)
        const last = card.group.children[card.group.children.length - 1].index
        let keyboardLink = null
        tryVerify(function() {
            keyboardLink = itemsNamed(card, "galleryCategoryLink").find(function(item) {
                return item.entry.index === last
            })
            return keyboardLink !== undefined
        })
        revealControl(page, keyboardLink)
        keyboardLink.forceActiveFocus()
        tryCompare(keyboardLink, "activeFocus", true)
        keyClick(Qt.Key_Space)
        tryCompare(window, "currentComponent", last)
        tryCompare(loader, "status", Loader.Ready)
        compare(loader.item.selectedComponent, last)
        window.close()
    }

    function test_allExamples(data) {
        const component = Qt.createComponent("../../example/qml/component/" + data.entry.source)
        compare(component.status, Component.Ready, component.errorString())
        const page = createTemporaryObject(component, testCase, {
            width: 900,
            height: 620,
            selectedComponent: data.entry.index
        })
        verify(page !== null, component.errorString())
        page.showComponent(data.entry.index)
        compare(page.selectedComponent, data.entry.index)
        wait(0)
        GalleryUtils.loadExamples(testCase, page)
        if (data.entry.index === "ETabs") {
            const tabs = findChild(page, "webNavigationTabs")
            verify(tabs !== null)
            verify(tabs.paneAt(tabs.currentIndex) !== null)
            compare(tabs.activePane, tabs.paneAt(tabs.currentIndex))
            compare(tabs.navigation.currentIndex, tabs.currentIndex)
            verify(tabs.implicitHeight >= tabs.navigation.implicitHeight + tabs.activePane.implicitHeight)
        }
        const sections = sectionsIn(page)
        let matching = 0
        for (let index = 0; index < sections.length; ++index) {
            const section = sections[index]
            if (section.componentName === data.entry.index) {
                ++matching
                verify(section.loadedCard !== null, data.entry.index + " card was not loaded")
                verify(section.loadedCard.implicitHeight > 0)
                verify(section.loadedCard.hasSource, data.entry.index + " source is missing")
                if (section.loadedCard.code !== undefined && section.loadedCard.code.length > 0)
                    compare(sourceToolbarCount(section.loadedCard), 1, data.entry.index
                        + " source toolbar is duplicated")
                const previews = itemsNamed(section.loadedCard, "galleryPreview")
                verify(previews.length > 0, data.entry.index + " preview is missing")
                for (const preview of previews) {
                    const content = findChild(preview, "galleryPreviewContent")
                    verify(preview.width > 0)
                    verify(content.y + content.implicitHeight <= preview.height + 1,
                        data.entry.index + " preview clips its content")
                    if (content.implicitHeight > 0 && content.implicitHeight <= 48)
                        verify(preview.height <= 112, data.entry.index
                            + " compact preview has excessive empty space")
                }
            } else {
                compare(section.loadedCard, null)
            }
        }
        verify(matching > 0, data.entry.index + " example is missing")
        page.destroy()
    }

    function test_showcaseHeaderAndLayout(data) {
        ELocale.language = "en"
        const component = Qt.createComponent("../../example/qml/component/App.qml")
        compare(component.status, Component.Ready, component.errorString())
        const window = createTemporaryObject(component, null, { width: data.width })
        verify(window !== null)
        window.showComponent(exampleCatalog.find(data.name))
        const loader = findChild(window, "galleryLoader")
        tryCompare(loader, "status", Loader.Ready)
        const page = loader.item
        GalleryUtils.loadExamples(testCase, page)
        const title = findChild(page, "galleryComponentTitle")
        const identifier = findChild(page, "galleryComponentIdentifier")
        compare(
            findChild(page, "galleryComponentIcon").iconSource,
            Gallery.GalleryStyle.componentIcons[data.name]
        )
        compare(title.text, exampleCatalog.find(data.name).label)
        compare(identifier.text, data.name)
        ELocale.language = "zh"
        tryCompare(title, "text", exampleCatalog.find(data.name).label)
        compare(identifier.text, data.name)
        verify(title.x + title.width <= title.parent.width)
        if (data.name === "EIcon") {
            for (const name of ["galleryIconSizeGrid", "galleryIconToneGrid"]) {
                const grid = findChild(page, name)
                verify(grid !== null)
                tryVerify(function() {
                    return grid.implicitHeight > 0
                })
                let count = 0
                for (let index = 0; index < grid.children.length; ++index) {
                    const tile = grid.children[index]
                    if (tile.objectName !== "galleryIconSizeTile"
                        && tile.objectName !== "galleryIconToneTile")
                        continue
                    ++count
                    verify(tile.x + tile.width <= grid.width + 1)
                    verify(tile.y + tile.height <= grid.implicitHeight + 1)
                }
                compare(count, name === "galleryIconSizeGrid" ? 3 : 4)
            }
        } else {
            const specimen = findChild(page, "galleryTextSpecimen")
            const body = findChild(page, "galleryTextBody")
            verify(specimen.width <= specimen.parent.width)
            compare(body.wrapMode, Text.WordWrap)
            verify(body.contentWidth <= body.width + 1)
            waitForItemPolished(body.parent)
        }
        waitForItemPolished(findChild(page, "galleryPreviewContent"))
        waitForItemPolished(findChild(page, "galleryPageColumn"))
        const source = visibleSource(page)
        verify(source !== null)
        verify(waitForRendering(window.contentItem))
        waitForItemPolished(findChild(page, "galleryPageColumn"))
        const collapsedHeight = page.contentHeight
        source.expanded = true
        tryVerify(function() {
            return page.contentHeight > collapsedHeight
        })
        source.expanded = false
        tryCompare(page, "contentHeight", collapsedHeight)
        window.close()
    }

    function test_windowNavigation() {
        ELocale.language = "en"
        const component = Qt.createComponent("../../example/qml/component/App.qml")
        compare(component.status, Component.Ready, component.errorString())
        const window = component.createObject(null)
        verify(window !== null, component.errorString())
        const loader = findChild(window, "galleryLoader")
        tryCompare(loader, "status", Loader.Ready)
        compare(window.currentComponent, "")
        compare(window.currentSource, "Overview.qml")
        verify(loader.item.componentCount > 80)
        window.requestActivate()
        waitForRendering(window.contentItem)
        const navigationToggle = findChild(window, "galleryNavigationToggle")
        const search = findChild(window, "gallerySearch")
        const expandedWidth = loader.width
        mouseClick(navigationToggle)
        compare(window.navigationExpanded, false)
        compare(search.visible, false)
        tryVerify(function() {
            return loader.width > expandedWidth
        })
        mouseClick(navigationToggle)
        compare(window.navigationExpanded, true)
        compare(search.visible, true)
        tryCompare(loader, "width", expandedWidth)
        window.showComponent(exampleCatalog.find("ETable"))
        tryCompare(loader, "status", Loader.Ready)
        compare(loader.item.selectedComponent, "ETable")
        window.showComponent(exampleCatalog.find("ESelect"))
        tryCompare(loader, "status", Loader.Ready)
        compare(loader.item.selectedComponent, "ESelect")
        search.text = "table"
        compare(window.pages.length, 1)
        compare(window.pages[0].children.length, 1)
        tryVerify(function() {
            const entry = findChild(window.contentItem, "galleryNavEntry")
            return entry !== null && entry.visible && entry.entry.index === "ETable"
        })
        const entry = findChild(window.contentItem, "galleryNavEntry")
        compare(entry.entry.index, "ETable")
        mouseClick(entry)
        tryCompare(loader, "status", Loader.Ready)
        compare(window.currentComponent, "ETable")
        compare(loader.item.selectedComponent, "ETable")
        compare(entry.selected, true)
        const languageSwitch = findChild(window, "galleryLanguageSwitch")
        window.requestActivate()
        waitForRendering(window.contentItem)
        mouseClick(languageSwitch)
        compare(ELocale.language, "zh")
        compare(exampleCatalog.find("ETable").label, "表格")
        mouseClick(languageSwitch)
        compare(ELocale.language, "en")
        tryVerify(function() { return visibleSource(loader.item) !== null })
        const source = visibleSource(loader.item)
        verify(source !== null)
        verify(source.code.indexOf("\n") >= 0)
        compare(source.expanded, false)
        const collapsedHeight = source.implicitHeight
        source.expanded = true
        tryVerify(function() {
            return source.implicitHeight > collapsedHeight
        })
        const sourceText = findChild(source, "gallerySourceText")
        verify(sourceText.contentHeight > sourceText.font.pixelSize * 2)
        compare(findChild(source, "gallerySourceToggle").text, ELocale.texts.HideSource)
        source.expanded = false
        tryCompare(source, "implicitHeight", collapsedHeight)
        window.showOverview()
        tryCompare(loader, "status", Loader.Ready)
        verify(loader.item.componentCount > 80)
        window.close()
        window.destroy()
    }

    function test_titleBarActionsAndNarrowLayout() {
        ELocale.language = "en"
        ETheme.setDark(false)
        const component = Qt.createComponent("../../example/qml/component/App.qml")
        compare(component.status, Component.Ready, component.errorString())
        const window = createTemporaryObject(component, null)
        verify(window !== null, component.errorString())
        window.requestActivate()
        waitForRendering(window.contentItem)
        const appBar = findChild(window, "galleryAppBar")
        const breadcrumb = findChild(window, "galleryBreadcrumbHeader")
        const language = findChild(window, "galleryLanguageSwitch")
        const theme = findChild(window, "galleryThemeSwitch")
        const loader = findChild(window, "galleryLoader")
        verify(appBar !== null && breadcrumb !== null && language !== null && theme !== null)
        const actions = findChild(appBar, "eAppBarActions")
        const dragArea = findChild(appBar, "eAppBarDragArea")
        const windowButtons = findChild(appBar, "eAppBarWindowButtons")
        verify(actions !== null && dragArea !== null && windowButtons !== null)
        compare(window.appBar, appBar)
        verify((window.flags & Qt.FramelessWindowHint) !== 0)
        compare(appBar.mapToItem(window.contentItem, 0, 0).y, 0)
        verify(breadcrumb.mapToItem(window.contentItem, 0, 0).y >= appBar.height)
        for (const width of [1280, 820]) {
            window.width = width
            waitForRendering(window.contentItem)
            compare(appBar.width, window.width)
            const actionPosition = actions.mapToItem(appBar, 0, 0)
            const dragPosition = dragArea.mapToItem(appBar, 0, 0)
            const buttonPosition = windowButtons.mapToItem(appBar, 0, 0)
            verify(dragPosition.x + dragArea.width <= actionPosition.x)
            verify(actionPosition.x + actions.width <= buttonPosition.x
                || buttonPosition.x + windowButtons.width <= actionPosition.x)
            for (const action of [language, theme]) {
                compare(action.parent, actions)
                const position = action.mapToItem(appBar, 0, 0)
                verify(position.x >= 0 && position.x + action.width <= appBar.width)
                verify(position.y >= 0 && position.y + action.height <= appBar.height)
            }
            const languagePosition = language.mapToItem(appBar, 0, 0)
            const themePosition = theme.mapToItem(appBar, 0, 0)
            verify(languagePosition.x + language.width <= themePosition.x)
        }
        compare(theme.captureRoot.parent, window.contentItem)
        compare(theme.captureRoot.width, window.width)
        compare(theme.captureRoot.height, window.height)
        let ancestor = loader
        while (ancestor && ancestor !== theme.captureRoot)
            ancestor = ancestor.parent
        compare(ancestor, theme.captureRoot)
        const visibility = window.visibility
        mouseClick(language)
        compare(ELocale.language, "zh")
        compare(window.visibility, visibility)
        mouseClick(language)
        compare(ELocale.language, "en")
        compare(window.visibility, visibility)
        mouseClick(theme)
        tryCompare(ETheme, "dark", true, 2000)
        wait(theme.transitionDuration + 150)
        compare(theme.checked, true)
        compare(window.visibility, visibility)
        mouseClick(theme)
        tryCompare(ETheme, "dark", false, 2000)
        wait(theme.transitionDuration + 150)
        compare(theme.checked, false)
        compare(window.visibility, visibility)
        verify(window.visible)
    }

    function test_overviewCategoryLayout(data) {
        ELocale.language = data.language
        ETheme.setDark(data.dark)
        const component = Qt.createComponent("../../example/qml/component/App.qml")
        compare(component.status, Component.Ready, component.errorString())
        const window = createTemporaryObject(component, null, {width: data.width})
        verify(window !== null)
        const loader = findChild(window, "galleryLoader")
        tryCompare(loader, "status", Loader.Ready)
        tryCompare(loader, "opacity", 1)
        window.requestActivate()
        tryCompare(window, "active", true)
        window.update()
        verify(waitForRendering(window.contentItem))
        const page = loader.item
        const grid = findChild(page, "galleryCategoryGrid")
        verify(grid !== null)
        compare(grid.columns, data.width === 1280 ? 3 : 1)
        const cards = itemsNamed(grid, "galleryCategoryCard")
        compare(cards.length, exampleCatalog.groups.length)
        compare(page.componentCount, exampleCatalog.groups.reduce(function(total, group) {
            return total + group.children.length
        }, 0))
        waitForItemPolished(grid)
        const gridPosition = grid.mapToItem(page.contentItem, 0, 0)
        verify(gridPosition.x >= -1 && gridPosition.x + grid.width <= page.width + 1)
        verifyTiles(cards, grid)
        for (let index = 0; index < cards.length; ++index) {
            const card = cards[index]
            compare(card.group.index, exampleCatalog.groups[index].index)
            compare(card.group.text, exampleCatalog.groups[index].text)
            compare(card.expanded, false)
            const toggle = findChild(card, "galleryCategoryToggle")
            verify(toggle !== null)
            compare(toggle.visible, card.group.children.length > 3)
            const links = itemsNamed(card, "galleryCategoryLink")
            compare(links.length, Math.min(3, card.group.children.length))
            const tiles = findChild(card, "galleryCategoryTileGrid")
            verify(tiles !== null)
            verifyTiles(links, tiles)
            verifyTiles([tiles], card)
            const collapsedWidth = card.width
            if (toggle.visible) {
                revealControl(page, toggle)
                mouseClick(toggle)
                tryCompare(card, "expanded", true)
                tryCompare(card, "width", grid.width)
                if (index === 0) {
                    revealControl(page, toggle)
                    mouseClick(toggle)
                    tryCompare(card, "expanded", false)
                    tryCompare(card, "width", collapsedWidth)
                    tryVerify(function() {
                        return itemsNamed(card, "galleryCategoryLink").length === 3
                    })
                    revealControl(page, toggle)
                    mouseClick(toggle)
                    tryCompare(card, "expanded", true)
                    tryCompare(card, "width", grid.width)
                }
            }
            tryVerify(function() {
                return itemsNamed(card, "galleryCategoryLink").length === card.group.children.length
            })
            waitForItemPolished(tiles)
            const expandedLinks = itemsNamed(card, "galleryCategoryLink")
            for (let position = 0; position < expandedLinks.length; ++position) {
                compare(expandedLinks[position].entry.index, card.group.children[position].index)
                verify(page.componentIcons[expandedLinks[position].entry.index] > 0)
            }
            verifyTiles(expandedLinks, tiles)
            verifyTiles([tiles], card)
        }
        waitForItemPolished(grid)
        verifyTiles(cards, grid)
        compare(itemsNamed(grid, "galleryCategoryLink").length, page.componentCount)
        const links = itemsNamed(cards[cards.length - 1], "galleryCategoryLink")
        const last = links[links.length - 1]
        const target = last.entry.index
        revealControl(page, last)
        const position = last.mapToItem(page, 0, 0)
        verify(position.y >= -1 && position.y + last.height <= page.height + 1)
        mouseClick(last)
        tryCompare(window, "currentComponent", target)
        tryCompare(loader, "status", Loader.Ready)
        compare(loader.item.selectedComponent, target)
        window.close()
    }

    height: 720
    width: 1000
    when: windowShown
    name: "EUIGallery"
}

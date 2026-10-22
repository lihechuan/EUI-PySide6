import EUI 1.0
import "../../example/qml/component" as Gallery
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Window 2.15

TestCase {
    id: testCase

    function cleanup() {
        ETheme.setDark(false)
        ELocale.language = "zh"
    }

    function test_skeletonContrast_data() {
        return [{ tag: "light", dark: false }, { tag: "dark", dark: true }]
    }

    function initTestCase() {
        if (Qt.platform.os === "osx")
            testCase.Window.window.flags |= Qt.WindowStaysOnTopHint
    }

    function test_formFieldsFollowContainerWidth_data() {
        return [{ tag: "left", position: "left" }, { tag: "top", position: "top" }]
    }

    function namedItems(item, name) {
        let items = item.objectName === name ? [item] : []
        for (let index = 0; index < item.children.length; ++index)
            items = items.concat(namedItems(item.children[index], name))
        return items
    }

    function test_dateGridDistribution_data() {
        return [{ tag: "chinese", language: "zh", width: 300 },
            { tag: "english", language: "en", width: 300 },
            { tag: "compact", language: "zh", width: 240 },
            { tag: "wide", language: "en", width: 420 }]
    }

    function test_avatarSourceRendersAtControlSize_data() {
        return [{tag: "crop-circle", mode: Image.PreserveAspectCrop, shape: "circle"},
            {tag: "fit-square", mode: Image.PreserveAspectFit, shape: "square"},
            {tag: "stretch-square", mode: Image.Stretch, shape: "square"}]
    }

    function test_treeCheckboxLines_data() {
        return [{tag: "light-small", dark: false, size: EStyle.Small},
            {tag: "light-medium", dark: false, size: EStyle.Medium},
            {tag: "light-large", dark: false, size: EStyle.Large},
            {tag: "dark-small", dark: true, size: EStyle.Small},
            {tag: "dark-medium", dark: true, size: EStyle.Medium},
            {tag: "dark-large", dark: true, size: EStyle.Large}]
    }

    function test_formIntrinsicAndInlineLayout() {
        const item = createTemporaryObject(naturalFormComponent, testCase)
        verify(waitForItemPolished(item.fields[0].parent))
        compare(item.width, 220)
        verify(item.height > 0)
        item.inline = true
        verify(waitForItemPolished(item.fields[0].parent))
        compare(item.width, 180 + 220 + item.columnSpacing)
        compare(item.fields[1].y, item.fields[0].y)
        compare(item.fields[1].x, item.fields[0].width + item.columnSpacing)
        verify(item.height >= item.fields[0].height)
    }

    function test_avatarSourceRendersAtControlSize(data) {
        const item = createTemporaryObject(
            avatarComponent,
            testCase,
            {fillMode: data.mode, shape: data.shape}
        )
        tryCompare(item, "loaded", true)
        for (const size of [56, 32, 72]) {
            item.size = size
            verify(waitForItemPolished(item))
            tryVerify(function() {
                const pixels = grabImage(item)
                const y = Math.floor(size / 2)
                for (const position of [0.15, 0.85]) {
                    const x = Math.floor(size * position)
                    if (pixels.blue(x, y) - pixels.red(x, y) <= 100
                        || pixels.blue(x, y) - pixels.green(x, y) <= 45)
                        return false
                }
                return true
            }, 5000, "The full source image must render both blue faces at every avatar size")
        }
    }

    function test_skeletonContrast(data) {
        ETheme.setDark(data.dark)
        const item = createTemporaryObject(skeletonComponent, testCase)
        const bars = namedItems(item, "skeletonBar")
        const surface = EPaletteManager.ThemePalette.surfaceDisabled(data.dark)
        compare(bars.length, 4)
        for (const bar of bars) {
            const difference = Math.max(Math.abs(bar.color.r - surface.r),
                Math.abs(bar.color.g - surface.g), Math.abs(bar.color.b - surface.b))
            verify(difference >= 0.09)
            fuzzyCompare(bar.color.r, bar.color.g, 0.02)
            fuzzyCompare(bar.color.g, bar.color.b, 0.04)
        }
        item.animated = true
        tryVerify(function() {
            return bars[0].opacity < 0.9
        })
        verify(bars[0].opacity >= 0.4)
        item.enabled = false
        const opacity = bars[0].opacity
        wait(50)
        compare(bars[0].opacity, opacity)
    }

    function test_skeletonLoadingKeepsContentHeight() {
        const item = createTemporaryObject(skeletonComponent, testCase)
        const label = findChild(item, "loadedLabel")
        verify(waitForItemPolished(item))
        compare(item.implicitHeight, 112)
        item.loading = false
        verify(waitForItemPolished(item))
        compare(item.implicitHeight, label.height)
        compare(label.parent.height, label.height)
        item.width = 200
        verify(waitForItemPolished(item))
        compare(item.implicitHeight, label.height)
        compare(label.parent.height, label.height)
        item.loading = true
        verify(waitForItemPolished(item))
        compare(item.implicitHeight, 112)
        const bars = namedItems(item, "skeletonBar")
        compare(bars.length, 4)
        fuzzyCompare(bars[1].width, item.availableWidth, 0.01)
        fuzzyCompare(bars[3].width, item.availableWidth * 0.61, 0.01)
    }

    function test_formFieldsFollowContainerWidth(data) {
        const item = createTemporaryObject(formComponent, testCase, { labelPosition: data.position })
        tryVerify(function() {
            return item.fields.length === 2 && item.fields[0].form === item
        })
        const fields = item.fields
        for (const width of [360, 240]) {
            item.width = width
            verify(waitForItemPolished(fields[0].parent))
            for (const field of fields) {
                const input = field.field
                compare(field.width, item.width)
                verify(field.visible)
                verify(field.height > 0)
                verify(input.visible)
                verify(input.width > 100)
                verify(input.height > 0)
                const position = input.mapToItem(item, 0, 0)
                verify(position.x >= 0)
                verify(position.x + input.width <= item.width + 0.5)
                verify(position.y + input.height <= item.height + 0.5)
            }
            verify(fields[1].y >= fields[0].y + fields[0].height + item.spacing)
            verify(item.height >= fields[1].y + fields[1].height)
        }
    }

    function test_descriptionLongWordsStayInsideCells() {
        const item = createTemporaryObject(descriptionComponent, testCase)
        verify(waitForItemPolished(item.contentItem))
        const cell = findChild(item, "descriptionCell_2")
        let label = null
        let value = null
        for (let index = 0; index < cell.children.length; ++index) {
            const child = cell.children[index]
            if (child.text === "Maintainer")
                label = child
            else if (child.text === "Product team")
                value = child
        }
        verify(label !== null)
        verify(value !== null)
        for (const direction of ["horizontal", "vertical"]) {
            item.direction = direction
            verify(waitForItemPolished(item.contentItem))
            for (const text of [label, value]) {
                verify(text.contentWidth <= text.width - text.leftPadding - text.rightPadding + 0.5,
                    "Description labels and values must not paint into adjacent cells")
                verify(text.contentHeight <= text.height - text.topPadding - text.bottomPadding + 0.5)
            }
        }
    }

    function test_dateGridDistribution(data) {
        ELocale.language = data.language
        const item = createTemporaryObject(dateComponent, testCase, { width: data.width })
        const grid = findChild(item, "datePickerMonthGrid")
        verify(waitForItemPolished(grid.contentItem))
        const cells = namedItems(item, "datePickerDay")
        const weekdays = namedItems(item, "datePickerWeekday")
        compare(cells.length, 42)
        compare(weekdays.length, 7)
        for (let index = 0; index < cells.length; ++index) {
            const cell = cells[index]
            const position = cell.mapToItem(grid.contentItem, 0, 0)
            verify(cell.width > 0)
            verify(cell.height > 0)
            fuzzyCompare(position.x, (index % 7) * (cell.width + grid.spacing), 0.5)
            fuzzyCompare(position.y, Math.floor(index / 7) * (cell.height + grid.spacing), 0.5)
            verify(position.x + cell.width <= grid.availableWidth + 0.5)
            verify(position.y + cell.height <= grid.availableHeight + 0.5)
            if (index < weekdays.length) {
                const header = weekdays[index].mapToItem(item, weekdays[index].width / 2, 0)
                const day = cell.mapToItem(item, cell.width / 2, 0)
                fuzzyCompare(header.x, day.x, 0.5)
            }
        }
        const target = cells.filter(function(cell) {
            return cell.currentMonth && !cell.selected
        })[0]
        const spy = createTemporaryObject(pickedSpy, testCase, { target: item })
        verify(target)
        mouseClick(target, target.width / 2, target.height / 2)
        compare(spy.count, 1)
        verify(target.selected)
        compare(item.value.slice(0, 7), "2026-10")
    }

    function test_treeCheckboxLines(data) {
        ETheme.setDark(data.dark)
        const provider = createTemporaryObject(treeProviderComponent, testCase, {size: data.size})
        const tree = findChild(provider, "treeAppearanceFixture")
        verify(waitForItemPolished(tree.contentItem))
        mouseMove(testCase, width - 1, height - 1)
        waitForRendering(tree)
        for (const key of ["team", "design", "engineering", "archived"]) {
            const check = findChild(tree, "treeCheck_" + key)
            const row = findChild(tree, "treeRow_" + key)
            verify(check !== null)
            verify(check.indicator.x >= 0)
            verify(check.indicator.x + check.indicator.width <= check.width)
            compare(check.height, row.height)
            const indicatorRight = check.mapToItem(row, check.indicator.x + check.indicator.width, 0).x
            verify(row.labelOffset - indicatorRight >= 8)
            const pixels = grabImage(row)
            compare(pixels.pixel(Math.floor(check.x), 1), pixels.pixel(Math.floor(check.x
                + check.width
                + 2), 1))
        }
        const design = findChild(tree, "treeCheck_design")
        mouseClick(design, design.width / 2, design.height / 2)
        compare(tree.getCheckedKeys(), ["design"])
        compare(findChild(tree, "treeCheck_team").checkState, Qt.PartiallyChecked)
        const archived = findChild(tree, "treeCheck_archived")
        mouseClick(archived, archived.width / 2, archived.height / 2)
        compare(tree.getCheckedKeys(), ["design"])
        const root = findChild(tree, "treeCheck_team")
        mouseClick(root, root.width / 2, root.height / 2)
        compare(tree.getCheckedKeys(), ["design", "engineering"])
        compare(root.checkState, Qt.PartiallyChecked)
    }

    function test_paginationExampleReflowsAndStaysSynchronized() {
        ELocale.language = "en"
        const page = createTemporaryObject(paginationPageComponent, testCase)
        tryVerify(function() {
            return findChild(page, "galleryPaginationControls") !== null
        })
        const controls = findChild(page, "galleryPaginationControls")
        const pager = findChild(page, "galleryPaginationPages")
        verify(waitForItemPolished(controls.parent))
        verify(!pager.visible)
        compare(controls.layout, "total, sizes, prev, pager, next, jumper")
        page.width = 588
        verify(waitForItemPolished(controls.parent))
        verify(pager.visible)
        compare(controls.layout, "total, sizes, ->, jumper")
        for (const item of [controls, pager]) {
            for (const name of ["paginationLeft", "paginationRight"]) {
                const group = findChild(item, name)
                verify(waitForItemPolished(group))
                if (group.width > 0)
                    verify(group.x + group.width <= item.availableWidth + 0.5)
            }
        }
        verify(pager.setPage(20))
        compare(controls.currentPage, 20)
        verify(controls.setPageSize(100))
        compare(pager.pageSize, 100)
        compare(pager.currentPage, controls.currentPage)
        compare(controls.currentPage, 3)
        const sizes = findChild(controls, "paginationSizes")
        const jumper = findChild(controls, "paginationJumper")
        verify(sizes && jumper)
        sizes.activated(0)
        compare(pager.pageSize, 10)
        controls.setPage(1)
        mouseClick(jumper.up.indicator, jumper.up.indicator.width / 2, jumper.up.indicator.height / 2)
        compare(controls.currentPage, 2)
        compare(pager.currentPage, 2)
        page.width = 1000
        verify(waitForItemPolished(controls.parent))
        verify(!pager.visible)
        compare(controls.currentPage, 2)
    }

    function test_avatarGroupCountRemainsVisibleAndInteractive() {
        const group = createTemporaryObject(avatarGroupComponent, testCase)
        tryCompare(group, "collapsedCount", 2)
        const more = findChild(group, "avatarGroupCollapsed")
        const popup = findChild(group, "avatarGroupPopup")
        verify(waitForItemPolished(more))
        const hover = findChild(more, "avatarGroupHover")
        verify(hover !== null)
        try {
            let counter = null
            for (let index = 0; index < more.contentItem.children.length; ++index) {
                const child = more.contentItem.children[index]
                if (child.text === "+2")
                    counter = child
            }
            verify(counter !== null)
            verify(
                counter.visible,
                "The avatar counter must remain visible beside its mouse interaction area"
            )
            verify(counter.contentWidth > 0 && counter.contentWidth <= counter.width)
            verify(counter.font.pixelSize >= 12)
            tryVerify(function() {
                const pixels = grabImage(more)
                let white = 0
                for (let y = 8; y < more.height - 8; ++y) {
                    for (let x = 8; x < more.width - 8; ++x) {
                        if (pixels.red(x, y) > 230 && pixels.green(x, y) > 230 && pixels.blue(x, y) > 230)
                            ++white
                    }
                }
                return white > 8
            }, 5000, "The collapsed avatar must visibly render its +2 counter")
            mouseMove(testCase, width - 1, height - 1)
            tryCompare(hover, "containsMouse", false)
            mouseMove(more, more.width / 2, more.height / 2)
            tryCompare(hover, "containsMouse", true)
            tryCompare(popup, "visible", true)
            popup.close()
            tryCompare(popup, "visible", false)
            mouseClick(more, more.width / 2, more.height / 2)
            tryCompare(popup, "visible", true)
            popup.close()
            tryCompare(popup, "visible", false)
            mouseMove(testCase, width - 1, height - 1)
            tryCompare(hover, "containsMouse", false)
            mouseMove(more, more.width / 2, more.height / 2)
            tryCompare(hover, "containsMouse", true)
            tryCompare(popup, "visible", true)
            mouseMove(testCase, width - 1, height - 1)
            tryCompare(hover, "containsMouse", false)
            verify(popup.visible)
            tryCompare(popup, "visible", false)
        } finally {
            popup.close()
            tryCompare(popup, "visible", false)
        }
    }

    width: 640
    height: 480
    visible: true
    when: windowShown
    name: "DataVisuals"

    Component {
        id: avatarComponent

        EAvatar {
            x: 24
            y: 24
            size: 56
            source: Qt.resolvedUrl("../../assets/eui-mark.svg")
        }
    }
    Component {
        id: descriptionComponent

        EDescriptions {
            x: 24
            y: 24
            columns: 3
            width: 481
            model: [{label: "Name", value: "EUI component library", span: 2},
                {label: "Version", value: "3.0"}, {label: "Maintainer", value: "Product team", rowspan: 2},
                {label: "Platform", value: "Desktop", span: 2},
                {label: "Description", value: "Themes, keyboard and custom content", span: 2}]
        }
    }
    Component {
        id: avatarGroupComponent

        EAvatarGroup {
            x: 24
            y: 24
            size: 40
            collapseAvatars: true
            maxCollapseAvatars: 2
            collapseAvatarsTooltip: true

            EAvatar { text: "A" }
            EAvatar { text: "B" }
            EAvatar { text: "C" }
            EAvatar { text: "D" }
        }
    }
    Component {
        id: paginationPageComponent

        Gallery.DataExamples {
            x: 24
            height: 460
            width: 1000
            selectedComponent: "EPagination"
        }
    }
    Component {
        id: dateComponent

        EDatePickerPanel {
            x: 24
            y: 24
            value: "2026-10-10"
        }
    }
    Component {
        id: skeletonComponent

        ESkeleton {
            x: 24
            y: 24
            width: 320

            EText {
                width: parent.width
                wrapMode: Text.WordWrap
                objectName: "loadedLabel"
                text: "Loaded content retains its natural height after changing the skeleton width."
            }
        }
    }
    Component {
        id: pickedSpy

        SignalSpy {
            signalName: "picked"
        }
    }
    Component {
        id: formComponent

        EForm {
            x: 24
            y: 24
            width: 360
            labelWidth: 80
            labelPosition: "left"
            validateOnRuleChange: false

            EFormItem {
                prop: "name"
                label: "Name"
                width: parent.width

                EInput {
                    width: parent.width
                }
            }
            EFormItem {
                prop: "email"
                label: "Email"
                width: parent.width

                EInput {
                    width: parent.width
                }
            }
        }
    }
    Component {
        id: naturalFormComponent

        EForm {
            x: 24
            y: 24
            validateOnRuleChange: false

            EFormItem {
                width: 180
                label: "Name"

                EInput {
                    width: parent.width
                }
            }
            EFormItem {
                width: 220
                label: "Email"

                EInput {
                    width: parent.width
                }
            }
        }
    }
    Component {
        id: treeProviderComponent

        EConfigProvider {
            x: 24
            y: 24
            width: 340
            height: 160

            ETree {
                showCheckbox: true
                width: parent.width
                height: parent.height
                expandedKeys: ["team"]
                objectName: "treeAppearanceFixture"
                model: [{id: "team", label: "产品团队", children: [{id: "design", label: "设计"},
                    {id: "engineering", label: "开发"}, {id: "archived", label: "归档", disabled: true}]}]
            }
        }
    }
}

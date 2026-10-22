import EUI 1.0
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function namedItems(item, name) {
        const result = []
        if (item.objectName === name)
            result.push(item)
        for (let index = 0; index < item.children.length; ++index) {
            const children = namedItems(item.children[index], name)
            for (let child = 0; child < children.length; ++child)
                result.push(children[child])
        }
        return result
    }

    function test_textButtonBackgroundStates(data) {
        const state = EPaletteManager.createStateObject(testCase, EStyle.Color)
            .setDark(data.dark)
            .setHovered(data.interaction === "hover")
            .setPressed(data.interaction === "pressed")
            .setEnabled(data.interaction !== "disabled")
            .setColor(EPaletteManager.ThemePalette.fetchThemeColor(data.dark))
            .setIsOpenBackgroundColor(data.open)
        compare(EPaletteManager.StatePalette.adjustPlainTextButtonColor(state), data.expected)
    }

    function test_tabsReserveCloseSpaceAndViewport() {
        const item = createTemporaryObject(tabsComponent, testCase)
        waitForRendering(item)
        const bar = item.navigation
        verify(bar.clip)
        compare(bar.width, item.availableWidth)
        compare(bar.count, 2)
        for (let index = 0; index < bar.count; ++index) {
            const tab = bar.itemAt(index)
            verify(tab.width <= bar.width)
            let close = null
            for (let child = 0; child < tab.children.length; ++child) {
                if (tab.children[child].iconSource === EIcons.XMARK)
                    close = tab.children[child]
            }
            verify(close)
            verify(tab.contentItem.x + tab.contentItem.width <= close.x)
            compare(tab.height, bar.height)
        }
    }

    function test_textButtonDefaultsStayTransparent() {
        const item = createTemporaryObject(textButtonComponent, testCase)
        compare(item.isOpenBackgroundColor, false)
        const originalDark = ETheme.dark
        try {
            mouseMove(testCase, width - 1, height - 1)
            tryCompare(item, "hovered", false)
            for (let dark = 0; dark < 2; ++dark) {
                ETheme.setDark(Boolean(dark))
                item.enabled = true
                item.isOpenBackgroundColor = false
                wait(0)
                compare(item.background.color, EPaletteManager.BasePalette.transparent)
                compare(item.background.border.color, EPaletteManager.BasePalette.transparent)
                item.enabled = false
                wait(0)
                compare(item.background.color, EPaletteManager.BasePalette.transparent)
                item.enabled = true
                item.isOpenBackgroundColor = true
                wait(0)
                compare(item.background.color, EPaletteManager.ThemePalette.surfaceHover(ETheme.dark))
            }
        } finally {
            ETheme.setDark(originalDark)
        }
    }

    function test_tableHeaderAlignsWithCells() {
        const item = createTemporaryObject(tableComponent, testCase)
        waitForRendering(item)
        const headers = namedItems(item, "tableHeader")
        const cells = namedItems(item, "tableCell")
        compare(headers.length, 2)
        compare(cells.length, 2)
        for (let index = 0; index < headers.length; ++index) {
            const header = headers[index].contentItem
            compare(header.horizontalAlignment, cells[index].horizontalAlignment)
            const headerStart = header.mapToItem(item, header.leftPadding, 0).x
            const cellStart = cells[index].mapToItem(item, cells[index].leftPadding, 0).x
            compare(headerStart, cellStart)
            verify(header.width - header.leftPadding - header.rightPadding > 30)
        }
        compare(cells[1].horizontalAlignment, Text.AlignRight)
        mouseClick(headers[0], 20, headers[0].height / 2)
        compare(item.sortProp, "name")
        compare(item.sortOrder, "ascending")
    }

    function test_skeletonContentHeightStaysIndependent() {
        const item = createTemporaryObject(skeletonComponent, testCase)
        waitForRendering(item)
        const label = findChild(item, "skeletonLoadedText")
        verify(label)
        compare(item.implicitHeight, 112)
        compare(label.width, item.availableWidth)
        compare(label.parent.height, label.height)
        for (let cycle = 0; cycle < 3; ++cycle) {
            item.loading = false
            waitForRendering(item)
            compare(item.implicitHeight, label.height)
            compare(label.parent.height, label.height)
            item.loading = true
            waitForRendering(item)
            compare(item.implicitHeight, 112)
        }
        item.loading = false
        const wideHeight = item.implicitHeight
        item.width = 120
        waitForRendering(item)
        compare(label.width, item.availableWidth)
        compare(item.implicitHeight, label.height)
        verify(item.implicitHeight > wideHeight)
        label.height = 0
        waitForRendering(item)
        compare(item.implicitHeight, 0)
        item.loading = true
        item.rows = -1
        waitForRendering(item)
        compare(item.implicitHeight, 16)
    }

    function test_descriptionRowsStretchTogether() {
        const item = createTemporaryObject(descriptionComponent, testCase)
        verify(waitForItemPolished(item.contentItem))
        const cells = [0, 1, 2, 3].map(function(index) {
            return findChild(item, "descriptionCell_" + index)
        })
        verify(cells.every(function(cell) {
            return cell !== null
        }))
        compare(cells[0].height, cells[1].height)
        compare(cells[2].height, cells[3].height)
        compare(cells[2].y, cells[3].y)
        verify(cells[2].height > cells[0].height)
        const wideHeight = cells[2].height
        item.width = 360
        verify(waitForItemPolished(item.contentItem))
        compare(cells[0].height, cells[1].height)
        compare(cells[2].height, cells[3].height)
        verify(cells[2].height > wideHeight)
        verify(item.implicitHeight > cells[2].height)
        item.width = 540
        verify(waitForItemPolished(item.contentItem))
        compare(cells[2].height, wideHeight)
        item.model = []
        verify(waitForItemPolished(item.contentItem))
        verify(isFinite(item.implicitHeight))
        verify(item.implicitHeight >= 0)
    }

    function test_centeredStepsAlignMarkerAndLabels() {
        const item = createTemporaryObject(stepsComponent, testCase)
        waitForRendering(item)
        let firstStep = null
        for (let index = 0; index < item.contentItem.children.length; ++index) {
            if (item.contentItem.children[index].stepIndex === 0)
                firstStep = item.contentItem.children[index]
        }
        verify(firstStep)
        let labels = null
        let marker = null
        for (let index = 0; index < firstStep.children.length; ++index) {
            const child = firstStep.children[index]
            if (child.circle !== undefined)
                marker = child
            if (child.spacing === 6)
                labels = child
        }
        verify(labels)
        verify(marker)
        compare(marker.x + marker.width / 2, labels.x + labels.width / 2)
        let title = null
        for (let index = 0; index < labels.children.length; ++index) {
            if (labels.children[index].text === "Created")
                title = labels.children[index]
        }
        verify(title)
        compare(title.horizontalAlignment, Text.AlignHCenter)
        item.width = 360
        waitForRendering(item)
        compare(marker.x + marker.width / 2, labels.x + labels.width / 2)
    }

    function test_spinBoxReservesSpaceForValueAndIndicators() {
        const item = createTemporaryObject(spinBoxComponent, testCase)
        waitForRendering(item)
        verify(item.contentItem.width >= item.contentItem.implicitWidth)
        verify(item.width >= item.up.indicator.width + item.down.indicator.width
            + item.contentItem.implicitWidth + 2 * item.padding)
        verify(item.contentItem.x >= item.down.indicator.x + item.down.indicator.width)
        verify(item.contentItem.x + item.contentItem.width <= item.up.indicator.x)
        mouseClick(item.up.indicator, item.up.indicator.width / 2, item.up.indicator.height / 2)
        compare(item.value, 3)
        mouseClick(item.down.indicator, item.down.indicator.width / 2, item.down.indicator.height / 2)
        compare(item.value, 2)
        item.size = EStyle.Large
        item.indicatorWidth = 42
        waitForRendering(item)
        verify(item.contentItem.width >= item.contentItem.implicitWidth)
        compare(item.up.indicator.width, 42)
        compare(item.down.indicator.width, 42)
        item.size = EStyle.Medium
        item.indicatorWidth = 32
        item.width = 100
        waitForRendering(item)
        verify(item.contentItem.width >= item.contentItem.implicitWidth)
    }

    function test_textButtonBackgroundStates_data() {
        const cases = [
            {tag: "plain-normal", open: false, interaction: "normal", token: "transparent"},
            {tag: "plain-hover", open: false, interaction: "hover", token: "hover"},
            {tag: "plain-pressed", open: false, interaction: "pressed", token: "pressed"},
            {tag: "plain-disabled", open: false, interaction: "disabled", token: "transparent"},
            {tag: "filled-normal", open: true, interaction: "normal", token: "hover"},
            {tag: "filled-hover", open: true, interaction: "hover", token: "hover"},
            {tag: "filled-pressed", open: true, interaction: "pressed", token: "pressed"},
            {tag: "filled-disabled", open: true, interaction: "disabled", token: "canvas"}
        ]
        const rows = []
        for (let dark = 0; dark < 2; ++dark) {
            const colors = {
                transparent: EPaletteManager.BasePalette.transparent,
                hover: EPaletteManager.ThemePalette.surfaceHover(Boolean(dark)),
                pressed: EPaletteManager.ThemePalette.surfacePressed(Boolean(dark)),
                canvas: EPaletteManager.ThemePalette.fetchThemeColor(Boolean(dark))
            }
            for (let index = 0; index < cases.length; ++index) {
                const entry = cases[index]
                rows.push({tag: (dark ? "dark-" : "light-") + entry.tag, dark: Boolean(dark),
                           open: entry.open, interaction: entry.interaction, expected: colors[entry.token]})
            }
        }
        return rows
    }

    width: 640
    height: 480
    visible: true
    when: windowShown
    name: "ComponentAppearance"

    Component {
        id: textButtonComponent

        ETextButton {
            x: 32
            y: 32
            text: "Text action"
        }
    }
    Component {
        id: skeletonComponent

        ESkeleton {
            width: 320
            animated: true

            EText {
                width: parent.width
                wrapMode: Text.WordWrap
                objectName: "skeletonLoadedText"
                text: "Loaded content keeps its natural height when the skeleton changes size."
            }
        }
    }
    Component {
        id: spinBoxComponent

        ESpinBox {
            to: 20
            value: 2
            from: -20
            editable: true
        }
    }
    Component {
        id: tableComponent

        ETable {
            width: 420
            height: 120
            model: [{name: "Alice", age: 24}]
            columns: [{prop: "name", label: "Name", sortable: true},
                      {prop: "age", label: "Age", align: "right", width: 72}]
        }
    }
    Component {
        id: tabsComponent

        ETabs {
            width: 320
            addable: true
            closable: true
            model: [{text: "Overview"}, {text: "A long title that needs its own close button space"}]
        }
    }
    Component {
        id: stepsComponent

        ESteps {
            width: 600
            alignCenter: true
            model: [{title: "Created"}, {title: "Configured"}, {title: "Complete"}]
        }
    }
    Component {
        id: descriptionComponent

        EDescriptions {
            columns: 2
            width: 540
            model: [{label: "Name", value: "Alice"}, {label: "Status", value: "Active"},
                    {label: "Description", value: "A longer description that wraps over several lines in this row."},
                    {label: "Owner", value: "Bob"}]
        }
    }
}

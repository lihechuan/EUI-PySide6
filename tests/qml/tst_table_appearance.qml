import EUI 1.0
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function cleanup() {
        ETheme.setDark(false)
    }

    function test_themeAndPointerStates_data() {
        return [{ tag: "light", dark: false }, { tag: "dark", dark: true }]
    }

    function namedItems(item, name) {
        let items = item.objectName === name ? [item] : []
        for (let index = 0; index < item.children.length; ++index)
            items = items.concat(namedItems(item.children[index], name))
        return items
    }

    function tableForTest() {
        const table = createTemporaryObject(tableComponent, testCase)
        verify(table !== null)
        const rows = findChild(table, "tableRows")
        tryCompare(rows, "count", table.rowCount)
        verify(waitForItemPolished(rows))
        tryVerify(function() {
            return namedItems(table, "tableRow").length >= table.rowCount
        })
        mouseMove(testCase, width - 5, height - 5)
        return table
    }

    function test_truthySortableKeepsVisibleIndicators() {
        const table = tableForTest()
        table.columns = [{prop: "name", label: "Name", sortable: 1}]
        waitForRendering(table)
        const header = findChild(table, "tableHeader")
        verify(findChild(header, "tableSortAscending").visible)
        verify(findChild(header, "tableSortDescending").visible)
        mouseClick(header, 40, header.height / 2)
        compare(table.sortProp, "name")
        compare(table.sortOrder, "ascending")
    }

    function test_scrollPreservesHeaderAlignmentAndVirtualization() {
        const table = tableForTest()
        table.width = 340
        table.columns = [{prop: "name", label: "Name", width: 240, sortable: true},
            {prop: "score", label: "Score", width: 180, align: "right", sortable: true}]
        const model = []
        for (let index = 0; index < 1000; ++index)
            model.push({ name: "Row " + index, score: index })
        table.model = model
        const rows = findChild(table, "tableRows")
        tryCompare(rows, "count", 1000)
        verify(waitForItemPolished(rows))
        verify(table.contentItem.contentWidth > table.contentItem.width)
        table.contentItem.contentX = 70
        const header = namedItems(table, "tableHeader")[0].contentItem
        const firstRow = namedItems(table, "tableRow").find(function(row) {
            return row.entry.index === 0
        })
        const cell = findChild(firstRow, "tableCell")
        compare(
            header.mapToItem(table, header.leftPadding, 0).x,
            cell.mapToItem(table, cell.leftPadding, 0).x
        )
        verify(namedItems(table, "tableRow").length < 50)
        rows.positionViewAtIndex(999, ListView.End)
        verify(waitForItemPolished(rows))
        tryVerify(function() {
            return namedItems(table, "tableRow").some(function(row) {
                return row.entry.index === 999
            })
        })
        verify(namedItems(table, "tableRow").length < 50)
        const lastRow = namedItems(table, "tableRow").find(function(row) {
            return row.entry.index === 999
        })
        mouseClick(lastRow, 120, lastRow.height / 2)
        compare(table.currentRowIndex, 999)
        compare(table.currentRow.score, 999)
        compare(findChild(lastRow, "tableRowSelection").visible, true)
    }

    function test_themeAndPointerStates(data) {
        ETheme.setDark(data.dark)
        const table = tableForTest()
        compare(table.background.radius, 8)
        compare(table.background.color, EPaletteManager.ThemePalette.surfaceComponent(data.dark))
        const rows = namedItems(table, "tableRow")
        const first = rows.find(function(row) {
            return row.entry.index === 0
        })
        const striped = rows.find(function(row) {
            return row.entry.index === 1
        })
        const disabled = rows.find(function(row) {
            return row.entry.index === 2
        })
        const firstBackground = findChild(first, "tableRowBackground")
        compare(firstBackground.color, table.surfaceColor)
        verify(!Qt.colorEqual(findChild(striped, "tableRowBackground").color, table.surfaceColor))
        mouseMove(first, 40, first.height / 2)
        tryCompare(firstBackground, "color", table.hoverColor)
        mouseClick(first, 40, first.height / 2)
        compare(table.currentRowIndex, 0)
        compare(firstBackground.color, table.selectedColor)
        compare(findChild(first, "tableRowSelection").visible, true)
        verify(!Qt.colorEqual(table.selectedColor, table.hoverColor))
        mouseClick(disabled, 40, disabled.height / 2)
        compare(table.currentRowIndex, 0)
        compare(findChild(disabled, "tableRowSelection").visible, false)
        const disabledCell = findChild(disabled, "tableCell")
        compare(disabledCell.color, EPaletteManager.ThemePalette.textDisabled(data.dark))
        table.clearSelection()
        compare(findChild(first, "tableRowSelection").visible, false)
        table.enabled = false
        mouseClick(first, 40, first.height / 2)
        compare(table.currentRowIndex, -1)
    }

    function test_sortIconsAndFontAlignment() {
        const table = tableForTest()
        table.font.pixelSize = 18
        table.font.family = (Qt.platform.os === "osx" ? "Menlo" : "monospace")
        const headers = namedItems(table, "tableHeader")
        compare(headers.length, 3)
        const cells = namedItems(table, "tableRow").find(function(row) {
            return row.entry.index === 0
        })
        const firstCells = namedItems(cells, "tableCell")
        for (let index = 0; index < headers.length; ++index) {
            compare(headers[index].contentItem.font.pixelSize, 18)
            compare(headers[index].contentItem.font.bold, true)
            compare(headers[index].contentItem.font.family, table.font.family)
            compare(firstCells[index].font.pixelSize, 18)
            compare(firstCells[index].font.family, table.font.family)
            compare(headers[index].contentItem.horizontalAlignment, firstCells[index].horizontalAlignment)
            compare(headers[index].contentItem.mapToItem(table, headers[index].contentItem.leftPadding, 0).x,
                firstCells[index].mapToItem(table, firstCells[index].leftPadding, 0).x)
        }
        const ascending = findChild(headers[0], "tableSortAscending")
        const descending = findChild(headers[0], "tableSortDescending")
        verify(ascending.visible && descending.visible)
        verify(!findChild(headers[2], "tableSortAscending").visible)
        compare(headers[0].text, "Name")
        mouseClick(headers[0], 40, headers[0].height / 2)
        compare(table.sortProp, "name")
        compare(table.sortOrder, "ascending")
        compare(ascending.color, table.accentColor)
        verify(!Qt.colorEqual(descending.color, table.accentColor))
        mouseClick(headers[0], 40, headers[0].height / 2)
        compare(table.sortOrder, "descending")
        compare(descending.color, table.accentColor)
        verify(!Qt.colorEqual(ascending.color, table.accentColor))
        mouseClick(headers[2], 40, headers[2].height / 2)
        compare(table.sortProp, "name")
        compare(table.sortOrder, "descending")
    }

    width: 620
    height: 420
    visible: true
    when: windowShown
    name: "EUITableAppearance"

    Component {
        id: tableComponent

        ETable {
            width: 480
            height: 240
            stripe: true
            model: [{name: "Cedar", score: 24, state: "Ready"},
                {name: "Aspen", score: 8, state: "Ready"},
                {name: "Birch", score: 31, state: "Disabled", disabled: true}]
            columns: [{prop: "name", label: "Name", sortable: true},
                {prop: "score", label: "Score", align: "right", width: 120, sortable: true},
                {prop: "state", label: "State", width: 100}]
        }
    }
}

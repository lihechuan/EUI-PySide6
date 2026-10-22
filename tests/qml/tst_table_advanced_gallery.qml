import EUI 1.0
import "../../example/qml/component" as Gallery
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function example() {
        const result = createTemporaryObject(examples, testCase, {width: 1050})
        verify(result !== null)
        verify(waitForRendering(result))
        return result
    }

    function settle(promise) {
        let completed = false
        let result
        promise.then(function(value) {
            result = value
            completed = true
        })
        tryVerify(function() { return completed }, 5000)
        return result
    }

    function test_sourcesCompile() {
        const panel = example()
        for (const name of ["Editing", "Spreadsheet", "Grouping", "Virtual", "Drag", "Proxy"]) {
            const card = findChild(panel, "advancedCase" + name)
            verify(card !== null, name)
            verify(card.code.indexOf("import EUI") >= 0)
            const item = Qt.createQmlObject(card.code, testCase, "Advanced" + name)
            verify(item !== null)
            item.width = 900
            verify(waitForRendering(item))
            item.destroy()
        }
    }

    function test_fileAndFindDialogs() {
        const panel = example()
        const table = findChild(panel, "advancedSpreadsheetTable")
        const point = table.mapToItem(testCase, 0, 0)
        panel.y += 30 - point.y
        verify(waitForRendering(table))
        const find = findChild(table, "tableFindDialog")
        find.exitDuration = 0
        mouseClick(findChild(table, "tableToolbarFind"))
        tryCompare(find, "opened", true)
        find.close()
        tryCompare(find, "visible", false)
        mouseClick(findChild(table, "tableToolbarExport"))
        const file = findChild(table, "tableFileDialog")
        tryCompare(file, "opened", true)
        file.close()
        table.openContextMenu(table.model[0], table.columnModel[0], 20, 100)
        const menu = findChild(table, "tableContextMenu")
        tryCompare(menu, "opened", true)
        menu.close()
    }

    function test_proxyAndVirtualData() {
        const panel = example()
        const table = findChild(panel, "advancedProxyTable")
        tryCompare(table, "total", 190)
        table.currentPage = table.pageCount
        tryVerify(function() { return !table.loading && table.model[table.model.length - 1].id === 190 })
        table.queryForm = {fail: true}
        verify(!settle(table.commitProxy("query")))
        verify(table.queryError.length > 0)
        table.queryForm = {name: exampleData.models.TableAvatars[0].name}
        verify(settle(table.commitProxy("reload")))
        verify(table.total >= 1)
        const large = findChild(panel, "advancedVirtualTable")
        compare(large.rowCount, 10000)
        compare(large.columnModel.length, 82)
        verify(large.renderColumnIndexes.length < 20)
        large.setScrollLeft(4500)
        tryVerify(function() { return large.renderColumnIndexes.indexOf(40) >= 0 })
    }

    function test_businessPaginationAndRealEditors() {
        const panel = example()
        const table = findChild(panel, "advancedEditingTable")
        compare(table.model.length, 190)
        compare(table.columnModel.length, 8)
        table.currentPage = table.pageCount
        compare(table.displayRows[table.displayRows.length - 1].row.id, 190)
        table.currentPage = 1
        const row = table.model[0]
        verify(table.editCell(row, "department"))
        tryVerify(function() { return findChild(table, "tableEditSelect") !== null })
        const select = findChild(table, "tableEditSelect")
        select.value = "Design"
        select.changed("Design")
        tryCompare(table, "editingCell", null)
        compare(table.model[0].department, "Design")
        verify(table.editCell(table.model[0], "active"))
        tryVerify(function() { return findChild(table, "tableEditCheckbox") !== null })
        const check = findChild(table, "tableEditCheckbox")
        check.checked = !table.model[0].active
        check.clicked()
        tryCompare(table, "editingCell", null)
        verify(table.editCell(table.model[0], "joined"))
        tryVerify(function() { return findChild(table, "tableEditDate") !== null })
        const date = findChild(table, "tableEditDate")
        date.value = "2026-11-01"
        tryCompare(table, "editingCell", null)
        compare(table.model[0].joined, "2026-11-01")
    }

    height: 900
    width: 1100
    visible: true
    when: windowShown
    name: "AdvancedTableGallery"

    Component {
        id: examples

        Gallery.TableAdvancedExamples { }
    }
}

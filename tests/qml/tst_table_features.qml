import EUI 1.0
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    property string clipboard: ""
    property var snapshotRow: null

    function table(properties) {
        const item = createTemporaryObject(tableComponent, testCase, properties || {})
        verify(item !== null)
        verify(waitForRendering(item))
        return item
    }

    function settled(promise) {
        let finished = false
        let result
        promise.then(function(value) { result = value
         finished = true })
        tryVerify(function() { return finished }, 5000)
        return result
    }

    function named(item, name) {
        let result = item.objectName === name ? [item] : []
        const children = item.children || []
        for (let index = 0; index < children.length; ++index)
            result = result.concat(named(children[index], name))
        return result
    }

    function test_clearingRadioDoesNotScanRows() {
        let keyReads = 0
        const item = table({rowKey: function(row) {
            ++keyReads
            return row.id
        }})
        item.radioKey = 2
        compare(item.radioRow.id, 2)
        keyReads = 0
        item.radioKey = undefined
        compare(item.radioRow, null)
        compare(keyReads, 0)
    }

    function test_toolbarReportsFileErrors() {
        const item = table({showToolbar: true})
        item.operationFailed("export", "Cannot write file")
        compare(findChild(item, "tableOperationError").text, "Cannot write file")
        verify(settled(item.setCellValue(item.model[0], "name", "Changed")))
        compare(findChild(item, "tableOperationError").text, "")
    }

    function test_fileDialogUsesLoadedPath() {
        const item = table({showToolbar: true})
        const dialog = findChild(item, "tableFileDialog")
        compare(dialog.loadedContent, null)
        dialog.open()
        tryCompare(dialog, "opened", true)
        const input = findChild(dialog, "tableFilePath")
        verify(input !== null)
        input.text = "file:///"
        compare(dialog.loadedContent.pathText, input.text)
        dialog.accepted()
        verify(findChild(item, "tableOperationError").text.length > 0)
        dialog.close()
    }

    function test_multipleAreasAndFill() {
        const item = table({rangeSelection: true})
        item.selectCell(0, 0, false)
        item.selectCell(1, 1, false, true)
        compare(item.cellAreas.length, 1)
        verify(item.isCellSelected(0, 0))
        verify(item.isCellSelected(1, 1))
        item.selectCell(0, 1, false)
        const source = Object.assign({}, item.cellArea)
        item.selectCell(2, 1, true)
        verify(settled(item.fillCellArea(source)))
        compare(item.model[1].score, 80)
        compare(item.model[2].score, 80)
        item.undo()
        compare(item.model[1].score, 90)
    }

    function test_proxySaveFailuresAndRecordset() {
        let changes
        const item = table({proxyConfig: {save: function(context) {
            changes = context.records
            return true
        }}})
        verify(settled(item.setCellValue(item.model[0], "name", "Changed")))
        verify(settled(item.commitProxy("save")))
        compare(changes.updateRecords.length, 1)
        compare(item.getRecordset().updateRecords.length, 0)
        item.proxyConfig = {save: function() { throw new Error("Save failed") }}
        verify(!settled(item.commitProxy("save")))
        verify(!item.loading)
    }

    function test_horizontalVirtualization() {
        const columns = []
        for (let index = 0; index < 100; ++index)
            columns.push({prop: "c" + index, width: 100, fixed: index === 0 ? "left" : index === 99 ? "right" : false})
        const item = table({width: 450, fit: false, columns: columns})
        verify(item.renderColumnIndexes.length < 12)
        verify(item.renderColumnIndexes.indexOf(0) >= 0)
        verify(item.renderColumnIndexes.indexOf(99) >= 0)
        item.setScrollLeft(5000)
        tryVerify(function() { return item.renderColumnIndexes.indexOf(50) >= 0 })
        verify(item.renderColumnIndexes.indexOf(1) < 0)
    }

    function test_rowEditingIsAtomic() {
        const item = table({editConfig: {mode: "row"}, editRules: {score: [{type: "number", max: 100}]}})
        verify(item.editCell(item.model[0], "name"))
        item.setEditValue(item.columnModel[0], "Changed")
        item.setEditValue(item.columnModel[1], 101)
        verify(!settled(item.commitEdit()))
        compare(item.model[0].name, "Alice")
        item.setEditValue(item.columnModel[1], 99)
        verify(settled(item.commitEdit()))
        compare(item.model[0].name, "Changed")
        compare(item.model[0].score, 99)
        item.undo()
        compare(item.model[0].name, "Alice")
        compare(item.model[0].score, 80)
    }

    function test_asyncValidationDoesNotOverwriteNewModel() {
        const item = table({editRules: {name: [{validator: function(rule, value, done) {
            Qt.callLater(function() { done(value === "Approved" ? undefined : new Error("Rejected")) })
        }}]}})
        const first = item.setCellValue(item.model[0], "name", "Approved")
        item.model = [{id: 20, name: "New", score: 3}]
        verify(!settled(first))
        compare(item.model[0].name, "New")
        verify(!settled(item.setCellValue(item.model[0], "name", "Bad")))
        verify(settled(item.setCellValue(item.model[0], "name", "Approved")))
        compare(item.model[0].name, "Approved")
    }

    function test_crudAndSource() {
        const item = table()
        const inserted = item.insertAt({id: 4, name: "Dora", score: 70}, -1)
        verify(inserted !== false)
        compare(item.rowCount, 4)
        compare(item.getRecordset().insertRecords.length, 1)
        verify(!item.insert({id: 4, name: "Duplicate"}))
        compare(item.remove(item.model[1]).rows.length, 1)
        compare(item.getRecordset().removeRecords[0].id, 2)
        verify(item.revertData())
        compare(item.rowCount, 3)
        compare(item.model[1].id, 2)
        item.model = [{id: 9, name: "External", score: 10}]
        compare(item.undoStack.length, 0)
        compare(item.getRecordset().insertRecords.length, 0)
    }

    function test_keyboardAndRealEditor() {
        const item = table({keyboardNavigation: true, rangeSelection: true})
        item.selectCell(0, 0, false)
        item.forceActiveFocus()
        keyClick(Qt.Key_Right)
        compare(item.cellArea.endColumn, 1)
        keyClick(Qt.Key_Down, Qt.ShiftModifier)
        compare(item.cellArea.endRow, 1)
        compare(item.cellArea.startRow, 0)
        keyClick(Qt.Key_F2)
        tryVerify(function() { return findChild(item, "tableEditInput") !== null })
        const editor = findChild(item, "tableEditInput")
        editor.text = "95"
        editor.textEdited()
        editor.accepted()
        tryCompare(item, "editingCell", null)
        compare(item.model[1].score, 95)
    }

    function test_pagingRadioAndColumnOrder() {
        const item = table({pagination: true, pageSize: 2})
        compare(item.displayRows.length, 2)
        compare(item.pageCount, 2)
        item.currentPage = 2
        compare(item.displayRows.length, 1)
        compare(item.displayRows[0].row.id, 3)
        verify(item.setRadioRow(item.model[2]))
        compare(item.radioRow.id, 3)
        verify(item.setRadioRow(null))
        compare(item.radioRow, null)
        item.currentPage = 1
        verify(item.moveColumn(0, 1))
        compare(item.columnModel[0].prop, "score")
        item.pagination = false
        verify(item.moveRow(0, 2))
        compare(item.model[2].name, "Alice")
        item.undo()
        compare(item.model[0].name, "Alice")
    }

    function test_chartDataIsBuiltOnlyWhenOpened() {
        const item = table({showToolbar: true, columns: [{prop: "name", label: "Name"}, {prop: "score", label: "Score"}]})
        const dialog = findChild(item, "tableChartDialog")
        compare(dialog.loadedContent, null)
        compare(findChild(dialog, "tableChart"), null)
        dialog.open()
        tryCompare(dialog, "opened", true)
        const chart = findChild(dialog, "tableChart")
        verify(chart !== null)
        compare(chart.model.length, item.rowCount)
        compare(chart.model[0].label, "Alice")
        compare(chart.model[0].value, 80)
        dialog.close()
        tryCompare(dialog, "visible", false)
        compare(chart.model.length, 0)
    }

    function test_emptyValidationDoesNotScanRows() {
        let keyReads = 0
        const item = table({rowKey: function(row) {
            ++keyReads
            return row.id
        }})
        keyReads = 0
        compare(item.cellError(item.model[0], item.columnModel[0]), "")
        compare(keyReads, 0)
        item.validationErrors = [{row: item.model[1], column: item.columnModel[1], message: "Invalid score"}]
        compare(item.cellError(item.model[0], item.columnModel[1]), "")
        compare(item.cellError(item.model[1], item.columnModel[0]), "")
        compare(item.cellError(item.model[1], item.columnModel[1]), "Invalid score")
        item.clearValidate()
        keyReads = 0
        compare(item.cellError(item.model[1], item.columnModel[1]), "")
        compare(keyReads, 0)
    }

    function test_findReplaceAndAggregate() {
        const item = table()
        compare(item.findCells("a").length, 4)
        compare(item.findCells("Alice", {wholeCell: true}).length, 1)
        compare(item.findCells("[", {regex: true}).length, 0)
        verify(settled(item.replaceCells("a", "X", {caseSensitive: false})))
        compare(item.model[0].name, "Xlice")
        compare(item.model[2].name, "CXrol")
        compare(item.aggregate("score", "sum"), 240)
        compare(item.aggregate("score", "avg"), 80)
        compare(item.aggregate("score", "min"), 70)
        compare(item.aggregate("score", "max"), 90)
        compare(item.aggregate("name", "count"), 3)
        compare(item.chartData("name", "score")[1].value, 90)
        const pivot = item.pivot("team", "name", "score", "sum")
        compare(pivot.rows.length, 2)
    }

    function test_toolsFollowLocaleChanges() {
        const language = ELocale.language
        try {
            const item = table({showToolbar: true, pagination: true})
            ELocale.language = "en"
            const button = findChild(item, "tableToolbarFind")
            const pager = findChild(item, "tablePagination")
            compare(button.text, ELocale.texts.TableFindReplace)
            compare(item.emptyText, ELocale.texts.NoData)
            compare(pager.localizedTexts.Total1Items, ELocale.texts.Total1Items)
            const english = button.text
            ELocale.language = "zh"
            compare(button.text, ELocale.texts.TableFindReplace)
            compare(item.emptyText, ELocale.texts.NoData)
            compare(pager.localizedTexts.Total1Items, ELocale.texts.Total1Items)
            verify(button.text !== english)
        } finally {
            ELocale.language = language
        }
    }

    function test_cellAreaAndAtomicPaste() {
        const item = table({rangeSelection: true, editRules: {score: [{type: "number", max: 100}]}})
        item.selectCell(0, 0, false)
        item.selectCell(1, 1, true)
        verify(item.isCellSelected(1, 1))
        compare(item.copyCellArea(false), "Alice\t80\nBob\t90")
        compare(clipboard, "Alice\t80\nBob\t90")
        verify(settled(item.pasteCellArea("Ann\t88\nBen\t91")))
        compare(item.model[0].name, "Ann")
        compare(item.model[1].score, 91)
        verify(!settled(item.pasteCellArea("Invalid\t101\nAlso\t4")))
        compare(item.model[0].name, "Ann")
        compare(item.model[1].name, "Ben")
        verify(!settled(item.pasteCellArea('"unterminated')))
        verify(!settled(item.pasteCellArea("a\tb\tc")))
        verify(item.undo())
        compare(item.model[0].name, "Alice")
    }

    function test_tooltipsAreCreatedOnlyWhenUsed() {
        const item = table()
        const cell = findChild(item, "tableCellHost")
        compare(cell.overflowTooltip, null)
        const errorTooltip = findChild(cell, "tableCellErrorTooltip")
        verify(errorTooltip !== null)
        compare(errorTooltip.item, null)
        item.showOverflowTooltip = true
        verify(waitForRendering(item))
        verify(cell.overflowTooltip !== null)
        item.showOverflowTooltip = false
        item.validationErrors = [{row: item.model[0], column: item.columnModel[0], message: "Invalid name"}]
        verify(waitForRendering(item))
        compare(cell.overflowTooltip, null)
        verify(errorTooltip.item !== null)
        compare(errorTooltip.item.text, "Invalid name")
        item.clearValidate()
        verify(waitForRendering(item))
        compare(errorTooltip.item, null)
    }

    function test_initialSnapshotIsCopiedOnce() {
        let reads = 0
        const row = {id: 1, name: "Initial", score: 80}
        Object.defineProperty(row, "snapshotValue", {enumerable: true, get: function() {
            ++reads
            return {value: "Original"}
        }})
        const existing = table({model: []})
        existing.model = [row]
        const singleCopyReads = reads
        verify(singleCopyReads > 0)
        reads = 0
        snapshotRow = row
        const item = createTemporaryObject(snapshotComponent, testCase)
        verify(item !== null)
        compare(reads, singleCopyReads)
        compare(item.sourceRows[0].snapshotValue.value, "Original")
        verify(item.sourceRows[0] !== row)
        item.model = [{id: 2, name: "External", score: 90}]
        compare(item.sourceRows[0].id, 2)
        item.model[0].name = "Changed"
        verify(item.revertData())
        compare(item.model[0].name, "External")
    }

    function test_queryStaleResponseAndErrors() {
        let resolveFirst
        let count = 0
        const item = table({pagination: true, proxyConfig: {query: function(context) {
            ++count
            if (count === 1)
                return new Promise(function(resolve) { resolveFirst = resolve })
            return {rows: [{id: 8, name: "Latest", score: 4}], total: 25}
        }}})
        const pending = item.commitProxy("query")
        verify(item.loading)
        verify(settled(item.commitProxy("query")))
        resolveFirst({rows: [{id: 7, name: "Old", score: 2}], total: 1})
        verify(!settled(pending))
        compare(item.model[0].name, "Latest")
        compare(item.total, 25)
        item.proxyConfig = {query: function() { return Promise.reject(new Error("Offline")) }}
        verify(!settled(item.commitProxy("query")))
        compare(item.queryError, "Offline")
        verify(!item.loading)
        compare(item.model[0].name, "Latest")
    }

    function test_proxySortFiltersAndSinglePageRequest() {
        let calls = 0
        let last
        const item = table({pagination: true, proxyConfig: {query: function(context) {
            ++calls
            last = context
            return {rows: [{id: 4, name: "Server", score: 4}], total: 40}
        }}})
        verify(settled(item.commitProxy("query")))
        item.currentPage = 2
        tryVerify(function() { return !item.loading })
        const before = calls
        verify(settled(item.commitProxy("reload")))
        compare(calls, before + 1)
        item.sort("name", "descending")
        tryVerify(function() { return !item.loading })
        compare(last.sorts[0].prop, "name")
        compare(last.sorts[0].order, "descending")
        item.setFilter("name", ["Absent"])
        tryVerify(function() { return !item.loading })
        compare(last.filters.name[0], "Absent")
        compare(item.displayRows.length, 1)
        compare(item.displayRows[0].row.name, "Server")
    }

    function test_filterContentLoadsOnOpen() {
        const item = table({columns: [{prop: "name", label: "Name", filters: [{text: "Alice", value: "Alice"}]}]})
        const header = findChild(item, "tableHeader")
        const popup = findChild(header, "tableFilterPopup")
        verify(popup !== null)
        compare(popup.contentItem.item, null)
        mouseClick(findChild(header, "tableFilterButton"))
        tryCompare(popup, "opened", true)
        const options = named(popup.contentItem.item, "tableFilterOption")
        compare(options.length, 1)
        mouseClick(options[0])
        compare(item.displayRows.length, 1)
        compare(item.displayRows[0].row.name, "Alice")
        popup.close()
        tryCompare(popup, "visible", false)
        tryCompare(popup.contentItem, "item", null)
        popup.open()
        tryCompare(popup, "opened", true)
        compare(findChild(popup.contentItem.item, "tableFilterOption").checkState, Qt.Checked)
        popup.close()
    }

    function test_multipleSortGroupingAndFooter() {
        const item = table({multiSort: true, groupFields: ["team"], showFooter: true, footerData: [["Total", 240], ["Average", 80]], mergeFooterCells: [{row: 0, col: 0, rowspan: 1, colspan: 2}]})
        verify(item.setSorts([{prop: "team", order: "ascending"}, {prop: "score", order: "descending"}]))
        compare(item.displayRows.filter(function(entry) { return !entry.group }).map(function(entry) { return entry.row.name }), ["Bob", "Alice", "Carol"])
        compare(item.displayRows.length, 5)
        const firstGroup = item.displayRows[0]
        verify(firstGroup.group)
        item.toggleGroup(firstGroup.key)
        compare(item.displayRows.length, 3)
        compare(item.footerHeight, 88)
        const summaries = named(item, "tableSummaryCell")
        verify(summaries.length > 0)
        compare(summaries[0].width, item.columnWidth(0) + item.columnWidth(1))
        verify(!item.moveRow(0, 1))
    }

    function test_editValidationAndHistory() {
        const item = table({editRules: {name: [{required: true}], score: [{type: "number", min: 0, max: 100}]}})
        verify(item.editCell(item.model[0], "name"))
        item.editValue = ""
        verify(!settled(item.commitEdit()))
        compare(item.model[0].name, "Alice")
        compare(item.validationErrors.length, 1)
        verify(item.editingCell !== null)
        item.editValue = "Ada"
        verify(settled(item.commitEdit()))
        compare(item.model[0].name, "Ada")
        verify(item.canUndo)
        compare(item.getRecordset().updateRecords.length, 1)
        verify(item.undo())
        compare(item.model[0].name, "Alice")
        verify(item.redo())
        compare(item.model[0].name, "Ada")
        verify(!settled(item.setCellValue(item.model[0], "score", "NaN")))
        verify(!settled(item.setCellValue(item.model[0], "score", 101)))
        compare(item.model[0].score, 80)
        verify(settled(item.setCellValue(item.model[0], "score", "96")))
        compare(item.model[0].score, 96)
    }

    function test_cellControlsAreCreatedOnlyWhenUsed() {
        const item = table()
        for (const name of ["tableRowRadio", "tableRowCheckbox", "tableExpandButton"])
            compare(named(item, name).length, 0)
        item.columns = [{type: "selection", width: 52}, {type: "radio", width: 52},
            {type: "expand", width: 52}, {prop: "name", label: "Name"}]
        verify(waitForRendering(item))
        for (const name of ["tableRowRadio", "tableRowCheckbox", "tableExpandButton"])
            compare(named(item, name).length, item.rowCount)
        mouseClick(findChild(item, "tableRowCheckbox"))
        compare(item.selectedRows.length, 1)
        mouseClick(findChild(item, "tableRowRadio"))
        compare(item.radioRow.id, item.model[0].id)
        mouseClick(findChild(item, "tableExpandButton"))
        verify(item.isExpanded(item.model[0].id))
        item.columns = [{prop: "name", label: "Name"}]
        verify(waitForRendering(item))
        for (const name of ["tableRowRadio", "tableRowCheckbox", "tableExpandButton"])
            compare(named(item, name).length, 0)
    }

    function test_exportImportRoundTripAndGuards() {
        const item = table()
        const source = item.exportText({type: "json", mode: "all"})
        verify(settled(item.importText(source, {type: "json"})))
        compare(item.rowCount, 3)
        const csv = item.exportText({type: "csv"})
        verify(csv.indexOf("name,score,team") === 0)
        verify(settled(item.importText(csv)))
        compare(item.model[1].score, 90)
        verify(!settled(item.importText("unknown\n1")))
        compare(item.rowCount, 3)
        const escaped = 'name,score,team\r\n"Comma, and ""quote""",25,A\r\n"Two\nlines",30,B'
        const loose = table({rowKey: ""})
        verify(settled(loose.importText(escaped)))
        compare(loose.model[0].name, 'Comma, and "quote"')
        compare(loose.model[1].name, "Two\nlines")
        verify(loose.exportText({type: "html"}).indexOf("<table>") >= 0)
        verify(loose.exportText({type: "xml"}).indexOf("<Workbook") >= 0)
        verify(!settled(loose.importText('[null]', {type: "json"})))
        verify(!settled(loose.setCellValue(loose.model[0], "__proto__.polluted", "yes")))
    }

    function test_deepTreeEditingAndNestedImportRules() {
        let root = {id: 2001, name: "Leaf", score: 1}
        for (let index = 2000; index >= 1; --index)
            root = {id: index, name: "Node", score: 2, children: [root]}
        const item = table({model: []})
        item.model = [root]
        verify(settled(item.setCellValue(2001, "name", "Changed leaf")))
        compare(item.rowEntry(2001).row.name, "Changed leaf")
        item.undo()
        compare(item.rowEntry(2001).row.name, "Leaf")
        compare(item.remove(2001).rows.length, 1)
        compare(item.rowEntry(2001), null)
        item.undo()
        compare(item.rowEntry(2001).row.name, "Leaf")
        item.editRules = {name: [{required: true}]}
        verify(!settled(item.importText('[{"id":1,"name":"Parent","children":[{"id":2,"name":""}]}]', {type: "json"})))
        verify(!settled(item.importText('[{"id":1,"name":"Parent","children":[{"id":1,"name":"Duplicate"}]}]', {type: "json"})))
        verify(!item.selectCell(0.5, 0, false))
        verify(!item.setSorts([null]))
        verify(!item.setSorts([{prop: "name", order: "ascending"}, {prop: "name", order: "descending"}]))
    }

    function test_closedToolsDoNotCreateContent() {
        const item = table()
        compare(findChild(item, "tableToolbarFind"), null)
        compare(findChild(item, "tableFindInput"), null)
        compare(findChild(item, "tableSelectAll"), null)
        compare(findChild(item, "tableChart"), null)
        compare(findChild(item, "tablePagination"), null)
        item.pagination = true
        verify(findChild(item, "tablePagination") !== null)
        item.pagination = false
        tryVerify(function() { return findChild(item, "tablePagination") === null })
        const popup = findChild(item, "tableColumnSettingsPopup")
        compare(named(popup.contentItem, "tableColumnVisibility").length, 0)
        item.showToolbar = true
        verify(findChild(item, "tableToolbarFind") !== null)
        const dialog = findChild(item, "tableFindDialog")
        dialog.open()
        tryCompare(dialog, "opened", true)
        verify(findChild(dialog, "tableFindInput") !== null)
        dialog.close()
        popup.open()
        tryCompare(popup, "opened", true)
        compare(named(popup.contentItem, "tableColumnVisibility").length, item.allColumns.length)
        popup.close()
        tryCompare(popup, "visible", false)
        compare(named(popup.contentItem, "tableColumnVisibility").length, 0)
        item.showToolbar = false
        tryVerify(function() { return findChild(item, "tableToolbarFind") === null })
        item.showToolbar = true
        compare(findChild(item, "tableFindDialog"), dialog)
        item.showToolbar = false
        item.openContextMenu(item.model[0], item.columnModel[0], 20, 100)
        const menu = findChild(item, "tableContextMenu")
        tryCompare(menu, "opened", true)
        verify(named(menu.contentItem, "tableContextCommand").length > 0)
        menu.close()
    }

    height: 750
    width: 1000
    visible: true
    when: windowShown
    name: "TableFeatures"

    Component {
        id: snapshotComponent

        ETable {
            width: 490
            height: 220
            keepSource: true
            model: [testCase.snapshotRow]
        }
    }
    Component {
        id: tableComponent

        ETable {
            width: 760
            height: 400
            rowKey: "id"
            editable: true
            keepSource: true
            clipboardProvider: ({setText: function(value) { testCase.clipboard = value
             return true }, text: function() { return testCase.clipboard }})
            model: [{id: 1, name: "Alice", score: 80, team: "A"}, {id: 2, name: "Bob", score: 90, team: "A"},
                {id: 3, name: "Carol", score: 70, team: "B"}]
            columns: [{prop: "name", label: "Name", editable: true, sortable: true},
                {prop: "score", label: "Score", sortable: true, editRender: {type: "number"}},
                {prop: "team", label: "Team", editable: true, sortable: true}]
        }
    }
}

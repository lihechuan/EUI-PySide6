import EUI 1.0
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    property string formatterPrefix: "Value: "

    function test_badgeVisibilityAndLimit() {
        verify(!badge.badgeVisible)
        badge.showZero = true
        verify(badge.badgeVisible)
        badge.value = 120
        compare(badge.displayValue, "99+")
        badge.value = "new"
        compare(badge.displayValue, "new")
        badge.hidden = true
        verify(!badge.badgeVisible)
        badge.hidden = false
        badge.value = null
        verify(!badge.badgeVisible)
        badge.isDot = true
        verify(badge.badgeVisible)
    }

    function test_pointerSelectionAndAvatarLoading() {
        table.visible = true
        table.sortOrder = ""
        table.sortProp = ""
        wait(30)
        mouseClick(table, 20, table.headerHeight + table.rowHeight / 2)
        compare(table.currentRowIndex, 0)
        avatar.source = Qt.resolvedUrl("../../assets/eui-mark.svg")
        tryCompare(avatar, "loaded", true)
        verify(avatar.width > 0)
        compare(avatar.width, avatar.height)
        table.visible = false
    }

    function init() {
        testCase.visible = true
        table.visible = false
        tree.visible = false
        pagination.enabled = true
        pagination.total = 256
        pagination.pageSize = 10
        pagination.pagerCount = 7
        pagination.currentPage = 1
        table.enabled = true
        table.currentRowIndex = -1
        table.sortOrder = ""
        table.sortProp = ""
        table.model = [{
            "name": "A",
            "age": 24
        }, {
            "name": "B",
            "age": 8
        }, {
            "name": "C",
            "age": 24,
            "disabled": true
        }]
        tree.enabled = true
        tree.currentKey = ""
        tree.expandedKeys = []
        badge.value = 0
        badge.showZero = false
        badge.hidden = false
        badge.isDot = false
        rowSpy.clear()
        pageSpy.clear()
        nodeSpy.clear()
    }

    function test_treeExpansionAndDisabledNodes() {
        compare(tree.visibleNodes.length, 2)
        const nodes = tree.allNodes
        tree.expandedKeys = null
        verify(!tree.isExpanded("root"))
        verify(tree.toggle("root"))
        compare(tree.visibleNodes.length, 4)
        verify(tree.allNodes === nodes)
        verify(tree.setExpanded("branch", true))
        compare(tree.visibleNodes.length, 5)
        verify(tree.select("leaf"))
        compare(tree.currentNode.label, "Leaf")
        compare(nodeSpy.count, 1)
        verify(!tree.select("disabled"))
        verify(!tree.select("disabled-child"))
        verify(!tree.toggle("leaf"))
        verify(tree.setExpanded("root", false))
        compare(tree.visibleNodes.length, 2)
        tree.enabled = false
        verify(!tree.toggle("root"))
        tree.model = []
        compare(tree.visibleNodes.length, 0)
        compare(tree.currentKey, "")
    }

    function test_paginationBoundsAndSignals() {
        compare(pagination.pageCount, 26)
        verify(pagination.setPage(12))
        compare(pagination.currentPage, 12)
        compare(pageSpy.count, 1)
        verify(pagination.pages.indexOf(12) >= 0)
        verify(pagination.pages.indexOf(0) >= 0)
        pagination.pagerCount = 1000000
        verify(pagination.pages.length <= 23)
        verify(pagination.setPage(999))
        compare(pagination.currentPage, 26)
        verify(!pagination.setPage(26))
        verify(!pagination.setPage(NaN))
        pagination.total = 5
        compare(pagination.currentPage, 1)
        pagination.pageSize = 0
        compare(pagination.effectivePageSize, 1)
        compare(pagination.pageCount, 5)
        pagination.enabled = false
        verify(!pagination.setPage(2))
        pagination.total = -100
        compare(pagination.pageCount, 1)
        compare(pagination.currentPage, 1)
    }

    function test_tableSortingRetainsSourceSelection() {
        const columns = table.columns
        table.columns = [null].concat(columns)
        const layout = table.columnLayout
        verify(table.sort("age", "ascending"))
        verify(table.columnLayout === layout)
        table.columns = columns
        compare(table.displayRows.map(function(entry) {
            return entry.index
        }), [1, 0, 2])
        verify(table.selectRow(table.displayRows[0].index))
        compare(table.currentRow.name, "B")
        compare(rowSpy.count, 1)
        verify(table.sort("age", "descending"))
        compare(table.displayRows.map(function(entry) {
            return entry.index
        }), [0, 2, 1])
        compare(table.currentRow.name, "B")
        verify(!table.selectRow(2))
        verify(!table.selectRow(-1))
        verify(!table.selectRow(NaN))
        verify(!table.selectRow(0.5))
        verify(!table.sort("name", "ascending"))
        table.enabled = false
        verify(!table.selectRow(0))
        table.model = []
        compare(table.rowCount, 0)
        compare(table.currentRowIndex, -1)
        compare(table.currentRow, null)
    }

    function test_nativeLargeAndDeepModels() {
        const rows = []
        const nodes = []
        for (let index = 0; index < 100000; ++index) {
            rows.push({ value: 100000 - index })
            nodes.push({ id: String(index), label: "Node " + index })
        }
        let started = Date.now()
        const sorted = EDataUtils.tableRows(rows, "value", "ascending")
        compare(sorted.length, 100000)
        compare(sorted[0].row.value, 1)
        compare(sorted[99999].row.value, 100000)
        console.log("native table 100000 sort ms", Date.now() - started)
        started = Date.now()
        const flat = EDataUtils.treeNodes(nodes, [], false)
        compare(flat.length, 100000)
        console.log("native tree 100000 flatten ms", Date.now() - started)
        let deep = { id: "2000", label: "Leaf" }
        for (let level = 1999; level >= 0; --level)
            deep = { id: String(level), label: String(level), children: [deep] }
        started = Date.now()
        const entries = EDataUtils.treeNodes([deep], [], false)
        compare(entries.length, 2001)
        compare(entries[2000].level, 2000)
        verify(entries[0].node === deep)
        console.log("native tree depth 2000 ms", Date.now() - started)
        let anonymous = { label: "Leaf" }
        for (let level = 999; level >= 0; --level)
            anonymous = { children: [anonymous] }
        started = Date.now()
        const anonymousEntries = EDataUtils.treeNodes([anonymous], [], false)
        compare(anonymousEntries.length, 1001)
        compare(anonymousEntries[1000].key.split("-").length, 1001)
        console.log("native anonymous tree depth 1000 ms", Date.now() - started)
    }

    function test_nativeAlgorithmsPreserveReferences() {
        const rows = [{ value: 2 }, { value: 10 }, { value: "11" }, { value: NaN }, {}]
        const ascending = EDataUtils.tableRows(rows, "value", "ascending")
        compare(ascending.map(function(entry) {
            return entry.index
        }), [0, 1, 2, 3, 4])
        verify(ascending[0].row === rows[0])
        const descending = EDataUtils.tableRows(rows, "value", "descending")
        compare(descending.map(function(entry) {
            return entry.index
        }), [3, 4, 2, 1, 0])
        compare(EDataUtils.tableRows(null, "value", "ascending").length, 0)
        const formatter = { prop: "value", formatter: function(row, value) {
            return testCase.formatterPrefix + value
        } }
        compare(table.cellText(rows[0], formatter), "Value: 2")
        compare(formatterText.text, "Value: 2")
        formatterPrefix = "Updated: "
        compare(table.cellText(rows[0], formatter), "Updated: 2")
        compare(formatterText.text, "Updated: 2")
        formatterPrefix = "Value: "
        compare(table.cellText({}, { prop: "value" }), "")
        const layout = EDataUtils.columnWidths([{ width: 20 }, {}, { width: 120 }], 500)
        compare(layout.widths, [40, 340, 120])
        compare(layout.total, 500)
        const fallback = EDataUtils.treeNodes([{ children: [{ label: "Child" }] }], [], false)
        compare(fallback.map(function(entry) {
            return entry.key
        }), ["0", "0-0"])
        verify(EDataUtils.treeVisibleNodes(fallback, ["0"]) === fallback)
        compare(EDataUtils.treeVisibleNodes(fallback, []).length, 1)
        compare(EDataUtils.treeVisibleNodes(null, []).length, 0)
        const cyclic = { id: "cycle", label: "Cycle" }
        cyclic.children = [cyclic]
        compare(EDataUtils.treeNodes([cyclic], [], false).length, 1)
    }

    function test_virtualizedLargeModels() {
        const rows = []
        const nodes = []
        for (let index = 0; index < 100000; ++index) {
            rows.push({ name: "Row " + index, age: index })
            nodes.push({ id: String(index), label: "Node " + index })
        }
        table.model = rows
        table.visible = true
        tree.model = nodes
        tree.visible = true
        tree.height = 360
        const tableView = findChild(table, "tableRows")
        const treeView = findChild(tree, "treeRows")
        tryCompare(tableView, "count", 100000)
        tryCompare(treeView, "count", 100000)
        wait(30)
        verify(tableView.contentItem.children.length > 0)
        verify(tableView.contentItem.children.length < 100)
        verify(treeView.contentItem.children.length > 0)
        verify(treeView.contentItem.children.length < 100)
        console.log(
            "virtual 100000 delegate counts",
            tableView.contentItem.children.length,
            treeView.contentItem.children.length
        )
        tableView.positionViewAtIndex(99999, ListView.End)
        treeView.positionViewAtIndex(99999, ListView.End)
        wait(30)
        verify(tableView.contentItem.children.length < 100)
        verify(treeView.contentItem.children.length < 100)
        verify(table.selectRow(99999))
        compare(table.currentRow.age, 99999)
        verify(tree.select("99999"))
        compare(tree.currentNode.label, "Node 99999")
        for (let cycle = 0; cycle < 3; ++cycle) {
            table.enabled = false
            tree.enabled = false
            verify(!table.selectRow(0))
            verify(!tree.select("0"))
            table.enabled = true
            tree.enabled = true
            verify(table.selectRow(99999 - cycle))
            verify(tree.select(String(99999 - cycle)))
        }
        table.model = []
        tree.model = []
        compare(table.currentRowIndex, -1)
        compare(tree.currentKey, "")
        verify(!table.selectRow(0))
        verify(!tree.select("0"))
        table.visible = false
        tree.visible = false
    }

    width: 700
    height: 500
    name: "EUIData"
    when: windowShown

    ETable {
        id: table

        width: 300
        visible: false
        columns: [{
            "prop": "name",
            "label": "Name"
        }, {
            "prop": "age",
            "label": "Age",
            "sortable": true
        }]
    }
    EText {
        id: formatterText

        visible: false
        text: table.cellText({ value: 2 }, { prop: "value", formatter: function(row, value) {
            return testCase.formatterPrefix + value
        } })
    }
    ETree {
        id: tree

        visible: false
        model: [{
            "id": "root",
            "label": "Root",
            "children": [{
                "id": "branch",
                "label": "Branch",
                "children": [{
                    "id": "leaf",
                    "label": "Leaf"
                }]
            }, {
                "id": "sibling",
                "label": "Sibling"
            }]
        }, {
            "id": "disabled",
            "label": "Disabled",
            "disabled": true,
            "children": [{
                "id": "disabled-child",
                "label": "Child"
            }]
        }]
    }
    EPagination {
        id: pagination

        visible: false
    }
    EBadge {
        id: badge
    }
    ETag {
        text: "Tag"
    }
    EAvatar {
        id: avatar

        x: 20
        y: 20
        text: "EU"
    }
    ECard {
        visible: false

        EText {
            text: "Card"
        }
    }
    EEmpty {
        visible: false
    }
    ESkeleton {
        visible: false
    }
    SignalSpy {
        id: rowSpy

        target: table
        signalName: "rowClicked"
    }
    SignalSpy {
        id: pageSpy

        target: pagination
        signalName: "currentChange"
    }
    SignalSpy {
        id: nodeSpy

        target: tree
        signalName: "nodeSelected"
    }
}

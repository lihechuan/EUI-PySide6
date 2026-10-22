import EUI 1.0
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function tableForTest(properties) {
        const table = createTemporaryObject(tableComponent, testCase, properties || {})
        verify(table !== null)
        verify(waitForItemPolished(table))
        return table
    }

    function test_rowStyleHeight() {
        const t=tableForTest({rowStyle:{height:80}})
        const row=findChild(t,"tableRow")
        const cell=findChild(row,"tableCell")
        compare(row.height,80)
        compare(cell.height,80)
    }

    function childrenNamed(item,name) {
        let result=[]
        if(item.objectName===name)
            result.push(item)
        for(let i=0;i<item.children.length;++i)
            result=result.concat(childrenNamed(item.children[i],name))
        return result
    }

    function test_currentRowIndependentFromCheckboxSelectable() {
        const t=tableForTest({columns:[{type:"selection",selectable:function(){
            return false
        }},{prop:"name"}]})
        verify(t.selectRow(0))
        t.clearSelection()
        verify(t.setCurrentRow(t.model[0]))
    }

    function test_unkeyedResizeSurvivesHide() {
        const t=tableForTest({fit:false,columns:[{label:"A",width:180},{label:"B",width:120}]})
        verify(t.resizeColumn(1,320))
        compare(t.columnWidth(1),320)
        verify(t.setColumnVisible("0",false))
        compare(t.columnWidth(0),320)
    }

    function test_lazyReservedStringKey() {
        const t=tableForTest({rowKey:"id",lazy:true,model:[{id:"toString",name:"A",hasChildren:true}]})
        let calls=0
        t.load = function(row, node, resolve) {
            ++calls
            resolve([{id: "leaf", name: "Leaf"}])
        }
        verify(t.toggleRowExpansion(t.model[0],true))
        compare(calls,1)
    }

    function test_tooltipRawValue() {
        let captured=null
        const t = tableForTest({showOverflowTooltip: true, columns: [{prop: "score", formatter: function(row, value) {
            return "$" + value
        }}],
            tooltipFormatter: function(context) {
                captured = context.cellValue
                return ""
            }})
        verify(captured!==null)
        compare(typeof captured,"number")
    }

    function test_collapsedTreeSelectAll() {
        const t=tableForTest({rowKey:"id", treeProps:{children:"children",checkStrictly:false}, columns:[{type:"selection"},{prop:"name"}], model:[{id:"a",name:"A",children:[{id:"a1",name:"A1"}]}]})
        t.toggleAllSelection()
        compare(t.selectedRows.map(function(r){
            return r.id
        }),["a","a1"])
    }

    function test_spanValidationAndEmptyFilter() {
        const table = tableForTest()
        table.spanMethod = function(context) {
            return context.rowIndex === 0 ? [2, 2] : [0, 0]
        }
        compare(table.cellSpan(table.displayRows[0], table.columns[0], 0, 0), {rowspan: 2, colspan: 2})
        compare(table.cellSpan(table.displayRows[1], table.columns[0], 1, 0), {rowspan: 0, colspan: 0})
        table.setFilter("name", ["Not found"])
        compare(table.displayRows.length, 0)
    }

    function test_mergedCellAfterVirtualScroll() {
        const rows=[]
        for(let i=0;i<120;++i)
            rows.push({name:"Row "+i,score:i})
        const t=tableForTest({height:180,model:rows,spanMethod:function(c){
            return c.columnIndex===0 ? c.rowIndex===5 ? [60,1]
                : c.rowIndex>5 && c.rowIndex<65 ? [0,0]
                : [1,1]
                : [1,1]
        }})
        t.setScrollTop(44*30)
        verify(waitForItemPolished(findChild(t,"tableRows")))
        const instantiated=childrenNamed(t,"tableRow")
        verify(instantiated.some(function(r){
            return r.displayIndex===5
        }),"Merged origin must still render while covered rows are visible")
    }

    function test_nestedValuesAndFormatterCompatibility() {
        const table = tableForTest()
        const row = {user: {name: "Cedar"}}
        compare(table.cellText(row, {prop: "user.name"}, 2), "Cedar")
        compare(table.cellText(row, {prop: "user.name", formatter: function(row, value) {
            return "old:" + value
        }}, 2), "old:Cedar")
        compare(table.cellText(row, {prop: "user.name", formatter: function(row, column, value, index) {
            return index + ":" + value
        }}, 2), "2:Cedar")
        compare(table.cellText(row, {type: "index", index: 10}, 2), "12")
        compare(table.cellText(row, {type: "index", index: function(index) {
            return index * 2
        }}, 2), "4")
    }

    function test_headerDrag() {
        const t=tableForTest({fit:false,columns:[{prop:"name",label:"Name",width:180},{prop:"score",width:200}]})
        const header=findChild(t,"tableHeader")
        let handle=null
        for(let i=0;i<header.children.length;++i)
            if(header.children[i].cursorShape===Qt.SplitHCursor)
                handle=header.children[i]
        verify(handle!==null)
        const start=handle.mapToItem(t,3,10)
        let events=0
        t.headerDragend.connect(function(){
            ++events
        })
        mousePress(t,start.x,start.y)
        mouseMove(t,start.x+20,start.y)
        wait(0)
        mouseMove(t,start.x+40,start.y)
        wait(0)
        mouseRelease(t,start.x+40,start.y)
        compare(t.columnWidth(0),220)
        compare(events,1)
    }

    function test_expandGuardAndPreservedContent() {
        const table = tableForTest({rowExpandable: function(row) {
            return row.score > 10
        },
            expandDelegate: expansionComponent, preserveExpandedContent: true})
        verify(!table.toggleRowExpansion(table.model[1], true))
        verify(table.toggleRowExpansion(table.model[0], true))
        tryVerify(function() {
            return findChild(table, "tableExpansionFixture") !== null
        })
        const content = findChild(table, "tableExpansionFixture")
        content.stateValue = 42
        verify(table.toggleRowExpansion(table.model[0], false))
        verify(table.toggleRowExpansion(table.model[0], true))
        compare(content.stateValue, 42)
    }

    function test_groupedHeadersAndFixedColumns() {
        const table = tableForTest()
        table.width = 300
        table.columns = [{label: "Identity", fixed: "left", children: [{prop: "name", label: "Name", width: 180}]},
            {prop: "score", width: 200}, {prop: "status", width: 100, fixed: "right"}]
        compare(table.columnTree.depth, 2)
        compare(table.columnModel.length, 3)
        compare(table.columnModel[0].fixed, "left")
        table.setScrollLeft(100)
        compare(table.columnX(0), table.scrollLeft)
        compare(table.columnX(1), 180)
        compare(table.columnX(2), table.scrollLeft + table.availableWidth - 100)
        verify(table.setColumnVisible("name", false))
        compare(table.columnModel.length, 2)
    }

    function test_realColumnSettingsPopup() {
        const table = tableForTest()
        table.showColumnSettings = true
        verify(waitForItemPolished(table))
        const button = findChild(table, "tableColumnSettingsButton")
        mouseClick(button)
        wait(40)
        const controls = []
        function visit(item) {
            if (item.objectName === "tableColumnVisibility")
                controls.push(item)
            for (let index = 0; index < item.children.length; ++index)
                visit(item.children[index])
        }
        visit(findChild(table, "tableColumnSettingsPopup").contentItem)
        verify(controls.length === 2)
        compare(controls[1].checkState, Qt.Checked)
        mouseClick(controls[1], 16, controls[1].height / 2)
        compare(table.columnModel.length, 1)
    }

    function test_customAndRemoteSort() {
        const table = tableForTest()
        table.columns = [{prop: "name", sortable: true, sortBy: function(row) {
            return row.name.length
        }}]
        table.sort("name", "ascending")
        compare(table.displayRows.map(function(entry) {
            return entry.row.name
        }), ["Cedar", "Aspen", "Disabled"])
        table.columns = [{prop: "score", sortable: true, sortMethod: function(a, b) {
            return b.score - a.score
        }}]
        table.sort("score", "ascending")
        compare(table.displayRows[0].row.name, "Disabled")
        table.columns = [{prop: "score", sortable: "custom"}]
        table.sort("score", "ascending")
        compare(table.displayRows.map(function(entry) {
            return entry.index
        }), [0, 1, 2])
    }

    function test_tooltipOptionsAndHiddenGroupedUnkeyedColumn() {
        const table = tableForTest({showOverflowTooltip: true,
            tooltipOptions: {offset: 22, placement: "bottom-end", showArrow: false, enterable: false},
            columns: [{label: "Group", children: [{label: "Hidden", visible: false}, {prop: "name", width: 90}]}]})
        verify(table.setColumnVisible("0", true))
        compare(table.columnModel.length, 2)
        tryVerify(function() {
            return findChild(table, "tableCellHost") !== null
        })
        const tooltip = findChild(table, "tableCellHost").overflowTooltip
        compare(tooltip.offset, 22)
        compare(tooltip.placement, EPlacement.BottomRight)
        verify(!tooltip.showArrow)
        verify(!tooltip.enterable)
    }

    function test_columnVisibilityAndWidth() {
        const table = tableForTest()
        verify(table.setColumnVisible("score", false))
        compare(table.columnModel.map(function(column) {
            return column.prop
        }), ["name"])
        verify(table.setColumnVisible("score", true))
        compare(table.columnModel.length, 2)
        verify(!table.setColumnVisible("missing", true))
        table.columns = [{prop: "name", minWidth: 250}, {prop: "score", minWidth: 200}]
        table.width = 200
        compare(table.columnLayout.widths, [250, 200])
        verify(table.resizeColumn(0, 320))
        compare(table.columnWidth(0), 320)
        verify(!table.resizeColumn(0, NaN))
        table.hiddenColumns = ["name", "score"]
        compare(table.columnModel.length, 0)
        compare(table.columnLayout.total, 0)
    }

    function test_checkboxSelectionAndDisabledRows() {
        const table = tableForTest()
        table.columns = [{type: "selection", width: 50, selectable: function(row) {
            return row.score > 10
        }},
            {prop: "name", label: "Name"}]
        verify(!table.toggleRowSelection(table.model[1], true))
        verify(!table.toggleRowSelection(table.model[2], true))
        verify(table.toggleRowSelection(table.model[0], true))
        compare(table.getSelectionRows(), [table.model[0]])
        verify(table.allSelected)
        table.toggleAllSelection()
        compare(table.getSelectionRows().length, 0)
        verify(table.toggleRowSelection(table.model[1], true, true))
        compare(table.getSelectionRows().length, 1)
        table.clearSelection()
        compare(table.getSelectionRows().length, 0)
    }

    function test_noncontiguousFixedColumns() {
        const table = tableForTest({fit: false, width: 300,
            columns: [{prop: "index", width: 56}, {prop: "action", width: 100, fixed: "right"},
                {prop: "name", width: 150, fixed: "left"}, {prop: "score", width: 200}]})
        compare(table.columnModel.map(function(column) {
            return column.prop
        }), ["name", "index", "score", "action"])
        compare(table.columnX(1), 150)
        table.setScrollLeft(100)
        compare(table.columnX(0), table.scrollLeft)
        compare(table.columnX(1), 150)
        compare(table.columnX(3), table.scrollLeft + table.availableWidth - 100)
        verify(table.setColumnVisible("name", false))
        compare(table.columnModel.map(function(column) {
            return column.prop
        }), ["index", "score", "action"])
    }

    function test_treeFilteringKeepsAncestorsAndDeepRows() {
        const table = tableForTest()
        table.rowKey = "id"
        table.model = [{id: 1, name: "Parent", children: [{id: 2, name: "Match"}, {id: 3, name: "Other"}]},
            {id: 4, name: "Other root"}]
        table.setFilter("name", ["Match"])
        compare(table.displayRows.map(function(entry) {
            return entry.row.id
        }), [1, 2])
        table.clearFilter()
        compare(table.displayRows.length, 2)
        let tree = {id: 2000, name: "Deep leaf"}
        for (let index = 1999; index >= 0; --index)
            tree = {id: index, name: "Node", children: [tree]}
        table.model = [tree]
        table.defaultExpandAll = true
        compare(table.displayRows.length, 2001)
        table.toggleRowSelection(tree, true)
        table.toggleRowSelection(tree, true)
        compare(table.selectionCache.length, 1)
    }

    function test_preservedExpansionSurvivesVirtualScroll() {
        const rows = []
        for (let index = 0; index < 100; ++index)
            rows.push({id: index, name: "Row " + index, score: index})
        const table = tableForTest({rowKey: "id", model: rows, expandDelegate: expansionComponent, preserveExpandedContent: true})
        verify(table.toggleRowExpansion(rows[0], true))
        let content = findChild(table, "tableExpansionFixture")
        verify(content !== null)
        content.stateValue = 73
        table.setScrollTop(44 * 80)
        verify(waitForItemPolished(findChild(table, "tableRows")))
        table.setScrollTop(0)
        verify(waitForItemPolished(findChild(table, "tableRows")))
        tryVerify(function() {
            return findChild(table, "tableExpansionFixture") !== null
        })
        content = findChild(table, "tableExpansionFixture")
        compare(content.stateValue, 73)
    }

    function test_filtersSortAndStableSelection() {
        const table = tableForTest()
        table.columns = [{prop: "name", label: "Name", filters: [{text: "Cedar", value: "Cedar"}],
            filterMethod: function(value, row) {
                return row.name === value
            }},
            {prop: "score", label: "Score", sortable: true}]
        verify(table.setFilter("name", ["Cedar"]))
        compare(table.displayRows.length, 1)
        compare(table.displayRows[0].index, 0)
        table.selectRow(0)
        verify(table.sort("score", "ascending"))
        compare(table.currentRow.name, "Cedar")
        table.clearFilter()
        compare(table.displayRows.map(function(entry) {
            return entry.index
        }), [1, 0, 2])
        table.clearSort()
        compare(table.displayRows.map(function(entry) {
            return entry.index
        }), [0, 1, 2])
        compare(table.nextSortOrder("score"), "ascending")
        table.sort("score", "descending")
        compare(table.nextSortOrder("score"), "")
    }

    function test_reservedSelectionAcrossPagesAndTreeCheck() {
        const table = tableForTest()
        table.rowKey = "id"
        table.columns = [{type: "selection", reserveSelection: true}, {prop: "name"}]
        const first = {id: 1, name: "Page one"}
        const second = {id: 2, name: "Page two"}
        table.model = [first]
        table.toggleRowSelection(first, true)
        table.model = [second]
        compare(table.getSelectionRows(), [first])
        table.toggleRowSelection(second, true)
        compare(table.getSelectionRows(), [first, second])
        table.clearSelection()
        table.model = [{id: "a", name: "A", children: [{id: "a1", name: "A1"}]},
            {id: "b", name: "B", children: [{id: "b1", name: "B1"}]}]
        table.treeProps = {children: "children", checkStrictly: false}
        table.toggleRowSelection(table.model[0], true)
        compare(table.getSelectionRows().map(function(row) {
            return row.id
        }), ["a", "a1"])
    }

    function test_preserveModeAndDelegateChanges() {
        const table = tableForTest({expandDelegate: expansionComponent})
        verify(table.toggleRowExpansion(table.model[0], true))
        tryVerify(function() {
            return findChild(table, "tableExpansionFixture") !== null
        })
        table.preserveExpandedContent = true
        tryVerify(function() {
            return table.preservedExpansions.size === 1
        })
        compare(findChild(table, "tableRow").height, 134)
        table.expandDelegate = replacementExpansionComponent
        tryVerify(function() {
            return findChild(table, "tableExpansionReplacement") !== null
        })
        compare(childrenNamed(table, "tableExpansionFixture").length, 0)
        table.preserveExpandedContent = false
        tryVerify(function() {
            return table.preservedExpansions.size === 0
        })
        tryCompare(findChild(table, "tableRow"), "height", 154)
        compare(childrenNamed(table, "tableExpansionReplacement").length, 1)
        table.rowExpandable = function() {
            return false
        }
        compare(findChild(table, "tableRow").height, 44)
    }

    function test_treeExpansionLazyAndSummary() {
        const table = tableForTest()
        table.rowKey = "id"
        table.model = [{id: "root", name: "Root", score: 10, children: [{id: "leaf", name: "Leaf", score: 5}]},
            {id: "lazy", name: "Lazy", hasChildren: true, score: 20}]
        table.lazy = true
        table.load = function(row, node, resolve) {
            resolve([{id: "remote", name: "Remote", score: 15}])
        }
        compare(table.displayRows.length, 2)
        verify(table.toggleRowExpansion(table.model[0], true))
        compare(table.displayRows.length, 3)
        verify(table.toggleRowExpansion(table.model[1], true))
        compare(table.displayRows.length, 4)
        verify(table.setCurrentRow("remote"))
        compare(table.currentRow.name, "Remote")
        table.showSummary = true
        compare(table.summaryValues[1], 50)
        table.summaryMethod = function(options) {
            return ["Rows", options.data.length]
        }
        compare(table.summaryValues, ["Rows", 4])
        table.defaultExpandAll = true
        verify(table.toggleRowExpansion("root", false))
        compare(table.displayRows.length, 3)
    }

    width: 800
    height: 600
    visible: true
    when: windowShown
    name: "EUIWebTable"

    Component {
        id: expansionComponent

        Item {
            property int stateValue: 0

            implicitHeight: 90
            objectName: "tableExpansionFixture"
        }
    }
    Component {
        id: replacementExpansionComponent

        Item {
            implicitHeight: 110
            objectName: "tableExpansionReplacement"
        }
    }
    Component {
        id: tableComponent

        ETable {
            width: 480
            height: 280
            columns: [{prop: "name", label: "Name", sortable: true}, {prop: "score", label: "Score", sortable: true}]
            model: [{name: "Cedar", score: 24}, {name: "Aspen", score: 8}, {name: "Disabled", score: 31, disabled: true}]
        }
    }
}

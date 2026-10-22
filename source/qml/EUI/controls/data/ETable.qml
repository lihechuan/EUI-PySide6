import EUI 1.0
import EUI.Private 1.0
import "private" as Private
import "private/TableLogic.js" as Logic
import "private/TableOperations.js" as Operations
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control

    property int total: 0
    property var model: []
    property var sorts: []
    property bool fit: true
    property int indent: 16
    property var load: null
    property var rowKey: ""
    property var columns: []
    property bool lazy: false
    property int maxHeight: 0
    property int minHeight: 0
    property int pageSize: 10
    property var cellAreas: []
    property var menuItems: []
    property var redoStack: []
    property int rowHeight: 44
    property var undoStack: []
    property bool border: false
    property var cellArea: null
    property int currentPage: 1
    property var footerData: []
    property var mergeCells: []
    property var rowStyle: null
    property var sourceRows: []
    property bool stripe: false
    property var cellStyle: null
    property var columnOrder: []
    property var editRules: ({})
    property var editValue: null
    property var groupFields: []
    property bool loading: false
    property var loadingKeys: []
    property var queryForm: ({})
    property string sortProp: ""
    property var editValues: ({})
    property bool editable: false
    property int headerHeight: 44
    property string layoutKey: ""
    property int modelRevision: 0
    property int queryRevision: 0
    property string sortOrder: ""
    property var spanMethod: null
    property var defaultSort: null
    property var editingCell: null
    property var expandRowKeys: []
    property int generatedRowId: 0
    property var hiddenColumns: []
    property int historyLimit: 100
    property bool multiSort: false
    property var proxyConfig: ({})
    property string queryError: ""
    property var selectionKeys: []
    property bool showHeader: true
    property var columnWidths: ({})
    property var filterValues: ({})
    property var footerMethod: null
    property bool keepSource: false
    property var lazyChildren: ({})
    property bool pagination: false
    property var selectionCache: []
    property bool showFooter: false
    property bool typingEdit: false
    property bool validating: false
    property int currentRowIndex: -1
    property int draggedRowIndex: -1
    property var radioKey: undefined
    property var rowExpandable: null
    property bool showSummary: false
    property bool showToolbar: false
    property var summaryMethod: null
    property var mergeFooterCells: []
    property bool rowDraggable: false
    property var validationErrors: []
    property bool resettingPage: false
    property bool virtualColumns: true
    property var collapsedGroupKeys: []
    property int currentColumnIndex: -1
    property int draggedColumnIndex: -1
    property var footerSpanMethod: null
    property int hoveredColumnIndex: -1
    property bool rangeSelection: false
    property var clipboardProvider: null
    property bool columnDraggable: false
    property string borderMode: "default"
    property Component cellDelegate: null
    property bool defaultExpandAll: false
    property bool internalMutation: false
    property var previousCurrentRow: null
    property Component emptyDelegate: null
    property Component appendDelegate: null
    property Component expandDelegate: null
    property Component headerDelegate: null
    property bool highlightCurrentRow: true
    property bool keyboardNavigation: false
    property bool showColumnSettings: false
    property var expansionHeights: new Map()
    property Component toolbarDelegate: null
    property bool highlightHoverColumn: false
    property var pageSizes: [10, 20, 50, 100]
    property bool selectOnIndeterminate: true
    property bool highlightCurrentColumn: false
    property var preservedExpansions: new Map()
    property bool preserveExpandedContent: false
    property var editConfig: ({trigger: "dblclick", mode: "cell"})
    property string sumText: EControlConfig.textFor(control, "Total", control.localizedTexts)
    property string emptyText: EControlConfig.textFor(control, "NoData", control.localizedTexts)
    property var tooltipOptions: EControlConfig.optionFor(control, "table", "tooltipOptions", ({}))
    property string tooltipEffect: EControlConfig.optionFor(control, "table", "tooltipEffect", "dark")
    property var tooltipFormatter: EControlConfig.optionFor(control, "table", "tooltipFormatter", null)
    property var treeProps: ({ children: "children", hasChildren: "hasChildren", checkStrictly: true })
    property string columnSettingsText: EControlConfig.textFor(control, "Columns", control.localizedTexts)
    property bool showOverflowTooltip: EControlConfig.optionFor(
        control,
        "table",
        "showOverflowTooltip",
        false
    )

    readonly property var allColumns: columnTree.leaves
    readonly property var localizedTexts: ELocale.texts
    readonly property real scrollTop: rowsView.contentY
    readonly property bool canRedo: redoStack.length > 0
    readonly property bool canUndo: undoStack.length > 0
    readonly property var mergedRows: mergedRowGeometry()
    readonly property int pagerHeight: pagination ? 44 : 0
    readonly property real scrollLeft: contentItem.contentX
    readonly property var columnTree: Logic.columns(columns)
    readonly property int effectivePageSize: Math.max(1, pageSize)
    readonly property int effectiveRowHeight: Math.max(1, rowHeight)
    readonly property bool indeterminate: checkedRowCount > 0 && !allSelected
    readonly property int rowCount: EDataUtils.isArray(model) ? model.length : 0
    readonly property var displayRows: Operations.pageRows(control, processedRows)
    readonly property var summaryValues: showSummary ? Logic.summary(control) : []
    readonly property real tableWidth: Math.max(availableWidth, columnLayout.total)
    readonly property color hoverColor: EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)
    readonly property int pageCount: Math.max(1, Math.ceil(effectiveTotal / effectivePageSize))
    readonly property var processedRows: Operations.groups(control, Logic.displayRows(control))
    readonly property color borderColor: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
    readonly property color surfaceColor: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
    readonly property var allRows: hasTree ? Logic.rows(control) : EDataUtils.tableRows(model, "", "")
    readonly property color accentColor: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
    readonly property var currentRow: currentRowIndex < 0 ? null : currentEntry ? currentEntry.row : null
    readonly property bool allSelected: selectableRows.length > 0 && checkedRowCount === selectableRows.length
    readonly property int effectiveHeaderHeight: showHeader ? Math.max(1, headerHeight) * columnTree.depth : 0
    readonly property int footerHeight: showFooter || showSummary ? footerRows.length * effectiveRowHeight : 0
    readonly property int effectiveTotal: typeof proxyConfig.query === "function" ? total : processedRows.length
    readonly property int checkedRowCount: selectableRows.filter(function(entry) {
        return isRowSelected(entry)
    }).length
    readonly property color stripeColor: Qt.tint(
        surfaceColor,
        Qt.rgba(hoverColor.r, hoverColor.g, hoverColor.b, 0.45)
    )
    readonly property int toolbarHeight: (showColumnSettings ? 42 : 0) + (showToolbar ? tableTools.implicitHeight : 0)
    readonly property var selectionColumn: allColumns.filter(function(column) {
        return column.type === "selection"
    })[0] || null
    readonly property var sortColumn: allColumns.filter(function(column) {
        return (column.prop || column.property) === sortProp
    })[0] || null
    readonly property color selectedColor: Qt.tint(surfaceColor, Qt.rgba(accentColor.r, accentColor.g, accentColor.b, ETheme.dark
        ? 0.2
        : 0.1))
    readonly property var currentEntry: currentRowIndex < 0 ? null : allRows.filter(function(entry) {
        return entry.index === currentRowIndex
    })[0] || null
    readonly property var radioRow: radioKey === undefined ? null
        : (allRows.filter(function(entry) { return entryKey(entry) === radioKey })[0] || {}).row || null
    readonly property var selectableRows: selectionColumn
        ? (hasTree ? Logic.filteredRows(control, allRows) : displayRows)
        .filter(function(entry) {
            return isSelectable(entry)
        }) : []
    readonly property bool hasTree: EDataUtils.isArray(model) && model.some(function(row) {
        return row
            && (EDataUtils.isArray(row[treeProps.children || "children"])
                && row[treeProps.children || "children"].length
            || lazy && row[treeProps.hasChildren || "hasChildren"])
    })
    readonly property var columnLayout: EDataUtils.columnWidths(columnModel.map(function(column, index) {
        const width = Logic.ownValue(columnWidths, Logic.columnKey(column, index))
        return width ? Object.assign({}, column, { width: width }) : column
    }), fit ? availableWidth : 0)
    readonly property var selectedRows: selectionKeys.map(function(key) {
        const entry = allRows.filter(function(entry) {
            return entryKey(entry) === key
        })[0]
            || selectionCache.filter(function(entry) {
                return entryKey(entry) === key
            })[0]
        return entry ? entry.row : null
    }).filter(function(row) {
        return row !== null
    })
    readonly property var footerRows: {
        if (footerData.length)
            return footerData
        if (typeof footerMethod === "function")
            return footerMethod({columns: columnModel, data: displayRows.filter(function(entry) { return !entry.group }).map(function(entry) { return entry.row })}) || []
        return showSummary ? [summaryValues] : []
    }
    readonly property var renderColumnIndexes: {
        const indices = []
        for (let index = 0; index < columnModel.length; ++index)
            if (!virtualColumns || columnModel.length < 24 || typeof spanMethod === "function" || mergeCells.length
                || columnFixed(columnModel[index]) || columnLeft(index) + columnWidth(index) >= scrollLeft - 100
                    && columnLeft(index) <= scrollLeft + availableWidth + 100)
                indices.push(index)
        return indices
    }
    readonly property var columnModel: allColumns.filter(function(column, index) {
        return column.visible !== false && hiddenColumns.indexOf(Logic.columnKey(column, index)) < 0
    }).sort(function(left, right) {
        const leftRank = left.fixed === "right" ? 2 : control.columnFixed(left) ? 0 : 1
        const rightRank = right.fixed === "right" ? 2 : control.columnFixed(right) ? 0 : 1
        const leftOrder = columnOrder.indexOf(Logic.columnKey(left, allColumns.indexOf(left)))
        const rightOrder = columnOrder.indexOf(Logic.columnKey(right, allColumns.indexOf(right)))
        return leftRank - rightRank || (leftOrder < 0 ? allColumns.length + allColumns.indexOf(left) : leftOrder)
            - (rightOrder < 0 ? allColumns.length + allColumns.indexOf(right) : rightOrder)
    })

    signal radioChange(var row)
    signal sortChange(var sort)
    signal selectAll(var selection)
    signal filterChange(var filters)
    signal headerClicked(var column)
    signal queryCompleted(var result)
    signal headerContextMenu(var column)
    signal rowClicked(var row, int index)
    signal rowReordered(int from, int to)
    signal select(var selection, var row)
    signal selectionChange(var selection)
    signal cellAreaChangedByUser(var area)
    signal editStarted(var row, var column)
    signal columnReordered(int from, int to)
    signal rowContextMenu(var row, int index)
    signal dataChange(var rows, string action)
    signal expandChange(var row, bool expanded)
    signal rowDoubleClicked(var row, int index)
    signal sortChanged(string prop, string order)
    signal menuCommand(string command, var context)
    signal validationFinished(bool valid, var errors)
    signal cellClicked(var row, var column, int index)
    signal cellMouseLeft(var row, var column, int index)
    signal operationFailed(string action, string message)
    signal cellContextMenu(var row, var column, int index)
    signal editClosed(var row, var column, bool committed)
    signal cellMouseEntered(var row, var column, int index)
    signal cellValueChanged(var row, var column, var value)
    signal currentChange(var currentRow, var oldCurrentRow)
    signal cellDoubleClicked(var row, var column, int index)
    signal columnVisibilityChanged(string key, bool visible)
    signal headerDragend(real newWidth, real oldWidth, var column)

    function clearValidate() { validationErrors = [] }

    function setScrollTop(top) {
        scrollTo(undefined, top)
    }

    function setScrollLeft(left) {
        scrollTo(left, undefined)
    }

    function getSelectionRows() {
        return selectedRows.slice()
    }

    function redo() { return Operations.history(control, true) }

    function removeSelectedRows() { return remove(selectedRows) }

    function undo() { return Operations.history(control, false) }

    function doLayout() {
        rowsView.forceLayout()
        return columnLayout
    }

    function getRecordset() { return Operations.recordset(control) }

    function remove(records) { return Operations.remove(control, records) }

    function insert(records) { return Operations.insert(control, records, 0) }

    function moveRow(from, to) { return Operations.moveRow(control, from, to) }

    function pasteCellArea(text) { return Operations.pasteArea(control, text) }

    function validate(records) { return Operations.validate(control, records) }

    function exportText(options) { return Operations.exportText(control, options) }

    function copyCellArea(cut) { return Operations.copyArea(control, Boolean(cut)) }

    function moveColumn(from, to) { return Operations.moveColumn(control, from, to) }

    function isRowSelected(entry) {
        return selectionKeys.indexOf(entryKey(entry)) >= 0
    }

    function insertAt(records, row) { return Operations.insert(control, records, row) }

    function fillCellArea(sourceArea) { return Operations.fillArea(control, sourceArea) }

    function isExpanded(key) {
        return defaultExpandAll || expandRowKeys.indexOf(key) >= 0
    }

    function findCells(query, options) { return Operations.find(control, query, options) }

    function nativeRows(rows, prop, order) {
        return EDataUtils.tableRows(rows, prop, order)
    }

    function importText(text, options) { return Operations.importText(control, text, options) }

    function openContextMenu(row, column, x, y) {
        if (enabled)
            tableTools.openMenu(row, column, x, y)
    }

    function cellValue(row, column) {
        return Logic.valueAt(row, column.prop || column.property || "")
    }

    function entryKey(entry) {
        return entry.key === undefined ? keyForRow(entry.row, entry.index) : entry.key
    }

    function columnFixed(column) {
        return column.fixed === true || column.fixed === "left" || column.fixed === "right"
    }

    function replaceCells(query, replacement, options) { return Operations.replace(control, query, replacement, options) }

    function columnWidth(index) {
        return index >= 0 && index < columnLayout.widths.length ? columnLayout.widths[index] : 100
    }

    function canExpand(entry) {
        return entry && (typeof rowExpandable !== "function" || rowExpandable(entry.row, entry.index))
    }

    function resetSource() {
        sourceRows = EDataUtils.isArray(model) ? Operations.clone(model) : []
        undoStack = []
        redoStack = []
    }

    function clearSort() {
        sorts = []
        sortProp = ""
        sortOrder = ""
        sortChanged("", "")
        sortChange({ column: null, prop: "", order: "" })
    }

    function keyForRow(row, index) {
        return typeof rowKey === "function" ? rowKey(row) : rowKey ? Logic.valueAt(row, rowKey) : index
    }

    function saveLayout() {
        return ETableIO.saveLayout(layoutKey, {order: columnOrder, hidden: hiddenColumns, widths: columnWidths})
    }

    function clearPreservedExpansions() {
        preservedExpansions.forEach(function(item) {
            item.destroy()
        })
        preservedExpansions = new Map()
    }

    function clearSelection() {
        currentRowIndex = -1
        if (selectionKeys.length) {
            selectionKeys = []
            selectionCache = []
            selectionChange([])
        }
    }

    function pivot(rowFields, columnField, valueField, method) {
        return Operations.pivot(control, rowFields, columnField, valueField, method)
    }

    function columnLeft(index) {
        let position = 0
        for (let previous = 0; previous < index; ++previous)
            position += columnWidth(previous)
        return position
    }

    function cancelEdit() {
        const current = editingCell
        editingCell = null
        if (current)
            editClosed(current.row, current.column, false)
        return Boolean(current)
    }

    function revertData() {
        if (!enabled || !keepSource)
            return false
        cancelEdit()
        Operations.apply(control, Operations.clone(sourceRows), "revert")
        return true
    }

    function readClipboard() {
        return clipboardProvider && typeof clipboardProvider.text === "function" ? clipboardProvider.text() : ETableIO.clipboardText()
    }

    function setCellValue(row, prop, value, validateValue) {
        return Operations.mutateCells(control, [{row: row, column: prop, value: value}], validateValue, "edit")
    }

    function rowHeightFor(entry, index) {
        const appearance = styleFor(rowStyle, entry, null, index, -1)
        return Math.max(1, Number(appearance.height) || effectiveRowHeight)
    }

    function writeClipboard(text) {
        return clipboardProvider && typeof clipboardProvider.setText === "function" ? clipboardProvider.setText(text) !== false : ETableIO.setClipboardText(text)
    }

    function toggleGroup(key) {
        collapsedGroupKeys = collapsedGroupKeys.indexOf(key) >= 0 ? collapsedGroupKeys.filter(function(value) { return value !== key }) : collapsedGroupKeys.concat([key])
    }

    function aggregate(prop, method, records) {
        return Operations.aggregate(records || displayRows.filter(function(entry) { return !entry.group }).map(function(entry) { return entry.row }), prop, method)
    }

    function recordExpansionHeight(entry, height) {
        const key = entryKey(entry)
        if (expansionHeights.get(key) === height)
            return
        const heights = new Map(expansionHeights)
        heights.set(key, height)
        expansionHeights = heights
    }

    function setEditValue(column, value) {
        const prop = Operations.field(column)
        editValues = Object.assign({}, editValues, {[prop]: value})
        if (editingCell && prop === Operations.field(editingCell.column))
            editValue = value
    }

    function columnSortOrder(column) {
        const prop = column.prop || column.property
        const configured = sorts.filter(function(sort) { return sort.prop === prop })[0]
        return configured ? configured.order : sortProp === prop ? sortOrder : ""
    }

    function updateKeyChildren(key, children) {
        if (!EDataUtils.isArray(children) || !rowEntry(key))
            return false
        const loaded = Object.assign(Object.create(null), lazyChildren)
        loaded[String(key)] = children
        lazyChildren = loaded
        return true
    }

    function setCurrentRow(row) {
        if (row === null || row === undefined) {
            currentRowIndex = -1
            return true
        }
        const entry = rowEntry(row)
        if (!enabled || !entry || entry.disabled || entry.row.disabled)
            return false
        currentRowIndex = entry.index
        return true
    }

    function isSelectable(entry) {
        return enabled && entry && !entry.group && !entry.disabled && !(entry.row && entry.row.disabled)
            && (!selectionColumn || typeof selectionColumn.selectable !== "function"
                || selectionColumn.selectable(entry.row, entry.index))
    }

    function printData(url, options) {
        options = options || {}
        const result = ETableIO.printHtml(exportText(Object.assign({}, options, {type: "html"})), url || "", options.printerName || "")
        if (!result.ok) operationFailed("print", result.message)
        return result.ok
    }

    function valuesForFilter(column) {
        const key = Logic.columnKey(column, allColumns.indexOf(column))
        const configured = Logic.ownValue(filterValues, key)
        const values = configured === undefined ? column.filteredValue : configured
        return EDataUtils.isArray(values) ? values : []
    }

    function rowEntry(rowOrKey) {
        const key = rowKey && rowOrKey && typeof rowOrKey === "object"
            ? keyForRow(rowOrKey, -1) : rowOrKey
        return allRows.filter(function(entry) {
            return entry.row === rowOrKey || key !== undefined && key !== null && entryKey(entry) === key
        })[0] || null
    }

    function styleFor(callback, entry, column, rowIndex, columnIndex) {
        const context = { row: entry.row, column: column, rowIndex: rowIndex, columnIndex: columnIndex }
        const result = typeof callback === "function" ? callback(context) : callback
        return result && typeof result === "object" ? result : ({})
    }

    function chartData(labelField, valueField, records) {
        return (records || displayRows.filter(function(entry) { return !entry.group }).map(function(entry) { return entry.row })).map(function(row) {
            return {label: String(Logic.valueAt(row, labelField)), value: Number(Logic.valueAt(row, valueField)) || 0}
        })
    }

    function cacheSelection(keys) {
        const entries = new Map()
        const selected = new Set(keys)
        selectionCache.concat(allRows).forEach(function(entry) {
            const key = entryKey(entry)
            if (selected.has(key))
                entries.set(key, entry)
        })
        const cache = []
        entries.forEach(function(entry) {
            cache.push(entry)
        })
        selectionCache = cache
    }

    function selectRow(index) {
        if (!enabled || !isFinite(index) || Math.floor(index) !== index)
            return false
        const entry = allRows.filter(function(row) {
            return row.index === index
        })[0]
        if (!entry || entry.disabled || !entry.row || entry.row.disabled)
            return false
        currentRowIndex = index
        rowClicked(entry.row, index)
        return true
    }

    function scrollTo(left, top) {
        if (left && typeof left === "object") {
            top = left.top
            left = left.left
        }
        if (isFinite(left))
            contentItem.contentX = Math.max(0, Math.min(contentItem.contentWidth - contentItem.width, left))
        if (isFinite(top))
            rowsView.contentY = Math.max(0, Math.min(rowsView.contentHeight - rowsView.height, top))
    }

    function spanHeight(index, count) {
        let height = 0
        for (let offset = 0; offset < count && index + offset < displayRows.length; ++offset) {
            const entry = displayRows[index + offset]
            height += rowHeightFor(entry, index + offset)
            if (offset + 1 < count && isExpanded(entryKey(entry)))
                height += Number(expansionHeights.get(entryKey(entry))) || 0
        }
        return height
    }

    function rowCheckState(entry) {
        if (isRowSelected(entry))
            return Qt.Checked
        if (!hasTree || treeProps.checkStrictly !== false)
            return Qt.Unchecked
        const start = allRows.indexOf(entry) + 1
        for (let index = start; index < allRows.length && allRows[index].level > entry.level; ++index)
            if (isRowSelected(allRows[index]))
                return Qt.PartiallyChecked
        return Qt.Unchecked
    }

    function extendSelection(x, y) {
        const point = control.mapToItem(rowsView.contentItem, x, y)
        const row = rowsView.indexAt(point.x, point.y)
        let column = -1
        for (let index = 0; index < columnModel.length; ++index)
            if (point.x >= columnX(index) && point.x < columnX(index) + columnWidth(index))
                column = index
        if (row >= 0 && column >= 0)
            selectCell(row, column, true)
    }

    function isCellSelected(row, column) {
        return (rangeSelection || keyboardNavigation) && cellAreas.concat(cellArea ? [cellArea] : []).some(function(area) {
            return row >= Math.min(area.startRow, area.endRow) && row <= Math.max(area.startRow, area.endRow)
                && column >= Math.min(area.startColumn, area.endColumn) && column <= Math.max(area.startColumn, area.endColumn)
        })
    }

    function exportData(url, options) {
        try {
            const result = options && options.type === "xlsx"
                ? ETableIO.writeWorkbook(url, JSON.parse(exportText(Object.assign({}, options, {type: "matrix"}))))
                : ETableIO.writeText(url, exportText(options))
            if (!result.ok) operationFailed("export", result.message)
            return result.ok
        } catch (error) { operationFailed("export", String(error))
         return false }
    }

    function sortIndicator(column) {
        if (!column.sortable)
            return ""
        const order = columnSortOrder(column)
        if (!order)
            return EControlConfig.textFor(control, "SortNeutralGlyph", control.localizedTexts)
        return order === "ascending"
            ? EControlConfig.textFor(control, "SortAscendingGlyph", control.localizedTexts)
            : EControlConfig.textFor(control, "SortDescendingGlyph", control.localizedTexts)
    }

    function clearFilter(keys) {
        const values = Object.assign(Object.create(null), filterValues)
        const targets = keys === undefined ? allColumns.map(function(column, index) {
            return Logic.columnKey(column, index)
        })
            : EDataUtils.isArray(keys) ? keys.map(String) : [String(keys)]
        for (let index = 0; index < targets.length; ++index)
            values[targets[index]] = []
        filterValues = values
        filterChange(values)
    }

    function importData(url, options) {
        const workbook = options && options.type === "xlsx"
        const result = workbook ? ETableIO.readWorkbook(url) : ETableIO.readText(url)
        if (!result.ok) { operationFailed("import", result.message)
         return Promise.resolve(false) }
        return importText(workbook ? JSON.stringify(result.matrix) : result.text, workbook ? Object.assign({}, options, {type: "matrix"}) : options)
    }

    function cellText(row, column, index) {
        if (column.type === "index")
            return typeof column.index === "function" ? String(column.index(index))
                : String(index + (Number(column.index) || 1))
        if (typeof column.formatter === "function" && column.formatter.length >= 3)
            return String(column.formatter(row, column, Logic.valueAt(row, column.prop
                || column.property), index))
        return EDataUtils.cellText(row, column)
    }

    function runCellValidation(row, column, value, rules) {
        return new Promise(function(resolve) {
            const runner = validationFactory.createObject(control, {rules: rules, label: column.label || Operations.field(column), prop: Operations.field(column)})
            runner.field.modelValue = value
            runner.validate("submit", function(valid, message) {
                resolve(valid ? "" : message)
                Qt.callLater(function() { runner.destroy() })
            })
        })
    }

    function cellError(row, column) {
        if (!validationErrors.length)
            return ""
        const entry = rowEntry(row)
        const key = entry ? entryKey(entry) : keyForRow(row, -1)
        const error = validationErrors.filter(function(error) {
            const item = rowEntry(error.row)
            return (item ? entryKey(item) : keyForRow(error.row, -1)) === key && Operations.field(error.column) === Operations.field(column)
        })[0]
        return error ? error.message : ""
    }

    function mergedRowsAtViewport() {
        let first = 0
        let last = mergedRows.length
        while (first < last) {
            const middle = Math.floor((first + last) / 2)
            if (mergedRows[middle].top < scrollTop)
                first = middle + 1
            else
                last = middle
        }
        const result = []
        for (let index = first - 1; index >= 0 && mergedRows[index].maximumBottom > scrollTop; --index)
            if (mergedRows[index].bottom > scrollTop)
                result.push(mergedRows[index])
        return result
    }

    function setFilter(key, values) {
        const column = allColumns.filter(function(column, index) {
            return Logic.columnKey(column, index) === String(key)
        })[0]
        if (!enabled || !column || !EDataUtils.isArray(values))
            return false
        const filters = Object.assign(Object.create(null), filterValues)
        filters[String(key)] = column.filterMultiple === false ? values.slice(-1) : values.slice()
        filterValues = filters
        filterChange(filters)
        return true
    }

    function tooltipPlacement(value) {
        if (typeof value === "number")
            return value
        const names = ["top", "bottom", "left", "right", "top-start", "top-end", "bottom-start", "bottom-end"]
        const placements = [EPlacement.Top, EPlacement.Bottom, EPlacement.Left, EPlacement.Right,
            EPlacement.TopLeft, EPlacement.TopRight, EPlacement.BottomLeft, EPlacement.BottomRight]
        const index = names.indexOf(value)
        return index >= 0 ? placements[index] : EPlacement.Top
    }

    function setRadioRow(row) {
        const entry = rowEntry(row)
        if (row === null) {
            radioKey = undefined
            radioChange(null)
            return true
        }
        const column = allColumns.filter(function(column) { return column.type === "radio" })[0]
        if (!enabled || !entry || entry.disabled || entry.row.disabled || column && typeof column.selectable === "function" && !column.selectable(entry.row, entry.index))
            return false
        radioKey = entryKey(entry)
        radioChange(entry.row)
        return true
    }

    function retainedExpansion(entry, index, component) {
        const key = entryKey(entry)
        let loader = preservedExpansions.get(key)
        if (!loader) {
            loader = retainedExpansionFactory.createObject(retainedExpansions, {
                table: control, row: entry.row, rowIndex: index, sourceComponent: component
            })
            if (!loader)
                return null
            preservedExpansions.set(key, loader)
        }
        if (loader.sourceComponent !== component)
            loader.sourceComponent = component
        loader.row = entry.row
        loader.rowIndex = index
        return loader
    }

    function toggleAllSelection() {
        if (!enabled || !selectionColumn)
            return false
        const checked = indeterminate ? selectOnIndeterminate : !allSelected
        const keys = selectionKeys.slice()
        for (let index = 0; index < selectableRows.length; ++index) {
            const key = entryKey(selectableRows[index])
            const old = keys.indexOf(key)
            if (old >= 0)
                keys.splice(old, 1)
            if (checked)
                keys.push(key)
        }
        cacheSelection(keys)
        selectionKeys = keys
        selectionChange(selectedRows)
        selectAll(selectedRows)
        return true
    }

    function nextSortOrder(prop) {
        const column = allColumns.filter(function(entry) {
            return (entry.prop || entry.property) === prop
        })[0]
        const orders = column && EDataUtils.isArray(column.sortOrders) && column.sortOrders.length
            ? column.sortOrders : ["ascending", "descending", ""]
        const order = column ? columnSortOrder(column) : ""
        const current = orders.indexOf(order || null)
        const position = current < 0 ? orders.indexOf(order) : current
        return orders[(position + 1) % orders.length] || ""
    }

    function columnX(index) {
        const column = columnModel[index]
        if (!column || !columnFixed(column))
            return columnLeft(index)
        let offset = 0
        if (column.fixed === "right") {
            for (let next = index + 1; next < columnModel.length; ++next)
                if (columnModel[next].fixed === "right")
                    offset += columnWidth(next)
            return scrollLeft + availableWidth - offset - columnWidth(index)
        }
        for (let previous = 0; previous < index; ++previous)
            if (columnModel[previous].fixed === true || columnModel[previous].fixed === "left")
                offset += columnWidth(previous)
        return scrollLeft + offset
    }

    function resizeColumn(index, width, notify) {
        if (!enabled
            || !isFinite(width)
            || index < 0
            || index >= columnModel.length
            || columnModel[index].resizable === false)
            return false
        const column = columnModel[index]
        const oldWidth = columnWidth(index)
        const minimum = Math.max(40, Number(column.minWidth) || 40)
        const widths = Object.assign(Object.create(null), columnWidths)
        widths[Logic.columnKey(column, index)] = Math.max(minimum, width)
        columnWidths = widths
        if (notify !== false)
            headerDragend(widths[Logic.columnKey(column, index)], oldWidth, column)
        return true
    }

    function restoreLayout() {
        const layout = ETableIO.loadLayout(layoutKey)
        const keys = allColumns.map(function(column, index) { return Logic.columnKey(column, index) })
        columnOrder = (EDataUtils.isArray(layout.order) ? layout.order : []).filter(function(key) { return keys.indexOf(key) >= 0 })
        hiddenColumns = (EDataUtils.isArray(layout.hidden) ? layout.hidden : []).filter(function(key) { return keys.indexOf(key) >= 0 })
        const widths = {}
        keys.forEach(function(key) {
            if (layout.widths && isFinite(layout.widths[key]) && layout.widths[key] > 0)
                widths[key] = layout.widths[key]
        })
        columnWidths = widths
    }

    function editCell(row, prop, initialValue) {
        const entry = rowEntry(row)
        const column = Operations.columnFor(control, prop)
        if (!entry || !Operations.canEdit(control, entry.row, column) || validating)
            return false
        const values = {}
        allColumns.forEach(function(definition) { values[Operations.field(definition)] = cellValue(entry.row, definition) })
        editValues = values
        typingEdit = arguments.length > 2
        editValue = typingEdit ? initialValue : cellValue(entry.row, column)
        if (typingEdit)
            setEditValue(column, initialValue)
        editingCell = {row: entry.row, key: entryKey(entry), column: column}
        editStarted(entry.row, column)
        return true
    }

    function setSorts(values) {
        if (!enabled || !EDataUtils.isArray(values) || values.some(function(value) {
            if (!value || typeof value !== "object")
                return true
            const column = Operations.columnFor(control, value.prop)
            return !column || !column.sortable || ["ascending", "descending"].indexOf(value.order) < 0
        }) || new Set(values.map(function(value) { return value.prop })).size !== values.length) return false
        sorts = values.slice()
        sortProp = values.length ? values[values.length - 1].prop : ""
        sortOrder = values.length ? values[values.length - 1].order : ""
        sortChange({prop: sortProp, order: sortOrder, sorts: sorts})
        return true
    }

    function sort(prop, order) {
        const column = allColumns.filter(function(entry) {
            return (entry.prop || entry.property) === prop
        })[0]
        if (!enabled || !column || !column.sortable)
            return false
        if (multiSort) {
            const remaining = sorts.filter(function(value) { return value.prop !== prop })
            if (order === "ascending" || order === "descending") remaining.push({prop: prop, order: order})
            return setSorts(remaining)
        }
        sorts = []
        sortProp = String(prop)
        sortOrder = order === "descending" ? "descending" : order === "ascending" ? "ascending" : ""
        sortChanged(sortProp, sortOrder)
        sortChange({ column: column, prop: sortProp, order: sortOrder })
        return true
    }

    function cellSpan(entry, column, rowIndex, columnIndex) {
        if (typeof spanMethod !== "function")
            return Operations.mergeSpan(mergeCells, rowIndex, columnIndex, displayRows.length, columnModel.length)
        const result = spanMethod({ row: entry.row, column: column, rowIndex: rowIndex, columnIndex: columnIndex })
        const rows = EDataUtils.isArray(result) ? result[0] : result && result.rowspan
        const columns = EDataUtils.isArray(result) ? result[1] : result && result.colspan
        return { rowspan: isFinite(rows) ? Math.max(0, Math.floor(rows)) : 1,
            colspan: isFinite(columns)
                ? Math.max(0, Math.min(columnModel.length - columnIndex, Math.floor(columns)))
                : 1 }
    }

    function commitEdit() {
        const current = editingCell
        if (!current)
            return Promise.resolve(false)
        const changes = editConfig.mode === "row" ? allColumns.filter(function(column) {
            return Operations.canEdit(control, current.row, column)
        }).map(function(column) {
            const prop = Operations.field(column)
            return {row: current.row, column: column, value: prop === Operations.field(current.column) ? editValue : editValues[prop]}
        }) : [{row: current.row, column: current.column, value: editValue}]
        return Operations.mutateCells(control, changes, true, "edit").then(function(ok) {
            if (ok && editingCell === current) {
                editingCell = null
                editClosed(current.row, current.column, true)
                control.forceActiveFocus()
            }
            return ok
        })
    }

    function selectCell(rowIndex, columnIndex, extend, append) {
        if (!enabled || !Number.isInteger(rowIndex) || !Number.isInteger(columnIndex)
            || rowIndex < 0 || rowIndex >= displayRows.length || columnIndex < 0 || columnIndex >= columnModel.length)
            return false
        const entry = displayRows[rowIndex]
        if (entry.group || entry.disabled || entry.row.disabled)
            return false
        if (append && cellArea)
            cellAreas = cellAreas.concat([cellArea])
        else if (!extend)
            cellAreas = []
        const origin = extend && cellArea ? cellArea : {startRow: rowIndex, startColumn: columnIndex}
        cellArea = {startRow: origin.startRow, startColumn: origin.startColumn, endRow: rowIndex, endColumn: columnIndex}
        currentColumnIndex = columnIndex
        currentRowIndex = entry.index
        cellAreaChangedByUser(cellArea)
        return true
    }

    function mergedRowGeometry() {
        if (typeof spanMethod !== "function" && !mergeCells.length)
            return []
        const result = []
        let position = 0
        for (let index = 0; index < displayRows.length; ++index) {
            const entry = displayRows[index]
            let maximum = 1
            for (let column = 0; column < columnModel.length; ++column)
                maximum = Math.max(maximum, cellSpan(entry, columnModel[column], index, column).rowspan)
            if (maximum > 1) {
                const bottom = position + spanHeight(index, maximum)
                result.push({ entry: entry, index: index, top: position, bottom: bottom,
                    maximumBottom: Math.max(bottom, result.length ? result[result.length - 1].maximumBottom
                        : 0) })
            }
            position += rowHeightFor(entry, index)
            if (isExpanded(entryKey(entry)))
                position += Number(expansionHeights.get(entryKey(entry))) || 0
        }
        return result
    }

    function setColumnVisible(key, visible) {
        const column = allColumns.filter(function(column, index) {
            return Logic.columnKey(column, index) === String(key)
        })[0]
        if (!column)
            return false
        const hidden = hiddenColumns.filter(function(entry) {
            return entry !== String(key)
        })
        if (!visible)
            hidden.push(String(key))
        hiddenColumns = hidden
        if (visible && column.visible === false) {
            let leafIndex = 0
            const update = function(items) {
                return items.map(function(entry) {
                    if (!entry)
                        return entry
                    const copy = Object.assign({}, entry)
                    if (EDataUtils.isArray(copy.children) && copy.children.length)
                        copy.children = update(copy.children)
                    else if (Logic.columnKey(copy, leafIndex++) === String(key))
                        copy.visible = true
                    return copy
                })
            }
            columns = update(columns)
        }
        columnVisibilityChanged(String(key), Boolean(visible))
        return true
    }

    function navigateCell(rows, columns, extend) {
        if (!displayRows.length || !columnModel.length)
            return false
        let row = cellArea ? cellArea.endRow : 0
        let column = cellArea ? cellArea.endColumn : 0
        column += columns
        if (column >= columnModel.length) { column = 0
         ++row }
        if (column < 0) { column = columnModel.length - 1
         --row }
        row = Math.max(0, Math.min(displayRows.length - 1, row + rows))
        while (displayRows[row].group && row + (rows < 0 ? -1 : 1) >= 0 && row + (rows < 0 ? -1 : 1) < displayRows.length)
            row += rows < 0 ? -1 : 1
        if (!selectCell(row, column, extend))
            return false
        rowsView.positionViewAtIndex(row, ListView.Contain)
        if (!columnFixed(columnModel[column])) {
            const left = columnLeft(column)
            if (left < scrollLeft) setScrollLeft(left)
            else if (left + columnWidth(column) > scrollLeft + availableWidth) setScrollLeft(left + columnWidth(column) - availableWidth)
        }
        return true
    }

    function commitProxy(action, params) {
        action = action || "query"
        if (action === "query" || action === "reload") {
            if (action === "reload") {
                resettingPage = true
                currentPage = 1
                resettingPage = false
            }
            return Operations.query(control, params)
        }
        const callback = proxyConfig[action]
        if (typeof callback !== "function") return Promise.resolve(false)
        const revision = modelRevision
        return validate().then(function(valid) {
            if (!valid) return false
            loading = true
            return Promise.resolve(callback({table: control, records: getRecordset(), selectedRows: selectedRows, form: queryForm})).then(function(result) {
                loading = false
                if (result === false) return false
                if (revision === modelRevision)
                    resetSource()
                return true
            }, function(error) {
                loading = false
                operationFailed(action, String(error))
                return false
            })
        }).catch(function(error) {
            loading = false
            operationFailed(action, String(error.message || error))
            return false
        })
    }

    function toggleRowSelection(row, selected, ignoreSelectable) {
        const entry = rowEntry(row)
        if (!entry || !enabled || !ignoreSelectable && !isSelectable(entry))
            return false
        const key = entryKey(entry)
        const checked = selected === undefined ? !isRowSelected(entry) : Boolean(selected)
        const keys = selectionKeys.filter(function(value) {
            return value !== key
        })
        if (checked)
            keys.push(key)
        if (hasTree && treeProps.checkStrictly === false) {
            const start = allRows.indexOf(entry) + 1
            for (let index = start; index < allRows.length && allRows[index].level > entry.level; ++index) {
                const child = allRows[index]
                if (isSelectable(child)) {
                    const childKey = entryKey(child)
                    const old = keys.indexOf(childKey)
                    if (old >= 0)
                        keys.splice(old, 1)
                    if (checked)
                        keys.push(childKey)
                }
            }
        }
        if (hasTree && treeProps.checkStrictly === false) {
            let parentIndex = entry.parentIndex
            while (parentIndex >= 0) {
                const parent = allRows[parentIndex]
                const siblings = allRows.filter(function(item) {
                    return item.parentIndex === parentIndex && isSelectable(item)
                })
                const selected = siblings.length > 0 && siblings.every(function(item) {
                    return keys.indexOf(entryKey(item)) >= 0
                })
                const key = entryKey(parent)
                const old = keys.indexOf(key)
                if (old >= 0)
                    keys.splice(old, 1)
                if (selected && isSelectable(parent))
                    keys.push(key)
                parentIndex = parent.parentIndex
            }
        }
        cacheSelection(keys)
        selectionKeys = keys
        selectionChange(selectedRows)
        return true
    }

    function toggleRowExpansion(row, expanded) {
        const entry = rowEntry(row)
        if (!enabled || !entry || entry.disabled || entry.row.disabled || !canExpand(entry))
            return false
        const key = entryKey(entry)
        const opened = expanded === undefined ? !isExpanded(key) : Boolean(expanded)
        if (defaultExpandAll) {
            expandRowKeys = allRows.filter(function(item) {
                return item.hasChildren || expandDelegate
            }).map(entryKey)
            defaultExpandAll = false
        }
        const keys = expandRowKeys.filter(function(value) {
            return value !== key
        })
        if (opened)
            keys.push(key)
        expandRowKeys = keys
        expandChange(entry.row, opened)
        const declaredChildren = entry.row[treeProps.children || "children"]
        if (opened
            && lazy
            && entry.hasChildren
            && !(EDataUtils.isArray(declaredChildren) && declaredChildren.length)
            && Logic.ownValue(lazyChildren, String(key)) === undefined
                && typeof load === "function"
                && loadingKeys.indexOf(key) < 0) {
            loadingKeys = loadingKeys.concat([key])
            const revision = modelRevision
            const resolve = function(children) {
                loadingKeys = loadingKeys.filter(function(value) {
                    return value !== key
                })
                if (revision !== modelRevision || !EDataUtils.isArray(children))
                    return
                updateKeyChildren(key, children)
            }
            try {
                const result = load(entry.row, entry, resolve)
                if (EDataUtils.isArray(result))
                    resolve(result)
                else if (result && typeof result.then === "function")
                    result.then(resolve, function() {
                        resolve([])
                    })
            } catch (error) {
                resolve([])
                return false
            }
        }
        return true
    }

    function handleCellKey(event) {
        if (!keyboardNavigation || editingCell || !enabled) return
        const shift = Boolean(event.modifiers & Qt.ShiftModifier)
        const command = Boolean(event.modifiers & Qt.ControlModifier || event.modifiers & Qt.MetaModifier)
        if (command && event.key === Qt.Key_C) copyCellArea(false)
        else if (command && event.key === Qt.Key_X) copyCellArea(true)
        else if (command && event.key === Qt.Key_V) pasteCellArea()
        else if (command && event.key === Qt.Key_Z) shift ? redo() : undo()
        else if (command && event.key === Qt.Key_Y) redo()
        else if (command && event.key === Qt.Key_A && rangeSelection && displayRows.length) {
            selectCell(0, 0, false)
            selectCell(displayRows.length - 1, columnModel.length - 1, true)
        } else if (event.key === Qt.Key_Left) navigateCell(0, -1, shift)
        else if (event.key === Qt.Key_Right) navigateCell(0, 1, shift)
        else if (event.key === Qt.Key_Up) navigateCell(-1, 0, shift)
        else if (event.key === Qt.Key_Down) navigateCell(1, 0, shift)
        else if (event.key === Qt.Key_Tab || event.key === Qt.Key_Backtab) navigateCell(0, shift || event.key === Qt.Key_Backtab ? -1 : 1, false)
        else if (event.key === Qt.Key_Home && displayRows.length) selectCell(command ? 0 : cellArea ? cellArea.endRow : 0, 0, shift)
        else if (event.key === Qt.Key_End && displayRows.length) selectCell(command ? displayRows.length - 1 : cellArea ? cellArea.endRow : 0, columnModel.length - 1, shift)
        else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_F2) {
            if (cellArea) editCell(displayRows[cellArea.endRow].row, columnModel[cellArea.endColumn])
        } else if (event.key === Qt.Key_Delete || event.key === Qt.Key_Backspace) {
            const area = Operations.range(control)
            const changes = []
            if (area) for (let row = area.top; row <= area.bottom; ++row)
                for (let column = area.left; column <= area.right; ++column)
                    if (Operations.canEdit(control, displayRows[row].row, columnModel[column]))
                        changes.push({row: displayRows[row].row, column: columnModel[column], value: ""})
            Operations.mutateCells(control, changes, true, "clear")
        } else if (event.key === Qt.Key_Escape) { cellArea = null
         cellAreas = []
         cancelEdit() }
        else if (!command && !(event.modifiers & Qt.AltModifier) && event.text && event.text.charCodeAt(0) >= 32 && cellArea) {
            if (!editCell(displayRows[cellArea.endRow].row, columnModel[cellArea.endColumn], event.text))
                return
        }
        else return
        event.accepted = true
    }

    clip: true
    padding: 1
    font.pixelSize: 14
    implicitWidth: 560
    activeFocusOnTab: keyboardNavigation
    background: ERectangle {
        radius: 8
        color: control.surfaceColor
        border.color: control.borderColor
        border.width: control.borderMode === "none" || control.borderMode === "inner" ? 0 : 1
    }
    implicitHeight: Math.max(minHeight, Math.min(maxHeight > 0 ? maxHeight : Infinity,
        toolbarHeight
            + effectiveHeaderHeight
            + Math.max(120, Math.min(displayRows.length, 6) * effectiveRowHeight)
        + footerHeight + pagerHeight + 2))
    contentItem: Flickable {
        clip: true
        contentHeight: height
        contentWidth: control.tableWidth
        ScrollBar.horizontal: ScrollHandle { }
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.HorizontalFlick

        Column {
            y: control.toolbarHeight
            width: control.tableWidth
            height: parent.height - control.toolbarHeight

            Item {
                width: parent.width
                visible: control.showHeader
                height: control.effectiveHeaderHeight

                ERectangle {
                    radius: 7
                    anchors.fill: parent
                    color: control.hoverColor
                    objectName: "tableHeaderBackground"

                    ERectangle {
                        color: parent.color
                        width: parent.width
                        height: parent.height / 2
                        anchors.bottom: parent.bottom
                    }
                }
                Repeater {
                    model: control.columnTree.groups

                    ERectangle {
                        id: groupHeader

                        readonly property var group: modelData
                        readonly property var indices: control.columnModel.map(function(column, index) {
                            return control.allColumns.indexOf(column) >= group.start
                                && control.allColumns.indexOf(column) < group.start + group.count ? index : -1
                        }).filter(function(index) {
                            return index >= 0
                        })

                        color: control.hoverColor
                        visible: indices.length > 0
                        objectName: "tableGroupHeader"
                        y: group.level * control.headerHeight
                        height: Math.max(1, control.headerHeight)
                        x: indices.length ? control.columnX(indices[0]) : 0
                        width: indices.reduce(function(sum, index) {
                            return sum + control.columnWidth(index)
                        }, 0)
                        z: indices.length && indices.every(function(index) {
                            return control.columnFixed(control.columnModel[index])
                        }) ? 4 : 0

                        EText {
                            font.bold: true
                            leftPadding: 16
                            anchors.fill: parent
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                            text: groupHeader.group.column.label || ""
                        }
                    }
                }
                Repeater {
                    model: control.renderColumnIndexes

                    Private.TableHeader {
                        owner: control
                        column: control.columnModel[columnIndex]
                        columnIndex: control.renderColumnIndexes[index]
                    }
                }
                ERectangle {
                    height: 1
                    width: parent.width
                    color: control.borderColor
                    anchors.bottom: parent.bottom
                }
            }
            ListView {
                id: rowsView

                clip: true
                width: parent.width
                objectName: "tableRows"
                model: control.displayRows.length
                boundsBehavior: Flickable.StopAtBounds
                footer: Loader {
                    width: rowsView.width
                    sourceComponent: control.appendDelegate
                }
                height: Math.max(0, parent.height - control.effectiveHeaderHeight - control.footerHeight - control.pagerHeight)
                delegate: Private.TableRow {
                    owner: control
                    displayIndex: index
                    width: rowsView.width
                    entry: control.displayRows[index]
                }
                ScrollBar.vertical: ScrollHandle {
                    height: rowsView.height
                    parent: control.contentItem
                    y: control.toolbarHeight + control.effectiveHeaderHeight
                    x: control.mirrored ? 0 : control.contentItem.width - width
                }

                Item {
                    z: 1000001
                    parent: rowsView
                    anchors.fill: parent

                    Repeater {
                        id: mergedRowsRepeater

                        readonly property var rows: control.mergedRowsAtViewport()

                        model: rows.length

                        Private.TableRow {
                            owner: control
                            spanOverlay: true
                            width: rowsView.width
                            entry: mergedRowsRepeater.rows[index].entry
                            displayIndex: mergedRowsRepeater.rows[index].index
                            y: mergedRowsRepeater.rows[index].top - control.scrollTop
                        }
                    }
                }
                Loader {
                    anchors.centerIn: parent
                    active: control.displayRows.length === 0
                    sourceComponent: control.emptyDelegate || defaultEmpty
                }
                Component {
                    id: defaultEmpty

                    EEmpty {
                        imageSize: 40
                        description: control.emptyText
                    }
                }
            }
            Private.TableFooter {
                owner: control
                width: parent.width
                height: control.footerHeight
                visible: control.showFooter || control.showSummary
            }
        }
    }

    Keys.onPressed: function(event) {
        handleCellKey(event)
    }
    onEffectiveTotalChanged: if (currentPage > pageCount)
        currentPage = pageCount
    onCurrentRowChanged: {
        currentChange(currentRow, previousCurrentRow)
        previousCurrentRow = currentRow
    }
    onSortChange: if (typeof proxyConfig.query === "function" && proxyConfig.remoteSort !== false)
        commitProxy("reload")
    onFilterChange: if (typeof proxyConfig.query === "function" && proxyConfig.remoteFilter !== false)
        commitProxy("reload")
    onPageSizeChanged: {
        if (currentPage !== 1)
            currentPage = 1
        else if (pagination && typeof proxyConfig.query === "function")
            commitProxy("query")
    }
    onPreserveExpandedContentChanged: {
        if (!preserveExpandedContent)
            Qt.callLater(function() { if (!control.preserveExpandedContent)
                control.clearPreservedExpansions() })
    }
    onCurrentPageChanged: {
        cellArea = null
        cellAreas = []
        cancelEdit()
        setScrollTop(0)
        if (!resettingPage && pagination && typeof proxyConfig.query === "function") commitProxy("query")
    }
    Component.onCompleted: {
        if (layoutKey) restoreLayout()
        if (proxyConfig.autoLoad) commitProxy("query")
        if (defaultSort && defaultSort.prop)
            sort(defaultSort.prop, defaultSort.order)
    }
    onModelChanged: {
        ++modelRevision
        if (!internalMutation) {
            ++queryRevision
            loading = false
            cancelEdit()
            cellArea = null
            cellAreas = []
            radioKey = undefined
            sourceRows = EDataUtils.isArray(model) ? Operations.clone(model) : []
            undoStack = []
            redoStack = []
        }
        clearPreservedExpansions()
        lazyChildren = ({})
        expansionHeights = new Map()
        loadingKeys = []
        if (!EDataUtils.isArray(model) || currentRowIndex >= model.length)
            currentRowIndex = -1
        if (!(selectionColumn && selectionColumn.reserveSelection && rowKey)) {
            selectionKeys = []
            selectionCache = []
        }
    }

    Item {
        id: retainedExpansions

        visible: false
    }
    Component {
        id: retainedExpansionFactory

        Loader {
            property var row
            property var table
            property int rowIndex: 0

            onLoaded: {
                if (item && "row" in item)
                    item.row = Qt.binding(function() {
                        return row
                    })
                if (item && "rowIndex" in item)
                    item.rowIndex = Qt.binding(function() {
                        return rowIndex
                    })
                if (item && "table" in item)
                    item.table = table
            }
        }
    }
    Item {
        height: 42
        x: control.leftPadding
        width: control.availableWidth
        visible: control.showColumnSettings
        y: control.topPadding + (control.showToolbar ? tableTools.implicitHeight : 0)

        EText {
            x: 16
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            text: EControlConfig.textFor(control, "RowCount", control.localizedTexts).arg(control.pagination ? control.effectiveTotal
                : control.displayRows.filter(function(entry) { return !entry.group }).length)
        }
        ETextButton {
            id: settingsButton

            size: EStyle.Small
            anchors.rightMargin: 8
            iconSource: EIcons.SLIDERS
            anchors.right: parent.right
            text: control.columnSettingsText
            objectName: "tableColumnSettingsButton"
            anchors.verticalCenter: parent.verticalCenter

            onClicked: columnPopup.open()
        }
    }
    Popup {
        id: columnPopup

        padding: 12
        y: control.toolbarHeight
        width: Math.min(260, control.width)
        objectName: "tableColumnSettingsPopup"
        x: Math.max(0, control.width - width - 8)
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        background: ERectangle {
            radius: 8
            border.width: 1
            color: control.surfaceColor
            border.color: control.borderColor
        }
        contentItem: Column {
            spacing: 4

            Repeater {
                model: columnPopup.visible ? control.allColumns : []

                ECheckBox {
                    width: parent.width
                    borderVisible: false
                    objectName: "tableColumnVisibility"
                    text: modelData.label || modelData.prop || modelData.type || String(index)
                    checkState: modelData.visible !== false
                        && control.hiddenColumns.indexOf(Logic.columnKey(modelData, index)) < 0
                        ? Qt.Checked
                        : Qt.Unchecked

                    onClicked: control.setColumnVisible(Logic.columnKey(modelData, index), checked)
                }
            }
        }
    }
    Component {
        id: validationFactory

        EFormItem {
            visible: false
            showMessage: false
            propagateToField: false
            inheritFormConfig: false

            Item {
                property var modelValue
            }
        }
    }
    Loader {
        id: tableTools

        property bool toolsLoaded: false

        function openMenu(row, column, x, y) {
            toolsLoaded = true
            item.openMenu(row, column, x, y)
        }

        y: control.topPadding
        x: control.leftPadding
        visible: control.showToolbar
        width: control.availableWidth
        active: control.showToolbar || toolsLoaded
        sourceComponent: Private.TableTools {
            owner: control
        }

        onLoaded: toolsLoaded = true
    }
    Loader {
        active: control.pagination
        x: control.leftPadding + 8
        y: control.height - control.bottomPadding - control.pagerHeight + 6
        sourceComponent: EPagination {
            pageSize: control.pageSize
            pageSizes: control.pageSizes
            objectName: "tablePagination"
            total: control.effectiveTotal
            currentPage: control.currentPage
            pagerCount: control.width < 640 ? 5 : 7
            layout: control.width >= 640 ? "total, sizes, prev, pager, next, jumper" : "total, prev, pager, next"

            onSizeChange: control.pageSize = pageSize
            onCurrentChange: control.currentPage = currentPage
        }
    }
    ELoading {
        z: 1000002
        target: control
        loading: control.loading
        text: control.localizedTexts.Loading
    }
}

.pragma library
.import "../../private/ArrayUtils.js" as Arrays

function ownValue(object, key) {
    return object && Object.prototype.hasOwnProperty.call(object, key) ? object[key] : undefined
}

function columnKey(column, index) {
    return String(column._columnKey === undefined ? column.columnKey || column.key || column.prop || column.property || column.type || index : column._columnKey)
}

function valueAt(row, path) {
    const parts = String(path || "").split(".")
    let value = row
    for (let index = 0; index < parts.length && value !== null && value !== undefined; ++index)
        value = value[parts[index]]
    return value
}

function compareValues(left, right) {
    const leftMissing = left === null || left === undefined || typeof left === "number" && isNaN(left)
    const rightMissing = right === null || right === undefined || typeof right === "number" && isNaN(right)
    if (leftMissing || rightMissing)
        return leftMissing === rightMissing ? 0 : leftMissing ? 1 : -1
    if (typeof left === "number" && typeof right === "number")
        return left - right
    if (typeof left === "number" || typeof right === "number")
        return typeof left === "number" ? -1 : 1
    return String(left).localeCompare(String(right))
}

function summary(owner) {
    const rows = owner.displayRows.filter(function(entry) { return !entry.group }).map(function(entry) { return entry.row })
    if (typeof owner.summaryMethod === "function") {
        const values = owner.summaryMethod({ columns: owner.columnModel, data: rows })
        return Arrays.isArray(values) ? values : []
    }
    return owner.columnModel.map(function(column, index) {
        if (index === 0)
            return owner.sumText
        const values = rows.map(function(row) { return valueAt(row, column.prop || column.property) })
        const numbers = values.filter(function(value) { return value !== null && value !== "" && isFinite(Number(value)) })
        return numbers.length ? numbers.reduce(function(sum, value) { return sum + Number(value) }, 0) : ""
    })
}

function filteredRows(owner, source) {
    if (typeof owner.proxyConfig.query === "function" && owner.proxyConfig.remoteFilter !== false)
        return source
    const active = owner.allColumns.filter(function(column) { return owner.valuesForFilter(column).length > 0 })
    if (!active.length)
        return source
    const matches = source.map(function(entry) {
        return active.every(function(column) {
            const values = owner.valuesForFilter(column)
            return values.some(function(value) {
                return typeof column.filterMethod === "function" ? column.filterMethod(value, entry.row, column)
                    : valueAt(entry.row, column.prop || column.property) === value
            })
        })
    })
    if (owner.hasTree) {
        for (let index = 0; index < source.length; ++index)
            if (source[index].parentIndex >= 0 && matches[source[index].parentIndex])
                matches[index] = true
        for (let index = source.length - 1; index >= 0; --index)
            if (matches[index] && source[index].parentIndex >= 0)
                matches[source[index].parentIndex] = true
    }
    return source.filter(function(entry, index) { return matches[index] })
}

function columns(source) {
    const leaves = []
    const groups = []
    const stack = []
    let depth = 1
    function visit(items, level, inheritedFixed, hidden, path) {
        if (!Arrays.isArray(items))
            return
        for (let index = 0; index < items.length; ++index) {
            const original = items[index]
            if (!original || typeof original !== "object" || stack.indexOf(original) >= 0)
                continue
            const column = Object.assign({}, original)
            column.fixed = column.fixed === undefined ? inheritedFixed : column.fixed
            column.visible = !hidden && column.visible !== false
            const start = leaves.length
            if (Arrays.isArray(column.children) && column.children.length) {
                stack.push(original)
                visit(column.children, level + 1, column.fixed, !column.visible, path + "/" + index)
                stack.pop()
                groups.push({ column: column, level: level, start: start, count: leaves.length - start })
            } else {
                column._columnKey = columnKey(column, leaves.length)
                column._level = level
                column._groupPath = path
                leaves.push(column)
                depth = Math.max(depth, level + 1)
            }
        }
    }
    visit(source, 0, false, false, "")
    return { leaves: leaves, groups: groups, depth: depth }
}

function rows(owner) {
    const entries = []
    const ancestors = new Set()
    const stack = [{ items: owner.model, index: 0, level: 0, parentKey: null, parentIndex: -1, disabled: false, row: null }]
    let childIndex = owner.rowCount
    while (stack.length) {
        const frame = stack[stack.length - 1]
        if (!Arrays.isArray(frame.items) || frame.index >= frame.items.length) {
            ancestors.delete(frame.row)
            stack.pop()
            continue
        }
        const index = frame.index++
        const row = frame.items[index]
        if (!row || typeof row !== "object" || ancestors.has(row))
            continue
        const sourceIndex = frame.level === 0 ? index : childIndex++
        const key = owner.keyForRow(row, sourceIndex)
        const declaredChildren = row[owner.treeProps.children || "children"]
        const loadedChildren = ownValue(owner.lazyChildren, String(key))
        const children = loadedChildren || declaredChildren
        const hasChildren = Arrays.isArray(children) && children.length > 0
            || loadedChildren === undefined && owner.lazy && Boolean(row[owner.treeProps.hasChildren || "hasChildren"])
        const treeIndex = entries.length
        const disabled = frame.disabled || Boolean(row.disabled)
        entries.push({ row: row, index: sourceIndex, key: key, level: frame.level, treeIndex: treeIndex,
            parentIndex: frame.parentIndex, parentKey: frame.parentKey, disabled: disabled, hasChildren: hasChildren })
        if (Arrays.isArray(children) && children.length) {
            ancestors.add(row)
            stack.push({ items: children, index: 0, level: frame.level + 1, parentKey: key,
                parentIndex: treeIndex, disabled: disabled, row: row })
        }
    }
    return entries
}

function displayRows(owner) {
    const column = owner.sortColumn
    const remote = column && column.sortable === "custom"
        || typeof owner.proxyConfig.query === "function" && owner.proxyConfig.remoteSort !== false
    if (!owner.hasTree && owner.sorts.length < 2 && !(column && column.sortMethod) && !(column && column.sortBy)) {
        const rows = owner.nativeRows(owner.model, remote ? "" : owner.sortProp, remote ? "" : owner.sortOrder)
        return filteredRows(owner, rows)
    }
    const source = filteredRows(owner, owner.allRows)
    function compare(left, right) {
        if (owner.sorts.length > 1) {
            for (let index = 0; index < owner.sorts.length; ++index) {
                const sort = owner.sorts[index]
                const definition = owner.allColumns.filter(function(column) { return (column.prop || column.property) === sort.prop })[0]
                if (!definition || definition.sortable === "custom")
                    continue
                const value = typeof definition.sortMethod === "function" ? Number(definition.sortMethod(left.row, right.row)) || 0
                    : compareValues(valueAt(left.row, sort.prop), valueAt(right.row, sort.prop))
                if (value)
                    return sort.order === "descending" ? -value : value
            }
            return left.index - right.index
        }
        let result = 0
        if (typeof column.sortMethod === "function")
            result = Number(column.sortMethod(left.row, right.row)) || 0
        else {
            const by = column.sortBy || owner.sortProp
            const properties = Arrays.isArray(by) ? by : [by]
            for (let index = 0; index < properties.length && result === 0; ++index) {
                const property = properties[index]
                result = compareValues(typeof property === "function" ? property(left.row, left.index) : valueAt(left.row, property),
                    typeof property === "function" ? property(right.row, right.index) : valueAt(right.row, property))
            }
        }
        return (owner.sortOrder === "descending" ? -result : result) || left.index - right.index
    }
    const sorted = !remote && (owner.sorts.length > 1 || owner.sortOrder && column)
    if (!owner.hasTree)
        return sorted ? source.slice().sort(compare) : source
    const result = []
    const children = new Map()
    for (let index = 0; index < source.length; ++index) {
        const parent = source[index].parentIndex
        if (!children.has(parent))
            children.set(parent, [])
        children.get(parent).push(source[index])
    }
    if (sorted)
        children.forEach(function(siblings) { siblings.sort(compare) })
    const filtering = owner.allColumns.some(function(item) { return owner.valuesForFilter(item).length > 0 })
    const stack = (children.get(-1) || []).slice().reverse()
    while (stack.length) {
        const entry = stack.pop()
        result.push(entry)
        if (filtering || owner.isExpanded(entry.key)) {
            const descendants = children.get(entry.treeIndex) || []
            for (let index = descendants.length - 1; index >= 0; --index)
                stack.push(descendants[index])
        }
    }
    return result
}

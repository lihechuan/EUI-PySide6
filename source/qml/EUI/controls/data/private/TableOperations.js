.pragma library
.import "TableLogic.js" as Logic
.import "../../private/ArrayUtils.js" as Arrays

function field(column) {
    return String(column.prop || column.property || "")
}

function columnFor(owner, prop) {
    return typeof prop === "object" ? prop : owner.allColumns.filter(function(column) { return field(column) === prop })[0]
}

function htmlEscape(text) {
    return String(text === undefined || text === null ? "" : text).replace(/&/g, "&amp;").replace(/</g, "&lt;")
        .replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#39;")
}

function pageRows(owner, source) {
    return owner.pagination && typeof owner.proxyConfig.query !== "function"
        ? source.slice((owner.currentPage - 1) * owner.effectivePageSize, owner.currentPage * owner.effectivePageSize) : source
}

function rowEntries(owner, records, loaded) {
    return Logic.rows({model: records, rowCount: records.length, treeProps: owner.treeProps,
        lazyChildren: loaded || {}, lazy: false, keyForRow: function(row, index) { return owner.keyForRow(row, index) }})
}

function quote(value, separator, safe) {
    let text = value === null || value === undefined ? "" : String(value)
    if (safe && /^[=+@-]/.test(text) && !isFinite(Number(text)))
        text = "'" + text
    return text.indexOf(separator) >= 0 || /["\r\n]/.test(text) ? '"' + text.replace(/"/g, '""') + '"' : text
}

function canEdit(owner, row, column) {
    return owner.enabled && owner.editable && row && !row.disabled && column && field(column)
        && column.editable !== false && (column.editable === true || column.editRender || column.editDelegate)
        && (typeof owner.editConfig.activeMethod !== "function" || owner.editConfig.activeMethod({row: row, column: column}))
}

function apply(owner, rows, action, record) {
    if (record !== false && owner.historyLimit > 0) {
        owner.undoStack = owner.undoStack.concat([{rows: clone(owner.model), action: action}]).slice(-owner.historyLimit)
        owner.redoStack = []
    }
    const position = owner.scrollTop
    owner.internalMutation = true
    owner.model = rows
    owner.internalMutation = false
    owner.dataChange(rows, action)
    owner.setScrollTop(position)
}

function range(owner) {
    const area = owner.cellArea
    if (!area || !owner.displayRows.length || !owner.columnModel.length)
        return null
    return {top: Math.max(0, Math.min(area.startRow, area.endRow)),
        bottom: Math.min(owner.displayRows.length - 1, Math.max(area.startRow, area.endRow)),
        left: Math.max(0, Math.min(area.startColumn, area.endColumn)),
        right: Math.min(owner.columnModel.length - 1, Math.max(area.startColumn, area.endColumn))}
}

function moveRow(owner, from, to) {
    if (!owner.enabled || owner.hasTree || owner.groupFields.length || owner.sortOrder || owner.sorts.length
        || !Number.isInteger(from) || !Number.isInteger(to) || from < 0 || to < 0
        || from >= owner.model.length || to >= owner.model.length || from === to)
        return false
    const rows = owner.model.slice()
    rows.splice(to, 0, rows.splice(from, 1)[0])
    apply(owner, rows, "moveRow")
    owner.rowReordered(from, to)
    return true
}

function convert(column, value) {
    const render = column.editRender || {}
    if (typeof render.parser === "function")
        return render.parser(value)
    if (render.type === "number") {
        if (value === "" || value === null)
            return null
        const number = Number(value)
        if (!isFinite(number))
            throw new Error("Invalid number")
        return number
    }
    if (render.type === "checkbox" || render.type === "switch")
        return value === true || value === "true" || value === 1 || value === "1"
    return value
}

function setValue(row, path, value) {
    const parts = String(path).split(".")
    if (!path || parts.some(function(part) { return !part || ["__proto__", "constructor", "prototype"].indexOf(part) >= 0 }))
        return false
    let target = row
    for (let index = 0; index < parts.length - 1; ++index) {
        if (target[parts[index]] === undefined || target[parts[index]] === null)
            target[parts[index]] = {}
        if (typeof target[parts[index]] !== "object")
            return false
        target = target[parts[index]]
    }
    target[parts[parts.length - 1]] = value
    return true
}

function validateCell(owner, row, column, value) {
    const prop = field(column)
    let rules = owner.editRules[prop] || column.rules || []
    rules = (Arrays.isArray(rules) ? rules : [rules]).map(function(rule) {
        if (typeof rule.validator !== "function")
            return rule
        return Object.assign({}, rule, {validator: function(entry, candidate, done) {
            return rule.validator(entry, candidate, done, {row: row, column: column, table: owner})
        }})
    })
    if (!rules.length)
        return Promise.resolve("")
    return owner.runCellValidation(row, column, value, rules)
}

function history(owner, redo) {
    const source = redo ? owner.redoStack : owner.undoStack
    if (!owner.enabled || !source.length || owner.validating)
        return false
    const entry = source[source.length - 1]
    const current = {rows: clone(owner.model), action: entry.action}
    if (redo) {
        owner.redoStack = source.slice(0, -1)
        owner.undoStack = owner.undoStack.concat([current])
    } else {
        owner.undoStack = source.slice(0, -1)
        owner.redoStack = owner.redoStack.concat([current])
    }
    owner.cancelEdit()
    apply(owner, clone(entry.rows), redo ? "redo" : "undo", false)
    return true
}

function moveColumn(owner, from, to) {
    if (!owner.enabled || !Number.isInteger(from) || !Number.isInteger(to) || from < 0 || to < 0
        || from >= owner.columnModel.length || to >= owner.columnModel.length || from === to)
        return false
    const source = owner.columnModel[from]
    const target = owner.columnModel[to]
    if ((source.fixed || false) !== (target.fixed || false) || source._groupPath !== target._groupPath)
        return false
    const keys = owner.columnModel.map(function(column, index) { return Logic.columnKey(column, index) })
    keys.splice(to, 0, keys.splice(from, 1)[0])
    owner.columnOrder = keys
    owner.columnReordered(from, to)
    return true
}

function copyArea(owner, cut) {
    const area = range(owner)
    if (!area)
        return ""
    const lines = []
    const changes = []
    for (let row = area.top; row <= area.bottom; ++row) {
        const values = []
        for (let column = area.left; column <= area.right; ++column) {
            const record = owner.displayRows[row].row
            const definition = owner.columnModel[column]
            values.push(quote(owner.cellValue(record, definition), "\t", false))
            if (cut && canEdit(owner, record, definition))
                changes.push({row: record, column: definition, value: ""})
        }
        lines.push(values.join("\t"))
    }
    const text = lines.join("\n")
    if (owner.writeClipboard(text) && cut)
        mutateCells(owner, changes, true, "cut")
    return text
}

function aggregate(rows, prop, method) {
    const values = rows.map(function(row) { return Logic.valueAt(row, prop) })
    if (method === "count")
        return rows.length
    if (method === "distinct")
        return new Set(values).size
    const numbers = values.filter(function(value) { return value !== null && value !== "" && value !== undefined && isFinite(Number(value)) }).map(Number)
    if (!numbers.length)
        return null
    if (method === "min")
        return numbers.reduce(function(left, right) { return Math.min(left, right) })
    if (method === "max")
        return numbers.reduce(function(left, right) { return Math.max(left, right) })
    const total = numbers.reduce(function(sum, value) { return sum + value }, 0)
    return method === "avg" || method === "average" ? total / numbers.length : total
}

function pasteArea(owner, text) {
    const area = range(owner)
    if (!area)
        return Promise.resolve(false)
    let matrix
    try { matrix = parseDelimited(text === undefined ? owner.readClipboard() : text, "\t") }
    catch (error) {
        owner.operationFailed("paste", error.message)
        return Promise.resolve(false)
    }
    const changes = []
    for (let row = 0; row < matrix.length; ++row) {
        if (area.top + row >= owner.displayRows.length)
            return Promise.resolve(false)
        for (let column = 0; column < matrix[row].length; ++column) {
            if (area.left + column >= owner.columnModel.length)
                return Promise.resolve(false)
            changes.push({row: owner.displayRows[area.top + row].row,
                column: owner.columnModel[area.left + column], value: matrix[row][column]})
        }
    }
    return mutateCells(owner, changes, true, "paste")
}

function mergeSpan(merges, row, column, rowCount, columnCount) {
    for (const merge of merges) {
        const top = Number(merge.row === undefined ? merge.rowIndex : merge.row)
        const left = Number(merge.col === undefined ? merge.columnIndex : merge.col)
        const rows = Math.min(rowCount - top, Math.max(1, Math.floor(Number(merge.rowspan) || 1)))
        const columns = Math.min(columnCount - left, Math.max(1, Math.floor(Number(merge.colspan) || 1)))
        if (!Number.isInteger(top) || !Number.isInteger(left) || top < 0 || left < 0 || top >= rowCount || left >= columnCount)
            continue
        if (row === top && column === left)
            return {rowspan: rows, colspan: columns}
        if (row >= top && row < top + rows && column >= left && column < left + columns)
            return {rowspan: 0, colspan: 0}
    }
    return {rowspan: 1, colspan: 1}
}

function remove(owner, records) {
    if (!owner.enabled)
        return false
    const requested = Arrays.isArray(records) ? records : [records]
    const keys = new Set(requested.map(function(row) { const entry = owner.rowEntry(row)
     return entry ? owner.entryKey(entry) : row }))
    const removed = []
    const rows = clone(owner.model)
    const entries = rowEntries(owner, rows)
    entries.forEach(function(entry) {
        if (!keys.has(entry.key))
            return
        let parent = entry.parentIndex
        while (parent >= 0) {
            if (keys.has(entries[parent].key))
                return
            parent = entries[parent].parentIndex
        }
        const siblings = entry.parentIndex < 0 ? rows : entries[entry.parentIndex].row[owner.treeProps.children || "children"]
        const original = owner.rowEntry(entry.key)
        removed.push(original ? original.row : entry.row)
        siblings.splice(siblings.indexOf(entry.row), 1)
    })
    if (removed.length)
        apply(owner, rows, "remove")
    return {rows: removed, row: removed[0] || null}
}

function replace(owner, query, replacement, options) {
    options = options || {}
    const found = find(owner, query, options).filter(function(match) { return canEdit(owner, match.row, match.column) })
    const targets = options.all === false ? found.slice(0, 1) : found
    let expression
    try { expression = options.regex ? new RegExp(String(query), options.caseSensitive ? "g" : "gi") : null }
    catch (error) { return Promise.resolve(false) }
    const changes = targets.map(function(match) {
        const value = String(match.value === null || match.value === undefined ? "" : match.value)
        const replaced = options.wholeCell ? replacement : expression ? value.replace(expression, replacement)
            : value.replace(new RegExp(String(query).replace(/[.*+?^${}()|[\]\\]/g, "\\$&"), options.caseSensitive ? "g" : "gi"), function() { return replacement })
        return {row: match.row, column: match.column, value: replaced}
    })
    return mutateCells(owner, changes, true, "replace")
}

function parseDelimited(text, separator) {
    const rows = []
    let row = []
    let value = ""
    let quoted = false
    let closed = false
    text = String(text).replace(/^\uFEFF/, "")
    for (let index = 0; index < text.length; ++index) {
        const character = text[index]
        if (quoted) {
            if (character === '"' && text[index + 1] === '"') {
                value += '"'
                ++index
            } else if (character === '"') {
                quoted = false
                closed = true
            } else {
                value += character
            }
        } else if (character === '"' && !value && !closed) {
            quoted = true
        } else if (character === separator || character === "\n" || character === "\r") {
            row.push(value)
            value = ""
            closed = false
            if (character !== separator) {
                rows.push(row)
                row = []
                if (character === "\r" && text[index + 1] === "\n")
                    ++index
            }
        } else {
            if (closed)
                throw new Error("Unexpected text after a quoted field")
            value += character
        }
    }
    if (quoted)
        throw new Error("Unterminated quoted field")
    if (value || row.length || closed)
        rows.push(row.concat([value]))
    return rows
}

function equal(left, right) {
    const pending = [[left, right]]
    const visited = new Map()
    while (pending.length) {
        const pair = pending.pop()
        if (pair[0] === pair[1] || Number.isNaN(pair[0]) && Number.isNaN(pair[1]))
            continue
        if (!pair[0] || !pair[1] || typeof pair[0] !== "object" || typeof pair[1] !== "object"
            || Arrays.isArray(pair[0]) !== Arrays.isArray(pair[1]))
            return false
        if (pair[0] instanceof Date || pair[1] instanceof Date) {
            if (!(pair[0] instanceof Date) || !(pair[1] instanceof Date) || pair[0].getTime() !== pair[1].getTime())
                return false
            continue
        }
        if (visited.has(pair[0]) && visited.get(pair[0]).has(pair[1]))
            continue
        if (!visited.has(pair[0]))
            visited.set(pair[0], new Set())
        visited.get(pair[0]).add(pair[1])
        const keys = Object.keys(pair[0])
        if (keys.length !== Object.keys(pair[1]).length)
            return false
        for (const key of keys) {
            if (!Object.prototype.hasOwnProperty.call(pair[1], key))
                return false
            pending.push([pair[0][key], pair[1][key]])
        }
    }
    return true
}

function find(owner, query, options) {
    options = options || {}
    if (query === "" || query === undefined || query === null)
        return []
    let expression
    try { expression = options.regex ? new RegExp(String(query), options.caseSensitive ? "" : "i") : null }
    catch (error) { owner.operationFailed("find", error.message)
     return [] }
    const target = options.caseSensitive ? String(query) : String(query).toLowerCase()
    const found = []
    owner.displayRows.forEach(function(entry, rowIndex) {
        owner.columnModel.forEach(function(column, columnIndex) {
            if (!field(column))
                return
            const value = owner.cellValue(entry.row, column)
            const text = value === null || value === undefined ? "" : String(value)
            const candidate = options.caseSensitive ? text : text.toLowerCase()
            if (expression ? expression.test(text) : options.wholeCell ? candidate === target : candidate.indexOf(target) >= 0)
                found.push({row: entry.row, column: column, rowIndex: rowIndex, columnIndex: columnIndex, value: value})
        })
    })
    return found
}

function clone(value) {
    if (value === null || typeof value !== "object")
        return value
    const output = Arrays.isArray(value) ? [] : value instanceof Date ? new Date(value.getTime()) : {}
    const copies = Object.create(null)
    function bucket(source) {
        const keys = Object.keys(source)
        const signature = keys.slice(0, 3).map(function(key) {
            const descriptor = Object.getOwnPropertyDescriptor(source, key)
            const item = descriptor && descriptor.value
            return [key, item !== null && typeof item === "object" ? "object" : typeof item, item !== null && typeof item === "object" || typeof item === "function" ? null : item]
        })
        const key = JSON.stringify(signature)
        return copies[key] || (copies[key] = [])
    }
    bucket(value).push({source: value, target: output})
    const pending = [{source: value, target: output}]
    while (pending.length) {
        const item = pending.pop()
        Object.keys(item.source).forEach(function(key) {
            const child = item.source[key]
            let copy = child
            if (child !== null && typeof child === "object") {
                const memo = bucket(child)
                const existing = memo.find(function(entry) { return entry.source === child })
                copy = existing ? existing.target : undefined
                if (!existing) {
                    copy = Arrays.isArray(child) ? [] : child instanceof Date ? new Date(child.getTime()) : {}
                    memo.push({source: child, target: copy})
                    pending.push({source: child, target: copy})
                }
            }
            Object.defineProperty(item.target, key, {value: copy, enumerable: true, writable: true, configurable: true})
        })
    }
    return output
}

function validate(owner, records) {
    const rows = records === undefined ? owner.allRows.map(function(entry) { return entry.row })
        : rowEntries(owner, Arrays.isArray(records) ? records : [records]).map(function(entry) { return entry.row })
    const revision = owner.modelRevision
    owner.validating = true
    const tasks = []
    rows.forEach(function(row) {
        owner.allColumns.forEach(function(column) {
            if (owner.editRules[field(column)] || column.rules)
                tasks.push(validateCell(owner, row, column, Logic.valueAt(row, field(column))).then(function(message) {
                    return message ? {row: row, column: column, message: message} : null
                }))
        })
    })
    return Promise.all(tasks).then(function(results) {
        owner.validating = false
        if (revision !== owner.modelRevision)
            return false
        owner.validationErrors = results.filter(function(error) { return error !== null })
        owner.validationFinished(owner.validationErrors.length === 0, owner.validationErrors)
        return owner.validationErrors.length === 0
    }, function(error) {
        owner.validating = false
        owner.operationFailed("validate", String(error))
        return false
    })
}

function recordset(owner) {
    const baseline = new Map()
    const current = new Map()
    function collect(rows, target) {
        const pending = [{rows: rows, index: 0, root: true}]
        const visited = new Set()
        let childIndex = rows.length
        while (pending.length) {
            const frame = pending[pending.length - 1]
            if (frame.index >= frame.rows.length) {
                pending.pop()
                continue
            }
            const index = frame.index++
            const row = frame.rows[index]
            if (!row || visited.has(row))
                continue
            visited.add(row)
            target.set(owner.keyForRow(row, frame.root ? index : childIndex++), row)
            const children = row[owner.treeProps.children || "children"]
            if (Arrays.isArray(children))
                pending.push({rows: children, index: 0, root: false})
        }
    }
    collect(owner.sourceRows, baseline)
    collect(owner.model, current)
    const inserted = []
    const removed = []
    const updated = []
    current.forEach(function(row, key) {
        if (!baseline.has(key))
            inserted.push(row)
        else if (!equal(row, baseline.get(key)))
            updated.push(row)
    })
    baseline.forEach(function(row, key) {
        if (!current.has(key))
            removed.push(row)
    })
    return {insertRecords: inserted, removeRecords: removed, updateRecords: updated}
}

function pivot(owner, rowFields, columnField, valueField, method) {
    rowFields = Arrays.isArray(rowFields) ? rowFields : [rowFields]
    const groups = new Map()
    const columnValues = []
    owner.allRows.forEach(function(entry) {
        const record = entry.row
        const key = JSON.stringify(rowFields.map(function(prop) { return Logic.valueAt(record, prop) }))
        const column = String(Logic.valueAt(record, columnField))
        if (columnValues.indexOf(column) < 0)
            columnValues.push(column)
        if (!groups.has(key))
            groups.set(key, {record: record, cells: new Map()})
        const cells = groups.get(key).cells
        if (!cells.has(column))
            cells.set(column, [])
        cells.get(column).push(record)
    })
    const rows = []
    groups.forEach(function(group) {
        const row = {}
        rowFields.forEach(function(prop) { setValue(row, prop, Logic.valueAt(group.record, prop)) })
        group.cells.forEach(function(records, column) { row[column] = aggregate(records, valueField, method || "sum") })
        rows.push(row)
    })
    return {rows: rows, columns: rowFields.map(function(prop) { return {prop: prop, label: prop} })
        .concat(columnValues.map(function(value) { return {prop: value, label: value} }))}
}

function fillArea(owner, source) {
    const target = range(owner)
    if (!target || !source)
        return Promise.resolve(false)
    const top = Math.min(source.startRow, source.endRow)
    const bottom = Math.max(source.startRow, source.endRow)
    const left = Math.min(source.startColumn, source.endColumn)
    const right = Math.max(source.startColumn, source.endColumn)
    if (top < 0 || left < 0 || bottom >= owner.displayRows.length || right >= owner.columnModel.length)
        return Promise.resolve(false)
    const changes = []
    for (let row = target.top; row <= target.bottom; ++row)
        for (let column = target.left; column <= target.right; ++column) {
            if (row >= top && row <= bottom && column >= left && column <= right)
                continue
            const sourceRow = top + ((row - top) % (bottom - top + 1) + bottom - top + 1) % (bottom - top + 1)
            const sourceColumn = left + ((column - left) % (right - left + 1) + right - left + 1) % (right - left + 1)
            changes.push({row: owner.displayRows[row].row, column: owner.columnModel[column],
                value: owner.cellValue(owner.displayRows[sourceRow].row, owner.columnModel[sourceColumn])})
        }
    return mutateCells(owner, changes, true, "fill")
}

function insert(owner, records, position) {
    if (!owner.enabled || !Arrays.isArray(owner.model))
        return false
    const additions = clone(Arrays.isArray(records) ? records : [records || {}])
    if (additions.some(function(row) { return !row || typeof row !== "object" || Arrays.isArray(row) }))
        return false
    const keys = new Set(owner.allRows.map(function(entry) { return owner.entryKey(entry) }))
    for (const entry of rowEntries(owner, additions)) {
        const row = entry.row
        if (typeof owner.rowKey === "string" && owner.rowKey && Logic.valueAt(row, owner.rowKey) === undefined)
            setValue(row, owner.rowKey, "eui-row-" + Date.now() + "-" + (++owner.generatedRowId))
        const key = owner.keyForRow(row, owner.model.length + entry.index)
        if (owner.rowKey && keys.has(key))
            return false
        keys.add(key)
    }
    const rows = owner.model.slice()
    const index = position === undefined || position === -1 ? rows.length
        : typeof position === "number" ? Math.max(0, Math.min(rows.length, Math.floor(position))) : rows.indexOf(position)
    if (index < 0)
        return false
    Array.prototype.splice.apply(rows, [index, 0].concat(additions))
    apply(owner, rows, "insert")
    return {rows: additions, row: additions[0] || null}
}

function groups(owner, source) {
    if (!owner.groupFields.length || owner.hasTree)
        return source
    const result = []
    function visit(entries, level, prefix) {
        if (level >= owner.groupFields.length) {
            entries.forEach(function(entry) { result.push(Object.assign({}, entry, {groupLevel: level})) })
            return
        }
        const prop = owner.groupFields[level]
        const grouped = new Map()
        entries.forEach(function(entry) {
            const key = JSON.stringify(Logic.valueAt(entry.row, prop))
            if (!grouped.has(key))
                grouped.set(key, [])
            grouped.get(key).push(entry)
        })
        grouped.forEach(function(items, key) {
            const identity = prefix + "/" + prop + ":" + key
            const values = {}
            owner.allColumns.forEach(function(column) {
                if (column.aggregate)
                    values[field(column)] = aggregate(items.map(function(entry) { return entry.row }), field(column), column.aggregate)
            })
            const value = Logic.valueAt(items[0].row, prop)
            result.push({group: true, key: identity, row: values, index: -1, level: level, groupLevel: level,
                label: prop + ": " + String(value === undefined ? "" : value) + " (" + items.length + ")", count: items.length})
            if (owner.collapsedGroupKeys.indexOf(identity) < 0)
                visit(items, level + 1, identity)
        })
    }
    visit(source, 0, "group")
    return result
}

function query(owner, params) {
    const config = owner.proxyConfig || {}
    if (typeof config.query !== "function")
        return Promise.resolve(false)
    const generation = ++owner.queryRevision
    owner.loading = true
    owner.queryError = ""
    const context = Object.assign({page: owner.currentPage, pageSize: owner.pageSize,
        sorts: owner.sorts.length ? owner.sorts : owner.sortOrder ? [{prop: owner.sortProp, order: owner.sortOrder}] : [],
        filters: owner.filterValues, form: owner.queryForm, table: owner}, params || {})
    let pending
    try { pending = config.query(context) }
    catch (error) { pending = Promise.reject(error) }
    return Promise.resolve(pending).then(function(result) {
        if (generation !== owner.queryRevision)
            return false
        const records = Arrays.isArray(result) ? result : result && (result.rows || result.data)
        if (!Arrays.isArray(records))
            throw new Error("The data proxy must return an array or {rows, total}")
        owner.loading = false
        apply(owner, records, "query", false)
        owner.sourceRows = clone(records)
        owner.undoStack = []
        owner.redoStack = []
        owner.total = Arrays.isArray(result) || result.total === undefined ? records.length : Math.max(0, Number(result.total) || 0)
        owner.queryCompleted(result)
        return true
    }).catch(function(error) {
        if (generation === owner.queryRevision) {
            owner.loading = false
            owner.queryError = String(error.message || error)
            owner.operationFailed("query", owner.queryError)
        }
        return false
    })
}

function mutateCells(owner, changes, validate, action) {
    if (!owner.enabled || owner.validating || !changes.length)
        return Promise.resolve(false)
    let prepared
    try {
        prepared = changes.map(function(change) {
            const entry = owner.rowEntry(change.row)
            const column = columnFor(owner, change.column)
            if (!entry || !canEdit(owner, entry.row, column))
                throw new Error("The cell is not editable")
            return {key: owner.entryKey(entry), row: entry.row, column: column, value: convert(column, change.value)}
        })
    } catch (error) {
        owner.operationFailed(action, String(error.message || error))
        return Promise.resolve(false)
    }
    const revision = owner.modelRevision
    owner.validating = true
    return Promise.all(prepared.map(function(change) {
        return validate === false ? "" : validateCell(owner, change.row, change.column, change.value)
    })).then(function(messages) {
        owner.validating = false
        if (revision !== owner.modelRevision)
            return false
        const errors = messages.map(function(message, index) {
            return message ? {row: prepared[index].row, column: prepared[index].column, message: message} : null
        }).filter(function(error) { return error !== null })
        owner.validationErrors = errors
        owner.validationFinished(errors.length === 0, errors)
        if (errors.length)
            return false
        const byKey = new Map()
        prepared.forEach(function(change) {
            if (!byKey.has(change.key))
                byKey.set(change.key, [])
            byKey.get(change.key).push(change)
        })
        const rows = clone(owner.model)
        const loaded = clone(owner.lazyChildren)
        rowEntries(owner, rows, loaded).forEach(function(entry) {
            const children = Logic.ownValue(loaded, String(entry.key))
            if (Arrays.isArray(children))
                entry.row[owner.treeProps.children || "children"] = children
            const changes = byKey.get(entry.key) || []
            changes.forEach(function(change) {
                if (!setValue(entry.row, field(change.column), change.value))
                    throw new Error("Invalid field path")
            })
        })
        apply(owner, rows, action || "edit")
        prepared.forEach(function(change) {
            owner.cellValueChanged(change.row, change.column, change.value)
        })
        return true
    }, function(error) {
        owner.validating = false
        owner.operationFailed(action, String(error.message || error))
        return false
    }).catch(function(error) {
        owner.validating = false
        owner.operationFailed(action, String(error.message || error))
        return false
    })
}

function importText(owner, text, options) {
    options = options || {}
    const type = options.type || "csv"
    let records
    try {
        if (["csv", "tsv", "txt", "json", "html", "xml", "matrix"].indexOf(type) < 0)
            throw new Error("Unsupported import format")
        if (type === "json") {
            records = JSON.parse(text)
        } else {
            let matrix
            if (type === "matrix") {
                matrix = JSON.parse(text)
                if (!Arrays.isArray(matrix) || matrix.some(function(row) { return !Arrays.isArray(row) }))
                    throw new Error("Expected a row matrix")
            } else if (type === "xml" || type === "html") {
                const decode = function(value) { return value.replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/&quot;/g, '"').replace(/&#39;/g, "'").replace(/&amp;/g, "&") }
                const rows = String(text).match(type === "xml" ? /<Row\b[^>]*>[\s\S]*?<\/Row>/gi : /<tr\b[^>]*>[\s\S]*?<\/tr>/gi) || []
                matrix = rows.map(function(row) {
                    const cells = row.match(type === "xml" ? /<data\b[^>]*>[\s\S]*?<\/Data>/gi : /<t[dh]\b[^>]*>[\s\S]*?<\/t[dh]>/gi) || []
                    return cells.map(function(cell) { return decode(cell.replace(/<[^>]*>/g, "")) })
                })
            } else {
                matrix = parseDelimited(text, type === "tsv" || type === "txt" ? "\t" : ",")
            }
            if (!matrix.length)
                throw new Error("No rows found")
            const columns = owner.allColumns.filter(function(column) { return field(column) })
            if (typeof owner.rowKey === "string" && owner.rowKey && !columns.some(function(column) { return field(column) === owner.rowKey }))
                columns.push({prop: owner.rowKey})
            const headers = options.header === false ? columns.map(field) : matrix.shift()
            const mapped = headers.map(function(header) { return columns.filter(function(column) { return field(column) === header || column.label === header })[0] })
            if (mapped.some(function(column) { return !column }))
                throw new Error("The import header contains unknown fields")
            records = matrix.map(function(values) {
                if (values.length !== mapped.length)
                    throw new Error("The import row has an incorrect column count")
                const row = {}
                mapped.forEach(function(column, index) {
                    if (!setValue(row, field(column), convert(column, values[index])))
                        throw new Error("Invalid field path")
                })
                return row
            })
        }
        if (!Arrays.isArray(records) || records.some(function(row) { return !row || typeof row !== "object" || Arrays.isArray(row) }))
            throw new Error("Expected an array of row objects")
        records = clone(records)
        const keys = new Set()
        if (owner.rowKey)
            rowEntries(owner, records).forEach(function(entry) {
                const key = entry.key
                if (key === undefined || keys.has(key))
                    throw new Error("Missing or duplicate row key")
                keys.add(key)
            })
    } catch (error) {
        owner.operationFailed("import", error.message)
        return Promise.resolve(false)
    }
    if (!owner.enabled)
        return Promise.resolve(false)
    const revision = owner.modelRevision
    return validate(owner, records).then(function(valid) {
        if (!valid || revision !== owner.modelRevision)
            return false
        if (options.mode === "append")
            return Boolean(insert(owner, records))
        apply(owner, records, "import")
        return true
    })
}

function exportText(owner, options) {
    options = options || {}
    const format = options.type || "csv"
    if (["csv", "tsv", "txt", "json", "html", "xml", "matrix"].indexOf(format) < 0)
        throw new Error("Unsupported export format")
    const columns = (options.columns || owner.columnModel).filter(function(column) { return field(column) && column.exportable !== false })
    if (options.includeKey !== false && typeof owner.rowKey === "string" && owner.rowKey
        && !columns.some(function(column) { return field(column) === owner.rowKey }))
        columns.push({prop: owner.rowKey, label: owner.rowKey})
    const rows = options.data || (options.mode === "selected" ? owner.selectedRows
        : options.mode === "all" ? owner.allRows.map(function(entry) { return entry.row }) : owner.displayRows.filter(function(entry) { return !entry.group }).map(function(entry) { return entry.row }))
    const value = function(row, column) { return options.formatted ? owner.cellText(row, column, 0) : owner.cellValue(row, column) }
    if (format === "matrix")
        return JSON.stringify((options.header === false ? [] : [columns.map(field)]).concat(rows.map(function(row) {
            return columns.map(function(column) { return value(row, column) })
        })))
    if (format === "json")
        return JSON.stringify(rows.map(function(row) {
            const record = {}
            columns.forEach(function(column) { setValue(record, field(column), value(row, column)) })
            return record
        }), null, 2)
    if (format === "html")
        return '<!DOCTYPE html><html><head><meta charset="utf-8"><style>table{border-collapse:collapse}th,td{border:1px solid #aaa;padding:6px}</style></head><body><table><thead><tr>'
            + columns.map(function(column) { return "<th>" + htmlEscape(column.label || field(column)) + "</th>" }).join("")
            + "</tr></thead><tbody>" + rows.map(function(row) { return "<tr>" + columns.map(function(column) { return "<td>" + htmlEscape(value(row, column)) + "</td>" }).join("") + "</tr>" }).join("")
            + "</tbody></table></body></html>"
    if (format === "xml")
        return '<?xml version="1.0" encoding="UTF-8"?><Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"><Worksheet ss:Name="Table"><Table>'
            + [columns.map(function(column) { return field(column) })].concat(rows.map(function(row) { return columns.map(function(column) { return value(row, column) }) })).map(function(values) {
                return "<Row>" + values.map(function(item) { return '<Cell><Data ss:Type="' + (typeof item === "number" ? "Number" : "String") + '">' + htmlEscape(item) + "</Data></Cell>" }).join("") + "</Row>"
            }).join("") + "</Table></Worksheet></Workbook>"
    const separator = format === "tsv" || format === "txt" ? "\t" : ","
    const lines = options.header === false ? [] : [columns.map(function(column) { return quote(field(column), separator, true) }).join(separator)]
    rows.forEach(function(row) { lines.push(columns.map(function(column) { return quote(value(row, column), separator, options.safe !== false) }).join(separator)) })
    return lines.join("\r\n")
}

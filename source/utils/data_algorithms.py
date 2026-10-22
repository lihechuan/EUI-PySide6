# Keep QML values in their JavaScript engine during bulk operations. Converting
# every cell through QVariant loses object identity and makes large models slow.
ALGORITHMS = r"""({
    array: function(value) {
        return Array.isArray(value) || Object.prototype.toString.call(value) === "[object V4Sequence]"
    },
    tableRows: function(model, prop, order) {
        const rows = []
        if (!this.array(model))
            return rows
        for (let i = 0; i < model.length; ++i)
            rows.push({row: model[i], index: i})
        if (!prop || (order !== "ascending" && order !== "descending"))
            return rows
        const path = prop.split(".")
        function value(row) {
            let result = row
            for (let i = 0; i < path.length; ++i)
                result = result !== null && typeof result === "object" ? result[path[i]] : undefined
            return result
        }
        function missing(v) {
            return v === null || v === undefined || typeof v === "number" && isNaN(v)
        }
        rows.sort(function(a, b) {
            const left = value(a.row), right = value(b.row)
            let result = 0
            if (missing(left) || missing(right))
                result = Number(missing(left)) - Number(missing(right))
            else if (typeof left === "number" && typeof right === "number")
                result = left < right ? -1 : left > right ? 1 : 0
            else if ((typeof left === "number") !== (typeof right === "number"))
                result = typeof left === "number" ? -1 : 1
            else
                result = String(left).localeCompare(String(right))
            return (order === "descending" ? -result : result) || a.index - b.index
        })
        return rows
    },
    treeVisibleNodes: function(nodes, expandedKeys) {
        if (!this.array(nodes))
            return []
        const expanded = new Set(this.array(expandedKeys) ? Array.prototype.map.call(expandedKeys, String) : [])
        const output = []
        let hidden = -1
        for (let i = 0; i < nodes.length; ++i) {
            const node = nodes[i]
            if (hidden >= 0 && node.level > hidden)
                continue
            hidden = -1
            output.push(node)
            if (node.hasChildren && !expanded.has(String(node.key)))
                hidden = node.level
        }
        return output.length === nodes.length ? nodes : output
    },
    menuEntries: function(model, openedIndexes, horizontal) {
        const output = [], pending = [], active = new Set()
        const opened = new Set(this.array(openedIndexes) ? Array.prototype.map.call(openedIndexes, String) : [])
        if (!this.array(model))
            return output
        for (let i = model.length - 1; i >= 0; --i)
            pending.push({node: model[i], level: 0, path: [], index: i, disabled: false})
        while (pending.length) {
            const entry = pending.pop()
            if (entry.exit) {
                active.delete(entry.node)
                continue
            }
            const node = entry.node !== null && typeof entry.node === "object" ? entry.node : {}
            if (active.has(node))
                continue
            const key = node.index === undefined || node.index === null ? entry.path.concat(String(entry.index)).join("-") : String(node.index)
            const disabled = !!(entry.disabled || node.disabled)
            const children = this.array(node.children) ? node.children : []
            output.push({index: key, indexPath: entry.path.concat(key), item: node,
                text: node.text === undefined ? key : String(node.text), iconSource: Number(node.iconSource) || 0,
                disabled: disabled, level: entry.level, hasChildren: children.length > 0})
            if (!horizontal && children.length && opened.has(key)) {
                active.add(node)
                pending.push({exit: true, node: node})
                for (let i = children.length - 1; i >= 0; --i)
                    pending.push({node: children[i], level: entry.level + 1, path: entry.path.concat(key), index: i, disabled: disabled})
            }
        }
        return output
    },
    treeNodes: function(model, expandedKeys, visibleOnly, initialLevel, parentPath, inheritedDisabled) {
        const output = [], pending = [], active = new Set()
        const expanded = new Set(this.array(expandedKeys) ? Array.prototype.map.call(expandedKeys, String) : [])
        const prefix = this.array(parentPath) ? Array.prototype.map.call(parentPath, String) : []
        if (!this.array(model))
            return output
        for (let i = model.length - 1; i >= 0; --i)
            pending.push({node: model[i], level: initialLevel, path: prefix.concat(String(i)), disabled: inheritedDisabled})
        while (pending.length) {
            const entry = pending.pop()
            if (entry.exit) {
                active.delete(entry.node)
                continue
            }
            const node = entry.node !== null && typeof entry.node === "object" ? entry.node : {}
            if (active.has(node))
                continue
            const key = node.id === undefined ? entry.path.join("-") : String(node.id)
            const disabled = !!(entry.disabled || node.disabled)
            const children = this.array(node.children) ? node.children : []
            output.push({key: key, node: node, level: entry.level, disabled: disabled,
                hasChildren: children.length > 0, label: node.label !== undefined ? String(node.label) : node.text ? String(node.text) : key})
            if (children.length && (!visibleOnly || expanded.has(key))) {
                active.add(node)
                pending.push({exit: true, node: node})
                for (let i = children.length - 1; i >= 0; --i)
                    pending.push({node: children[i], level: entry.level + 1, path: entry.path.concat(String(i)), disabled: disabled})
            }
        }
        return output
    }
})"""

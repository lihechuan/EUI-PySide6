import EUI 1.0
import EUI.Private 1.0
import "private" as Private
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control

    property var model: []
    property int indent: 18
    property var load: null
    property var props: ({})
    property bool lazy: false
    property int itemHeight: 34
    property var allowDrag: null
    property var allowDrop: null
    property var checkedKeys: []
    property var loadingKeys: []
    property var expandedKeys: []
    property string nodeKey: "id"
    property bool accordion: false
    property string currentKey: ""
    property bool draggable: false
    property string draggingKey: ""
    property string filterValue: ""
    property bool showCheckbox: false
    property bool checkStrictly: false
    property var filterNodeMethod: null
    property bool autoExpandParent: true
    property bool highlightCurrent: true
    property bool checkOnClickLeaf: false
    property bool checkOnClickNode: false
    property bool defaultExpandAll: false
    property Component nodeDelegate: null
    property Component emptyDelegate: null
    property bool expandOnClickNode: false
    property int iconSource: EIcons.CHEVRON_RIGHT
    property var loadedChildren: Object.create(null)
    property string emptyText: EControlConfig.textFor(control, "NoData", ELocale.texts)

    readonly property var currentNode: findNode(currentKey)
    readonly property var halfCheckedKeys: checkSummary.half
    readonly property var checkSummary: calculateChecks(checkedKeys)
    readonly property var allNodes: flatten(model, 0, [], false, false)
    readonly property var visibleNodes: filterValue.length > 0
        ? filteredNodes() : EDataUtils.treeVisibleNodes(allNodes, expandedKeys)

    signal nodeDragStarted(var node)
    signal checked(var node, var state)
    signal loadFailed(var node, var error)
    signal nodeDragLeft(var node, var target)
    signal nodeDragOver(var node, var target)
    signal nodeSelected(var node, string key)
    signal currentChanged(var node, string key)
    signal nodeContextMenu(var node, var mouse)
    signal nodeDragEntered(var node, var target)
    signal nodeExpanded(string key, bool expanded)
    signal nodeDropped(var node, var target, string position)
    signal nodeDragEnded(var node, var target, string position)
    signal checkChanged(var node, bool checked, bool halfChecked)

    function getCurrentKey() {
        return currentKey
    }

    function getCurrentNode() {
        return currentNode
    }

    function getNode(key) {
        return findEntry(resolveKey(key))
    }

    function getHalfCheckedKeys() {
        return halfCheckedKeys.slice()
    }

    function toggle(key) {
        return setExpanded(key, !isExpanded(key))
    }

    function isLoading(key) {
        return loadingKeys.indexOf(String(key)) >= 0
    }

    function isChecked(key) {
        return checkSummary.states[String(key)] === 2
    }

    function isHalfChecked(key) {
        return checkSummary.states[String(key)] === 1
    }

    function findEntry(key) {
        return EDataUtils.treeEntry(allNodes, String(key))
    }

    function findNode(key) {
        const entry = findEntry(key)
        return entry ? entry.node : null
    }

    function remove(node) {
        return enabled && changeModel(resolveKey(node), "remove", null)
    }

    function filter(value) {
        filterValue = value === null || value === undefined ? "" : String(value)
    }

    function setCurrentNode(node, expandParents) {
        return setCurrentKey(resolveKey(node), expandParents)
    }

    function isExpanded(key) {
        return EDataUtils.isArray(expandedKeys) && expandedKeys.indexOf(String(key)) >= 0
    }

    function setCheckedNodes(nodes) {
        return EDataUtils.isArray(nodes) && setCheckedKeys(nodes.map(function(node) {
            return resolveKey(node)
        }))
    }

    function updateKeyChildren(key, children) {
        return enabled && EDataUtils.isArray(children) && changeModel(resolveKey(key), "children", children)
    }

    function insertAfter(data, reference) {
        return enabled
            && data
            && typeof data === "object"
            && changeModel(resolveKey(reference), "after", data)
    }

    function insertBefore(data, reference) {
        return enabled
            && data
            && typeof data === "object"
            && changeModel(resolveKey(reference), "before", data)
    }

    function getHalfCheckedNodes() {
        return allNodes.filter(function(entry) {
            return checkSummary.states[entry.key] === 1
        })
            .map(function(entry) {
                return entry.node
            })
    }

    function option(node, name, fallback) {
        const field = props && props[name] !== undefined ? props[name] : fallback
        return typeof field === "function" ? field(node) : node[field]
    }

    function getCheckedKeys(leafOnly) {
        return allNodes.filter(function(entry) {
            return checkSummary.states[entry.key] === 2 && (!leafOnly || !entry.hasChildren)
        })
            .map(function(entry) {
                return entry.key
            })
    }

    function clickNode(key) {
        if (!select(key))
            return false
        if (expandOnClickNode)
            toggle(key)
        if (showCheckbox && (checkOnClickNode || checkOnClickLeaf && !findEntry(key).hasChildren))
            setChecked(key, !isChecked(key))
        return true
    }

    function resolveKey(value) {
        if (value && typeof value === "object") {
            for (let index = 0; index < allNodes.length; ++index) {
                if (allNodes[index].node === value || allNodes[index] === value)
                    return allNodes[index].key
            }
        }
        return String(value)
    }

    function setCurrentKey(key, expandParents) {
        if (key === null || key === undefined) {
            currentKey = ""
            return true
        }
        const entry = findEntry(key)
        if (!entry || !select(key))
            return false
        if (expandParents !== false)
            expandAncestors(entry.key)
        return true
    }

    function select(key) {
        const entry = findEntry(key)
        if (!enabled || !entry || entry.disabled)
            return false
        const changed = currentKey !== entry.key
        currentKey = entry.key
        nodeSelected(entry.node, entry.key)
        if (changed)
            currentChanged(entry.node, entry.key)
        return true
    }

    function getCheckedNodes(leafOnly, includeHalfChecked) {
        return allNodes.filter(function(entry) {
            const state = checkSummary.states[entry.key]
            return state === 2 && (!leafOnly || !entry.hasChildren) || includeHalfChecked && state === 1
        }).map(function(entry) {
            return entry.node
        })
    }

    function append(data, parentNode) {
        if (!enabled || !data || typeof data !== "object")
            return false
        if (parentNode === null || parentNode === undefined) {
            model = (EDataUtils.isArray(model) ? model : []).concat([data])
            return true
        }
        return changeModel(resolveKey(parentNode), "append", data)
    }

    function moveNode(key, targetKey, position) {
        if (!canDrop(key, targetKey, position))
            return false
        const source = findNode(key)
        const target = findNode(targetKey)
        const original = model
        if (!remove(key) || !changeModel(targetKey, position === "inner" ? "append" : position, source)) {
            model = original
            return false
        }
        nodeDropped(source, target, position)
        return true
    }

    function expandAncestors(key) {
        const keys = EDataUtils.isArray(expandedKeys) ? expandedKeys.slice() : []
        const parents = []
        for (let index = 0; index < allNodes.length; ++index) {
            const entry = allNodes[index]
            parents.length = entry.level
            if (entry.key === String(key)) {
                parents.forEach(function(parent) {
                    if (keys.indexOf(parent.key) < 0)
                        keys.push(parent.key)
                })
                expandedKeys = keys
                return
            }
            parents.push(entry)
        }
    }

    function filteredNodes() {
        const keep = Object.create(null)
        const parents = []
        for (let index = 0; index < allNodes.length; ++index) {
            const entry = allNodes[index]
            parents.length = entry.level
            const match = typeof filterNodeMethod === "function"
                ? filterNodeMethod(filterValue, entry.node, entry)
                : entry.label.toLowerCase().indexOf(filterValue.toLowerCase()) >= 0
            if (match) {
                keep[entry.key] = true
                parents.forEach(function(parent) {
                    keep[parent.key] = true
                })
            }
            parents.push(entry)
        }
        return allNodes.filter(function(entry) {
            return keep[entry.key] === true
        })
    }

    function setCheckedKeys(keys, leafOnly) {
        if (!enabled || !EDataUtils.isArray(keys))
            return false
        const requested = Object.create(null)
        const selected = Object.create(null)
        const parents = []
        keys.forEach(function(key) {
            requested[String(key)] = true
        })
        allNodes.forEach(function(entry) {
            parents.length = entry.level
            const inherited = !checkStrictly
                && parents.length > 0
                && selected[parents[parents.length - 1].key]
            if (!entry.disabled && (requested[entry.key] || inherited))
                selected[entry.key] = true
            parents.push(entry)
        })
        checkedKeys = allNodes.filter(function(entry) {
            return selected[entry.key] && (!leafOnly || !entry.hasChildren)
        })
            .map(function(entry) {
                return entry.key
            })
        return true
    }

    function canDrop(key, targetKey, position) {
        const source = findEntry(key)
        const target = findEntry(targetKey)
        if (!enabled || !draggable || !source || !target || source.disabled || target.disabled
                || source.key === target.key || ["before", "after", "inner"].indexOf(position) < 0)
            return false
        let inside = false
        for (let index = 0; index < allNodes.length; ++index) {
            const candidate = allNodes[index]
            if (candidate.key === source.key)
                inside = true
            else if (inside && candidate.level <= source.level)
                inside = false
            if (inside && candidate.key === target.key)
                return false
        }
        return (typeof allowDrag !== "function" || allowDrag(source.node))
            && (typeof allowDrop !== "function" || allowDrop(source.node, target.node, position))
    }

    function setExpanded(key, expanded) {
        const entry = findEntry(key)
        if (!enabled || !entry || entry.disabled || !entry.hasChildren || isExpanded(key) === expanded)
            return false
        let keys = EDataUtils.isArray(expandedKeys) ? expandedKeys : []
        if (expanded && accordion) {
            const parents = []
            const siblings = []
            let parentKey = ""
            const parentByKey = Object.create(null)
            allNodes.forEach(function(candidate) {
                parents.length = candidate.level
                const parent = parents.length > 0 ? parents[parents.length - 1].key : ""
                parentByKey[candidate.key] = parent
                if (candidate.key === entry.key)
                    parentKey = parent
                parents.push(candidate)
            })
            allNodes.forEach(function(candidate) {
                if (candidate.key !== entry.key
                    && candidate.level === entry.level
                    && parentByKey[candidate.key] === parentKey)
                    siblings.push(candidate.key)
            })
            keys = keys.filter(function(value) {
                return siblings.indexOf(value) < 0
            })
        }
        expandedKeys = expanded ? keys.concat([entry.key]) : keys.filter(function(value) {
            return value !== entry.key
        })
        if (expanded && autoExpandParent)
            expandAncestors(key)
        if (expanded && lazy && loadedChildren[entry.key] === undefined)
            loadNode(entry.key)
        nodeExpanded(entry.key, expanded)
        return true
    }

    function loadNode(key) {
        const entry = key === null ? null : findEntry(key)
        const loadKey = entry ? entry.key : ""
        if (!lazy
            || typeof load !== "function"
            || isLoading(loadKey)
            || loadedChildren[loadKey] !== undefined)
            return false
        loadingKeys = loadingKeys.concat([loadKey])
        const sourceModel = model
        const wasChecked = entry && isChecked(entry.key)
        let settled = false
        const resolve = function(children) {
            if (settled)
                return
            settled = true
            loadingKeys = loadingKeys.filter(function(value) {
                return value !== loadKey
            })
            if (model !== sourceModel && (!entry || findNode(entry.key) !== entry.node))
                return
            if (!EDataUtils.isArray(children)) {
                control.loadFailed(entry ? entry.node : null, "load must resolve an array")
                return
            }
            if (entry) {
                const next = Object.assign(Object.create(null), loadedChildren)
                next[loadKey] = children
                loadedChildren = next
                if (wasChecked)
                    setChecked(loadKey, true, true)
            } else {
                model = children
            }
        }
        const reject = function(error) {
            if (settled)
                return
            settled = true
            loadingKeys = loadingKeys.filter(function(value) {
                return value !== loadKey
            })
            control.loadFailed(entry ? entry.node : null, error)
        }
        try {
            load(entry ? entry.node : null, resolve, reject)
        } catch (error) {
            reject(error)
        }
        return true
    }

    function setChecked(key, value, deep) {
        const entry = findEntry(resolveKey(key))
        if (!enabled || !entry || entry.disabled)
            return false
        const previous = checkSummary
        const selected = Object.create(null)
        previous.checked.forEach(function(key) {
            selected[key] = true
        })
        let inside = false
        const parents = []
        allNodes.forEach(function(candidate) {
            parents.length = candidate.level
            if (candidate.key === entry.key) {
                inside = true
                if (!checkStrictly)
                    parents.forEach(function(parent) {
                        delete selected[parent.key]
                    })
            } else if (inside && candidate.level <= entry.level) {
                inside = false
            }
            if ((candidate.key === entry.key || inside && (!checkStrictly || deep)) && !candidate.disabled) {
                if (value)
                    selected[candidate.key] = true
                else
                    delete selected[candidate.key]
            }
            parents.push(candidate)
        })
        checkedKeys = Object.keys(selected)
        const state = checkSummary
        allNodes.forEach(function(candidate) {
            const now = state.states[candidate.key] === 2
            const half = state.states[candidate.key] === 1
            if (now !== (previous.states[candidate.key] === 2)
                || half !== (previous.states[candidate.key] === 1))
                checkChanged(candidate.node, now, half)
        })
        checked(entry.node, { checkedKeys: getCheckedKeys(), checkedNodes: getCheckedNodes(),
            halfCheckedKeys: getHalfCheckedKeys(), halfCheckedNodes: getHalfCheckedNodes() })
        return true
    }

    function calculateChecks(keys) {
        const selected = Object.create(null)
        const states = Object.create(null)
        const children = Object.create(null)
        const parents = []
        const half = []
        const checked = []
        if (!EDataUtils.isArray(keys) || keys.length === 0)
            return { checked: checked, half: half, states: states }
        if (EDataUtils.isArray(keys))
            keys.forEach(function(key) {
                selected[String(key)] = true
            })
        for (let index = 0; index < allNodes.length; ++index) {
            const entry = allNodes[index]
            parents.length = entry.level
            if (!checkStrictly
                && !entry.disabled
                && parents.length > 0
                && selected[parents[parents.length - 1].key])
                selected[entry.key] = true
            if (parents.length > 0) {
                const parentKey = parents[parents.length - 1].key
                if (!children[parentKey])
                    children[parentKey] = []
                children[parentKey].push(entry.key)
            }
            parents.push(entry)
        }
        for (let index = allNodes.length - 1; index >= 0; --index) {
            const entry = allNodes[index]
            const descendants = children[entry.key] || []
            let state = selected[entry.key] ? 2 : 0
            if (!checkStrictly && descendants.length > 0) {
                let full = true
                let some = false
                descendants.forEach(function(key) {
                    full = full && states[key] === 2
                    some = some || states[key] > 0
                })
                state = full ? 2 : some ? 1 : 0
            }
            states[entry.key] = state
        }
        allNodes.forEach(function(entry) {
            if (states[entry.key] === 2)
                checked.push(entry.key)
            else if (states[entry.key] === 1)
                half.push(entry.key)
        })
        return { checked: checked, half: half, states: states }
    }

    function flatten(items, level, path, visibleOnly, inheritedDisabled) {
        if (!lazy && nodeKey === "id" && (!props || Object.keys(props).length === 0))
            return EDataUtils.treeNodes(items, visibleOnly ? expandedKeys
                : [], visibleOnly, level, path, inheritedDisabled)
        const result = []
        const stack = [{ items: EDataUtils.isArray(items) ? items : [], index: 0, level: level,
            path: path || [], disabled: inheritedDisabled, ancestors: [] }]
        while (stack.length > 0) {
            const frame = stack[stack.length - 1]
            if (frame.index >= frame.items.length) {
                stack.pop()
                continue
            }
            const index = frame.index++
            const node = frame.items[index]
            if (!node || typeof node !== "object" || frame.ancestors.indexOf(node) >= 0)
                continue
            const nodePath = frame.path.concat([index])
            const key = node[nodeKey] === undefined ? nodePath.join("-") : String(node[nodeKey])
            const source = loadedChildren[key] !== undefined ? loadedChildren[key]
                : option(node, "children", "children")
            const children = EDataUtils.isArray(source) ? source : []
            const disabled = frame.disabled || !!option(node, "disabled", "disabled")
            const label = option(node, "label", "label")
            const leaf = option(node, "isLeaf", "isLeaf")
            const hasChildren = children.length > 0
                || lazy && loadedChildren[key] === undefined && leaf !== true
            result.push({ key: key, node: node, label: label === undefined ? String(node.text || key)
                : String(label),
                level: frame.level, disabled: disabled, hasChildren: hasChildren })
            if (children.length > 0 && (!visibleOnly || isExpanded(key)))
                stack.push({ items: children, index: 0, level: frame.level + 1, path: nodePath,
                    disabled: disabled, ancestors: frame.ancestors.concat([node]) })
        }
        return result
    }

    function changeModel(key, operation, data) {
        if (props && typeof props.children === "function")
            return false
        const field = props && props.children ? props.children : "children"
        const paths = []
        const counters = []
        let path = null
        for (let index = 0; index < allNodes.length; ++index) {
            const entry = allNodes[index]
            counters.length = entry.level + 1
            counters[entry.level] = counters[entry.level] === undefined ? 0 : counters[entry.level] + 1
            paths.length = entry.level
            paths.push(counters[entry.level])
            if (entry.key === String(key)) {
                path = paths.slice()
                break
            }
        }
        if (!path)
            return false
        const arrays = [model]
        const ancestors = []
        for (let index = 0; index < path.length - 1; ++index) {
            const node = arrays[index][path[index]]
            ancestors.push(node)
            const key = node[nodeKey] === undefined ? path.slice(0, index + 1).join("-")
                : String(node[nodeKey])
            const children = loadedChildren[key] !== undefined ? loadedChildren[key] : node[field]
            arrays.push(EDataUtils.isArray(children) ? children : [])
        }
        let changed = arrays[arrays.length - 1].slice()
        const position = path[path.length - 1]
        if (operation === "remove")
            changed.splice(position, 1)
        else if (operation === "before" || operation === "after")
            changed.splice(position + (operation === "after" ? 1 : 0), 0, data)
        else {
            const node = Object.assign({}, changed[position])
            const nodeKeyValue = node[nodeKey] === undefined ? path.join("-") : String(node[nodeKey])
            const source = loadedChildren[nodeKeyValue] !== undefined ? loadedChildren[nodeKeyValue]
                : node[field]
            const children = EDataUtils.isArray(source) ? source.slice() : []
            node[field] = operation === "children" ? data : children.concat([data])
            changed[position] = node
        }
        for (let index = ancestors.length - 1; index >= 0; --index) {
            const node = Object.assign({}, ancestors[index])
            node[field] = changed
            changed = arrays[index].slice()
            changed[path[index]] = node
        }
        const nextLoaded = Object.assign(Object.create(null), loadedChildren)
        for (let index = 0; index < path.length; ++index) {
            const array = arrays[index]
            const node = array && array[path[index]]
            if (node) {
                const key = node[nodeKey] === undefined ? path.slice(0, index + 1).join("-")
                    : String(node[nodeKey])
                if (nextLoaded[key] !== undefined) {
                    delete nextLoaded[key]
                    if (operation !== "remove" || index < path.length - 1) {
                        let updated = changed
                        for (let depth = 0; depth <= index; ++depth)
                            updated = depth === index ? updated[path[depth]] : updated[path[depth]][field]
                        nextLoaded[key] = updated[field] || []
                    }
                }
            }
        }
        model = changed
        loadedChildren = nextLoaded
        return true
    }

    clip: true
    implicitWidth: 260
    background: ERectangle {
        color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
    }
    implicitHeight: Math.max(120, Math.min(visibleNodes.length, 10) * Math.max(1, itemHeight))
    contentItem: ListView {
        id: treeView

        clip: true
        objectName: "treeRows"
        model: control.visibleNodes
        ScrollBar.vertical: ScrollHandle { }
        boundsBehavior: Flickable.StopAtBounds
        delegate: Private.TreeRow {
            owner: control
            entry: modelData
            width: treeView.width
        }

        EEmpty {
            imageSize: 40
            anchors.centerIn: parent
            description: control.emptyText
            visible: control.visibleNodes.length === 0 && !control.emptyDelegate
        }
        Loader {
            anchors.fill: parent
            sourceComponent: control.emptyDelegate
            active: control.visibleNodes.length === 0 && sourceComponent !== null
        }
    }

    onModelChanged: {
        loadedChildren = Object.create(null)
        loadingKeys = []
    }
    onAllNodesChanged: {
        if (currentKey && !findEntry(currentKey))
            currentKey = ""
        if (defaultExpandAll)
            expandedKeys = allNodes.filter(function(entry) {
                return entry.hasChildren
            }).map(function(entry) {
                return entry.key
            })
    }
    Component.onCompleted: {
        if (defaultExpandAll)
            expandedKeys = allNodes.filter(function(entry) {
                return entry.hasChildren
            }).map(function(entry) {
                return entry.key
            })
        if (lazy && EDataUtils.isArray(model) && model.length === 0)
            loadNode(null)
    }
}

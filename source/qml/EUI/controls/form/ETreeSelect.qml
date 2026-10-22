import EUI 1.0
import EUI.Private 1.0
import "." as FormControls
import "../config/EControlConfig.js" as EControlConfig
import "../data/private/TableOperations.js" as DataOperations
import QtQuick 2.15
import QtQml 2.15

FormControls.ESelect {
    id: control

    property var data: []
    property var load: null
    property bool lazy: false
    property var cacheData: []
    property var expandedKeys: []
    property bool leavesOnly: false
    property string nodeKey: "value"
    property bool showCheckbox: false
    property bool checkStrictly: false
    property string labelRole: "label"
    property var filterNodeMethod: null
    property bool defaultExpandAll: true
    property Component nodeDelegate: null
    property string childrenRole: "children"

    readonly property var treeOptions: flattenNodes()
    readonly property var cacheOptions: flattenNodes(cacheData)

    signal loadFailed(string message)
    signal nodeExpanded(var value, bool expanded)

    function matchesQuery(option, query) {
        return typeof filterNodeMethod === "function" ? filterNodeMethod(query, option.node)
            : option.label.toLowerCase().indexOf(query.toLowerCase()) >= 0
    }

    function labelFor(key) {
        const option = treeOptions.concat(cacheOptions).find(function(item) {
            return valuesEqual(item.value, key)
        })
        return option ? option.label : String(key === undefined || key === null ? "" : key)
    }

    function checkedState(key) {
        if (!multiple || checkStrictly)
            return isSelected(key) ? 2 : 0
        const leaves = descendants(key)
        const count = leaves.filter(function(item) {
            return control.isSelected(item.value)
        }).length
        return count === 0 ? 0 : count === leaves.length ? 2 : 1
    }

    function descendants(key) {
        const parent = treeOptions.find(function(item) {
            return valuesEqual(item.value, key)
        })
        if (!parent)
            return []
        return treeOptions.filter(function(item) {
            return !item.disabled && !item.branch && (valuesEqual(item.value, key)
                || item.ancestors.some(function(ancestor) {
                    return valuesEqual(ancestor, key)
                }))
        })
    }

    function toggleExpanded(key) {
        const option = treeOptions.find(function(item) {
            return valuesEqual(item.value, key)
        })
        if (!enabled
            || !option
            || option.disabled
            || (!option.branch && (!lazy || option.node.leaf === true)))
            return false
        if (defaultExpandAll) {
            expandedKeys = treeOptions.filter(function(item) {
                return item.branch && EDataUtils.isArray(item.node[control.childrenRole])
            }).map(function(item) {
                return item.value
            })
            defaultExpandAll = false
        }
        const expanded = expandedKeys.indexOf(key) < 0
        expandedKeys = expanded ? expandedKeys.concat([key]) : expandedKeys.filter(function(item) {
            return item !== key
        })
        nodeExpanded(key, expanded)
        if (expanded && lazy && !EDataUtils.isArray(option.node[childrenRole]))
            loadNode(key)
        return true
    }

    function flattenNodes(source) {
        internal.revision
        const result = []
        const stack = [{ nodes: source === undefined ? internal.nodes
            : source, index
            : 0, ancestors
            : [], references
            : [], disabled
            : false }]
        while (stack.length > 0) {
            const frame = stack[stack.length - 1]
            if (!EDataUtils.isArray(frame.nodes) || frame.index >= frame.nodes.length) {
                stack.pop()
                continue
            }
            const node = frame.nodes[frame.index++]
            if (!node || typeof node !== "object" || frame.references.indexOf(node) >= 0)
                continue
            const children = node[childrenRole]
            const branch = EDataUtils.isArray(children) && children.length > 0
                || lazy && node.leaf !== true && !EDataUtils.isArray(children)
            const key = node[nodeKey] === undefined ? node[labelRole] : node[nodeKey]
            const disabled = frame.disabled || Boolean(node.disabled)
            result.push({ value: key, label: String(node[labelRole] || ""), node: node,
                level: frame.ancestors.length, ancestors: frame.ancestors, branch: branch, disabled: disabled })
            if (branch)
                stack.push({ nodes: children, index: 0, ancestors: frame.ancestors.concat([key]),
                references: frame.references.concat([node]), disabled: disabled })
        }
        return result
    }

    function loadNode(key, resolved) {
        const option = treeOptions.find(function(item) {
            return valuesEqual(item.value, key)
        })
        if (!enabled || !lazy || !option || option.disabled || typeof load !== "function"
                || internal.loadingNodes.indexOf(option.node) >= 0) return false
        const node = option.node
        internal.loadingNodes = internal.loadingNodes.concat([node])
        let settled = false
        function finish(children, error) {
            if (settled)
                return
            settled = true
            internal.loadingNodes = internal.loadingNodes.filter(function(item) {
                return item !== node
            })
            if (!control.treeOptions.some(function(item) {
                return item.node === node
            }))
                return
            if (!EDataUtils.isArray(children)) {
                internal.pendingChecks = internal.pendingChecks.filter(function(request) {
                    return request.node !== node && !option.ancestors.some(function(key) {
                        return control.valuesEqual(key, request.key)
                    })
                })
                control.loadFailed(String(error || "Invalid child data"))
                return
            }
            node[control.childrenRole] = children
            if (children.length === 0)
                node.leaf = true
            ++internal.revision
            if (typeof resolved === "function")
                resolved()
            internal.pendingChecks.slice(0).forEach(function(request) {
                if (internal.pendingChecks.indexOf(request) >= 0)
                    control.checkNode(request.key, true)
            })
        }
        try { load(node, function(children) {
            finish(children)
        }, function(error) {
            finish(null, error)
        }) }
        catch (error) { finish(null, error) }
        return true
    }

    function checkNode(key, checked) {
        const option = treeOptions.find(function(item) {
            return valuesEqual(item.value, key)
        })
        if (!enabled || !option || option.disabled)
            return false
        internal.pendingChecks = internal.pendingChecks.filter(function(request) {
            return request.node !== option.node && (checked
                || !option.ancestors.some(function(key) {
                    return control.valuesEqual(key, request.key)
                }))
        })
        if (checked && multiple && !checkStrictly && lazy) {
            const unknown = treeOptions.find(function(item) {
                return !item.disabled
                    && item.node.leaf !== true
                    && !EDataUtils.isArray(item.node[control.childrenRole])
                    && (valuesEqual(item.value, key) || item.ancestors.some(function(ancestor) {
                        return valuesEqual(ancestor, key)
                    }))
            })
            if (unknown) {
                internal.pendingChecks = internal.pendingChecks.concat([{key: key, node: option.node}])
                return internal.loadingNodes.indexOf(unknown.node) >= 0 || loadNode(unknown.value)
            }
        }
        if (!multiple) {
            if (option.branch && !checkStrictly)
                return toggleExpanded(key)
            value = key
            popup.close()
        } else if (checkStrictly || !option.branch) {
            const selected = isSelected(key)
            if (selected === checked)
                return true
            if (checked && multipleLimit > 0 && selectedValues.length >= multipleLimit)
                return false
            value = checked ? selectedValues.concat([key])
                : selectedValues.filter(function(item) {
                    return !valuesEqual(item, key)
                })
        } else {
            const keys = descendants(key).map(function(item) {
                return item.value
            })
            let next = selectedValues.filter(function(item) {
                return !keys.some(function(key) {
                    return valuesEqual(item, key)
                })
            })
            if (checked)
                next = next.concat(keys)
            if (multipleLimit > 0 && next.length > multipleLimit)
                return false
            value = next
        }
        changed(value)
        return true
    }

    textRole: "label"
    valueRole: "value"
    indentRole: "level"
    optionDelegate: treeOption
    placeholderText: EControlConfig.textFor(control, "SelectATreeNode", ELocale.texts)
    filterMethod: function(query, option) {
        return control.matchesQuery(option, query) || control.treeOptions.some(function(child) {
            return child.ancestors.some(function(key) {
                return control.valuesEqual(key, option.value)
            }) && control.matchesQuery(child, query)
        })
    }
    model: treeOptions.filter(function(item) {
        if (item.disabled || (control.leavesOnly && item.branch))
            return false
        return control.filterable && control.query ? true : control.defaultExpandAll
            || item.ancestors.every(function(key) {
                return control.expandedKeys.indexOf(key) >= 0
            })
    })

    onCleared: internal.pendingChecks = []
    onDataChanged: internal.pendingChecks = []

    QtObject {
        id: internal

        property int revision: 0
        property var loadingNodes: []
        property var pendingChecks: []

        readonly property var nodes: control.lazy && Object.prototype.toString.call(control.data) === "[object V4Sequence]"
            ? DataOperations.clone(control.data) : control.data
    }
    Component {
        id: treeOption

        OptionDelegate {
            id: row

            readonly property var option: parent.option.raw

            size: control.size
            width: parent.width
            objectName: "treeSelectOption"
            selected: control.isSelected(option.value)
            text: control.nodeDelegate ? "" : option.label
            implicitHeight: EDefaultConfig.controlHeight(control.size) + 2
            leftPadding: Math.max(0, option.level) * 16 + 24 + (control.showCheckbox ? 32 : 0)

            onClicked: control.checkNode(option.value, !control.isSelected(option.value))

            ETextButton {
                width: 24
                height: parent.height
                x: Math.max(0, row.option.level) * 16
                enabled: control.enabled && !row.option.disabled
                visible: row.option.branch || control.lazy && row.option.node.leaf !== true
                text: internal.loadingNodes.indexOf(row.option.node) >= 0 ? "…"
                    : control.expandedKeys.indexOf(row.option.value) >= 0
                        || control.defaultExpandAll && EDataUtils.isArray(row.option.node[control.childrenRole])
                            ? "−"
                            : "+"

                onClicked: control.toggleExpanded(row.option.value)
            }
            ECheckBox {
                width: 32
                leftPadding: 4
                rightPadding: 4
                font.bold: false
                borderVisible: false
                height: parent.height
                visible: control.showCheckbox
                x: Math.max(0, row.option.level) * 16 + 24
                enabled: control.enabled && !row.option.disabled
                checkState: control.checkedState(row.option.value) === 1 ? Qt.PartiallyChecked
                    : control.checkedState(row.option.value) === 2 ? Qt.Checked : Qt.Unchecked

                onClicked: {
                    control.checkNode(row.option.value, control.checkedState(row.option.value) !== 2)
                    checkState = Qt.binding(function() {
                        return control.checkedState(row.option.value) === 1 ? Qt.PartiallyChecked
                            : control.checkedState(row.option.value) === 2 ? Qt.Checked : Qt.Unchecked
                    })
                }
            }
            Loader {
                readonly property var node: row.option.node
                readonly property bool selected: control.checkedState(row.option.value) === 2
                readonly property bool expanded: control.defaultExpandAll
                    || control.expandedKeys.indexOf(row.option.value) >= 0

                function select() {
                    return control.checkNode(row.option.value, !selected)
                }

                active: control.nodeDelegate !== null
                sourceComponent: control.nodeDelegate
                width: Math.max(0, parent.width - x - 8)
                anchors.verticalCenter: parent.verticalCenter
                x: Math.max(0, row.option.level) * 16 + 24 + (control.showCheckbox ? 32 : 0)
            }
        }
    }
}

import EUI 1.0
import EUI.Private 1.0
import "." as FormControls
import "../config/EControlConfig.js" as EControlConfig
import "../data/private/TableOperations.js" as DataOperations
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Window 2.15
import QtQuick.Controls

FormControls.EInput {
    id: control

    property var value: []
    property var options: []
    property bool lazy: false
    property string query: ""
    property var lazyLoad: null
    property bool emitPath: true
    property bool multiple: false
    property var filterMethod: null
    property bool filterable: false
    property int maxCollapseTags: 1
    property bool collapseTags: false
    property bool checkStrictly: false
    property string labelRole: "label"
    property string valueRole: "value"
    property Component nodeDelegate: null
    property string expandTrigger: "click"
    property string childrenRole: "children"
    property var valueOnClear: EControlConfig.valueFor(control, "valueOnClear", undefined)
    property string separator: EControlConfig.textFor(control, "PathSeparator", ELocale.texts)
    property var emptyValues: EControlConfig.valueFor(control, "emptyValues", [undefined, null, ""])

    readonly property alias popup: cascadePopup
    readonly property var nodePaths: flattenPaths()
    readonly property var effectiveOptions: lazy && Object.prototype.toString.call(options) === "[object V4Sequence]"
        ? DataOperations.clone(options) : EDataUtils.isArray(options) ? options : []
    readonly property real columnHeight: Math.min(240, internal.levels.reduce(function(rows, nodes) {
        return Math.max(rows, nodes.length)
    }, 1) * Math.max(30, EDefaultConfig.controlHeight(size) + 2))
    readonly property var filteredPaths: nodePaths.filter(function(item) {
        if (item.disabled || (!control.multiple && !control.checkStrictly && item.branch))
            return false
        return !control.query || (typeof control.filterMethod === "function"
            ? control.filterMethod(item, control.query)
            : item.labels.join(control.separator).toLowerCase().indexOf(control.query.toLowerCase()) >= 0)
    })
    readonly property string selectedLabel: {
        const values = multiple && EDataUtils.isArray(value) ? value : [value]
        const labels = values.map(function(key) {
            const match = nodePaths.find(function(item) {
                return sameValue(item.path, key)
            })
            return match ? match.labels.join(separator) : ""
        }).filter(function(label) {
            return label.length > 0
        })
        return multiple && collapseTags && labels.length > Math.max(1, maxCollapseTags)
            ? labels.slice(0, Math.max(1, maxCollapseTags)).join(", ")
                + " +"
                + (labels.length - Math.max(1, maxCollapseTags))
            : labels.join(", ")
    }

    signal selected(var value)
    signal loadFailed(string message)

    function open() {
        if (!enabled)
            return
        internal.path = []
        internal.levels = [effectiveOptions]
        query = ""
        cascadePopup.open()
    }

    function isChecked(path) {
        return multiple && EDataUtils.isArray(value) ? value.some(function(key) {
            return sameValue(path, key)
        })
            : sameValue(path, value)
    }

    function sameValue(path, key) {
        return emitPath ? EDataUtils.isArray(key) && path.length === key.length
            && path.every(function(value, index) {
                return value === key[index]
            })
            : path[path.length - 1] === key
    }

    function descendants(path) {
        return nodePaths.filter(function(item) {
            return !item.disabled && !item.branch && path.length <= item.path.length
                && path.every(function(key, index) {
                    return key === item.path[index]
                })
        })
    }

    function expandNode(level, node, path) {
        internal.path = path
        const levels = internal.levels.slice(0, level + 1)
        if (EDataUtils.isArray(node[childrenRole]) && node[childrenRole].length > 0)
            levels.push(node[childrenRole])
        internal.levels = levels
    }

    function clearSelection() {
        internal.pendingChecks = []
        const next = typeof valueOnClear === "function" ? valueOnClear() : valueOnClear
        internal.clearing = true
        value = next === undefined ? [] : next
        internal.clearing = false
        query = ""
        selected(value)
    }

    function checkedState(path) {
        if (!multiple || checkStrictly)
            return isChecked(path) ? 2 : 0
        const leaves = descendants(path)
        const count = leaves.filter(function(item) {
            return control.isChecked(item.path)
        }).length
        return count === 0 ? 0 : count === leaves.length ? 2 : 1
    }

    function commitPath(path) {
        if (!enabled || !EDataUtils.isArray(path) || path.length === 0)
            return false
        const node = nodePaths.find(function(item) {
            return item.path.length === path.length && item.path.every(function(key, index) {
                return key === path[index]
            })
        })
        if (!node || node.disabled || (!checkStrictly && node.branch))
            return false
        const key = emitPath ? path.slice(0) : path[path.length - 1]
        if (multiple) {
            const values = EDataUtils.isArray(value) ? value : []
            value = isChecked(path) ? values.filter(function(item) {
                return !sameValue(path, item)
            })
                : values.concat([key])
        } else {
            value = key
            if (!checkStrictly || !node.branch)
                cascadePopup.close()
        }
        selected(value)
        return true
    }

    function selectLevel(level, index, expandOnly) {
        if (!enabled || level < 0 || level >= internal.levels.length)
            return false
        const nodes = internal.levels[level]
        if (index < 0 || index >= nodes.length || !nodes[index] || nodes[index].disabled)
            return false
        const node = nodes[index]
        const path = internal.path.slice(0, level)
        path.push(node[valueRole])
        if (lazy
            && node.leaf !== true
            && !EDataUtils.isArray(node[childrenRole])
            && typeof lazyLoad === "function") {
            internal.path = path
            return loadPath(path, function() {
                if (internal.path.length === path.length && internal.path.every(function(key, index) {
                    return key === path[index]
                }))
                    control.expandNode(level, node, path)
            })
        }
        expandNode(level, node, path)
        if (EDataUtils.isArray(node[childrenRole]) && node[childrenRole].length > 0) {
            if (checkStrictly && !multiple && !expandOnly)
                commitPath(path)
        } else if (!expandOnly)
            commitPath(path)
        return true
    }

    function flattenPaths() {
        internal.revision
        const result = []
        const stack = [{ nodes: effectiveOptions, index: 0, path: [], labels: [], refs: [], disabled: false }]
        while (stack.length > 0) {
            const frame = stack[stack.length - 1]
            if (!EDataUtils.isArray(frame.nodes) || frame.index >= frame.nodes.length) {
                stack.pop()
                continue
            }
            const node = frame.nodes[frame.index++]
            if (!node || typeof node !== "object" || frame.refs.indexOf(node) >= 0)
                continue
            const children = node[childrenRole]
            const branch = EDataUtils.isArray(children) && children.length > 0
                || (lazy && node.leaf !== true && !EDataUtils.isArray(children))
            const item = { path: frame.path.concat([node[valueRole]]), labels: frame.labels.concat([String(node[labelRole]
                || "")]),
                node: node, branch: branch, disabled: frame.disabled || Boolean(node.disabled) }
            result.push(item)
            if (branch)
                stack.push({ nodes: children, index: 0, path: item.path, labels: item.labels,
                refs: frame.refs.concat([node]), disabled: item.disabled })
        }
        return result
    }

    function loadPath(path, resolved) {
        const item = nodePaths.find(function(option) { return option.path.length === path.length
            && option.path.every(function(key, index) {
                return key === path[index]
            }) })
        if (!enabled || !lazy || !item || item.disabled || typeof lazyLoad !== "function"
                || internal.loadingNodes.indexOf(item.node) >= 0) return false
        const node = item.node
        internal.loadingNodes = internal.loadingNodes.concat([node])
        let settled = false
        function finish(children, error) {
            if (settled)
                return
            settled = true
            internal.loadingNodes = internal.loadingNodes.filter(function(item) {
                return item !== node
            })
            if (!control.nodePaths.some(function(item) {
                return item.node === node
            }))
                return
            if (!EDataUtils.isArray(children)) {
                internal.pendingChecks = internal.pendingChecks.filter(function(request) {
                    return request.path.length > item.path.length
                        || !request.path.every(function(key, index) {
                            return key === item.path[index]
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
                    control.checkPath(request.path, true)
            })
        }
        try { lazyLoad(node, function(children) {
            finish(children)
        }, function(error) {
            finish(null, error)
        }) }
        catch (error) { finish(null, error) }
        return true
    }

    function checkPath(path, checked) {
        if (!multiple)
            return commitPath(path)
        const current = nodePaths.find(function(item) { return item.path.length === path.length
            && item.path.every(function(key, index) {
                return key === path[index]
            }) })
        if (!enabled || !current || current.disabled)
            return false
        internal.pendingChecks = internal.pendingChecks.filter(function(request) {
            return request.node !== current.node && (checked || request.path.length > path.length
                || !request.path.every(function(key, index) {
                    return key === path[index]
                }))
        })
        if (checkStrictly)
            return isChecked(path) === checked ? true : commitPath(path)
        if (checked && lazy) {
            const unknown = nodePaths.find(function(item) {
                return !item.disabled
                    && item.node.leaf !== true
                    && !EDataUtils.isArray(item.node[control.childrenRole])
                    && path.length <= item.path.length && path.every(function(key, index) {
                        return key === item.path[index]
                    })
            })
            if (unknown) {
                internal.pendingChecks = internal.pendingChecks.concat([{path: path.slice(0), node: current.node}])
                return internal.loadingNodes.indexOf(unknown.node) >= 0 || loadPath(unknown.path)
            }
        }
        const leaves = descendants(path)
        if (checked && leaves.length === 0)
            return false
        let next = EDataUtils.isArray(value) ? value.slice(0) : []
        leaves.forEach(function(item) {
            next = next.filter(function(key) {
                return !control.sameValue(item.path, key)
            })
        })
        if (checked)
            next = next.concat(leaves.map(function(item) {
            return control.emitPath ? item.path.slice(0) : item.path[item.path.length - 1]
        }))
        value = next
        selected(value)
        return true
    }

    readOnly: true
    clearable: true
    implicitWidth: 280
    text: selectedLabel
    Keys.priority: Keys.BeforeItem
    suffixIcon: EIcons.CHEVRON_DOWN
    placeholderText: EControlConfig.textFor(control, "SelectACascadingOption", ELocale.texts)

    onCleared: clearSelection()
    onOptionsChanged: internal.pendingChecks = []
    onEnabledChanged: if (!enabled)
        cascadePopup.close()
    Keys.onPressed: {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Space || event.key === Qt.Key_Down) {
            open()
            event.accepted = true
        }
    }
    onValueChanged: if (!internal.clearing && (multiple || emitPath) && !EDataUtils.isArray(value)
        && !(valueOnClear !== undefined && value === valueOnClear)
        && !(value !== null
            && value !== undefined
            && value !== ""
            && EDataUtils.isArray(emptyValues)
            && emptyValues.indexOf(value) >= 0)) value = []

    QtObject {
        id: internal

        property var path: []
        property var levels: []
        property int revision: 0
        property bool clearing: false
        property var loadingNodes: []
        property var pendingChecks: []
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        anchors.rightMargin: control.clearable && control.text.length > 0 ? 34 : 0

        onClicked: {
            control.forceActiveFocus()
            control.open()
        }
    }
    PickerPopup {
        id: cascadePopup

        padding: 0
        topPadding: 6
        bottomPadding: 6
        width: Math.min(control.Window.window ? control.Window.window.width - 32 : 720,
            Math.max(control.width, internal.levels.length * 170))
        contentItem: Column {
            spacing: 6

            EInput {
                width: parent.width
                visible: control.filterable
                placeholderText: control.placeholderText

                onTextEdited: control.query = text
            }
            ListView {
                clip: true
                width: parent.width
                model: control.filteredPaths
                objectName: "cascaderOptions"
                ScrollBar.vertical: ScrollHandle {}
                height: Math.min(240, Math.max(34, contentHeight))
                visible: control.multiple || control.query.length > 0
                delegate: OptionDelegate {
                    size: control.size
                    width: ListView.view.width
                    selected: control.isChecked(modelData.path)
                    text: control.nodeDelegate ? "" : modelData.labels.join(control.separator)
                    leftPadding: control.multiple ? 40 : EDefaultConfig.horizontalPadding(control.size) + 8

                    onClicked: control.multiple
                        ? control.checkPath(modelData.path, control.checkedState(modelData.path) !== 2)
                        : control.commitPath(modelData.path)

                    Loader {
                        readonly property var node: modelData.node
                        readonly property var path: modelData.path
                        readonly property bool selected: control.checkedState(path) === 2

                        function select() {
                            return control.multiple ? control.checkPath(path, !selected)
                                : control.commitPath(path)
                        }

                        x: control.multiple ? 40 : 12
                        active: control.nodeDelegate !== null
                        sourceComponent: control.nodeDelegate
                        anchors.verticalCenter: parent.verticalCenter
                        width: Math.max(0, parent.width - x - (control.lazy && modelData.node.leaf !== true
                            && !EDataUtils.isArray(modelData.node[control.childrenRole]) ? 24 : 0))
                    }
                    ETextButton {
                        text: "+"
                        width: 24
                        height: parent.height
                        anchors.right: parent.right
                        visible: control.lazy
                            && modelData.node.leaf !== true
                            && !EDataUtils.isArray(modelData.node[control.childrenRole])

                        onClicked: control.loadPath(modelData.path)
                    }
                    ECheckBox {
                        width: 40
                        borderVisible: false
                        height: parent.height
                        anchors.left: parent.left
                        visible: control.multiple
                        checkState: control.checkedState(modelData.path) === 1 ? Qt.PartiallyChecked
                            : control.checkedState(modelData.path) === 2 ? Qt.Checked : Qt.Unchecked

                        onClicked: {
                            control.checkPath(modelData.path, control.checkedState(modelData.path) !== 2)
                            checkState = Qt.binding(function() {
                                return control.checkedState(modelData.path) === 1 ? Qt.PartiallyChecked
                                    : control.checkedState(modelData.path) === 2 ? Qt.Checked : Qt.Unchecked
                            })
                        }
                    }
                }
            }
            Flickable {
                clip: true
                width: parent.width
                height: control.columnHeight
                contentWidth: levelRow.implicitWidth
                visible: !control.multiple && control.query.length === 0

                Row {
                    id: levelRow

                    spacing: 1

                    Repeater {
                        model: internal.levels
                        delegate: ListView {
                            id: levelList

                            property int level: index

                            clip: true
                            model: modelData
                            height: control.columnHeight
                            ScrollBar.vertical: ScrollHandle {}
                            width: Math.max(170, control.width / Math.max(1, internal.levels.length))
                            delegate: OptionDelegate {
                                rightPadding: 28
                                size: control.size
                                width: levelList.width
                                enabled: modelData && !modelData.disabled
                                text: control.nodeDelegate ? ""
                                    : modelData ? modelData[control.labelRole]
                                    : ""
                                selected: modelData
                                    && internal.path[levelList.level] === modelData[control.valueRole]

                                onClicked: control.selectLevel(levelList.level, index)
                                onHoveredChanged: {
                                    if (hovered && control.expandTrigger === "hover")
                                        control.selectLevel(levelList.level, index, true)
                                }

                                Loader {
                                    readonly property var node: modelData
                                    readonly property var path: internal.path.slice(
                                        0,
                                        levelList.level
                                    ).concat([modelData[control.valueRole]])

                                    function select() {
                                        return control.selectLevel(levelList.level, index)
                                    }

                                    x: 12
                                    active: control.nodeDelegate !== null
                                    sourceComponent: control.nodeDelegate
                                    width: Math.max(0, parent.width - 40)
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                EIcon {
                                    width: 14
                                    height: 14
                                    iconSize: 12
                                    anchors.rightMargin: 8
                                    anchors.right: parent.right
                                    iconSource: EIcons.CHEVRON_RIGHT
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
                                    visible: modelData
                                        && (EDataUtils.isArray(modelData[control.childrenRole])
                                            && modelData[control.childrenRole].length > 0
                                        || control.lazy && modelData.leaf !== true)
                                }
                            }

                            ERectangle {
                                width: 1
                                height: parent.height
                                anchors.right: parent.right
                                visible: levelList.level < internal.levels.length - 1
                                color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
                            }
                        }
                    }
                }
            }
        }
    }
}

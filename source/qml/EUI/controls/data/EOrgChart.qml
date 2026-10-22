import EUI 1.0
import EUI.Private 1.0
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control

    property var model: []
    property real nodeHeight: 56
    property real nodeWidth: 150
    property var selectedKeys: []
    property real verticalGap: 48
    property var collapsedKeys: []
    property real horizontalGap: 20
    property Component nodeDelegate: null
    property string selectionMode: "single"

    readonly property var layout: buildLayout()
    readonly property string errorString: layout.error

    signal nodeClicked(var node)
    signal selectionChanged(var keys)
    signal toggled(var key, bool collapsed)

    function toggle(key) {
        if (!enabled)
            return false
        const keys = EDataUtils.isArray(collapsedKeys) ? collapsedKeys.slice() : []
        const index = keys.indexOf(key)
        if (index >= 0)
            keys.splice(index, 1)
        else
            keys.push(key)
        collapsedKeys = keys
        toggled(key, index < 0)
        return true
    }

    function select(key) {
        const entry = layout.nodes.filter(function(item) { return item.key === key })[0]
        if (!enabled || !entry || entry.node.disabled || selectionMode === "none")
            return false
        const keys = EDataUtils.isArray(selectedKeys) ? selectedKeys.slice() : []
        const index = keys.indexOf(key)
        if (selectionMode === "single")
            selectedKeys = [key]
        else if (selectionMode === "multiple") {
            if (index >= 0)
                keys.splice(index, 1)
            else
                keys.push(key)
            selectedKeys = keys
        } else if (selectionMode === "checkbox") {
            const branch = []
            const visited = []
            function visit(node, path) {
                if (!node || typeof node !== "object" || visited.indexOf(node) >= 0 || visited.length > 10000)
                    return
                visited.push(node)
                const identifier = node.key === undefined ? path : node.key
                if (!node.disabled)
                    branch.push(identifier)
                const children = EDataUtils.isArray(node.children) ? node.children : []
                children.forEach(function(child, position) { visit(child, path + "/" + position) })
            }
            visit(entry.node, entry.path)
            selectedKeys = index >= 0 ? keys.filter(function(value) { return branch.indexOf(value) < 0 })
                : keys.concat(branch.filter(function(value) { return keys.indexOf(value) < 0 }))
        } else {
            return false
        }
        nodeClicked(entry.node)
        selectionChanged(selectedKeys)
        return true
    }

    function buildLayout() {
        const result = {nodes: [], lines: [], width: 0, height: 0, error: ""}
        const roots = EDataUtils.isArray(model) ? model : model && typeof model === "object" ? [model] : []
        const seen = []
        const keys = []
        const width = Math.max(1, nodeWidth)
        const height = Math.max(1, nodeHeight)
        const gap = Math.max(0, horizontalGap)
        function measure(node, path, depth) {
            if (!node || typeof node !== "object" || seen.indexOf(node) >= 0 || depth > 128) {
                result.error = "invalid-or-cyclic-model"
                return null
            }
            seen.push(node)
            const key = node.key === undefined ? path : node.key
            if (keys.indexOf(key) >= 0) {
                result.error = "duplicate-key"
                return null
            }
            keys.push(key)
            const collapsed = EDataUtils.isArray(control.collapsedKeys) && control.collapsedKeys.indexOf(key) >= 0
            const children = []
            if (!collapsed && EDataUtils.isArray(node.children))
                node.children.forEach(function(child, index) {
                    const measured = measure(child, path + "/" + index, depth + 1)
                    if (measured)
                        children.push(measured)
                })
            return {node: node, key: key, path: path, depth: depth, children: children,
                width: Math.max(width, children.reduce(function(sum, child) { return sum + child.width }, 0)
                    + Math.max(0, children.length - 1) * gap)}
        }
        function place(entry, left, parent) {
            const x = left + (entry.width - width) / 2
            const y = entry.depth * (height + Math.max(0, verticalGap))
            result.nodes.push({node: entry.node, key: entry.key, path: entry.path, x: x, y: y})
            result.height = Math.max(result.height, y + height)
            if (parent)
                result.lines.push({x1: parent.x, y1: parent.y, x2: x + width / 2, y2: y})
            let offset = left
            entry.children.forEach(function(child) {
                place(child, offset, {x: x + width / 2, y: y + height})
                offset += child.width + gap
            })
        }
        let offset = 0
        roots.forEach(function(node, index) {
            const entry = measure(node, String(index), 0)
            if (entry) {
                place(entry, offset, null)
                offset += entry.width + gap
            }
        })
        result.width = Math.max(0, offset - gap)
        if (result.error) {
            result.nodes = []
            result.lines = []
        }
        return result
    }

    implicitWidth: Math.max(200, Math.min(800, layout.width + 24))
    implicitHeight: Math.max(80, Math.min(480, layout.height + 32))

    onLayoutChanged: connectors.requestPaint()

    Flickable {
        id: view

        clip: true
        anchors.fill: parent
        ScrollBar.vertical: ScrollHandle {}
        ScrollBar.horizontal: ScrollHandle {}
        contentWidth: Math.max(width, control.layout.width + 24)
        contentHeight: Math.max(height, control.layout.height + 32)

        Canvas {
            id: connectors

            width: view.contentWidth
            height: view.contentHeight

            onPaint: {
                const context = getContext("2d")
                context.reset()
                context.lineWidth = 1
                context.translate(Math.max(12, (view.width - control.layout.width) / 2), 8)
                context.strokeStyle = EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
                control.layout.lines.forEach(function(line) {
                    const middle = (line.y1 + line.y2) / 2
                    context.beginPath()
                    context.moveTo(line.x1, line.y1)
                    context.lineTo(line.x1, middle)
                    context.lineTo(line.x2, middle)
                    context.lineTo(line.x2, line.y2)
                    context.stroke()
                })
            }
        }
        Repeater {
            model: control.layout.nodes

            EButton {
                id: node

                readonly property var entry: modelData
                readonly property bool selected: control.selectedKeys.indexOf(entry.key) >= 0
                readonly property color accent: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)

                plain: true
                y: entry.y + 8
                Accessible.name: text
                enabled: !entry.node.disabled
                width: Math.max(1, control.nodeWidth)
                height: Math.max(1, control.nodeHeight)
                styleType: selected ? EStyle.Primary : EStyle.Default
                text: String(entry.node.label || entry.node.text || "")
                x: entry.x + Math.max(12, (view.width - control.layout.width) / 2)
                contentItem: EText {
                    font: node.font
                    text: node.text
                    elide: Text.ElideRight
                    visible: !control.nodeDelegate
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: !node.enabled ? EPaletteManager.ThemePalette.textDisabled(ETheme.dark)
                        : node.selected ? node.accent : EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                }
                background: ERectangle {
                    radius: 6
                    border.width: 1
                    border.color: node.selected || node.hovered || node.visualFocus ? node.accent
                        : EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
                    color: node.selected
                        ? Qt.rgba(node.accent.r, node.accent.g, node.accent.b, ETheme.dark ? 0.2 : 0.08)
                        : EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
                }

                onClicked: control.select(entry.key)

                Loader {
                    readonly property var node: parent.entry.node
                    readonly property bool selected: control.selectedKeys.indexOf(parent.entry.key) >= 0

                    anchors.fill: parent
                    sourceComponent: control.nodeDelegate
                }
                EButton {
                    width: 24
                    height: 24
                    circle: true
                    iconSize: 12
                    minHeight: 24
                    y: parent.height - 6
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: EDataUtils.isArray(node.entry.node.children) && node.entry.node.children.length > 0
                    iconSource: control.collapsedKeys.indexOf(node.entry.key) >= 0 ? EIcons.PLUS : EIcons.MINUS

                    onClicked: control.toggle(node.entry.key)
                }
            }
        }
    }
    Connections {
        function onDarkChanged() { connectors.requestPaint() }

        target: ETheme
    }
}

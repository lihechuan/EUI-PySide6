import QtQuick 2.15
import QtQuick.Window 2.15

Item {
    id: control

    property var gutter: 0
    property string align: "top"
    property string justify: "start"
    property real viewportWidth: Window.window ? Window.window.width : width

    readonly property var positions: layoutChildren()
    readonly property real verticalGutter: Math.max(0, Number(EDataUtils.isArray(gutter) ? gutter[1] : gutter)
        || 0)
    readonly property real horizontalGutter: Math.max(0, Number(EDataUtils.isArray(gutter) ? gutter[0] : gutter)
        || 0)

    function layoutChildren() {
        const lines = []
        let line = { items: [], width: 0, height: 0 }
        for (let index = 0; index < children.length; ++index) {
            const child = children[index]
            if (!child.visible || child.width <= 0)
                continue
            const offset = "effectiveOffset" in child
                ? child.effectiveOffset * (width + horizontalGutter) / 24
                : 0
            const needed = offset + child.width + (line.items.length ? horizontalGutter : 0)
            if (line.items.length && line.width + needed > width + 0.1) {
                lines.push(line)
                line = { items: [], width: 0, height: 0 }
            }
            line.items.push({ item: child, offset: offset })
            line.width += offset + child.width + (line.items.length > 1 ? horizontalGutter : 0)
            line.height = Math.max(line.height, child.height)
        }
        if (line.items.length)
            lines.push(line)
        const result = []
        let y = 0
        for (let row = 0; row < lines.length; ++row) {
            const current = lines[row]
            const spare = Math.max(0, width - current.width)
            const count = current.items.length
            const extra = justify === "space-between" ? spare / Math.max(1, count - 1)
                : justify === "space-around" ? spare / count
                    : justify === "space-evenly" ? spare / (count + 1)
                    : 0
            let x = justify === "end" ? spare : justify === "center" ? spare / 2
                : justify === "space-around" ? extra / 2 : justify === "space-evenly" ? extra : 0
            for (let column = 0; column < count; ++column) {
                const slot = current.items[column]
                const child = slot.item
                x += slot.offset
                const shift = "effectivePush" in child
                    ? (child.effectivePush - child.effectivePull) * (width + horizontalGutter) / 24
                    : 0
                result.push({ item: child, x: x + shift,
                    y: y
                        + (align === "middle" ? (current.height - child.height) / 2
                            : align === "bottom" ? current.height - child.height
                            : 0) })
                x += child.width + horizontalGutter + extra
            }
            y += current.height + (row < lines.length - 1 ? verticalGutter : 0)
        }
        return { items: result, height: y }
    }

    implicitHeight: positions.height
    width: parent ? parent.width : 0

    onPositionsChanged: {
        for (let index = 0; index < positions.items.length; ++index) {
            const position = positions.items[index]
            position.item.x = position.x
            position.item.y = position.y
        }
    }
}

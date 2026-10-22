import EUI 1.0
import QtQuick 2.15
import QtQml 2.15

Item {
    id: control
    default property alias content: body.data

    property var size: 12
    property var spacer: ""
    property bool wrap: true
    property bool fill: false
    property real fillRatio: 100
    property real layoutHeight: 0
    property string alignment: "center"
    property var direction: Qt.Horizontal
    property real spacing: typeof size === "number" ? Math.max(0, size)
        : size === "large" ? 16
        : size === "default" ? 12
        : 8

    readonly property var positions: layoutChildren()
    readonly property int flow: horizontal ? Flow.LeftToRight : Flow.TopToBottom
    readonly property bool horizontal: direction === Qt.Horizontal || direction === "horizontal"
    readonly property real verticalGap: EDataUtils.isArray(size) ? Math.max(0, Number(size[1]) || 0) : spacing
    readonly property real horizontalGap: EDataUtils.isArray(size) ? Math.max(0, Number(size[0]) || 0) : spacing

    function syncLayoutHeight() {
        layoutHeight = height
    }

    function naturalSize(horizontalAxis) {
        let size = 0
        let count = 0
        for (let index = 0; index < body.children.length; ++index) {
            const child = body.children[index]
            if (!child.visible)
                continue
            size += horizontalAxis ? child.width : child.height
            ++count
        }
        return size + Math.max(0, count - 1) * (horizontalAxis ? horizontalGap : verticalGap)
    }

    function layoutChildren() {
        const items = []
        for (let index = 0; index < body.children.length; ++index) {
            const child = body.children[index]
            if (child.visible)
                items.push(child)
        }
        const lines = []
        let line = { items: [], main: 0, cross: 0 }
        const gap = horizontal ? horizontalGap : verticalGap
        const crossGap = horizontal ? verticalGap : horizontalGap
        const limit = horizontal ? width : layoutHeight < naturalSize(false) - 0.1 ? layoutHeight : 0
        for (let index = 0; index < items.length; ++index) {
            const child = items[index]
            const main = horizontal ? fill ? width * Math.max(0, Math.min(100, fillRatio)) / 100
                : child.width
                : child.height
            const cross = horizontal ? child.height
                : fill ? width * Math.max(0, Math.min(100, fillRatio)) / 100
                : child.width
            if (wrap && limit > 0 && line.items.length && line.main + gap + main > limit + 0.1) {
                lines.push(line)
                line = { items: [], main: 0, cross: 0 }
            }
            line.items.push({ item: child, main: main, cross: cross })
            line.main += main + (line.items.length > 1 ? gap : 0)
            line.cross = Math.max(line.cross, cross)
        }
        if (line.items.length)
            lines.push(line)
        const positions = []
        const separators = []
        let crossPosition = 0
        let totalMain = 0
        for (let index = 0; index < lines.length; ++index) {
            const current = lines[index]
            let mainPosition = 0
            for (let slotIndex = 0; slotIndex < current.items.length; ++slotIndex) {
                const slot = current.items[slotIndex]
                const crossOffset = alignment === "center" ? (current.cross - slot.cross) / 2
                    : alignment === "end" || alignment === "flex-end" ? current.cross - slot.cross : 0
                positions.push({ item: slot.item, width: fill ? horizontal ? slot.main
                    : slot.cross
                    : !horizontal && alignment === "stretch" ? current.cross
                    : null,
                    height: horizontal && alignment === "stretch" ? current.cross
                        : null, x
                        : horizontal ? mainPosition
                        : crossPosition + crossOffset,
                    y: horizontal ? crossPosition + crossOffset : mainPosition })
                if (slotIndex < current.items.length - 1)
                    separators.push({ x: horizontal ? mainPosition + slot.main : crossPosition,
                        y: horizontal ? crossPosition : mainPosition + slot.main,
                        width: horizontal ? gap : current.cross, height: horizontal ? current.cross : gap })
                mainPosition += slot.main + gap
            }
            totalMain = Math.max(totalMain, current.main)
            crossPosition += current.cross + (index < lines.length - 1 ? crossGap : 0)
        }
        return { items: positions, separators: separators, width: horizontal ? totalMain : crossPosition,
            height: horizontal ? crossPosition : totalMain }
    }

    implicitWidth: horizontal ? naturalSize(true) : positions.width
    implicitHeight: horizontal ? positions.height : naturalSize(false)

    Component.onCompleted: syncLayoutHeight()
    onHeightChanged: Qt.callLater(syncLayoutHeight)
    onPositionsChanged: {
        for (let index = 0; index < positions.items.length; ++index) {
            const position = positions.items[index]
            position.item.x = position.x
            position.item.y = position.y
        }
    }

    Item {
        id: body

        anchors.fill: parent
    }
    Repeater {
        model: body.children

        Item {
            id: geometryOverride

            readonly property var position: control.positions.items.find(function(position) {
                return position.item === modelData
            }) || null

            Binding {
                property: "width"
                target: modelData
                restoreMode: Binding.RestoreBindingOrValue
                when: modelData.visible
                    && (control.fill || !control.horizontal && control.alignment === "stretch")
                value: control.fill ? control.width * Math.max(0, Math.min(100, control.fillRatio)) / 100
                    : geometryOverride.position && geometryOverride.position.width !== null
                        ? geometryOverride.position.width
                        : 0
            }
            Binding {
                target: modelData
                property: "height"
                restoreMode: Binding.RestoreBindingOrValue
                when: modelData.visible && control.horizontal && control.alignment === "stretch"
                value: geometryOverride.position && geometryOverride.position.height !== null
                    ? geometryOverride.position.height
                    : 0
            }
        }
    }
    Repeater {
        model: control.spacer ? control.positions.separators : []

        Loader {
            x: modelData.x
            y: modelData.y
            width: modelData.width
            height: modelData.height
            sourceComponent: typeof control.spacer === "string" ? textSpacer : control.spacer

            Component {
                id: textSpacer

                EText {
                    text: String(control.spacer)
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }
}

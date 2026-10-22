import EUI 1.0
import QtQuick 2.15
import QtQml 2.15

Item {
    id: control
    default property alias content: body.data

    property var gap: 12
    property real padding: 0
    property bool wrap: false
    property bool reverse: false
    property string align: "stretch"
    property string justify: "start"
    property string alignContent: "start"
    property string orientation: "horizontal"

    readonly property var layout: layoutState.result
    readonly property real naturalCross: measure(true)
    readonly property real naturalMain: measure(false)
    readonly property real inset: finiteSize(padding, 0)
    readonly property alias contentChildren: body.children
    readonly property bool horizontal: orientation !== "vertical"
    readonly property real verticalGap: finiteSize(EDataUtils.isArray(gap) ? gap[1] : gap, 0)
    readonly property real horizontalGap: finiteSize(EDataUtils.isArray(gap) ? gap[0] : gap, 0)

    function finiteSize(value, fallback) {
        return isFinite(value) ? Math.max(0, Number(value)) : fallback
    }

    function slotFor(item) {
        return layout.slots.find(function(slot) {
            return slot.item === item
        }) || null
    }

    function distribution(mode, spare, count) {
        let offset = 0
        let extra = 0
        if (mode === "center") {
            offset = spare / 2
        } else if (mode === "end" || mode === "flex-end") {
            offset = spare
        } else if (mode === "space-between" && count > 1) {
            extra = spare / (count - 1)
        } else if (mode === "space-around" && count > 0) {
            extra = spare / count
            offset = extra / 2
        } else if (mode === "space-evenly" && count > 0) {
            extra = spare / (count + 1)
            offset = extra
        }
        return {
            "offset": offset,
            "extra": extra
        }
    }

    function measure(crossAxis) {
        const mainGap = horizontal ? horizontalGap : verticalGap
        const crossGap = horizontal ? verticalGap : horizontalGap
        const limit = crossAxis && wrap ? Math.max(0, (horizontal ? width : height) - inset * 2) : Infinity
        let main = 0
        let cross = 0
        let total = 0
        let count = 0
        const slots = collectSlots()
        slots.forEach(function(slot) {
            if (crossAxis && count > 0 && main + mainGap + slot.main > limit + 0.01) {
                total += cross + crossGap
                main = 0
                cross = 0
                count = 0
            }
            main += slot.main + (count > 0 ? mainGap : 0)
            cross = Math.max(cross, slot.cross)
            ++count
        })
        return crossAxis ? total + cross : main
    }

    function resizeLine(slots, available) {
        let remaining = available - slots.reduce(function(value, slot) {
            return value + slot.main
        }, 0)
        for (let pass = 0; pass <= slots.length && Math.abs(remaining) > 0.01; ++pass) {
            const growing = remaining > 0
            const candidates = slots.filter(function(slot) {
                return growing ? slot.grow > 0 && slot.main < slot.maximum
                    : slot.shrink > 0 && slot.main > slot.minimum
            })
            const weight = candidates.reduce(function(value, slot) {
                return value + (growing ? slot.grow : slot.shrink * slot.base)
            }, 0)
            if (weight <= 0)
                break

            let consumed = 0
            candidates.forEach(function(slot) {
                const portion = remaining * (growing ? slot.grow : slot.shrink * slot.base) / weight
                const next = Math.max(slot.minimum, Math.min(slot.maximum, slot.main + portion))
                consumed += next - slot.main
                slot.main = next
            })
            remaining -= consumed
            if (Math.abs(consumed) < 0.01)
                break

        }
    }

    function collectSlots() {
        const slots = []
        for (let index = 0; index < body.children.length; ++index) {
            const item = body.children[index]
            if (!item.visible)
                continue

            const elastic = item.flexItem === true
            const intrinsic = horizontal ? item.implicitWidth : item.implicitHeight
            const original = elastic ? intrinsic : horizontal ? item.width : item.height
            const basis = elastic && isFinite(item.basis) && item.basis >= 0 ? item.basis : original
            const minimum = elastic ? finiteSize(item.minSize, 0) : Math.max(0, basis)
            const maximum = elastic ? Math.max(minimum, finiteSize(item.maxSize, Infinity))
                : Math.max(0, basis)
            const main = Math.max(minimum, Math.min(maximum, finiteSize(basis, 0)))
            const cross = Math.max(0, horizontal ? item.implicitHeight || item.height
                : item.implicitWidth || item.width)
            slots.push({
                "item": item,
                "main": main,
                "base": main,
                "cross": cross,
                "minimum": minimum,
                "maximum": maximum,
                "grow": elastic ? finiteSize(item.grow, 0) : 0,
                "shrink": elastic ? finiteSize(item.shrink, 1) : 0,
                "order": elastic && isFinite(item.order) ? item.order : 0,
                "index": index,
                "alignment": elastic && item.alignSelf !== "auto" ? item.alignSelf : align,
                "elastic": elastic
            })
        }
        slots.sort(function(left, right) {
            return left.order - right.order || left.index - right.index
        })
        return slots
    }

    function arrange() {
        const mainGap = horizontal ? horizontalGap : verticalGap
        const crossGap = horizontal ? verticalGap : horizontalGap
        const mainLimit = Math.max(0, (horizontal ? width : height) - inset * 2)
        const crossLimit = Math.max(0, (horizontal ? height : width) - inset * 2)
        const slots = collectSlots()
        const lines = []
        let line = {
            "slots": [],
            "main": 0,
            "cross": 0
        }
        slots.forEach(function(slot) {
            if (wrap && line.slots.length && line.main + mainGap + slot.main > mainLimit + 0.01) {
                lines.push(line)
                line = {
                    "slots": [],
                    "main": 0,
                    "cross": 0
                }
            }
            line.main += slot.main + (line.slots.length ? mainGap : 0)
            line.cross = Math.max(line.cross, slot.cross)
            line.slots.push(slot)
        })
        if (line.slots.length)
            lines.push(line)

        const naturalCross = lines.reduce(function(value, current) {
            return value + current.cross
        }, 0) + Math.max(0, lines.length - 1) * crossGap
        const crossSpare = Math.max(0, crossLimit - naturalCross)
        const crossDistribution = distribution(alignContent, crossSpare, lines.length)
        let crossPosition = inset + crossDistribution.offset
        lines.forEach(function(current) {
            if (lines.length === 1 && !wrap)
                current.cross = Math.max(current.cross, crossLimit)
            else if (alignContent === "stretch" && lines.length > 0)
                current.cross += crossSpare / lines.length
            resizeLine(
                current.slots,
                Math.max(0, mainLimit - Math.max(0, current.slots.length - 1) * mainGap)
            )
            const used = current.slots.reduce(function(value, slot) {
                return value + slot.main
            }, 0) + Math.max(0, current.slots.length - 1) * mainGap
            const placement = distribution(justify, Math.max(0, mainLimit - used), current.slots.length)
            let mainPosition = inset + placement.offset
            current.slots.forEach(function(slot) {
                const crossSize = slot.alignment === "stretch" ? current.cross : slot.cross
                const offset = distribution(slot.alignment, Math.max(0, current.cross - crossSize), 1).offset
                const position = reverse ? inset + mainLimit - (mainPosition - inset) - slot.main
                    : mainPosition
                slot.x = horizontal ? position : crossPosition + offset
                slot.y = horizontal ? crossPosition + offset : position
                slot.width = horizontal ? slot.main : crossSize
                slot.height = horizontal ? crossSize : slot.main
                mainPosition += slot.main + mainGap + placement.extra
            })
            crossPosition += current.cross + crossGap + crossDistribution.extra
        })
        return {
            "slots": slots,
            "naturalCross": naturalCross
        }
    }

    implicitWidth: inset * 2 + (horizontal ? naturalMain : naturalCross)
    implicitHeight: inset * 2 + (horizontal ? naturalCross : naturalMain)

    Item {
        id: body

        anchors.fill: parent
    }
    Timer {
        id: layoutState

        property var result: ({slots: []})

        readonly property var inputs: [control.width, control.height, control.wrap, control.reverse,
            control.inset, control.horizontalGap, control.verticalGap, control.alignContent,
            control.justify, control.collectSlots()]

        interval: 0

        onInputsChanged: restart()
        onTriggered: result = control.arrange()
    }
    Repeater {
        model: body.children

        Item {
            id: geometryOverride

            readonly property var slot: control.slotFor(modelData)

            Binding {
                delayed: true
                property: "x"
                target: modelData
                when: geometryOverride.slot !== null
                restoreMode: Binding.RestoreBindingOrValue
                value: geometryOverride.slot ? geometryOverride.slot.x : 0
            }
            Binding {
                delayed: true
                property: "y"
                target: modelData
                when: geometryOverride.slot !== null
                restoreMode: Binding.RestoreBindingOrValue
                value: geometryOverride.slot ? geometryOverride.slot.y : 0
            }
            Binding {
                delayed: true
                property: "width"
                target: modelData
                restoreMode: Binding.RestoreBindingOrValue
                value: geometryOverride.slot ? geometryOverride.slot.width : 0
                when: geometryOverride.slot !== null
                    && (geometryOverride.slot.elastic
                        || !control.horizontal && geometryOverride.slot.alignment === "stretch")
            }
            Binding {
                delayed: true
                target: modelData
                property: "height"
                restoreMode: Binding.RestoreBindingOrValue
                value: geometryOverride.slot ? geometryOverride.slot.height : 0
                when: geometryOverride.slot !== null
                    && (geometryOverride.slot.elastic
                        || control.horizontal && geometryOverride.slot.alignment === "stretch")
            }
        }
    }
}

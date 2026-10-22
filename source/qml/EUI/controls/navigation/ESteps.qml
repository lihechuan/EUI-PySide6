import EUI 1.0
import "private" as Private
import QtQuick 2.15
import QtQuick.Controls

Control {
    id: control

    property var space: 0
    property int active: 0
    property var model: []
    property bool simple: false
    property bool clickable: false
    property bool alignCenter: false
    property string finishStatus: "finish"
    property string processStatus: "process"
    property int direction: EOrientation.Horizontal

    readonly property int count: items.length
    readonly property var items: EDataUtils.isArray(model) ? model : []
    readonly property real stepHeight: resolvedSpace > 0 ? resolvedSpace : 86
    readonly property bool vertical: !simple && direction === EOrientation.Vertical
    readonly property bool relativeSpace: typeof space === "string" && /%$/.test(space.trim())
    readonly property real stepWidth: resolvedSpace > 0 ? resolvedSpace : availableWidth / Math.max(1, count)
    readonly property real resolvedSpace: {
        const value = Number(relativeSpace ? String(space).trim().slice(0, -1) : space)
        return !simple && isFinite(value) && value > 0
            ? relativeSpace ? value * (vertical ? availableHeight : availableWidth) / 100 : value : 0
    }

    signal changed(int active)
    signal stepClicked(int index, var item)

    function advance() {
        active = Math.min(count, active + 1)
    }

    function normalizeActive() {
        active = Math.max(0, Math.min(count, active))
    }

    function select(index) {
        if (!enabled || !clickable || !isFinite(index) || Math.floor(index) !== index)
            return false
        if (index < 0 || index >= count || (items[index] && items[index].disabled))
            return false
        active = index
        stepClicked(index, items[index])
        return true
    }

    function statusAt(index) {
        if (!isFinite(index) || Math.floor(index) !== index || index < 0 || index >= count)
            return "wait"
        const item = items[index]
        if (item && item.status)
            return String(item.status)
        if (index < active)
            return finishStatus
        return index === active ? processStatus : "wait"
    }

    implicitWidth: vertical ? 240 : 480
    padding: simple && !vertical ? 16 : 0
    implicitHeight: vertical ? relativeSpace ? count * 86 : Math.max(count * stepHeight, steps.implicitHeight)
        : simple ? 64 : steps.implicitHeight
    background: ERectangle {
        radius: 4
        color: control.simple && !control.vertical
            ? EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)
            : EPaletteManager.BasePalette.transparent
    }
    contentItem: Grid {
        id: steps

        columns: control.vertical ? 1 : Math.max(1, control.count)

        Repeater {
            model: control.items

            Private.StepItem {
                owner: control
                entry: modelData
                stepIndex: index
                width: control.vertical ? control.availableWidth : control.stepWidth
            }
        }
    }

    onCountChanged: normalizeActive()
    onActiveChanged: {
        const normalized = Math.max(0, Math.min(count, active))
        if (active !== normalized)
            active = normalized
        else
            changed(active)
    }
}

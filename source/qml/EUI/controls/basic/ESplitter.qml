import EUI 1.0
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

SplitView {
    id: control

    property bool lazy: false
    property int handleSize: 6
    property int resizeIndex: -1
    property int activeHandle: -1
    property var initialSizes: []
    property real pendingDelta: 0
    property int finishedIndex: -1
    property var collapseEvents: []
    property string layout: "horizontal"

    readonly property var sizes: panelSizes()

    signal resize(int index, var sizes)
    signal resizeEnd(int index, var sizes)
    signal resizeStart(int index, var sizes)
    signal collapsed(int index, string side, var sizes)

    function panelSizes() {
        const sizes = []
        for (let index = 0; index < count; ++index)
            sizes.push(orientation === Qt.Horizontal ? itemAt(index).width : itemAt(index).height)
        return sizes
    }

    function panelLimit(item, key, fallback) {
        if (!item)
            return fallback
        const attached = item.SplitView
        return orientation === Qt.Horizontal ? attached[key + "Width"] : attached[key + "Height"]
    }

    function collapsePanel(index, collapsed, side) {
        const panel = index >= 0 && index < count ? itemAt(index) : null
        if (!panel || typeof panel.setCollapsed !== "function" || !panel.collapsible)
            return false
        panel.setCollapsed(collapsed === undefined ? !panel.collapsed : Boolean(collapsed))
        collapseEvents = collapseEvents.concat([{index: index, side: side || "start"}])
        finishTimer.restart()
        return true
    }

    function resizePanels(index, delta) {
        if (index < 0 || index + 1 >= count || !isFinite(delta))
            return false
        const first = itemAt(index)
        const second = itemAt(index + 1)
        if ("resizable" in first && !first.resizable || "resizable" in second && !second.resizable)
            return false
        const sizes = initialSizes.length === count ? initialSizes : panelSizes()
        const total = sizes[index] + sizes[index + 1]
        const minimum = Math.max(
            panelLimit(first, "minimum", 0),
            total - panelLimit(second, "maximum", Infinity)
        )
        const maximum = Math.min(
            panelLimit(first, "maximum", Infinity),
            total - panelLimit(second, "minimum", 0)
        )
        if (minimum > maximum)
            return false
        const size = Math.max(minimum, Math.min(maximum, sizes[index] + delta))
        if (orientation === Qt.Horizontal) {
            first.SplitView.preferredWidth = size
            second.SplitView.preferredWidth = total - size
        } else {
            first.SplitView.preferredHeight = size
            second.SplitView.preferredHeight = total - size
        }
        return true
    }

    orientation: layout === "vertical" ? Qt.Vertical : Qt.Horizontal
    background: Item {
        ERectangle {
            z: 20
            opacity: 0.6
            visible: control.lazy && control.activeHandle >= 0
            color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
            height: control.orientation === Qt.Vertical ? Math.max(2, control.handleSize) : control.height
            width: control.orientation === Qt.Horizontal ? Math.max(2, control.handleSize) : control.width
            y: control.orientation === Qt.Vertical && control.activeHandle >= 0
                ? control.itemAt(control.activeHandle).y
                    + control.itemAt(control.activeHandle).height
                    + control.pendingDelta
                    : 0
            x: control.orientation === Qt.Horizontal && control.activeHandle >= 0
                ? control.itemAt(control.activeHandle).x
                    + control.itemAt(control.activeHandle).width
                    + control.pendingDelta
                    : 0
        }
    }
    handle: Item {
        id: handle

        property int handleIndex: 0
        property real pressPosition: 0

        function resolvedIndex() {
            const point = mapToItem(control, width / 2, height / 2)
            let nearest = 0
            let distance = Infinity
            for (let index = 0; index + 1 < control.count; ++index) {
                const item = control.itemAt(index)
                const edge = control.orientation === Qt.Horizontal ? item.x + item.width
                    : item.y + item.height
                const difference = Math.abs((control.orientation === Qt.Horizontal ? point.x
                    : point.y) - edge)
                if (difference < distance) {
                    distance = difference
                    nearest = index
                }
            }
            return nearest
        }

        implicitWidth: Math.max(2, control.handleSize)
        implicitHeight: Math.max(2, control.handleSize)

        onXChanged: Qt.callLater(function() {
            handleIndex = resolvedIndex()
        })
        onYChanged: Qt.callLater(function() {
            handleIndex = resolvedIndex()
        })

        ERectangle {
            anchors.fill: parent
            color: lazyPointer.pressed ? EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                : SplitHandle.hovered ? EPaletteManager.ThemePalette.borderHover(ETheme.dark)
                : EPaletteManager.ThemePalette.surfacePressed(ETheme.dark)
        }
        ETextButton {
            z: 10
            width: 18
            height: 24
            iconSize: 10
            leftPadding: 0
            rightPadding: 0
            iconSource: control.orientation === Qt.Horizontal ? EIcons.CHEVRON_LEFT : EIcons.CHEVRON_UP
            x: control.orientation === Qt.Horizontal ? (parent.width - width) / 2
                : parent.width / 2 - width - 2
            visible: control.itemAt(handle.handleIndex)
                && control.itemAt(handle.handleIndex).collapsible === true
            y: control.orientation === Qt.Horizontal ? parent.height / 2 - height - 2
                : (parent.height - height) / 2

            onClicked: control.collapsePanel(handle.resolvedIndex(), undefined, "start")
        }
        ETextButton {
            z: 10
            width: 18
            height: 24
            iconSize: 10
            leftPadding: 0
            rightPadding: 0
            objectName: "splitterCollapseEnd"
            x: control.orientation === Qt.Horizontal ? (parent.width - width) / 2 : parent.width / 2 + 2
            iconSource: control.orientation === Qt.Horizontal ? EIcons.CHEVRON_RIGHT : EIcons.CHEVRON_DOWN
            y: control.orientation === Qt.Horizontal ? parent.height / 2 + 2 : (parent.height - height) / 2
            visible: control.itemAt(handle.handleIndex + 1)
                && control.itemAt(handle.handleIndex + 1).collapsible === true

            onClicked: control.collapsePanel(handle.resolvedIndex() + 1, undefined, "end")
        }
        MouseArea {
            id: lazyPointer

            anchors.fill: parent
            preventStealing: true
            cursorShape: control.orientation === Qt.Horizontal ? Qt.SplitHCursor : Qt.SplitVCursor

            onCanceled: {
                control.activeHandle = -1
                control.pendingDelta = 0
            }
            onReleased: {
                if (control.lazy) {
                    control.resizePanels(control.activeHandle, control.pendingDelta)
                    control.resizeIndex = control.activeHandle
                }
                control.finishedIndex = control.activeHandle
                finishTimer.restart()
                control.activeHandle = -1
                control.pendingDelta = 0
            }
            onPositionChanged: function(mouse) {
                if (!pressed)
                    return
                const point = mapToItem(control, mouse.x, mouse.y)
                control.pendingDelta = (control.orientation === Qt.Horizontal ? point.x
                    : point.y) - handle.pressPosition
                if (!control.lazy && control.resizePanels(control.activeHandle, control.pendingDelta)) {
                    control.resizeIndex = control.activeHandle
                    finishTimer.start()
                }
            }
            onPressed: function(mouse) {
                const point = mapToItem(control, mouse.x, mouse.y)
                handle.pressPosition = control.orientation === Qt.Horizontal ? point.x : point.y
                handle.handleIndex = handle.resolvedIndex()
                control.activeHandle = handle.handleIndex
                control.initialSizes = control.panelSizes()
                control.pendingDelta = 0
                control.resizeStart(control.activeHandle, control.initialSizes)
            }
        }
    }

    Timer {
        id: finishTimer

        interval: 16

        onTriggered: {
            const sizes = control.panelSizes()
            if (control.resizeIndex >= 0) {
                const index = control.resizeIndex
                control.resizeIndex = -1
                control.resize(index, sizes)
            }
            if (control.finishedIndex >= 0) {
                const index = control.finishedIndex
                control.finishedIndex = -1
                control.resizeEnd(index, sizes)
            }
            const events = control.collapseEvents
            control.collapseEvents = []
            for (let index = 0; index < events.length; ++index)
                control.collapsed(events[index].index, events[index].side, sizes)
        }
    }
}

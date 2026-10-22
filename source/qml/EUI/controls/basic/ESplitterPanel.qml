import EUI 1.0
import QtQuick 2.15
import QtQuick.Controls

Item {
    id: control

    property var min: 0
    property var max: Infinity
    property real savedSize: 0
    property var size: undefined
    property bool resizable: true
    property bool collapsed: false
    property bool collapsible: false

    readonly property var splitter: findSplitter()
    readonly property bool horizontal: !splitter || splitter.orientation === Qt.Horizontal
    readonly property real preferredSize: dimension(size, horizontal ? implicitWidth : implicitHeight)

    signal sizeUpdated(real size)

    function findSplitter() {
        let ancestor = parent
        while (ancestor) {
            if (typeof ancestor.resizePanels === "function")
                return ancestor
            ancestor = ancestor.parent
        }
        return null
    }

    function setCollapsed(value) {
        if (!collapsible)
            return false
        if (value && !collapsed)
            savedSize = horizontal ? width : height
        collapsed = value
        if (!value && savedSize > 0)
            size = savedSize
        return true
    }

    function dimension(value, fallback) {
        if (typeof value === "string" && value.indexOf("%") >= 0)
            return Math.max(0, parseFloat(value) || 0) * (splitter ? horizontal ? splitter.width
                : splitter.height
                : 0) / 100
        return isFinite(Number(value)) && value !== undefined ? Math.max(0, Number(value)) : fallback
    }

    implicitWidth: childrenRect.width
    implicitHeight: childrenRect.height
    SplitView.preferredWidth: collapsed ? 0 : preferredSize
    SplitView.preferredHeight: collapsed ? 0 : preferredSize
    SplitView.minimumWidth: collapsed ? 0 : !resizable ? preferredSize : dimension(min, 0)
    SplitView.minimumHeight: collapsed ? 0 : !resizable ? preferredSize : dimension(min, 0)
    SplitView.maximumWidth: collapsed ? 0 : !resizable ? preferredSize : dimension(max, Infinity)
    SplitView.maximumHeight: collapsed ? 0 : !resizable ? preferredSize : dimension(max, Infinity)

    onWidthChanged: {
        if (horizontal && splitter && (splitter.resizing || splitter.activeHandle >= 0))
            sizeUpdated(width)
    }
    onHeightChanged: {
        if (!horizontal && splitter && (splitter.resizing || splitter.activeHandle >= 0))
            sizeUpdated(height)
    }
}

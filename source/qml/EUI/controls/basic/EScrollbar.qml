import EUI 1.0
import EUI.Private 1.0
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls
import QtQuick.Templates 2.15 as T

T.ScrollView {
    id: control

    property var mask: false
    property real distance: 0
    property real minSize: 36
    property real maskSize: 40
    property real maxHeight: 0
    property bool always: false
    property bool topReached: false
    property bool leftReached: false
    property bool rightReached: false
    property bool bottomReached: false
    property bool componentReady: false

    readonly property real scrollTop: scrollTarget ? scrollTarget.contentY : 0
    readonly property real scrollLeft: scrollTarget ? scrollTarget.contentX : 0
    readonly property var scrollTarget: componentReady && contentItem && contentItem.contentY !== undefined
        ? contentItem
        : null

    signal endReached(string direction)
    signal scrolled(real scrollTop, real scrollLeft)

    function update() {
        if (scrollTarget && typeof scrollTarget.returnToBounds === "function")
            scrollTarget.returnToBounds()
    }

    function setScrollTop(top) {
        if (scrollTarget && isFinite(top))
            scrollTarget.contentY = Math.max(
                0,
                Math.min(scrollTarget.contentHeight - scrollTarget.height, top)
            )
    }

    function setScrollLeft(left) {
        if (scrollTarget && isFinite(left))
            scrollTarget.contentX = Math.max(
                0,
                Math.min(scrollTarget.contentWidth - scrollTarget.width, left)
            )
    }

    function scrollTo(left, top) {
        if (left && typeof left === "object") {
            top = left.top
            left = left.left
        }
        if (isFinite(left))
            setScrollLeft(left)
        if (isFinite(top))
            setScrollTop(top)
    }

    function notifyScroll() {
        if (!scrollTarget)
            return
        scrolled(scrollTop, scrollLeft)
        const top = scrollTop <= distance
        const left = scrollLeft <= distance
        const bottom = scrollTarget.contentHeight > scrollTarget.height
            && scrollTop + scrollTarget.height >= scrollTarget.contentHeight - distance
        const right = scrollTarget.contentWidth > scrollTarget.width
            && scrollLeft + scrollTarget.width >= scrollTarget.contentWidth - distance
        if (top && !topReached)
            endReached("top")
        if (bottom && !bottomReached)
            endReached("bottom")
        if (left && !leftReached)
            endReached("left")
        if (right && !rightReached)
            endReached("right")
        topReached = top
        bottomReached = bottom
        leftReached = left
        rightReached = right
    }

    clip: true
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
        contentWidth + leftPadding + rightPadding)
    implicitHeight: maxHeight > 0 ? Math.min(maxHeight, implicitContentHeight + topPadding + bottomPadding)
        : implicitContentHeight + topPadding + bottomPadding
    ScrollBar.horizontal: ScrollHandle {
        parent: control
        x: control.leftPadding
        y: control.height - height
        width: control.availableWidth
        active: control.ScrollBar.vertical.active
        policy: control.always ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
        minimumSize: Math.min(0.9, control.minSize / Math.max(1, availableWidth))
    }
    ScrollBar.vertical: ScrollHandle {
        parent: control
        y: control.topPadding
        height: control.availableHeight
        active: control.ScrollBar.horizontal.active
        x: control.mirrored ? 0 : control.width - width
        policy: control.always ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
        minimumSize: Math.min(0.9, control.minSize / Math.max(1, availableHeight))
    }
    background: Item {
        z: 2

        Repeater {
            model: ["top", "bottom", "left", "right"]

            Rectangle {
                readonly property bool vertical: modelData === "top" || modelData === "bottom"
                readonly property bool horizontalEdge: modelData === "left" || modelData === "right"

                z: 2
                x: modelData === "right" ? control.width - width : 0
                y: modelData === "bottom" ? control.height - height : 0
                width: vertical ? control.availableWidth : Math.min(control.maskSize, control.availableWidth)
                height: vertical ? Math.min(control.maskSize, control.availableHeight)
                    : control.availableHeight
                visible: (control.mask === true || control.mask === modelData)
                    && (modelData === "top" ? control.scrollTop > 0
                    : modelData === "left" ? control.scrollLeft > 0
                        : modelData === "bottom" ? !control.bottomReached
                        : !control.rightReached)
                gradient: Gradient {
                    orientation: horizontalEdge ? Gradient.Horizontal : Gradient.Vertical

                    GradientStop {
                        position: 0
                        color: modelData === "bottom" || modelData === "right" ? "transparent"
                            : EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
                    }
                    GradientStop {
                        position: 1
                        color: modelData === "bottom" || modelData === "right"
                            ? EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
                            : "transparent"
                    }
                }
            }
        }
        Connections {
            function onContentXChanged() {
                control.notifyScroll()
            }

            function onContentYChanged() {
                control.notifyScroll()
            }

            ignoreUnknownSignals: true
            target: control.scrollTarget
        }
    }

    Component.onCompleted: componentReady = true
}

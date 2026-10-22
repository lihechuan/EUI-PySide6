import EUI 1.0
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Popup {
    id: control

    property var steps: []
    property bool mask: true
    property int currentStep: 0
    property bool showArrow: true
    property bool showClose: true
    property string type: "default"
    property bool scrollIntoView: true
    property string placement: "bottom"
    property bool closeOnPressEscape: true
    property Component headerDelegate: null
    property bool targetAreaClickable: false
    property Component indicatorsDelegate: null
    property Component descriptionDelegate: null
    property var gap: ({ offset: 6, radius: 4 })
    property color maskColor: EPaletteManager.BasePalette.modalOverlay
    property var scrollIntoViewOptions: ({block: "center", inline: "nearest"})

    readonly property Item target: resolveTarget()
    readonly property bool finalStep: currentStep + 1 === stepCount
    readonly property int stepCount: EDataUtils.isArray(steps) ? steps.length : 0
    readonly property string effectiveType: step && step.type ? step.type : type
    readonly property bool effectiveMask: step && step.mask !== undefined ? !!step.mask : mask
    readonly property string effectivePlacement: step && step.placement ? step.placement : placement
    readonly property var nextButtonProps: step && step.nextButtonProps ? step.nextButtonProps : ({})
    readonly property real gapOffset: gap && isFinite(gap.offset) ? Math.max(0, Number(gap.offset)) : 6
    readonly property real gapRadius: gap && isFinite(gap.radius) ? Math.max(0, Number(gap.radius)) : 4
    readonly property var previousButtonProps: step && step.prevButtonProps ? step.prevButtonProps : ({})
    readonly property var step: EDataUtils.isArray(steps) && currentStep >= 0 && currentStep < steps.length
        ? steps[currentStep]
        : null
    readonly property var effectiveScrollOptions: step && step.scrollIntoViewOptions !== undefined
        ? step.scrollIntoViewOptions : scrollIntoViewOptions
    readonly property point targetPosition: {
        const revision = scrollState.positionRevision
        return target && parent && parent.width > 0 && parent.height > 0
            ? target.mapToItem(parent, 0, 0) : Qt.point(width / 2, height / 3)
    }
    readonly property rect highlight: {
        if (!target)
            return Qt.rect(0, height, 0, 0)
        const left = Math.min(width, Math.max(0, targetPosition.x - gapOffset))
        const top = Math.min(height, Math.max(0, targetPosition.y - gapOffset))
        const right = Math.min(width, targetPosition.x + target.width + gapOffset)
        const bottom = Math.min(height, targetPosition.y + target.height + gapOffset)
        return Qt.rect(left, top, Math.max(0, right - left), Math.max(0, bottom - top))
    }
    readonly property point cardPosition: {
        if (!target)
            return Qt.point(
                Math.max(16, (width - stepCard.width) / 2),
                Math.max(16, (height - stepCard.height) / 2)
            )
        const position = effectivePlacement
        let left = highlight.x + (highlight.width - stepCard.width) / 2
        let top = highlight.y + highlight.height + 14
        if (position.indexOf("top") === 0)
            top = highlight.y - stepCard.height - 14
        else if (position.indexOf("left") === 0) {
            left = highlight.x - stepCard.width - 14
            top = highlight.y + (highlight.height - stepCard.height) / 2
        } else if (position.indexOf("right") === 0) {
            left = highlight.x + highlight.width + 14
            top = highlight.y + (highlight.height - stepCard.height) / 2
        }
        if (position.indexOf("start") >= 0) {
            if (position.indexOf("left") === 0 || position.indexOf("right") === 0)
                top = highlight.y
            else
                left = highlight.x
        } else if (position.indexOf("end") >= 0) {
            if (position.indexOf("left") === 0 || position.indexOf("right") === 0)
                top = highlight.y + highlight.height - stepCard.height
            else
                left = highlight.x + highlight.width - stepCard.width
        }
        return Qt.point(Math.max(16, Math.min(width - stepCard.width - 16, left)),
            Math.max(16, Math.min(height - stepCard.height - 16, top)))
    }

    signal finished()
    signal changed(int index)

    function previous() {
        return goTo(currentStep - 1)
    }

    function start() {
        if (!enabled || !EDataUtils.isArray(steps) || steps.length === 0)
            return false

        currentStep = 0
        open()
        return true
    }

    function next() {
        if (!enabled || !EDataUtils.isArray(steps) || steps.length === 0)
            return false

        if (currentStep + 1 < steps.length)
            return goTo(currentStep + 1)

        close()
        finished()
        return true
    }

    function watchTargetPositions() {
        let item = target
        while (item) {
            scrollState.watchers.push(positionWatcher.createObject(control, {watchedItem: item}))
            item = item.parent
        }
        ++scrollState.positionRevision
    }

    function goTo(index) {
        if (!enabled || !EDataUtils.isArray(steps) || !isFinite(index) || Math.floor(index) !== Number(index)
            || index < 0 || index >= steps.length)
            return false

        currentStep = index
        changed(index)
        return true
    }

    function findTarget(item, name) {
        if (!item)
            return null
        if (item.objectName === name)
            return item
        const children = item.children || []
        for (let index = 0; index < children.length; ++index) {
            const result = findTarget(children[index], name)
            if (result)
                return result
        }
        return null
    }

    function clearScrollAnimations() {
        ++scrollState.revision
        scrollState.animations.forEach(function(animation) {
            if (animation) {
                animation.stop()
                animation.destroy()
            }
        })
        scrollState.animations = []
        scrollState.watchers.forEach(function(watcher) { if (watcher)
            watcher.destroy() })
        scrollState.watchers = []
    }

    function resolveTarget() {
        if (!step || !step.target)
            return null
        let value = step.target
        if (typeof value === "function") {
            try { value = value() } catch (error) { return null }
        }
        if (typeof value !== "string")
            return value
        let root = parent
        while (root && root.parent)
            root = root.parent
        return findTarget(root, value.charAt(0) === "#" ? value.slice(1) : value)
    }

    function revealTarget() {
        clearScrollAnimations()
        if (!scrollIntoView || effectiveScrollOptions === false || !target)
            return
        const options = effectiveScrollOptions && typeof effectiveScrollOptions === "object"
            ? effectiveScrollOptions
            : ({block: "start", inline: "nearest"})
        scrollState.options = options
        watchTargetPositions()
        scrollAncestor(target.parent, options, scrollState.revision)
    }

    function scrollOffset(start, extent, viewport, current, origin, contentExtent, alignment) {
        let offset = current
        if (alignment === "start")
            offset = start
        else if (alignment === "end")
            offset = start + extent - viewport
        else if (alignment === "center")
            offset = start + (extent - viewport) / 2
        else if (start < current && start + extent > current + viewport)
            return current
        else if (start < current)
            offset = extent > viewport ? start + extent - viewport : start
        else if (start + extent > current + viewport)
            offset = extent > viewport ? start : start + extent - viewport
        return Math.max(origin, Math.min(origin + Math.max(0, contentExtent - viewport), offset))
    }

    function scrollAncestor(item, options, revision) {
        if (revision !== scrollState.revision || !target)
            return
        while (item && !(item.contentItem && item.contentX !== undefined && item.contentY !== undefined
                && item.contentWidth !== undefined && item.contentHeight !== undefined)) item = item.parent
        if (!item)
            return
        const position = target.mapToItem(item.contentItem, 0, 0)
        const end = target.mapToItem(item.contentItem, target.width, target.height)
        const left = Math.min(position.x, end.x)
        const top = Math.min(position.y, end.y)
        const horizontal = scrollOffset(left, Math.abs(end.x - position.x), item.width, item.contentX,
            item.originX || 0, item.contentWidth, options.inline || "nearest")
        const vertical = scrollOffset(top, Math.abs(end.y - position.y), item.height, item.contentY,
            item.originY || 0, item.contentHeight, options.block || "start")
        if (options.behavior === "smooth"
            && (Math.abs(item.contentX - horizontal) > 0.5 || Math.abs(item.contentY - vertical) > 0.5)) {
            const animation = scrollAnimation.createObject(control, {flickable: item, endX: horizontal,
                endY: vertical, revision: revision, nextParent: item.parent})
            scrollState.animations = scrollState.animations.filter(function(value) {
                return value
            }).concat([animation])
            animation.start()
            return
        }
        item.contentX = horizontal
        item.contentY = vertical
        scrollAncestor(item.parent, options, revision)
    }

    dim: false
    padding: 0
    focus: true
    parent: Overlay.overlay
    modal: !targetAreaClickable
    width: parent ? parent.width : 0
    height: parent ? parent.height : 0
    background: ERectangle {
        color: EPaletteManager.BasePalette.transparent
    }
    closePolicy: closeOnPressEscape ? Popup.CloseOnEscape : Popup.NoAutoClose
    contentItem: Item {
        ERectangle {
            width: parent.width
            color: control.maskColor
            height: control.highlight.y
            visible: control.effectiveMask

            MouseArea {
                anchors.fill: parent
                enabled: control.targetAreaClickable
            }
        }
        ERectangle {
            width: parent.width
            color: control.maskColor
            visible: control.effectiveMask
            height: Math.max(0, parent.height - y)
            y: control.highlight.y + control.highlight.height

            MouseArea {
                anchors.fill: parent
                enabled: control.targetAreaClickable
            }
        }
        ERectangle {
            y: control.highlight.y
            color: control.maskColor
            width: control.highlight.x
            visible: control.effectiveMask
            height: control.highlight.height

            MouseArea {
                anchors.fill: parent
                enabled: control.targetAreaClickable
            }
        }
        ERectangle {
            y: control.highlight.y
            color: control.maskColor
            visible: control.effectiveMask
            height: control.highlight.height
            width: Math.max(0, parent.width - x)
            x: control.highlight.x + control.highlight.width

            MouseArea {
                anchors.fill: parent
                enabled: control.targetAreaClickable
            }
        }
        ERectangle {
            border.width: 3
            x: control.highlight.x
            y: control.highlight.y
            radius: control.gapRadius
            width: control.highlight.width
            height: control.highlight.height
            color: EPaletteManager.BasePalette.transparent
            visible: control.target !== null && control.effectiveMask
            border.color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
        }
        ERectangle {
            width: 12
            height: 12
            rotation: 45
            visible: control.target !== null
                && (control.step && control.step.showArrow !== undefined ? control.step.showArrow
                    : control.showArrow)
            color: control.effectiveType === "primary"
                ? EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                : EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
            x: control.effectivePlacement.indexOf("left") === 0 ? control.cardPosition.x + stepCard.width - 6
                : control.effectivePlacement.indexOf("right") === 0 ? control.cardPosition.x - 6
                : Math.max(control.cardPosition.x + 16, Math.min(control.cardPosition.x + stepCard.width - 28,
                    control.highlight.x + control.highlight.width / 2 - 6))
            y: control.effectivePlacement.indexOf("top") === 0 ? control.cardPosition.y + stepCard.height - 6
                : control.effectivePlacement.indexOf("left") === 0
                    || control.effectivePlacement.indexOf("right") === 0
                    ? Math.max(control.cardPosition.y
                        + 16, Math.min(control.cardPosition.y + stepCard.height - 28,
                        control.highlight.y + control.highlight.height / 2 - 6)) : control.cardPosition.y - 6
        }
        ECard {
            id: stepCard

            x: control.cardPosition.x
            y: control.cardPosition.y
            width: Math.min(360, Math.max(0, parent.width - 32))
            header: control.step ? String(control.step.title || "") : ""
            headerDelegate: control.step && control.step.headerDelegate ? control.step.headerDelegate
                : control.headerDelegate || (control.effectiveType === "primary" ? primaryHeader : null)
            background: ERectangle {
                radius: 6
                border.width: 1
                border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
                color: control.effectiveType === "primary"
                    ? EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                    : EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
            }

            Column {
                spacing: 20
                width: parent.width

                EText {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    visible: !descriptionSlot.active
                    text: control.step ? String(control.step.description || "") : ""
                    color: control.effectiveType === "primary" ? EPaletteManager.BasePalette.white
                        : EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                }
                Loader {
                    id: descriptionSlot

                    property var step: control.step

                    width: parent.width
                    active: sourceComponent !== null
                    sourceComponent: control.step && control.step.descriptionDelegate
                        ? control.step.descriptionDelegate : control.descriptionDelegate
                }
                Row {
                    spacing: 8

                    EText {
                        height: 32
                        visible: !indicatorSlot.active
                        verticalAlignment: Text.AlignVCenter
                        text: (control.currentStep + 1) + ELocale.texts.CountSeparator + control.stepCount
                        color: control.effectiveType === "primary" ? EPaletteManager.BasePalette.white
                            : EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                    }
                    Loader {
                        id: indicatorSlot

                        property int total: control.stepCount
                        property int current: control.currentStep

                        active: sourceComponent !== null
                        sourceComponent: control.indicatorsDelegate
                    }
                    EButton {
                        objectName: "tourPrevious"
                        visible: control.previousButtonProps.visible !== false
                        text: control.previousButtonProps.text || ELocale.texts.Previous
                        enabled: control.currentStep > 0 && control.previousButtonProps.disabled !== true
                        size: control.previousButtonProps.size === undefined ? EStyle.Medium
                            : control.previousButtonProps.size
                        styleType: control.previousButtonProps.styleType === undefined ? EStyle.Default
                            : control.previousButtonProps.styleType

                        onClicked: control.previous()
                    }
                    EButton {
                        objectName: "tourNext"
                        enabled: control.nextButtonProps.disabled !== true
                        visible: control.nextButtonProps.visible !== false
                        size: control.nextButtonProps.size === undefined ? EStyle.Medium
                            : control.nextButtonProps.size
                        text: control.nextButtonProps.text
                            || (control.finalStep ? ELocale.texts.Done : ELocale.texts.Next)
                        styleType: control.nextButtonProps.styleType === undefined ? EStyle.Primary
                            : control.nextButtonProps.styleType

                        onClicked: control.next()
                    }
                    EButton {
                        text: ELocale.texts.Close
                        visible: control.step && control.step.showClose !== undefined ? control.step.showClose
                            : control.showClose

                        onClicked: control.close()
                    }
                }
            }
        }
    }

    onClosed: clearScrollAnimations()
    onOpened: Qt.callLater(revealTarget)
    onCurrentStepChanged: Qt.callLater(revealTarget)

    Component {
        id: primaryHeader

        EText {
            font.bold: true
            wrapMode: Text.WordWrap
            color: EPaletteManager.BasePalette.white
            text: control.step ? String(control.step.title || "") : ""
        }
    }
    QtObject {
        id: scrollState

        property int revision: 0
        property var watchers: []
        property var options: ({})
        property var animations: []
        property int positionRevision: 0
    }
    Component {
        id: scrollAnimation

        ParallelAnimation {
            id: animation

            property real endX: 0
            property real endY: 0
            property Item flickable
            property Item nextParent
            property int revision: 0

            onStopped: {
                if (revision === scrollState.revision) {
                    scrollState.animations = scrollState.animations.filter(function(value) {
                        return value !== animation
                    })
                    control.scrollAncestor(nextParent, scrollState.options, revision)
                    Qt.callLater(destroy)
                }
            }

            NumberAnimation {
                duration: 180
                to: animation.endX
                property: "contentX"
                target: animation.flickable
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                duration: 180
                to: animation.endY
                property: "contentY"
                target: animation.flickable
                easing.type: Easing.InOutQuad
            }
        }
    }
    Component {
        id: positionWatcher

        Connections {
            property var watchedItem

            function onXChanged() {
                ++scrollState.positionRevision
            }

            function onYChanged() {
                ++scrollState.positionRevision
            }

            function onWidthChanged() {
                ++scrollState.positionRevision
            }

            function onHeightChanged() {
                ++scrollState.positionRevision
            }

            function onContentXChanged() {
                ++scrollState.positionRevision
            }

            function onContentYChanged() {
                ++scrollState.positionRevision
            }

            target: watchedItem
            ignoreUnknownSignals: true
        }
    }
}

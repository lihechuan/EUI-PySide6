import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Window 2.15
import QtQuick.Controls

ToolTip {
    id: control

    property real offset: 4
    property int hideAfter: 0
    property real arrowOffset: 16
    property bool enterable: true
    property Item reference: null
    property bool showArrow: true
    property string effect: "dark"
    property bool persistent: true
    property bool rawContent: false
    property string trigger: "hover"
    property bool focusOnTarget: false
    property string alignment: "center"
    property var fallbackPlacements: []
    property int placement: EPlacement.Top
    property int styleType: EStyle.Default
    property alias showAfter: control.delay
    property alias autoClose: control.timeout
    property Component contentComponent: null
    property color textColor: EPaletteManager.BasePalette.transparent
    property var triggerKeys: [Qt.Key_Return, Qt.Key_Enter, Qt.Key_Space]
    property color backgroundColor: effect === "light"
        ? EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
        : EPaletteManager.ThemePalette.fetchInverseThemeColor(ETheme.dark)

    readonly property alias popperRef: control
    readonly property Item contentRef: contentItem
    readonly property bool contentHovered: popupHover.hovered
    readonly property bool referenceHovered: referenceHover.hovered
    readonly property bool referenceEnabled: !reference || reference.enabled

    function hide() {
        close()
    }

    function onClose() {
        hide()
    }

    function onOpen() {
        showForReference()
    }

    function updatePopper() {
        x = coordinatesFor(inside.effectivePlacement).x
        y = coordinatesFor(inside.effectivePlacement).y
        arrow.requestPaint()
    }

    function isFocusInsideContent() {
        let focused = contentItem.Window.window ? contentItem.Window.window.activeFocusItem : null
        while (focused) {
            if (focused === contentItem)
                return true
            focused = focused.parent
        }
        return false
    }

    function showForReference() {
        hideTimer.stop()
        if (!enabled || !inside.hasContent() || reference && (!reference.enabled || !reference.visible))
            return false
        if (focusOnTarget && reference)
            reference.forceActiveFocus()
        open()
        return true
    }

    function choosePlacement() {
        const anchor = reference || parent
        const overlay = Overlay.overlay
        if (!anchor || !overlay || !EDataUtils.isArray(fallbackPlacements) || fallbackPlacements.length === 0)
            return placement
        const origin = anchor.mapToItem(overlay, 0, 0)
        for (const position of [placement].concat(fallbackPlacements)) {
            const point = coordinatesFor(position)
            if (origin.x + point.x >= margins && origin.y + point.y >= margins
                && origin.x + point.x + width <= overlay.width - margins
                && origin.y + point.y + height <= overlay.height - margins)
                return position
        }
        return placement
    }

    function coordinatesFor(position) {
        const anchor = reference || parent
        if (!anchor)
            return Qt.point(0, 0)
        const distance = offset + (showArrow ? 6 : 0)
        const top = position === EPlacement.Top
            || position === EPlacement.TopLeft
            || position === EPlacement.TopRight
        const bottom = position === EPlacement.Bottom
            || position === EPlacement.BottomLeft
            || position === EPlacement.BottomRight
        const left = position === EPlacement.Left
        const right = position === EPlacement.Right
        const leading = position === EPlacement.TopLeft || position === EPlacement.BottomLeft
        const trailing = position === EPlacement.TopRight || position === EPlacement.BottomRight
        const x = left ? -width - distance : right ? anchor.width + distance
            : leading ? 0 : trailing ? anchor.width - width : (anchor.width - width) / 2
        const y = top ? -height - distance : bottom ? anchor.height + distance
            : alignment === "start" ? 0
                : alignment === "end" ? anchor.height - height
                : (anchor.height - height) / 2
        return Qt.point(x, y)
    }

    margins: 8
    padding: 8
    topPadding: 6
    leftPadding: 10
    bottomPadding: 6
    rightPadding: 10
    font.pixelSize: 12
    x: coordinatesFor(inside.effectivePlacement).x
    y: coordinatesFor(inside.effectivePlacement).y
    z: EControlConfig.valueFor(control, "zIndex", 0)
    contentItem: Item {
        implicitHeight: contentLoader.item ? contentLoader.item.implicitHeight : contentText.implicitHeight
        implicitWidth: Math.min(contentLoader.item ? contentLoader.item.implicitWidth
            : contentText.implicitWidth, inside.maximumContentWidth)

        Loader {
            id: contentLoader

            anchors.fill: parent
            sourceComponent: control.contentComponent
            active: control.persistent || control.visible
        }
        EText {
            id: contentText

            font: control.font
            text: control.text
            wrapMode: Text.Wrap
            anchors.fill: parent
            color: inside.textColor
            visible: !control.contentComponent
            textFormat: control.rawContent ? Text.RichText : Text.PlainText
        }
    }
    background: Item {
        HoverHandler {
            id: popupHover

            onHoveredChanged: {
                if (hovered && control.enterable)
                    hideTimer.stop()
                else if (control.trigger === "hover")
                    hideTimer.restart()
            }
        }
        ERectangle {
            id: box

            radius: 4
            border.width: 0
            anchors.fill: parent
            color: control.backgroundColor
        }
        Canvas {
            id: arrow

            visible: control.visible && control.showArrow
            width: inside.verticalPlacement ? inside.arrowWidth : inside.arrowDepth
            height: inside.verticalPlacement ? inside.arrowDepth : inside.arrowWidth
            y: {
                if (inside.bottomPlacement)
                    return -height
                if (inside.topPlacement)
                    return box.height
                return (box.height - height) / 2
            }
            x: {
                if (inside.leftPlacement)
                    return box.width
                if (inside.rightPlacement)
                    return -width
                if (inside.leadingPlacement) {
                    const center = Math.min(box.width / 2, inside.arrowInset)
                    return center - width / 2
                }
                if (inside.trailingPlacement) {
                    const center = Math.max(box.width / 2, box.width - inside.arrowInset)
                    return center - width / 2
                }
                return (box.width - width) / 2
            }

            onWidthChanged: requestPaint()
            onHeightChanged: requestPaint()
            onVisibleChanged: requestPaint()
            onPaint: {
                const ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)

                if (!visible || width <= 0 || height <= 0)
                    return

                ctx.beginPath()
                if (inside.bottomPlacement) {
                    ctx.moveTo(0, height)
                    ctx.lineTo(width / 2, 0)
                    ctx.lineTo(width, height)
                } else if (inside.topPlacement) {
                    ctx.moveTo(0, 0)
                    ctx.lineTo(width / 2, height)
                    ctx.lineTo(width, 0)
                } else if (inside.rightPlacement) {
                    ctx.moveTo(width, 0)
                    ctx.lineTo(0, height / 2)
                    ctx.lineTo(width, height)
                } else if (inside.leftPlacement) {
                    ctx.moveTo(0, 0)
                    ctx.lineTo(width, height / 2)
                    ctx.lineTo(0, height)
                }
                ctx.closePath()
                ctx.fillStyle = control.backgroundColor
                ctx.fill()
            }
        }
    }

    onEnabledChanged: if (!enabled)
        close()
    onPlacementChanged: arrow.requestPaint()
    onBackgroundColorChanged: arrow.requestPaint()
    onReferenceChanged: {
        if (reference)
            parent = reference
    }
    onReferenceEnabledChanged: if (!referenceEnabled)
        close()
    onVisibleChanged: if (visible && !inside.hasContent())
        close()
    onReferenceHoveredChanged: {
        if (trigger !== "hover")
            return
        if (referenceHovered)
            showForReference()
        else
            hideTimer.restart()
    }

    Shortcut {
        sequence: "Enter"
        enabled: control.trigger !== "manual" && control.reference
            && control.reference.activeFocus
            && control.triggerKeys.indexOf(Qt.Key_Enter) >= 0

        onActivated: control.visible ? control.hide() : control.showForReference()
    }
    Shortcut {
        sequence: "Return"
        enabled: control.trigger !== "manual" && control.reference
            && control.reference.activeFocus
            && control.triggerKeys.indexOf(Qt.Key_Return) >= 0

        onActivated: control.visible ? control.hide() : control.showForReference()
    }
    Shortcut {
        sequence: "Space"
        enabled: control.trigger !== "manual" && control.reference
            && control.reference.activeFocus
            && control.triggerKeys.indexOf(Qt.Key_Space) >= 0

        onActivated: control.visible ? control.hide() : control.showForReference()
    }
    Item {
        anchors.fill: parent
        parent: control.reference

        HoverHandler {
            id: referenceHover
        }
        TapHandler {
            acceptedButtons: Qt.RightButton
            enabled: control.trigger === "contextmenu"

            onTapped: control.showForReference()
        }
        TapHandler {
            enabled: control.trigger === "click"
                && control.reference
                && typeof control.reference.clicked !== "function"

            onTapped: control.visible ? control.hide() : control.showForReference()
        }
    }
    Connections {
        function onVisibleChanged() {
            if (control && control.reference && !control.reference.visible)
                control.close()
        }

        function onClicked() {
            if (control && control.trigger === "click")
                control.visible ? control.close() : control.showForReference()
        }

        function onActiveFocusChanged() {
            if (control && control.reference && control.trigger === "focus")
                control.reference.activeFocus ? control.showForReference() : control.close()
        }

        target: control.reference
        ignoreUnknownSignals: true
    }
    Timer {
        id: hideTimer

        interval: Math.max(0, control.hideAfter)

        onTriggered: {
            if (!control.enterable || !popupHover.hovered)
                control.close()
        }
    }
    QtObject {
        id: inside

        readonly property real arrowDepth: 6
        readonly property real arrowWidth: 12
        readonly property real maximumContentWidth: 320
        readonly property bool contentAvailable: hasContent()
        readonly property real arrowInset: Math.max(0, control.arrowOffset)
        readonly property int effectivePlacement: control.choosePlacement()
        readonly property bool verticalPlacement: topPlacement || bottomPlacement
        readonly property bool leftPlacement: effectivePlacement === EPlacement.Left
        readonly property bool rightPlacement: effectivePlacement === EPlacement.Right
        readonly property bool leadingPlacement: effectivePlacement === EPlacement.TopLeft
            || effectivePlacement === EPlacement.BottomLeft
        readonly property bool trailingPlacement: effectivePlacement === EPlacement.TopRight
            || effectivePlacement === EPlacement.BottomRight
        readonly property bool topPlacement: effectivePlacement === EPlacement.TopLeft
            || effectivePlacement === EPlacement.Top
            || effectivePlacement === EPlacement.TopRight
        readonly property bool bottomPlacement: effectivePlacement === EPlacement.BottomLeft
            || effectivePlacement === EPlacement.Bottom
            || effectivePlacement === EPlacement.BottomRight
        readonly property color textColor: EPaletteManager.StatePalette.resolveEffectiveTextColor(
            EPaletteManager.createStateObject(this, EStyle.TextColor)
                .setDark(control.effect === "light" ? ETheme.dark : !ETheme.dark)
                .setColor(control.textColor)
                .setComponentStyle(control.styleType)
        )

        function hasContent() {
            return control.contentComponent !== null || control.text.trim().length > 0
        }

        onContentAvailableChanged: if (!contentAvailable)
            control.close()
    }
}

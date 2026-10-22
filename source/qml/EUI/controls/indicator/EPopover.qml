import EUI 1.0
import EUI.Private 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Popup {
    id: control
    default property alias content: customContent.data

    property real offset: 8
    property string text: ""
    property int autoClose: 0
    property int showAfter: 0
    property string title: ""
    property int hideAfter: 120
    property bool enterable: true
    property Item reference: null
    property bool persistent: true
    property bool showArrow: false
    property string effect: "light"
    property bool rawContent: false
    property string trigger: "click"
    property string alignment: "center"
    property var fallbackPlacements: []
    property Component contentComponent: null
    property int placement: EPlacement.Bottom
    property var triggerKeys: [Qt.Key_Return, Qt.Key_Enter, Qt.Key_Space]

    readonly property alias popperRef: control
    readonly property alias loadedContent: contentLoader.item
    readonly property int effectivePlacement: choosePlacement()
    readonly property bool referenceHovered: referenceHover.hovered
    readonly property real referenceWidth: reference ? reference.width : 0
    readonly property bool referenceEnabled: !reference || reference.enabled
    readonly property real referenceHeight: reference ? reference.height : 0
    readonly property bool referenceVisible: !reference || reference.visible

    function hide() {
        showTimer.stop()
        close()
    }

    function toggle() {
        if (visible)
            close()
        else if (enabled && (!reference || reference.enabled))
            show()
    }

    function show() {
        if (!enabled || !body.hasContent() || !referenceEnabled || !referenceVisible)
            return false
        hoverCloseTimer.stop()
        if (showAfter > 0)
            showTimer.restart()
        else
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
    focus: true
    padding: 16
    implicitWidth: 240
    parent: reference || Overlay.overlay
    x: coordinatesFor(effectivePlacement).x
    y: coordinatesFor(effectivePlacement).y
    z: EControlConfig.valueFor(control, "zIndex", 0)
    implicitHeight: body.implicitHeight + topPadding + bottomPadding
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    background: FieldSurface {
        color: control.effect === "dark" ? EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
            : EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)

        onColorChanged: arrow.requestPaint()

        HoverHandler {
            id: popupHover

            onHoveredChanged: {
                if (!control.enterable)
                    return
                if (hovered)
                    hoverCloseTimer.stop()
                else if (control.trigger === "hover")
                    hoverCloseTimer.restart()
            }
        }
    }
    contentItem: Column {
        id: body

        readonly property bool contentAvailable: hasContent()

        function hasContent() {
            return control.contentComponent !== null
                || control.text.trim().length > 0 || control.title.trim().length > 0
                || customContent.children.length > 1
        }

        spacing: 12

        onContentAvailableChanged: if (!contentAvailable)
            control.hide()

        EText {
            font.bold: true
            font.pixelSize: 16
            text: control.title
            width: parent.width
            wrapMode: Text.WordWrap
            visible: text.length > 0
            color: control.effect === "dark" ? EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
                : EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
        }
        EText {
            text: control.text
            width: parent.width
            wrapMode: Text.WordWrap
            visible: text.length > 0
            textFormat: control.rawContent ? Text.RichText : Text.PlainText
            color: control.effect === "dark" ? EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
                : EPaletteManager.ThemePalette.textRegular(ETheme.dark)
        }
        Item {
            id: customContent

            width: parent.width
            visible: children.length > 0
            implicitHeight: childrenRect.height

            Loader {
                id: contentLoader

                width: parent.width
                sourceComponent: control.contentComponent
                active: control.persistent || control.visible
            }
        }
    }

    onOpened: autoCloseTimer.restart()
    onEffectChanged: arrow.requestPaint()
    onEnabledChanged: if (!enabled)
        close()
    onClosed: {
        autoCloseTimer.stop()
        showTimer.stop()
    }
    onEffectivePlacementChanged: arrow.requestPaint()
    onReferenceEnabledChanged: if (!referenceEnabled)
        close()
    onReferenceVisibleChanged: if (!referenceVisible)
        close()
    onVisibleChanged: if (visible && !body.hasContent())
        hide()
    onReferenceHoveredChanged: {
        if (trigger !== "hover")
            return
        if (referenceHovered)
            show()
        else {
            showTimer.stop()
            hoverCloseTimer.restart()
        }
    }

    Timer {
        id: showTimer

        interval: Math.max(0, control.showAfter)

        onTriggered: {
            if (control.enabled && body.hasContent() && control.referenceEnabled && control.referenceVisible)
                control.open()
        }
    }
    Timer {
        id: autoCloseTimer

        interval: Math.max(0, control.autoClose)

        onTriggered: {
            if (control.autoClose > 0)
                control.close()
        }
    }
    Canvas {
        id: arrow

        parent: control.background
        visible: control.showArrow
        width: control.effectivePlacement === EPlacement.Left
            || control.effectivePlacement === EPlacement.Right
            ? 6
            : 12
        height: control.effectivePlacement === EPlacement.Left
            || control.effectivePlacement === EPlacement.Right
            ? 12
            : 6
        y: control.effectivePlacement === EPlacement.Left || control.effectivePlacement === EPlacement.Right
            ? (parent.height - height) / 2
            : control.effectivePlacement === EPlacement.Top
                || control.effectivePlacement === EPlacement.TopLeft
                || control.effectivePlacement === EPlacement.TopRight
            ? parent.height : -height
        x: control.effectivePlacement === EPlacement.Left ? parent.width
            : control.effectivePlacement === EPlacement.Right ? -width
            : control.effectivePlacement === EPlacement.TopLeft
                || control.effectivePlacement === EPlacement.BottomLeft
                ? 16
            : control.effectivePlacement === EPlacement.TopRight
                || control.effectivePlacement === EPlacement.BottomRight
                ? parent.width - width - 16
            : (parent.width - width) / 2

        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        onVisibleChanged: requestPaint()
        onPaint: {
            const context = getContext("2d")
            context.reset()
            context.beginPath()
            if (control.effectivePlacement === EPlacement.Left) {
                context.moveTo(0, 0)
                context.lineTo(width, height / 2)
                context.lineTo(0, height)
            } else if (control.effectivePlacement === EPlacement.Right) {
                context.moveTo(width, 0)
                context.lineTo(0, height / 2)
                context.lineTo(width, height)
            } else {
                const above = control.effectivePlacement === EPlacement.Top
                    || control.effectivePlacement === EPlacement.TopLeft
                    || control.effectivePlacement === EPlacement.TopRight
                context.moveTo(0, above ? 0 : height)
                context.lineTo(width / 2, above ? height : 0)
                context.lineTo(width, above ? 0 : height)
            }
            context.closePath()
            context.fillStyle = control.background.color
            context.fill()
        }
    }
    Shortcut {
        sequence: "Enter"
        enabled: control.trigger !== "manual" && control.reference
            && control.reference.activeFocus
            && control.triggerKeys.indexOf(Qt.Key_Enter) >= 0

        onActivated: control.toggle()
    }
    Shortcut {
        sequence: "Return"
        enabled: control.trigger !== "manual" && control.reference
            && control.reference.activeFocus
            && control.triggerKeys.indexOf(Qt.Key_Return) >= 0

        onActivated: control.toggle()
    }
    Shortcut {
        sequence: "Space"
        enabled: control.trigger !== "manual" && control.reference
            && control.reference.activeFocus
            && control.triggerKeys.indexOf(Qt.Key_Space) >= 0

        onActivated: control.toggle()
    }
    MouseArea {
        anchors.fill: parent
        parent: control.reference
        acceptedButtons: Qt.RightButton
        enabled: control.trigger === "contextmenu" && control.reference !== null

        onClicked: control.show()
    }
    Item {
        anchors.fill: parent
        parent: control.reference

        HoverHandler {
            id: referenceHover
        }
        TapHandler {
            enabled: control.trigger === "click"
                && control.reference
                && typeof control.reference.clicked !== "function"

            onTapped: control.toggle()
        }
    }
    Connections {
        function onClicked() {
            if (control.trigger === "click")
                control.toggle()
        }

        function onActiveFocusChanged() {
            if (control.trigger === "focus") {
                if (control.reference.activeFocus)
                    control.show()
                else
                    control.close()
            }
        }

        target: control.reference
        ignoreUnknownSignals: true
    }
    Timer {
        id: hoverCloseTimer

        interval: Math.max(0, control.hideAfter)

        onTriggered: {
            if ((!control.enterable || !popupHover.hovered)
                && (!control.reference || !control.referenceHovered))
                control.close()
        }
    }
}

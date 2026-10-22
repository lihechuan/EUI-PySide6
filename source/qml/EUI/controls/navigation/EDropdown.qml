import EUI 1.0
import "private" as Private
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

EButton {
    id: control

    property var model: []
    property real maxHeight: 0
    property int menuWidth: 160
    property int hideTimeout: 150
    property Item reference: null
    property int showTimeout: 150
    property bool persistent: true
    property bool showArrow: false
    property string effect: "light"
    property bool hideOnClick: true
    property bool splitButton: false
    property string trigger: "click"
    property int placement: EPlacement.BottomLeft
    property var triggerKeys: [Qt.Key_Return, Qt.Key_Enter, Qt.Key_Space, Qt.Key_Down]

    readonly property alias menu: dropdownMenu
    readonly property var items: EDataUtils.isArray(model) ? model : []
    readonly property bool referenceAvailable: !reference || reference.enabled && reference.visible

    signal command(var value, var item)
    signal visibleChangedByUser(bool visible)

    function handleOpen() {
        open()
    }

    function handleClose() {
        close()
    }

    function close() {
        dropdownMenu.close()
    }

    function open() {
        if (enabled && referenceAvailable && items.length > 0)
            dropdownMenu.open()
    }

    function openAt(x, y, item) {
        if (!enabled || !isFinite(x) || !isFinite(y))
            return false
        if (item)
            reference = item
        menuState.position = Qt.point(x, y)
        menuState.positioned = true
        open()
        return dropdownMenu.visible
    }

    iconSize: 12
    hoverEnabled: true
    iconSource: EIcons.CHEVRON_DOWN
    rightPadding: splitButton ? 36 : 12

    onReferenceChanged: close()
    onEnabledChanged: {
        if (!enabled)
            close()
    }
    onReferenceAvailableChanged: if (!referenceAvailable)
        close()
    Keys.onDownPressed: if (triggerKeys.indexOf(Qt.Key_Down) >= 0)
        open()
    Keys.onEnterPressed: if (triggerKeys.indexOf(Qt.Key_Enter) >= 0)
        open()
    Keys.onSpacePressed: if (triggerKeys.indexOf(Qt.Key_Space) >= 0)
        open()
    Keys.onReturnPressed: if (triggerKeys.indexOf(Qt.Key_Return) >= 0)
        open()
    onClicked: {
        if (!splitButton && trigger === "click")
            dropdownMenu.visible ? close() : open()
    }
    onHoveredChanged: {
        if (trigger !== "hover")
            return
        if (hovered) {
            hideTimer.stop()
            showTimer.restart()
        } else {
            showTimer.stop()
            hideTimer.restart()
        }
    }

    Instantiator {
        model: [{key: Qt.Key_Enter, sequence: "Enter"}, {key: Qt.Key_Return, sequence: "Return"},
            {key: Qt.Key_Space, sequence: "Space"}, {key: Qt.Key_Down, sequence: "Down"}]
        delegate: Shortcut {
            sequence: modelData.sequence
            enabled: control.enabled && control.reference && control.reference.activeFocus
                && control.triggerKeys.indexOf(modelData.key) >= 0

            onActivated: control.open()
        }
    }
    Connections {
        function onClicked() {
            if (control.trigger === "click")
                dropdownMenu.visible ? control.close() : control.open()
        }

        target: control.reference
        ignoreUnknownSignals: true
    }
    Item {
        anchors.fill: parent
        parent: control.reference

        HoverHandler {
            id: referenceHover

            onHoveredChanged: {
                if (control.trigger !== "hover")
                    return
                if (hovered) {
                    hideTimer.stop()
                    showTimer.restart()
                } else {
                    hideTimer.restart()
                }
            }
        }
        TapHandler {
            enabled: control.trigger === "click"
                && control.reference
                && typeof control.reference.clicked !== "function"

            onTapped: dropdownMenu.visible ? control.close() : control.open()
        }
        TapHandler {
            acceptedButtons: Qt.RightButton
            enabled: control.trigger === "contextmenu"

            onTapped: control.openAt(point.position.x, point.position.y, control.reference || control)
        }
    }
    ETextButton {
        width: 28
        iconSize: 12
        height: parent.height
        anchors.right: parent.right
        visible: control.splitButton
        iconSource: EIcons.CHEVRON_DOWN

        onClicked: dropdownMenu.visible ? control.close() : control.open()
    }
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        enabled: control.trigger === "contextmenu"

        onClicked: function(mouse) { control.openAt(mouse.x, mouse.y, control) }
    }
    Timer {
        id: showTimer

        interval: Math.max(0, control.showTimeout)

        onTriggered: control.open()
    }
    Timer {
        id: hideTimer

        interval: Math.max(0, control.hideTimeout)

        onTriggered: {
            if (!control.hovered && !referenceHover.hovered && !menuHover.hovered)
                control.close()
        }
    }
    QtObject {
        id: menuState

        property bool loaded: false
        property bool positioned: false
        property point position: Qt.point(0, 0)
    }
    Menu {
        id: dropdownMenu

        padding: 6
        parent: control.reference || control
        width: Math.max(100, control.menuWidth)
        z: EControlConfig.valueFor(control, "zIndex", 0)
        height: control.maxHeight > 0 ? Math.min(implicitHeight, control.maxHeight) : implicitHeight
        y: menuState.positioned ? menuState.position.y : control.placement === EPlacement.Top
            || control.placement === EPlacement.TopLeft
            || control.placement === EPlacement.TopRight
            ? -height - 6 : (parent ? parent.height : 0) + 6
        x: menuState.positioned ? menuState.position.x
            : control.placement === EPlacement.TopRight || control.placement === EPlacement.BottomRight
            ? (parent ? parent.width : 0) - width
                : control.placement === EPlacement.Top || control.placement === EPlacement.Bottom
            ? ((parent ? parent.width : 0) - width) / 2 : 0
        background: ERectangle {
            radius: 4
            border.width: 1
            border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
            color: control.effect === "dark" ? EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
                : EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)

            onColorChanged: arrow.requestPaint()

            Canvas {
                id: arrow

                height: 6
                width: 12
                visible: control.showArrow
                x: (parent.width - width) / 2
                y: control.placement === EPlacement.Top
                    || control.placement === EPlacement.TopLeft
                    || control.placement === EPlacement.TopRight
                    ? parent.height : -height

                onYChanged: requestPaint()
                onVisibleChanged: requestPaint()
                onPaint: {
                    const context = getContext("2d")
                    context.reset()
                    context.beginPath()
                    const above = y > 0
                    context.moveTo(0, above ? 0 : height)
                    context.lineTo(width / 2, above ? height : 0)
                    context.lineTo(width, above ? 0 : height)
                    context.closePath()
                    context.fillStyle = dropdownMenu.background.color
                    context.fill()
                }
            }
            HoverHandler {
                id: menuHover

                onHoveredChanged: {
                    if (hovered)
                        hideTimer.stop()
                    else if (control.trigger === "hover")
                        hideTimer.restart()
                }
            }
        }

        onClosed: {
            menuState.positioned = false
            if (!control.persistent)
                menuState.loaded = false
        }
        onVisibleChanged: {
            if (visible)
                menuState.loaded = true
            control.visibleChangedByUser(visible)
        }

        Instantiator {
            model: control.persistent || menuState.loaded ? control.items : []
            delegate: Private.MenuAction {
                id: entry

                readonly property var item: modelData || ({})

                checked: !!item.checked
                enabled: !item.disabled
                checkable: !!item.checkable
                icon.source: item.icon || ""
                iconSource: item.iconSource || 0
                topPadding: item.divided ? 8 : 0
                implicitHeight: item.divided ? 42 : 34
                titleComponent: item.titleComponent || null
                text: typeof item === "string" ? item : String(item.text || "")

                onTriggered: {
                    control.command(item.command === undefined ? index : item.command, modelData)
                    if (!control.hideOnClick)
                        Qt.callLater(dropdownMenu.open)
                }

                ERectangle {
                    height: 1
                    anchors.top: parent.top
                    width: parent.width - 12
                    visible: !!entry.item.divided
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
                }
            }

            onObjectRemoved: function(index, object) { dropdownMenu.removeItem(object) }
            onObjectAdded: function(index, object) { dropdownMenu.insertItem(index, object) }
        }
    }
}

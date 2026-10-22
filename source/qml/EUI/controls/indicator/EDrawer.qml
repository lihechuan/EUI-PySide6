import EUI 1.0
import EUI.Private 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Window 2.15
import QtQuick.Controls

Drawer {
    id: control
    default property alias content: body.data

    property int openDelay: 0
    property string title: ""
    property int closeDelay: 0
    property var drawerSize: 320
    property bool autofocus: true
    property real minimumSize: 80
    property bool showClose: true
    property var beforeClose: null
    property bool resizable: false
    property bool showHeader: true
    property bool closeOnEscape: true
    property bool destroyOnClose: false
    property int closeIcon: EIcons.XMARK
    property bool modalPenetrable: false
    property bool closeOnClickOutside: true
    property Component footerComponent: null
    property Component contentComponent: null

    readonly property alias loadedContent: contentLoader.item
    readonly property bool horizontal: edge === Qt.LeftEdge || edge === Qt.RightEdge
    readonly property real resolvedSize: {
        const text = String(drawerSize).trim()
        const percentage = /%$/.test(text)
        const value = Number(percentage ? text.slice(0, -1) : text)
        const extent = parent ? horizontal ? parent.width : parent.height : 0
        return isFinite(value) ? Math.max(0, percentage ? value * extent / 100 : value) : 0
    }

    signal closeRejected()
    signal openAutoFocused()
    signal closeAutoFocused()
    signal resized(real size)
    signal resizeEnded(real size)
    signal resizeStarted(real size)

    function close() {
        return requestClose()
    }

    function handleClose() {
        return requestClose()
    }

    function open() {
        closeTimer.stop()
        if (!enabled)
            return false
        if (openDelay > 0)
            openTimer.restart()
        else
            visible = true
        return true
    }

    function requestClose() {
        openTimer.stop()
        if (!visible || lifecycle.pending)
            return false
        const generation = lifecycle.generation
        let completed = false
        lifecycle.pending = true
        const done = function(cancel) {
            if (completed || generation !== lifecycle.generation)
                return
            completed = true
            lifecycle.pending = false
            if (cancel === true)
                return
            if (control.closeDelay > 0)
                closeTimer.restart()
            else
                control.visible = false
        }
        if (typeof beforeClose !== "function") {
            done()
            return true
        }
        let result
        try {
            result = beforeClose(done)
        } catch (error) {
            completed = true
            lifecycle.pending = false
            closeRejected()
            return false
        }
        if (result === false) {
            completed = true
            lifecycle.pending = false
            closeRejected()
            return false
        }
        if (result && typeof result.then === "function") {
            result.then(function(allowed) {
                if (allowed === false && generation === lifecycle.generation) {
                    completed = true
                    lifecycle.pending = false
                    control.closeRejected()
                } else {
                    done()
                }
            }, function() {
                if (generation !== lifecycle.generation)
                    return
                completed = true
                lifecycle.pending = false
                control.closeRejected()
            })
        } else if (result === true) {
            done()
        }
        return true
    }

    dim: true
    modal: true
    padding: 24
    focus: autofocus
    edge: Qt.RightEdge
    topPadding: padding
    leftPadding: padding
    rightPadding: padding
    bottomPadding: padding
    parent: Overlay.overlay
    background: FieldSurface {}
    z: EControlConfig.valueFor(control, "zIndex", 0)
    width: parent ? (horizontal ? Math.max(0, Math.min(resolvedSize, parent.width)) : parent.width)
        : resolvedSize
    height: parent ? (horizontal ? parent.height : Math.max(0, Math.min(resolvedSize, parent.height)))
        : resolvedSize
    closePolicy: typeof beforeClose === "function" || closeDelay > 0 ? Popup.NoAutoClose
        : ((closeOnEscape ? Popup.CloseOnEscape : Popup.NoAutoClose)
        | (closeOnClickOutside ? Popup.CloseOnPressOutside : Popup.NoAutoClose))
    Overlay.modal: ERectangle {
        color: EPaletteManager.BasePalette.modalOverlay

        MouseArea {
            anchors.fill: parent
            enabled: typeof control.beforeClose === "function" || control.closeDelay > 0

            onPressed: {
                if (control.closeOnClickOutside)
                    control.requestClose()
            }
        }
    }
    Overlay.modeless: ERectangle {
        color: EPaletteManager.BasePalette.modelessOverlay

        MouseArea {
            anchors.fill: parent
            enabled: !control.modalPenetrable
                && (typeof control.beforeClose === "function" || control.closeDelay > 0)

            onPressed: {
                if (control.closeOnClickOutside)
                    control.requestClose()
            }
        }
    }
    contentItem: Column {
        spacing: 24

        Keys.onEscapePressed: {
            if (control.closeOnEscape)
                control.requestClose()
        }

        Item {
            width: parent.width
            visible: control.showHeader
            height: visible && (control.title.length > 0 || control.showClose) ? 32 : 0

            EText {
                font.bold: true
                font.pixelSize: 18
                text: control.title
                elide: Text.ElideRight
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                color: EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
                anchors.right: closeButton.visible ? closeButton.left : parent.right
            }
            ETextButton {
                id: closeButton

                width: 32
                height: 32
                circle: true
                iconSize: 16
                visible: control.showClose
                anchors.right: parent.right
                iconSource: control.closeIcon
                accessibleName: EControlConfig.textFor(control, "CloseDrawer", ELocale.texts)

                onClicked: control.close()
            }
        }
        Item {
            id: body

            width: parent.width
            height: Math.max(0, control.availableHeight - y - footerArea.height
                - (footerArea.height > 0 ? parent.spacing : 0))

            Loader {
                id: contentLoader

                anchors.fill: parent
                active: lifecycle.loaded
                sourceComponent: control.contentComponent
            }
        }
        Item {
            id: footerArea

            width: parent.width
            height: footerLoader.item ? footerLoader.height : 0

            Loader {
                id: footerLoader

                width: parent.width
                sourceComponent: control.footerComponent
            }
        }
    }

    MouseArea {
        property real initialSize: 0
        property point pressPosition

        z: 1
        enabled: control.resizable
        objectName: "drawerResizeHandle"
        width: control.horizontal ? 6 : control.width
        height: control.horizontal ? control.height : 6
        x: control.edge === Qt.LeftEdge ? control.width - width : 0
        y: control.edge === Qt.TopEdge ? control.height - height : 0
        parent: control.contentItem ? control.contentItem.parent : null
        cursorShape: control.horizontal ? Qt.SizeHorCursor : Qt.SizeVerCursor

        onCanceled: control.resizeEnded(control.horizontal ? control.width : control.height)
        onReleased: control.resizeEnded(control.horizontal ? control.width : control.height)
        onPressed: function(mouse) {
            pressPosition = mapToItem(control.parent, mouse.x, mouse.y)
            initialSize = control.horizontal ? control.width : control.height
            control.resizeStarted(initialSize)
        }
        onPositionChanged: function(mouse) {
            if (!pressed)
                return
            const position = mapToItem(control.parent, mouse.x, mouse.y)
            const delta = control.horizontal ? position.x - pressPosition.x : position.y - pressPosition.y
            const sign = control.edge === Qt.LeftEdge || control.edge === Qt.TopEdge ? 1 : -1
            const maximum = control.horizontal ? control.parent.width : control.parent.height
            control.drawerSize = Math.max(Math.min(control.minimumSize, maximum), Math.min(maximum, initialSize
                + sign * delta))
            control.resized(control.drawerSize)
        }
    }
    Shortcut {
        sequence: "Escape"
        enabled: control.opened
            && control.closeOnEscape
            && (typeof control.beforeClose === "function" || control.closeDelay > 0)

        onActivated: control.requestClose()
    }
    Connections {
        function onOpened() {
            if (control.autofocus)
                control.forceActiveFocus()
            control.openAutoFocused()
        }

        function onAboutToShow() {
            ++lifecycle.generation
            lifecycle.loaded = true
            lifecycle.previousFocus = control.parent && control.parent.Window.window
                ? control.parent.Window.window.activeFocusItem
                : null
        }

        function onClosed() {
            ++lifecycle.generation
            lifecycle.pending = false
            if (lifecycle.previousFocus && lifecycle.previousFocus.enabled && lifecycle.previousFocus.visible)
                lifecycle.previousFocus.forceActiveFocus()
            control.closeAutoFocused()
            if (control.destroyOnClose)
                lifecycle.loaded = false
        }

        target: control
    }
    QtObject {
        id: lifecycle

        property int generation: 0
        property bool loaded: false
        property bool pending: false
        property Item previousFocus: null
    }
    Timer {
        id: openTimer

        interval: Math.max(0, control.openDelay)

        onTriggered: control.visible = true
    }
    Timer {
        id: closeTimer

        interval: Math.max(0, control.closeDelay)

        onTriggered: control.visible = false
    }
}

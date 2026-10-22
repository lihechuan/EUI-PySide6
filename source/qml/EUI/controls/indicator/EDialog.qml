import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Window 2.15
import QtQuick.Controls

Dialog {
    id: control
    default property alias content: dialogContent.data

    property string text
    property real top: 0
    property int openDelay: 0
    property int closeDelay: 0
    property bool center: false
    property bool autofocus: true
    property real dialogRadius: 8
    property bool showClose: true
    property var beforeClose: null
    property int exitDuration: 180
    property bool showFooter: true
    property bool showHeader: true
    property real windowMargin: 16
    property int enterDuration: 220
    property bool fullscreen: false
    property bool closeOnEscape: true
    property bool destroyOnClose: false
    property int closeIcon: EIcons.XMARK
    property bool modalPenetrable: false
    property bool showCancelButton: true
    property bool showConfirmButton: true
    property bool closeOnClickOutside: true
    property Component contentComponent: null
    property int confirmStyleType: EStyle.Primary
    property color modalOverlayColor: EPaletteManager.BasePalette.modalOverlay
    property color textColor: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
    property color modelessOverlayColor: EPaletteManager.BasePalette.modelessOverlay
    property color titleColor: EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
    property color borderColor: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
    property string cancelText: EControlConfig.textFor(control, "Cancel2", ELocale.texts)
    property bool overflow: EControlConfig.optionFor(control, "dialog", "overflow", false)
    property string confirmText: EControlConfig.textFor(control, "Confirm2", ELocale.texts)
    property bool draggable: EControlConfig.optionFor(control, "dialog", "draggable", false)
    property color backgroundColor: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
    property bool alignCenter: EControlConfig.optionFor(control, "dialog", "alignCenter", true)

    readonly property alias loadedContent: contentLoader.item
    readonly property real maximumDialogWidth: Overlay.overlay && Overlay.overlay.width > 0
        ? Overlay.overlay.width - windowMargin * 2 : implicitWidth

    signal closeRejected()
    signal openAutoFocused()
    signal closeAutoFocused()

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

    function resetPosition() {
        x = Overlay.overlay ? Math.round((Overlay.overlay.width - width) / 2) : 0
        y = alignCenter && Overlay.overlay ? Math.round((Overlay.overlay.height - height) / 2) : top
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
    spacing: 0
    modal: true
    padding: 24
    focus: autofocus
    implicitWidth: 420
    parent: Overlay.overlay
    z: EControlConfig.valueFor(control, "zIndex", 0)
    x: Overlay.overlay ? Math.round((Overlay.overlay.width - width) / 2) : 0
    height: fullscreen && Overlay.overlay ? Overlay.overlay.height : implicitHeight
    y: alignCenter && Overlay.overlay ? Math.round((Overlay.overlay.height - height) / 2) : top
    width: fullscreen && Overlay.overlay ? Overlay.overlay.width
        : Math.max(0, Math.min(implicitWidth, maximumDialogWidth))
    background: ERectangle {
        border.width: 1
        color: control.backgroundColor
        border.color: control.borderColor
        radius: Math.max(0, control.dialogRadius)
    }
    closePolicy: typeof beforeClose === "function" || closeDelay > 0 ? Popup.NoAutoClose
        : ((closeOnEscape ? Popup.CloseOnEscape : Popup.NoAutoClose)
        | (closeOnClickOutside ? Popup.CloseOnPressOutside : Popup.NoAutoClose))
    exit: Transition {
        NumberAnimation {
            to: 0
            from: 1
            property: "opacity"
            easing.type: Easing.InCubic
            duration: Math.max(0, control.exitDuration)
        }
        NumberAnimation {
            from: 1
            to: 0.96
            property: "scale"
            easing.type: Easing.InCubic
            duration: Math.max(0, control.exitDuration)
        }
    }
    enter: Transition {
        NumberAnimation {
            to: 1
            from: 0
            property: "opacity"
            easing.type: Easing.OutCubic
            duration: Math.max(0, control.enterDuration)
        }
        NumberAnimation {
            to: 1
            from: 0.94
            property: "scale"
            easing.type: Easing.OutBack
            duration: Math.max(0, control.enterDuration)
        }
    }
    Overlay.modal: ERectangle {
        radius: 0
        color: control.modalOverlayColor

        MouseArea {
            anchors.fill: parent
            enabled: typeof control.beforeClose === "function" || control.closeDelay > 0

            onPressed: {
                if (control.closeOnClickOutside)
                    control.requestClose()
            }
        }
        Behavior on opacity {
            NumberAnimation {
                easing.type: Easing.OutCubic
                duration: Math.max(0, control.enterDuration)
            }
        }
    }
    Overlay.modeless: ERectangle {
        radius: 0
        color: control.modelessOverlayColor

        MouseArea {
            anchors.fill: parent
            enabled: !control.modalPenetrable
                && (typeof control.beforeClose === "function" || control.closeDelay > 0)

            onPressed: {
                if (control.closeOnClickOutside)
                    control.requestClose()
            }
        }
        Behavior on opacity {
            NumberAnimation {
                easing.type: Easing.OutCubic
                duration: Math.max(0, control.enterDuration)
            }
        }
    }
    contentItem: Column {
        spacing: 16

        Keys.onEscapePressed: {
            if (control.closeOnEscape)
                control.requestClose()
        }

        EText {
            id: bodyText

            text: control.text
            width: parent.width
            wrapMode: Text.Wrap
            color: control.textColor
            visible: text.length > 0
            verticalAlignment: Text.AlignVCenter
        }
        Item {
            id: dialogContent

            width: parent.width
            visible: children.length > 0
            implicitHeight: childrenRect.height

            Loader {
                id: contentLoader

                width: parent.width
                active: lifecycle.loaded
                sourceComponent: control.contentComponent
            }
        }
    }
    footer: Item {
        implicitHeight: visible ? 64 : 0
        visible: control.showFooter
            && (control.showCancelButton || control.showConfirmButton)

        Row {
            spacing: 12
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: control.center ? undefined : parent.right
            anchors.horizontalCenter: control.center ? parent.horizontalCenter : undefined

            EButton {
                height: 32
                text: control.cancelText
                objectName: "cancelButton"
                visible: control.showCancelButton
                width: Math.max(80, implicitWidth)

                onClicked: control.reject()
            }
            EButton {
                height: 32
                text: control.confirmText
                objectName: "confirmButton"
                visible: control.showConfirmButton
                width: Math.max(80, implicitWidth)
                styleType: control.confirmStyleType

                onClicked: control.accept()
            }
        }
    }
    header: Item {
        implicitHeight: visible ? 52 : 0
        visible: control.showHeader && (control.title.length > 0 || control.showClose)

        EText {
            font.bold: true
            font.pixelSize: 16
            text: control.title
            anchors.leftMargin: 24
            elide: Text.ElideRight
            anchors.left: parent.left
            color: control.titleColor
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: closeButton.visible ? 8 : 24
            anchors.right: closeButton.visible ? closeButton.left : parent.right
            horizontalAlignment: control.center ? Text.AlignHCenter : Text.AlignLeft
        }
        ETextButton {
            id: closeButton

            width: 30
            height: 30
            circle: true
            iconSize: 14
            anchors.rightMargin: 12
            objectName: "closeButton"
            visible: control.showClose
            anchors.right: parent.right
            iconSource: control.closeIcon
            anchors.verticalCenter: parent.verticalCenter

            onClicked: control.requestClose()
        }
        MouseArea {
            property real startX: 0
            property real startY: 0
            property point pressPosition

            z: -1
            anchors.fill: parent
            enabled: control.draggable && !control.fullscreen

            onPressed: {
                pressPosition = mapToItem(control.Overlay.overlay, mouse.x, mouse.y)
                startX = control.x
                startY = control.y
            }
            onPositionChanged: {
                if (!pressed)
                    return
                const position = mapToItem(control.Overlay.overlay, mouse.x, mouse.y)
                const nextX = startX + position.x - pressPosition.x
                const nextY = startY + position.y - pressPosition.y
                control.x = control.overflow ? nextX
                    : Math.max(0, Math.min(control.Overlay.overlay.width - control.width, nextX))
                control.y = control.overflow ? nextY
                    : Math.max(0, Math.min(control.Overlay.overlay.height - control.height, nextY))
            }
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

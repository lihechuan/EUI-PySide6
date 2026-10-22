import EUI 1.0
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Item {
    id: notification

    property var entry
    property Item manager
    property real targetX: x
    property real targetY: y
    property real remaining: 1
    property bool closing: false
    property bool hovered: false
    property real edgeOffset: entry.offset
    property bool progress: entry.progress
    property bool richText: entry.richText
    property int closeIcon: entry.closeIcon
    property string notificationKey: entry.key
    property int messageDuration: entry.duration
    property bool messageShowIcon: entry.showIcon
    property int messagePlacement: entry.placement
    property int messageStyleType: entry.styleType
    property string notificationTitle: entry.title
    property bool pauseOnHover: entry.pauseOnHover
    property bool messageShowClose: entry.showClose
    property color messageIconColor: entry.iconColor
    property int messageIconSource: entry.iconSource
    property color messageTextColor: entry.textColor
    property color messageTitleColor: entry.titleColor
    property string notificationMessage: entry.message
    property color messageBorderColor: entry.borderColor
    property bool messageCloseOnClick: entry.closeOnClick
    property color messageBackgroundColor: entry.backgroundColor
    property Component contentComponent: manager.contentFor(notification.notificationKey)

    readonly property color resolvedTextColor: messageTextColor.a > 0
        ? messageTextColor : EPaletteManager.ThemePalette.textRegular(ETheme.dark)
    readonly property color resolvedTitleColor: messageTitleColor.a > 0
        ? messageTitleColor : EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
    readonly property color resolvedBorderColor: messageBorderColor.a > 0
        ? messageBorderColor : EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
    readonly property color resolvedIconColor: messageIconColor.a > 0
        ? messageIconColor : EPaletteManager.ThemePalette.fetchColorForStyle(messageStyleType)
    readonly property bool topPlacement: messagePlacement === EPlacement.TopLeft
        || messagePlacement === EPlacement.Top || messagePlacement === EPlacement.TopRight
    readonly property bool leftPlacement: messagePlacement === EPlacement.TopLeft
        || messagePlacement === EPlacement.Left || messagePlacement === EPlacement.BottomLeft
    readonly property color resolvedBackgroundColor: messageBackgroundColor.a > 0
        ? messageBackgroundColor : EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)

    function relayout() {
        layoutAnimation.restart()
    }

    function close() {
        if (closing)
            return

        closing = true
        closeTimer.stop()
        countdown.stop()
        enterAnimation.stop()
        layoutAnimation.stop()
        exitAnimation.restart()
    }

    function calculateTargetPosition() {
        const position = ELayout.calculatePosition(messagePlacement, notification)
        targetX = position.x
        targetY = position.y
    }

    function open() {
        calculateTargetPosition()
        const overlayWidth = Overlay.overlay && Overlay.overlay.width > 0
            ? Overlay.overlay.width : targetX + width
        x = leftPlacement ? -width : overlayWidth
        y = targetY + (topPlacement ? edgeOffset - 10 : 10 - edgeOffset)
        opacity = 1
        enterAnimation.restart()
        manager.opened(notificationKey)
    }

    opacity: 0
    visible: true
    z: entry.zIndex
    height: Math.max(56, contentColumn.y
        + contentColumn.implicitHeight
        + 14, contentLoader.y
        + contentLoader.implicitHeight
        + 14)
    width: {
        const availableWidth = Overlay.overlay && Overlay.overlay.width > 0
            ? Math.max(0, Overlay.overlay.width - manager.edgeMargin * 2) : manager.maximumWidth
        const desiredWidth = Math.max(manager.minimumWidth,
            Math.min(manager.maximumWidth, manager.widthHint))
        return Math.min(desiredWidth, availableWidth)
    }

    Component.onCompleted: notification.open()
    Component.onDestruction: ELayout.releasePosition(messagePlacement, notification)

    ParallelAnimation {
        id: enterAnimation

        onFinished: {
            if ((!notification.pauseOnHover || !notification.hovered) && notification.messageDuration > 0)
                closeTimer.restart()
            if ((!notification.pauseOnHover || !notification.hovered) && notification.messageDuration > 0)
                countdown.restart()
        }

        NumberAnimation {
            property: "x"
            target: notification
            to: notification.targetX
            easing.type: Easing.InOutCubic
            duration: Math.max(0, manager.animationDuration)
        }
    }
    ParallelAnimation {
        id: layoutAnimation

        NumberAnimation {
            property: "x"
            target: notification
            to: notification.targetX
            easing.type: Easing.InOutCubic
            duration: Math.max(0, manager.animationDuration)
        }
        NumberAnimation {
            property: "y"
            target: notification
            easing.type: Easing.InOutCubic
            to: notification.targetY
                + (notification.topPlacement ? notification.edgeOffset - 10 : 10 - notification.edgeOffset)
            duration: notification.topPlacement
                      ? Math.max(0, manager.animationDuration + 100)
                      : Math.max(0, manager.animationDuration)
        }
    }
    ParallelAnimation {
        id: exitAnimation

        onFinished: manager.scheduleRemoval(notificationKey)

        NumberAnimation {
            to: 0
            property: "opacity"
            target: notification
            easing.type: Easing.InOutCubic
            duration: Math.max(0, manager.animationDuration)
        }
    }
    ERectangle {
        radius: 6
        border.width: 1
        anchors.fill: parent
        color: notification.resolvedBackgroundColor
        border.color: notification.resolvedBorderColor
    }
    HoverHandler {
        acceptedDevices: PointerDevice.Mouse

        onHoveredChanged: {
            notification.hovered = hovered
            if (hovered && notification.pauseOnHover) {
                closeTimer.stop()
                if (countdown.running)
                    countdown.pause()
            } else if (!notification.closing && notification.messageDuration > 0) {
                closeTimer.restart()
                countdown.restart()
            }
        }
    }
    EIcon {
        id: statusIcon

        x: 16
        y: 16
        width: 24
        height: 24
        iconSize: 20
        color: notification.resolvedIconColor
        visible: notification.messageShowIcon
        iconSource: notification.messageIconSource > 0
                    ? notification.messageIconSource
                    : manager.iconForStyle(notification.messageStyleType)
    }
    Column {
        id: contentColumn

        y: 14
        spacing: 4
        x: notification.messageShowIcon ? 52 : 16
        width: Math.max(0, notification.width - x
                        - (notification.messageShowClose ? 32 : 16))

        EText {
            id: titleText

            font.bold: true
            font.pixelSize: 14
            width: parent.width
            wrapMode: Text.Wrap
            text: notification.notificationTitle
            color: notification.resolvedTitleColor
            visible: notification.notificationTitle.length > 0
        }
        ECopyableText {
            id: messageText

            width: parent.width
            height: implicitHeight
            wrapMode: Text.WrapAnywhere
            color: notification.resolvedTextColor
            text: notification.notificationMessage
            visible: !notification.contentComponent
            textFormat: notification.richText ? TextEdit.RichText : TextEdit.PlainText
        }
    }
    Loader {
        id: contentLoader

        x: contentColumn.x
        width: contentColumn.width
        sourceComponent: notification.contentComponent
        y: contentColumn.y + (titleText.visible ? titleText.implicitHeight + contentColumn.spacing : 0)
    }
    ETextButton {
        id: closeButton

        z: 2
        width: 24
        height: 24
        circle: true
        iconSize: 12
        anchors.topMargin: 8
        anchors.rightMargin: 8
        anchors.top: parent.top
        anchors.right: parent.right
        isOpenBackgroundColor: true
        iconSource: notification.closeIcon
        visible: notification.messageShowClose

        onClicked: notification.close()
    }
    EProgress {
        readonly property var options: manager.progressFor(notification.notificationKey)

        width: notification.width
        striped: !!options.striped
        status: options.status || ""
        anchors.bottom: parent.bottom
        format: options.format || null
        textInside: !!options.textInside
        stripedFlow: !!options.stripedFlow
        percentage: notification.remaining * 100
        strokeWidth: Math.max(1, Number(options.strokeWidth) || 2)
        visible: notification.progress && notification.messageDuration > 0
        showText: options.showText === undefined ? false : options.showText
        color: options.color === undefined ? notification.resolvedIconColor : options.color
    }
    NumberAnimation {
        id: countdown

        to: 0
        from: 1
        target: notification
        property: "remaining"
        duration: Math.max(0, notification.messageDuration)
    }
    TapHandler {
        gesturePolicy: TapHandler.DragThreshold

        onTapped: function(eventPoint) {
            const point = closeButton.mapFromItem(notification, eventPoint.position.x, eventPoint.position.y)
            if (closeButton.visible && closeButton.contains(point))
                return
            manager.notifyClick(notification.notificationKey)
            if (notification.messageCloseOnClick)
                notification.close()
        }
    }
    Timer {
        id: closeTimer

        repeat: false
        running: false
        interval: Math.max(0, notification.messageDuration)

        onTriggered: notification.close()
    }
}

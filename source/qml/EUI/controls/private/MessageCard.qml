import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Item {
    id: notification

    property var entry
    property Item manager
    property real exitY: y
    property real enterY: y
    property real targetX: x
    property real targetY: y
    property bool closing: false
    property bool hovered: false
    property string key: entry.key
    property bool center: entry.center
    property int duration: entry.duration
    property real edgeOffset: entry.offset
    property string message: entry.message
    property bool richText: entry.richText
    property bool showIcon: entry.showIcon
    property bool messagePlain: entry.plain
    property int repeatNum: entry.repeatNum
    property bool showClose: entry.showClose
    property int iconSource: entry.iconSource
    property bool closeOnClick: entry.closeOnClick
    property int messagePlacement: entry.placement
    property int messageStyleType: entry.styleType
    property bool pauseOnHover: entry.pauseOnHover
    property color messageTextColor: entry.textColor
    property color messageBackgroundColor: entry.backgroundColor
    property Component contentComponent: manager.contentFor(notification.key)

    readonly property real animationOffset: Math.max(32, height)
    readonly property real contentWidth: Math.min(contentComponent ? contentLoader.implicitWidth
        : content.implicitWidth, maxContentWidth)
    readonly property bool bottomPlacement: messagePlacement === EPlacement.Bottom
        || messagePlacement === EPlacement.BottomLeft || messagePlacement === EPlacement.BottomRight
    readonly property real maxContentWidth: Math.max(
        0,
        (Overlay.overlay && Overlay.overlay.width > 0
            ? Overlay.overlay.width - 32
            : 560) - (notification.showClose ? closeButton.width + 24 : 16)
    )
    readonly property color resolvedTextColor: EPaletteManager.StatePalette.resolveEffectiveTextColor(
        EPaletteManager.createStateObject(this, EStyle.Color)
            .setDark(ETheme.dark)
            .setColor(notification.messageTextColor)
            .setComponentStyle(notification.messageStyleType)
    )
    readonly property color resolvedBackgroundColor: messageBackgroundColor.a > 0
        ? messageBackgroundColor
        : messagePlain ? EPaletteManager.StatePalette.resolveRectBackgroundColor(
            EPaletteManager.createStateObject(this, EStyle.BackgroundColor)
                .setDark(ETheme.dark)
        ) : EPaletteManager.StatePalette.computeBackgroundColor(
            EPaletteManager.createStateObject(this, EStyle.BackgroundColor)
                .setDark(ETheme.dark)
                .setPlain(true)
                .setComponentStyle(messageStyleType)
        )

    function relayout() {
        layoutAnim.start()
    }

    function restartTimer() {
        if (duration > 0 && (!pauseOnHover || !hovered))
            closeTimer.restart()
    }

    function close() {
        if (closing)
            return
        closing = true
        closeTimer.stop()
        enterAnim.stop()
        layoutAnim.stop()
        exitY = notification.y + (bottomPlacement ? animationOffset : -animationOffset)
        exitAnim.start()
    }

    function open() {
        const pos = ELayout.calculatePosition(messagePlacement, notification)
        const finalX = pos.x
        const finalY = pos.y + (bottomPlacement ? 10 - edgeOffset : edgeOffset - 10)
        notification.y = finalY + (bottomPlacement ? animationOffset : -animationOffset)
        notification.x = finalX
        notification.opacity = 0
        enterY = finalY
        Qt.callLater(function() {
            if (!notification.closing)
                enterAnim.start()
        })
    }

    opacity: 0
    z: entry.zIndex
    width: contentWidth + (notification.showClose ? closeButton.width + 24 : 16)
    height: Math.max(contentComponent ? contentLoader.implicitHeight
        : content.implicitHeight, notification.showIcon || notification.iconSource > 0 ? 20
        : 0)
        + 16

    Component.onDestruction: ELayout.releasePosition(messagePlacement, notification)
    Component.onCompleted: {
        notification.hovered = messageHover.hovered
        open()
        manager.opened(key)
    }

    ParallelAnimation {
        id: enterAnim

        NumberAnimation {
            duration: 300
            property: "y"
            target: notification
            to: notification.enterY
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            to: 1
            from: 0
            duration: 300
            property: "opacity"
            target: notification
            easing.type: Easing.OutCubic
        }
    }
    ParallelAnimation {
        id: layoutAnim

        NumberAnimation {
            duration: 300
            property: "x"
            target: notification
            to: notification.targetX
            easing.type: Easing.InOutCubic
        }
        NumberAnimation {
            duration: 300
            property: "y"
            target: notification
            easing.type: Easing.InOutCubic
            to: notification.targetY
                + (notification.bottomPlacement ? 10 - notification.edgeOffset : notification.edgeOffset - 10)
        }
    }
    ParallelAnimation {
        id: exitAnim

        onFinished: manager.scheduleRemoval(notification.key)

        NumberAnimation {
            to: 0
            duration: 300
            property: "opacity"
            target: notification
            easing.type: Easing.InCubic
        }
        NumberAnimation {
            duration: 300
            property: "y"
            target: notification
            to: notification.exitY
            easing.type: Easing.InCubic
        }
    }
    ERectangle {
        radius: 4
        anchors.fill: parent
        color: notification.resolvedBackgroundColor

        HoverHandler {
            id: messageHover

            acceptedDevices: PointerDevice.Mouse

            onHoveredChanged: {
                notification.hovered = hovered
                if (hovered && notification.pauseOnHover)
                    closeTimer.stop()
                else if (notification.duration > 0)
                    closeTimer.restart()
            }
        }
    }
    ECopyableText {
        id: content

        text: notification.message
        width: notification.contentWidth
        color: notification.resolvedTextColor
        visible: !notification.contentComponent
        anchors.verticalCenter: parent.verticalCenter
        leftPadding: notification.showIcon || notification.iconSource > 0 ? 24 : 0
        textFormat: notification.richText ? TextEdit.RichText : TextEdit.PlainText
        horizontalAlignment: notification.center ? Text.AlignHCenter : Text.AlignLeft
        x: notification.showClose
            ? (notification.center
                ? (parent.width - closeButton.width - 16 - width) / 2
                : 8)
            : (parent.width - width) / 2
    }
    Loader {
        id: contentLoader

        x: 8
        width: notification.contentWidth
        anchors.verticalCenter: parent.verticalCenter
        sourceComponent: notification.contentComponent
    }
    EIcon {
        x: 8
        iconSize: 16
        color: notification.resolvedTextColor
        anchors.verticalCenter: parent.verticalCenter
        visible: notification.showIcon || notification.iconSource > 0
        iconSource: notification.iconSource > 0 ? notification.iconSource
            : notification.messageStyleType === EStyle.Success ? EIcons.CIRCLE_CHECK_FILL
            : notification.messageStyleType === EStyle.Danger ? EIcons.CIRCLE_XMARK_FILL
            : notification.messageStyleType === EStyle.Warning ? EIcons.TRIANGLE_EXCLAMATION_FILL
                : EIcons.CIRCLE_Info_FILL
    }
    ERectangle {
        y: -8
        radius: 8
        height: 18
        anchors.right: parent.right
        visible: notification.repeatNum > 1
        color: notification.resolvedTextColor
        width: repeatLabel.implicitWidth + 10

        EText {
            id: repeatLabel

            font.pixelSize: 11
            anchors.centerIn: parent
            text: String(notification.repeatNum)
            color: notification.resolvedBackgroundColor
        }
    }
    ETextButton {
        id: closeButton

        z: 2
        width: 20
        height: 20
        circle: true
        iconSize: 14
        anchors.rightMargin: 8
        iconSource: EIcons.XMARK
        anchors.right: parent.right
        isOpenBackgroundColor: true
        visible: notification.showClose
        anchors.verticalCenter: parent.verticalCenter
        accessibleName: EControlConfig.textFor(notification, "Close", ELocale.texts)
        contentItem: EIcon {
            iconSize: 14
            iconSource: EIcons.XMARK
            color: notification.resolvedTextColor
        }

        onClicked: notification.close()
    }
    TapHandler {
        gesturePolicy: TapHandler.DragThreshold

        onTapped: {
            const point = closeButton.mapFromItem(notification, eventPoint.position.x, eventPoint.position.y)
            if (closeButton.visible && closeButton.contains(point))
                return
            manager.notifyClick(notification.key)
            if (notification.closeOnClick)
                notification.close()
        }
    }
    Timer {
        id: closeTimer

        repeat: false
        interval: notification.duration
        running: notification.visible
            && notification.duration > 0
            && (!notification.pauseOnHover || !notification.hovered)

        onTriggered: notification.close()
    }
}

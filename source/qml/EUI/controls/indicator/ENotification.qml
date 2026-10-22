import EUI 1.0
import EUI.Private 1.0
import "../private" as Private
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Item {
    id: control

    property string title
    property int iconSource
    property string message
    property real offset: 10
    property int duration: 4500
    property Item appendTo: null
    property var callbacks: ({})
    property real edgeMargin: 16
    property var progress: false
    property bool showIcon: true
    property real widthHint: 360
    property bool clearing: false
    property bool grouping: false
    property bool showClose: true
    property real maximumWidth: 480
    property real minimumWidth: 280
    property bool pauseOnHover: true
    property bool closeOnClick: false
    property int type: EStyle.Default
    property int animationDuration: 300
    property var pendingRemovalKeys: []
    property int closeIcon: EIcons.XMARK
    property int styleType: EStyle.Primary
    property int placement: EPlacement.TopRight
    property bool dangerouslyUseHTMLString: false
    property color iconColor: EPaletteManager.BasePalette.transparent
    property color textColor: EPaletteManager.BasePalette.transparent
    property color titleColor: EPaletteManager.BasePalette.transparent
    property color borderColor: EPaletteManager.BasePalette.transparent
    property color backgroundColor: EPaletteManager.BasePalette.transparent

    readonly property int count: listModel.count

    signal closed(string key)
    signal opened(string key)
    signal clicked(string key)

    function closeAll() {
        return clear()
    }

    function option(options, name, fallback) {
        return options[name] === undefined ? fallback : options[name]
    }

    function contentFor(key) {
        const entry = callbacks["$" + key]
        return entry ? entry.contentComponent || null : null
    }

    function progressFor(key) {
        const entry = callbacks["$" + key]
        return entry && typeof entry.progress === "object" ? entry.progress : ({})
    }

    function colorString(value) {
        return value === undefined || value === null ? String(EPaletteManager.BasePalette.transparent)
            : String(value)
    }

    function notifyClick(key) {
        const callback = callbacks["$" + key]
        if (callback && typeof callback.onClick === "function")
            callback.onClick(key)
        clicked(key)
    }

    function clear() {
        const count = repeater.count
        if (count === 0)
            return 0

        clearing = true
        let closedCount = 0
        for (let index = count - 1; index >= 0; --index) {
            const item = repeater.itemAt(index)
            if (item && !item.closing) {
                item.close()
                ++closedCount
            }
        }
        return closedCount
    }

    function scheduleRemoval(key) {
        const normalizedKey = String(key)
        for (let index = 0; index < pendingRemovalKeys.length; ++index) {
            if (String(pendingRemovalKeys[index]) === normalizedKey)
                return
        }

        pendingRemovalKeys = pendingRemovalKeys.concat([normalizedKey])
        removalTimer.restart()
    }

    function iconForStyle(style) {
        switch (style) {
        case EStyle.Success:
            return EIcons.CIRCLE_CHECK_FILL
        case EStyle.Info:
            return EIcons.CIRCLE_Info_FILL
        case EStyle.Warning:
            return EIcons.TRIANGLE_EXCLAMATION_FILL
        case EStyle.Danger:
            return EIcons.CIRCLE_XMARK_FILL
        default:
            return EIcons.BELL
        }
    }

    function normalizePlacement(value) {
        switch (value) {
        case EPlacement.TopLeft:
        case EPlacement.Top:
        case EPlacement.TopRight:
        case EPlacement.Left:
        case EPlacement.Center:
        case EPlacement.Right:
        case EPlacement.BottomLeft:
        case EPlacement.Bottom:
        case EPlacement.BottomRight:
            return value
        default:
            return EPlacement.TopRight
        }
    }

    function close(key) {
        if (key === undefined || key === null)
            return clear()

        const normalizedKey = String(key)
        for (let index = 0; index < listModel.count; ++index) {
            const itemData = listModel.get(index)
            if (String(itemData.key) !== normalizedKey)
                continue

            const item = repeater.itemAt(index)
            if (item && !item.closing) {
                item.close()
                return true
            }
            return false
        }
        return false
    }

    function removeNotification(key) {
        const normalizedKey = String(key)
        let index = -1
        for (let candidate = 0; candidate < listModel.count; ++candidate) {
            if (String(listModel.get(candidate).key) === normalizedKey) {
                index = candidate
                break
            }
        }
        if (index < 0)
            return false

        const item = repeater.itemAt(index)
        const affected = item
                         ? ELayout.releasePosition(item.messagePlacement, item)
                         : []
        const shouldRelayout = !clearing
        listModel.remove(index)
        if (clearing && listModel.count === 0)
            clearing = false
        const callback = callbacks["$" + normalizedKey]
        delete callbacks["$" + normalizedKey]
        if (callback && typeof callback.onClose === "function")
            callback.onClose(normalizedKey)
        control.closed(normalizedKey)
        if (!shouldRelayout)
            return true

        for (let affectedIndex = 0; affectedIndex < affected.length; ++affectedIndex) {
            const affectedItem = affected[affectedIndex]
            if (affectedItem && typeof affectedItem.relayout === "function")
                affectedItem.relayout()
        }
        return true
    }

    function open(messageValue) {
        const isOptionsObject = messageValue !== null && typeof messageValue === "object"
        const options = isOptionsObject ? messageValue : ({})
        const nextMessage = isOptionsObject && options.message !== undefined
                           ? options.message
                           : (messageValue === undefined || isOptionsObject ? control.message : messageValue)
        const nextTitle = isOptionsObject && options.title !== undefined
                        ? options.title
                        : control.title
        const messageText = String(nextMessage === undefined || nextMessage === null ? "" : nextMessage)
        const titleText = String(nextTitle === undefined || nextTitle === null ? "" : nextTitle)

        const keyValue = isOptionsObject && options.key !== undefined
                       ? options.key
                       : RandomUtils.nanoid()
        const notificationKey = keyValue === undefined || keyValue === null || keyValue === ""
                              ? RandomUtils.nanoid()
                              : String(keyValue)

        const durationValue = isOptionsObject && options.duration !== undefined
                            ? options.duration
                            : control.duration
        const durationNumber = Number(durationValue)
        const notificationDuration = isFinite(durationNumber)
                                    ? Math.max(0, durationNumber)
                                    : control.duration

        if (option(options, "grouping", control.grouping)) {
            for (let index = 0; index < listModel.count; ++index) {
                const existing = listModel.get(index)
                const existingItem = repeater.itemAt(index)
                if (existing.title === titleText
                        && existing.message === messageText
                        && (!existingItem || !existingItem.closing)) {
                    return existing.key
                }
            }
        }

        const style = option(options, "styleType", control.styleType)
        const itemType = option(options, "type", control.type)
        const notificationStyleType = itemType !== EStyle.Default ? itemType : style
        const notificationPlacement = normalizePlacement(
                    option(options, "placement", control.placement))

        callbacks["$"
            + notificationKey] = {onClose: options.onClose, onClick: options.onClick, contentComponent: options.contentComponent, progress: option(options, "progress", control.progress)}
        listModel.append({
            progress: !!option(options, "progress", control.progress),
            closeIcon: option(options, "closeIcon", control.closeIcon),
            title: titleText,
            zIndex: option(options, "zIndex", EControlConfig.valueFor(control, "zIndex", 0)),
            message: messageText,
            key: notificationKey,
            duration: notificationDuration,
            offset: Math.max(0, Number(option(options, "offset", control.offset)) || 0),
            pauseOnHover: !!option(options, "pauseOnHover", control.pauseOnHover),
            richText: !!option(options, "dangerouslyUseHTMLString", control.dangerouslyUseHTMLString),
            placement: notificationPlacement,
            styleType: notificationStyleType,
            showClose: option(options, "showClose", control.showClose),
            showIcon: option(options, "showIcon", control.showIcon),
            closeOnClick: option(options, "closeOnClick", control.closeOnClick),
            iconSource: option(options, "iconSource", control.iconSource),
            iconColor: colorString(option(options, "iconColor", control.iconColor)),
            backgroundColor: colorString(option(options, "backgroundColor", control.backgroundColor)),
            borderColor: colorString(option(options, "borderColor", control.borderColor)),
            titleColor: colorString(option(options, "titleColor", control.titleColor)),
            textColor: colorString(option(options, "textColor", control.textColor)),
        })
        return notificationKey
    }

    Timer {
        id: removalTimer

        interval: 0
        repeat: false

        onTriggered: {
            const keys = control.pendingRemovalKeys
            control.pendingRemovalKeys = []
            for (let index = 0; index < keys.length; ++index)
                control.removeNotification(keys[index])
        }
    }
    ListModel {
        id: listModel
    }
    Repeater {
        id: repeater

        model: listModel
        parent: control.appendTo || control.Overlay.overlay
        delegate: Private.NotificationCard {
            entry: model
            manager: control
        }
    }
}

import EUI 1.0
import EUI.Private 1.0
import "../private" as Private
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Item {
    id: control

    property int repeatNum: 1
    property int iconSource: 0
    property bool center: false
    property Item appendTo: null
    property var callbacks: ({})
    property bool clearing: false
    property bool showIcon: false
    property bool pauseOnHover: true
    property bool closeOnClick: false
    property int type: EStyle.Default
    property var pendingRemovalKeys: []
    property int styleType: EStyle.Primary
    property bool dangerouslyUseHTMLString: false
    property color textColor: EPaletteManager.BasePalette.transparent
    property color backgroundColor: EPaletteManager.BasePalette.transparent
    property int max: EControlConfig.optionFor(control, "message", "max", 0)
    property real offset: EControlConfig.optionFor(control, "message", "offset", 10)
    property bool plain: EControlConfig.optionFor(control, "message", "plain", false)
    property int duration: EControlConfig.optionFor(control, "message", "duration", 3000)
    property bool grouping: EControlConfig.optionFor(control, "message", "grouping", false)
    property bool showClose: EControlConfig.optionFor(control, "message", "showClose", true)
    property int placement: EControlConfig.optionFor(control, "message", "placement", EPlacement.Top)

    readonly property int count: listModel.count

    signal closed(string key)
    signal opened(string key)
    signal clicked(string key)

    function closeAll(type) {
        return clear(type)
    }

    function option(options, name, fallback) {
        return options[name] === undefined ? fallback : options[name]
    }

    function contentFor(key) {
        const entry = callbacks["$" + key]
        return entry ? entry.contentComponent || null : null
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

    function scheduleRemoval(key) {
        const normalizedKey = String(key)
        if (pendingRemovalKeys.indexOf(normalizedKey) >= 0)
            return
        pendingRemovalKeys = pendingRemovalKeys.concat([normalizedKey])
        removalTimer.restart()
    }

    function close(key) {
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

    function clear(type) {
        const count = repeater.count
        if (count === 0)
            return 0

        const filtered = type !== undefined && type !== null
        clearing = !filtered
        let closedCount = 0
        for (let index = count - 1; index >= 0; --index) {
            const item = repeater.itemAt(index)
            if (item && !item.closing && (!filtered || item.messageStyleType === type)) {
                item.close()
                ++closedCount
            }
        }
        return closedCount
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
        const affected = item ? ELayout.releasePosition(item.messagePlacement, item) : []
        listModel.remove(index)
        const shouldRelayout = !clearing
        if (clearing && listModel.count === 0)
            clearing = false
        const callback = callbacks["$" + normalizedKey]
        delete callbacks["$" + normalizedKey]
        if (callback && typeof callback.onClose === "function")
            callback.onClose(normalizedKey)
        closed(normalizedKey)

        if (!shouldRelayout)
            return true

        for (let affectedIndex = 0; affectedIndex < affected.length; ++affectedIndex) {
            const affectedItem = affected[affectedIndex]
            if (affectedItem && typeof affectedItem.relayout === "function")
                affectedItem.relayout()
        }
        return true
    }

    function open(message, key = RandomUtils.nanoid(), duration = control.duration) {
        const isOptionsObject = message !== null && typeof message === "object"
        const options = isOptionsObject ? message : {}
        const messageValue = isOptionsObject ? options.message : message
        const messageText = String(messageValue === undefined || messageValue === null
                                    ? ""
                                    : messageValue)

        const keyValue = isOptionsObject && options.key !== undefined
                         ? options.key
                         : key
        const messageKey = keyValue === undefined || keyValue === null || keyValue === ""
                           ? RandomUtils.nanoid()
                           : String(keyValue)

        const durationValue = isOptionsObject && options.duration !== undefined
                              ? options.duration
                              : duration
        const durationNumber = Number(durationValue)
        const messageDuration = isFinite(durationNumber)
                                ? Math.max(0, durationNumber)
                                : control.duration

        const styleType = option(options, "styleType", control.styleType)
        const type = option(options, "type", control.type)
        const messageStyleType = type !== EStyle.Default ? type : styleType
        const messagePlacement = option(options, "placement", control.placement)

        if (option(options, "grouping", control.grouping) && !options.contentComponent) {
            for (let index = 0; index < listModel.count; ++index) {
                const existing = listModel.get(index)
                const existingItem = repeater.itemAt(index)
                if (existing.message === messageText && existing.placement === messagePlacement
                    && !contentFor(existing.key) && (!existingItem || !existingItem.closing)) {
                    listModel.setProperty(index, "repeatNum", existing.repeatNum + 1)
                    listModel.setProperty(index, "styleType", messageStyleType)
                    if (existingItem)
                        existingItem.restartTimer()
                    return existing.key
                }
            }
        }

        if (max > 0) {
            let placementCount = 0
            for (let index = 0; index < listModel.count; ++index) {
                if (listModel.get(index).placement === messagePlacement)
                    ++placementCount
            }
            if (placementCount >= max)
                return ""
        }

        callbacks["$"
            + messageKey] = {onClose: options.onClose, onClick: options.onClick, contentComponent: options.contentComponent}
        listModel.append({
            zIndex: option(options, "zIndex", EControlConfig.valueFor(control, "zIndex", 0)),
            message: messageText,
            duration: messageDuration,
            offset: Math.max(0, Number(option(options, "offset", control.offset)) || 0),
            pauseOnHover: !!option(options, "pauseOnHover", control.pauseOnHover),
            richText: !!option(options, "dangerouslyUseHTMLString", control.dangerouslyUseHTMLString),
            placement: messagePlacement,
            repeatNum: Math.max(1, Math.floor(Number(option(options, "repeatNum", control.repeatNum))) || 1),
            iconSource: option(options, "iconSource", control.iconSource),
            showIcon: option(options, "showIcon", control.showIcon),
            key: messageKey,
            showClose: option(options, "showClose", control.showClose),
            closeOnClick: option(options, "closeOnClick", control.closeOnClick),
            center: option(options, "center", control.center),
            plain: !!option(options, "plain", control.plain),
            textColor: colorString(option(options, "textColor", control.textColor)),
            backgroundColor: colorString(option(options, "backgroundColor", control.backgroundColor)),
            styleType: messageStyleType
        })
        return messageKey
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
    Repeater {
        id: repeater

        model: ListModel { id: listModel }
        parent: control.appendTo || control.Overlay.overlay
        delegate: Private.MessageCard {
            entry: model
            manager: control
        }
    }
}

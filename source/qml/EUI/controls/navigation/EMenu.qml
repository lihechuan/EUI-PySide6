import EUI 1.0
import "private" as Private
import QtQuick 2.15
import QtQml 2.15

Item {
    id: control

    property var model: []
    property int indent: 20
    property int iconSize: 16
    property int duration: 180
    property int itemHeight: 44
    property bool ellipsis: true
    property bool collapse: false
    property int hideTimeout: 150
    property real popperOffset: 0
    property int showTimeout: 150
    property var openedIndexes: []
    property bool persistent: true
    property string currentIndex: ""
    property bool uniqueOpened: true
    property string menuTrigger: "hover"
    property string popperEffect: "light"
    property int styleType: EStyle.Primary
    property bool closeOnClickOutside: true
    property bool collapseTransition: false
    property int ellipsisIcon: EIcons.ELLIPSIS
    property int direction: EOrientation.Vertical
    property int expandOpenIcon: EIcons.CHEVRON_UP
    property int expandCloseIcon: EIcons.CHEVRON_DOWN
    property int collapseOpenIcon: EIcons.CHEVRON_RIGHT
    property int collapseCloseIcon: EIcons.CHEVRON_RIGHT
    property color textColor: EPaletteManager.BasePalette.transparent
    property color hoverColor: EPaletteManager.BasePalette.transparent
    property color activeTextColor: EPaletteManager.BasePalette.transparent
    property color backgroundColor: EPaletteManager.BasePalette.transparent

    readonly property var allEntries: completeEntries()
    readonly property bool popupMode: horizontal || collapse
    readonly property bool horizontal: direction === EOrientation.Horizontal
    readonly property var displayItems: horizontal ? visibleItems.slice(0, visibleRootCount) : visibleItems
    readonly property var overflowItems: visibleItems.slice(visibleRootCount).map(function(entry) {
        return entry.item
    })
    readonly property real naturalWidth: visibleItems.reduce(function(width, entry) {
        return width + itemWidth(entry)
    }, 0)
    readonly property color resolvedTextColor: textColor.a === 0
        ? EPaletteManager.ThemePalette.textRegular(ETheme.dark)
        : textColor
    readonly property color resolvedActiveTextColor: activeTextColor.a === 0
        ? EPaletteManager.ThemePalette.fetchColorForStyle(styleType)
        : activeTextColor
    readonly property color resolvedBackgroundColor: backgroundColor.a === 0
        ? EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
        : backgroundColor
    readonly property var visibleItems: EDataUtils.menuEntries(model, (EDataUtils.isArray(openedIndexes)
        ? openedIndexes
        : []).concat(allEntries.filter(function(entry) {
        return entry.item.group === true
    }).map(function(entry) {
        return entry.index
    })), popupMode)
    readonly property int visibleRootCount: {
        if (!horizontal || !ellipsis || width >= naturalWidth)
            return visibleItems.length
        let used = 44
        let count = 0
        for (const entry of visibleItems) {
            used += itemWidth(entry)
            if (used > width)
                break
            ++count
        }
        return count
    }
    readonly property color resolvedHoverColor: hoverColor.a === 0
        ? EPaletteManager.StatePalette.computeBackgroundColor(
            EPaletteManager.createStateObject(control, EStyle.BackgroundColor)
                .setDark(ETheme.dark)
                .setHovered(true)
                .setEnabled(true)
        )
        : hoverColor

    signal closed(string index)
    signal opened(string index)
    signal branchClosed(string index, var indexPath)
    signal branchOpened(string index, var indexPath)
    signal itemSelected(string index, var indexPath, var item)

    function handleResize() {
        overflowMenu.close()
    }

    function toggle(index) {
        return isOpened(index) ? close(index) : open(index)
    }

    function isOpened(index) {
        return EDataUtils.isArray(openedIndexes) && openedIndexes.indexOf(String(index)) >= 0
    }

    function itemWidth(entry) {
        return Math.max(88, textMetrics.advanceWidth(entry.text)
            + 32
            + (entry.iconSource > 0 ? iconSize + 8 : 0))
    }

    function trigger(index, item) {
        for (const entry of allEntries) {
            if (entry.item === item)
                return select(entry.index)
        }
        return select(index)
    }

    function updateActiveIndex(index) {
        const entry = findEntry(index)
        if (!enabled || !entry || entry.disabled || entry.hasChildren)
            return false
        currentIndex = entry.index
        return true
    }

    function findEntry(index) {
        const normalized = String(index)
        for (let position = 0; position < allEntries.length; ++position) {
            if (allEntries[position].index === normalized)
                return allEntries[position]
        }
        return null
    }

    function select(index) {
        const entry = findEntry(index)
        if (!enabled || !entry || entry.disabled || entry.hasChildren)
            return false

        currentIndex = entry.index
        itemSelected(entry.index, entry.indexPath, entry.item)
        if (popupMode) {
            const previous = openedIndexes.slice()
            openedIndexes = []
            for (const key of previous) {
                const branch = findEntry(key)
                closed(key)
                branchClosed(key, branch ? branch.indexPath : [])
            }
        }
        return true
    }

    function close(index) {
        const normalized = String(index)
        const position = EDataUtils.isArray(openedIndexes) ? openedIndexes.indexOf(normalized) : -1
        if (position < 0)
            return false

        const next = []
        for (let indexPosition = 0; indexPosition < openedIndexes.length; ++indexPosition) {
            const openedIndex = openedIndexes[indexPosition]
            const entry = findEntry(openedIndex)
            if (openedIndex !== normalized
                && (!entry || entry.indexPath.indexOf(normalized) < 0))
                next.push(openedIndex)
        }
        const previous = openedIndexes
        openedIndexes = next
        for (const key of previous) {
            if (next.indexOf(key) < 0) {
                const entry = findEntry(key)
                closed(key)
                branchClosed(key, entry ? entry.indexPath : [])
            }
        }
        return true
    }

    function completeEntries() {
        const keys = []
        const visited = []
        const pending = EDataUtils.isArray(model) ? model.slice() : []
        while (pending.length > 0) {
            const item = pending.pop()
            if (!item || typeof item !== "object" || visited.indexOf(item) >= 0)
                continue
            visited.push(item)
            if (EDataUtils.isArray(item.children)) {
                if (item.index !== undefined)
                    keys.push(String(item.index))
                for (const child of item.children)
                    pending.push(child)
            }
        }
        let entries = EDataUtils.menuEntries(model, keys, false)
        while (true) {
            const missing = entries.filter(function(entry) {
                return entry.hasChildren && keys.indexOf(entry.index) < 0
            })
            if (missing.length === 0)
                return entries
            for (const entry of missing)
                keys.push(entry.index)
            entries = EDataUtils.menuEntries(model, keys, false)
        }
    }

    function open(index) {
        if (!enabled)
            return false
        const normalized = String(index)
        if (isOpened(normalized))
            return false

        const entry = findEntry(normalized)
        if (!entry || entry.disabled || !entry.hasChildren)
            return false
        const ancestors = entry ? entry.indexPath.slice(0, -1) : []
        const previous = EDataUtils.isArray(openedIndexes) ? openedIndexes : []
        const next = uniqueOpened ? ancestors.concat([normalized]) : previous.slice()
        for (const key of ancestors.concat([normalized])) {
            if (next.indexOf(key) < 0)
                next.push(key)
        }
        openedIndexes = next
        for (const key of previous) {
            if (next.indexOf(key) < 0) {
                const branch = findEntry(key)
                closed(key)
                branchClosed(key, branch ? branch.indexPath : [])
            }
        }
        for (const key of next) {
            if (previous.indexOf(key) < 0) {
                const branch = findEntry(key)
                opened(key)
                branchOpened(key, branch ? branch.indexPath : [])
            }
        }
        return true
    }

    implicitWidth: horizontal ? naturalWidth : collapse ? 64 : 240
    implicitHeight: horizontal ? itemHeight : verticalColumn.implicitHeight

    Behavior on implicitWidth {
        enabled: control.collapseTransition

        NumberAnimation {
            duration: control.duration
        }
    }
    Behavior on implicitHeight {
        enabled: control.collapseTransition

        NumberAnimation {
            duration: control.duration
        }
    }
    ERectangle {
        anchors.fill: parent
        color: control.resolvedBackgroundColor
    }
    Row {
        id: horizontalRow

        visible: control.horizontal

        Repeater {
            delegate: menuItemComponent
            model: control.horizontal ? control.displayItems : 0
        }
        ETextButton {
            width: 44
            height: control.itemHeight
            iconSource: control.ellipsisIcon
            visible: control.overflowItems.length > 0

            onClicked: overflowMenu.visible ? overflowMenu.close() : overflowMenu.open()

            Private.MenuBranch {
                id: overflowMenu

                nested: true
                owner: control
                y: parent.height
                model: control.overflowItems
            }
        }
    }
    Column {
        id: verticalColumn

        width: control.width
        visible: !control.horizontal

        Repeater {
            delegate: menuItemComponent
            model: control.horizontal ? 0 : control.visibleItems
        }
    }
    FontMetrics {
        id: textMetrics

        font.pixelSize: EDefaultConfig.controlFontPixelSize(EStyle.Medium)
    }
    Component {
        id: menuItemComponent

        Private.MenuEntry {
            owner: control
            entry: modelData
        }
    }
}

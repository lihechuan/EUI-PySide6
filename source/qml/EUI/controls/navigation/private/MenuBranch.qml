import EUI 1.0
import "../../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Menu {
    id: menu

    property var owner
    property var model: []
    property var entry: ({})
    property bool loaded: false
    property bool nested: false
    property string indexKey: ""

    readonly property bool hovered: {
        if (menuHover.hovered)
            return true
        for (let index = 0; index < count; ++index) {
            const action = itemAt(index)
            if (action && (action.hovered || action.pointerHovered
                || action.subMenu && action.subMenu.visible && action.subMenu.hovered))
                return true
        }
        return false
    }

    function insert(index, loader) {
        if (!loader.item || loader.inserted)
            return
        loader.inserted = true
        if (loader.hasChildren)
            insertMenu(index, loader.item)
        else
            insertItem(index, loader.item)
    }

    function groupedItems(items) {
        const result = []
        const seen = []
        const pending = EDataUtils.isArray(items) ? items.slice().reverse() : []
        while (pending.length > 0) {
            const item = pending.pop()
            if (item && item.group && EDataUtils.isArray(item.children)) {
                if (seen.indexOf(item) >= 0)
                    continue
                seen.push(item)
                result.push({text: item.text
                    || item.title
                    || "", disabled: true, titleComponent: item.titleComponent
                    || null})
                for (let index = item.children.length - 1; index >= 0; --index)
                    pending.push(item.children[index])
            } else {
                result.push(item)
            }
        }
        return result
    }

    padding: 6
    implicitWidth: 200
    z: EControlConfig.valueFor(menu, "zIndex", 0)
    overlap: -Math.max(0, entry.popperOffset === undefined ? owner && owner.popperOffset || 0
        : entry.popperOffset)
    closePolicy: owner && owner.closeOnClickOutside === false ? Popup.CloseOnEscape
        : Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    delegate: MenuAction {
        iconSource: subMenu && subMenu.entry ? subMenu.entry.iconSource || 0 : 0
        titleComponent: subMenu && subMenu.entry ? subMenu.entry.titleComponent || null : null
    }
    background: ERectangle {
        radius: 4
        border.width: 1
        border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
        color: menu.owner && menu.owner.popperEffect === "dark"
            ? EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
            : EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)

        HoverHandler {
            id: menuHover
        }
    }

    onOpened: currentIndex = 0
    onAboutToShow: {
        loaded = true
        if (indexKey && owner && typeof owner.open === "function" && typeof owner.findEntry === "function")
            owner.open(indexKey)
    }
    onClosed: {
        if (indexKey && owner && typeof owner.findEntry === "function")
            owner.close(indexKey)
        if (owner && owner.persistent === false)
            loaded = false
    }

    Connections {
        function onParentChanged() {
            if (menu.visible)
                menu.contentItem.forceActiveFocus()
        }

        target: menu.contentItem
    }
    Shortcut {
        sequence: "Left"
        enabled: menu.visible && !menu.nested

        onActivated: menu.owner.move(-1)
    }
    Shortcut {
        sequence: "Right"
        enabled: menu.visible
            && !menu.nested
            && !(menu.itemAt(menu.currentIndex) && menu.itemAt(menu.currentIndex).subMenu)

        onActivated: menu.owner.move(1)
    }
    Instantiator {
        model: menu.loaded ? menu.groupedItems(menu.model) : []
        delegate: Loader {
            id: entryLoader

            property bool inserted: false
            property var entry: modelData || ({})

            readonly property bool hasChildren: EDataUtils.isArray(entry.children) && entry.children.length > 0

            sourceComponent: hasChildren ? null : actionComponent
            source: hasChildren ? Qt.resolvedUrl("MenuBranch.qml") : ""

            onLoaded: {
                if (hasChildren) {
                    item.entry = entry
                    item.owner = menu.owner
                    item.indexKey = entry.index === undefined ? "" : String(entry.index)
                    item.nested = true
                    item.model = entry.children
                    item.enabled = !entry.disabled
                    item.title = String(entry.text || entry.title || "")
                }
                menu.insert(index, entryLoader)
            }

            Component {
                id: actionComponent

                MenuAction {
                    enabled: !entryLoader.entry.disabled
                    iconSource: entryLoader.entry.iconSource || 0
                    titleComponent: entryLoader.entry.titleComponent || null
                    text: String(entryLoader.entry.text || entryLoader.entry.title || "")

                    onTriggered: menu.owner.trigger(
                        entryLoader.entry.index === undefined ? text : entryLoader.entry.index,
                        entryLoader.entry)
                }
            }
        }

        onObjectAdded: function(index, object) {
            menu.insert(index, object)
        }
        onObjectRemoved: function(index, object) {
            if (object.item && object.inserted) {
                if (object.hasChildren)
                    menu.removeMenu(object.item)
                else
                    menu.removeItem(object.item)
            }
        }
    }
}

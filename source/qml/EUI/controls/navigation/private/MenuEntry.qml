import EUI 1.0
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Window 2.15

Item {
    id: item

    property var entry
    property var owner

    readonly property alias menu: branch
    readonly property bool expanded: owner.isOpened(entry.index)
    readonly property bool itemEnabled: owner.enabled && !entry.disabled && !entry.item.group
    readonly property bool selected: !entry.hasChildren && entry.index === owner.currentIndex
    readonly property real textWidth: Math.max(0, width - leftInset - (entry.hasChildren ? 34 : 14))
    readonly property real leftInset: owner.horizontal ? 16
        : owner.collapse ? 14
        : 14 + entry.level * owner.indent
    readonly property color textColor: !itemEnabled ? EPaletteManager.ThemePalette.textDisabled(ETheme.dark)
        : selected ? owner.resolvedActiveTextColor : owner.resolvedTextColor

    function activate() {
        if (!itemEnabled)
            return
        if (entry.hasChildren)
            owner.toggle(entry.index)
        else
            owner.select(entry.index)
    }

    function syncPopup() {
        if (!owner || !entry || !owner.popupMode || !entry.hasChildren)
            return
        if (expanded && item.visible && item.Window.window && branch.parent)
            branch.open()
        else
            branch.close()
    }

    Accessible.name: entry.text
    Accessible.selected: selected
    activeFocusOnTab: itemEnabled
    Accessible.role: Accessible.MenuItem
    height: Math.max(1, entry.item.group ? 32 : owner.itemHeight)
    width: owner.horizontal ? owner.itemWidth(entry) : owner.width

    Keys.onEnterPressed: activate()
    Keys.onSpacePressed: activate()
    Keys.onReturnPressed: activate()
    onVisibleChanged: popupSyncTimer.restart()
    onExpandedChanged: popupSyncTimer.restart()
    Component.onCompleted: popupSyncTimer.restart()
    Window.onWindowChanged: popupSyncTimer.restart()

    ERectangle {
        anchors.fill: parent
        color: item.selected && !item.owner.horizontal
            ? EPaletteManager.StatePalette.computeBackgroundColor(
                EPaletteManager.createStateObject(this, EStyle.BackgroundColor)
                    .setDark(ETheme.dark)
                    .setPressed(true)
            )
            : pointer.containsMouse || item.activeFocus
                ? item.owner.resolvedHoverColor : item.owner.resolvedBackgroundColor
    }
    ERectangle {
        height: 3
        width: parent.width
        anchors.bottom: parent.bottom
        color: item.owner.resolvedActiveTextColor
        visible: item.selected && item.owner.horizontal
    }
    Row {
        id: content

        spacing: 8
        x: item.leftInset
        anchors.verticalCenter: parent.verticalCenter
        width: item.owner.horizontal ? implicitWidth : item.textWidth

        EIcon {
            color: item.textColor
            iconSize: item.owner.iconSize
            iconSource: item.entry.iconSource
            visible: item.entry.iconSource !== 0
            anchors.verticalCenter: parent.verticalCenter
        }
        Loader {
            anchors.verticalCenter: parent.verticalCenter
            sourceComponent: item.entry.item.titleComponent || null
        }
        EText {
            color: item.textColor
            text: item.entry.text
            elide: Text.ElideRight
            anchors.verticalCenter: parent.verticalCenter
            visible: (!item.owner.collapse || item.owner.horizontal) && !item.entry.item.titleComponent
            width: item.owner.horizontal ? implicitWidth
                : Math.max(0, content.width - (item.entry.iconSource ? item.owner.iconSize + content.spacing
                    : 0))
        }
    }
    EIcon {
        rotation: 0
        anchors.rightMargin: 14
        anchors.right: parent.right
        color: item.owner.resolvedTextColor
        anchors.verticalCenter: parent.verticalCenter
        iconSize: Math.max(12, item.owner.iconSize - 2)
        visible: item.entry.hasChildren
            && !item.entry.item.group
            && !item.owner.horizontal
            && !item.owner.collapse
        iconSource: item.owner.collapse
            ? item.expanded ? item.entry.item.collapseOpenIcon || item.owner.collapseOpenIcon
                : item.entry.item.collapseCloseIcon || item.owner.collapseCloseIcon
            : item.expanded ? item.entry.item.expandOpenIcon || item.owner.expandOpenIcon
                : item.entry.item.expandCloseIcon || item.owner.expandCloseIcon
    }
    MenuBranch {
        id: branch

        nested: true
        parent: item
        owner: item.owner
        entry: item.entry.item
        enabled: item.itemEnabled
        model: item.entry.item.children
        x: item.owner.horizontal ? 0
            : item.width
                + (item.entry.item.popperOffset === undefined ? item.owner.popperOffset
                    : item.entry.item.popperOffset)
        y: item.owner.horizontal
            ? item.height
                + (item.entry.item.popperOffset === undefined ? item.owner.popperOffset
                    : item.entry.item.popperOffset)
            : 0

        onClosed: {
            if (item.expanded)
                item.owner.close(item.entry.index)
        }
        onHoveredChanged: {
            if (hovered)
                hideTimer.stop()
            else if (item.owner.menuTrigger === "hover")
                hideTimer.restart()
        }
    }
    Timer {
        id: popupSyncTimer

        interval: 0

        onTriggered: item.syncPopup()
    }
    Timer {
        id: showTimer

        interval: Math.max(0, item.entry.item.showTimeout === undefined ? item.owner.showTimeout
            : item.entry.item.showTimeout)

        onTriggered: if (item.owner.menuTrigger === "hover") item.owner.open(item.entry.index)
    }
    Timer {
        id: hideTimer

        interval: Math.max(0, item.entry.item.hideTimeout === undefined ? item.owner.hideTimeout
            : item.entry.item.hideTimeout)

        onTriggered: {
            if (item.owner.menuTrigger === "hover" && !pointer.containsMouse && !branch.hovered)
                item.owner.close(item.entry.index)
        }
    }
    MouseArea {
        id: pointer

        hoverEnabled: true
        anchors.fill: parent
        enabled: item.itemEnabled
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

        onClicked: {
            item.forceActiveFocus()
            item.activate()
        }
        onExited: {
            showTimer.stop()
            if (item.owner.popupMode && item.owner.menuTrigger === "hover")
                hideTimer.restart()
        }
        onEntered: {
            if (item.entry.hasChildren && item.owner.popupMode && item.owner.menuTrigger === "hover") {
                hideTimer.stop()
                showTimer.restart()
            }
        }
    }
}

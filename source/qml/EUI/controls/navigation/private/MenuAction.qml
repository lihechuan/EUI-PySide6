import EUI 1.0
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

MenuItem {
    id: action

    property int iconSource: 0
    property Component titleComponent: null

    readonly property bool pointerHovered: submenuHover.hovered
    readonly property var submenuOwner: menu ? menu.owner : null
    readonly property bool hasIcon: iconSource > 0 || String(icon.source).length > 0
    readonly property bool managedSubmenu: subMenu && submenuOwner && submenuOwner.menuTrigger !== undefined
    readonly property bool darkEffect: menu && (menu.owner && menu.owner.popperEffect === "dark"
        || menu.parent && menu.parent.effect === "dark")

    padding: 10
    topPadding: 0
    bottomPadding: 0
    implicitHeight: 34
    hoverEnabled: !managedSubmenu
    indicator: EIcon {
        iconSize: 14
        anchors.leftMargin: 10
        iconSource: EIcons.CHECK
        anchors.left: parent.left
        visible: action.checkable && action.checked
        anchors.verticalCenter: parent.verticalCenter
        color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
    }
    background: ERectangle {
        radius: 3
        color: EPaletteManager.StatePalette.adjustPlainTextButtonColor(
            EPaletteManager.createStateObject(this, EStyle.BackgroundColor)
                .setDark(action.darkEffect ? !ETheme.dark : ETheme.dark)
                .setColor(EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark))
                .setEnabled(action.enabled)
                .setHovered(action.highlighted)
        )
    }
    contentItem: EText {
        text: action.text
        elide: Text.ElideRight
        visible: !action.titleComponent
        verticalAlignment: Text.AlignVCenter
        rightPadding: action.subMenu ? 18 : 0
        leftPadding: action.checkable || action.hasIcon ? 24 : 0
        color: EPaletteManager.StatePalette.computeTextColor(
            EPaletteManager.createStateObject(this, EStyle.Color)
                .setDark(action.darkEffect ? !ETheme.dark : ETheme.dark)
                .setEnabled(action.enabled)
                .setHovered(action.highlighted)
        )
    }
    arrow: EIcon {
        iconSize: 12
        anchors.rightMargin: 10
        anchors.right: parent.right
        visible: action.subMenu !== null
        anchors.verticalCenter: parent.verticalCenter
        color: action.darkEffect ? EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
            : EPaletteManager.ThemePalette.textRegular(ETheme.dark)
        iconSource: action.managedSubmenu
            ? action.subMenu.visible
                ? action.subMenu.entry.collapseOpenIcon || action.submenuOwner.collapseOpenIcon
                : action.subMenu.entry.collapseCloseIcon || action.submenuOwner.collapseCloseIcon
            : EIcons.CHEVRON_RIGHT
    }

    HoverHandler {
        id: submenuHover

        onHoveredChanged: {
            if (!action.managedSubmenu || action.submenuOwner.menuTrigger !== "hover")
                return
            if (hovered) {
                closeTimer.stop()
                openTimer.restart()
            } else {
                openTimer.stop()
                closeTimer.restart()
            }
        }
    }
    Timer {
        id: openTimer

        interval: Math.max(0, action.managedSubmenu && action.subMenu.entry.showTimeout !== undefined
            ? action.subMenu.entry.showTimeout : action.submenuOwner ? action.submenuOwner.showTimeout : 150)

        onTriggered: {
            if (!action.managedSubmenu || !action.enabled || action.submenuOwner.menuTrigger !== "hover")
                return
            for (let index = 0; index < action.menu.count; ++index) {
                const item = action.menu.itemAt(index)
                if (item === action)
                    action.menu.currentIndex = index
                else if (item.subMenu)
                    item.subMenu.close()
            }
            action.subMenu.open()
        }
    }
    Timer {
        id: closeTimer

        interval: Math.max(0, action.managedSubmenu && action.subMenu.entry.hideTimeout !== undefined
            ? action.subMenu.entry.hideTimeout : action.submenuOwner ? action.submenuOwner.hideTimeout : 150)

        onTriggered: {
            if (action.managedSubmenu && action.submenuOwner.menuTrigger === "hover"
                && !submenuHover.hovered && !action.subMenu.hovered)
                action.subMenu.close()
        }
    }
    Connections {
        function onHoveredChanged() {
            if (!action.managedSubmenu || action.submenuOwner.menuTrigger !== "hover")
                return
            if (action.subMenu.hovered)
                closeTimer.stop()
            else
                closeTimer.restart()
        }

        target: action.subMenu
        ignoreUnknownSignals: true
    }
    EIcon {
        iconSize: 16
        x: action.leftPadding
        iconSource: action.iconSource
        visible: action.iconSource > 0
        anchors.verticalCenter: parent.verticalCenter
        color: action.darkEffect ? EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
            : EPaletteManager.ThemePalette.textRegular(ETheme.dark)
    }
    Image {
        width: 16
        height: 16
        x: action.leftPadding
        source: action.icon.source
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: parent.verticalCenter
        visible: action.iconSource <= 0 && String(source).length > 0
    }
    Loader {
        sourceComponent: action.titleComponent
        anchors.verticalCenter: parent.verticalCenter
        x: action.leftPadding + (action.hasIcon ? 24 : 0)
        width: Math.max(0, action.availableWidth - (action.hasIcon ? 24 : 0))
    }
}

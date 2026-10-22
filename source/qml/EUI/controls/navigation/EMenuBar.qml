import EUI 1.0
import "private" as Private
import QtQuick 2.15
import QtQuick.Controls

Control {
    id: control

    property var model: []
    property int activeIndex: -1
    property string currentIndex: ""

    readonly property int count: items.length
    readonly property var items: EDataUtils.isArray(model) ? model : []

    signal command(string index, var item)

    function trigger(index, item) {
        if (!enabled || !item || item.disabled)
            return false
        currentIndex = String(index)
        close()
        command(currentIndex, item)
        return true
    }

    function close() {
        activeIndex = -1
        for (let position = 0; position < count; ++position) {
            const button = buttons.itemAt(position)
            if (button && button.menu.visible)
                button.menu.close()
        }
    }

    function move(delta) {
        if (!count || !isFinite(delta) || (delta !== -1 && delta !== 1))
            return false
        const start = activeIndex >= 0 ? activeIndex : 0
        for (let offset = 1; offset <= count; ++offset) {
            const index = (start + delta * offset + count * 2) % count
            if (items[index] && !items[index].disabled)
                return open(index)
        }
        return false
    }

    function open(index) {
        if (!enabled || !isFinite(index) || Math.floor(index) !== index || index < 0 || index >= count)
            return false
        const entry = items[index]
        if (!entry || entry.disabled)
            return false
        close()
        activeIndex = index
        const button = buttons.itemAt(index)
        if (!button) {
            activeIndex = -1
            return false
        }
        button.forceActiveFocus()
        if (EDataUtils.isArray(entry.children) && entry.children.length)
            button.menu.open()
        return true
    }

    padding: 4
    implicitHeight: 40
    implicitWidth: menuRow.implicitWidth + leftPadding + rightPadding
    background: ERectangle {
        color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
    }
    contentItem: Row {
        id: menuRow

        spacing: 4

        Repeater {
            id: buttons

            model: control.items

            ETextButton {
                id: menuButton

                property var entry: modelData || ({})

                readonly property alias menu: branch
                readonly property bool hasChildren: EDataUtils.isArray(entry.children) && entry.children.length > 0

                minHeight: 32
                enabled: !entry.disabled
                text: String(entry.text || "")
                isOpenBackgroundColor: index === control.activeIndex

                Keys.onLeftPressed: control.move(-1)
                Keys.onRightPressed: control.move(1)
                Keys.onEscapePressed: control.close()
                Keys.onDownPressed: control.open(index)
                onHoveredChanged: {
                    if (hovered && control.activeIndex >= 0 && index !== control.activeIndex)
                        control.open(index)
                }
                onClicked: {
                    if (hasChildren)
                        control.activeIndex === index && branch.visible ? control.close()
                            : control.open(index)
                    else
                        control.trigger(entry.index === undefined ? index : entry.index, entry)
                }

                Private.MenuBranch {
                    id: branch

                    owner: control
                    y: menuButton.height
                    model: menuButton.entry.children

                    onClosed: {
                        if (control.activeIndex === index)
                            control.activeIndex = -1
                    }
                }
            }
        }
    }

    onModelChanged: close()
    onEnabledChanged: {
        if (!enabled)
            close()
    }
}

import QtQuick 2.15
import QtQuick.Window 2.15

FocusScope {
    id: control
    default property alias content: body.data

    property bool active: true

    function focusNext(reverse) {
        if (!active || !enabled)
            return false
        const items = []
        function visit(item) {
            if (!item.visible || !item.enabled)
                return
            if (item.activeFocusOnTab) {
                items.push(item)
                return
            }
            for (let index = 0; index < item.children.length; ++index)
                visit(item.children[index])
        }
        for (let child = 0; child < control.children.length; ++child)
            visit(control.children[child])
        if (!items.length)
            return false
        let index = -1
        for (let position = 0; position < items.length; ++position)
            if (items[position].activeFocus)
                index = position
        const next = index < 0 ? reverse ? items.length - 1 : 0
            : (index + (reverse ? -1 : 1) + items.length) % items.length
        items[next].forceActiveFocus(reverse ? Qt.BacktabFocusReason : Qt.TabFocusReason)
        return true
    }

    implicitWidth: body.childrenRect.width
    implicitHeight: body.childrenRect.height

    Item {
        id: body

        anchors.fill: parent
    }
    Shortcut {
        sequence: "Tab"
        enabled: control.active && control.enabled && control.activeFocus

        onActivated: control.focusNext(false)
    }
    Shortcut {
        sequence: "Shift+Tab"
        enabled: control.active && control.enabled && control.activeFocus

        onActivated: control.focusNext(true)
    }
}

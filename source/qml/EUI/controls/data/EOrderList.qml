import EUI 1.0
import QtQuick 2.15
import QtQml 2.15

Item {
    id: control

    property var model: []
    property var values: []
    property bool filterable: false
    property string labelKey: "label"
    property string valueKey: "value"
    property Component itemDelegate: null

    readonly property alias view: selection.view

    signal changed(var model)
    signal selectionChanged(var values)

    function moveItem(from, to) {
        if (!enabled || !EDataUtils.isArray(model) || from < 0 || to < 0 || from >= model.length || to >= model.length
            || from === to || Math.floor(from) !== from || Math.floor(to) !== to
            || model[from] && model[from].disabled || model[to] && model[to].disabled)
            return false
        const items = model.slice()
        items.splice(to, 0, items.splice(from, 1)[0])
        model = items
        changed(model)
        return true
    }

    function moveSelected(direction) {
        if (!enabled || !EDataUtils.isArray(model) || !EDataUtils.isArray(values)
            || ["up", "down", "top", "bottom"].indexOf(direction) < 0)
            return false
        const items = model.slice()
        function selected(item, index) {
            const key = item && typeof item === "object" ? item[control.valueKey] === undefined
                ? item : item[control.valueKey] : item
            return values.indexOf(key) >= 0 && !(item && item.disabled)
        }
        if (direction === "top" || direction === "bottom") {
            const picked = items.filter(selected)
            if (!picked.length || items.some(function(item) { return item && item.disabled }))
                return false
            const rest = items.filter(function(item, index) { return !selected(item, index) })
            model = direction === "top" ? picked.concat(rest) : rest.concat(picked)
        } else {
            const down = direction === "down"
            for (let index = down ? items.length - 2 : 1; down ? index >= 0 : index < items.length; index += down ? -1 : 1) {
                const next = index + (down ? 1 : -1)
                if (selected(items[index], index) && !selected(items[next], next) && !(items[next] && items[next].disabled)) {
                    const swap = items[next]
                    items[next] = items[index]
                    items[index] = swap
                }
            }
            model = items
        }
        changed(model)
        return true
    }

    implicitWidth: 340
    implicitHeight: 280

    EListbox {
        id: selection

        multiple: true
        reorderable: true
        model: control.model
        height: parent.height
        values: control.values
        labelKey: control.labelKey
        valueKey: control.valueKey
        filterable: control.filterable
        itemDelegate: control.itemDelegate
        width: Math.max(0, parent.width - 48)

        onReorderRequested: function(from, to) { control.moveItem(from, to) }
        onChanged: function(value) {
            control.values = selection.values
            control.selectionChanged(selection.values)
        }
    }
    Column {
        width: 40
        spacing: 6
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        Repeater {
            model: ["top", "up", "down", "bottom"]

            EButton {
                width: 36
                height: 36
                iconSize: 18
                minHeight: 36
                Accessible.name: modelData
                enabled: EDataUtils.isArray(control.values) && control.values.length > 0
                iconSource: [EIcons.ARROW_UP_TO_LINE, EIcons.ARROW_UP, EIcons.ARROW_DOWN, EIcons.ARROW_DOWN_TO_LINE][index]

                onClicked: control.moveSelected(modelData)
            }
        }
    }
}

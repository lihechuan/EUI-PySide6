import EUI 1.0
import EUI.Private 1.0
import "../private" as PrivateControls
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control

    property var data: []
    property var value: []
    property bool draggable: false
    property bool filterable: true
    property var filterMethod: null
    property bool reorderable: false
    property bool validateEvent: true
    property Component leftFooter: null
    property Component rightFooter: null
    property Component optionDelegate: null
    property string targetOrder: "original"
    property var props: ({key: "key", label: "label", disabled: "disabled"})
    property string leftTitle: EControlConfig.textFor(control, "AvailableItems", ELocale.texts)
    property string rightTitle: EControlConfig.textFor(control, "SelectedItems", ELocale.texts)

    readonly property var selectedKeys: {
        const keys = Object.create(null)
        for (let index = 0; index < value.length; ++index)
            keys[keyId(value[index])] = true
        return keys
    }
    readonly property var effectiveData: EDataUtils.isArray(data)
        ? data.filter(function(item) {
            return item && typeof item === "object"
        }).map(function(item) {
            return { key: item[props.key || "key"], label: item[props.label || "label"],
                disabled: Boolean(item[props.disabled || "disabled"]), raw: item }
        }) : []
    readonly property var targetData: {
        const items = effectiveData.filter(function(item) {
            return Boolean(control.selectedKeys[control.keyId(item.key)])
        })
        return targetOrder === "original" ? items : items.sort(function(left, right) {
            return control.value.indexOf(left.key) - control.value.indexOf(right.key)
        })
    }

    signal changed(var value)
    signal reordered(bool right)
    signal moved(var value, string direction, var keys)

    function keyId(key) {
        return typeof key + ":" + String(key)
    }

    function checkKey(key, checked, right) {
        const keys = (right ? internal.rightChecked : internal.leftChecked).slice(0)
        const position = keys.indexOf(key)
        if (checked && position < 0)
            keys.push(key)
        else if (!checked && position >= 0)
            keys.splice(position, 1)
        if (right)
            internal.rightChecked = keys
        else
            internal.leftChecked = keys
    }

    function finishDrag(right, key, x, y) {
        if (!enabled || !draggable)
            return false
        const source = right ? targetPanel : sourcePanel
        const target = right ? sourcePanel : targetPanel
        const position = source.mapToItem(target, x, y)
        if (position.x >= 0 && position.x <= target.width && position.y >= 0 && position.y <= target.height)
            return move([key], !right)
        return false
    }

    function moveSelection(right, delta) {
        if (!enabled || !reorderable || (delta !== -1 && delta !== 1))
            return false
        const items = right ? targetData : effectiveData.filter(function(item) {
            return !control.selectedKeys[control.keyId(item.key)]
        })
        const keys = right ? internal.rightChecked : internal.leftChecked
        let moved = false
        for (let index = delta > 0 ? items.length - 2 : 1; delta > 0 ? index >= 0 : index < items.length;
            index += delta > 0 ? -1 : 1) {
            const next = index + delta
            if (keys.indexOf(items[index].key) >= 0 && keys.indexOf(items[next].key) < 0
                && reorder(right, index, next)) {
                const item = items[index]
                items[index] = items[next]
                items[next] = item
                moved = true
            }
        }
        return moved
    }

    function reorder(right, from, to) {
        const items = right ? targetData : effectiveData.filter(function(item) {
            return !control.selectedKeys[control.keyId(item.key)]
        })
        if (!enabled || !reorderable || from < 0 || to < 0 || from >= items.length || to >= items.length
            || Math.floor(from) !== from || Math.floor(to) !== to
            || items[from].disabled || items[to].disabled || from === to)
            return false
        const order = items.slice()
        order.splice(to, 0, order.splice(from, 1)[0])
        if (right) {
            targetOrder = "push"
            value = order.map(function(item) { return item.key })
            changed(value)
        } else {
            const keys = order.map(function(item) { return item.key })
            const positions = data.map(function(item, index) {
                return keys.indexOf(item[props.key || "key"]) >= 0 ? index : -1
            }).filter(function(index) { return index >= 0 })
            const updated = data.slice()
            positions.forEach(function(position, index) { updated[position] = order[index].raw })
            data = updated
        }
        reordered(right)
        return true
    }

    function move(keys, toRight) {
        if (!enabled || !EDataUtils.isArray(keys))
            return false
        const allowed = Object.create(null)
        const chosen = Object.create(null)
        const moving = Object.create(null)
        const result = []
        for (let index = 0; index < effectiveData.length; ++index)
            if (!effectiveData[index].disabled)
                allowed[keyId(effectiveData[index].key)] = true
        for (let index = 0; index < keys.length; ++index)
            if (allowed[keyId(keys[index])])
                moving[keyId(keys[index])] = true
        for (let index = 0; index < value.length; ++index) {
            const key = value[index]
            if (!toRight && moving[keyId(key)])
                continue
            chosen[keyId(key)] = true
            result.push(key)
        }
        for (let index = 0; index < keys.length; ++index) {
            const key = keys[index]
            if (toRight && moving[keyId(key)] && !chosen[keyId(key)]) {
                result.push(key)
                chosen[keyId(key)] = true
            }
        }
        if (toRight && targetOrder === "unshift") {
            const fresh = result.filter(function(key) {
                return control.value.indexOf(key) < 0
            })
            value = fresh.concat(result.filter(function(key) {
                return control.value.indexOf(key) >= 0
            }))
        } else value = result
        moved(value, toRight ? "right" : "left", keys.filter(function(key) {
            return Boolean(moving[control.keyId(key)])
        }))
        internal.leftChecked = []
        internal.rightChecked = []
        changed(value)
        return true
    }

    implicitWidth: 520
    implicitHeight: 280
    contentItem: Row {
        spacing: 12

        PrivateControls.TransferPanel {
            id: sourcePanel

            title: control.leftTitle
            draggable: control.draggable
            filterable: control.filterable
            height: control.availableHeight
            reorderable: control.reorderable
            checkedKeys: internal.leftChecked
            filterMethod: control.filterMethod
            footerComponent: control.leftFooter
            optionDelegate: control.optionDelegate
            width: Math.max(0, (control.availableWidth - 72) / 2)
            model: control.effectiveData.filter(function(item) {
                return !control.selectedKeys[control.keyId(item.key)]
            })

            onToggled: control.checkKey(key, checked, false)
            onMoveSelection: function(delta) { control.moveSelection(false, delta) }
            onDragFinished: function(key, x, y) { control.finishDrag(false, key, x, y) }
            onAllToggled: function(keys, checked) {
                keys.forEach(function(key) {
                    control.checkKey(key, checked, false)
                })
            }
        }
        Column {
            width: 48
            spacing: 12
            anchors.verticalCenter: parent.verticalCenter

            EButton {
                width: parent.width
                iconSource: EIcons.CHEVRON_RIGHT
                enabled: internal.leftChecked.length > 0

                onClicked: control.move(internal.leftChecked, true)
            }
            EButton {
                width: parent.width
                iconSource: EIcons.CHEVRON_LEFT
                enabled: internal.rightChecked.length > 0

                onClicked: control.move(internal.rightChecked, false)
            }
        }
        PrivateControls.TransferPanel {
            id: targetPanel

            model: control.targetData
            title: control.rightTitle
            draggable: control.draggable
            filterable: control.filterable
            height: control.availableHeight
            reorderable: control.reorderable
            checkedKeys: internal.rightChecked
            filterMethod: control.filterMethod
            footerComponent: control.rightFooter
            optionDelegate: control.optionDelegate
            width: Math.max(0, (control.availableWidth - 72) / 2)

            onToggled: control.checkKey(key, checked, true)
            onMoveSelection: function(delta) { control.moveSelection(true, delta) }
            onDragFinished: function(key, x, y) { control.finishDrag(true, key, x, y) }
            onAllToggled: function(keys, checked) {
                keys.forEach(function(key) {
                    control.checkKey(key, checked, true)
                })
            }
        }
    }

    onValueChanged: if (!EDataUtils.isArray(value))
        value = []

    QtObject {
        id: internal

        property var leftChecked: []
        property var rightChecked: []
    }
}

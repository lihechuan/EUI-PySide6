import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control

    property var value
    property var model: []
    property var props: ({})
    property bool block: false
    property int currentIndex: 0
    property bool validateEvent: true
    property string direction: "horizontal"
    property Component optionDelegate: null
    property int size: EControlConfig.sizeFor(control)

    readonly property var currentValue: itemValue(currentItem)
    readonly property var currentItem: EDataUtils.isArray(model)
        && currentIndex >= 0
        && currentIndex < model.length
        ? model[currentIndex] : null

    signal selected(var value, int index)

    function itemValue(item) {
        return item && typeof item === "object" ? item[props.value || "value"] : item
    }

    function itemDisabled(item) {
        return item && typeof item === "object" && !!item[props.disabled || "disabled"]
    }

    function selectValue(key) {
        if (!EDataUtils.isArray(model))
            return false
        return select(model.findIndex(function(item) {
            return itemValue(item) === key
        }))
    }

    function itemLabel(item) {
        if (item === null || item === undefined)
            return ""
        if (typeof item !== "object")
            return String(item)
        const label = item[props.label || "label"]
        return String(label === undefined ? itemValue(item) : label)
    }

    function select(index) {
        if (!enabled || !EDataUtils.isArray(model) || !isFinite(index) || Math.floor(index) !== Number(index)
                || index < 0 || index >= model.length || itemDisabled(model[index]))
            return false
        currentIndex = index
        value = currentValue
        selected(currentValue, index)
        return true
    }

    function moveSelection(offset) {
        if (!EDataUtils.isArray(model) || model.length === 0)
            return false
        for (let step = 1; step <= model.length; ++step) {
            const index = (currentIndex + offset * step + model.length * (step + 1)) % model.length
            if (!itemDisabled(model[index]))
                return select(index)
        }
        return false
    }

    padding: 3
    activeFocusOnTab: true
    implicitWidth: segments.implicitWidth + 6
    implicitHeight: segments.implicitHeight + 6
    background: ERectangle {
        radius: 4
        color: EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)
    }
    contentItem: Grid {
        id: segments

        spacing: 3
        columns: control.direction === "vertical" ? 1
            : Math.max(1, EDataUtils.isArray(control.model) ? control.model.length : 1)

        Repeater {
            model: EDataUtils.isArray(control.model) ? control.model : []

            ETextButton {
                id: segment

                readonly property bool selected: index === control.currentIndex

                size: control.size
                text: control.itemLabel(modelData)
                enabled: !control.itemDisabled(modelData)
                height: EDefaultConfig.controlHeight(size)
                background: ERectangle {
                    radius: 3
                    color: segment.selected ? EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
                        : EPaletteManager.BasePalette.transparent
                }
                width: control.block ? control.direction === "vertical" ? control.availableWidth
                    : Math.max(
                        0,
                        (control.availableWidth - segments.spacing * (segments.columns - 1)) / segments.columns
                    )
                    : implicitWidth
                contentItem: Item {
                    implicitWidth: customSlot.active ? customSlot.implicitWidth : label.implicitWidth
                    implicitHeight: customSlot.active ? customSlot.implicitHeight : label.implicitHeight

                    EText {
                        id: label

                        font: segment.font
                        text: segment.text
                        anchors.fill: parent
                        elide: Text.ElideRight
                        visible: !customSlot.active
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        color: EPaletteManager.StatePalette.computeTextColor(
                            EPaletteManager.createStateObject(this, EStyle.Color)
                                .setDark(ETheme.dark)
                                .setPlain(true)
                                .setIsFound(segment.selected)
                                .setEnabled(segment.enabled)
                                .setHovered(segment.hovered && !segment.selected)
                                .setComponentStyle(EStyle.Primary)

                        )
                    }
                    Loader {
                        id: customSlot

                        property var option: modelData
                        property bool selected: segment.selected

                        anchors.fill: parent
                        active: sourceComponent !== null
                        sourceComponent: control.optionDelegate
                    }
                }

                onClicked: control.select(index)
            }
        }
    }

    Keys.onUpPressed: moveSelection(-1)
    Keys.onDownPressed: moveSelection(1)
    Keys.onLeftPressed: moveSelection(-1)
    Keys.onRightPressed: moveSelection(1)
    onValueChanged: {
        if (value !== undefined && EDataUtils.isArray(model)) {
            const index = model.findIndex(function(item) {
                return itemValue(item) === value
            })
            if (index >= 0 && !itemDisabled(model[index]))
                currentIndex = index
        }
    }
    onModelChanged: {
        if (!EDataUtils.isArray(model)
            || currentIndex < 0
            || currentIndex >= model.length
            || itemDisabled(model[currentIndex]))
            currentIndex = EDataUtils.isArray(model) ? model.findIndex(function(item) {
                return !itemDisabled(item)
            }) : -1
    }
}

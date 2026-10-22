import EUI 1.0
import EUI.Private 1.0
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control

    property var model: []
    property var values: []
    property var value: null
    property bool multiple: false
    property bool filterable: false
    property bool reorderable: false
    property string labelKey: "label"
    property string valueKey: "value"
    property Component itemDelegate: null
    property alias filterText: search.text

    readonly property alias view: list
    readonly property var items: EDataUtils.isArray(model) ? model.map(function(item, index) {
        const object = item && typeof item === "object"
        return {raw: item, index: index, label: String(object ? item[labelKey] === undefined ? "" : item[labelKey] : item),
            value: object ? item[valueKey] === undefined ? item : item[valueKey] : item,
            disabled: !!(object && item.disabled)}
    }).filter(function(item) {
        return item.label.toLowerCase().indexOf(search.text.toLowerCase()) >= 0
    }) : []

    signal changed(var value)
    signal itemClicked(var item, int index)
    signal reorderRequested(int from, int to)

    function isSelected(option) {
        return multiple ? EDataUtils.isArray(values) && values.indexOf(option.value) >= 0 : value === option.value
    }

    function navigate(delta) {
        if (!enabled || !items.length || delta !== 1 && delta !== -1)
            return false
        const start = list.currentIndex < 0 && delta < 0 ? 0 : list.currentIndex
        for (let offset = 1; offset <= items.length; ++offset) {
            const next = (start + delta * offset + items.length * 2) % items.length
            if (!items[next].disabled) {
                list.currentIndex = next
                list.positionViewAtIndex(next, ListView.Contain)
                return true
            }
        }
        return false
    }

    function select(index) {
        if (!enabled || index < 0 || index >= items.length || Math.floor(index) !== index || items[index].disabled)
            return false
        const option = items[index]
        if (multiple) {
            const selected = EDataUtils.isArray(values) ? values.slice() : []
            const position = selected.indexOf(option.value)
            if (position >= 0)
                selected.splice(position, 1)
            else
                selected.push(option.value)
            values = selected
            changed(values)
        } else {
            value = option.value
            changed(value)
        }
        list.currentIndex = index
        itemClicked(option.raw, option.index)
        return true
    }

    padding: 8
    implicitWidth: 260
    implicitHeight: 240
    activeFocusOnTab: true
    focusPolicy: Qt.StrongFocus
    Accessible.role: Accessible.List
    background: ERectangle {
        radius: 6
        border.width: 1
        color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
        border.color: control.activeFocus
            ? EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
            : EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
    }

    Keys.onUpPressed: navigate(-1)
    Keys.onDownPressed: navigate(1)
    Keys.onEnterPressed: select(list.currentIndex)
    Keys.onSpacePressed: select(list.currentIndex)
    Keys.onReturnPressed: select(list.currentIndex)

    EInput {
        id: search

        clearable: true
        x: control.padding
        y: control.padding
        visible: control.filterable
        prefixIcon: EIcons.MAGNIFIER
        placeholderText: ELocale.texts.Search2
        width: Math.max(0, control.width - x * 2)
    }
    ListView {
        id: list

        clip: true
        spacing: 4
        currentIndex: -1
        x: control.padding
        model: control.items
        width: control.availableWidth
        ScrollBar.vertical: ScrollHandle {}
        height: Math.max(0, control.height - y - control.padding)
        y: control.filterable ? search.y + search.height + 8 : control.padding
        delegate: ETextButton {
            id: option

            property var entry: modelData

            readonly property bool selected: control.isSelected(entry)
            readonly property color accent: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)

            minHeight: 40
            leftPadding: 12
            font.bold: false
            rightPadding: 12
            text: entry.label
            width: list.width
            Accessible.name: text
            enabled: !entry.disabled
            Accessible.role: Accessible.ListItem
            Accessible.selected: control.isSelected(entry)
            background: ERectangle {
                radius: 4
                border.color: option.accent
                border.width: option.visualFocus || control.activeFocus && list.currentIndex === index ? 1 : 0
                color: option.selected
                    ? Qt.rgba(option.accent.r, option.accent.g, option.accent.b, ETheme.dark ? 0.2 : 0.1)
                    : option.hovered ? EPaletteManager.ThemePalette.surfaceHover(ETheme.dark) : "transparent"
            }
            contentItem: Row {
                spacing: 10
                visible: !control.itemDelegate

                ECheckBox {
                    width: 18
                    height: 20
                    optSize: 16
                    leftPadding: 0
                    rightPadding: 0
                    borderVisible: false
                    focusPolicy: Qt.NoFocus
                    checked: option.selected
                    visible: control.multiple
                    anchors.verticalCenter: parent.verticalCenter

                    onClicked: {
                        control.forceActiveFocus()
                        control.select(index)
                        checked = Qt.binding(function() { return option.selected })
                    }
                }
                EText {
                    font: option.font
                    text: option.text
                    height: parent.height
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                    width: Math.max(0, parent.width - x - (control.reorderable ? 24 : 0))
                    color: !option.enabled ? EPaletteManager.ThemePalette.textDisabled(ETheme.dark)
                        : option.selected ? option.accent : EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                }
                EIcon {
                    iconSize: 16
                    iconSource: EIcons.GRIP
                    visible: control.reorderable
                    anchors.verticalCenter: parent.verticalCenter
                    color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
                }
            }

            onClicked: {
                control.forceActiveFocus()
                control.select(index)
            }

            Loader {
                readonly property var optionData: option.entry.raw
                readonly property bool selected: control.isSelected(option.entry)

                anchors.fill: parent
                sourceComponent: control.itemDelegate
            }
            DragGesture {
                anchors.fill: parent
                enabled: control.reorderable && !option.entry.disabled

                onTapped: {
                    control.forceActiveFocus()
                    control.select(index)
                }
                onDropped: function(x, y) {
                    const position = mapToItem(list.contentItem, x, y)
                    const destination = list.indexAt(position.x, position.y)
                    if (destination >= 0 && destination !== index)
                        control.reorderRequested(option.entry.index, control.items[destination].index)
                }
            }
        }

        EText {
            anchors.centerIn: parent
            text: ELocale.texts.NoOptions
            visible: control.items.length === 0
            color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
        }
    }
}

import EUI 1.0
import EUI.Private 1.0
import "." as FormControls
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

ComboBox {
    id: control

    property var value
    property string query: ""
    property int debounce: 300
    property bool remote: false
    property bool loading: false
    property bool multiple: false
    property int multipleLimit: 0
    property bool clearable: false
    property string indentRole: ""
    property var filterMethod: null
    property bool filterable: false
    property int maxCollapseTags: 1
    property var remoteMethod: null
    property bool allowCreate: false
    property bool collapseTags: false
    property bool validateEvent: true
    property string valueKey: "value"
    property bool reserveKeyword: true
    property Component popupFooter: null
    property Component popupHeader: null
    property Component tagDelegate: null
    property string validationMessage: ""
    property Component optionDelegate: null
    property int size: EControlConfig.sizeFor(control)
    property int validationState: EValidationState.None
    property string loadingText: EControlConfig.textFor(control, "Loading", ELocale.texts)
    property var valueOnClear: EControlConfig.valueFor(control, "valueOnClear", undefined)
    property string noDataText: EControlConfig.textFor(control, "NoOptions", ELocale.texts)
    property var emptyValues: EControlConfig.valueFor(control, "emptyValues", [undefined, null, ""])
    property string noMatchText: EControlConfig.textFor(control, "NoMatchingResults2", ELocale.texts)
    property string placeholderText: EControlConfig.textFor(control, "SelectAnOption", ELocale.texts)

    readonly property var sourceOptions: normalizedOptions()
    readonly property var selectedValues: multiple && EDataUtils.isArray(value) ? value : []
    readonly property bool hasValidationError: validationState === EValidationState.Error
    readonly property bool empty: multiple ? selectedValues.length === 0 : isEmptyValue(value)
    readonly property bool advanced: multiple || filterable || remote || grouped || optionDelegate !== null
    readonly property bool grouped: EDataUtils.isArray(model) && model.some(function(item) {
        return item && EDataUtils.isArray(item.options)
    })
    readonly property var visibleOptions: {
        const result = sourceOptions.filter(function(option) {
            if (option.group || remote || !filterable || !query)
                return true
            return typeof filterMethod === "function" ? filterMethod(query, option.raw)
                : option.label.toLowerCase().indexOf(query.toLowerCase()) >= 0
        })
        if (filterable && allowCreate && query.trim().length > 0
                && !sourceOptions.some(function(option) {
                    return option.label === query.trim()
                }))
            result.unshift({ label: query.trim(), value: query.trim(), disabled: false, created: true })
        return result.filter(function(option, index) {
            if (!option.group)
                return true
            return index + 1 < result.length && !result[index + 1].group
        })
    }

    signal cleared()
    signal changed(var value)
    signal removedTag(var value)
    signal searchFailed(string message)

    function isEmptyValue(key) {
        return EDataUtils.isArray(emptyValues) && emptyValues.some(function(item) {
            return valuesEqual(item, key)
        })
    }

    function isSelected(key) {
        return multiple ? selectedValues.some(function(item) {
            return valuesEqual(item, key)
        })
            : valuesEqual(value, key)
    }

    function clear() {
        currentIndex = -1
        value = multiple ? [] : typeof valueOnClear === "function" ? valueOnClear() : valueOnClear
        query = ""
        cleared()
        changed(value)
    }

    function labelFor(key) {
        const item = sourceOptions.find(function(option) {
            return !option.group && valuesEqual(option.value, key)
        })
        return item ? item.label : String(key === undefined || key === null ? "" : key)
    }

    function valuesEqual(left, right) {
        if (left === right)
            return true
        return left && right && typeof left === "object" && typeof right === "object"
            && left[valueKey] !== undefined && left[valueKey] === right[valueKey]
    }

    function chooseHighlighted() {
        if (optionList.currentIndex < 0)
            highlightOption(1)
        const option = visibleOptions[optionList.currentIndex]
        return option && !option.group && !option.disabled ? selectValue(option.value) : false
    }

    function removeValue(key) {
        if (!enabled || !multiple)
            return false
        const values = selectedValues.filter(function(item) {
            return !valuesEqual(item, key)
        })
        if (values.length === selectedValues.length)
            return false
        value = values
        removedTag(key)
        changed(value)
        return true
    }

    function highlightOption(direction) {
        const options = visibleOptions
        let next = optionList.currentIndex + direction
        if (direction > 0 && optionList.currentIndex < 0)
            next = 0
        while (next >= 0 && next < options.length) {
            if (!options[next].group && !options[next].disabled) {
                optionList.currentIndex = next
                optionList.positionViewAtIndex(next, ListView.Contain)
                return true
            }
            next += direction
        }
        return false
    }

    function requestRemote() {
        if (!remote || typeof remoteMethod !== "function")
            return
        const revision = ++internal.remoteRevision
        loading = true
        function finish(options, error) {
            if (revision !== internal.remoteRevision)
                return
            loading = false
            if (EDataUtils.isArray(options))
                control.model = options
            if (error)
                searchFailed(String(error))
        }
        try {
            const result = remoteMethod(query)
            if (result && typeof result.then === "function")
                result.then(function(options) {
                    finish(options, "")
                }, function(error) {
                    finish(null, error)
                })
            else
                finish(result, "")
        } catch (error) { finish(null, error) }
    }

    function selectValue(key) {
        if (!enabled || loading)
            return false
        const option = sourceOptions.find(function(item) {
            return !item.group && valuesEqual(item.value, key)
        })
        if (!option && !(filterable && allowCreate && String(key) === query.trim()))
            return false
        if (option && option.disabled)
            return false
        if (multiple) {
            if (isSelected(key))
                return removeValue(key)
            if (multipleLimit > 0 && selectedValues.length >= multipleLimit)
                return false
            value = selectedValues.concat([key])
        } else {
            value = key
            if (!grouped)
                currentIndex = indexOfValue(key)
            popup.close()
        }
        if (!reserveKeyword)
            query = ""
        changed(value)
        return true
    }

    function normalizedOptions() {
        const result = []
        const source = EDataUtils.isArray(model) ? model : null
        function append(item, inheritedDisabled, sourceIndex, ancestors) {
            if (item === undefined || item === null || ancestors && ancestors.indexOf(item) >= 0)
                return
            if (typeof item === "object" && EDataUtils.isArray(item.options)) {
                result.push({ label: String(item.label || ""), group: true, disabled: true })
                for (let index = 0; index < item.options.length; ++index)
                    append(item.options[index], inheritedDisabled
                        || item.disabled, -1, (ancestors || []).concat([item]))
                return
            }
            const object = typeof item === "object"
            const label = object ? item[textRole || "label"] : item
            const key = object ? (valueRole ? item[valueRole] : item) : item
            if (label === undefined)
                return
            result.push({ label: String(label), value: key, raw: item,
                disabled: Boolean(inheritedDisabled || (object && item.disabled)), sourceIndex: sourceIndex })
        }
        if (source) {
            for (let index = 0; index < source.length; ++index)
                append(source[index], false, index)
        } else {
            for (let index = 0; index < count; ++index)
                append(model && typeof model.get === "function" ? model.get(index)
                    : { label: textAt(index), value: valueAt(index) }, false, index)
        }
        return result
    }

    currentIndex: -1
    hoverEnabled: true
    implicitWidth: 200
    Accessible.description: validationMessage
    leftPadding: EDefaultConfig.horizontalPadding(size)
    rightPadding: EDefaultConfig.horizontalPadding(size) + 28
    Accessible.name: currentIndex < 0 ? placeholderText : currentText
    font.pixelSize: EDefaultConfig.controlFontPixelSize(control.size)
    implicitHeight: Math.max(EDefaultConfig.controlHeight(control.size), multiple ? tags.implicitHeight + 12
        : 0)
    background: FieldSurface {
        hovered: control.hovered
        validationState: control.validationState
        focused: control.activeFocus || control.popup.visible
    }
    delegate: OptionDelegate {
        size: control.size
        text: control.textAt(index)
        selected: control.currentIndex === index
        highlighted: control.highlightedIndex === index
        width: ListView.view ? ListView.view.width : control.width
        enabled: !(typeof modelData !== "undefined" && modelData && modelData.disabled)
        leftPadding: EDefaultConfig.horizontalPadding(control.size) + 8
            + (control.indentRole && typeof modelData !== "undefined" && modelData
            ? Math.max(0, Number(modelData[control.indentRole]) || 0) * 16 : 0)
    }
    indicator: EIcon {
        width: 16
        height: 16
        iconSize: 14
        y: (control.height - height) / 2
        x: control.width - width - control.leftPadding
        rotation: control.popup.visible && iconSource === EIcons.CHEVRON_DOWN ? 180 : 0
        iconSource: control.clearable && !control.empty && control.hovered
            ? EIcons.CIRCLE_XMARK : EIcons.CHEVRON_DOWN
        color: control.enabled ? EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
            : EPaletteManager.ThemePalette.textDisabled(ETheme.dark)

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            enabled: control.enabled && control.clearable && !control.empty

            onClicked: control.clear()
        }
    }
    contentItem: Item {
        EText {
            font: control.font
            anchors.fill: parent
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            visible: !control.multiple || control.selectedValues.length === 0
            text: control.multiple || control.currentIndex < 0
                ? (control.advanced && !control.empty && !control.multiple
                    ? control.labelFor(control.value) : control.placeholderText) : control.displayText
            color: !control.enabled ? EPaletteManager.ThemePalette.textDisabled(ETheme.dark)
                : control.empty
                    ? EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
                    : EPaletteManager.ThemePalette.textRegular(ETheme.dark)
        }
        Flow {
            id: tags

            spacing: 4
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            visible: control.multiple && control.selectedValues.length > 0

            Repeater {
                model: control.collapseTags
                    ? control.selectedValues.slice(0, Math.max(1, control.maxCollapseTags))
                    : control.selectedValues
                delegate: Loader {
                    readonly property var key: modelData
                    readonly property string label: control.labelFor(key)
                    readonly property real contentWidth: item ? item.implicitWidth : 0
                    readonly property real contentHeight: item ? item.implicitHeight : 0

                    function remove() {
                        return control.removeValue(key)
                    }

                    height: contentHeight
                    width: Math.min(contentWidth, tags.width)
                    sourceComponent: control.tagDelegate || standardTag
                }
            }
            ETag {
                size: EStyle.Small
                text: "+" + Math.max(0, control.selectedValues.length - Math.max(1, control.maxCollapseTags))
                visible: control.collapseTags
                    && control.selectedValues.length > Math.max(1, control.maxCollapseTags)
            }
        }
    }
    popup: PickerPopup {
        padding: 0
        topPadding: 6
        bottomPadding: 6
        width: control.width
        implicitHeight: popupColumn.implicitHeight + 12
        contentItem: Column {
            id: popupColumn

            spacing: 6

            Loader {
                width: parent.width
                active: control.popupHeader !== null
                sourceComponent: control.popupHeader
            }
            FormControls.EInput {
                id: searchInput

                text: control.query
                width: parent.width
                visible: control.filterable
                objectName: "selectSearchInput"
                placeholderText: control.placeholderText

                onTextEdited: control.query = text
                Keys.onPressed: function(event) {
                    if (event.key === Qt.Key_Down) {
                        control.highlightOption(1)
                        event.accepted = true
                    } else if (event.key === Qt.Key_Up) {
                        control.highlightOption(-1)
                        event.accepted = true
                    } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        control.chooseHighlighted()
                        event.accepted = true
                    }
                }
            }
            ListView {
                id: optionList

                clip: true
                width: parent.width
                objectName: "selectOptionList"
                ScrollBar.vertical: ScrollHandle {}
                height: Math.min(Math.max(40, contentHeight), 228)
                currentIndex: control.advanced ? -1 : control.highlightedIndex
                model: control.popup.visible ? control.visibleOptions : null
                delegate: control.advanced ? advancedLoader : basicOption

                EText {
                    anchors.centerIn: parent
                    visible: control.loading || optionList.count === 0
                    color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
                    text: control.loading ? control.loadingText
                        : control.query.length > 0 ? control.noMatchText : control.noDataText
                }
            }
            Loader {
                width: parent.width
                active: control.popupFooter !== null
                sourceComponent: control.popupFooter
            }
        }

        onOpened: if (control.filterable)
            searchInput.forceActiveFocus()
    }

    onEnabledChanged: if (!enabled)
        popup.close()
    onMultipleChanged: if (internal.completed)
        value = multiple ? [] : undefined
    onQueryChanged: {
        ++internal.remoteRevision
        if (remote)
            remoteTimer.restart()
    }
    onCurrentValueChanged: {
        if (internal.completed && !multiple && !grouped && (!advanced || currentIndex >= 0))
            value = currentIndex < 0 ? undefined : currentValue
    }
    onValueChanged: {
        if (multiple && !EDataUtils.isArray(value))
            value = []
        else if (internal.completed && !multiple && !grouped && !valuesEqual(value, currentValue))
            currentIndex = indexOfValue(value)
    }
    Component.onCompleted: {
        internal.completed = true
        if (multiple) {
            if (!EDataUtils.isArray(value))
                value = []
        } else if (value !== undefined && !grouped)
            currentIndex = indexOfValue(value)
        else
            value = currentIndex < 0 ? undefined : currentValue
    }

    Timer {
        id: remoteTimer

        interval: Math.max(0, control.debounce)

        onTriggered: control.requestRemote()
    }
    Component {
        id: basicOption

        OptionDelegate {
            readonly property var option: modelData

            size: control.size
            text: option.label
            width: optionList.width
            selected: control.isSelected(option.value)
            enabled: control.enabled && !control.loading && !option.disabled

            onClicked: control.selectValue(option.value)
        }
    }
    Component {
        id: advancedLoader

        Loader {
            readonly property var option: modelData
            readonly property bool selected: control.isSelected(option.value)

            width: optionList.width
            sourceComponent: control.optionDelegate || advancedOption
            height: item ? item.implicitHeight : EDefaultConfig.controlHeight(control.size)
        }
    }
    Component {
        id: advancedOption

        OptionDelegate {
            readonly property var option: parent.option

            size: control.size
            text: option.label
            width: parent.width
            selected: parent.selected
            enabled: control.enabled && !control.loading && !option.disabled && !option.group
            leftPadding: EDefaultConfig.horizontalPadding(control.size) + 8
                + (control.indentRole && option.raw
                    ? Math.max(0, Number(option.raw[control.indentRole]) || 0) * 16
                    : 0)

            onClicked: control.selectValue(option.value)
        }
    }
    QtObject {
        id: internal

        property bool completed: false
        property int remoteRevision: 0
    }
    Component {
        id: standardTag

        ETag {
            size: EStyle.Small
            text: parent.label
            closable: control.enabled

            onClosed: parent.remove()
        }
    }
}

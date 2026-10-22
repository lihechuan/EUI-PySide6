import EUI 1.0
import EUI.Private 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

EInput {
    id: control

    property int offset: 0
    property var options: []
    property var prefix: "@"
    property int popupWidth: 0
    property string split: " "
    property bool whole: false
    property bool loading: false
    property string type: "input"
    property bool showArrow: false
    property var checkIsWhole: null
    property var filterOption: null
    property int popupMaxHeight: 220
    property bool fitInputWidth: true
    property string placement: "bottom"
    property Component labelDelegate: null
    property Component footerDelegate: null
    property Component headerDelegate: null
    property Component loadingDelegate: null
    property var props: ({value: "value", label: "label", disabled: "disabled"})

    readonly property var input: editor
    readonly property var tooltip: mentionPopup
    readonly property var token: tokenAtCursor()
    readonly property string activePrefix: token.prefix
    readonly property int mentionPosition: token.position
    readonly property bool dropdownVisible: mentionPopup.visible
    readonly property var editor: type === "textarea" && multiline.item ? multiline.item : control
    readonly property var matches: {
        if (mentionPosition < 0 || !activePrefix || !EDataUtils.isArray(options))
            return []
        const query = text.slice(mentionPosition + activePrefix.length, cursorPosition)
        if (/\s/.test(query))
            return []
        return options.filter(function(item) {
            if (!item
                || (typeof item !== "string"
                    && (item[props.disabled || "disabled"]
                        || item[props.label || "label"] === undefined
                            && item[props.value || "value"] === undefined)))
                return false
            return filterOption === false || (typeof filterOption === "function" ? filterOption(query, item)
                : optionLabel(item).toLowerCase().indexOf(query.toLowerCase()) >= 0)
        })
    }

    signal mentioned(var value)
    signal selected(var value, string prefix)
    signal searched(string pattern, string prefix)
    signal wholeRemoved(string pattern, string prefix)

    function close() {
        mentionPopup.close()
    }

    function open() {
        if (enabled && !readOnly && (matches.length > 0 || loading))
            mentionPopup.open()
    }

    function optionValue(item) {
        return String(typeof item === "string" ? item
            : item[props.value || "value"] === undefined ? optionLabel(item)
            : item[props.value || "value"])
    }

    function optionLabel(item) {
        return String(typeof item === "string" ? item
            : item[props.label || "label"] === undefined ? item[props.value || "value"]
            : item[props.label || "label"])
    }

    function syncSuggestions() {
        if (mentionPosition >= 0 && activePrefix)
            searched(text.slice(mentionPosition + activePrefix.length, cursorPosition), activePrefix)
        if ((activeFocus || editor.activeFocus) && (matches.length > 0 || loading))
            open()
        else
            close()
    }

    function tokenAtCursor() {
        const prefixes = EDataUtils.isArray(prefix) ? prefix : [prefix]
        let result = {position: -1, prefix: ""}
        prefixes.forEach(function(token) {
            if (typeof token !== "string" || token.length === 0 || cursorPosition < token.length)
                return
            const position = text.lastIndexOf(token, cursorPosition - token.length)
            if (position > result.position)
                result = {position: position, prefix: token}
        })
        return result
    }

    function choose(index) {
        if (!enabled
            || readOnly
            || loading
            || !Number.isInteger(index)
            || index < 0
            || index >= matches.length)
            return false
        const item = matches[index]
        const value = optionValue(item)
        const prefixValue = activePrefix
        const position = mentionPosition
        let tokenEnd = cursorPosition
        while (tokenEnd < text.length
            && !/\s/.test(text.charAt(tokenEnd))
            && (!split || text.slice(tokenEnd, tokenEnd + split.length) !== split))
            ++tokenEnd
        const after = text.slice(tokenEnd)
        const separator = split && after.slice(0, split.length) === split ? "" : split
        const next = text.slice(0, position) + prefixValue + value + separator + after
        const end = position + prefixValue.length + value.length + split.length
        text = next
        cursorPosition = end
        if (editor !== control)
            editor.cursorPosition = end
        close()
        mentioned(item)
        selected(item, prefixValue)
        return true
    }

    function removeWhole() {
        if (!enabled || readOnly || (!whole && typeof checkIsWhole !== "function") || cursorPosition <= 0)
            return false
        const end = cursorPosition
        const before = text.slice(0, end)
        const trimmed = split && before.slice(-split.length) === split ? before.slice(0, -split.length)
            : before
        const prefixes = EDataUtils.isArray(prefix) ? prefix : [prefix]
        for (let index = 0; index < prefixes.length; ++index) {
            const token = prefixes[index]
            if (!token)
                continue
            const position = trimmed.lastIndexOf(token)
            if (position < 0)
                continue
            const pattern = trimmed.slice(position + token.length)
            if (!pattern || /\s/.test(pattern))
                continue
            const allowed = typeof checkIsWhole === "function" ? checkIsWhole(pattern, token)
                : options.some(function(item) {
                    return item && optionValue(item) === pattern
                })
            if (!allowed)
                continue
            text = text.slice(0, position) + text.slice(end)
            cursorPosition = position
            wholeRemoved(pattern, token)
            return true
        }
        return false
    }

    function handleKey(event) {
        if (editor.inputMethodComposing)
            return
        if (event.key === Qt.Key_Backspace && removeWhole()) {
            if (editor !== control)
                editor.cursorPosition = cursorPosition
            event.accepted = true
        } else if (event.key === Qt.Key_Down && matches.length > 0) {
            open()
            mentionList.currentIndex = (mentionList.currentIndex + 1) % matches.length
            mentionList.positionViewAtIndex(mentionList.currentIndex, ListView.Contain)
            event.accepted = true
        } else if (event.key === Qt.Key_Up && mentionPopup.visible && matches.length > 0) {
            mentionList.currentIndex = (mentionList.currentIndex + matches.length - 1) % matches.length
            mentionList.positionViewAtIndex(mentionList.currentIndex, ListView.Contain)
            event.accepted = true
        } else if ((event.key === Qt.Key_Return || event.key === Qt.Key_Enter) && mentionPopup.visible) {
            if (mentionList.currentIndex >= 0)
                choose(mentionList.currentIndex)
            else
                close()
            event.accepted = true
        } else if (event.key === Qt.Key_Escape && mentionPopup.visible) {
            close()
            event.accepted = true
        }
    }

    Keys.priority: Keys.BeforeItem
    implicitHeight: type === "textarea" ? Math.max(80, multiline.item ? multiline.item.implicitHeight : 80)
        : EDefaultConfig.controlHeight(size)

    onTextEdited: syncSuggestions()
    onEnabledChanged: if (!enabled)
        close()
    Keys.onPressed: function(event) {
        handleKey(event)
    }
    onMatchesChanged: mentionList.currentIndex = matches.length > 0 ? 0 : -1
    onTextChanged: if (editor !== control && editor.text !== text)
        editor.text = text
    onActiveFocusChanged: Qt.callLater(function() { if (!control.activeFocus && !control.editor.activeFocus)
        control.close() })
    onCursorPositionChanged: if (editor !== control && editor.cursorPosition !== cursorPosition)
        editor.cursorPosition = cursorPosition

    Loader {
        id: multiline

        anchors.fill: parent
        active: control.type === "textarea"
        sourceComponent: Component {
            ETextArea {
                font: control.font
                size: control.size
                text: control.text
                adaptiveHeight: false
                readOnly: control.readOnly
                objectName: "mentionTextarea"
                Keys.priority: Keys.BeforeItem
                placeholderText: control.placeholderText
                validationState: control.validationState
                validationMessage: control.validationMessage

                Keys.onPressed: function(event) {
                    control.handleKey(event)
                }
                onTextChanged: if (control.text !== text)
                    control.text = text
                onActiveFocusChanged: Qt.callLater(function() {
                    control.syncSuggestions()
                })
                onCursorPositionChanged: {
                    if (control.cursorPosition !== cursorPosition)
                        control.cursorPosition = cursorPosition
                    control.syncSuggestions()
                }
            }
        }
    }
    PickerPopup {
        id: mentionPopup

        padding: 0
        topPadding: 6
        bottomPadding: 6
        objectName: "mentionPopup"
        implicitHeight: popupColumn.implicitHeight + topPadding + bottomPadding
        x: Math.max(0, Math.min(control.width - width, control.editor.cursorRectangle.x))
        width: control.fitInputWidth ? control.width : Math.max(control.width, control.popupWidth)
        y: control.placement === "top" ? control.editor.cursorRectangle.y - height - control.offset
            : control.editor.cursorRectangle.y + control.editor.cursorRectangle.height + control.offset
        background: FieldSurface {
            Rectangle {
                width: 8
                height: 8
                rotation: 45
                visible: control.showArrow
                anchors.horizontalCenter: parent.horizontalCenter
                color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
                y: control.placement.indexOf("top") === 0 ? parent.height - height / 2 : -height / 2
            }
        }
        contentItem: Column {
            id: popupColumn

            Loader {
                id: popupHeader

                width: parent.width
                height: active ? implicitHeight : 0
                active: control.headerDelegate !== null
                sourceComponent: control.headerDelegate
            }
            Item {
                width: parent.width
                height: Math.min(control.popupMaxHeight, Math.max(40, mentionList.contentHeight,
                    loadingContent.active && loadingContent.item ? loadingContent.item.implicitHeight : 0))

                ListView {
                    id: mentionList

                    clip: true
                    currentIndex: -1
                    anchors.fill: parent
                    model: control.matches
                    visible: !(control.loading)
                    ScrollBar.vertical: ScrollHandle {}
                    objectName: "mentionSuggestionList"
                    delegate: OptionDelegate {
                        id: optionButton

                        size: control.size
                        focusPolicy: Qt.NoFocus
                        width: mentionList.width
                        enabled: !control.loading
                        highlighted: mentionList.currentIndex === index
                        text: control.activePrefix + control.optionLabel(modelData)
                        implicitHeight: Math.max(30, optionContent.implicitHeight
                            + topPadding
                            + bottomPadding)
                        contentItem: Loader {
                            id: optionContent

                            readonly property var option: modelData
                            readonly property int optionIndex: index

                            sourceComponent: control.labelDelegate || defaultOption

                            onLoaded: {
                                if ("option" in item)
                                    item.option = Qt.binding(function() {
                                        return optionContent.option
                                    })
                                if ("optionIndex" in item)
                                    item.optionIndex = Qt.binding(function() {
                                        return optionContent.optionIndex
                                    })
                            }
                        }

                        onClicked: control.choose(index)

                        Component {
                            id: defaultOption

                            EText {
                                font: control.font
                                elide: Text.ElideRight
                                text: optionButton.text
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                }
                Loader {
                    id: loadingContent

                    anchors.fill: parent
                    active: control.loading
                    sourceComponent: control.loadingDelegate || defaultLoading
                }
                EText {
                    anchors.centerIn: parent
                    visible: !control.loading && mentionList.count === 0
                    color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
                    text: EControlConfig.textFor(control, "NoMatchingResults2", ELocale.texts)
                }
            }
            Loader {
                width: parent.width
                height: active ? implicitHeight : 0
                active: control.footerDelegate !== null
                sourceComponent: control.footerDelegate
            }
        }

        onClosed: mentionList.currentIndex = -1
    }
    Component {
        id: defaultLoading

        EText {
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text: EControlConfig.textFor(control, "Loading", ELocale.texts)
        }
    }
}

import EUI 1.0
import EUI.Private 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

EInput {
    id: control

    property var model: []
    property int offset: 6
    property int debounce: 300
    property int popupWidth: 0
    property bool loading: false
    property bool showArrow: false
    property bool hideLoading: false
    property int popupMaxHeight: 240
    property bool fitInputWidth: true
    property string textRole: "label"
    property bool loopNavigation: true
    property bool triggerOnFocus: true
    property var fetchSuggestions: null
    property Component footerDelegate: null
    property Component headerDelegate: null
    property bool highlightFirstItem: false
    property Component optionDelegate: null
    property Component loadingDelegate: null
    property bool selectWhenUnmatched: false
    property string placement: "bottom-start"
    property alias valueKey: control.textRole

    readonly property var inputRef: control
    readonly property var popperRef: suggestionPopup
    readonly property bool activated: suggestionPopup.visible
    readonly property int highlightedIndex: suggestionList.currentIndex
    readonly property var suggestions: {
        const query = text.toLowerCase()
        return typeof fetchSuggestions === "function" || EDataUtils.isArray(fetchSuggestions) ? sourceItems
            : sourceItems.filter(function(item) {
                return item.search.indexOf(query) >= 0
            })
    }
    readonly property var sourceItems: {
        const result = []
        const source = EDataUtils.isArray(fetchSuggestions) ? fetchSuggestions
            : typeof fetchSuggestions === "function" ? internal.remoteItems
                : EDataUtils.isArray(model) ? model
                : []
        for (let index = 0; index < source.length; ++index) {
            const item = source[index]
            if (item === null || item === undefined || (typeof item === "object" && item.disabled))
                continue
            const label = typeof item === "object" && item !== null ? item[textRole] : item
            if (label !== undefined)
                result.push({ label: String(label), search: String(label).toLowerCase(), value: item })
        }
        return result
    }

    signal selected(var value)
    signal searchFailed(string message)

    function blur() {
        focus = false
        close()
    }

    function close() {
        fetchTimer.stop()
        suggestionPopup.close()
    }

    function open() {
        if (enabled && !readOnly)
            suggestionPopup.open()
    }

    function getData(query) {
        fetchTimer.stop()
        return fetch(query === undefined ? text : String(query))
    }

    function handleSelect(item) {
        const index = suggestions.findIndex(function(option) {
            return option.value === item
        })
        return choose(index)
    }

    function handleKeyEnter() {
        if (!enabled || readOnly || loading)
            return false
        if (activated && highlightedIndex >= 0)
            return choose(highlightedIndex)
        if (selectWhenUnmatched) {
            selected(text)
            close()
            return true
        }
        return false
    }

    function choose(index) {
        if (!enabled
            || readOnly
            || loading
            || !Number.isInteger(index)
            || index < 0
            || index >= suggestions.length)
            return false
        const item = suggestions[index]
        internal.selecting = true
        text = item.label
        internal.selecting = false
        close()
        selected(item.value)
        return true
    }

    function highlight(index) {
        if (!activated || loading || suggestions.length === 0 || !isFinite(index))
            return false
        let position = Math.floor(index)
        if (position < 0)
            position = loopNavigation ? suggestions.length - 1 : -1
        if (position >= suggestions.length)
            position = loopNavigation ? 0 : suggestions.length - 1
        suggestionList.currentIndex = position
        if (position >= 0)
            suggestionList.positionViewAtIndex(position, ListView.Contain)
        return true
    }

    function fetch(query) {
        if (EDataUtils.isArray(fetchSuggestions)) {
            loading = false
            return true
        }
        if (typeof fetchSuggestions !== "function")
            return false
        const revision = ++internal.revision
        loading = true
        function complete(items) {
            if (revision !== internal.revision)
                return
            internal.remoteItems = EDataUtils.isArray(items) ? items : []
            loading = false
            suggestionList.currentIndex = highlightFirstItem && suggestions.length > 0 ? 0 : -1
        }
        try {
            const result = fetchSuggestions(query === undefined ? text : String(query), complete)
            if (result && typeof result.then === "function")
                result.then(complete, function(error) {
                    if (revision !== internal.revision)
                        return
                    loading = false
                    searchFailed(String(error))
                })
            else if (EDataUtils.isArray(result))
                complete(result)
            return true
        } catch (error) {
            loading = false
            searchFailed(String(error))
            return false
        }
    }

    Keys.priority: Keys.BeforeItem

    onAccepted: handleKeyEnter()
    onEnabledChanged: if (!enabled)
        close()
    onTextEdited: {
        open()
        if (typeof fetchSuggestions === "function")
            fetchTimer.restart()
    }
    onSuggestionsChanged: suggestionList.currentIndex = highlightFirstItem && suggestions.length > 0 ? 0 : -1
    onTextChanged: if (typeof fetchSuggestions === "function" && !internal.selecting) {
        ++internal.revision
        fetchTimer.restart()
    }
    onActiveFocusChanged: {
        if (activeFocus && triggerOnFocus) {
            open()
            if (typeof fetchSuggestions === "function")
                fetchTimer.restart()
        } else if (!activeFocus)
            close()
    }
    Keys.onPressed: function(event) {
        if (inputMethodComposing)
            return
        if (event.key === Qt.Key_Down || event.key === Qt.Key_Up) {
            open()
            highlight(highlightedIndex + (event.key === Qt.Key_Down ? 1 : -1))
            event.accepted = true
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            event.accepted = handleKeyEnter()
        } else if (event.key === Qt.Key_Escape || event.key === Qt.Key_Tab) {
            close()
            event.accepted = event.key === Qt.Key_Escape
        } else if (activated && (event.key === Qt.Key_Home || event.key === Qt.Key_End)) {
            highlight(event.key === Qt.Key_Home ? 0 : suggestions.length - 1)
            event.accepted = true
        } else if (activated && (event.key === Qt.Key_PageUp || event.key === Qt.Key_PageDown)) {
            highlight(Math.max(0, Math.min(suggestions.length - 1, highlightedIndex
                + (event.key === Qt.Key_PageUp ? -10 : 10))))
            event.accepted = true
        }
    }

    QtObject {
        id: internal

        property int revision: 0
        property var remoteItems: []
        property bool selecting: false
    }
    Timer {
        id: fetchTimer

        interval: Math.max(0, control.debounce)

        onTriggered: control.fetch()
    }
    PickerPopup {
        id: suggestionPopup

        padding: 0
        topPadding: 6
        bottomPadding: 6
        objectName: "autocompletePopup"
        implicitHeight: popupColumn.implicitHeight + topPadding + bottomPadding
        width: control.fitInputWidth ? control.width : Math.max(control.width, control.popupWidth)
        y: control.placement.indexOf("top") === 0 ? -height - control.offset : control.height + control.offset
        x: control.placement.slice(-3) === "end" ? control.width - width
            : control.placement.slice(-5) === "start" ? 0
            : (control.width - width) / 2
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
                height: Math.min(control.popupMaxHeight, Math.max(40, suggestionList.contentHeight,
                    loadingContent.active && loadingContent.item ? loadingContent.item.implicitHeight : 0))

                ListView {
                    id: suggestionList

                    clip: true
                    currentIndex: -1
                    anchors.fill: parent
                    model: control.suggestions
                    ScrollBar.vertical: ScrollHandle {}
                    objectName: "autocompleteSuggestionList"
                    visible: !(control.loading && !control.hideLoading)
                    delegate: OptionDelegate {
                        id: optionButton

                        size: control.size
                        text: modelData.label
                        focusPolicy: Qt.NoFocus
                        enabled: !control.loading
                        width: suggestionList.width
                        highlighted: suggestionList.currentIndex === index
                        implicitHeight: Math.max(30, optionContent.implicitHeight
                            + topPadding
                            + bottomPadding)
                        contentItem: Loader {
                            id: optionContent

                            readonly property int optionIndex: index
                            readonly property var option: modelData.value

                            sourceComponent: control.optionDelegate || defaultOption

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
                    active: control.loading && !control.hideLoading
                    sourceComponent: control.loadingDelegate || defaultLoading
                }
                EText {
                    anchors.centerIn: parent
                    visible: !control.loading && suggestionList.count === 0
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

        onClosed: suggestionList.currentIndex = -1
    }
    Component {
        id: defaultLoading

        EText {
            verticalAlignment: Text.AlignVCenter
            objectName: "autocompleteLoadingText"
            horizontalAlignment: Text.AlignHCenter
            text: EControlConfig.textFor(control, "Loading", ELocale.texts)
        }
    }
}

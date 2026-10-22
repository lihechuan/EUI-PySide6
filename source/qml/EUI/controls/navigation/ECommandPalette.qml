import EUI 1.0
import EUI.Private 1.0
import "../private/CommandUtils.js" as Commands
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQuick.Controls

Popup {
    id: control

    property var model: []
    property string query: ""
    property int visibleRows: 8
    property int currentIndex: -1
    property bool closeOnTrigger: true
    property string shortcut: "Ctrl+Shift+P"
    property string placeholderText: EControlConfig.textFor(control, "CommandSearch", ELocale.texts)

    readonly property var filteredItems: {
        const words = query.trim().toLowerCase().split(/\s+/)
        return (EDataUtils.isArray(model) ? model : []).filter(function(item) {
            if (!item || typeof item !== "object" || item.separator || item.visible === false)
                return false
            const action = Commands.actionFor(item)
            const text = [item.text || (action ? action.text : ""), item.description || "", item.keywords || ""]
                .join(" ").toLowerCase()
            return words.every(function(word) { return text.indexOf(word) >= 0 })
        })
    }

    signal failed(string message)
    signal command(var value, var item)

    function resetSelection() {
        currentIndex = -1
        moveSelection(1)
    }

    function moveSelection(direction) {
        const count = filteredItems.length
        for (let step = 1; step <= count; ++step) {
            const next = ((currentIndex + step * direction) % count + count) % count
            if (Commands.enabled(filteredItems[next])) {
                currentIndex = next
                commandList.positionViewAtIndex(next, ListView.Contain)
                return true
            }
        }
        return false
    }

    function trigger(index) {
        if (!enabled || index < 0 || index >= filteredItems.length || Math.floor(index) !== index)
            return false
        const item = filteredItems[index]
        try {
            if (!Commands.invoke(item))
                return false
            const action = Commands.actionFor(item)
            command(item.command === undefined ? item.text || (action ? action.text : "") : item.command, item)
            if (closeOnTrigger)
                close()
            return true
        } catch (error) {
            failed(String(error))
            return false
        }
    }

    focus: true
    modal: true
    padding: 12
    parent: Overlay.overlay
    x: Math.max(0, (parent ? parent.width - width : 0) / 2)
    y: Math.max(16, (parent ? parent.height - height : 0) / 3)
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    width: Math.max(0, Math.min(520, parent ? parent.width - 32 : 520))
    background: ERectangle {
        radius: 8
        border.width: 1
        color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
        border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
    }
    contentItem: Column {
        spacing: 8

        EInput {
            id: searchInput

            clearable: true
            text: control.query
            width: parent.width
            objectName: "commandSearch"
            Keys.priority: Keys.BeforeItem
            placeholderText: control.placeholderText

            onCleared: control.query = ""
            onTextEdited: control.query = text
            Keys.onUpPressed: control.moveSelection(-1)
            Keys.onDownPressed: control.moveSelection(1)
            Keys.onEnterPressed: control.trigger(control.currentIndex)
            Keys.onReturnPressed: control.trigger(control.currentIndex)
        }
        ListView {
            id: commandList

            clip: true
            width: parent.width
            objectName: "commandList"
            model: control.filteredItems
            currentIndex: control.currentIndex
            ScrollBar.vertical: ScrollHandle {}
            boundsBehavior: Flickable.StopAtBounds
            height: Math.min(count, Math.max(1, control.visibleRows)) * 52
            delegate: ETextButton {
                id: commandButton

                property var entry: modelData

                readonly property var entryAction: Commands.actionFor(entry)

                height: 52
                leftIcon: true
                font.bold: false
                width: commandList.width
                enabled: Commands.enabled(entry)
                iconSource: entry.iconSource || 0
                objectName: "commandItem" + index
                text: entry.text || (entryAction ? entryAction.text : "")
                background: ERectangle {
                    radius: 4
                    color: index === control.currentIndex ? EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)
                        : EPaletteManager.BasePalette.transparent
                }
                contentItem: Row {
                    spacing: 8

                    EIcon {
                        width: visible ? 20 : 0
                        iconSource: commandButton.iconSource
                        visible: commandButton.iconSource !== 0
                        anchors.verticalCenter: parent.verticalCenter
                        color: commandButton.enabled ? EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
                            : EPaletteManager.ThemePalette.textDisabled(ETheme.dark)
                    }
                    Column {
                        spacing: 4
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - (commandButton.iconSource !== 0 ? 28 : 0)

                        EText {
                            width: parent.width
                            elide: Text.ElideRight
                            text: commandButton.text
                            color: commandButton.enabled ? EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
                                : EPaletteManager.ThemePalette.textDisabled(ETheme.dark)
                        }
                        EText {
                            font.pixelSize: 12
                            width: parent.width
                            elide: Text.ElideRight
                            visible: text.length > 0
                            text: commandButton.entry.description || ""
                            color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
                        }
                    }
                }

                onClicked: control.trigger(index)
            }
        }
        EText {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            visible: control.filteredItems.length === 0
            text: EControlConfig.textFor(control, "NoMatchingResults", ELocale.texts)
        }
    }

    onEnabledChanged: if (!enabled)
        close()
    onFilteredItemsChanged: resetSelection()
    onOpened: {
        query = ""
        resetSelection()
        searchInput.forceActiveFocus()
    }

    Shortcut {
        sequence: control.shortcut
        enabled: control.enabled && sequence.length > 0

        onActivated: control.visible ? control.close() : control.open()
    }
}

import EUI 1.0
import "../private/CommandUtils.js" as Commands
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

ToolBar {
    id: control

    property var model: []
    property bool showText: true
    property int alignment: Qt.AlignLeft
    property int size: EControlConfig.sizeFor(control)

    readonly property var items: EDataUtils.isArray(model) ? model.filter(function(item) {
        return item && typeof item === "object" && item.visible !== false
    }) : []
    readonly property real naturalWidth: {
        let total = 0
        for (let index = 0; index < actionRepeater.count; ++index) {
            const item = actionRepeater.itemAt(index)
            if (item)
                total += item.implicitWidth + (index > 0 ? spacing : 0)
        }
        return total
    }
    readonly property int visibleCount: {
        const total = naturalWidth
        if (total <= availableWidth)
            return items.length
        const limit = availableWidth - overflowButton.implicitWidth - spacing
        let used = 0
        let count = 0
        for (; count < actionRepeater.count; ++count) {
            const width = actionRepeater.itemAt(count).implicitWidth + (count > 0 ? spacing : 0)
            if (used + width > limit)
                break
            used += width
        }
        while (count > 0 && items[count - 1].separator)
            --count
        return count
    }
    readonly property var overflowItems: {
        const result = []
        let divided = false
        for (let index = visibleCount; index < items.length; ++index) {
            const item = items[index]
            if (item.separator) {
                divided = result.length > 0
                continue
            }
            const action = Commands.actionFor(item)
            result.push({command: index, text: item.text || (action ? action.text : ""),
                divided: divided, disabled: !Commands.enabled(item), iconSource: item.iconSource || 0,
                checkable: !!(action ? action.checkable : item.checkable), checked: !!(action ? action.checked : item.checked)})
            divided = false
        }
        return result
    }

    signal failed(string message)
    signal command(var value, var item)

    function trigger(index) {
        if (!enabled || index < 0 || index >= items.length || Math.floor(index) !== index)
            return false
        const item = items[index]
        try {
            if (!Commands.invoke(item))
                return false
            if (EDataUtils.isArray(model))
                model = model.slice()
            if (!Commands.actionFor(item))
                command(item.command === undefined ? item.text : item.command, item)
            return true
        } catch (error) {
            failed(String(error))
            return false
        }
    }

    function moveFocus(index, direction) {
        const count = visibleCount + (overflowButton.visible ? 1 : 0)
        for (let step = 1; step <= count; ++step) {
            const next = ((index + step * direction) % count + count) % count
            const item = next === visibleCount ? overflowButton : actionRepeater.itemAt(next)
            if (item && item.enabled && (next === visibleCount || !items[next].separator)) {
                item.forceActiveFocus()
                return true
            }
        }
        return false
    }

    clip: true
    padding: 8
    spacing: 6
    Accessible.role: Accessible.ToolBar
    implicitWidth: naturalWidth + leftPadding + rightPadding
    implicitHeight: EDefaultConfig.controlHeight(size) + topPadding + bottomPadding
    background: ERectangle {
        color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
    }
    contentItem: Item {
        Row {
            id: actionsRow

            spacing: control.spacing
            anchors.verticalCenter: parent.verticalCenter
            x: control.alignment === Qt.AlignRight ? Math.max(0, parent.width - implicitWidth
                - (overflowButton.visible ? overflowButton.width + control.spacing : 0))
                : control.alignment === Qt.AlignHCenter ? Math.max(0, (parent.width - implicitWidth
                    - (overflowButton.visible ? overflowButton.width + control.spacing : 0)) / 2) : 0

            Repeater {
                id: actionRepeater

                model: control.items

                EButton {
                    id: actionButton

                    property var entry: modelData

                    readonly property var entryAction: Commands.actionFor(entry)

                    plain: true
                    leftIcon: true
                    size: control.size
                    action: entryAction
                    autoExclusive: false
                    iconSource: entry.iconSource || 0
                    objectName: "toolbarAction" + index
                    visible: index < control.visibleCount
                    enabled: control.enabled && Commands.enabled(entry)
                    checked: entryAction ? entryAction.checked : !!entry.checked
                    checkable: entryAction ? entryAction.checkable : !!entry.checkable
                    accessibleName: entry.text || (entryAction ? entryAction.text : "")
                    text: control.showText ? entry.text || (entryAction ? entryAction.text : "") : ""
                    implicitWidth: entry.separator ? 8 : implicitContentWidth + leftPadding + rightPadding

                    Keys.onLeftPressed: control.moveFocus(index, -1)
                    Keys.onRightPressed: control.moveFocus(index, 1)
                    onClicked: if (!entryAction)
                        control.trigger(index)

                    Connections {
                        function onTriggered() {
                            control.command(actionButton.entry.command === undefined
                                ? actionButton.entryAction.text : actionButton.entry.command, actionButton.entry)
                        }

                        target: actionButton.entryAction
                    }
                    Shortcut {
                        sequence: actionButton.entry.shortcut || ""
                        enabled: !actionButton.entryAction && control.enabled && Commands.enabled(actionButton.entry)
                            && sequence.length > 0

                        onActivated: control.trigger(index)
                    }
                    EDivider {
                        anchors.centerIn: parent
                        height: parent.height - 8
                        direction: EOrientation.Vertical
                        visible: actionButton.entry.separator === true
                    }
                }
            }
        }
        EDropdown {
            id: overflowButton

            text: ""
            plain: true
            size: control.size
            anchors.right: parent.right
            iconSource: EIcons.ELLIPSIS
            model: control.overflowItems
            objectName: "toolbarOverflow"
            width: Math.min(implicitWidth, parent.width)
            anchors.verticalCenter: parent.verticalCenter
            visible: control.visibleCount < control.items.length
            accessibleName: EControlConfig.textFor(control, "More", ELocale.texts)

            onCommand: control.trigger(value)
            Keys.onLeftPressed: control.moveFocus(control.visibleCount, -1)
            Keys.onRightPressed: control.moveFocus(control.visibleCount, 1)
        }
    }
}

import EUI 1.0
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control

    property var model: []
    property var activeNames: []
    property var pendingNames: []
    property bool accordion: false
    property var beforeCollapse: null
    property Component iconDelegate: null
    property Component titleDelegate: null
    property Component contentDelegate: null
    property string expandIconPosition: "right"

    signal changed(var names)

    function isExpanded(name) {
        return EDataUtils.isArray(activeNames) && activeNames.indexOf(String(name)) >= 0
    }

    function setActiveNames(names) {
        activeNames = EDataUtils.isArray(names) ? names.map(String)
            : names === null || names === undefined ? []
            : [String(names)]
        normalizeActiveNames()
        return true
    }

    function applyToggle(key) {
        const item = EDataUtils.isArray(model) ? model.find(function(entry, index) {
            return entry && String(entry.name === undefined ? index : entry.name) === key
        }) : null
        if (!enabled || !item || item.disabled)
            return false
        const names = EDataUtils.isArray(activeNames) ? activeNames : []
        activeNames = isExpanded(key) ? names.filter(function(value) {
            return value !== key
        })
            : accordion ? [key] : names.concat([key])
        changed(activeNames)
        return true
    }

    function normalizeActiveNames() {
        const names = EDataUtils.isArray(model) ? model.map(function(entry, index) {
            return entry ? String(entry.name === undefined ? index : entry.name) : ""
        }) : []
        const active = EDataUtils.isArray(activeNames) ? activeNames.filter(function(name, index, values) {
            return names.indexOf(name) >= 0 && values.indexOf(name) === index
        }) : []
        const normalized = accordion ? active.slice(0, 1) : active
        if (JSON.stringify(activeNames) !== JSON.stringify(normalized))
            activeNames = normalized
    }

    function toggle(name) {
        const key = String(name)
        const item = EDataUtils.isArray(model) ? model.find(function(entry, index) {
            return entry && String(entry.name === undefined ? index : entry.name) === key
        }) : null
        if (!enabled || !item || item.disabled || pendingNames.indexOf(key) >= 0)
            return false
        if (typeof beforeCollapse !== "function")
            return applyToggle(key)
        try {
            const result = beforeCollapse(key, !isExpanded(key))
            if (result && typeof result.then === "function") {
                const revision = internal.revision
                pendingNames = pendingNames.concat([key])
                result.then(function() {
                    pendingNames = pendingNames.filter(function(value) {
                        return value !== key
                    })
                    if (revision === internal.revision)
                        applyToggle(key)
                }, function() {
                    pendingNames = pendingNames.filter(function(value) {
                        return value !== key
                    })
                })
                return true
            }
            return result !== false && applyToggle(key)
        } catch (error) {
            return false
        }
    }

    implicitWidth: 480
    implicitHeight: panels.implicitHeight
    contentItem: Column {
        id: panels

        Repeater {
            model: EDataUtils.isArray(control.model) ? control.model : []

            Column {
                id: panel

                property var entry: modelData || ({})
                property string key: String(entry.name === undefined ? index : entry.name)

                readonly property bool expanded: control.isExpanded(key)

                width: panels.width

                ERectangle {
                    height: 1
                    width: parent.width
                    color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
                }
                EButton {
                    id: heading

                    height: 48
                    textButton: true
                    width: parent.width
                    enabled: !panel.entry.disabled
                    text: String(panel.entry.title || panel.key)
                    Accessible.name: String(panel.entry.title || panel.key)
                    contentItem: EText {
                        text: heading.text
                        elide: Text.ElideRight
                        visible: !titleSlot.active
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: control.expandIconPosition === "left" ? 24 : 0
                        rightPadding: control.expandIconPosition === "left" ? 0 : 24
                        color: EPaletteManager.StatePalette.defaultTextColor(
                            EPaletteManager.createStateObject(this, EStyle.Color)
                                .setDark(ETheme.dark)
                                .setEnabled(heading.enabled)

                        )
                    }

                    onClicked: control.toggle(panel.key)

                    Loader {
                        id: titleSlot

                        property var entry: panel.entry

                        anchors.fill: parent
                        active: sourceComponent !== null
                        anchors.leftMargin: control.expandIconPosition === "left" ? 40 : 16
                        sourceComponent: panel.entry.titleDelegate || control.titleDelegate
                        anchors.rightMargin: control.expandIconPosition === "right" ? 40 : 16
                    }
                    EIcon {
                        iconSize: 14
                        anchors.rightMargin: 16
                        visible: !iconSlot.active
                        rotation: panel.expanded ? 90 : 0
                        anchors.verticalCenter: parent.verticalCenter
                        color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                        x: control.expandIconPosition === "left" ? 16 : parent.width - width - 16
                        iconSource: panel.entry.icon === undefined ? EIcons.CHEVRON_RIGHT : panel.entry.icon
                    }
                    Loader {
                        id: iconSlot

                        property var entry: panel.entry
                        property bool expanded: panel.expanded

                        width: 16
                        height: 16
                        active: sourceComponent !== null
                        anchors.verticalCenter: parent.verticalCenter
                        sourceComponent: panel.entry.iconDelegate || control.iconDelegate
                        x: control.expandIconPosition === "left" ? 16 : parent.width - width - 16
                    }
                }
                EText {
                    padding: 16
                    font.pixelSize: 14
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: String(panel.entry.content || "")
                    visible: panel.expanded && !contentSlot.active
                    color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                }
                Loader {
                    id: contentSlot

                    property var entry: panel.entry

                    width: parent.width
                    visible: panel.expanded
                    active: sourceComponent !== null
                    sourceComponent: panel.entry.contentDelegate || control.contentDelegate
                }
            }
        }
        ERectangle {
            height: 1
            width: parent.width
            color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
        }
    }

    onAccordionChanged: normalizeActiveNames()
    onModelChanged: {
        if (internal)
            ++internal.revision
        normalizeActiveNames()
    }

    QtObject {
        id: internal

        property int revision: 0
    }
}

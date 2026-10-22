import EUI 1.0
import "private" as Private
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control

    property var model: []
    property bool lazy: false
    property bool addable: false
    property int currentIndex: 0
    property bool movable: false
    property bool stretch: false
    property string type: "line"
    property bool closable: false
    property bool editable: false
    property var beforeLeave: null
    property int addIcon: EIcons.PLUS
    property real navigationWidth: 140
    property string tabPosition: "top"
    property int size: EControlConfig.sizeFor(control)

    readonly property alias navigation: tabBar
    readonly property int count: tabRepeater.count
    readonly property alias activePane: panes.currentItem
    readonly property bool vertical: tabPosition === "left" || tabPosition === "right"
    readonly property var currentName: currentIndex >= 0 && EDataUtils.isArray(model) && model[currentIndex]
        ? model[currentIndex].name === undefined ? currentIndex : model[currentIndex].name : currentIndex

    signal tabAddRequested()
    signal tabChanged(var name)
    signal tabMoved(int from, int to)
    signal selectionRejected(int index)
    signal tabClosed(int index, var item)
    signal edited(var name, string action)
    signal tabClicked(int index, var item)

    function paneAt(index) {
        const pane = paneRepeater.itemAt(index)
        return pane ? pane.item : null
    }

    function scrollToActiveTab() {
        if (currentIndex >= 0)
            tabBar.contentItem.positionViewAtIndex(currentIndex, ListView.Contain)
    }

    function requestAdd() {
        if (!enabled || !(addable || editable))
            return false
        tabAddRequested()
        edited(undefined, "add")
        return true
    }

    function removeFocus() {
        for (let index = 0; index < count; ++index) {
            const tab = tabRepeater.itemAt(index)
            if (tab)
                tab.focus = false
        }
        return true
    }

    function selectName(name) {
        if (!EDataUtils.isArray(model))
            return false
        for (let index = 0; index < model.length; ++index) {
            const value = model[index] && model[index].name !== undefined ? model[index].name : index
            if (value === name)
                return select(index)
        }
        return false
    }

    function commitSelection(index) {
        if (!enabled || !EDataUtils.isArray(model) || index < 0 || index >= model.length
            || (model[index] && model[index].disabled))
            return false
        selectionState.committing = true
        currentIndex = index
        selectionState.committing = false
        return true
    }

    function indexAt(position) {
        for (let index = 0; index < count; ++index) {
            const tab = tabRepeater.itemAt(index)
            const origin = tab.mapToItem(control.contentItem, 0, 0)
            if (position <= (vertical ? origin.y + tab.height : origin.x + tab.width))
                return index
        }
        return Math.max(0, count - 1)
    }

    function normalizeSelection() {
        if (EDataUtils.isArray(model) && currentIndex >= 0 && currentIndex < count
            && !(model[currentIndex] && model[currentIndex].disabled))
            return
        for (let index = 0; index < count; ++index) {
            if (!model[index] || !model[index].disabled) {
                commitSelection(index)
                return
            }
        }
        selectionState.committing = true
        currentIndex = -1
        selectionState.committing = false
    }

    function selectAdjacent(index, direction) {
        if (!enabled || count < 1 || !isFinite(index) || !isFinite(direction) || direction === 0)
            return false
        const step = direction < 0 ? -1 : 1
        for (let distance = 1; distance <= count; ++distance) {
            const next = ((index + distance * step) % count + count) % count
            if (model[next] && model[next].disabled)
                continue
            if (!select(next))
                return false
            const tab = tabRepeater.itemAt(next)
            if (tab)
                tab.forceActiveFocus()
            tabClicked(next, model[next])
            return true
        }
        return false
    }

    function closeTab(index) {
        if (!enabled || !EDataUtils.isArray(model) || !isFinite(index) || Math.floor(index) !== Number(index)
            || index < 0 || index >= count || (model[index] && model[index].disabled))
            return false
        const item = model[index]
        const next = model.slice()
        const selection = index < currentIndex ? currentIndex - 1
            : index === currentIndex ? Math.min(index, next.length - 2) : currentIndex
        next.splice(index, 1)
        model = next
        selectionState.committing = true
        currentIndex = selection
        selectionState.committing = false
        normalizeSelection()
        tabClosed(index, item)
        edited(item && item.name !== undefined ? item.name : index, "remove")
        return true
    }

    function moveTab(from, to) {
        if (!enabled || !EDataUtils.isArray(model) || !isFinite(from) || !isFinite(to))
            return false
        if (Math.floor(from) !== from || Math.floor(to) !== to || from < 0 || to < 0
            || from >= count || to >= count || from === to || (model[from] && model[from].disabled))
            return false
        const next = model.slice()
        const item = next.splice(from, 1)[0]
        next.splice(to, 0, item)
        let selected = currentIndex
        if (selected === from)
            selected = to
        else if (from < selected && selected <= to)
            --selected
        else if (to <= selected && selected < from)
            ++selected
        model = next
        selectionState.committing = true
        currentIndex = selected
        selectionState.committing = false
        tabMoved(from, to)
        return true
    }

    function select(index) {
        if (!enabled || !EDataUtils.isArray(model) || !isFinite(index) || Math.floor(index) !== Number(index)
            || index < 0 || index >= count || (model[index] && model[index].disabled))
            return false
        if (index === currentIndex)
            return true
        const oldIndex = currentIndex
        const nextName = model[index] && model[index].name !== undefined ? model[index].name : index
        const oldName = currentName
        const request = ++selectionState.request
        let result = true
        if (typeof beforeLeave === "function") {
            try {
                result = beforeLeave(nextName, oldName)
            } catch (error) {
                selectionRejected(index)
                return false
            }
        }
        if (result && typeof result.then === "function") {
            result.then(function(allowed) {
                if (request === selectionState.request && allowed !== false && currentIndex === oldIndex)
                    control.commitSelection(index)
                else if (request === selectionState.request)
                    control.selectionRejected(index)
            }, function() {
                if (request === selectionState.request)
                    control.selectionRejected(index)
            })
            return true
        }
        if (result === false) {
            selectionRejected(index)
            return false
        }
        return commitSelection(index)
    }

    padding: 0
    implicitWidth: 320
    rightPadding: !vertical && (addable || editable) ? 36 : 0
    implicitHeight: vertical
        ? Math.max((count + (addable || editable ? 1 : 0)) * tabBar.implicitHeight, panes.implicitHeight)
        : tabBar.implicitHeight + (panes.implicitHeight > 0 ? panes.implicitHeight + 12 : 0)
    contentItem: Item {
        TabBar {
            id: tabBar

            clip: true
            spacing: 0
            currentIndex: control.currentIndex
            implicitHeight: EDefaultConfig.controlHeight(control.size) + 8
            x: control.tabPosition === "right" ? control.availableWidth - width : 0
            width: control.vertical ? control.navigationWidth : control.availableWidth
            y: control.tabPosition === "bottom" ? control.availableHeight - height : 0
            height: control.vertical ? Math.max(0, control.availableHeight
                - (control.addable || control.editable ? implicitHeight : 0)) : implicitHeight
            background: ERectangle {
                height: 2
                visible: !control.vertical
                anchors.bottom: parent.bottom
                color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
            }
            contentItem: ListView {
                clip: true
                spacing: 0
                model: tabBar.contentModel
                currentIndex: control.currentIndex
                boundsBehavior: Flickable.StopAtBounds
                orientation: control.vertical ? ListView.Vertical : ListView.Horizontal
            }

            onCurrentIndexChanged: {
                if (currentIndex !== control.currentIndex)
                    setCurrentIndex(control.currentIndex)
            }

            Repeater {
                id: tabRepeater

                model: EDataUtils.isArray(control.model) ? control.model : []

                Private.TabItem {
                    owner: control
                    tabIndex: index
                    entry: modelData || ({})
                    width: control.vertical ? tabBar.width
                        : control.stretch ? tabBar.width / Math.max(1, control.count)
                        : Math.min(implicitWidth, tabBar.width)
                }
            }
        }
    }

    onModelChanged: {
        ++selectionState.request
        Qt.callLater(normalizeSelection)
    }
    Component.onCompleted: {
        selectionState.committing = true
        normalizeSelection()
        selectionState.acceptedIndex = currentIndex
        selectionState.committing = false
        selectionState.ready = true
    }
    onCurrentIndexChanged: {
        if (selectionState.restoring)
            return
        if (selectionState.ready && !selectionState.committing) {
            const requested = currentIndex
            selectionState.restoring = true
            currentIndex = selectionState.acceptedIndex
            selectionState.restoring = false
            select(requested)
            return
        }
        selectionState.acceptedIndex = currentIndex
        tabChanged(currentName)
        Qt.callLater(scrollToActiveTab)
        Qt.callLater(normalizeSelection)
    }

    QtObject {
        id: selectionState

        property int request: 0
        property bool ready: false
        property int acceptedIndex: 0
        property bool restoring: false
        property bool committing: false
    }
    Item {
        id: panes

        readonly property Item currentItem: children.length > 0 && paneRepeater.count > 0
            ? control.paneAt(control.currentIndex) : null

        implicitHeight: currentItem ? currentItem.implicitHeight : 0
        y: control.tabPosition === "top" ? tabBar.height + 12 : control.topPadding
        height: Math.max(0, control.availableHeight - (control.vertical ? 0 : tabBar.height + 12))
        x: control.tabPosition === "left" ? tabBar.width + 12 + control.leftPadding : control.leftPadding
        width: control.vertical ? Math.max(0, control.availableWidth - tabBar.width - 12)
            : control.availableWidth

        Repeater {
            id: paneRepeater

            model: EDataUtils.isArray(control.model) ? control.model : []

            Loader {
                id: paneLoader

                property var entry: modelData || ({})
                property bool visited: !control.lazy && !entry.lazy

                width: panes.width
                height: panes.height
                objectName: "tabPaneLoader"
                visible: index === control.currentIndex
                sourceComponent: entry.contentComponent || null
                active: visited || index === control.currentIndex

                Component.onCompleted: {
                    if (index === control.currentIndex)
                        visited = true
                }

                Connections {
                    function onCurrentIndexChanged() {
                        if (index === control.currentIndex)
                            paneLoader.visited = true
                    }

                    target: control
                }
            }
        }
    }
    ETextButton {
        iconSize: 14
        iconSource: control.addIcon
        height: tabBar.implicitHeight
        width: control.vertical ? tabBar.width : 32
        visible: control.addable || control.editable
        accessibleName: EControlConfig.textFor(control, "NewTab", ELocale.texts)
        y: control.topPadding + tabBar.y + (control.vertical ? tabBar.height : 0)
        x: control.vertical ? control.leftPadding + tabBar.x : control.width - width

        onClicked: control.requestAdd()
    }
}

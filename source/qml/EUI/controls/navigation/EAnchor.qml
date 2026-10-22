import EUI 1.0
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control

    property real bound: 1
    property var model: []
    property real offset: 0
    property int duration: 0
    property bool marker: true
    property Item target: null
    property int currentIndex: -1
    property string type: "default"
    property bool selectScrollTop: false
    property int direction: EOrientation.Vertical

    readonly property var items: flattenLinks(model)
    readonly property bool scrollable: target && target.contentItem && target.contentY !== undefined

    signal changed(int index, var item)
    signal clicked(int index, var item)

    function updateCurrent() {
        if (!scrollable || !items) {
            currentIndex = -1
            return
        }
        let selected = selectScrollTop && items.length > 0 ? 0 : -1
        for (let index = 0; index < items.length; ++index) {
            const entry = items[index]
            if (entry
                && entry.target
                && entry.target.mapToItem(target.contentItem, 0, 0).y <= target.contentY
                    + offset
                    + Math.max(0, bound))
                selected = index
        }
        currentIndex = selected
    }

    function flattenLinks(links) {
        const result = []
        const visited = []
        const pending = EDataUtils.isArray(links) ? links.slice().reverse() : []
        while (pending.length > 0) {
            const entry = pending.pop()
            if (entry && typeof entry === "object") {
                if (visited.indexOf(entry) >= 0)
                    continue
                visited.push(entry)
            }
            result.push(entry)
            if (entry && EDataUtils.isArray(entry.children)) {
                for (let index = entry.children.length - 1; index >= 0; --index)
                    pending.push(entry.children[index])
            }
        }
        return result
    }

    function scrollTo(index) {
        if (typeof index === "string") {
            index = items.findIndex(function(item) {
                return item && item.href === index
            })
        }
        if (!enabled || !scrollable || !isFinite(index) || Math.floor(index) !== Number(index)
            || index < 0 || index >= items.length)
            return false
        const entry = items[index]
        if (!entry || !entry.target || entry.disabled)
            return false
        const destination = Math.max(target.originY || 0, Math.min(
            Math.max(target.originY || 0, target.contentHeight - target.height),
            entry.target.mapToItem(target.contentItem, 0, 0).y - offset))
        scrollAnimation.stop()
        if (duration > 0) {
            scrollAnimation.to = destination
            scrollAnimation.restart()
        } else {
            target.contentY = destination
        }
        currentIndex = index
        clicked(index, entry)
        return true
    }

    padding: 0
    implicitWidth: 160
    implicitHeight: entries.implicitHeight
    contentItem: Grid {
        id: entries

        columns: control.direction === EOrientation.Horizontal ? Math.max(1, control.items.length) : 1

        Repeater {
            model: control.items

            ETextButton {
                id: link

                minHeight: 34
                Accessible.role: Accessible.Link
                enabled: !modelData || !modelData.disabled
                styleType: index === control.currentIndex ? EStyle.Primary : EStyle.Default
                implicitHeight: Math.max(minHeight, linkContent.implicitHeight + topPadding + bottomPadding)
                width: control.direction === EOrientation.Horizontal ? implicitWidth : control.availableWidth
                implicitWidth: Math.max(implicitContentWidth, linkContent.implicitWidth)
                    + leftPadding
                    + rightPadding
                text: typeof modelData === "string" ? modelData
                    : modelData ? String(modelData.text || modelData.title || "")
                    : ""
                contentItem: EText {
                    font: link.font
                    elide: Text.ElideRight
                    text: link.displayText
                    visible: !linkContent.active
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    color: EPaletteManager.StatePalette.computeEffectiveTextColor(
                        EPaletteManager.createStateObject(link, EStyle.TextColor)
                            .setDark(ETheme.dark)
                            .setHovered(link.hovered)
                            .setPressed(link.pressed)
                            .setEnabled(link.enabled)
                            .setPlain(link.plain)
                            .setColor(link.color)
                            .setComponentStyle(link.styleType)
                            .setTextButton(link.textButton)
                    )
                }

                onClicked: control.scrollTo(index)

                Loader {
                    id: linkContent

                    y: link.topPadding
                    x: link.leftPadding
                    width: link.availableWidth
                    height: link.availableHeight
                    active: sourceComponent !== null
                    sourceComponent: modelData && modelData.contentComponent ? modelData.contentComponent
                        : null
                }
                ERectangle {
                    visible: control.marker
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    width: control.direction === EOrientation.Horizontal || control.type === "underline"
                        ? parent.width
                        : 2
                    height: control.direction === EOrientation.Horizontal || control.type === "underline" ? 2
                        : parent.height
                    color: index === control.currentIndex
                        ? EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                        : EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
                }
            }
        }
    }

    onBoundChanged: updateCurrent()
    onModelChanged: updateCurrent()
    onOffsetChanged: updateCurrent()
    onTargetChanged: updateCurrent()
    Component.onCompleted: updateCurrent()
    onCurrentIndexChanged: changed(currentIndex, currentIndex >= 0 && currentIndex < items.length
        ? items[currentIndex]
        : null)

    NumberAnimation {
        id: scrollAnimation

        property: "contentY"
        target: control.target
        easing.type: Easing.InOutCubic
        duration: Math.max(0, control.duration)
    }
    Connections {
        function onContentYChanged() {
            control.updateCurrent()
        }

        target: control.target
        ignoreUnknownSignals: true
    }
}

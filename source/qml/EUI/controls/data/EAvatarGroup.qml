import EUI 1.0
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control
    default property alias content: avatarRow.data

    property int size: 40
    property int overlap: 8
    property var avatars: []
    property string shape: "circle"
    property int maxCollapseAvatars: 3
    property bool collapseAvatars: false
    property bool collapseAvatarsTooltip: false

    readonly property int count: EDataUtils.isArray(avatars) ? avatars.length : 0
    readonly property int collapsedCount: collapseAvatars
        ? Math.max(0, count - Math.max(0, maxCollapseAvatars))
        : 0

    function openCollapsed() {
        if (!enabled || !collapseAvatarsTooltip || collapsedCount === 0)
            return false
        collapsedPopup.open()
        return true
    }

    function syncAvatars() {
        const items = []
        for (let index = 0; index < avatarRow.children.length; ++index) {
            const item = avatarRow.children[index]
            if (item.size !== undefined
                && item.source !== undefined
                && item.shape !== undefined)
                items.push(item)
        }
        avatars = items
        items.forEach(function(item, index) {
            item.size = Qt.binding(function() {
                return control.size
            })
            item.shape = Qt.binding(function() {
                return control.shape
            })
            item.visible = !collapseAvatars || index < Math.max(0, maxCollapseAvatars)
        })
    }

    padding: 0
    implicitHeight: Math.max(1, size)
    implicitWidth: avatarRow.implicitWidth + (collapsedCount > 0
        ? size - (avatarRow.implicitWidth > 0 ? Math.min(size, overlap) : 0) : 0)
    contentItem: Row {
        id: avatarRow

        spacing: -Math.max(0, control.overlap)

        onChildrenChanged: Qt.callLater(control.syncAvatars)
    }

    onSizeChanged: Qt.callLater(syncAvatars)
    onShapeChanged: Qt.callLater(syncAvatars)
    Component.onCompleted: Qt.callLater(syncAvatars)
    onCollapseAvatarsChanged: Qt.callLater(syncAvatars)
    onMaxCollapseAvatarsChanged: Qt.callLater(syncAvatars)

    EAvatar {
        id: moreAvatar

        x: Math.max(0, avatarRow.implicitWidth - control.overlap)
        parent: control
        size: control.size
        shape: control.shape
        objectName: "avatarGroupCollapsed"
        text: "+" + control.collapsedCount
        visible: control.collapsedCount > 0
        backgroundColor: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)

        MouseArea {
            hoverEnabled: true
            parent: moreAvatar
            anchors.fill: parent
            objectName: "avatarGroupHover"

            onExited: closeTimer.restart()
            onClicked: control.openCollapsed()
            onEntered: {
                closeTimer.stop()
                control.openCollapsed()
            }
        }
    }
    Timer {
        id: closeTimer

        interval: 200

        onTriggered: {
            if (!popupHover.hovered)
                collapsedPopup.close()
        }
    }
    Popup {
        id: collapsedPopup

        padding: 12
        focus: false
        parent: Overlay.overlay
        objectName: "avatarGroupPopup"
        height: allAvatars.implicitHeight + 24
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        width: parent ? Math.min(400, parent.width - 16, control.count * (control.size + 8) + 24) : 0
        x: parent ? Math.max(8, Math.min(parent.width - width - 8, control.mapToItem(parent, 0, 0).x)) : 0
        y: parent ? Math.min(parent.height - height - 8, control.mapToItem(parent, 0, control.height + 8).y)
            : 0
        background: ERectangle {
            radius: 6
            border.width: 1
            color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
            border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
        }
        contentItem: Flow {
            id: allAvatars

            spacing: 8

            Repeater {
                model: control.avatars

                EAvatar {
                    size: control.size
                    shape: control.shape
                    text: modelData.text
                    source: modelData.source
                    fillMode: modelData.fillMode
                    iconSource: modelData.iconSource
                    backgroundColor: modelData.backgroundColor
                }
            }
            HoverHandler {
                id: popupHover

                onHoveredChanged: {
                    if (hovered)
                        closeTimer.stop()
                    else
                        closeTimer.restart()
                }
            }
        }
    }
}

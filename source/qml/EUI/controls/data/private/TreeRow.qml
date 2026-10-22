import EUI 1.0
import QtQuick 2.15

Item {
    id: row

    property var entry
    property var owner
    property string dropPosition: "inner"

    readonly property bool itemEnabled: owner.enabled && !entry.disabled
    readonly property real indentWidth: entry.level * Math.max(0, owner.indent)
    readonly property real labelOffset: indentWidth + 28 + (owner.showCheckbox ? 28 : 0)
    readonly property bool selected: owner.highlightCurrent && entry.key === owner.currentKey

    Accessible.name: entry.label
    Accessible.selected: selected
    activeFocusOnTab: itemEnabled
    objectName: "treeRow_" + entry.key
    Accessible.role: Accessible.TreeItem
    height: Math.max(1, owner.itemHeight)

    Keys.onReturnPressed: owner.clickNode(entry.key)
    Keys.onLeftPressed: owner.setExpanded(entry.key, false)
    Keys.onRightPressed: owner.setExpanded(entry.key, true)
    Keys.onSpacePressed: {
        if (owner.showCheckbox)
            owner.setChecked(entry.key, !owner.isChecked(entry.key))
        else
            owner.clickNode(entry.key)
    }

    ERectangle {
        anchors.fill: parent
        color: EPaletteManager.StatePalette.computeBackgroundColor(
            EPaletteManager.createStateObject(this, EStyle.BackgroundColor)
                .setDark(ETheme.dark)
                .setPressed(row.selected)
                .setEnabled(row.itemEnabled)
                .setHovered(pointer.containsMouse || row.activeFocus)

        )
    }
    EText {
        rightPadding: 12
        anchors.fill: parent
        font: row.owner.font
        text: row.entry.label
        elide: Text.ElideRight
        leftPadding: row.labelOffset
        visible: !row.owner.nodeDelegate
        verticalAlignment: Text.AlignVCenter
        color: EPaletteManager.StatePalette.computeTextColor(
            EPaletteManager.createStateObject(this, EStyle.Color)
                .setDark(ETheme.dark)
                .setPlain(true)
                .setIsFound(row.selected)
                .setEnabled(row.itemEnabled)
                .setComponentStyle(EStyle.Primary)

        )
    }
    Loader {
        property var entry: row.entry
        property var node: row.entry.node

        height: row.height
        x: row.labelOffset
        active: sourceComponent !== null
        width: Math.max(0, row.width - x - 12)
        sourceComponent: row.owner.nodeDelegate
    }
    MouseArea {
        id: pointer

        hoverEnabled: true
        anchors.fill: parent
        enabled: row.itemEnabled
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        drag.target: row.owner.draggable && (typeof row.owner.allowDrag !== "function"
            || row.owner.allowDrag(row.entry.node)) ? dragMarker : null

        onReleased: {
            if (drag.active)
                dragMarker.Drag.drop()
        }
        onPressed: function(mouse) {
            dragMarker.x = mouse.x
            dragMarker.y = mouse.y
        }
        onPositionChanged: function(mouse) {
            if (drag.active) {
                dragMarker.x = mouse.x
                dragMarker.y = mouse.y
            }
        }
        onClicked: {
            if (mouse.button === Qt.RightButton) {
                row.owner.nodeContextMenu(row.entry.node, mouse)
                return
            }
            row.forceActiveFocus()
            row.owner.clickNode(row.entry.key)
        }
        drag.onActiveChanged: {
            if (drag.active) {
                row.owner.draggingKey = row.entry.key
                row.owner.nodeDragStarted(row.entry.node)
            } else {
                row.owner.nodeDragEnded(row.entry.node, null, "")
                row.owner.draggingKey = ""
            }
        }
    }
    Item {
        id: dragMarker

        width: 1
        height: 1
        Drag.source: row
        Drag.hotSpot.x: 0
        Drag.hotSpot.y: 0
        Drag.keys: ["eui-tree"]
        Drag.active: pointer.drag.active
    }
    DropArea {
        id: dropTarget

        keys: ["eui-tree"]
        anchors.fill: parent
        enabled: row.owner.draggable && row.itemEnabled

        onExited: row.owner.nodeDragLeft(row.owner.findNode(row.owner.draggingKey), row.entry.node)
        onEntered: function(drag) {
            row.dropPosition = drag.y < row.height / 4 ? "before"
                : drag.y > row.height * 3 / 4 ? "after"
                : "inner"
            row.owner.nodeDragEntered(row.owner.findNode(row.owner.draggingKey), row.entry.node)
        }
        onDropped: function(drop) {
            row.dropPosition = drop.y < row.height / 4 ? "before"
                : drop.y > row.height * 3 / 4 ? "after"
                : "inner"
            if (row.owner.moveNode(row.owner.draggingKey, row.entry.key, row.dropPosition))
                drop.acceptProposedAction()
        }
        onPositionChanged: function(drag) {
            row.dropPosition = drag.y < row.height / 4 ? "before"
                : drag.y > row.height * 3 / 4 ? "after"
                : "inner"
            drag.accepted = row.owner.canDrop(row.owner.draggingKey, row.entry.key, row.dropPosition)
            row.owner.nodeDragOver(row.owner.findNode(row.owner.draggingKey), row.entry.node)
        }
    }
    ERectangle {
        height: 2
        x: row.indentWidth
        width: row.width - row.indentWidth
        y: row.dropPosition === "after" ? row.height - height : 0
        color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
        visible: row.owner.draggingKey.length > 0
            && row.owner.canDrop(row.owner.draggingKey, row.entry.key, row.dropPosition)
            && dropTarget.containsDrag && row.dropPosition !== "inner"
    }
    ETextButton {
        width: 24
        iconSize: 12
        height: row.height
        x: row.indentWidth
        enabled: row.itemEnabled
        visible: row.entry.hasChildren
        accessibleName: row.entry.label
        iconSource: row.owner.iconSource
        contentItem: EIcon {
            iconSize: 12
            anchors.centerIn: parent
            iconSource: row.owner.iconSource
            rotation: row.owner.isExpanded(row.entry.key) ? 90 : 0
            color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
        }

        onClicked: row.owner.toggle(row.entry.key)
    }
    ECheckBox {
        text: ""
        width: 24
        height: row.height
        borderVisible: false
        x: row.indentWidth + 26
        enabled: row.itemEnabled
        visible: row.owner.showCheckbox
        objectName: "treeCheck_" + row.entry.key
        anchors.verticalCenter: parent.verticalCenter
        indicator.anchors.leftMargin: (width - indicator.width) / 2
        checkState: row.owner.isHalfChecked(row.entry.key) ? Qt.PartiallyChecked
            : row.owner.isChecked(row.entry.key) ? Qt.Checked : Qt.Unchecked

        onClicked: row.owner.setChecked(row.entry.key, checkState === Qt.Checked)
    }
    ELoading {
        width: 12
        height: 12
        x: row.indentWidth + 6
        visible: row.owner.isLoading(row.entry.key)
        anchors.verticalCenter: parent.verticalCenter
    }
}

import EUI 1.0
import "TableOperations.js" as Operations
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Item {
    id: tableRow

    property var entry
    property var owner
    property int displayIndex: 0
    property var hoveredCells: []
    property bool spanOverlay: false
    property var retainedContent: null

    readonly property bool preserving: owner.preserveExpandedContent
    readonly property bool striped: owner.stripe && displayIndex % 2 === 1
    readonly property real contentHeight: owner.rowHeightFor(entry, displayIndex)
    readonly property bool expanded: owner.canExpand(entry) && owner.isExpanded(owner.entryKey(entry))
    readonly property var rowAppearance: owner.styleFor(owner.rowStyle, entry, null, displayIndex, -1)
    readonly property bool selected: owner.highlightCurrentRow && owner.currentRowIndex === entry.index
    readonly property bool itemEnabled: owner.enabled && !entry.disabled && !(entry.row && entry.row.disabled)
    readonly property Component expansionComponent: owner.expandDelegate
        || (owner.columnModel.filter(function(column) {
        return column.type === "expand"
    })[0] || {}).cellDelegate || null
    readonly property color backgroundColor: rowAppearance.backgroundColor
        || (selected && itemEnabled ? owner.selectedColor
        : itemEnabled && (rowHover.hovered || hoveredCells.length > 0 || activeFocus) ? owner.hoverColor
            : striped ? owner.stripeColor
            : owner.surfaceColor)

    function attachRetainedContent() {
        if (retainedContent) {
            retainedContent.visible = false
            retainedContent.parent = owner
            retainedContent = null
        }
        if (spanOverlay || !preserving || !expanded)
            return
        const component = expansionComponent
        if (!component)
            return
        retainedContent = owner.retainedExpansion(entry, displayIndex, component)
        if (!retainedContent)
            return
        owner.recordExpansionHeight(entry, retainedContent.height)
        retainedContent.parent = retainedHost
        retainedContent.width = Qt.binding(function() {
            return retainedHost.width
        })
        retainedContent.visible = Qt.binding(function() {
            return tableRow && tableRow.expanded
        })
    }

    objectName: "tableRow"
    Accessible.selected: selected
    activeFocusOnTab: itemEnabled
    Accessible.role: Accessible.Row
    z: typeof owner.spanMethod === "function" ? owner.displayRows.length - displayIndex : 0
    height: contentHeight
        + (expanded ? retainedContent ? retainedContent.height
            : expandedContent.active ? expandedContent.height
            : 0
            : 0)

    onExpandedChanged: attachRetainedContent()
    onPreservingChanged: attachRetainedContent()
    Component.onCompleted: attachRetainedContent()
    onEntryChanged: Qt.callLater(attachRetainedContent)
    Keys.onSpacePressed: if (!owner.keyboardNavigation)
        owner.selectRow(entry.index)
    Keys.onReturnPressed: if (!owner.keyboardNavigation)
        owner.selectRow(entry.index)
    Component.onDestruction: {
        if (retainedContent) {
            retainedContent.visible = false
            retainedContent.parent = owner
        }
    }

    Connections {
        function onColumnModelChanged() {
            tableRow.attachRetainedContent()
        }

        function onExpandDelegateChanged() {
            tableRow.attachRetainedContent()
        }

        target: tableRow.owner
    }
    HoverHandler {
        id: rowHover
    }
    ERectangle {
        anchors.fill: parent
        visible: !tableRow.spanOverlay
        color: tableRow.backgroundColor
        objectName: "tableRowBackground"
    }
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        enabled: tableRow.itemEnabled && !tableRow.spanOverlay

        onDoubleClicked: tableRow.owner.rowDoubleClicked(tableRow.entry.row, tableRow.entry.index)
        onClicked: function(mouse) {
            tableRow.forceActiveFocus()
            if (mouse.button === Qt.RightButton)
                tableRow.owner.rowContextMenu(tableRow.entry.row, tableRow.entry.index)
            else
                tableRow.owner.selectRow(tableRow.entry.index)
        }
    }
    ERectangle {
        y: 8
        width: 3
        radius: 1
        objectName: "tableRowSelection"
        color: tableRow.owner.accentColor
        height: Math.max(0, tableRow.contentHeight - 16)
        visible: tableRow.selected && tableRow.itemEnabled && !tableRow.spanOverlay
    }
    Repeater {
        model: tableRow.owner.renderColumnIndexes

        Item {
            id: cell

            readonly property alias overflowTooltip: cellTooltip.item
            readonly property var column: tableRow.owner.columnModel[columnIndex]
            readonly property int columnIndex: tableRow.owner.renderColumnIndexes[index]
            readonly property string validationMessage: tableRow.owner.cellError(tableRow.entry.row, column)
            readonly property var span: tableRow.owner.cellSpan(
                tableRow.entry,
                column,
                tableRow.displayIndex,
                columnIndex
            )
            readonly property var appearance: tableRow.owner.styleFor(
                tableRow.owner.cellStyle,
                tableRow.entry,
                column,
                tableRow.displayIndex,
                columnIndex
            )
            readonly property bool treeCell: tableRow.owner.hasTree
                && columnIndex === tableRow.owner.columnModel.findIndex(function(column) {
                return column.type !== "selection" && column.type !== "index" && column.type !== "expand"
            })

            objectName: "tableCellHost"
            x: tableRow.owner.columnX(columnIndex)
            z: tableRow.owner.columnFixed(column) ? 3 : span.rowspan > 1 ? 2 : 0
            height: tableRow.owner.spanHeight(tableRow.displayIndex, span.rowspan)
            visible: span.rowspan > 0 && span.colspan > 0 && (!tableRow.spanOverlay || span.rowspan > 1)
            width: tableRow.owner.columnWidth(columnIndex)
                + (span.colspan > 1 ? tableRow.owner.columnModel.slice(columnIndex + 1, columnIndex + span.colspan)
                .reduce(function(sum, column, offset) {
                    return sum + tableRow.owner.columnWidth(columnIndex + offset + 1)
                }, 0) : 0)

            ERectangle {
                anchors.fill: parent
                color: cell.appearance.backgroundColor || (tableRow.owner.isCellSelected(tableRow.displayIndex, cell.columnIndex)
                    || tableRow.owner.highlightCurrentColumn && tableRow.owner.currentColumnIndex === cell.columnIndex
                    || tableRow.owner.highlightHoverColumn && tableRow.owner.hoveredColumnIndex === cell.columnIndex
                    ? tableRow.owner.selectedColor : tableRow.backgroundColor)
            }
            MouseArea {
                id: cellPointer

                hoverEnabled: true
                anchors.fill: parent
                enabled: tableRow.itemEnabled
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onPositionChanged: {
                    if (pressed && tableRow.owner.rangeSelection) {
                        const point = mapToItem(tableRow.owner, mouse.x, mouse.y)
                        tableRow.owner.extendSelection(point.x, point.y)
                    }
                }
                onEntered: {
                    tableRow.owner.hoveredColumnIndex = cell.columnIndex
                    tableRow.hoveredCells = tableRow.hoveredCells.concat([cell])
                    tableRow.owner.cellMouseEntered(tableRow.entry.row, cell.column, tableRow.entry.index)
                }
                onExited: {
                    tableRow.owner.hoveredColumnIndex = -1
                    tableRow.hoveredCells = tableRow.hoveredCells.filter(function(item) {
                        return item !== cell
                    })
                    tableRow.owner.cellMouseLeft(tableRow.entry.row, cell.column, tableRow.entry.index)
                }
                onPressed: function(mouse) {
                    if (mouse.button === Qt.LeftButton && tableRow.owner.rangeSelection)
                        tableRow.owner.selectCell(tableRow.displayIndex, cell.columnIndex, Boolean(mouse.modifiers & Qt.ShiftModifier), Boolean(mouse.modifiers & Qt.ControlModifier))
                }
                onDoubleClicked: {
                    if (tableRow.owner.editConfig.trigger === "dblclick")
                        tableRow.owner.editCell(tableRow.entry.row, cell.column)
                    tableRow.owner.cellDoubleClicked(tableRow.entry.row, cell.column, tableRow.entry.index)
                    tableRow.owner.rowDoubleClicked(tableRow.entry.row, tableRow.entry.index)
                }
                onClicked: function(mouse) {
                    tableRow.forceActiveFocus()
                    if (tableRow.entry.group) { tableRow.owner.toggleGroup(tableRow.entry.key)
                     return }
                    if (!tableRow.owner.rangeSelection || mouse.button === Qt.RightButton)
                        tableRow.owner.selectCell(tableRow.displayIndex, cell.columnIndex, Boolean(mouse.modifiers & Qt.ShiftModifier), Boolean(mouse.modifiers & Qt.ControlModifier))
                    if (tableRow.owner.editConfig.trigger === "click") tableRow.owner.editCell(tableRow.entry.row, cell.column)
                    if (mouse.button === Qt.RightButton) {
                        const point = mapToItem(tableRow.owner, mouse.x, mouse.y)
                        tableRow.owner.openContextMenu(tableRow.entry.row, cell.column, point.x, point.y)
                        tableRow.owner.cellContextMenu(tableRow.entry.row, cell.column, tableRow.entry.index)
                        tableRow.owner.rowContextMenu(tableRow.entry.row, tableRow.entry.index)
                    } else {
                        tableRow.owner.cellClicked(tableRow.entry.row, cell.column, tableRow.entry.index)
                        tableRow.owner.selectRow(tableRow.entry.index)
                    }
                }
            }
            EText {
                id: cellText

                rightPadding: 16
                width: parent.width
                height: parent.height
                elide: Text.ElideRight
                objectName: "tableCell"
                font: tableRow.owner.font
                verticalAlignment: Text.AlignVCenter
                visible: !(cell.column.cellDelegate || tableRow.owner.cellDelegate)
                leftPadding: 16
                    + (cell.treeCell ? (tableRow.entry.level || 0) * tableRow.owner.indent + 26 : 0)
                horizontalAlignment: cell.column.align === "right" ? Text.AlignRight
                    : cell.column.align === "center" ? Text.AlignHCenter : Text.AlignLeft
                color: !tableRow.itemEnabled ? EPaletteManager.ThemePalette.textDisabled(ETheme.dark)
                    : cell.appearance.color
                        || tableRow.rowAppearance.color
                        || EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                text: tableRow.entry.group && cell.columnIndex === 0 ? tableRow.entry.label
                    : cell.column.type === "selection" || cell.column.type === "expand" || cell.column.type === "radio" ? ""
                    : tableRow.owner.cellText(tableRow.entry.row, cell.column, tableRow.displayIndex)
            }
            ERectangle {
                z: 5
                anchors.fill: parent
                color: "transparent"
                border.width: cell.validationMessage ? 1 : 0
                border.color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Danger)
            }
            ERectangle {
                z: 7
                width: 8
                height: 8
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                color: tableRow.owner.accentColor
                objectName: "tableAreaFillHandle"
                visible: tableRow.owner.rangeSelection && tableRow.owner.editable && tableRow.owner.cellArea !== null
                    && tableRow.owner.cellArea.endRow === tableRow.displayIndex && tableRow.owner.cellArea.endColumn === cell.columnIndex

                MouseArea {
                    property var originalArea: null

                    anchors.fill: parent
                    cursorShape: Qt.CrossCursor

                    onReleased: tableRow.owner.fillCellArea(originalArea)
                    onPressed: originalArea = Object.assign({}, tableRow.owner.cellArea)
                    onPositionChanged: if (pressed) {
                        const point = mapToItem(tableRow.owner, mouse.x, mouse.y)
                        tableRow.owner.extendSelection(point.x, point.y)
                    }
                }
            }
            Loader {
                objectName: "tableCellErrorTooltip"
                active: cell.validationMessage.length > 0
                sourceComponent: EToolTip {
                    reference: cellPointer
                    text: cell.validationMessage
                    visible: cellPointer.containsMouse && text.length > 0
                }
            }
            Loader {
                z: 6
                anchors.margins: 4
                anchors.fill: parent
                sourceComponent: Component {
                    TableEditor {
                        column: cell.column
                        owner: tableRow.owner
                        row: tableRow.entry.row
                    }
                }
                active: tableRow.owner.editingCell !== null && tableRow.owner.editingCell.key === tableRow.owner.entryKey(tableRow.entry)
                    && (tableRow.owner.editConfig.mode === "row" && Operations.canEdit(tableRow.owner, tableRow.entry.row, cell.column)
                        || Operations.field(tableRow.owner.editingCell.column) === Operations.field(cell.column))
            }
            Loader {
                anchors.centerIn: parent
                active: cell.column.type === "radio" && !tableRow.entry.group
                sourceComponent: ERadio {
                    borderVisible: false
                    objectName: "tableRowRadio"
                    checked: tableRow.owner.radioKey === tableRow.owner.entryKey(tableRow.entry)

                    onClicked: tableRow.owner.setRadioRow(tableRow.entry.row)
                }
            }
            Loader {
                anchors.centerIn: parent
                active: cell.column.type === "selection" && !tableRow.entry.group
                sourceComponent: ECheckBox {
                    borderVisible: false
                    objectName: "tableRowCheckbox"
                    enabled: tableRow.owner.isSelectable(tableRow.entry)
                    checkState: tableRow.owner.rowCheckState(tableRow.entry)

                    onClicked: {
                        tableRow.owner.toggleRowSelection(tableRow.entry.row, checked)
                        tableRow.owner.select(tableRow.owner.selectedRows, tableRow.entry.row)
                    }
                }
            }
            Loader {
                width: 26
                height: 28
                anchors.verticalCenter: parent.verticalCenter
                active: !tableRow.entry.group && (cell.column.type === "expand" || cell.treeCell && tableRow.entry.hasChildren)
                x: cell.column.type === "expand" ? (parent.width - width) / 2
                    : 12 + (tableRow.entry.level || 0) * tableRow.owner.indent
                sourceComponent: ETextButton {
                    iconSize: 14
                    leftPadding: 0
                    rightPadding: 0
                    size: EStyle.Small
                    objectName: "tableExpandButton"
                    enabled: tableRow.itemEnabled && tableRow.owner.canExpand(tableRow.entry)
                    iconSource: tableRow.expanded ? EIcons.CHEVRON_DOWN : EIcons.CHEVRON_RIGHT

                    onClicked: tableRow.owner.toggleRowExpansion(tableRow.entry.row)
                }
            }
            Loader {
                property var column: cell.column
                property var table: tableRow.owner
                property var row: tableRow.entry.row
                property int rowIndex: tableRow.displayIndex

                anchors.fill: parent
                sourceComponent: cell.column.cellDelegate || tableRow.owner.cellDelegate

                onLoaded: {
                    if (item && "row" in item)
                        item.row = Qt.binding(function() {
                            return tableRow.entry.row
                        })
                    if (item && "column" in item)
                        item.column = Qt.binding(function() {
                            return cell.column
                        })
                    if (item && "table" in item)
                        item.table = tableRow.owner
                    if (item && "rowIndex" in item)
                        item.rowIndex = Qt.binding(function() {
                            return tableRow.displayIndex
                        })
                }
            }
            ERectangle {
                width: 1
                height: parent.height
                anchors.right: parent.right
                color: tableRow.owner.borderColor
                visible: tableRow.owner.borderMode === "full" || tableRow.owner.borderMode === "inner"
                    || tableRow.owner.borderMode === "default" && tableRow.owner.border || tableRow.owner.columnFixed(cell.column)
            }
            Loader {
                id: cellTooltip

                active: Boolean(cell.column.showOverflowTooltip === undefined
                    ? tableRow.owner.showOverflowTooltip : cell.column.showOverflowTooltip)
                sourceComponent: EToolTip {
                    trigger: "manual"
                    reference: cellPointer
                    objectName: "tableCellTooltip"
                    effect: tableRow.owner.tooltipEffect
                    enterable: tableRow.owner.tooltipOptions.enterable !== false
                    showArrow: tableRow.owner.tooltipOptions.showArrow !== false
                    fallbackPlacements: tableRow.owner.tooltipOptions.fallbackPlacements || []
                    placement: tableRow.owner.tooltipPlacement(tableRow.owner.tooltipOptions.placement)
                    offset: Number(tableRow.owner.tooltipOptions.offset === undefined ? 8
                        : tableRow.owner.tooltipOptions.offset)
                        || 0
                    timeout: tableRow.owner.tooltipOptions.hideAfter === undefined ? -1
                        : Number(tableRow.owner.tooltipOptions.hideAfter) || -1
                    delay: tableRow.owner.tooltipOptions.showAfter === undefined ? 600
                        : Math.max(0, Number(tableRow.owner.tooltipOptions.showAfter) || 0)
                    visible: (cellPointer.containsMouse || enterable && contentHovered)
                        && cellMetrics.width > cellText.width - cellText.leftPadding - cellText.rightPadding
                        && text.length > 0
                    text: typeof (cell.column.tooltipFormatter || tableRow.owner.tooltipFormatter) === "function"
                        ? String((cell.column.tooltipFormatter
                            || tableRow.owner.tooltipFormatter)({ row: tableRow.entry.row, column: cell.column,
                            cellValue: tableRow.owner.cellValue(tableRow.entry.row, cell.column) }))
                        : tableRow.owner.cellText(tableRow.entry.row, cell.column, tableRow.displayIndex)

                    TextMetrics {
                        id: cellMetrics

                        font: cellText.font
                        text: cellText.text
                    }
                }
            }
        }
    }
    Item {
        id: retainedHost

        y: tableRow.contentHeight
        x: tableRow.owner.scrollLeft
        width: tableRow.owner.availableWidth
        visible: tableRow.expanded && !tableRow.spanOverlay

        Connections {
            function onHeightChanged() {
                tableRow.owner.recordExpansionHeight(tableRow.entry, tableRow.retainedContent.height)
            }

            ignoreUnknownSignals: true
            target: tableRow.retainedContent
        }
    }
    Loader {
        id: expandedContent

        property var table: tableRow.owner
        property var dataRow: tableRow.entry.row
        property int rowIndex: tableRow.displayIndex

        y: tableRow.contentHeight
        x: tableRow.owner.scrollLeft
        width: tableRow.owner.availableWidth
        sourceComponent: tableRow.expansionComponent
        visible: tableRow.expanded && !tableRow.spanOverlay
        active: !tableRow.spanOverlay && !tableRow.preserving && tableRow.expanded

        onHeightChanged: {
            if (!active || !tableRow.expanded)
                return
            tableRow.owner.recordExpansionHeight(tableRow.entry, height)
        }
        onLoaded: {
            if (item && "row" in item)
                item.row = Qt.binding(function() {
                    return tableRow.entry.row
                })
            if (item && "rowIndex" in item)
                item.rowIndex = Qt.binding(function() {
                    return tableRow.displayIndex
                })
            if (item && "table" in item)
                item.table = tableRow.owner
        }
    }
    ERectangle {
        height: 1
        opacity: 0.55
        anchors.bottom: parent.bottom
        objectName: "tableRowSeparator"
        color: tableRow.owner.borderColor
        x: tableRow.owner.border ? 0 : 16
        width: Math.max(0, parent.width - (tableRow.owner.border ? 0 : 32))
        visible: tableRow.owner.borderMode !== "none" && tableRow.owner.borderMode !== "outer"
            && tableRow.displayIndex < tableRow.owner.displayRows.length - 1 && !tableRow.spanOverlay
    }
    MouseArea {
        z: 7
        width: 14
        height: parent.height
        x: tableRow.owner.scrollLeft
        cursorShape: Qt.SizeVerCursor
        objectName: "tableRowDragHandle"
        visible: tableRow.owner.rowDraggable && !tableRow.entry.group

        onPressed: tableRow.owner.draggedRowIndex = tableRow.entry.index
        onReleased: {
            const position = mapToItem(tableRow.parent, mouse.x, mouse.y)
            const view = tableRow.parent.parent
            const index = typeof view.indexAt === "function" ? view.indexAt(position.x, position.y) : -1
            const target = tableRow.owner.displayRows[index]
            if (target) tableRow.owner.moveRow(tableRow.owner.draggedRowIndex, target.index)
            tableRow.owner.draggedRowIndex = -1
        }

        EIcon {
            iconSize: 12
            iconSource: EIcons.BARS
            anchors.centerIn: parent
        }
    }
}

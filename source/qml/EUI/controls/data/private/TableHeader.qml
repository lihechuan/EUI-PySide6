import EUI 1.0
import "TableLogic.js" as Logic
import "../../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

ETextButton {
    id: header

    property var owner
    property var column: ({})
    property int columnIndex: 0
    property real resizeStart: 0
    property real resizeWidth: 0

    readonly property bool sorted: sortOrder.length > 0
    readonly property string sortOrder: owner.columnSortOrder(column)
    readonly property string label: String(column.label || column.prop || "")
    readonly property bool filterable: EDataUtils.isArray(column.filters) && column.filters.length > 0

    text: label
    topPadding: 0
    leftPadding: 0
    font.bold: true
    rightPadding: 0
    bottomPadding: 0
    enabled: owner.enabled
    objectName: "tableHeader"
    styleType: EStyle.Default
    font.family: owner.font.family
    font.pixelSize: owner.font.pixelSize
    z: owner.columnFixed(column) ? 3 : 0
    x: owner ? owner.columnX(columnIndex) : 0
    width: owner ? owner.columnWidth(columnIndex) : 0
    height: owner ? owner.effectiveHeaderHeight - y : 0
    y: owner ? (column._level || 0) * owner.headerHeight : 0
    focusPolicy: column.sortable ? Qt.StrongFocus : Qt.NoFocus
    Accessible.description: owner && typeof owner.sortIndicator === "function" ? owner.sortIndicator(column) : ""
    background: ERectangle {
        color: header.owner.hoverColor

        ERectangle {
            x: 4
            y: 4
            radius: 5
            width: Math.max(0, parent.width - 8)
            height: Math.max(0, parent.height - 8)
            color: header.column.sortable && (header.hovered || header.activeFocus)
                ? EPaletteManager.ThemePalette.surfacePressed(ETheme.dark) : "transparent"
        }
        ERectangle {
            width: 1
            height: parent.height
            anchors.right: parent.right
            color: header.owner.borderColor
            visible: header.owner.borderMode === "full" || header.owner.borderMode === "inner"
                || header.owner.borderMode === "default" && header.owner.border || header.owner.columnFixed(header.column)
        }
    }
    contentItem: EText {
        leftPadding: 16
        font: header.font
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
        text: header.column.type === "selection" ? "" : header.label
        rightPadding: 16 + (header.column.sortable ? 18 : 0) + (header.filterable ? 26 : 0)
        color: !header.owner.enabled ? EPaletteManager.ThemePalette.textDisabled(ETheme.dark)
            : header.sorted ? header.owner.accentColor : EPaletteManager.ThemePalette.textRegular(ETheme.dark)
        horizontalAlignment: (header.column.headerAlign || header.column.align) === "right" ? Text.AlignRight
            : (header.column.headerAlign || header.column.align) === "center" ? Text.AlignHCenter
                : Text.AlignLeft

        Column {
            spacing: 0
            anchors.right: parent.right
            visible: Boolean(header.column.sortable)
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: header.filterable ? 40 : 14

            EIcon {
                iconSize: 8
                iconSource: EIcons.CHEVRON_UP
                objectName: "tableSortAscending"
                color: header.owner.enabled && header.sorted && header.sortOrder === "ascending"
                    ? header.owner.accentColor : EPaletteManager.ThemePalette.textDisabled(ETheme.dark)
            }
            EIcon {
                iconSize: 8
                iconSource: EIcons.CHEVRON_DOWN
                objectName: "tableSortDescending"
                color: header.owner.enabled && header.sorted && header.sortOrder === "descending"
                    ? header.owner.accentColor : EPaletteManager.ThemePalette.textDisabled(ETheme.dark)
            }
        }
    }

    Component.onCompleted: contentItem.visible = Qt.binding(function() {
        return !(column.headerDelegate || owner.headerDelegate)
    })
    onClicked: {
        owner.headerClicked(column)
        if (column.sortable)
            owner.sort(column.prop || column.property, owner.nextSortOrder(column.prop || column.property))
    }

    Loader {
        anchors.centerIn: parent
        active: header.column.type === "selection"
        sourceComponent: ECheckBox {
            borderVisible: false
            objectName: "tableSelectAll"
            checkState: header.owner.allSelected ? Qt.Checked
                : header.owner.indeterminate ? Qt.PartiallyChecked
                : Qt.Unchecked

            onClicked: header.owner.toggleAllSelection()
        }
    }
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton

        onClicked: function(mouse) {
            header.owner.headerContextMenu(header.column)
            const point = mapToItem(header.owner, mouse.x, mouse.y)
            header.owner.openContextMenu(null, header.column, point.x, point.y)
        }
    }
    Loader {
        property var table: header.owner
        property var column: header.column
        property int columnIndex: header.columnIndex

        anchors.fill: parent
        sourceComponent: header.column.headerDelegate || header.owner.headerDelegate

        onLoaded: {
            if (item && "column" in item)
                item.column = Qt.binding(function() {
                    return header.column
                })
            if (item && "table" in item)
                item.table = header.owner
            if (item && "columnIndex" in item)
                item.columnIndex = Qt.binding(function() {
                    return header.columnIndex
                })
        }
    }
    ETextButton {
        width: 26
        height: 28
        iconSize: 14
        leftPadding: 0
        rightPadding: 0
        size: EStyle.Small
        anchors.rightMargin: 7
        iconSource: EIcons.FUNNEL
        visible: header.filterable
        anchors.right: parent.right
        objectName: "tableFilterButton"
        anchors.verticalCenter: parent.verticalCenter
        styleType: header.owner.valuesForFilter(header.column).length ? EStyle.Primary : EStyle.Default

        onClicked: filterPopup.open()
    }
    MouseArea {
        z: 5
        width: 6
        height: parent.height
        anchors.right: parent.right
        cursorShape: Qt.SplitHCursor
        visible: header.column.resizable !== false

        onReleased: header.owner.headerDragend(
            header.owner.columnWidth(header.columnIndex),
            header.resizeWidth,
            header.column
        )
        onPressed: function(mouse) {
            header.resizeStart = mapToItem(header.owner, mouse.x, mouse.y).x
            header.resizeWidth = header.width
        }
        onPositionChanged: function(mouse) {
            if (pressed)
                header.owner.resizeColumn(header.columnIndex, header.resizeWidth
                    + mapToItem(header.owner, mouse.x, mouse.y).x - header.resizeStart, false)
        }
    }
    Popup {
        id: filterPopup

        padding: 12
        y: header.height
        objectName: "tableFilterPopup"
        width: Math.max(180, Math.min(280, header.width))
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        background: ERectangle {
            radius: 8
            border.width: 1
            color: header.owner.surfaceColor
            border.color: header.owner.borderColor
        }
        contentItem: Loader {
            active: filterPopup.visible
            sourceComponent: Column {
                spacing: 4

                Repeater {
                    model: header.column.filters || []

                    ECheckBox {
                        width: parent.width
                        borderVisible: false
                        objectName: "tableFilterOption"
                        text: modelData.text === undefined ? String(modelData.value) : modelData.text
                        checkState: header.owner.valuesForFilter(header.column).indexOf(modelData.value) >= 0
                            ? Qt.Checked
                            : Qt.Unchecked

                        onClicked: {
                            const values = header.owner.valuesForFilter(header.column).filter(function(value) {
                                return value !== modelData.value
                            })
                            if (checked)
                                values.push(modelData.value)
                            header.owner.setFilter(Logic.columnKey(header.column, header.columnIndex), values)
                            if (header.column.filterMultiple === false)
                                filterPopup.close()
                        }
                    }
                }
                ETextButton {
                    text: EControlConfig.textFor(header.owner, "ResetFilter", ELocale.texts)

                    onClicked: header.owner.clearFilter(Logic.columnKey(header.column, header.columnIndex))
                }
            }
        }
    }
    MouseArea {
        z: 6
        width: 20
        height: 10
        anchors.top: parent.top
        cursorShape: Qt.SizeHorCursor
        objectName: "tableColumnDragHandle"
        visible: header.owner.columnDraggable
        anchors.horizontalCenter: parent.horizontalCenter

        onPressed: header.owner.draggedColumnIndex = header.columnIndex
        onReleased: {
            const point = mapToItem(header.owner.contentItem, mouse.x, mouse.y)
            for (let index = 0; index < header.owner.columnModel.length; ++index)
                if (point.x >= header.owner.columnX(index) && point.x < header.owner.columnX(index) + header.owner.columnWidth(index)) {
                    header.owner.moveColumn(header.owner.draggedColumnIndex, index)
                    break
                }
            header.owner.draggedColumnIndex = -1
        }
    }
}

import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls

Control {
    id: control

    property var model: []
    property int columns: 3
    property string extra: ""
    property string title: ""
    property bool border: true
    property real labelWidth: 112
    property Component extraDelegate: null
    property Component labelDelegate: null
    property Component titleDelegate: null
    property Component valueDelegate: null
    property string direction: "horizontal"
    property int size: EControlConfig.sizeFor(control)

    readonly property var columnMetrics: measureColumns()

    function alignment(value) {
        return value === "center" ? Text.AlignHCenter : value === "right" ? Text.AlignRight
            : typeof value === "number" ? value : Text.AlignLeft
    }

    function cellWidth(index, availableWidth, spacing) {
        const metrics = columnMetrics
        const place = metrics.positions[index]
        if (!place)
            return 0
        const fixed = metrics.widths.reduce(function(sum, value) {
            return sum + value
        }, 0)
        const weight = metrics.weights.reduce(function(sum, value, column) {
            return sum + (metrics.widths[column] > 0 ? 0 : value)
        }, 0)
        const remaining = Math.max(0, availableWidth - spacing * (Math.max(1, columns) - 1) - fixed)
        let width = spacing * (place.span - 1)
        for (let column = place.column; column < place.column + place.span; ++column)
            width += metrics.widths[column] > 0 ? metrics.widths[column]
                : remaining * metrics.weights[column] / Math.max(1, weight)
        return width
    }

    function measureColumns() {
        const count = Math.max(1, columns)
        const positions = []
        const widths = []
        const weights = []
        const occupied = []
        for (let column = 0; column < count; ++column) {
            widths.push(0)
            weights.push(1)
        }
        let row = 0
        let column = 0
        const entries = EDataUtils.isArray(model) ? model : []
        entries.forEach(function(entry) {
            entry = entry || ({})
            const span = Math.max(1, Math.min(count, Number(entry.span) || 1))
            const rowspan = Math.max(1, Number(entry.rowspan) || 1)
            let free = false
            while (!free) {
                if (column + span > count) {
                    ++row
                    column = 0
                }
                free = true
                for (let index = column; index < column + span; ++index) {
                    if (occupied[row] && occupied[row][index]) {
                        free = false
                        ++column
                        break
                    }
                }
            }
            positions.push({ row: row, column: column, span: span, rowspan: rowspan })
            for (let r = row; r < row + rowspan; ++r) {
                if (!occupied[r])
                    occupied[r] = []
                for (let c = column; c < column + span; ++c)
                    occupied[r][c] = true
            }
            for (let c = column; c < column + span; ++c) {
                if (Number(entry.width) > 0)
                    widths[c] = Math.max(widths[c], Number(entry.width) / span)
                if (Number(entry.minWidth) > 0)
                    weights[c] = Math.max(weights[c], Number(entry.minWidth) / span)
            }
            column += span
        })
        return { positions: positions, widths: widths, weights: weights }
    }

    implicitWidth: 600
    implicitHeight: contentColumn.implicitHeight
    contentItem: Column {
        id: contentColumn

        spacing: 16

        Item {
            width: parent.width
            visible: control.title.length > 0
                || control.extra.length > 0
                || titleSlot.active
                || extraSlot.active
            implicitHeight: visible ? Math.max(titleLabel.implicitHeight, extraLabel.implicitHeight,
                titleSlot.implicitHeight, extraSlot.implicitHeight) : 0

            EText {
                id: titleLabel

                font.bold: true
                text: control.title
                elide: Text.ElideRight
                visible: !titleSlot.active
                font.pixelSize: control.font.pixelSize
                color: EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
                width: Math.max(0, parent.width - extraLabel.implicitWidth - 16)
            }
            Loader {
                id: titleSlot

                active: sourceComponent !== null
                sourceComponent: control.titleDelegate
            }
            EText {
                id: extraLabel

                font: control.font
                text: control.extra
                visible: !extraSlot.active
                anchors.right: parent.right
                color: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
            }
            Loader {
                id: extraSlot

                anchors.right: parent.right
                active: sourceComponent !== null
                sourceComponent: control.extraDelegate
            }
        }
        Item {
            width: parent.width
            implicitHeight: grid.implicitHeight + (control.border ? 2 : 0)

            ERectangle {
                radius: 4
                anchors.fill: parent
                color: control.border ? EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
                    : EPaletteManager.BasePalette.transparent
            }
            GridLayout {
                id: grid

                readonly property real cellWidth: Math.max(
                    0,
                    (width - columnSpacing * (columns - 1)) / columns
                )

                x: control.border ? 1 : 0
                y: control.border ? 1 : 0
                rowSpacing: control.border ? 1 : 8
                columns: Math.max(1, control.columns)
                columnSpacing: control.border ? 1 : 16
                width: parent.width - (control.border ? 2 : 0)

                Repeater {
                    model: EDataUtils.isArray(control.model) ? control.model : []

                    ERectangle {
                        id: cell

                        property var entry: modelData || ({})

                        readonly property bool vertical: control.direction === "vertical"
                        readonly property var position: control.columnMetrics.positions[index]
                            || ({ row: 0, column: 0 })
                        readonly property real inset: control.size === EStyle.Small ? 8
                            : control.size === EStyle.Large ? 16
                            : 12
                        readonly property real labelHeight: Math.max(label.contentHeight
                            + inset * 2, labelSlot.implicitHeight
                            + inset * 2)
                        readonly property real valueHeight: Math.max(value.contentHeight
                            + inset * 2, valueSlot.implicitHeight
                            + inset * 2)
                        readonly property real labelExtent: Math.min(width, Math.max(0,
                            entry.labelWidth === undefined ? control.labelWidth : Number(entry.labelWidth)))

                        Layout.fillHeight: true
                        Layout.fillWidth: false
                        Layout.row: position.row
                        Layout.column: position.column
                        implicitWidth: Layout.preferredWidth
                        objectName: "descriptionCell_" + index
                        Layout.maximumWidth: Layout.preferredWidth
                        Layout.rowSpan: Math.max(1, Number(entry.rowspan) || 1)
                        Layout.minimumWidth: Math.max(0, Number(entry.minWidth) || 0)
                        color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
                        Layout.columnSpan: Math.max(1, Math.min(grid.columns, Number(entry.span) || 1))
                        Layout.preferredWidth: control.cellWidth(index, grid.width, grid.columnSpacing)
                        implicitHeight: vertical ? labelHeight + valueHeight
                            : Math.max(labelHeight, valueHeight)
                        Layout.minimumHeight: control.size === EStyle.Small ? 36
                            : control.size === EStyle.Large ? 56
                            : 48

                        ERectangle {
                            visible: control.border
                            width: cell.vertical ? parent.width : cell.labelExtent
                            height: cell.vertical ? cell.labelHeight : parent.height
                            color: EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)
                        }
                        EText {
                            id: label

                            font: control.font
                            padding: cell.inset
                            wrapMode: Text.Wrap
                            text: String(cell.entry.label || "")
                            verticalAlignment: Text.AlignVCenter
                            width: cell.vertical ? parent.width : cell.labelExtent
                            height: cell.vertical ? cell.labelHeight : parent.height
                            color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                            visible: !(cell.entry.labelDelegate || control.labelDelegate)
                            horizontalAlignment: control.alignment(cell.entry.labelAlign === undefined
                                ? cell.entry.align
                                : cell.entry.labelAlign)
                        }
                        Loader {
                            id: labelSlot

                            property var entry: cell.entry
                            property var modelData: cell.entry

                            x: cell.inset
                            y: cell.inset
                            sourceComponent: cell.entry.labelDelegate || control.labelDelegate
                            width: Math.max(0, (cell.vertical ? cell.width
                                : cell.labelExtent) - cell.inset * 2)
                        }
                        EText {
                            id: value

                            font: control.font
                            padding: cell.inset
                            wrapMode: Text.Wrap
                            verticalAlignment: Text.AlignVCenter
                            width: Math.max(0, parent.width - x)
                            height: Math.max(0, parent.height - y)
                            x: cell.vertical ? 0 : cell.labelExtent
                            y: cell.vertical ? cell.labelHeight : 0
                            horizontalAlignment: control.alignment(cell.entry.align)
                            color: EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
                            visible: !(cell.entry.valueDelegate || control.valueDelegate)
                            text: String(cell.entry.value === undefined || cell.entry.value === null ? ""
                                : cell.entry.value)
                        }
                        Loader {
                            id: valueSlot

                            property var entry: cell.entry
                            property var modelData: cell.entry

                            width: Math.max(0, cell.width - x - cell.inset)
                            x: (cell.vertical ? 0 : cell.labelExtent) + cell.inset
                            y: (cell.vertical ? cell.labelHeight : 0) + cell.inset
                            sourceComponent: cell.entry.valueDelegate || control.valueDelegate
                        }
                    }
                }
            }
        }
    }
}

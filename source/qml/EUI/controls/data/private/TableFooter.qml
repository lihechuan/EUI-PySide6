import EUI 1.0
import "TableOperations.js" as Operations
import QtQuick 2.15

Item {
    id: footer

    property var owner

    Repeater {
        model: footer.owner.footerRows.length

        Item {
            id: footerRow

            readonly property int rowIndex: index
            readonly property var values: footer.owner.footerRows[rowIndex]

            width: footer.width
            height: footer.owner.effectiveRowHeight
            z: footer.owner.footerRows.length - rowIndex
            y: rowIndex * footer.owner.effectiveRowHeight

            ERectangle {
                anchors.fill: parent
                color: footer.owner.hoverColor
            }
            Repeater {
                model: footer.owner.renderColumnIndexes

                EText {
                    readonly property var column: footer.owner.columnModel[columnIndex]
                    readonly property int columnIndex: footer.owner.renderColumnIndexes[index]
                    readonly property var span: {
                        if (typeof footer.owner.footerSpanMethod === "function") {
                            const result = footer.owner.footerSpanMethod({rowIndex: footerRow.rowIndex, columnIndex: columnIndex, column: column})
                            return EDataUtils.isArray(result) ? {rowspan: result[0], colspan: result[1]} : result || {rowspan: 1, colspan: 1}
                        }
                        return Operations.mergeSpan(footer.owner.mergeFooterCells, footerRow.rowIndex, columnIndex,
                            footer.owner.footerRows.length, footer.owner.columnModel.length)
                    }

                    leftPadding: 16
                    rightPadding: 16
                    elide: Text.ElideRight
                    font: footer.owner.font
                    objectName: "tableSummaryCell"
                    verticalAlignment: Text.AlignVCenter
                    x: footer.owner.columnX(columnIndex)
                    visible: span.rowspan > 0 && span.colspan > 0
                    z: footer.owner.columnFixed(column) ? 3 : span.rowspan > 1 ? 2 : 0
                    height: footer.owner.effectiveRowHeight * Math.max(1, span.rowspan)
                    horizontalAlignment: (column.footerAlign || column.align) === "right" ? Text.AlignRight
                        : (column.footerAlign || column.align) === "center" ? Text.AlignHCenter : Text.AlignLeft
                    text: {
                        const value = EDataUtils.isArray(footerRow.values) ? footerRow.values[columnIndex]
                            : footerRow.values[Operations.field(column)]
                        return value === undefined || value === null ? "" : String(value)
                    }
                    width: footer.owner.columnModel.slice(columnIndex, columnIndex + Math.max(1, span.colspan)).reduce(function(sum, column, offset) {
                        return sum + footer.owner.columnWidth(columnIndex + offset)
                    }, 0)

                    ERectangle {
                        z: -1
                        anchors.fill: parent
                        color: footer.owner.hoverColor
                    }
                }
            }
        }
    }
}

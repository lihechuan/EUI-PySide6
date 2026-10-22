import EUI 1.0
import "TableLogic.js" as Logic
import "TableOperations.js" as Operations
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Item {
    id: tools

    property var owner
    property var matches: []
    property int matchIndex: -1
    property var menuContext: ({})
    property string fileFormat: "csv"
    property string operationError: ""
    property string fileAction: "export"

    readonly property var localizedTexts: ELocale.texts

    function openFile(action) {
        fileAction = action
        operationError = ""
        fileDialog.open()
    }

    function selectMatch() {
        if (!matches.length)
            return
        matchIndex = (matchIndex + 1) % matches.length
        const match = matches[matchIndex]
        owner.selectCell(match.rowIndex, match.columnIndex, false)
        owner.navigateCell(0, 0, false)
    }

    function openMenu(row, column, x, y) {
        menuContext = {row: row, column: column, table: owner}
        contextMenu.x = Math.max(0, Math.min(owner.width - contextMenu.width, x))
        contextMenu.y = Math.max(0, Math.min(owner.height - contextMenu.height, y))
        contextMenu.open()
    }

    function execute(command) {
        if (command === "copy") owner.copyCellArea(false)
        else if (command === "cut") owner.copyCellArea(true)
        else if (command === "paste") owner.pasteCellArea()
        else if (command === "edit") owner.editCell(menuContext.row, menuContext.column)
        else if (command === "remove") owner.remove(menuContext.row)
        else if (command === "undo") owner.undo()
        else if (command === "redo") owner.redo()
        owner.menuCommand(command, menuContext)
        contextMenu.close()
    }

    implicitHeight: toolbarLoader.active ? toolbarLoader.implicitHeight + 12 : buttons.implicitHeight + 12

    Loader {
        id: buttons

        x: 8
        y: 6
        width: parent.width - 16
        active: tools.owner.showToolbar && !toolbarLoader.active
        sourceComponent: Flow {
            spacing: 6
            width: parent.width

            ETextButton {
                visible: tools.owner.editable
                objectName: "tableToolbarInsert"
                text: tools.localizedTexts.TableAddRow

                onClicked: tools.owner.insert({})
            }
            ETextButton {
                visible: tools.owner.editable
                objectName: "tableToolbarRemove"
                text: tools.localizedTexts.Delete
                enabled: tools.owner.selectedRows.length > 0 || tools.owner.currentRow !== null

                onClicked: tools.owner.remove(tools.owner.selectedRows.length ? tools.owner.selectedRows : tools.owner.currentRow)
            }
            ETextButton {
                visible: tools.owner.editable
                objectName: "tableToolbarValidate"
                text: tools.localizedTexts.TableValidate

                onClicked: tools.owner.validate()
            }
            ETextButton {
                text: tools.localizedTexts.Confirm
                visible: tools.owner.editConfig.mode === "row" && tools.owner.editingCell !== null

                onClicked: tools.owner.commitEdit()
            }
            ETextButton {
                text: tools.localizedTexts.Cancel
                visible: tools.owner.editConfig.mode === "row" && tools.owner.editingCell !== null

                onClicked: tools.owner.cancelEdit()
            }
            ETextButton {
                enabled: tools.owner.canUndo
                objectName: "tableToolbarUndo"
                text: tools.localizedTexts.TableUndo
                visible: tools.owner.editable || tools.owner.rowDraggable

                onClicked: tools.owner.undo()
            }
            ETextButton {
                enabled: tools.owner.canRedo
                text: tools.localizedTexts.TableRedo
                visible: tools.owner.editable || tools.owner.rowDraggable

                onClicked: tools.owner.redo()
            }
            ETextButton {
                objectName: "tableToolbarFind"
                text: tools.localizedTexts.TableFindReplace

                onClicked: findDialog.open()
            }
            ETextButton {
                text: tools.localizedTexts.TableImport

                onClicked: tools.openFile("import")
            }
            ETextButton {
                objectName: "tableToolbarExport"
                text: tools.localizedTexts.TableExport

                onClicked: tools.openFile("export")
            }
            ETextButton {
                text: tools.localizedTexts.TablePrint

                onClicked: tools.openFile("print")
            }
            ETextButton {
                text: tools.localizedTexts.TableChart

                onClicked: chartDialog.open()
            }
            ETextButton {
                text: tools.localizedTexts.TableReload
                visible: typeof tools.owner.proxyConfig.query === "function"

                onClicked: tools.owner.commitProxy("reload")
            }
            ETextButton {
                visible: tools.owner.layoutKey.length > 0
                text: tools.localizedTexts.TableSaveLayout

                onClicked: tools.owner.saveLayout()
            }
            EText {
                wrapMode: Text.WordWrap
                visible: text.length > 0
                objectName: "tableOperationError"
                width: Math.min(implicitWidth, parent.width)
                color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Danger)
                text: tools.owner.validationErrors.length ? tools.owner.validationErrors[0].message : tools.operationError || tools.owner.queryError
            }
        }
    }
    Loader {
        id: toolbarLoader

        width: parent.width
        active: tools.owner.toolbarDelegate !== null
        sourceComponent: tools.owner.toolbarDelegate

        onLoaded: if (item && "table" in item)
            item.table = tools.owner
    }
    Connections {
        function onDataChange() { tools.operationError = "" }

        function onQueryCompleted() { tools.operationError = "" }

        function onOperationFailed(action, message) { tools.operationError = message }

        target: tools.owner
    }
    Popup {
        id: contextMenu

        padding: 6
        width: 180
        parent: tools.owner
        objectName: "tableContextMenu"
        background: ERectangle {
            radius: 6
            border.width: 1
            color: tools.owner.surfaceColor
            border.color: tools.owner.borderColor
        }
        contentItem: Column {
            Repeater {
                model: !contextMenu.visible ? [] : tools.owner.menuItems.length ? tools.owner.menuItems : [
                    {command: "copy", label: tools.localizedTexts.TableCopy, disabled: !tools.owner.cellArea},
                    {command: "paste", label: tools.localizedTexts.TablePaste, disabled: !tools.owner.editable || !tools.owner.cellArea},
                    {command: "edit", label: tools.localizedTexts.Edit, disabled: !Operations.canEdit(tools.owner, tools.menuContext.row, tools.menuContext.column)},
                    {command: "remove", label: tools.localizedTexts.Delete, disabled: !tools.owner.editable || !tools.menuContext.row},
                    {command: "undo", label: tools.localizedTexts.TableUndo, disabled: !tools.owner.canUndo}]

                ETextButton {
                    width: 168
                    enabled: !modelData.disabled
                    objectName: "tableContextCommand"
                    text: modelData.label || modelData.command

                    onClicked: tools.execute(modelData.command)
                }
            }
        }
    }
    EDialog {
        id: findDialog

        autofocus: false
        implicitWidth: 460
        showCancelButton: false
        showConfirmButton: false
        objectName: "tableFindDialog"
        title: tools.localizedTexts.TableFindReplace
        contentComponent: Column {
            spacing: 12
            width: parent.width

            EInput {
                id: findInput

                width: parent.width
                objectName: "tableFindInput"
                placeholderText: tools.localizedTexts.TableFind
            }
            EInput {
                id: replaceInput

                width: parent.width
                placeholderText: tools.localizedTexts.TableReplace
            }
            ECheckBox {
                id: caseSensitive

                text: tools.localizedTexts.TableCaseSensitive
            }
            Row {
                spacing: 8

                EButton {
                    text: tools.localizedTexts.TableFindNext

                    onClicked: {
                        tools.matches = tools.owner.findCells(findInput.text, {caseSensitive: caseSensitive.checked})
                        tools.selectMatch()
                    }
                }
                EButton {
                    enabled: tools.owner.editable
                    text: tools.localizedTexts.TableReplaceAll

                    onClicked: tools.owner.replaceCells(findInput.text, replaceInput.text, {caseSensitive: caseSensitive.checked})
                }
            }
            EText {
                text: String(tools.matches.length) + tools.localizedTexts.TableMatches
            }
        }
    }
    EDialog {
        id: fileDialog

        autofocus: false
        implicitWidth: 500
        objectName: "tableFileDialog"
        title: tools.fileAction === "import" ? tools.localizedTexts.TableImport : tools.fileAction === "print" ? tools.localizedTexts.TablePrint : tools.localizedTexts.TableExport
        contentComponent: Column {
            readonly property alias pathText: filePath.text

            spacing: 12
            width: parent.width

            EInput {
                id: filePath

                width: parent.width
                objectName: "tableFilePath"
                placeholderText: tools.localizedTexts.TableFilePath
            }
            ESelect {
                width: parent.width
                value: tools.fileFormat
                visible: tools.fileAction !== "print"
                model: ["csv", "xlsx", "tsv", "json", "html", "xml"]

                onChanged: tools.fileFormat = value
            }
            EText {
                width: parent.width
                wrapMode: Text.WordWrap
                text: tools.fileAction === "print" ? tools.localizedTexts.TablePdfHint : tools.localizedTexts.TableFileHint
            }
        }

        onAccepted: {
            const path = fileDialog.loadedContent.pathText.replace(/\\/g, "/")
            const url = path.indexOf("file:") === 0 ? path : "file:///" + path
            if (tools.fileAction === "import") tools.owner.importData(url, {type: tools.fileFormat})
            else if (tools.fileAction === "print") tools.owner.printData(url)
            else tools.owner.exportData(url, {type: tools.fileFormat})
        }
    }
    EDialog {
        id: chartDialog

        autofocus: false
        implicitWidth: 620
        showCancelButton: false
        showConfirmButton: false
        objectName: "tableChartDialog"
        title: tools.localizedTexts.TableChart
        contentComponent: Column {
            spacing: 12
            width: parent.width

            Row {
                spacing: 12

                ESelect {
                    id: chartLabels

                    width: 180
                    textRole: "label"
                    valueRole: "prop"
                    value: model.length ? model[0].prop : ""
                    model: tools.owner.columnModel.filter(function(column) { return Operations.field(column) })
                }
                ESelect {
                    id: chartValues

                    width: 180
                    textRole: "label"
                    valueRole: "prop"
                    value: model.length ? model[model.length - 1].prop : ""
                    model: tools.owner.columnModel.filter(function(column) { return Operations.field(column) })
                }
            }
            EChart {
                type: 1
                height: 280
                width: parent.width
                objectName: "tableChart"
                model: chartDialog.visible ? tools.owner.chartData(chartLabels.value, chartValues.value) : []
            }
        }
    }
}

import EUI 1.0
import "TableOperations.js" as Operations
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Loader {
    id: editor

    property var row
    property var owner
    property var column

    readonly property string kind: options.type || "text"
    readonly property var options: column.editRender || ({})
    readonly property var value: owner.editConfig.mode === "row" ? owner.editValues[Operations.field(column)] : owner.editValue

    function accept(value) {
        owner.setEditValue(column, value)
        if (owner.editConfig.mode !== "row")
            owner.commitEdit()
    }

    objectName: "tableCellEditor"
    sourceComponent: column.editDelegate || (kind === "select" ? selectEditor
        : kind === "checkbox" ? checkEditor : kind === "switch" ? switchEditor : kind === "date" ? dateEditor : textEditor)

    onLoaded: {
        if (item && "row" in item)
            item.row = row
        if (item && "column" in item)
            item.column = column
        if (item && "table" in item)
            item.table = owner
        if (item && "value" in item)
            item.value = value
        if (item && typeof item.forceActiveFocus === "function" && owner.editingCell
            && Operations.field(owner.editingCell.column) === Operations.field(column))
            item.forceActiveFocus()
    }

    Component {
        id: textEditor

        EInput {
            objectName: "tableEditInput"
            enabled: !editor.owner.validating
            validationMessage: editor.owner.cellError(editor.row, editor.column)
            validationState: validationMessage ? EValidationState.Error : EValidationState.None
            inputMethodHints: editor.kind === "number" ? Qt.ImhFormattedNumbersOnly : Qt.ImhNone
            text: editor.value === null || editor.value === undefined ? "" : String(editor.value)

            Keys.onEscapePressed: editor.owner.cancelEdit()
            onTextEdited: editor.owner.setEditValue(editor.column, text)
            Component.onCompleted: if (!editor.owner.typingEdit)
                selectAll()
            onAccepted: {
                editor.owner.setEditValue(editor.column, text)
                editor.owner.commitEdit()
            }
            Keys.onTabPressed: {
                editor.owner.setEditValue(editor.column, text)
                editor.owner.commitEdit().then(function(ok) { if (ok) editor.owner.navigateCell(0, 1, false) })
            }
        }
    }
    Component {
        id: selectEditor

        ESelect {
            value: editor.value
            objectName: "tableEditSelect"
            model: editor.options.options || []
            textRole: editor.options.textRole || "label"
            valueRole: editor.options.valueRole || "value"

            Keys.onEscapePressed: editor.owner.cancelEdit()
            onChanged: function(value) {
                editor.accept(value)
            }
        }
    }
    Component {
        id: checkEditor

        ECheckBox {
            checked: Boolean(editor.value)
            objectName: "tableEditCheckbox"

            onClicked: editor.accept(checked)
            Keys.onEscapePressed: editor.owner.cancelEdit()
        }
    }
    Component {
        id: switchEditor

        ESwitch {
            objectName: "tableEditSwitch"
            checked: Boolean(editor.value)

            onClicked: editor.accept(checked)
            Keys.onEscapePressed: editor.owner.cancelEdit()
        }
    }
    Component {
        id: dateEditor

        EDatePicker {
            value: editor.value
            objectName: "tableEditDate"
            valueFormat: editor.options.valueFormat || "yyyy-MM-dd"

            Keys.onEscapePressed: editor.owner.cancelEdit()
            onValueChanged: if (value !== editor.value)
                editor.accept(value)
        }
    }
}

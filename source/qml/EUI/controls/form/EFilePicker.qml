import EUI 1.0
import EUI.Private 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Dialogs

EInput {
    id: control

    property var value: ""
    property url folder: ""
    property string mode: "open"
    property bool multiple: false
    property var nameFilters: ["All files (*)"]
    property string dialogTitle: EControlConfig.textFor(control,
        mode === "save" ? "PickerSaveFile" : mode === "folder" ? "PickerSelectFolder" : "SelectFiles", ELocale.texts)

    readonly property var dialog: internal.dialog
    readonly property string lastError: internal.lastError
    readonly property bool popupVisible: !!dialog && dialog.visible
    readonly property var selectedUrls: value && typeof value !== "string" && typeof value.length === "number"
        ? Array.prototype.slice.call(value) : value && String(value).length ? [value] : []

    signal rejected()
    signal picked(var value)
    signal selectionRejected(string reason)

    function close() {
        if (dialog)
            dialog.close()
    }

    function clear() {
        value = multiple && mode === "open" ? [] : ""
        internal.lastError = ""
    }

    function resetDialog() {
        if (dialog) {
            dialog.close()
            dialog.destroy()
            internal.dialog = null
        }
    }

    function open() {
        if (!enabled)
            return false
        if (["open", "save", "folder"].indexOf(mode) < 0) {
            internal.lastError = "invalid-mode"
            selectionRejected(internal.lastError)
            return false
        }
        if (!dialog)
            internal.dialog = (mode === "folder" ? folderDialogComponent : fileDialogComponent).createObject(control)
        if (!dialog)
            return false
        internal.lastError = ""
        dialog.open()
        return true
    }

    function acceptSelection(urls) {
        if (!enabled)
            return false
        const values = urls && typeof urls !== "string" && typeof urls.length === "number"
            ? Array.prototype.slice.call(urls) : [urls]
        const selection = pickerFiles.selection(values, mode, multiple)
        if (!selection.valid) {
            internal.lastError = selection.reason
            selectionRejected(internal.lastError)
            return false
        }
        internal.lastError = ""
        value = multiple && mode === "open" ? Array.prototype.slice.call(selection.urls) : selection.urls[0]
        picked(value)
        return true
    }

    readOnly: true
    clearable: true
    implicitWidth: 320
    placeholderText: dialogTitle
    text: selectedUrls.map(function(url) { return pickerFiles.filePath(String(url)) }).join("; ")
    appendComponent: ETextButton {
        minHeight: 0
        implicitWidth: 34
        height: control.height
        iconSource: EIcons.ELLIPSIS
        objectName: "filePickerBrowse"
        accessibleName: EControlConfig.textFor(control, "PickerBrowse", ELocale.texts)

        onClicked: control.open()
    }

    onCleared: clear()
    Keys.onReturnPressed: open()
    onModeChanged: resetDialog()
    onMultipleChanged: resetDialog()
    onEnabledChanged: if (!enabled)
        close()

    PickerFileUtils { id: pickerFiles }
    QtObject {
        id: internal

        property var dialog: null
        property string lastError: ""
    }
    Component {
        id: fileDialogComponent

        FileDialog {
            currentFolder: control.folder
            title: control.dialogTitle
            nameFilters: control.nameFilters
            fileMode: control.mode === "save" ? FileDialog.SaveFile
                : control.multiple ? FileDialog.OpenFiles : FileDialog.OpenFile

            onRejected: control.rejected()
            onAccepted: control.acceptSelection(selectedFiles)
        }
    }

    Component {
        id: folderDialogComponent

        FolderDialog {
            currentFolder: control.folder
            title: control.dialogTitle

            onRejected: control.rejected()
            onAccepted: control.acceptSelection([selectedFolder])
        }
    }
}

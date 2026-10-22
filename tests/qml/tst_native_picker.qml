import EUI 1.0
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function initTestCase() {
        if (!testNativeDialogsAvailable)
            skip("Native dialogs require the desktop driver; the background suite uses offscreen.")
    }

    function test_nativeDialog_data() {
        return [
            {tag: "open", mode: "open", action: "open"},
            {tag: "multiple", mode: "open", action: "multiple", multiple: true},
            {tag: "save", mode: "save", action: "save"},
            {tag: "folder", mode: "folder", action: "folder"},
            {tag: "cancel", mode: "open", action: "cancel"},
            {tag: "close", mode: "open", action: "close"}
        ]
    }

    function test_nativeDialog(data) {
        if (!testNativeDialogsAvailable) {
            skip("The current background platform lacks this native capability.")
            return
        }
        const picker = createTemporaryObject(data.mode === "folder" ? folderComponent : pickerComponent, testCase, {
            width: 400, height: 32, mode: data.mode, multiple: !!data.multiple,
            dialogTitle: "EUI native picker " + data.action,
            folder: Qt.resolvedUrl("."), value: Qt.resolvedUrl("tst_native_picker.qml")
        })
        verify(picker !== null)
        const picked = createTemporaryObject(spyComponent, testCase, {target: picker, signalName: "picked"})
        const rejected = createTemporaryObject(spyComponent, testCase, {target: picker, signalName: "rejected"})
        verify(picker.open())
        tryCompare(picker, "popupVisible", true)
        if (data.action === "close") {
            wait(400)
            picker.close()
            tryCompare(picker, "popupVisible", false)
            compare(picked.count, 0)
            compare(String(picker.value), String(Qt.resolvedUrl("tst_native_picker.qml")))
        } else if (data.action === "cancel") {
            tryCompare(rejected, "count", 1, 15000)
            compare(picked.count, 0)
            compare(String(picker.value), String(Qt.resolvedUrl("tst_native_picker.qml")))
        } else {
            tryCompare(picked, "count", 1, 15000)
            compare(rejected.count, 0)
            compare(picker.lastError, "")
            const urls = picker.selectedUrls.map(String)
            const expected = data.action === "folder" ? [String(Qt.resolvedUrl("..")).replace(/\/$/, "")]
                : data.action === "save" ? [String(Qt.resolvedUrl("../native-picker-save.tmp"))]
                : data.action === "multiple" ? [String(Qt.resolvedUrl("tst_native_picker.qml")), String(Qt.resolvedUrl("tst_cpp_table.qml"))]
                : [String(Qt.resolvedUrl("tst_native_picker.qml"))]
            compare(urls.sort(), expected.sort())
        }
        tryCompare(picker, "popupVisible", false)
        wait(750)
    }

    width: 640
    height: 480
    visible: true
    when: windowShown
    name: "NativePicker"

    Component {
        id: spyComponent

        SignalSpy {}
    }
    Component {
        id: folderComponent

        EFolderPicker {}
    }
    Component {
        id: pickerComponent

        EFilePicker {}
    }
}

import EUI 1.0
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Controls 2.15

TestCase {
    id: testCase

    property var pendingValidation: null

    function cleanup() {
        ETheme.setDark(false)
        pendingValidation = null
    }

    function test_folderPreset() {
        const picker = createTemporaryObject(folderComponent, testCase)
        compare(picker.mode, "folder")
        verify(picker.acceptSelection([Qt.resolvedUrl(".")]))
        verify(!Array.isArray(picker.value))
    }

    function test_toolbarNativeAction() {
        const toolbar = createTemporaryObject(nativeToolbarComponent, testCase)
        verify(waitForItemPolished(toolbar))
        mouseClick(findChild(toolbar, "toolbarAction0"))
        compare(toolbar.nativeCount, 1)
        compare(toolbar.commandCount, 1)
        verify(toolbar.actionObject.checked)
        verify(toolbar.trigger(0))
        compare(toolbar.nativeCount, 2)
        compare(toolbar.commandCount, 2)
        verify(!toolbar.actionObject.checked)
    }

    function test_wizardRejectedJump() {
        const wizard = createTemporaryObject(wizardComponent, testCase, {allowJump: true})
        verify(waitForItemPolished(wizard))
        const steps = findChild(wizard, "wizardSteps")
        wizard.beforeLeave = function() { return false }
        verify(steps.select(2))
        compare(wizard.currentIndex, 0)
        compare(steps.active, 0)
        wizard.beforeLeave = null
        verify(steps.select(2))
        compare(wizard.currentIndex, 2)
        compare(steps.active, 2)
        verify(wizard.previous())
        compare(steps.active, 0)
    }

    function test_invalidModels() {
        const toolbar = createTemporaryObject(toolbarComponent, testCase, {model: [null, 42, "invalid"]})
        compare(toolbar.items.length, 0)
        verify(!toolbar.trigger(0))
        const palette = createTemporaryObject(paletteComponent, testCase, {model: [null, 42, "invalid"]})
        compare(palette.filteredItems.length, 0)
        verify(!palette.trigger(0))
        const wizard = createTemporaryObject(wizardComponent, testCase, {model: [null, 42, "invalid"]})
        compare(wizard.currentIndex, -1)
        compare(wizard.currentPage, null)
        verify(!wizard.next())
        verify(!wizard.finish())
    }

    function test_wizardAsyncInvalidation() {
        const wizard = createTemporaryObject(wizardComponent, testCase)
        wizard.beforeLeave = function() {
            return new Promise(function(resolve) { testCase.pendingValidation = resolve })
        }
        verify(wizard.next())
        verify(wizard.busy)
        verify(!wizard.next())
        pendingValidation(false)
        tryCompare(wizard, "busy", false)
        compare(wizard.currentIndex, 0)
        verify(wizard.next())
        pendingValidation(true)
        tryCompare(wizard, "currentIndex", 2)
        wizard.reset()
        verify(wizard.next())
        wizard.enabled = false
        pendingValidation(true)
        wait(0)
        compare(wizard.currentIndex, 0)
        compare(wizard.busy, false)
    }

    function test_fileSelection(data) {
        const picker = createTemporaryObject(pickerComponent, testCase,
            {mode: data.mode, multiple: !!data.multiple})
        const original = picker.value
        compare(picker.acceptSelection(data.values), data.valid)
        if (data.valid) {
            compare(picker.selectedUrls.length, data.tag === "multiple" ? 2 : 1)
            verify(picker.text.length > 0)
            compare(picker.lastError, "")
            picker.clear()
            compare(picker.selectedUrls.length, 0)
        } else {
            compare(picker.value, original)
            verify(picker.lastError.length > 0)
        }
        picker.enabled = false
        verify(!picker.acceptSelection([Qt.resolvedUrl("tst_basic.qml")]))
        verify(!picker.open())
    }

    function test_wizardValidationErrors() {
        const wizard = createTemporaryObject(wizardComponent, testCase)
        wizard.beforeLeave = function() { throw new Error("validation failed") }
        verify(!wizard.next())
        compare(wizard.currentIndex, 0)
        compare(wizard.busy, false)
        wizard.beforeLeave = function() {
            return {then: function() { throw new Error("invalid promise") }}
        }
        verify(!wizard.next())
        compare(wizard.busy, false)
        wizard.beforeLeave = function() { return Promise.reject(new Error("request failed")) }
        verify(wizard.next())
        tryCompare(wizard, "busy", false)
        compare(wizard.currentIndex, 0)
        wizard.beforeLeave = null
        verify(wizard.next())
        compare(wizard.currentIndex, 2)
    }

    function test_paletteFilteringAndNavigation() {
        const palette = createTemporaryObject(paletteComponent, testCase)
        palette.open()
        tryCompare(palette, "opened", true)
        compare(palette.currentIndex, 0)
        palette.query = "文档 SAVE"
        compare(palette.filteredItems.length, 1)
        compare(palette.filteredItems[0].command, "save")
        palette.query = ""
        palette.currentIndex = 0
        verify(palette.moveSelection(1))
        compare(palette.currentIndex, 2)
        verify(!palette.trigger(1))
        verify(!palette.trigger(NaN))
        verify(palette.trigger(2))
        compare(palette.lastCommand, "save")
        tryCompare(palette, "visible", false)
        palette.open()
        tryCompare(palette, "opened", true)
        palette.query = "no matching command"
        compare(palette.filteredItems.length, 0)
        compare(palette.currentIndex, -1)
        verify(!palette.trigger(0))
        palette.close()
    }

    function test_wizardValidationAndRetention() {
        const wizard = createTemporaryObject(wizardComponent, testCase)
        verify(waitForItemPolished(wizard))
        tryVerify(function() { return wizard.currentPage !== null })
        wizard.currentPage.text = "preserved"
        const first = wizard.currentPage
        wizard.beforeLeave = function() { return false }
        verify(!wizard.next())
        compare(wizard.currentIndex, 0)
        wizard.beforeLeave = null
        verify(!wizard.finish())
        verify(wizard.next())
        compare(wizard.currentIndex, 2)
        tryVerify(function() { return wizard.currentPage !== first })
        verify(wizard.previous())
        compare(wizard.currentIndex, 0)
        compare(wizard.currentPage, first)
        compare(wizard.currentPage.text, "preserved")
        verify(wizard.next())
        verify(wizard.finish())
        verify(wizard.complete)
        verify(!wizard.next())
        wizard.reset()
        compare(wizard.currentIndex, 0)
        compare(wizard.complete, false)
    }

    function test_toolbarOverflowAndActions() {
        const toolbar = createTemporaryObject(toolbarComponent, testCase)
        verify(waitForItemPolished(toolbar))
        tryCompare(toolbar, "visibleCount", 3)
        verify(toolbar.trigger(0))
        compare(toolbar.triggeredCount, 1)
        verify(!toolbar.trigger(1))
        verify(!toolbar.trigger(-1))
        verify(!toolbar.trigger(0.5))
        toolbar.width = 90
        tryVerify(function() { return toolbar.visibleCount < 3 })
        const more = findChild(toolbar, "toolbarOverflow")
        verify(more.visible)
        compare(toolbar.overflowItems.length, 3 - toolbar.visibleCount)
        const toggleIndex = toolbar.items.length - 1
        verify(toolbar.trigger(toggleIndex))
        compare(toolbar.items[toggleIndex].checked, true)
        verify(toolbar.trigger(toggleIndex))
        compare(toolbar.items[toggleIndex].checked, false)
        toolbar.width = 600
        tryCompare(toolbar, "visibleCount", 3)
        compare(more.visible, false)
        toolbar.enabled = false
        verify(!toolbar.trigger(0))
    }

    function test_codeViewFormattingScrollingAndCopy() {
        const viewer = createTemporaryObject(codeComponent, testCase)
        viewer.code = 'EText {\n\ttext: "<script>&中文"\n}\n' + "long ".repeat(180) + "\n".repeat(50)
        verify(waitForItemPolished(viewer))
        tryVerify(function() { return viewer.viewport.contentWidth > viewer.viewport.width })
        verify(viewer.contentHeight > viewer.height)
        verify(viewer.textItem.text.indexOf("&lt;script&gt;") >= 0)
        verify(viewer.textItem.text.indexOf("<span") >= 0)
        compare(viewer.textItem.readOnly, true)
        viewer.viewport.contentX = 90
        viewer.viewport.contentY = 40
        viewer.code = "const value = 42"
        compare(viewer.viewport.contentX, 0)
        compare(viewer.viewport.contentY, 0)
        compare(viewer.lineCount, 1)
        const light = viewer.textItem.text
        ETheme.setDark(true)
        tryVerify(function() { return viewer.textItem.text !== light })
        verify(viewer.copy())
        pasteTarget.text = ""
        pasteTarget.paste()
        compare(pasteTarget.text, viewer.code)
        viewer.highlight = false
        compare(viewer.textItem.getText(0, viewer.textItem.length).replace(/\u00a0/g, " "), viewer.code)
    }

    function test_fileSelection_data() {
        return [{tag: "open", mode: "open", values: [Qt.resolvedUrl("tst_desktop_components.qml")], valid: true},
            {tag: "multiple", mode: "open", multiple: true, values: [Qt.resolvedUrl("tst_desktop_components.qml"),
                Qt.resolvedUrl("tst_basic.qml")], valid: true},
            {tag: "duplicates", mode: "open", values: [Qt.resolvedUrl("tst_basic.qml"), Qt.resolvedUrl("tst_basic.qml")], valid: true},
            {tag: "save", mode: "save", values: [Qt.resolvedUrl("未创建的 file.txt")], valid: true},
            {tag: "folder", mode: "folder", values: [Qt.resolvedUrl(".")], valid: true},
            {tag: "empty", mode: "open", values: [], valid: false},
            {tag: "remote", mode: "open", values: ["https://example.com/file.txt"], valid: false},
            {tag: "relative", mode: "open", values: ["tst_basic.qml"], valid: false},
            {tag: "missing", mode: "open", values: [Qt.resolvedUrl("does-not-exist.txt")], valid: false},
            {tag: "file-as-folder", mode: "folder", values: [Qt.resolvedUrl("tst_basic.qml")], valid: false},
            {tag: "folder-as-file", mode: "open", values: [Qt.resolvedUrl(".")], valid: false},
            {tag: "save-directory", mode: "save", values: [Qt.resolvedUrl(".")], valid: false},
            {tag: "save-missing-parent", mode: "save", values: [Qt.resolvedUrl("missing-directory/file.txt")], valid: false},
            {tag: "too-many", mode: "open", values: [Qt.resolvedUrl("tst_basic.qml"), Qt.resolvedUrl("tst_desktop_components.qml")], valid: false},
            {tag: "bad-mode", mode: "other", values: [Qt.resolvedUrl("tst_basic.qml")], valid: false}]
    }

    width: 700
    height: 520
    visible: true
    when: windowShown
    name: "DesktopComponents"

    TextEdit { id: pasteTarget }
    Component {
        id: pickerComponent

        EFilePicker {}
    }
    Component {
        id: folderComponent

        EFolderPicker {}
    }
    Component {
        id: codeComponent

        ECodeView {
            width: 400
            height: 180
        }
    }
    Component {
        id: toolbarComponent

        EToolBar {
            property int triggeredCount: 0

            width: 600
            model: [{text: "Open", handler: function() { ++triggeredCount }},
                {text: "Disabled", enabled: false}, {text: "Toggle", checkable: true}]
        }
    }
    Component {
        id: nativeToolbarComponent

        EToolBar {
            property int nativeCount: 0
            property int commandCount: 0

            readonly property alias actionObject: nativeAction

            width: 400
            model: [{action: nativeAction}]

            onCommand: ++commandCount

            Action {
                id: nativeAction

                text: "Save"
                checkable: true

                onTriggered: ++nativeCount
            }
        }
    }
    Component {
        id: paletteComponent

        ECommandPalette {
            property string lastCommand: ""

            shortcut: ""
            model: [{text: "Open", command: "open"}, {text: "Disabled", enabled: false},
                {text: "Save", command: "save", keywords: "document 文档"}]

            onCommand: function(value) {
                lastCommand = value
            }
        }
    }
    Component {
        id: wizardComponent

        EWizard {
            width: 560
            model: [{title: "First", component: pageComponent}, {title: "Disabled", disabled: true},
                {title: "Last", component: pageComponent}]

            Component {
                id: pageComponent

                EInput {}
            }
        }
    }
}

import EUI 1.0
import EUI.Private 1.0
import QtQuick 2.15
import QtTest 1.2

TestCase {
    function test_transferDisabledAndUnknown() {
        verify(transfer.move([1, 2, 999], true))
        compare(transfer.value, [1])
        verify(transfer.move([1], false))
        compare(transfer.value, [])
        transfer.enabled = false
        verify(!transfer.move([1], true))
        transfer.enabled = true
    }

    function test_otpNormalization() {
        otp.value = "12a34b567"
        compare(otp.value, "123456")
        otp.value = ""
        verify(!otp.inputAt(0, "x"))
        verify(otp.inputAt(0, "123456"))
        compare(otp.value, "123456")
        otp.length = 4
        compare(otp.value, "1234")
        otp.enabled = false
        verify(!otp.inputAt(0, "9"))
        otp.enabled = true
    }

    function test_timeOptions() {
        timeSelect.start = "09:00"
        timeSelect.end = "10:00"
        timeSelect.step = 30
        compare(timeSelect.count, 3)
        timeSelect.minTime = "09:00"
        compare(timeSelect.count, 2)
        timeSelect.step = 0
        compare(timeSelect.count, 0)
        timeSelect.step = 30
        timeSelect.start = "invalid"
        compare(timeSelect.count, 0)
    }

    function test_otpNormalizesWhenNumericModeChanges() {
        otp.length = 6
        otp.numericOnly = false
        otp.value = "12ab34"
        otp.numericOnly = true
        compare(otp.value, "1234")
        otp.numericOnly = false
        compare(otp.value, "1234")
        otp.length = 4
        otp.value = "12ab34"
        compare(otp.value, "12ab")
        otp.numericOnly = true
        compare(otp.value, "12")
    }

    function test_tagsAndLimits() {
        verify(tags.addTag("  QML  "))
        compare(tags.value, ["QML"])
        verify(!tags.addTag("QML"))
        verify(!tags.addTag(" "))
        tags.max = 2
        verify(tags.addTag("Qt"))
        verify(!tags.addTag("C++"))
        verify(tags.removeTag(0))
        compare(tags.value, ["Qt"])
        tags.enabled = false
        verify(!tags.removeTag(0))
        tags.enabled = true
    }

    function test_timeSelectRejectsInvalidBounds() {
        timeSelect.start = "09:00"
        timeSelect.end = "10:00"
        timeSelect.step = 30
        timeSelect.minTime = "invalid"
        timeSelect.maxTime = ""
        compare(timeSelect.count, 0)
        timeSelect.minTime = ""
        timeSelect.maxTime = "10:60"
        compare(timeSelect.count, 0)
        timeSelect.maxTime = ""
        compare(timeSelect.count, 3)
    }

    function test_cascadeAndTree() {
        cascader.open()
        verify(cascader.selectLevel(0, 0))
        verify(cascader.selectLevel(1, 1))
        compare(cascader.value, ["east", "shanghai"])
        compare(cascader.selectedLabel, "华东 / 上海")
        compare(treeSelect.count, 3)
        treeSelect.value = "shanghai"
        compare(treeSelect.currentIndex, 2)
        treeSelect.leavesOnly = true
        compare(treeSelect.count, 2)
    }

    function test_otpKeyboardMovesBetweenCells() {
        otp.length = 6
        otp.value = ""
        const first = findChild(otp, "otpDigit0")
        first.forceActiveFocus()
        keyClick(Qt.Key_1)
        compare(otp.value, "1")
        compare(findChild(otp, "otpDigit1").activeFocus, true)
        keyClick(Qt.Key_2)
        compare(otp.value, "12")
        compare(findChild(otp, "otpDigit2").activeFocus, true)
        first.forceActiveFocus()
        keyClick(Qt.Key_9)
        compare(otp.value, "92")
    }

    function test_uploadRejectsInvalidEndpointAndMissingFile() {
        compare(uploader.fileInfo("file:///nonexistent-eui-file.txt").readable, false)
        verify(!uploader.submit("file:///nonexistent-eui-file.txt", ""))
        compare(uploadFinished.count, 1)
        compare(uploadFinished.signalArguments[0][1], false)
        compare(uploader.busy, false)
        verify(!upload.addFiles(["file:///nonexistent-eui-file.txt"]))
        compare(upload.fileList.length, 0)
        verify(!upload.upload(0))
    }

    function test_colorsAndDateTimeValidation() {
        verify(colors.selectColor("#67c23a"))
        compare(colors.value, "#67c23a")
        verify(!colors.selectColor("invalid"))
        colors.enabled = false
        verify(!colors.selectColor("#409eff"))
        colors.enabled = true
        verify(dateTime.selectDateTime("2024-02-29 23:59:59"))
        compare(dateTime.value, "2024-02-29 23:59:59")
        verify(!dateTime.selectDateTime("2025-02-29 10:00:00"))
        verify(!dateTime.selectDateTime("2026-10-10 24:00:00"))
    }

    function test_mentionReplacesOnlyActiveToken() {
        mention.text = "@Alice"
        mention.cursorPosition = 0
        compare(mention.matches.length, 0)
        verify(!mention.choose(0))
        mention.text = "Hello @Al"
        mention.cursorPosition = mention.text.length
        compare(mention.matches.length, 1)
        verify(mention.choose(0))
        compare(mention.text, "Hello @Alice ")
        mention.text = "Hello world"
        mention.cursorPosition = mention.text.length
        compare(mention.matches.length, 0)
        verify(!mention.choose(0))
    }

    function test_formTransformFailureAndReusablePattern() {
        ruleValidation.rules = [{ transform: function() {
            throw new Error("Transform failed")
        } }]
        compare(ruleValidation.validate(), false)
        compare(ruleValidation.validating, false)
        compare(ruleValidation.validationMessage, "Transform failed")
        ruleValidation.rules = [{ pattern: /^valid$/g }]
        compare(ruleValidation.validate(), true)
        compare(ruleValidation.validate(), true)
        compare(ruleValidation.validating, false)
        ruleValidation.rules = []
    }

    function test_groupsRespectSelectionLimits() {
        checkGroup.max = 2
        checkGroup.min = 1
        verify(checkGroup.toggle("QML", true))
        verify(!checkGroup.toggle("QML", false))
        verify(checkGroup.toggle("Qt", true))
        verify(!checkGroup.toggle("C++", true))
        verify(checkGroup.toggle("QML", false))
        compare(checkGroup.value, ["Qt"])
        verify(radioGroup.select("Qt"))
        compare(radioGroup.value, "Qt")
        radioGroup.enabled = false
        verify(!radioGroup.select("QML"))
        compare(radioGroup.value, "Qt")
        radioGroup.enabled = true
    }

    function test_emptyArrayModels() {
        const oldOptions = cascader.options
        cascader.options = null
        cascader.value = null
        cascader.open()
        compare(cascader.value, [])
        compare(cascader.selectedLabel, "")
        verify(!cascader.selectLevel(0, 0))
        cascader.options = oldOptions
        mention.options = null
        mention.text = "@"
        mention.cursorPosition = 1
        compare(mention.matches.length, 0)
        mention.options = ["Alice", "Bob"]
        const oldData = transfer.data
        transfer.data = null
        transfer.value = null
        verify(transfer.move([1], true))
        compare(transfer.value, [])
        transfer.data = oldData
    }

    function test_malformedModelsAreIgnored() {
        const oldChecks = checkGroup.options
        const oldRadios = radioGroup.options
        checkGroup.options = [null, undefined, "QML"]
        radioGroup.options = [null, undefined, "QML"]
        compare(checkGroup.effectiveOptions.length, 1)
        compare(radioGroup.effectiveOptions.length, 1)
        verify(!checkGroup.toggle("missing", true))
        verify(!radioGroup.select("missing"))
        checkGroup.options = oldChecks
        radioGroup.options = oldRadios
        mention.options = [null, {}, { label: "Alice", disabled: true }, "Bob"]
        mention.text = "@"
        mention.cursorPosition = 1
        compare(mention.matches.length, 1)
        mention.options = ["Alice", "Bob"]
        verify(!transfer.move(null, true))
        verify(!upload.addFiles(null))
        upload.fileList = null
        compare(upload.fileList, [])
    }

    function test_treeSelectDeepAndCyclicModels() {
        const nodes = []
        let branch = nodes
        for (let depth = 0; depth < 2000; ++depth) {
            const node = { label: String(depth), value: depth, children: [] }
            branch.push(node)
            branch = node.children
        }
        const flattened = EValueUtils.selectTreeOptions(nodes, "children", false)
        compare(flattened.length, 2000)
        compare(flattened[1999].level, 1999)
        compare(flattened[1999].label, "1999")
        compare(EValueUtils.selectTreeOptions(nodes, "children", true).length, 1)
        const cyclic = { label: "Cycle", value: "cycle", children: [] }
        cyclic.children.push(cyclic)
        compare(EValueUtils.selectTreeOptions([null, cyclic], "children", false).length, 1)
        compare(EValueUtils.selectTreeOptions([{ label: "Disabled", disabled: true,
            children: [{ label: "Child" }] }], "children", false).length, 0)
        compare(EValueUtils.selectTreeOptions(null, "children", false).length, 0)
        const oldData = treeSelect.data
        const oldLeaves = treeSelect.leavesOnly
        treeSelect.data = [{ label: "Parent", value: 1, nested: [{ label: "Child", value: 2 }] }]
        treeSelect.childrenRole = "nested"
        treeSelect.leavesOnly = false
        compare(treeSelect.count, 2)
        compare(treeSelect.textAt(1), "Child")
        treeSelect.childrenRole = "children"
        treeSelect.leavesOnly = oldLeaves
        treeSelect.data = oldData
    }

    width: 900
    height: 700
    visible: true
    when: windowShown
    name: "ExtendedForm"

    EInputTag { id: tags }
    EInputOtp {
        id: otp

        y: 50
    }
    ECheckBoxGroup {
        id: checkGroup

        y: 100
        options: ["QML", "Qt", "C++"]
    }
    ERadioGroup {
        id: radioGroup

        y: 150
        options: ["QML", "Qt"]
    }
    ECascader {
        id: cascader

        y: 200
        options: [{ label: "华东", value: "east", children: [
            { label: "杭州", value: "hangzhou" }, { label: "上海", value: "shanghai" }] }]
    }
    ETreeSelect {
        id: treeSelect

        y: 250
        data: cascader.options
    }
    ETimeSelect {
        id: timeSelect

        y: 300
    }
    ETransfer {
        id: transfer

        y: 350
        data: [{ key: 1, label: "可移动" }, { key: 2, label: "禁用", disabled: true }]
    }
    EColorPickerPanel {
        id: colors

        x: 550
        y: 200
    }
    EDateTimePicker {
        id: dateTime

        y: 50
        x: 550
    }
    EUpload {
        id: upload

        x: 550
        y: 500
    }
    FileUploader { id: uploader }
    SignalSpy {
        id: uploadFinished

        target: uploader
        signalName: "finished"
    }
    EMention {
        id: mention

        x: 550
        y: 650
        options: ["Alice", "Bob"]
    }
    EFormItem {
        id: ruleValidation

        visible: false

        EInput {
            text: "valid"
        }
    }
    EDatePicker {
        x: 550
        y: 100
    }
    EColorPicker {
        x: 550
        y: 150
    }
}

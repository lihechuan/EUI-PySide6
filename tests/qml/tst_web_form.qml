import EUI 1.0
import EUI 1.0 as FormControls
import EUI 1.0 as ConfigControls
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function test_namedColorFormatAndValidation() {
        const panel = createTemporaryObject(colorComponent, testCase, {colorFormat: "name"})
        verify(panel.selectColor("purple"))
        verify(panel.value.length > 0)
        verify(panel.selectColor("red"))
        compare(panel.value, "red")
        verify(!panel.selectColor("this-is-not-a-color"))
        const previous = panel.value
        verify(!panel.selectColor("rgb(300, 0, 0)"))
        compare(panel.value, previous)
    }

    function test_spinNativeBindingAndEditorRefresh() {
        const owner = createTemporaryObject(boundSpinComponent, testCase)
        const spin = findChild(owner, "webBoundSpin")
        const decimal = findChild(owner, "webBoundDecimal")
        compare(spin.value, 9)
        compare(decimal.numberValue, 9)
        owner.amount = 15
        compare(spin.value, 15)
        compare(spin.numberValue, 15)
        compare(decimal.numberValue, 15)
        compare(decimal.value, 1500)
        verify(spin.commitInput("12"))
        compare(spin.contentItem.text, "12")
        spin.value = 14
        compare(spin.contentItem.text, "14")
    }

    function test_dateTypes_data() {
        return [{tag: "date", type: "date", expected: "2026-10-20"},
            {tag: "week", type: "week", expected: "2026-10-19"},
            {tag: "month", type: "month", expected: "2026-10"},
            {tag: "year", type: "year", expected: "2026"},
            {tag: "dates", type: "dates", expected: ["2026-10-20"]},
            {tag: "months", type: "months", expected: ["2026-10"]},
            {tag: "years", type: "years", expected: ["2026"]},
            {tag: "quarter", type: "quarter", expected: "2026-Q4"},
            {tag: "quarters", type: "quarters", expected: ["2026-Q4"]}]
    }

    function test_selectSearchPopupInteraction() {
        const item = createTemporaryObject(selectComponent, testCase, { multiple: true, filterable: true })
        item.popup.open()
        tryVerify(function() {
            return findChild(item.popup, "selectSearchInput").activeFocus
        })
        const editor = findChild(item.popup, "selectSearchInput")
        editor.text = "Beta"
        item.query = editor.text
        const list = findChild(item.popup, "selectOptionList")
        tryCompare(list, "count", 1)
        keyClick(Qt.Key_Return)
        compare(item.value, [2])
        verify(item.popup.visible)
        item.popup.close()
    }

    function test_formScrollSlotsAndTypedModels() {
        const scroll = createTemporaryObject(formScrollComponent, testCase)
        const form = findChild(scroll, "webTestForm")
        const field = form.getField("amount")
        verify(field)
        verify(form.scrollToField("amount"))
        verify(scroll.contentY >= 200)
        verify(!form.scrollToField("missing"))
        compare(field.fieldValue, 1.25)
        field.field.numberValue = 2.5
        tryCompare(form.model, "amount", 2.5)
        field.error = "Custom error"
        verify(findChild(field, "webTestErrorSlot"))
        verify(findChild(field, "webTestLabelSlot"))
    }

    function test_colorPickerPublicTransactionAndClear() {
        const picker = createTemporaryObject(colorPickerComponent, testCase,
            {value: "#3267e8", commitOnConfirm: true})
        picker.show()
        const panel = picker.popup.contentItem
        verify(panel.selectColor("#f56c6c"))
        compare(picker.value, "#3267e8")
        verify(picker.cancel())
        compare(picker.value, "#3267e8")
        picker.show()
        panel.selectColor("#f56c6c")
        verify(picker.confirm())
        compare(picker.value, "#f56c6c")
        verify(!picker.popup.visible)
        verify(picker.clear())
        compare(picker.value, "")
        picker.value = "#14b8a6"
        compare(panel.value, "#14b8a6")
    }

    function test_dateRangeAndMultiple() {
        const item = createTemporaryObject(dateComponent, testCase, { type: "daterange" })
        verify(item.selectDate(new Date(2026, 9, 20)))
        compare(item.value, ["2026-10-20"])
        verify(item.selectDate(new Date(2026, 9, 10)))
        compare(item.value, ["2026-10-10", "2026-10-20"])
        item.type = "dates"
        verify(item.selectDate(new Date(2026, 9, 20)))
        verify(item.selectDate(new Date(2026, 9, 20)))
        compare(item.value, [])
        item.type = "monthrange"
        item.selectDate(new Date(2026, 4, 1))
        item.selectDate(new Date(2026, 2, 1))
        compare(item.value, ["2026-03", "2026-05"])
    }

    function test_colorCompactFormatsAndConfiguredClear() {
        const panel = createTemporaryObject(colorComponent, testCase, {showAlpha: true, colorFormat: "hex4"})
        verify(panel.selectColor("#0f08"))
        compare(panel.value, "#0f08")
        panel.colorFormat = "hex8"
        verify(panel.selectColor("#00ff0080"))
        compare(panel.value, "#00ff0080")
        panel.colorFormat = "prgb"
        verify(panel.selectColor("rgba(255, 0, 0, 0.5)"))
        compare(panel.value, "rgba(100%, 0%, 0%, 0.5)")
        const picker = createTemporaryObject(colorPickerComponent, testCase,
            {valueOnClear: function() {
                return null
            }})
        verify(picker.clear())
        compare(picker.value, null)
    }

    function test_dateTypes(data) {
        const item = createTemporaryObject(dateComponent, testCase, { type: data.type })
        verify(item.selectDate(new Date(2026, 9, 20)))
        compare(item.value, data.expected)
        item.minDate = "2026-10-10"
        item.maxDate = "2026-10-25"
        if (["date", "dates", "week"].indexOf(data.type) >= 0) {
            verify(!item.selectDate(new Date(2026, 9, 26)))
            item.disabledDate = function(date) {
                return date.getDate() === 21
            }
            verify(!item.selectDate(new Date(2026, 9, 21)))
        } else {
            verify(!item.selectDate(new Date(2027, 0, 1)))
            item.disabledDate = function(date) {
                return true
            }
            verify(!item.selectDate(new Date(2026, 9, 1)))
        }
    }

    function test_transferRolesFilterAndCheckAll() {
        const item = createTemporaryObject(transferComponent, testCase,
            {props: {key: "id", label: "name", disabled: "locked"},
                data: [{id: 1, name: "One"}, {id: 2, name: "Two", locked: true}, {id: 3, name: "Three"}]})
        compare(item.effectiveData[0].label, "One")
        const checkAll = findChild(item, "transferCheckAll")
        verify(checkAll)
        mouseClick(checkAll, 8, checkAll.height / 2)
        verify(item.move([1, 2, 3], true))
        compare(item.value, [1, 3])
        item.filterMethod = function(query, option) {
            return option.id === 3
        }
        const leftList = findChild(item, "transferList")
        compare(leftList.count, 0)
    }

    function test_cascaderMultipleStrictFilterAndValueOnly() {
        const item = createTemporaryObject(cascaderComponent, testCase)
        verify(item.commitPath(["root", "a"]))
        compare(item.value, [["root", "a"]])
        verify(!item.commitPath(["root"]))
        verify(!item.commitPath(["root", "disabled"]))
        item.checkStrictly = true
        verify(item.commitPath(["root"]))
        compare(item.value.length, 2)
        item.query = "Beta"
        compare(item.filteredPaths.length, 1)
        item.value = []
        item.emitPath = false
        verify(item.commitPath(["root", "b"]))
        compare(item.value, ["b"])
        compare(item.selectedLabel, "Root / Beta")
        verify(item.commitPath(["root", "b"]))
        compare(item.value, [])
    }

    function test_colorFormatsAndValidation() {
        const panel = createTemporaryObject(colorComponent, testCase, {showAlpha: true, colorFormat: "rgb"})
        verify(panel.selectColor("rgba(255, 0, 0, 0.5)"))
        verify(panel.value.indexOf("rgba(255, 0, 0,") === 0)
        verify(!panel.selectColor("rgb(999, 0, 0)"))
        verify(!panel.selectColor("rgba(0, 0, 0, 2)"))
        panel.colorFormat = "hsl"
        verify(panel.selectColor("hsl(120, 100%, 50%)"))
        compare(panel.value, "hsla(120, 100%, 50%, 1)")
        panel.colorFormat = "hsv"
        compare(panel.value, "hsva(120, 100%, 100%, 1)")
        panel.colorFormat = "hex"
        compare(panel.value, "#00ff00")
        verify(!panel.selectColor("not-a-color"))
    }

    function test_autocompleteRemoteAndInputFormatting() {
        const item = createTemporaryObject(autocompleteComponent, testCase, { debounce: 0 })
        item.fetchSuggestions = function(query, callback) {
            callback([{label: query + " result"}])
        }
        item.text = "Qt"
        tryVerify(function() {
            return item.suggestions.length === 1
        })
        compare(item.suggestions[0].label, "Qt result")
        verify(item.choose(0))
        const input = createTemporaryObject(inputComponent, testCase)
        input.parser = function(value) {
            return value.replace(/\$/g, "")
        }
        input.formatter = function(value) {
            return "$" + value
        }
        compare(input.formatInput("$12"), "$12")
        input.text = "hello"
        compare(input.wordCount, 5)
    }

    function test_mentionMultiplePrefixesAndWholeRemoval() {
        const item = createTemporaryObject(mentionComponent, testCase,
            {prefix: ["@", "#"], whole: true, options: [{label: "Alice"}, {label: "Bob"}]})
        item.text = "Hello #Al"
        item.cursorPosition = item.text.length
        compare(item.activePrefix, "#")
        compare(item.matches.length, 1)
        verify(item.choose(0))
        compare(item.text, "Hello #Alice ")
        verify(item.removeWhole())
        compare(item.text, "Hello ")
        item.props = {label: "name", disabled: "locked"}
        item.options = [{name: "Alice", locked: true}, {name: "Bob"}]
        item.text = "@"
        item.cursorPosition = 1
        compare(item.matches.length, 1)
        item.filterOption = false
        compare(item.matches.length, 1)
    }

    function test_uploadCanceledCallbacksAndDeferredRemove() {
        const item = createTemporaryObject(uploadComponent, testCase)
        item.fileList = [{url: "file:///a.txt", name: "a.txt", status: "ready"}]
        let options
        let aborted = false
        item.httpRequest = function(request) {
            options = request
            return {abort: function() {
                aborted = true
            }}
        }
        verify(item.upload(0))
        item.cancel()
        verify(aborted)
        compare(item.fileList[0].status, "ready")
        options.onSuccess("stale")
        compare(item.fileList[0].status, "ready")
        let remove
        item.beforeRemove = function() {
            return {then: function(resolve) {
                remove = resolve
            }}
        }
        item.removeFile(0)
        item.updateFile("file:///a.txt", "error", "retry")
        remove(true)
        compare(item.fileList.length, 0)
    }

    function test_selectMultipleFilteringAndLimits() {
        const item = createTemporaryObject(
            selectComponent,
            testCase,
            { multiple: true, filterable: true, multipleLimit: 2 }
        )
        verify(item.selectValue(1))
        verify(item.selectValue(2))
        verify(!item.selectValue(3))
        compare(item.value, [1, 2])
        verify(item.removeValue(1))
        compare(item.value, [2])
        item.query = "ga"
        compare(item.visibleOptions.length, 1)
        compare(item.visibleOptions[0].label, "Gamma")
        item.filterMethod = function(query, option) {
            return option.id === 1
        }
        compare(item.visibleOptions[0].label, "Alpha")
        item.filterMethod = null
        item.allowCreate = true
        item.query = "Custom"
        verify(item.selectValue("Custom"))
        compare(item.value, [2, "Custom"])
        item.clear()
        compare(item.value, [])
    }

    function test_treeChecksExpansionAndCustomRoles() {
        const item = createTemporaryObject(treeComponent, testCase)
        verify(item.checkNode("root", true))
        compare(item.value, ["a", "b"])
        compare(item.checkedState("root"), 2)
        verify(item.checkNode("a", false))
        compare(item.checkedState("root"), 1)
        verify(!item.checkNode("disabled", true))
        item.checkStrictly = true
        verify(item.checkNode("root", true))
        verify(item.isSelected("root"))
        item.defaultExpandAll = false
        compare(item.count, 1)
        verify(item.toggleExpanded("root"))
        compare(item.count, 3)
        item.data = [{name: "Parent", id: 10, nodes: [{name: "Child", id: 11}]}]
        item.nodeKey = "id"
        item.labelRole = "name"
        item.childrenRole = "nodes"
        compare(item.treeOptions[1].label, "Child")
        verify(item.checkNode(11, true))
    }

    function test_selectSingleCompatibilityAndLargePopup() {
        const item = createTemporaryObject(selectComponent, testCase)
        item.value = 2
        compare(item.currentIndex, 1)
        compare(item.currentText, "Beta")
        item.popup.open()
        const list = findChild(item.popup, "selectOptionList")
        tryCompare(list, "count", 3)
        list.currentIndex = 2
        list.positionViewAtIndex(2, ListView.Contain)
        wait(20)
        const option = list.itemAtIndex(2)
        verify(option)
        mouseClick(option, option.width / 2, option.height / 2)
        compare(item.value, 3)
        verify(!item.popup.visible)
        const options = []
        for (let index = 0; index < 10000; ++index)
            options.push({label: "Item " + index, id: index})
        item.model = options
        item.popup.open()
        tryCompare(list, "count", 10000)
        verify(list.contentItem.children.length < 100)
        item.popup.close()
    }

    function test_tagsSwitchAndRating() {
        const tags = createTemporaryObject(tagsComponent, testCase, { clearable: true })
        tags.addTag("Alpha")
        tags.addTag("Beta")
        verify(tags.moveTag(1, 0))
        compare(tags.value, ["Beta", "Alpha"])
        verify(tags.clear())
        compare(tags.value, [])
        const toggle = createTemporaryObject(switchComponent, testCase,
            { activeValue: "yes", inactiveValue: "no", value: "no", duration: 0 })
        toggle.beforeChange = function() {
            return false
        }
        mouseClick(toggle, 10, toggle.height / 2)
        compare(toggle.value, "no")
        toggle.beforeChange = function() {
            return true
        }
        mouseClick(toggle, 10, toggle.height / 2)
        compare(toggle.value, "yes")
        const rating = createTemporaryObject(rateComponent, testCase,
            { showScore: true, scoreTemplate: "{value}/5", value: 3 })
        verify(rating.width > 100)
    }

    function test_timeRangeAndDisabledParts() {
        const item = createTemporaryObject(timeComponent, testCase, { isRange: true })
        verify(item.selectRange("09:00:00", "10:00:00"))
        compare(item.value, ["09:00:00", "10:00:00"])
        verify(!item.selectRange("11:00:00", "10:00:00"))
        item.disabledHours = function() {
            return [10]
        }
        verify(!item.selectTime("10:00:00"))
        item.disabledMinutes = function(hour) {
            return hour === 9 ? [30] : []
        }
        verify(!item.selectTime("09:30:00"))
        item.minTime = "08:00:00"
        verify(!item.selectTime("07:59:59"))
        const datetime = createTemporaryObject(dateTimeComponent, testCase, { isRange: true })
        verify(datetime.selectDateTimeRange("2026-10-10 09:00:00", "2026-10-11 10:00:00"))
        verify(!datetime.selectDateTimeRange("2026-10-12 09:00:00", "2026-10-11 10:00:00"))
        verify(!datetime.selectDateTime("2026-02-30 10:00:00"))
    }

    function test_periodBoundsAndDateTimeDisabledHours() {
        const item = createTemporaryObject(dateComponent, testCase,
            {type: "month", minDate: "2026-10-10", maxDate: "2026-10-25"})
        verify(item.selectDate(new Date(2026, 9, 1)))
        compare(item.value, "2026-10")
        item.type = "year"
        verify(item.selectDate(new Date(2026, 0, 1)))
        compare(item.value, "2026")
        item.type = "quarterrange"
        item.minDate = ""
        item.maxDate = ""
        item.selectDate(new Date(2026, 9, 1))
        item.selectDate(new Date(2026, 0, 1))
        compare(item.value, ["2026-Q1", "2026-Q4"])
        compare(item.parseDate("2026-Q2").getMonth(), 3)
        const datetime = createTemporaryObject(dateTimeComponent, testCase,
            {disabledHours: function() {
                return [12]
            }, minTime: "08:00:00"})
        verify(!datetime.selectDateTime("2026-10-10 12:00:00"))
        verify(!datetime.selectDateTime("2026-10-10 07:00:00"))
        verify(datetime.selectDateTime("2026-10-10 09:00:00"))
    }

    function test_sliderMarksStopsAndOrientation() {
        const item = createTemporaryObject(sliderComponent, testCase,
            {from: 0, to: 100, stepSize: 25, showStops: true, marks: {0: "Start", 50: "Middle", 100: "End", 200: "Invalid"}})
        compare(item.markValues, [0, 50, 100])
        compare(item.stopValues, [25, 50, 75])
        compare(item.markPosition(50), 0.5)
        item.formatTooltip = function(value) {
            return value + "%"
        }
        compare(item.tooltipText(75), "75%")
        const label = findChild(item, "sliderMark")
        verify(label.y + label.height <= item.height)
        item.orientation = Qt.Vertical
        compare(item.markPosition(0), 1)
        compare(item.markPosition(100), 0)
        const range = createTemporaryObject(
            rangeComponent,
            testCase,
            {from: 0, to: 10, stepSize: 2, showStops: true}
        )
        compare(range.stopValues, [2, 4, 6, 8])
        range.second.value = 8
        range.first.value = 2
        compare(range.first.value, 2)
        compare(range.second.value, 8)
    }

    function test_decimalSpinBoxAndIntegerCompatibility() {
        const integer = createTemporaryObject(spinComponent, testCase, {from: -10, to: 20, value: 7})
        compare(integer.value, 7)
        compare(integer.numberValue, 7)
        integer.increase()
        compare(integer.value, 8)
        const decimal = createTemporaryObject(spinComponent, testCase,
            {precision: 2, numberFrom: -1.5, numberTo: 2.5, numberStep: 0.25, numberValue: 1.25, editable: true})
        compare(decimal.value, 125)
        compare(decimal.numberValue, 1.25)
        compare(decimal.stepSize, 25)
        decimal.increase()
        compare(decimal.numberValue, 1.5)
        decimal.numberValue = 50
        compare(decimal.numberValue, 2.5)
        decimal.numberValue = -50
        compare(decimal.numberValue, -1.5)
        compare(decimal.valueFromText("1.75", Qt.locale("en_US")), 175)
        compare(decimal.textFromValue(175, Qt.locale("en_US")), "1.75")
        compare(decimal.valueFromText("invalid", Qt.locale("en_US")), -150)
    }

    function test_selectGroupsObjectsAndRemoteRevisions() {
        const item = createTemporaryObject(selectComponent, testCase, { filterable: true })
        item.model = [{label: "Group A", options: [{label: "Alpha", id: 1}, {label: "Beta", id: 2}]},
            {label: "Disabled", disabled: true, options: [{label: "Gamma", id: 3}]}]
        compare(item.sourceOptions.length, 5)
        verify(item.selectValue(2))
        compare(item.value, 2)
        verify(!item.selectValue(3))
        let first
        let second
        item.remote = true
        item.remoteMethod = function(query) {
            return {then: function(resolve) {
                if (query === "first")
                    first = resolve
                else
                    second = resolve
            }}
        }
        item.query = "first"
        item.requestRemote()
        item.query = "second"
        item.requestRemote()
        second([{label: "New", id: 4}])
        first([{label: "Stale", id: 5}])
        compare(item.model[0].id, 4)
        compare(item.loading, false)
        item.multiple = true
        item.valueRole = ""
        item.valueKey = "id"
        verify(item.selectValue(item.model[0]))
        verify(item.isSelected({id: 4}))
    }

    function test_strictStepsSpinAdornmentsAndSliderInput() {
        const number = createTemporaryObject(spinComponent, testCase,
            {precision: 2, numberStep: 0.25, numberValue: 1.13, stepStrictly: true, prefix: "$", suffix: " USD", controlsPosition: "right", editable: true})
        compare(number.numberValue, 1.25)
        compare(number.textFromValue(125, Qt.locale("en_US")), "$1.25 USD")
        compare(number.valueFromText("$1.63 USD", Qt.locale("en_US")), 175)
        verify(number.down.indicator.x > number.width / 2)
        number.controls = false
        verify(!number.up.indicator.visible)
        const slider = createTemporaryObject(
            sliderComponent,
            testCase,
            {from: 0, to: 100, stepSize: 1, showInput: true, value: 25}
        )
        const editor = findChild(slider, "sliderInput")
        verify(editor)
        compare(editor.numberValue, 25)
        editor.numberValue = 40
        editor.numberModified(40)
        compare(slider.value, 40)
        slider.marks = {0: "0", 50: "50", 100: "100"}
        slider.step = "mark"
        slider.value = 65
        compare(slider.value, 50)
        slider.value = 85
        compare(slider.value, 100)
    }

    function test_uploadManualQueueHooksAndCustomRequest() {
        const item = createTemporaryObject(uploadComponent, testCase)
        item.fileList = [{url: "file:///a.txt", name: "a.txt", status: "ready"},
            {url: "file:///b.txt", name: "b.txt", status: "ready"}]
        const requests = []
        item.httpRequest = function(options) {
            requests.push(options)
            return {abort: function() {}}
        }
        item.beforeUpload = function(file) {
            return file.name !== "a.txt"
        }
        verify(!item.submit())
        tryCompare(requests, "length", 1)
        compare(requests[0].file.name, "b.txt")
        verify(item.uploading)
        requests[0].onSuccess("ok")
        compare(item.fileList[1].status, "success")
        verify(!item.uploading)
        item.beforeRemove = function() {
            return false
        }
        verify(!item.removeFile(1))
        item.beforeRemove = function() {
            return {then: function(resolve) {
                resolve(true)
            }}
        }
        verify(item.removeFile(1))
        compare(item.fileList.length, 1)
        item.accept = ".svg,image/png"
        verify(item.acceptsFile("icon.svg", "image/svg+xml"))
        verify(item.acceptsFile("image.png", "image/png"))
        verify(!item.acceptsFile("notes.txt", "text/plain"))
        item.clearFiles()
        compare(item.fileList, [])
    }

    function test_localLocaleAndFieldValidationSwitch() {
        const provider = createTemporaryObject(providerComponent, testCase,
            {locale: {name: "en", texts: {SelectAnOption: "Local option", AvailableItems: "Local available", Search2: "Local search"}}})
        const select = createTemporaryObject(selectComponent, provider)
        const transfer = createTemporaryObject(transferComponent, provider)
        compare(select.placeholderText, "Local option")
        compare(transfer.leftTitle, "Local available")
        compare(findChild(transfer, "transferSearch").placeholderText, "Local search")
        provider.locale = {name: "zh", texts: {SelectAnOption: "局部选择", AvailableItems: "局部可用", Search2: "局部搜索"}}
        tryCompare(select, "placeholderText", "局部选择")
        tryCompare(transfer, "leftTitle", "局部可用")
        const field = createTemporaryObject(validationSwitchComponent, testCase)
        compare(field.effectiveValidateEvent, false)
        field.field.text = ""
        wait(20)
        compare(field.validationState, EValidationState.None)
        field.field.validateEvent = true
        field.field.text = "ok"
        field.field.text = ""
        tryCompare(field, "validationState", EValidationState.Error)
    }

    function test_clearConfigurationAndSubmitSignal() {
        const item = createTemporaryObject(selectComponent, testCase, {valueOnClear: null})
        item.selectValue(1)
        item.clear()
        compare(item.value, null)
        verify(item.empty)
        item.emptyValues = [undefined]
        verify(!item.empty)
        const defaultCascade = createTemporaryObject(cascaderComponent, testCase, {multiple: false})
        defaultCascade.value = null
        compare(defaultCascade.value, [])
        defaultCascade.value = undefined
        compare(defaultCascade.value, [])
        const clearCascade = createTemporaryObject(cascaderComponent, testCase,
            {multiple: false, valueOnClear: function() {
                return null
            }})
        clearCascade.clearSelection()
        compare(clearCascade.value, null)
        const cascader = createTemporaryObject(
            cascaderComponent,
            testCase,
            {multiple: false, valueOnClear: null}
        )
        cascader.clearSelection()
        compare(cascader.value, null)
        const form = createTemporaryObject(formComponent, testCase, {model: {name: "EUI"}})
        let submitted
        form.submitted.connect(function(valid, model) {
            submitted = {valid: valid, model: model}
        })
        verify(form.submit())
        verify(submitted.valid)
        compare(submitted.model.name, "EUI")
    }

    function test_transferTargetOrderTreeCacheAndTagDrag() {
        const transfer = createTemporaryObject(transferComponent, testCase,
            {targetOrder: "unshift", data: [{key: 1, label: "One"}, {key: 2, label: "Two"}], leftFooter: slotText})
        transfer.move([1], true)
        transfer.move([2], true)
        compare(transfer.value, [2, 1])
        compare(transfer.targetData[0].key, 2)
        const tree = createTemporaryObject(treeComponent, testCase,
            {data: [], cacheData: [{value: "cached", label: "Cached"}], value: ["cached"]})
        compare(tree.labelFor("cached"), "Cached")
        const tags = createTemporaryObject(tagsComponent, testCase, {value: ["Alpha", "Beta"], width: 400})
        const repeater = findChild(tags, "inputTagRepeater")
        verify(repeater)
        const first = repeater.itemAt(0)
        const second = repeater.itemAt(1)
        const point = second.mapToItem(tags, second.width / 2, second.height / 2)
        const start = first.mapToItem(tags, first.width / 2, first.height / 2)
        mousePress(tags, start.x, start.y)
        mouseMove(tags, start.x + 16, start.y, 20)
        mouseMove(tags, point.x, point.y, 20)
        mouseRelease(tags, point.x, point.y)
        tryCompare(tags, "value", ["Beta", "Alpha"])
    }

    function test_markKeyboardAndCyclicGroups() {
        const slider = createTemporaryObject(sliderComponent, testCase,
            {from: 0, to: 100, value: 25, step: "mark", showInput: true, marks: {0: "0", 25: "25", 70: "70", 100: "100"}})
        slider.forceActiveFocus()
        keyClick(Qt.Key_Right)
        compare(slider.value, 70)
        keyClick(Qt.Key_Left)
        compare(slider.value, 25)
        keyClick(Qt.Key_End)
        compare(slider.value, 100)
        verify(findChild(slider, "sliderInput").visible)
        verify(!findChild(slider, "sliderInput").controls)
        const range = createTemporaryObject(rangeComponent, testCase,
            {from: 0, to: 100, step: "mark", marks: {0: "0", 25: "25", 70: "70", 100: "100"}})
        range.first.value = 0
        range.second.value = 70
        range.first.handle.forceActiveFocus()
        keyClick(Qt.Key_Right)
        compare(range.first.value, 25)
        range.second.handle.forceActiveFocus()
        keyClick(Qt.Key_Right)
        compare(range.second.value, 100)
        const group = {label: "Cyclic", options: []}
        group.options = [group, {label: "One", value: 1}]
        const select = createTemporaryObject(selectComponent, testCase,
            {textRole: "label", valueRole: "value", model: [group]})
        compare(select.sourceOptions.length, 2)
        verify(select.selectValue(1))
    }

    function test_lazyTreesAndCascaderLinkedChecks() {
        const tree = createTemporaryObject(treeComponent, testCase,
            {data: [{label: "Lazy", value: "root"}], lazy: true, defaultExpandAll: false})
        tree.load = function(node, resolve) {
            resolve([{label: "Child", value: "child", leaf: true}])
        }
        verify(tree.toggleExpanded("root"))
        compare(tree.treeOptions.length, 2)
        verify(tree.checkNode("root", true))
        compare(tree.value, ["child"])
        verify(!tree.toggleExpanded("child"))
        tree.toggleExpanded("root")
        compare(tree.labelFor("child"), "Child")
        const cascade = createTemporaryObject(cascaderComponent, testCase)
        verify(cascade.checkPath(["root"], true))
        compare(cascade.value, [["root", "a"], ["root", "b"]])
        compare(cascade.checkedState(["root"]), 2)
        cascade.checkPath(["root", "a"], false)
        compare(cascade.checkedState(["root"]), 1)
        cascade.lazy = true
        cascade.multiple = false
        cascade.options = [{label: "Lazy", value: "lazy"}]
        cascade.lazyLoad = function(node, resolve) {
            resolve([{label: "Leaf", value: "leaf", leaf: true}])
        }
        cascade.open()
        verify(cascade.selectLevel(0, 0))
        compare(cascade.nodePaths.length, 2)
        verify(cascade.selectLevel(1, 0))
        compare(cascade.value, ["lazy", "leaf"])
    }

    function test_colorTransactionsRateThresholdAndInputSlots() {
        const panel = createTemporaryObject(colorComponent, testCase,
            {showButtons: true, commitOnConfirm: true, value: "#ff0000"})
        let picked = ""
        panel.picked.connect(function(value) {
            picked = value
        })
        panel.begin()
        panel.selectColor("#00ff00")
        compare(picked, "")
        verify(panel.cancel())
        compare(panel.value, "#ff0000")
        panel.begin()
        panel.selectColor("#0000ff")
        verify(panel.confirm())
        compare(picked, "#0000ff")
        const rating = createTemporaryObject(rateComponent, testCase,
            {colors: {2: "red", 4: {value: "orange", excluded: true}, 5: "green"}, value: 4, halfIcon: EIcons.HEART_FILL})
        compare(String(rating.currentColor), "#008000")
        rating.value = 1
        compare(String(rating.currentColor), "#ff0000")
        rating.setCurrentValue(3.5)
        compare(rating.currentScore, 3.5)
        rating.resetCurrentValue()
        compare(rating.currentScore, 1)
        const input = createTemporaryObject(inputComponent, testCase,
            {prefixComponent: slotText, suffixComponent: slotText, prependComponent: slotText, appendComponent: slotText})
        verify(findChild(input, "inputPrefix").item)
        verify(findChild(input, "inputAppend").item)
        verify(input.leftPadding > 40)
        verify(input.rightPadding > 40)
    }

    function test_typedChoicesAndGroupRoleButtons() {
        const checkbox = createTemporaryObject(checkComponent, testCase,
            {trueValue: "yes", falseValue: "no", value: "no"})
        mouseClick(checkbox, 8, checkbox.height / 2)
        compare(checkbox.value, "yes")
        checkbox.value = "no"
        verify(!checkbox.checked)
        const standaloneRadio = createTemporaryObject(radioComponent, testCase,
            {value: "desktop", modelValue: "web"})
        verify(!standaloneRadio.checked)
        mouseClick(standaloneRadio, 8, standaloneRadio.height / 2)
        compare(standaloneRadio.value, "desktop")
        compare(standaloneRadio.modelValue, "desktop")
        standaloneRadio.modelValue = "web"
        verify(!standaloneRadio.checked)
        const group = createTemporaryObject(checkGroupComponent, testCase,
            {buttonStyle: true, max: 1, props: {value: "id", label: "name", disabled: "locked"},
                options: [{id: 1, name: "One"}, {id: 2, name: "Two"}, {id: 3, name: "Locked", locked: true}]})
        verify(group.toggle(1, true))
        verify(!group.toggle(2, true))
        verify(!group.toggle(3, true))
        compare(group.value, [1])
        const radio = createTemporaryObject(radioGroupComponent, testCase,
            {buttonStyle: true, props: {value: "id", label: "name", disabled: "locked"},
                options: [{id: "a", name: "Alpha"}, {id: "b", name: "Beta", locked: true}]})
        verify(radio.select("a"))
        verify(!radio.select("b"))
        compare(radio.value, "a")
    }

    function test_lazyChecksRetriesAndStaleNodes() {
        let resolve
        let reject
        const tree = createTemporaryObject(treeComponent, testCase,
            {lazy: true, defaultExpandAll: false, data: [{value: "p", label: "Parent"}],
                load: function(node, done, fail) {
                    resolve = done
                    reject = fail
                }})
        let failures = 0
        tree.loadFailed.connect(function() {
            ++failures
        })
        verify(tree.treeOptions[0].branch)
        verify(tree.checkNode("p", true))
        compare(tree.value, [])
        verify(!tree.loadNode("p"))
        reject("Offline")
        compare(failures, 1)
        verify(tree.checkNode("p", true))
        resolve([{value: "leaf", label: "Leaf", leaf: true}])
        compare(tree.value, ["leaf"])
        compare(tree.checkedState("p"), 2)
        tree.data = [{value: "old", label: "Old"}]
        tree.loadNode("old")
        const stale = resolve
        tree.data = [{value: "new", label: "New", leaf: true}]
        stale([{value: "stale", label: "Stale", leaf: true}])
        compare(tree.treeOptions.length, 1)
        compare(tree.treeOptions[0].value, "new")
        const cascade = createTemporaryObject(cascaderComponent, testCase,
            {lazy: true, options: [{value: "p", label: "Parent"}],
                lazyLoad: function(node, done) {
                    resolve = done
                }})
        verify(cascade.checkPath(["p"], true))
        compare(cascade.value, [])
        verify(!cascade.loadPath(["p"]))
        resolve([{value: "leaf", label: "Leaf", leaf: true}])
        compare(cascade.value, [["p", "leaf"]])
        cascade.checkStrictly = true
        verify(cascade.checkPath(["p"], true))
        const selected = cascade.value.slice(0)
        verify(cascade.checkPath(["p"], true))
        compare(cascade.value, selected)
    }

    function test_spinReadonlySlotsAndClearModel() {
        const number = createTemporaryObject(spinComponent, testCase,
            {precision: 2, editable: true, numberValue: 1.25, numberFrom: -10, numberTo: 20,
                prefixComponent: slotText, suffixComponent: slotText, placeholderText: "Amount"})
        verify(findChild(number, "spinBoxPrefix").item)
        verify(findChild(number, "spinBoxSuffix").item)
        verify(number.commitInput(""))
        compare(number.numberValue, null)
        verify(number.empty)
        number.valueOnClear = "min"
        verify(number.commitInput(""))
        compare(number.numberValue, -10)
        number.valueOnClear = "max"
        number.commitInput("")
        compare(number.numberValue, 20)
        number.disabledScientific = true
        verify(!number.commitInput("1e1"))
        compare(number.numberValue, 20)
        number.disabledScientific = false
        verify(number.commitInput("1e1"))
        compare(number.numberValue, 10)
        number.readOnly = true
        verify(!number.up.indicator.enabled)
        verify(!number.down.indicator.enabled)
        mouseClick(number.up.indicator, 8, number.up.indicator.height / 2)
        number.forceActiveFocus()
        keyClick(Qt.Key_Up)
        verify(!number.commitInput("5"))
        compare(number.numberValue, 10)
        const field = createTemporaryObject(decimalFieldComponent, testCase)
        wait(5)
        field.field.commitInput("")
        compare(field.fieldValue, null)
        verify(!field.validate())
        verify(field.resetField())
        compare(field.fieldValue, 1.25)
        const toggle = createTemporaryObject(switchComponent, testCase,
            {value: false, beforeChange: function() {
                return false
            }})
        verify(!toggle.requestChange(true))
        compare(toggle.value, false)
        compare(toggle.checked, false)
    }

    function test_lazyNestedChecksAndCanceledSelection() {
        let resolve
        const tree = createTemporaryObject(treeComponent, testCase,
            {lazy: true, data: [{value: "p", label: "Parent", children: [
                {value: "known", label: "Known", leaf: true}, {value: "nested", label: "Nested"}]}],
                load: function(node, done) {
                    resolve = done
                }})
        verify(tree.checkNode("p", true))
        compare(tree.value, [])
        verify(typeof resolve === "function")
        verify(tree.checkNode("known", false))
        resolve([{value: "deep", label: "Deep", leaf: true}])
        compare(tree.value, [])
        verify(tree.checkNode("p", true))
        compare(tree.value, ["known", "deep"])
        tree.data = [{value: "reset", label: "Reset"}]
        verify(tree.checkNode("reset", true))
        tree.clear()
        resolve([{value: "late", label: "Late", leaf: true}])
        compare(tree.value, [])
        const cascade = createTemporaryObject(cascaderComponent, testCase,
            {lazy: true, options: [{value: "p", label: "Parent", children: [
                {value: "known", label: "Known", leaf: true}, {value: "nested", label: "Nested"}]}],
                lazyLoad: function(node, done) {
                    resolve = done
                }})
        verify(cascade.checkPath(["p"], true))
        compare(cascade.value, [])
        verify(cascade.checkPath(["p"], false))
        resolve([{value: "deep", label: "Deep", leaf: true}])
        compare(cascade.value, [])
        verify(cascade.checkPath(["p"], true))
        compare(cascade.value, [["p", "known"], ["p", "nested", "deep"]])
        cascade.options = [{value: "reset", label: "Reset"}]
        verify(cascade.checkPath(["reset"], true))
        verify(cascade.checkPath(["reset"], false))
        cascade.clearSelection()
        resolve([{value: "late", label: "Late", leaf: true}])
        compare(cascade.value, [])
    }

    function test_customNodeTagChoiceSlotsAndSwitchGuard() {
        const select = createTemporaryObject(selectComponent, testCase,
            {multiple: true, value: [1], tagDelegate: tagSlot})
        verify(findChild(select, "webTagSlot"))
        const tree = createTemporaryObject(treeComponent, testCase, {nodeDelegate: treeSlot})
        tree.popup.open()
        const list = findChild(tree.popup, "selectOptionList")
        tryVerify(function() {
            return list.itemAtIndex(0) !== null && findChild(list.itemAtIndex(0), "webTreeSlot") !== null
        })
        tree.popup.close()
        const cascade = createTemporaryObject(cascaderComponent, testCase,
            {nodeDelegate: cascadeSlot, collapseTags: true, maxCollapseTags: 1})
        cascade.commitPath(["root", "a"])
        cascade.commitPath(["root", "b"])
        verify(cascade.selectedLabel.indexOf("+1") > 0)
        cascade.open()
        tryVerify(function() { return findChild(cascade.popup, "cascaderOptions").itemAtIndex(0) !== null
            && findChild(
                findChild(cascade.popup, "cascaderOptions").itemAtIndex(0),
                "webCascadeSlot"
            ) !== null })
        const group = createTemporaryObject(checkGroupComponent, testCase,
            {options: [{label: "One", value: 1}], optionDelegate: choiceSlot})
        verify(findChild(group, "webChoiceSlot"))
        const tags = createTemporaryObject(tagsComponent, testCase,
            {value: ["Alpha"], tagDelegate: tagSlot, prefixComponent: slotText, suffixComponent: slotText})
        verify(findChild(tags, "webTagSlot"))
        const toggle = createTemporaryObject(switchComponent, testCase,
            {value: false, activeIcon: EIcons.CHECK, inactiveIcon: EIcons.XMARK, activeColor: "red", inactiveColor: "blue", duration: 0})
        let resolve
        toggle.beforeChange = function() {
            return {then: function(callback) {
                resolve = callback
            }}
        }
        mouseClick(toggle, 8, toggle.height / 2)
        verify(toggle.loading)
        compare(toggle.value, false)
        toggle.enabled = false
        resolve(true)
        compare(toggle.value, false)
        verify(!toggle.loading)
    }

    width: 720
    height: 600
    visible: true
    when: windowShown
    name: "WebFormParity"

    Component {
        id: providerComponent

        ConfigControls.EConfigProvider {}
    }
    Component {
        id: colorPickerComponent

        FormControls.EColorPicker {}
    }
    Component {
        id: decimalFieldComponent

        FormControls.EFormItem {
            required: true

            FormControls.ESpinBox {
                precision: 2
                editable: true
                numberValue: 1.25
            }
        }
    }
    Component {
        id: validationSwitchComponent

        FormControls.EFormItem {
            required: true
            validateOnChange: true

            FormControls.EInput {
                text: "Initial"
                validateEvent: false
            }
        }
    }
    Component {
        id: selectComponent

        FormControls.ESelect {
            x: 24
            y: 24
            width: 280
            valueRole: "id"
            textRole: "label"
            model: [{label: "Alpha", id: 1}, {label: "Beta", id: 2}, {label: "Gamma", id: 3}]
        }
    }
    Component {
        id: treeComponent

        FormControls.ETreeSelect {
            x: 24
            y: 24
            multiple: true
            showCheckbox: true
            data: [{label: "Root", value: "root", children: [{label: "Alpha", value: "a"},
                {label: "Beta", value: "b"}, {label: "Disabled", value: "disabled", disabled: true}]}]
        }
    }
    Component {
        id: cascaderComponent

        FormControls.ECascader {
            multiple: true
            filterable: true
            separator: " / "
            options: [{label: "Root", value: "root", children: [{label: "Alpha", value: "a"},
                {label: "Beta", value: "b"}, {label: "Disabled", value: "disabled", disabled: true}]}]
        }
    }
    Component {
        id: dateComponent

        FormControls.EDatePickerPanel {}
    }
    Component {
        id: timeComponent

        FormControls.ETimePicker {}
    }
    Component {
        id: dateTimeComponent

        FormControls.EDateTimePicker {}
    }
    Component {
        id: uploadComponent

        FormControls.EUpload {}
    }
    Component {
        id: inputComponent

        FormControls.EInput {}
    }
    Component {
        id: tagsComponent

        FormControls.EInputTag {}
    }
    Component {
        id: switchComponent

        FormControls.ESwitch {}
    }
    Component {
        id: rateComponent

        FormControls.ERate {}
    }
    Component {
        id: autocompleteComponent

        FormControls.EAutocomplete {}
    }
    Component {
        id: boundSpinComponent

        Item {
            property int amount: 9

            FormControls.ESpinBox {
                to: 23
                editable: true
                value: parent.amount
                objectName: "webBoundSpin"
            }
            FormControls.ESpinBox {
                precision: 2
                numberValue: parent.amount
                objectName: "webBoundDecimal"
            }
        }
    }
    Component {
        id: spinComponent

        FormControls.ESpinBox {}
    }
    Component {
        id: sliderComponent

        FormControls.ESlider {
            width: 260
        }
    }
    Component {
        id: rangeComponent

        FormControls.ERangeSlider {
            width: 260
        }
    }
    Component {
        id: transferComponent

        FormControls.ETransfer {}
    }
    Component {
        id: mentionComponent

        FormControls.EMention {}
    }
    Component {
        id: formComponent

        FormControls.EForm {}
    }
    Component {
        id: colorComponent

        FormControls.EColorPickerPanel {}
    }
    Component {
        id: checkComponent

        FormControls.ECheckBox {
            text: "Check"
        }
    }
    Component {
        id: checkGroupComponent

        FormControls.ECheckBoxGroup {}
    }
    Component {
        id: radioComponent

        FormControls.ERadio {
            text: "Desktop"
        }
    }
    Component {
        id: radioGroupComponent

        FormControls.ERadioGroup {}
    }
    Component {
        id: slotText

        EText {
            text: "Slot"
        }
    }
    Component {
        id: formScrollComponent

        Flickable {
            width: 360
            height: 100
            contentHeight: 600

            FormControls.EForm {
                y: 300
                width: 340
                model: ({amount: 1.25})
                objectName: "webTestForm"

                FormControls.EFormItem {
                    prop: "amount"
                    width: parent.width
                    labelComponent: Component {
                        EText {
                            text: "Amount"
                            objectName: "webTestLabelSlot"
                        }
                    }
                    errorComponent: Component {
                        EText {
                            text: parent.message
                            objectName: "webTestErrorSlot"
                        }
                    }

                    FormControls.ESpinBox {
                        numberTo: 10
                        precision: 2
                        numberValue: 1.25
                    }
                }
            }
        }
    }
    Component {
        id: tagSlot

        EText {
            objectName: "webTagSlot"
            text: parent.tag !== undefined ? parent.tag : parent.label
        }
    }
    Component {
        id: treeSlot

        EText {
            text: parent.node.label
            objectName: "webTreeSlot"
        }
    }
    Component {
        id: cascadeSlot

        EText {
            text: parent.node.label
            objectName: "webCascadeSlot"
        }
    }
    Component {
        id: choiceSlot

        EText {
            text: parent.label
            objectName: "webChoiceSlot"
        }
    }
}

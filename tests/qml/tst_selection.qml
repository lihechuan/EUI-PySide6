import EUI 1.0
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Controls 2.15

TestCase {
    id: tests

    function test_ratingRejectsNonFiniteValues() {
        const previous = rating.value
        verify(!rating.setRating(NaN))
        verify(!rating.setRating(Infinity))
        compare(rating.value, previous)
    }

    function test_selectObjectInitialValue() {
        compare(objectSelection.currentIndex, 1)
        compare(objectSelection.currentText, "Second")
        compare(objectSelection.value, 2)
        objectSelection.value = 1
        compare(objectSelection.currentIndex, 0)
    }

    function formLabel(item) {
        const children = item.children || []
        for (let index = 0; index < children.length; ++index) {
            if (children[index].visible && children[index].text === "Email")
                return children[index]
            const label = formLabel(children[index])
            if (label)
                return label
        }
        return null
    }

    function test_selectTagsUseAvailableWidth_data() {
        return [
            {tag: "single", values: ["Archived projects"], collapse: false},
            {tag: "multiple", values: ["Archived projects", "Qt Quick desktop applications"], collapse: false},
            {tag: "collapsed", values: ["Archived projects", "Qt Quick desktop applications"], collapse: true}
        ]
    }

    function test_selectValueAndClear() {
        selection.currentIndex = 1
        compare(selection.currentText, "Beta")
        compare(selection.value, "Beta")
        selection.value = "Alpha"
        compare(selection.currentIndex, 0)
        selection.clear()
        compare(selection.currentIndex, -1)
        selection.model = []
        compare(selection.count, 0)
        selection.model = ["Alpha", "Beta"]
    }

    function test_ratingTextFitsControl_data() {
        return [
            {tag: "small-text", size: EStyle.Small, score: false},
            {tag: "medium-text", size: EStyle.Medium, score: false},
            {tag: "large-text", size: EStyle.Large, score: false},
            {tag: "small-score", size: EStyle.Small, score: true},
            {tag: "medium-score", size: EStyle.Medium, score: true},
            {tag: "large-score", size: EStyle.Large, score: true}
        ]
    }

    function test_autocompleteFiltering() {
        autocomplete.text = "Q"
        compare(autocomplete.suggestions.length, 2)
        verify(autocomplete.choose(1))
        compare(autocomplete.text, "Qt Quick")
        autocomplete.text = "missing"
        compare(autocomplete.suggestions.length, 0)
        verify(!autocomplete.choose(0))
        autocomplete.text = ""
        autocomplete.enabled = false
        verify(!autocomplete.choose(0))
        autocomplete.enabled = true
    }

    function test_ratingBoundariesAndKeyboard() {
        rating.value = 20
        compare(rating.value, 5)
        rating.value = -1
        compare(rating.value, 0)
        rating.allowHalf = true
        rating.forceActiveFocus()
        keyClick(Qt.Key_Right)
        compare(rating.value, 0.5)
        rating.readOnly = true
        verify(!rating.setRating(3))
        compare(rating.value, 0.5)
        rating.readOnly = false
        rating.clearable = true
        rating.setRating(0.5)
        compare(rating.value, 0)
    }

    function test_timeValidation() {
        verify(timePicker.selectTime("23:59:59"))
        compare(timePicker.value, "23:59:59")
        verify(!timePicker.selectTime("24:00:00"))
        verify(!timePicker.selectTime("12:60:00"))
        verify(!timePicker.selectTime("wrong"))
        timePicker.showSeconds = false
        verify(timePicker.selectTime("09:30"))
        timePicker.enabled = false
        verify(!timePicker.selectTime("10:30"))
        timePicker.enabled = true
    }

    function test_largeSelectUsesVisibleDelegates() {
        compare(largeSelection.count, 10000)
        largeSelection.popup.open()
        wait(50)
        const list = findChild(largeSelection.popup, "selectOptionList")
        compare(list.count, 10000)
        verify(list.contentItem.children.length < 50)
        verify(list.ScrollBar.vertical.visible)
        largeSelection.currentIndex = 9999
        compare(largeSelection.value, "Option 9999")
        largeSelection.popup.close()
    }

    function test_sliderInputFitsControl_data() {
        return [
            {tag: "small", size: EStyle.Small, marks: ({})},
            {tag: "medium", size: EStyle.Medium, marks: ({})},
            {tag: "large", size: EStyle.Large, marks: ({})},
            {tag: "small-marks", size: EStyle.Small, marks: ({0: "0%", 100: "100%"})},
            {tag: "medium-marks", size: EStyle.Medium, marks: ({0: "0%", 100: "100%"})},
            {tag: "large-marks", size: EStyle.Large, marks: ({0: "0%", 100: "100%"})}
        ]
    }

    function test_selectPopupOptionsFitViewport() {
        selection.popup.open()
        const list = findChild(selection.popup, "selectOptionList")
        verify(list !== null)
        tryVerify(function() {
            return list.itemAtIndex(0) !== null
        })
        const option = list.itemAtIndex(0)
        verify(option.width > 0)
        compare(option.x, 0)
        verify(option.x + option.width <= list.width)
        verify(option.contentItem.width > 0)
        verify(!list.ScrollBar.vertical.visible)
        selection.popup.close()
    }

    function test_formLabelAlignment_data() {
        return [
            {tag: "left-small", position: "left", size: EStyle.Small},
            {tag: "left-medium", position: "left", size: EStyle.Medium},
            {tag: "left-large", position: "left", size: EStyle.Large},
            {tag: "right-large", position: "right", size: EStyle.Large},
            {tag: "top-large", position: "top", size: EStyle.Large},
            {tag: "custom-left", position: "left", size: EStyle.Large, custom: true},
            {tag: "custom-top", position: "top", size: EStyle.Large, custom: true}
        ]
    }

    function test_dateValidationAndLimits() {
        verify(calendar.parseDate("2024-02-29") !== null)
        compare(calendar.parseDate("2025-02-29"), null)
        compare(calendar.parseDate("not-a-date"), null)
        calendar.minDate = "2026-01-10"
        calendar.maxDate = "2026-01-20"
        verify(!calendar.selectDate(new Date(2026, 0, 9)))
        verify(calendar.selectDate(new Date(2026, 0, 10)))
        compare(calendar.value, "2026-01-10")
        calendar.disabledDate = function(date) {
            return date.getDate() === 15
        }
        verify(!calendar.selectDate(new Date(2026, 0, 15)))
        calendar.enabled = false
        verify(!calendar.selectDate(new Date(2026, 0, 11)))
        calendar.enabled = true
    }

    function test_selectDisabledAndValidationPalette() {
        selection.enabled = false
        compare(selection.background.color, EPaletteManager.ThemePalette.surfaceDisabled(ETheme.dark))
        compare(selection.background.border.color, EPaletteManager.ThemePalette.borderDisabled(ETheme.dark))
        selection.enabled = true
        selection.validationState = EValidationState.Error
        compare(
            selection.background.border.color,
            EPaletteManager.StatePalette.validationColor(EValidationState.Error)
        )
        selection.enabled = false
        compare(selection.background.border.color, EPaletteManager.ThemePalette.borderDisabled(ETheme.dark))
        selection.enabled = true
        selection.validationState = EValidationState.None
    }

    function test_formLabelAlignment(data) {
        const control = createTemporaryObject(formItemComponent, tests, {
            size: data.size, labelPosition: data.position, labelComponent: data.custom
                ? customFormLabelComponent
                : null
        })
        verify(control !== null)
        wait(0)
        const label = formLabel(control)
        verify(label !== null)
        const field = control.field
        verify(field !== null)
        compare(field.height, EDefaultConfig.controlHeight(data.size))
        const labelCenter = label.mapToItem(control, 0, label.height / 2).y
        const fieldTop = field.mapToItem(control, 0, 0).y
        if (data.position === "top")
            verify(labelCenter < fieldTop)
        else
            fuzzyCompare(labelCenter, fieldTop + field.height / 2, 0.51)
        verify(field.height < control.height)
    }

    function test_selectTagsUseAvailableWidth(data) {
        const control = createTemporaryObject(
            multipleSelectComponent,
            tests,
            {value: data.values, collapseTags: data.collapse}
        )
        verify(control !== null)
        wait(0)
        const contents = control.contentItem.children
        const flow = contents[contents.length - 1]
        const children = flow.children
        let count = 0
        for (let index = 0; index < children.length; ++index) {
            const tag = children[index]
            if (!("label" in tag) || !tag.item)
                continue
            ++count
            fuzzyCompare(tag.width, Math.min(tag.item.implicitWidth, flow.width), 0.01)
            verify(tag.x + tag.width <= flow.width + 0.01)
            verify(tag.y + tag.height <= flow.height + 0.01)
        }
        compare(count, data.collapse ? 1 : data.values.length)
        verify(flow.height <= control.availableHeight + 0.01)
    }

    function test_sliderInputFitsControl(data) {
        const control = createTemporaryObject(sliderComponent, tests, {size: data.size, marks: data.marks})
        verify(control !== null)
        const editor = findChild(control, "sliderInput")
        verify(editor !== null)
        compare(editor.size, data.size)
        verify(editor.contentItem.width >= editor.contentItem.implicitWidth)
        verify(editor.y >= 0)
        verify(editor.y + editor.height <= control.height - control.bottomPadding + 0.01)
        compare(control.background.y + control.background.height / 2, editor.y + editor.height / 2)
        const height = control.implicitHeight
        control.visible = false
        compare(control.implicitHeight, height)
        control.visible = true
        control.showInput = false
        compare(control.implicitHeight, control.handleSize + control.topPadding + control.bottomPadding)
    }

    function test_shortcutCaptureCancelAndClear() {
        shortcut.sequence = ""
        shortcut.forceActiveFocus()
        keyClick(Qt.Key_Return)
        verify(shortcut.capturing)
        keyClick(Qt.Key_K, Qt.ControlModifier)
        compare(shortcut.sequence, EValueUtils.shortcutText(Qt.Key_K, Qt.ControlModifier))
        verify(shortcut.sequence.length > 0)
        verify(!shortcut.capturing)
        shortcut.capturing = true
        keyClick(Qt.Key_Escape)
        verify(!shortcut.capturing)
        verify(shortcut.sequence.length > 0)
        shortcut.capturing = true
        verify(!shortcut.captureKey(Qt.Key_Control, Qt.ControlModifier))
        verify(shortcut.capturing)
        shortcut.enabled = false
        verify(!shortcut.captureKey(Qt.Key_A, Qt.AltModifier))
        verify(!shortcut.capturing)
        shortcut.enabled = true
        shortcut.cleared()
        compare(shortcut.sequence, "")
        compare(EValueUtils.shortcutText(Qt.Key_unknown, 0), "")
    }

    function test_ratingTextFitsControl(data) {
        const control = createTemporaryObject(ratingComponent, tests, {
            size: data.size, value: 3, showText: !data.score, showScore: data.score,
            texts: ["Poor", "Fair", "Good", "Very good", "Excellent"], scoreTemplate: "{value}/5"
        })
        verify(control !== null)
        tryVerify(function() {
            return control.contentItem.implicitWidth > 0
        })
        const children = control.children
        let label = null
        for (let index = 0; index < children.length; ++index)
            if (children[index].text === (data.score ? "3/5" : "Good"))
                label = children[index]
        verify(label !== null)
        verify(label.x >= control.contentItem.x + control.contentItem.implicitWidth + control.spacing - 0.01)
        verify(label.x + label.width <= control.width + 0.01)
        control.width += 100
        compare(label.x, control.contentItem.x + control.contentItem.implicitWidth + control.spacing)
        verify(label.x + label.width <= control.width + 0.01)
    }

    function test_rangeSliderHasTwoUsableHandles() {
        range.from = 0
        range.to = 100
        range.stepSize = 5
        range.setValues(20, 80)
        compare(range.first.value, 20)
        compare(range.second.value, 80)
        verify(range.first.handle !== range.second.handle)
        verify(range.first.handle.width > 0)
        range.first.handle.forceActiveFocus()
        keyClick(Qt.Key_Right)
        compare(range.first.value, 25)
        compare(range.second.value, 80)
        range.second.handle.forceActiveFocus()
        keyClick(Qt.Key_Left)
        compare(range.first.value, 25)
        compare(range.second.value, 75)
        range.setValues(-10, 200)
        compare(range.first.value, 0)
        compare(range.second.value, 100)
        range.enabled = false
        const previousFirst = range.first.value
        const previousSecond = range.second.value
        keyClick(Qt.Key_Left)
        compare(range.first.value, previousFirst)
        compare(range.second.value, previousSecond)
        range.enabled = true
        range.orientation = Qt.Vertical
        range.width = 30
        range.height = 160
        compare(range.background.width, range.trackSize)
        range.orientation = Qt.Horizontal
        range.width = 160
        range.height = range.implicitHeight
    }

    function test_standardDateAndTimeUtilities() {
        const leapDay = EValueUtils.parseDate("2024-02-29")
        verify(leapDay instanceof Date)
        compare(EValueUtils.formatDate(leapDay), "2024-02-29")
        compare(EValueUtils.parseDate("2026-2-01"), null)
        compare(EValueUtils.parseDate("0099-01-01"), null)
        compare(EValueUtils.parseDate("2026-04-31"), null)
        verify(!EValueUtils.dateAllowed(new Date("invalid"), "", "", null))
        verify(!EValueUtils.dateAllowed(leapDay, "2024-2-01", "", null))
        verify(!EValueUtils.dateAllowed(leapDay, "", "invalid", null))
        verify(!EValueUtils.dateAllowed(leapDay, "2024-03-01", "2024-02-01", null))
        compare(EValueUtils.shiftMonth(2026, 11, 1).year, 2027)
        compare(EValueUtils.shiftMonth(2026, 11, 1).month, 0)
        compare(EValueUtils.shiftMonth(2026, 0, -1).year, 2025)
        compare(EValueUtils.shiftMonth(2026, 0, -1).month, 11)
        verify(!EValueUtils.validTime("9:30", false))
        verify(!EValueUtils.validTime("24:00", false))
        compare(EValueUtils.formatTime(9, 3, 4, true), "09:03:04")
        compare(EValueUtils.formatTime(9, 3, 4, false), "09:03")
        compare(EValueUtils.formatTime(24, 0, 0, true), "")
        compare(EValueUtils.parseTime("invalid", true).hour, 0)
        compare(EValueUtils.parseTime("23:59:58", true).second, 58)
    }

    width: 600
    height: 600
    visible: true
    name: "Selection"
    when: windowShown

    Component {
        id: customFormLabelComponent

        EText {
            text: "Email"
            font.pixelSize: 20
        }
    }
    Component {
        id: formItemComponent

        EFormItem {
            width: 400
            label: "Email"
            labelWidth: 80
            required: true
            helpText: "Details below the field"

            EInput {
                width: parent.width
            }
        }
    }
    Component {
        id: multipleSelectComponent

        ESelect {
            width: 320
            multiple: true
            model: ["Archived projects", "Qt Quick desktop applications"]
        }
    }
    Component {
        id: ratingComponent

        ERate {}
    }
    Component {
        id: sliderComponent

        ESlider {
            to: 100
            width: 400
            showInput: true
        }
    }
    ESelect {
        id: selection

        model: ["Alpha", "Beta"]
    }
    EAutocomplete {
        id: autocomplete

        y: 50
        model: ["QML", "Qt Quick", "Widgets"]
    }
    ERate {
        id: rating

        y: 100
    }
    EDatePickerPanel {
        id: calendar

        y: 150
    }
    ETimePicker {
        id: timePicker

        y: 480
    }
    ESelect {
        id: largeSelection

        x: 300
        model: {
            const values = []
            for (let index = 0; index < 10000; ++index)
                values.push("Option " + index)
            return values
        }
    }
    ESelect {
        id: objectSelection

        y: 50
        x: 300
        value: 2
        valueRole: "id"
        textRole: "label"
        model: [{ id: 1, label: "First" }, { id: 2, label: "Second" }]
    }
    ERangeSlider {
        id: range

        x: 300
        y: 520
    }
    EShortcutPicker {
        id: shortcut

        x: 300
        y: 560
    }
}

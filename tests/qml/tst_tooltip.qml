import EUI 1.0
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Controls 2.15

TestCase {
    id: testCase

    property string tipText: ""

    function init() {
        tipText = ""
        mouseMove(testCase, width - 8, height - 8)
        wait(0)
    }

    function test_popoverRejectsEmptyContent_data() {
        return [{tag: "empty", text: ""}, {tag: "whitespace", text: " \n\t "}]
    }

    function test_manualTriggerIgnoresKeyboard_data() {
        return [{tag: "tooltip", component: tooltipComponent}, {tag: "popover", component: popoverComponent}]
    }

    function test_validationControls_data() {
        return [{tag: "input", component: inputComponent}, {tag: "textarea", component: textareaComponent},
            {tag: "spinbox", component: spinboxComponent}]
    }

    function overlayHasPopup() {
        const overlay = Overlay.overlay
        for (let index = 0; index < overlay.children.length; ++index) {
            const child = overlay.children[index]
            if (child.visible && child.width > 0 && child.height > 0)
                return true
        }
        return false
    }

    function test_hoverTooltipConsumers_data() {
        return [{tag: "float-button", component: floatButtonComponent}, {tag: "slider", component: sliderComponent},
            {tag: "range-first", component: rangeComponent}, {tag: "range-second", component: rangeComponent}]
    }

    function test_automaticTriggers_data() {
        const rows = []
        for (const trigger of ["hover", "click", "focus", "contextmenu", "keyboard"]) {
            for (const content of ["", " \n\t ", "Tip"]) {
                rows.push({tag: trigger + "-" + (content === "Tip" ? "text" : content.length ? "whitespace" : "empty"),
                    trigger: trigger, text: content})
            }
        }
        return rows
    }

    function test_clearingContentClosesTooltip() {
        const reference = createTemporaryObject(referenceComponent, testCase)
        const tip = createTemporaryObject(tooltipComponent, testCase, {reference: reference, text: "Tip"})
        verify(tip.showForReference())
        tryCompare(tip, "visible", true)
        tip.text = ""
        tryCompare(tip, "visible", false)
        verify(!tip.showForReference())
    }

    function test_nativeOpeningRejectsEmptyContent() {
        const reference = createTemporaryObject(referenceComponent, testCase)
        const tip = createTemporaryObject(tooltipComponent, testCase, {reference: reference})
        tip.open()
        wait(50)
        compare(tip.visible, false)
        tip.visible = true
        wait(50)
        compare(tip.visible, false)
        tip.text = "Tip"
        tip.open()
        tryCompare(tip, "visible", true)
    }

    function test_clearingContentCancelsDelayedTooltip() {
        const reference = createTemporaryObject(referenceComponent, testCase)
        const tip = createTemporaryObject(tooltipComponent, testCase,
            {reference: reference, text: "Tip", showAfter: 100})
        verify(tip.showForReference())
        tip.text = ""
        wait(150)
        compare(tip.visible, false)
        tip.text = "Tip"
        verify(tip.showForReference())
        tryCompare(tip, "visible", true)
    }

    function test_manualTriggerIgnoresKeyboard(data) {
        const reference = createTemporaryObject(referenceComponent, testCase)
        const panel = createTemporaryObject(data.component, testCase,
            {reference: reference, trigger: "manual", text: "Tip"})
        verify(waitForRendering(reference))
        reference.forceActiveFocus()
        keyClick(Qt.Key_Space)
        wait(50)
        compare(panel.visible, false)
        panel.open()
        tryCompare(panel, "visible", true)
    }

    function test_popoverRejectsEmptyContent(data) {
        const reference = createTemporaryObject(referenceComponent, testCase)
        const panel = createTemporaryObject(popoverComponent, testCase,
            {reference: reference, text: data.text, title: data.text})
        verify(!panel.show())
        reference.clicked()
        wait(50)
        compare(panel.visible, false)
        panel.open()
        wait(50)
        compare(panel.visible, false)
        panel.visible = true
        wait(50)
        compare(panel.visible, false)
    }

    function test_popoverClearingContentClosesAndCancelsDelay() {
        const reference = createTemporaryObject(referenceComponent, testCase)
        const panel = createTemporaryObject(popoverComponent, testCase, {reference: reference, text: "Tip"})
        verify(panel.show())
        tryCompare(panel, "visible", true)
        panel.text = ""
        tryCompare(panel, "visible", false)
        panel.text = "Tip"
        panel.showAfter = 80
        verify(panel.show())
        panel.text = ""
        wait(120)
        compare(panel.visible, false)
    }

    function test_popoverContentVariants(data) {
        const reference = createTemporaryObject(referenceComponent, testCase)
        const panel = createTemporaryObject(data.component, testCase,
            Object.assign({reference: reference}, data.properties))
        verify(panel.show())
        tryCompare(panel, "visible", true)
        verify(waitForRendering(panel.background))
        if (data.tag === "component" || data.tag === "children")
            verify(findChild(panel.contentItem, "tooltipCustomContent") !== null)
    }

    function test_customContentWithoutText() {
        const reference = createTemporaryObject(referenceComponent, testCase)
        const tip = createTemporaryObject(tooltipComponent, testCase,
            {reference: reference, contentComponent: customContentComponent})
        verify(tip.showForReference())
        tryCompare(tip, "visible", true)
        verify(findChild(tip.contentItem, "tooltipCustomContent") !== null)
        tip.contentComponent = null
        tryCompare(tip, "visible", false)
        verify(!tip.showForReference())
    }

    function test_popoverContentVariants_data() {
        return [{tag: "text", component: popoverComponent, properties: {text: "Tip"}},
            {tag: "title", component: popoverComponent, properties: {title: "Title"}},
            {tag: "component", component: popoverComponent,
                properties: {contentComponent: customContentComponent, persistent: false}},
            {tag: "children", component: customPopoverComponent, properties: {}},
            {tag: "confirm", component: confirmComponent, properties: {title: "", text: ""}}]
    }

    function test_tableCellsWithoutErrorsDoNotShowTooltip() {
        const table = createTemporaryObject(tableComponent, testCase)
        verify(waitForItemPolished(table))
        const cell = findChild(table, "tableCell")
        verify(cell !== null)
        verify(waitForRendering(cell))
        mouseMove(cell, cell.width / 2, cell.height / 2)
        wait(50)
        const overlay = Overlay.overlay
        verify(overlay !== null)
        for (let index = 0; index < overlay.children.length; ++index) {
            const child = overlay.children[index]
            verify(!child.visible || child.width <= 0 || child.height <= 0)
        }
    }

    function test_leavingReferenceCancelsDelayedPopover() {
        const reference = createTemporaryObject(referenceComponent, testCase)
        const panel = createTemporaryObject(popoverComponent, testCase,
            {reference: reference, trigger: "hover", text: "Tip", showAfter: 80, hideAfter: 0})
        verify(waitForRendering(reference))
        mouseMove(reference, reference.width / 2, reference.height / 2)
        tryCompare(panel, "referenceHovered", true)
        mouseMove(testCase, width - 8, height - 8)
        tryCompare(panel, "referenceHovered", false)
        wait(120)
        compare(panel.visible, false)
    }

    function test_validationControls(data) {
        const field = createTemporaryObject(data.component, testCase, {validationState: EValidationState.Error})
        verify(waitForRendering(field))
        field.forceActiveFocus()
        const tip = findChild(field, "inputValidationTooltip")
        verify(tip !== null)
        for (const message of ["", " \n\t ", "Problem", ""]) {
            field.validationMessage = message
            tryCompare(tip, "visible", message === "Problem")
        }
        field.validationMessage = "Problem"
        tryCompare(tip, "visible", true)
        field.validationState = EValidationState.Success
        tryCompare(tip, "visible", false)
    }

    function test_hoverTooltipConsumers(data) {
        const item = createTemporaryObject(data.component, testCase)
        verify(waitForRendering(item))
        const range = data.tag.indexOf("range-") === 0
        const target = range ? (data.tag === "range-first" ? item.first.handle : item.second.handle) : item
        if (range)
            mousePress(target, target.width / 2, target.height / 2)
        else
            mouseMove(target, target.width / 2, target.height / 2)
        for (const text of ["", " \n\t ", "Value", ""]) {
            tipText = text
            tryVerify(function() { return overlayHasPopup() === (text === "Value") })
        }
        if (range)
            mouseRelease(target, target.width / 2, target.height / 2)
    }

    function test_automaticTriggers(data) {
        const reference = createTemporaryObject(referenceComponent, testCase)
        const tip = createTemporaryObject(tooltipComponent, testCase,
            {reference: reference, trigger: data.trigger === "keyboard" ? "click" : data.trigger, text: data.text})
        verify(waitForRendering(reference))
        if (data.trigger === "hover")
            mouseMove(reference, reference.width / 2, reference.height / 2)
        else if (data.trigger === "click")
            reference.clicked()
        else if (data.trigger === "focus")
            reference.forceActiveFocus()
        else if (data.trigger === "contextmenu")
            mouseClick(reference, reference.width / 2, reference.height / 2, Qt.RightButton)
        else {
            reference.forceActiveFocus()
            keyClick(Qt.Key_Space)
        }
        if (data.text === "Tip") {
            tryCompare(tip, "visible", true)
            verify(tip.width > tip.leftPadding + tip.rightPadding)
            verify(waitForRendering(tip.background))
            const image = grabImage(tip.background)
            verify(image.alpha(Math.floor(image.width / 2), Math.floor(image.height / 2)) > 0)
        } else {
            wait(50)
            compare(tip.visible, false)
            verify(!tip.showForReference())
        }
    }

    width: 640
    height: 480
    visible: true
    name: "Tooltip"
    when: windowShown

    Component {
        id: referenceComponent

        EButton {
            x: 160
            y: 160
            height: 32
            width: 120
            text: "Reference"
        }
    }
    Component {
        id: tooltipComponent

        EToolTip {
            delay: 0
            timeout: -1
            exit: Transition {}
            enter: Transition {}
        }
    }
    Component {
        id: popoverComponent

        EPopover {
            exit: Transition {}
            enter: Transition {}
        }
    }
    Component {
        id: customPopoverComponent

        EPopover {
            EText {
                text: "Custom content"
                objectName: "tooltipCustomContent"
            }
        }
    }
    Component {
        id: confirmComponent

        EPopconfirm {}
    }
    Component {
        id: inputComponent

        EInput { width: 240 }
    }
    Component {
        id: textareaComponent

        ETextArea { width: 240 }
    }
    Component {
        id: spinboxComponent

        ESpinBox { width: 240 }
    }
    Component {
        id: floatButtonComponent

        EFloatButton {
            x: 160
            y: 160
            hoverEnabled: true
            tooltip: testCase.tipText
        }
    }
    Component {
        id: sliderComponent

        ESlider {
            x: 160
            y: 160
            width: 240
            hoverEnabled: true
            formatTooltip: function(value) { return testCase.tipText }
        }
    }
    Component {
        id: rangeComponent

        ERangeSlider {
            x: 160
            y: 160
            width: 240
            first.value: 0.25
            second.value: 0.75
            formatTooltip: function(value) { return testCase.tipText }
        }
    }
    Component {
        id: customContentComponent

        EText {
            text: "Custom content"
            objectName: "tooltipCustomContent"
        }
    }
    Component {
        id: tableComponent

        ETable {
            y: 120
            width: 520
            height: 260
            model: [{name: "Alice"}]
            columns: [{prop: "name", label: "Name", width: 260}]
        }
    }
}

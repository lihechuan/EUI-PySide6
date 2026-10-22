import EUI 1.0
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Window 2.15

TestCase {
    id: testCase

    function cleanup() {
        ETheme.setDark(false)
    }

    function test_inputAddonsPreserveBorder_data() {
        return [{tag: "light", dark: false}, {tag: "dark", dark: true}]
    }

    function test_spinBoxStepButtons_data() {
        return [{tag: "both", position: "both"}, {tag: "right", position: "right"}]
    }

    function test_popupHoverPreservesBorder_data() {
        const cases = []
        for (const dark of [false, true]) {
            for (const kind of ["select", "multiple", "tree", "time", "autocomplete", "cascader", "mention"])
                cases.push({tag: kind + (dark ? "-dark" : "-light"), kind: kind, dark: dark})
        }
        return cases
    }

    function test_spinBoxCornersMatchBackground_data() {
        const cases = []
        for (const dark of [false, true]) {
            for (const size of [EStyle.Small, EStyle.Medium, EStyle.Large]) {
                for (const position of ["both", "right"]) {
                    for (const state of ["normal", "disabled", "readOnly", "focus", "error"])
                        cases.push({tag: [dark, size, position, state].join("-"),
                            dark: dark, size: size, position: position, state: state})
                }
            }
        }
        return cases
    }

    function test_spinBoxStepButtons(data) {
        const spin = createTemporaryObject(spinComponent, testCase, {controlsPosition: data.position, value: 1})
        mouseClick(spin.up.indicator)
        compare(spin.value, 2)
        mouseClick(spin.down.indicator)
        compare(spin.value, 1)
        spin.value = spin.from
        verify(!spin.down.indicator.enabled)
        mouseClick(spin.down.indicator)
        compare(spin.value, spin.from)
        spin.value = spin.to
        verify(!spin.up.indicator.enabled)
        mouseClick(spin.up.indicator)
        compare(spin.value, spin.to)
    }

    function test_inputAddonsPreserveBorder(data) {
        ETheme.setDark(data.dark)
        const input = createTemporaryObject(inputComponent, testCase)
        verify(waitForItemPolished(input))
        input.Window.window.update()
        verify(waitForRendering(input))
        const image = grabImage(input)
        verify(image.width > 0)
        const border = input.background.border.color
        for (const point of [[0, image.height / 2], [image.width - 1, image.height / 2],
                [10, 0], [image.width - 10, 0], [10, image.height - 1], [image.width - 10, image.height - 1]]) {
            verify(Math.abs(image.red(point[0], point[1]) - Math.round(border.r * 255)) <= 2,
                "Input addons must preserve the outer border at " + point
                    + "; actual=" + image.pixel(point[0], point[1]) + "; expected=" + border
                    + "; image=" + image.width + "x" + image.height)
            verify(Math.abs(image.green(point[0], point[1]) - Math.round(border.g * 255)) <= 2)
            verify(Math.abs(image.blue(point[0], point[1]) - Math.round(border.b * 255)) <= 2)
            compare(image.alpha(point[0], point[1]), 255)
        }
    }

    function test_spinBoxCornersMatchBackground(data) {
        ETheme.setDark(data.dark)
        const spin = createTemporaryObject(spinComponent, testCase, {
            size: data.size, controlsPosition: data.position, enabled: data.state !== "disabled",
            readOnly: data.state === "readOnly", validationState: data.state === "error"
                ? EValidationState.Error : EValidationState.None
        })
        verify(spin !== null)
        verify(waitForItemPolished(spin))
        mouseMove(testCase, width - 1, height - 1)
        if (data.state === "focus")
            spin.forceActiveFocus()
        spin.up.indicator.visible = false
        spin.down.indicator.visible = false
        waitForRendering(spin)
        const expected = grabImage(spin)
        verify(expected.width > 0)
        spin.up.indicator.visible = true
        spin.down.indicator.visible = true
        waitForRendering(spin)
        const actual = grabImage(spin)
        for (let y = 0; y < 5; ++y) {
            for (let x = 0; x < 5; ++x) {
                for (const point of [[x, y], [actual.width - x - 1, y],
                        [x, actual.height - y - 1], [actual.width - x - 1, actual.height - y - 1]]) {
                    compare(actual.pixel(point[0], point[1]), expected.pixel(point[0], point[1]),
                        "Step buttons must preserve the rounded border at " + point)
                }
            }
        }
    }

    function test_popupHoverPreservesBorder(data) {
        ETheme.setDark(data.dark)
        const component = data.kind === "tree" ? treeComponent : data.kind === "time" ? timeComponent
            : data.kind === "autocomplete" ? autocompleteComponent : data.kind === "cascader" ? cascaderComponent
            : data.kind === "mention" ? mentionComponent : selectComponent
        const control = createTemporaryObject(component, testCase)
        verify(control !== null)
        if (data.kind === "multiple") {
            control.multiple = true
            control.value = [50]
        }
        const popup = data.kind === "autocomplete" ? control.popperRef
            : data.kind === "mention" ? control.tooltip : control.popup
        popup.open()
        tryCompare(popup, "opened", true)
        const listName = data.kind === "autocomplete" ? "autocompleteSuggestionList"
            : data.kind === "mention" ? "mentionSuggestionList"
            : data.kind === "cascader" ? "cascaderOptions" : "selectOptionList"
        const list = findChild(popup, listName)
        verify(list !== null)
        tryVerify(function() { return list.itemAtIndex(0) !== null && list.itemAtIndex(2) !== null })
        mouseMove(testCase, width - 1, height - 1)
        list.Window.window.update()
        verify(waitForRendering(list))
        const surface = popup.contentItem.parent
        const before = grabImage(surface)
        verify(before.width > 0)
        const row = list.itemAtIndex(1).item || list.itemAtIndex(1)
        mouseMove(row, row.width / 2, row.height / 2)
        tryCompare(row, "hovered", true)
        for (let index = 0; index < 3; ++index) {
            const option = list.itemAtIndex(index).item || list.itemAtIndex(index)
            compare(option.background.height, option.height, "Option background must fit its row")
            compare(option.background.width, option.width)
        }
        list.Window.window.update()
        verify(waitForRendering(list))
        const image = grabImage(surface)
        verify(image.width > 0)
        for (let index = 0; index < 3; ++index) {
            const option = list.itemAtIndex(index)
            const center = option.mapToItem(surface, 0, option.height / 2)
            for (const x of [0, image.width - 1])
                compare(image.pixel(x, center.y), popup.background.border.color,
                    "Options must preserve the popup border")
            const label = row.mapToItem(surface, 0, 0)
            const sampleX = Math.round(label.x + row.width - 8)
            if (index !== 1)
                compare(image.pixel(sampleX, center.y), before.pixel(sampleX, center.y),
                    "Hover must stay in the hovered row")
        }
        popup.close()
    }

    width: 640
    height: 480
    visible: true
    when: windowShown
    name: "PopupSpinBoxRendering"

    Component {
        id: selectComponent

        ESelect {
            width: 108
            currentIndex: 2
            model: [10, 20, 50]
        }
    }
    Component {
        id: spinComponent

        ESpinBox {
            y: 180
            width: 116
            editable: true
        }
    }
    Component {
        id: treeComponent

        ETreeSelect {
            value: 50
            width: 200
            data: [{label: "10", value: 10}, {label: "20", value: 20}, {label: "50", value: 50}]
        }
    }
    Component {
        id: timeComponent

        ETimeSelect {
            width: 200
            end: "09:30"
            start: "08:30"
        }
    }
    Component {
        id: autocompleteComponent

        EAutocomplete {
            width: 200
            model: ["10", "20", "50"]
        }
    }
    Component {
        id: cascaderComponent

        ECascader {
            width: 200
            multiple: true
            options: [{label: "10", value: 10}, {label: "20", value: 20}, {label: "50", value: 50}]
        }
    }
    Component {
        id: mentionComponent

        EMention {
            text: "@"
            width: 200
            cursorPosition: 1
            options: ["10", "20", "50"]
        }
    }
    Component {
        id: inputComponent

        EInput {
            y: 180
            width: 320
            appendComponent: Component { EText { text: ".com"; width: implicitWidth + 0.25 } }
            prependComponent: Component { EText { text: "https://"; width: implicitWidth + 0.25 } }
        }
    }
}

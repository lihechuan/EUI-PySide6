import EUI 1.0
import EUI.Private 1.0
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Controls 2.15

TestCase {
    id: testCase

    function cleanup() {
        ETheme.setDark(false)
    }

    function textItems(item, text) {
        let result = item.text === text && item.font !== undefined ? [item] : []
        const children = item.children || []
        for (let index = 0; index < children.length; ++index)
            result = result.concat(textItems(children[index], text))
        return result
    }

    function test_optionLabelFitsRow() {
        const item = createTemporaryObject(optionComponent, testCase)
        verify(waitForItemPolished(item))
        verify(item.contentItem.height >= item.contentItem.implicitHeight)
        fuzzyCompare(item.contentItem.y + item.contentItem.height / 2, item.height / 2, 0.5)
    }

    function test_drawerHasContentInsets() {
        const item = createTemporaryObject(drawerComponent, testCase)
        item.open()
        tryCompare(item, "opened", true)
        verify(item.contentItem.x >= 20, "Drawer content must not touch its outer edge")
        verify(item.contentItem.y >= 20)
        verify(item.width - item.contentItem.x - item.contentItem.width >= 20)
        item.close()
    }

    function test_validationTooltipKeepsInputKeys() {
        const item = createTemporaryObject(inputComponent, testCase)
        const accepted = createTemporaryObject(acceptedSpy, testCase, {target: item})
        item.validationState = EValidationState.Error
        item.forceActiveFocus()
        keyClick(Qt.Key_Return)
        compare(accepted.count, 1)
        keyClick(Qt.Key_Space)
        compare(item.text, " ")
    }

    function test_sliderTooltipDropsFloatingPointNoise() {
        const item = createTemporaryObject(rangeComponent, testCase)
        compare(item.tooltipText(44.73684210526316), "44.74")
        item.stepSize = 0.001
        compare(item.tooltipText(0.123000000000001), "0.123")
        item.formatTooltip = function(value) { return value.toFixed(1) + "%" }
        compare(item.tooltipText(44.73684210526316), "44.7%")
    }

    function test_cascaderCustomLabelsAreCentered() {
        const item = createTemporaryObject(cascaderComponent, testCase)
        item.open()
        tryCompare(item.popup, "opened", true)
        const list = findChild(item.popup.contentItem, "cascaderOptions")
        tryVerify(function() { return list.itemAtIndex(0) !== null })
        const row = list.itemAtIndex(0)
        const label = textItems(row, "中国")[0]
        verify(label)
        const position = label.mapToItem(row, 0, 0)
        fuzzyCompare(position.y + label.height / 2, row.height / 2, 0.5)
        item.popup.close()
    }

    function test_dialogFromNestedPageFitsWindow() {
        const carrier = createTemporaryObject(carrierComponent, testCase)
        const item = createTemporaryObject(dialogComponent, carrier)
        item.open()
        tryCompare(item, "opened", true)
        const position = item.contentItem.mapToItem(testCase, 0, 0)
        verify(position.x >= 0 && position.x + item.contentItem.width <= width,
            "Dialog opened from an offset page must stay inside the window")
        verify(position.y >= 0 && position.y + item.contentItem.height <= height)
        item.close()
    }

    function test_radioButtonsShowOneSelection() {
        const item = createTemporaryObject(radioComponent, testCase)
        verify(waitForItemPolished(item.contentItem))
        const first = item.contentItem.children[0].item
        const second = item.contentItem.children[1].item
        verify(first && second)
        verify(first.checked && !second.checked)
        verify(first.background.color !== second.background.color)
        mouseClick(second, second.width / 2, second.height / 2)
        compare(item.value, "web")
        tryCompare(first, "checked", false)
        tryCompare(second, "checked", true)
    }

    function test_lineTabFocusKeepsUnderlineAndReadableLabel() {
        const item = createTemporaryObject(tabsComponent, testCase)
        verify(waitForItemPolished(item))
        const tab = item.navigation.itemAt(1)
        verify(tab)
        mouseClick(tab, tab.width / 2, tab.height / 2)
        compare(item.currentIndex, 1)
        tab.forceActiveFocus()
        verify(tab.activeFocus)
        compare(tab.background.border.width, 0)
        verify(tab.contentItem.height >= tab.contentItem.implicitHeight)
        const underline = tab.background.children[0]
        verify(underline.visible)
        compare(underline.height, 2)
    }

    function test_inputTagKeepsOneCompactRow() {
        const item = createTemporaryObject(tagComponent, testCase)
        verify(waitForItemPolished(item.contentItem))
        verify(item.height <= EDefaultConfig.controlHeight(item.size) + 4)
        const repeater = findChild(item, "inputTagRepeater")
        compare(repeater.count, 2)
        for (let index = 0; index < repeater.count; ++index)
            verify(repeater.itemAt(index).height <= item.availableHeight)
        item.width = 150
        verify(waitForItemPolished(item.contentItem))
        verify(item.height > EDefaultConfig.controlHeight(item.size))
    }

    function test_rightSpinBoxButtonsStayInsideField() {
        const item = createTemporaryObject(spinComponent, testCase)
        verify(waitForItemPolished(item))
        verify(item.contentItem.width >= item.contentItem.implicitWidth)
        compare(item.up.indicator.width, item.down.indicator.width)
        fuzzyCompare(item.up.indicator.x, item.down.indicator.x, 0.5)
        verify(item.contentItem.x + item.contentItem.width <= item.up.indicator.x)
        verify(item.down.indicator.y + item.down.indicator.height <= item.height - 1)
        mouseClick(item.up.indicator, item.up.indicator.width / 2, item.up.indicator.height / 2)
        compare(item.numberValue, 1.5)
    }

    function test_colorHandlesFollowGradientBounds() {
        const item = createTemporaryObject(colorComponent, testCase)
        for (const name of ["colorHueSlider", "colorAlphaSlider"]) {
            const slider = findChild(item, name)
            verify(slider)
            verify(slider.handle.width < slider.handle.height)
            for (const value of [0, 0.5, 1]) {
                slider.value = value
                verify(waitForItemPolished(slider))
                verify(slider.handle.x >= 0)
                verify(slider.handle.x + slider.handle.width <= slider.width)
                const center = slider.handle.x + slider.handle.width / 2
                verify(center >= slider.background.x)
                verify(center <= slider.background.x + slider.background.width)
            }
        }
    }

    function test_validationTooltipFollowsTheme() {
        const item = createTemporaryObject(inputComponent, testCase)
        item.forceActiveFocus()
        const tooltip = findChild(item, "inputValidationTooltip")
        verify(tooltip)
        item.validationState = EValidationState.Success
        compare(tooltip.visible, false)
        item.validationState = EValidationState.Error
        tryCompare(tooltip, "visible", true)
        for (const dark of [false, true]) {
            ETheme.setDark(dark)
            compare(tooltip.backgroundColor, EPaletteManager.ThemePalette.fetchInverseThemeColor(dark))
            compare(tooltip.font.pixelSize, 12)
        }
        item.validationMessage = ""
        tryCompare(tooltip, "visible", false)
    }

    function test_treeCheckboxLabelsFitRows() {
        const item = createTemporaryObject(treeComponent, testCase)
        item.popup.open()
        tryCompare(item.popup, "opened", true)
        const list = findChild(item.popup.contentItem, "selectOptionList")
        verify(waitForItemPolished(list))
        tryVerify(function() { return list.itemAtIndex(0) !== null })
        for (let index = 0; index < list.count; ++index) {
            list.positionViewAtIndex(index, ListView.Contain)
            tryVerify(function() { return list.itemAtIndex(index) !== null })
            const row = list.itemAtIndex(index).item
            verify(row)
            compare(row.contentItem.verticalAlignment, Text.AlignVCenter)
            verify(row.contentItem.height >= row.contentItem.implicitHeight)
            verify(row.contentItem.x >= row.leftPadding)
            verify(row.contentItem.x + row.contentItem.width <= row.width)
        }
        verify(item.checkNode("desktop", true))
        compare(item.value, ["desktop"])
        item.popup.close()
    }

    width: 960
    height: 640
    visible: true
    when: windowShown
    name: "FormAppearance"

    Component {
        id: carrierComponent

        Item {
            x: 700
            y: 180
            width: 220
            height: 200
        }
    }
    Component {
        id: acceptedSpy

        SignalSpy { signalName: "accepted" }
    }
    Component {
        id: optionComponent

        OptionDelegate {
            width: 200
            text: "month"
        }
    }
    Component {
        id: dialogComponent

        EDialog {
            title: "保存修改"
            text: "是否保存当前修改？"
        }
    }
    Component {
        id: drawerComponent

        EDrawer { title: "项目详情" }
    }
    Component {
        id: spinComponent

        ESpinBox {
            prefix: "$"
            precision: 2
            editable: true
            numberStep: 0.25
            numberValue: 1.25
            controlsPosition: "right"
        }
    }
    Component {
        id: rangeComponent

        ERangeSlider {
            to: 100
            width: 320
        }
    }
    Component {
        id: radioComponent

        ERadioGroup {
            width: 300
            value: "desktop"
            buttonStyle: true
            props: ({value: "id", label: "name"})
            options: [{id: "desktop", name: "桌面端"}, {id: "web", name: "网页端"}]
        }
    }
    Component {
        id: tagComponent

        EInputTag {
            width: 500
            clearable: true
            value: ["Qt", "QML"]
        }
    }
    Component {
        id: cascaderComponent

        ECascader {
            width: 320
            multiple: true
            filterable: true
            nodeDelegate: Component {
                EText { text: parent.node.label }
            }
            options: [{label: "中国", value: "cn", children: [{label: "浙江", value: "zj"}]}]
        }
    }
    Component {
        id: colorComponent

        EColorPickerPanel {
            showAlpha: true
            value: "#3267e8"
        }
    }
    Component {
        id: inputComponent

        EInput {
            y: 100
            width: 300
            validationMessage: "请检查输入"
        }
    }
    Component {
        id: tabsComponent

        ETabs {
            width: 320
            model: [{text: "概览"}, {text: "活动"}]
        }
    }
    Component {
        id: treeComponent

        ETreeSelect {
            width: 320
            multiple: true
            showCheckbox: true
            data: [{label: "研发", value: "team", children: [
                {label: "桌面端", value: "desktop"}, {label: "网页端", value: "web"}]}]
        }
    }
}

import EUI 1.0
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function test_defaults_data() {
        return controlTypes()
    }

    function test_explicitFont_data() {
        return controlTypes()
    }

    function findLabel(item, text) {
        if (item.text === text && item.font !== undefined)
            return item
        for (let index = 0; index < item.children.length; ++index) {
            const label = findLabel(item.children[index], text)
            if (label)
                return label
        }
        return null
    }

    function controlTypes() {
        return [
            {tag: "button", component: buttonComponent},
            {tag: "textButton", component: textButtonComponent},
            {tag: "checkBox", component: checkBoxComponent},
            {tag: "checkBoxButton", component: checkBoxButtonComponent},
            {tag: "radio", component: radioComponent},
            {tag: "radioButton", component: radioButtonComponent}
        ]
    }

    function test_defaults(data) {
        const control = createTemporaryObject(data.component, testCase)
        verify(control !== null)
        let label = null
        tryVerify(function() {
            label = findLabel(control.contentItem, control.text)
            return label !== null
        })
        compare(control.font.bold, true)
        compare(label.font.bold, true)
        compare(label.font.pixelSize, EDefaultConfig.controlFontPixelSize(control.size))
        compare(label.font.pixelSize, control.font.pixelSize)
        control.font.bold = false
        compare(label.font.bold, false)
        control.font.bold = true
        compare(label.font.bold, true)
    }

    function test_textRenderingAndExplicitFont() {
        for (const component of [textComponent, inputComponent, textAreaComponent, copyableTextComponent]) {
            const label = createTemporaryObject(component, testCase)
            compare(label.renderType, Text.QtRendering)
            compare(label.font.pixelSize, 14)
            label.font = Qt.font({family: Qt.platform.os === "osx" ? "Menlo" : "monospace",
                pixelSize: 19, weight: Font.DemiBold, italic: true})
            compare(label.font.pixelSize, 19)
            compare(label.font.weight, Font.DemiBold)
            compare(label.font.italic, true)
            label.renderType = Text.NativeRendering
            compare(label.renderType, Text.NativeRendering)
        }
        const icon = createTemporaryObject(iconComponent, testCase)
        compare(icon.renderType, Text.QtRendering)
    }

    function test_defaultFontFamilies() {
        const families = Qt.fontFamilies()
        verify(EDefaultConfig.primaryFontFamily.length > 0)
        verify(EDefaultConfig.secondaryFontFamily.length > 0)
        if (Qt.platform.os === "windows") {
            verify(families.indexOf(EDefaultConfig.primaryFontFamily) >= 0)
            verify(families.indexOf(EDefaultConfig.secondaryFontFamily) >= 0)
        }
        const label = createTemporaryObject(textComponent, testCase)
        compare(label.font.family, EDefaultConfig.primaryFontFamily)
        if (Qt.platform.os === "windows" && families.indexOf("Microsoft YaHei UI") >= 0)
            compare(label.font.family, "Microsoft YaHei UI")
        if (Qt.platform.os === "windows" && families.indexOf("Consolas") >= 0)
            compare(EDefaultConfig.secondaryFontFamily, "Consolas")
        if (Qt.platform.os === "osx" && families.indexOf("Menlo") >= 0)
            compare(EDefaultConfig.secondaryFontFamily, "Menlo")
    }

    function test_explicitFont(data) {
        const control = createTemporaryObject(data.component, testCase, {
            font: Qt.font({ family: (Qt.platform.os === "osx" ? "Menlo"
                : "monospace"), pixelSize: 19, bold: false, italic: true })
        })
        verify(control !== null)
        let label = null
        tryVerify(function() {
            label = findLabel(control.contentItem, control.text)
            return label !== null
        })
        compare(control.font.bold, false)
        compare(label.font.bold, false)
        compare(label.font.pixelSize, 19)
        compare(label.font.family, control.font.family)
        compare(label.font.italic, true)
        control.font = Qt.font({ family: Qt.platform.os === "osx" ? "Times New Roman" : "serif",
            pointSize: 14, bold: false })
        compare(label.font.family, control.font.family)
        compare(label.font.pixelSize, control.font.pixelSize)
        fuzzyCompare(label.font.pointSize, 14, 0.01)
        compare(label.font.bold, false)
        compare(label.font.italic, false)
    }

    function test_breadcrumbPreservesCallerFont() {
        const breadcrumb = createTemporaryObject(breadcrumbComponent, testCase,
            {font: Qt.font({family: Qt.platform.os === "osx" ? "Menlo" : "monospace",
                pixelSize: 18, bold: false, italic: true, letterSpacing: 0.5})})
        const link = findLabel(breadcrumb.contentItem, "Components")
        let label = null
        tryVerify(function() {
            label = findLabel(link.contentItem, link.text)
            return label !== null
        })
        const last = findLabel(breadcrumb.contentItem, "Typography")
        const separator = findLabel(breadcrumb.contentItem, "/")
        for (const item of [label, last, separator]) {
            compare(item.font.family, breadcrumb.font.family)
            compare(item.font.pixelSize, 18)
            compare(item.font.bold, false)
            compare(item.font.italic, true)
            fuzzyCompare(item.font.letterSpacing, 0.5, 0.01)
        }
        breadcrumb.font = Qt.font({pixelSize: 15, bold: true})
        for (const item of [label, last, separator]) {
            compare(item.font.pixelSize, 15)
            compare(item.font.bold, true)
            compare(item.font.italic, false)
        }
    }

    width: 360
    height: 120
    visible: true
    when: windowShown
    name: "EUIButtonTypography"

    Component {
        id: buttonComponent

        EButton {
            text: "Typography"
        }
    }
    Component {
        id: textButtonComponent

        ETextButton {
            text: "Typography"
        }
    }
    Component {
        id: checkBoxComponent

        ECheckBox {
            text: "Typography"
        }
    }
    Component {
        id: checkBoxButtonComponent

        ECheckBoxButton {
            text: "Typography"
        }
    }
    Component {
        id: radioComponent

        ERadio {
            text: "Typography"
        }
    }
    Component {
        id: radioButtonComponent

        ERadioButton {
            text: "Typography"
        }
    }
    Component {
        id: textComponent

        EText {
            text: "Typography / 文字排版"
        }
    }
    Component {
        id: iconComponent

        EIcon {
            iconSource: EIcons.GEAR
        }
    }
    Component {
        id: breadcrumbComponent

        EBreadcrumb {
            model: ["Components", "Typography"]
        }
    }
    Component {
        id: inputComponent

        EInput {
            text: "Typography / 文字排版"
        }
    }
    Component {
        id: textAreaComponent

        ETextArea {
            text: "Typography / 文字排版"
        }
    }
    Component {
        id: copyableTextComponent

        ECopyableText {
            text: "Typography / 文字排版"
        }
    }
}

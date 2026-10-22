import EUI 1.0
import "../../example/qml/component" as Gallery
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Window 2.15

TestCase {
    id: testCase

    function test_inputAlignment_data() {
        return inputSizes()
    }

    function test_inputSlotsAreCentered_data() {
        return inputSizes()
    }

    function cleanup() {
        ETheme.setDark(false)
        ELocale.language = "zh"
    }

    function inputSizes() {
        return [{tag: "small", size: EStyle.Small}, {tag: "medium", size: EStyle.Medium},
            {tag: "large", size: EStyle.Large}]
    }

    function test_navigationTextStaysVisible_data() {
        return [{tag: "light-zh", dark: false, language: "zh"},
            {tag: "dark-zh", dark: true, language: "zh"},
            {tag: "light-en", dark: false, language: "en"},
            {tag: "dark-en", dark: true, language: "en"}]
    }

    function namedItems(item, name) {
        let result = item.objectName === name ? [item] : []
        const children = item.children || []
        for (let index = 0; index < children.length; ++index)
            result = result.concat(namedItems(children[index], name))
        return result
    }

    function test_colorPickerCancel() {
        const picker = createTemporaryObject(colorPickerComponent, testCase)
        const canceled = createTemporaryObject(canceledSpyComponent, testCase, {target: picker})
        picker.show()
        tryCompare(picker.popup, "opened", true)
        verify(picker.popup.contentItem.selectColor("#00ff00"))
        verify(picker.cancel())
        compare(canceled.count, 1)
        compare(picker.value, "#ff0000")
        tryCompare(picker.popup, "visible", false)
    }

    function test_inputAlignment(data) {
        const input = createTemporaryObject(inputComponent, testCase, {size: data.size})
        verify(waitForItemPolished(input))
        compare(input.verticalAlignment, TextInput.AlignVCenter)
        verify(input.height - input.topPadding - input.bottomPadding >= input.contentHeight,
            "Input must leave enough height for text")
        fuzzyCompare(input.cursorRectangle.y + input.cursorRectangle.height / 2, input.height / 2, 1)
        input.text = ""
        input.placeholderText = "Qt Quick"
        verify(waitForItemPolished(input))
        fuzzyCompare(input.cursorRectangle.y + input.cursorRectangle.height / 2, input.height / 2, 1)
    }

    function verifyTextPixels(window, label, dark) {
        const image = grabImage(window.contentItem)
        const position = label.mapToItem(window.contentItem, 0, 0)
        const scale = window.Screen.devicePixelRatio
        let ink = 0
        for (let y = Math.ceil(position.y * scale); y < (position.y + label.height) * scale; ++y) {
            for (let x = Math.ceil(position.x * scale); x < (position.x + label.width) * scale; ++x) {
                const red = image.red(x, y)
                const green = image.green(x, y)
                const blue = image.blue(x, y)
                if (dark ? red > 180 && green > 180 && blue > 180 : red < 100 && green < 100 && blue < 100)
                    ++ink
            }
        }
        verify(ink > 5, "Navigation label must remain painted: " + ink)
    }

    function test_inputSlotsAreCentered(data) {
        const input = createTemporaryObject(inputComponent, testCase, {size: data.size})
        verify(waitForItemPolished(input))
        for (const name of ["inputPrepend", "inputAppend"]) {
            const label = findChild(input, name).item
            const position = label.mapToItem(input, 0, 0)
            fuzzyCompare(position.y + label.topPadding + label.contentHeight / 2, input.height / 2, 0.5)
            fuzzyCompare(label.width / 2, label.leftPadding + label.contentWidth / 2, 0.5)
        }
        input.prependComponent = null
        input.appendComponent = null
        compare(input.leftPadding, EDefaultConfig.horizontalPadding(data.size))
        compare(input.rightPadding, EDefaultConfig.horizontalPadding(data.size))
    }

    function test_navigationTextStaysVisible(data) {
        ETheme.setDark(data.dark)
        ELocale.language = data.language
        const window = createTemporaryObject(windowComponent, null)
        verify(window !== null)
        window.showComponent(exampleCatalog.find("EUpload"))
        const navigation = findChild(window, "galleryNavigation")
        const loader = findChild(window, "galleryLoader")
        tryCompare(loader, "status", Loader.Ready)
        verify(waitForItemPolished(navigation))
        window.update()
        verify(waitForRendering(window.contentItem))
        for (let frame = 0; frame < 12; ++frame) {
            const name = frame % 2 ? "EInput" : "EUpload"
            const entry = namedItems(window.contentItem, "galleryNavEntry").filter(function(item) {
                return item.entry.index === name
            })[0]
            verify(entry !== undefined)
            mouseClick(entry, 70, entry.height / 2)
            compare(window.currentComponent, name)
            tryCompare(loader, "status", Loader.Ready)
            navigation.contentY = Math.max(0, navigation.contentY + (frame % 2 ? -0.5 : 0.5))
            window.update()
            verify(waitForRendering(window.contentItem))
            const label = entry.contentItem.children[0]
            verify(label.height >= label.implicitHeight, "Navigation label must not be squeezed")
            fuzzyCompare(label.y + label.height / 2, entry.contentItem.height / 2, 0.5)
            verifyTextPixels(window, label, data.dark)
        }
        window.close()
    }

    width: 960
    height: 640
    visible: true
    when: windowShown
    name: "ReportedUi"

    Component {
        id: canceledSpyComponent

        SignalSpy { signalName: "canceled" }
    }
    Component {
        id: colorPickerComponent

        EColorPicker {
            value: "#ff0000"
            commitOnConfirm: true
        }
    }
    Component {
        id: inputComponent

        EInput {
            y: 100
            width: 360
            text: "Qt Quick"
            prependComponent: Component {
                EText {
                    padding: 8
                    text: "USD"
                }
            }
            appendComponent: Component {
                EText {
                    padding: 8
                    text: "每月"
                }
            }
        }
    }
    Component {
        id: windowComponent

        Gallery.App { }
    }
}

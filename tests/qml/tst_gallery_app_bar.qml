import EUI 1.0
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function cleanup() {
        ELocale.language = "en"
        ETheme.setDark(false)
    }

    function difference(first, second) {
        return (Math.abs(first.r - second.r) + Math.abs(first.g - second.g) + Math.abs(first.b - second.b)) * 255 / 3
    }

    function test_interactionContrast_data() {
        const result = []
        for (const dark of [false, true]) {
            for (const language of ["zh", "en"]) {
                for (const width of [820, 1280])
                    result.push({tag: (dark ? "dark" : "light") + "-" + language + "-" + width,
                        dark: dark, language: language, width: width})
            }
        }
        return result
    }

    function test_interactionContrast(data) {
        ETheme.setDark(data.dark)
        ELocale.language = data.language
        const component = Qt.createComponent("../../example/qml/component/App.qml")
        compare(component.status, Component.Ready, component.errorString())
        const window = createTemporaryObject(component, null, {width: data.width})
        verify(window !== null)
        window.requestActivate()
        verify(waitForRendering(window.contentItem))
        const appBar = findChild(window, "galleryAppBar")
        const loader = findChild(window, "galleryLoader")
        verify(appBar !== null && loader !== null)
        loader.active = false
        const buttons = ["galleryRepositoryLink", "galleryLanguageSwitch"]
        if (!appBar.macOS)
            buttons.push("eAppBarMinimizeButton", "eAppBarMaximizeButton")
        const visibility = window.visibility
        for (const name of buttons) {
            const button = findChild(window, name)
            verify(button !== null, name)
            mouseMove(window.contentItem, 32, 72)
            tryCompare(button, "hovered", false)
            compare(button.background.color, "#00000000")
            const point = button.mapToItem(window.contentItem, 2, button.height / 2)
            mouseMove(button, button.width / 2, button.height / 2)
            tryCompare(button, "hovered", true)
            const background = button.background.color
            const hovered = Qt.rgba(background.r, background.g, background.b, background.a)
            verify(difference(hovered, appBar.backgroundColor) >= 20, name + " hover is too close to the title bar")
            compare(hovered, appBar.buttonHoverColor)
            verify(waitForRendering(window.contentItem))
            const pixels = grabImage(window.contentItem)
            verify(difference(pixels.pixel(Math.round(point.x), Math.round(point.y)), appBar.backgroundColor) >= 20,
                name + " rendered hover is too close to the title bar")
            mousePress(button, button.width / 2, button.height / 2)
            tryCompare(button, "pressed", true)
            tryCompare(button.background, "color", appBar.buttonPressedColor)
            verify(difference(button.background.color, hovered) >= 12, name + " press is too close to hover")
            mouseMove(window.contentItem, 32, 72)
            mouseRelease(window.contentItem, 32, 72)
            tryCompare(button, "pressed", false)
            tryCompare(button, "hovered", false)
            compare(button.background.color, "#00000000")
            compare(window.visibility, visibility)
            compare(ELocale.language, data.language)
        }
        const close = findChild(window, "eAppBarCloseButton")
        if (!appBar.macOS) {
            mouseMove(close, close.width / 2, close.height / 2)
            tryCompare(close, "hovered", true)
            compare(close.background.color, "#c42b1c")
        }
        const language = findChild(window, "galleryLanguageSwitch")
        mouseClick(language)
        compare(ELocale.language, data.language === "zh" ? "en" : "zh")
        compare(window.visibility, visibility)
        mouseClick(language)
        compare(ELocale.language, data.language)
        compare(window.visibility, visibility)
        window.close()
        window.destroy()
        wait(0)
        component.destroy()
    }

    height: 840
    width: 1280
    visible: true
    when: windowShown
    name: "GalleryAppBarHover"
}

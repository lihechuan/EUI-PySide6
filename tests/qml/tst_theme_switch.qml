import EUI 1.0
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Controls 2.15

TestCase {
    id: testCase

    function init() {
        ETheme.setDark(false)
        tryCompare(themeSwitch, "checked", false)
    }

    function cleanup() {
        wait(themeSwitch.transitionDuration + 100)
        ETheme.setDark(false)
    }

    function test_themeTransitionRenders_data() {
        return [{ tag: "dark", dark: true }, { tag: "light", dark: false }]
    }

    function test_rapidClicksKeepLatestRequest() {
        themeSwitch.checked = true
        themeSwitch.clicked()
        tryCompare(ETheme, "dark", true, 1000)
        themeSwitch.checked = true
        themeSwitch.clicked()
        tryCompare(ETheme, "dark", false, 2000)
        tryCompare(themeSwitch, "checked", false, 2000)
    }

    function expectPixel(frame, image, x, y, color) {
        verify(image.width > 0 && image.height > 0)
        const pixelX = Math.floor(x * image.width / frame.width)
        const pixelY = Math.floor(y * image.height / frame.height)
        compare(image.red(pixelX, pixelY), Math.round(color.r * 255))
        compare(image.green(pixelX, pixelY), Math.round(color.g * 255))
        compare(image.blue(pixelX, pixelY), Math.round(color.b * 255))
    }

    function test_themeTransitionRenders(data) {
        ETheme.setDark(!data.dark)
        const frame = createTemporaryObject(themeFrame, null)
        verify(frame !== null)
        frame.requestActivate()
        waitForRendering(frame.contentItem)
        if (frame.contentItem.GraphicsInfo.api === GraphicsInfo.Software)
            skip("ShaderEffect requires an OpenGL scene graph")
        const toggle = findChild(frame, "renderedThemeSwitch")
        const oldColor = EPaletteManager.ThemePalette.fetchThemeColor(!data.dark)
        const newColor = EPaletteManager.ThemePalette.fetchThemeColor(data.dark)
        const before = grabImage(frame.contentItem)
        expectPixel(frame, before, 240, 50, oldColor)
        expectPixel(frame, before, 1, 119, oldColor)
        mouseClick(toggle, toggle.width / 2, toggle.height / 2)
        tryCompare(ETheme, "dark", data.dark)
        wait(250)
        const during = grabImage(frame.contentItem)
        expectPixel(frame, during, 240, 50, data.dark ? oldColor : newColor)
        expectPixel(frame, during, 1, 119, data.dark ? newColor : oldColor)
        tryCompare(findChild(frame.contentItem, "themeTransitionLayer"), "active", false, 5000)
        const after = grabImage(frame.contentItem)
        expectPixel(frame, after, 240, 50, newColor)
        expectPixel(frame, after, 1, 119, newColor)
        compare(toggle.checked, data.dark)
    }

    height: 80
    width: 120
    when: windowShown
    name: "EUIThemeSwitch"

    EThemeSwitch {
        id: themeSwitch

        x: 40
        y: 20
        duration: 20
        transitionDuration: 120
    }
    Component {
        id: themeFrame

        ApplicationWindow {
            width: 320
            height: 120
            visible: true
            color: EPaletteManager.ThemePalette.fetchThemeColor(ETheme.dark)
            flags: Qt.Window | (Qt.platform.os === "osx" ? Qt.WindowStaysOnTopHint : 0)

            Rectangle {
                anchors.fill: parent
                color: EPaletteManager.ThemePalette.fetchThemeColor(ETheme.dark)

                EThemeSwitch {
                    y: 20
                    x: 260
                    transitionDuration: 1000
                    objectName: "renderedThemeSwitch"
                }
            }
        }
    }
}

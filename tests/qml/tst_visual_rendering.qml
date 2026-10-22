import EUI 1.0
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Window 2.15

TestCase {
    function expectPixel(frame, x, y, color) {
        tryVerify(function() {
            frame.update()
            waitForRendering(frame.contentItem, 1000)
            return pixelMatches(frame, grabImage(frame.contentItem), x, y, color)
        })
    }

    function openFrame(component) {
        const frame = createTemporaryObject(component, null)
        verify(frame !== null)
        frame.requestActivate()
        frame.update()
        waitForRendering(frame.contentItem, 1000)
        return frame
    }

    function pixelMatches(frame, image, x, y, color) {
        if (image.width <= 0 || image.height <= 0)
            return false
        const pixelX = Math.floor(x * image.width / frame.width)
        const pixelY = Math.floor(y * image.height / frame.height)
        return Math.abs(image.red(pixelX, pixelY) - Math.round(color.r * 255)) <= 2
            && Math.abs(image.green(pixelX, pixelY) - Math.round(color.g * 255)) <= 2
            && Math.abs(image.blue(pixelX, pixelY) - Math.round(color.b * 255)) <= 2
            && image.alpha(pixelX, pixelY) === 255
    }

    function test_acrylicResamplesAfterAncestorMoves() {
        const frame = openFrame(acrylicFrame)
        const carrier = findChild(frame, "acrylicCarrier")
        const acrylic = findChild(frame, "acrylicSurface")
        tryCompare(acrylic, "ready", true)
        expectPixel(frame, 40, 40, EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Danger))
        carrier.x = 100
        expectPixel(frame, 140, 40, EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary))
        carrier.x = 0
        expectPixel(frame, 40, 40, EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Danger))
    }

    function test_clipKeepsRoundedPixelsAndInteractiveLiveContent() {
        const frame = openFrame(clipFrame)
        const button = findChild(frame, "clipButton")
        expectPixel(frame, 81, 81, EPaletteManager.BasePalette.white)
        expectPixel(frame, 100, 120, EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Danger))
        mouseClick(button, button.width / 2, button.height / 2, Qt.LeftButton)
        compare(frame.clicks, 1)
        expectPixel(frame, 100, 120, EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Success))
        expectPixel(frame, 81, 81, EPaletteManager.BasePalette.white)
    }

    when: windowShown
    name: "EUIVisualRendering"

    Component {
        id: acrylicFrame

        Window {
            width: 300
            height: 120
            visible: true
            color: EPaletteManager.BasePalette.white

            Rectangle {
                id: source

                opacity: 0
                width: 200
                height: 100
                color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Danger)

                Rectangle {
                    x: 100
                    width: 100
                    height: 100
                    color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                }
            }
            Item {
                width: 80
                height: 80
                objectName: "acrylicCarrier"

                EAcrylic {
                    radius: 0
                    blurRadius: 0
                    tintOpacity: 0
                    noiseOpacity: 0
                    sourceItem: source
                    anchors.fill: parent
                    objectName: "acrylicSurface"
                }
            }
        }
    }
    Component {
        id: clipFrame

        Window {
            id: frame

            property int clicks: 0

            width: 320
            height: 240
            visible: true
            color: EPaletteManager.BasePalette.white

            EClip {
                x: 80
                y: 80
                height: 80
                radius: 32
                width: 160

                Rectangle {
                    anchors.fill: parent
                    color: EPaletteManager.ThemePalette.fetchColorForStyle(
                        frame.clicks ? EStyle.Success : EStyle.Danger)

                    EButton {
                        width: 32
                        height: 32
                        anchors.centerIn: parent
                        objectName: "clipButton"

                        onClicked: ++frame.clicks
                    }
                }
            }
        }
    }
}

import EUI 1.0
import EUI.Private 1.0
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Window 2.15

TestCase {
    id: testCase

    function test_capturePixels_data() {
        return [{tag: "full", sourceWidth: 200, left: 0, width: 200},
            {tag: "crop", sourceWidth: 200, left: 60, width: 100},
            {tag: "limited", sourceWidth: 800, left: 160, width: 400}]
    }

    function test_capturePixels(data) {
        const fixture = createTemporaryObject(fixtureComponent, testCase,
            {sourceWidth: data.sourceWidth, cropLeft: data.left, cropWidth: data.width})
        verify(fixture !== null)
        tryCompare(fixture.renderer, "ready", true)
        wait(50)
        const image = grabImage(testCase)
        if (image.width <= 0)
            skip("This platform cannot capture pixels with QtTest")
        for (const fraction of [0.1, 0.35, 0.65, 0.9]) {
            const sourceX = data.left + fraction * data.width
            const x = Math.floor((data.left + fraction * data.width) * Screen.devicePixelRatio)
            const y = Math.floor(20 * Screen.devicePixelRatio)
            const color = sourceX < data.sourceWidth * 0.2 ? "red"
                : sourceX < data.sourceWidth * 0.5 ? "green" : "blue"
            compare(image.red(x, y), color === "red" ? 255 : 0, "red at " + fraction)
            compare(image.green(x, y), color === "green" ? 255 : 0, "green at " + fraction)
            compare(image.blue(x, y), color === "blue" ? 255 : 0, "blue at " + fraction)
        }
    }

    height: 120
    width: 2000
    visible: true
    when: windowShown
    name: "BackdropRegressions"

    Component {
        id: fixtureComponent

        Item {
            id: fixture

            property int cropLeft: 0
            property int cropWidth: 200
            property int sourceWidth: 200
            property alias renderer: renderer

            height: 40
            width: sourceWidth

            Item {
                id: source

                height: 40
                opacity: 0
                width: fixture.sourceWidth

                Rectangle {
                    height: 40
                    color: "#ff0000"
                    width: source.width * 0.2
                }
                Rectangle {
                    height: 40
                    color: "#00ff00"
                    x: source.width * 0.2
                    width: source.width * 0.3
                }
                Rectangle {
                    height: 40
                    color: "#0000ff"
                    x: source.width * 0.5
                    width: source.width * 0.5
                }
            }
            BackdropRenderer {
                id: renderer

                radius: 0
                height: 40
                blurRadius: 0
                tintOpacity: 0
                noiseOpacity: 0
                sourceItem: source
                x: fixture.cropLeft
                width: fixture.cropWidth
            }
        }
    }
}

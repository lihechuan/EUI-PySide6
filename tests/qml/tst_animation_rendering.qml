import EUI 1.0
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Window 2.15

TestCase {
    id: testCase

    function test_renderedMotion_data() {
        return EAnimation.effects.map(function(effect) { return {tag: effect, effect: effect} })
    }

    function imageOf(host) {
        host.Window.window.update()
        verify(waitForRendering(host))
        const image = grabImage(host)
        verify(image.width > 0 && image.height > 0)
        return image
    }

    function test_renderedMotion(data) {
        const host = createTemporaryObject(renderComponent, testCase)
        const item = findChild(host, "renderedAnimationTarget")
        const before = imageOf(host)
        const ratio = before.width / host.width
        compare(before.red(Math.floor(80 * ratio), Math.floor(90 * ratio)), 255)
        verify(EAnimation.play(item, data.effect, {duration: 200, distance: 24, easing: Easing.Linear}))
        wait(60)
        const during = imageOf(host)
        let changed = 0
        for (let y = 25; y < 110; ++y) {
            for (let x = 30; x < 170; ++x) {
                const px = Math.floor(x * ratio)
                const py = Math.floor(y * ratio)
                if (before.red(px, py) !== during.red(px, py))
                    ++changed
            }
        }
        verify(changed > 20, data.effect + " must visibly change pixels")
        wait(170)
        const after = imageOf(host)
        const exiting = data.effect.indexOf("Out") >= 0
        compare(after.blue(Math.floor(80 * ratio), Math.floor(50 * ratio)), exiting ? 255 : 232)
        verify(EAnimation.stop(item))
        const reset = imageOf(host)
        compare(reset.blue(Math.floor(80 * ratio), Math.floor(50 * ratio)), 232)
    }

    width: 220
    height: 140
    visible: true
    when: windowShown
    name: "EUIAnimationRendering"

    Component {
        id: renderComponent

        Rectangle {
            width: 200
            height: 120
            color: "white"

            Rectangle {
                x: 60
                y: 40
                width: 80
                height: 40
                color: "#3267e8"
                objectName: "renderedAnimationTarget"
            }
        }
    }
}

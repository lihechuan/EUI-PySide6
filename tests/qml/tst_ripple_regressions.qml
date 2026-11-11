import EUI 1.0
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function test_invalidPulse() {
        const ripple = createTemporaryObject(rippleComponent, testCase)
        verify(!ripple.pulse(NaN, 20))
        verify(!ripple.pulse(20, Infinity))
        ripple.enabled = false
        verify(!ripple.pulse(20, 20))
    }

    function test_zeroScaleHidden() {
        const ripple = createTemporaryObject(rippleComponent, testCase)
        const surface = ripple.children[1]
        const wave = surface.children[0]
        wave.scale = 0
        wave.opacity = 0.25
        verify(!wave.visible)
        wave.scale = 0.2
        verify(wave.visible)
        wave.opacity = 0
        verify(!wave.visible)
    }

    name: "RippleRegressions"
    when: windowShown
    width: 240
    visible: true
    height: 160

    Component {
        id: rippleComponent

        ERipple {
            width: 121
            height: 61
        }
    }
}

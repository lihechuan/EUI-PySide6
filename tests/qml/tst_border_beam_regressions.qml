import EUI 1.0
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function test_fractionalCanvasRepaint() {
        const beam = createTemporaryObject(beamComponent, testCase)
        const canvas = findChild(beam, "borderBeamCanvas")
        verify(canvas !== null)
        tryCompare(canvas, "available", true)
        canvas.phase = 0.5
        const spy = createTemporaryObject(spyComponent, testCase, {target: canvas})
        canvas.requestPaint()
        tryVerify(function() { return spy.count > 0 })
        const first = canvas.toDataURL("image/png")
        verify(first.length > 100)
        for (let index = 0; index < 3; ++index) {
            spy.clear()
            canvas.requestPaint()
            tryVerify(function() { return spy.count > 0 })
            verify(canvas.toDataURL("image/png") === first, "Repeated paint changed unchanged beam pixels")
        }
    }

    width: 240
    height: 160
    visible: true
    when: windowShown
    name: "BorderBeamRegressions"

    Component {
        id: spyComponent

        SignalSpy {
            signalName: "painted"
        }
    }
    Component {
        id: beamComponent

        EBorderBeam {
            x: 20
            y: 20
            height: 80
            width: 160
            outset: 1.25
            running: false
        }
    }
}

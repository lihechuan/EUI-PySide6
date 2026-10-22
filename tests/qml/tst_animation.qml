import EUI 1.0
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function test_effects_data() {
        return EAnimation.effects.map(function(effect) { return {tag: effect, effect: effect} })
    }

    function test_flipAxis_data() {
        return [{tag: "X", effect: "flipInX", x: 80, y: 0},
            {tag: "Y", effect: "flipInY", x: 0, y: 40}]
    }

    function test_replacementAndBindings_data() {
        return EAnimation.effects.map(function(effect) { return {tag: effect, effect: effect} })
    }

    function test_initiallyTransparent() {
        const item = createTemporaryObject(targetComponent, testCase, {opacity: 0})
        verify(EAnimation.play(item, "fadeIn", {duration: 0}))
        compare(item.opacity, 1)
    }

    function test_invalidOptions(data) {
        const item = createTemporaryObject(targetComponent, testCase)
        verify(!EAnimation.play(item, "fadeIn", data.options))
        compare(item.opacity, 0.6)
        compare(item.transform.length, 0)
    }

    function test_slideDirections_data() {
        return [{tag: "Up", effect: "slideInUp", x: 20, y: 54},
            {tag: "Down", effect: "slideInDown", x: 20, y: 6},
            {tag: "Left", effect: "slideInLeft", x: -4, y: 30},
            {tag: "Right", effect: "slideInRight", x: 44, y: 30}]
    }

    function test_slideDirections(data) {
        const item = createTemporaryObject(targetComponent, testCase)
        verify(EAnimation.play(item, data.effect, {duration: 500, distance: 24}))
        fuzzyCompare(item.mapToItem(testCase, 0, 0).x, data.x, 0.01)
        fuzzyCompare(item.mapToItem(testCase, 0, 0).y, data.y, 0.01)
        verify(EAnimation.stop(item))
    }

    function test_effects(data) {
        const item = createTemporaryObject(targetComponent, testCase)
        verify(EAnimation.play(item, data.effect, {duration: 0, distance: 0}))
        compare(item.opacity, data.effect.indexOf("Out") >= 0 ? 0 : 0.6)
        compare(item.mapToItem(testCase, 0, 0), Qt.point(20, 30))
        verify(EAnimation.stop(item))
        compare(item.opacity, 0.6)
    }

    function test_targetDestroyedDuringPlayback() {
        const item = targetComponent.createObject(testCase)
        verify(EAnimation.play(item, "fadeIn", {duration: 500}))
        item.destroy()
        wait(0)
        const replacement = createTemporaryObject(targetComponent, testCase)
        verify(EAnimation.play(replacement, "pulse", {duration: 0}))
        compare(replacement.transform.length, 1)
    }

    function test_scaleUsesVisualTransform() {
        const item = createTemporaryObject(targetComponent, testCase)
        verify(EAnimation.play(item, "scaleIn", {duration: 500}))
        compare(item.scale, 1)
        fuzzyCompare(item.mapToItem(testCase, 0, 0).x, 26, 0.01)
        fuzzyCompare(item.mapToItem(testCase, 0, 0).y, 33, 0.01)
        verify(EAnimation.stop(item))
        compare(item.mapToItem(testCase, 0, 0), Qt.point(20, 30))
    }

    function test_invalidTargetAndEffect() {
        const item = createTemporaryObject(targetComponent, testCase)
        compare(EAnimation.effects.length, 83)
        compare(EAnimation.effects.filter(function(effect, index, list) { return list.indexOf(effect) === index }).length, 83)
        verify(!EAnimation.play(null, "fadeIn"))
        verify(!EAnimation.play(item, "missing"))
        verify(!EAnimation.stop(null))
        verify(!EAnimation.stop(item))
        compare(item.opacity, 0.6)
    }

    function test_flipAxis(data) {
        const item = createTemporaryObject(targetComponent, testCase)
        verify(EAnimation.play(item, data.effect, {duration: 500}))
        const first = item.mapToItem(testCase, 0, 0)
        const last = item.mapToItem(testCase, item.width, item.height)
        fuzzyCompare(last.x - first.x, data.x, 0.01)
        fuzzyCompare(last.y - first.y, data.y, 0.01)
        compare(item.rotation, 0)
        compare(item.scale, 1)
        verify(EAnimation.stop(item))
        compare(item.mapToItem(testCase, 0, 0), Qt.point(20, 30))
    }

    function test_independentTargetsAndRejectedReplacement() {
        const first = createTemporaryObject(targetComponent, testCase)
        const second = createTemporaryObject(targetComponent, testCase)
        verify(EAnimation.play(first, "slideInLeft", {duration: 500, easing: Easing.InOutSine}))
        verify(EAnimation.play(second, "slideInUp", {duration: 500}))
        verify(!EAnimation.play(first, "fadeOut", {duration: -1}))
        fuzzyCompare(first.mapToItem(testCase, 0, 0).x, -4, 0.01)
        fuzzyCompare(second.mapToItem(testCase, 0, 0).y, 54, 0.01)
        verify(EAnimation.stop(first))
        compare(first.opacity, 0.6)
        verify(second.opacity < 0.6)
        verify(EAnimation.stop(second))
    }

    function test_stopAndRepeatedPlayback() {
        const item = createTemporaryObject(targetComponent, testCase)
        verify(EAnimation.play(item, "slideInLeft", {duration: 500, distance: 24}))
        fuzzyCompare(item.mapToItem(testCase, 0, 0).x, -4, 0.01)
        verify(EAnimation.play(item, "slideInUp", {duration: 500, distance: 12}))
        compare(item.transform.length, 1)
        fuzzyCompare(item.mapToItem(testCase, 0, 0).y, 42, 0.01)
        verify(EAnimation.stop(item))
        compare(item.mapToItem(testCase, 0, 0), Qt.point(20, 30))
        compare(item.opacity, 0.6)
        verify(EAnimation.play(item, "fadeOut", {duration: 40}))
        tryCompare(item, "opacity", 0)
        verify(EAnimation.play(item, "fadeIn", {duration: 40}))
        tryCompare(item, "opacity", 0.6)
    }

    function test_replacementAndBindings(data) {
        const host = createTemporaryObject(boundComponent, testCase)
        const item = findChild(host, "boundAnimationTarget")
        verify(waitForItemPolished(host))
        const original = item.mapToItem(host, 0, 0)
        verify(EAnimation.play(item, data.effect, {duration: 500, distance: 32}))
        compare(item.x, 110)
        compare(item.y, 60)
        compare(item.rotation, 12)
        compare(item.scale, 1.2)
        verify(EAnimation.play(item, data.effect, {duration: 500, distance: 32}))
        compare(item.transform.length, 2)
        verify(EAnimation.stop(item))
        fuzzyCompare(item.mapToItem(host, 0, 0).x, original.x, 0.01)
        fuzzyCompare(item.mapToItem(host, 0, 0).y, original.y, 0.01)
        compare(item.opacity, 0.6)
        host.width = 400
        host.itemScale = 1.4
        host.itemOpacity = 0.4
        compare(item.x, 160)
        compare(item.scale, 1.4)
        compare(item.opacity, 0.4)
    }

    function test_invalidOptions_data() {
        return [
            {tag: "negative duration", options: {duration: -1}},
            {tag: "fractional duration", options: {duration: 0.5}},
            {tag: "overflow duration", options: {duration: 2147483648}},
            {tag: "NaN duration", options: {duration: NaN}},
            {tag: "infinite duration", options: {duration: Infinity}},
            {tag: "string duration", options: {duration: "300"}},
            {tag: "null duration", options: {duration: null}},
            {tag: "boolean duration", options: {duration: true}},
            {tag: "negative distance", options: {distance: -1}},
            {tag: "infinite distance", options: {distance: Infinity}},
            {tag: "overflow distance", options: {distance: 1000001}},
            {tag: "negative easing", options: {easing: -1}},
            {tag: "fractional easing", options: {easing: 1.5}},
            {tag: "custom easing", options: {easing: Easing.BezierSpline}},
            {tag: "unknown option", options: {duraton: 300}}
        ]
    }

    function test_layoutTransformsAndBindingsSurvive() {
        const host = createTemporaryObject(boundComponent, testCase)
        const item = findChild(host, "boundAnimationTarget")
        verify(waitForItemPolished(host))
        const original = item.mapToItem(host, 0, 0)
        verify(EAnimation.play(item, "slideInUp", {duration: 120, distance: 24}))
        fuzzyCompare(item.mapToItem(host, 0, 0).y, original.y + 24, 0.01)
        compare(item.x, 110)
        compare(item.y, 60)
        compare(item.scale, 1.2)
        compare(item.transform.length, 2)
        tryCompare(item, "opacity", host.itemOpacity)
        tryVerify(function() { return Math.abs(item.mapToItem(host, 0, 0).y - original.y) < 0.01 })
        host.width = 400
        host.itemScale = 1.4
        host.itemOpacity = 0.4
        compare(item.x, 160)
        compare(item.scale, 1.4)
        compare(item.opacity, 0.4)
        verify(EAnimation.play(item, "fadeOut", {duration: 0}))
        compare(item.opacity, 0)
        host.itemOpacity = 0.5
        compare(item.opacity, 0.5)
        verify(EAnimation.play(item, "fadeIn", {duration: 0}))
        compare(item.opacity, 0.5)
    }

    width: 500
    height: 300
    visible: true
    when: windowShown
    name: "EUIAnimation"

    Component {
        id: targetComponent

        Rectangle {
            x: 20
            y: 30
            width: 80
            height: 40
            opacity: 0.6
            color: "#3267e8"
        }
    }
    Component {
        id: boundComponent

        Item {
            property real itemScale: 1.2
            property real itemOpacity: 0.6

            width: 300
            height: 160

            Rectangle {
                width: 80
                height: 40
                rotation: 12
                color: "#3267e8"
                scale: parent.itemScale
                anchors.centerIn: parent
                opacity: parent.itemOpacity
                transform: Translate {
                    x: 4
                    y: 5
                }
                objectName: "boundAnimationTarget"
            }
        }
    }
}

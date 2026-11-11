import EUI 1.0
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function test_explicitViewportTracksMovement_data() {
        return [{tag: "deferred", name: "deferred"}, {tag: "animation", name: "animation"}]
    }

    function test_siblingViewportTracksMovement_data() {
        return [
            {tag: "deferred-viewport", name: "deferred", ancestor: false},
            {tag: "animation-viewport", name: "animation", ancestor: false},
            {tag: "deferred-ancestor", name: "deferred", ancestor: true},
            {tag: "animation-ancestor", name: "animation", ancestor: true}
        ]
    }

    function test_explicitViewportTracksMovement(data) {
        const fixture = createTemporaryObject(fixtureComponent, testCase)
        const body = findChild(fixture, "body")
        const tested = findChild(fixture, data.name)
        verify(body !== null)
        verify(tested !== null)
        wait(30)
        compare(tested.inViewport, false)
        body.y = 20
        tryCompare(tested, "inViewport", true)
        body.y = 160
        tryCompare(tested, "inViewport", false)
        body.y = 20
        tryCompare(tested, "inViewport", true)
    }

    function test_siblingViewportTracksMovement(data) {
        const fixture = createTemporaryObject(siblingFixtureComponent, testCase, {
            viewportY: data.ancestor ? 0 : 160,
            viewportHostY: data.ancestor ? 160 : 0
        })
        const moved = findChild(fixture, data.ancestor ? "viewportHost" : "viewport")
        const tested = findChild(fixture, data.name)
        verify(moved !== null)
        verify(tested !== null)
        wait(30)
        compare(tested.inViewport, false)
        moved.y = 0
        tryCompare(tested, "inViewport", true)
        moved.y = 160
        tryCompare(tested, "inViewport", false)
        moved.y = 0
        tryCompare(tested, "inViewport", true)
    }

    width: 240
    height: 180
    visible: true
    when: windowShown
    name: "DeferredRegressions"

    Component {
        id: fixtureComponent

        Item {
            width: 240
            height: 180

            Item {
                id: clipViewport

                clip: true
                width: 200
                height: 100

                Item {
                    y: 160
                    width: 200
                    height: 200
                    objectName: "body"

                    EDeferred {
                        width: 60
                        height: 40
                        once: false
                        viewport: clipViewport
                        objectName: "deferred"
                    }
                    EAnimateOnScroll {
                        width: 60
                        height: 40
                        enterEffect: ""
                        leaveEffect: ""
                        viewport: clipViewport
                        objectName: "animation"
                    }
                }
            }
        }
    }
    Component {
        id: siblingFixtureComponent

        Item {
            property real viewportY: 0
            property real viewportHostY: 0

            width: 240
            height: 180

            Item {
                width: 200
                height: 100
                y: parent.viewportHostY
                objectName: "viewportHost"

                Item {
                    id: siblingViewport

                    width: 200
                    height: 100
                    objectName: "viewport"
                    y: parent.parent.viewportY
                }
            }
            EDeferred {
                y: 20
                width: 60
                height: 40
                once: false
                objectName: "deferred"
                viewport: siblingViewport
            }
            EAnimateOnScroll {
                y: 20
                width: 60
                height: 40
                enterEffect: ""
                leaveEffect: ""
                objectName: "animation"
                viewport: siblingViewport
            }
        }
    }
}

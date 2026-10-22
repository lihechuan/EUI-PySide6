import EUI 1.0
import "../../example/qml/component" as Gallery
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    property int completedCount: 0
    property int destroyedCount: 0

    function test_hiddenPageKeepsLayout() {
        const page = createTemporaryObject(pageComponent, testCase, {visible: false, selectedComponent: "First"})
        verify(page !== null)
        tryVerify(function() { return page.firstSection.loadedCard !== null })
        compare(page.firstSection.implicitHeight, 40)
        verify(page.contentHeight > 40)
        page.visible = true
        compare(page.firstSection.implicitHeight, 40)
    }

    function test_waitsForOuterLoader() {
        const container = createTemporaryObject(loadingComponent, testCase)
        verify(container !== null)
        tryCompare(container.page, "layoutReady", true)
        compare(container.page.previewsReady, false)
        compare(container.page.firstSection.loadedCard, null)
        container.status = Loader.Ready
        tryVerify(function() { return container.page.firstSection.loadedCard !== null })
        compare(container.page.previewsReady, true)
    }

    function test_viewportCreationAndState() {
        const page = createTemporaryObject(viewportComponent, testCase)
        verify(page !== null)
        verify(waitForItemPolished(page))
        tryVerify(function() { return page.firstSection.loadedCard !== null })
        compare(page.secondSection.loadedCard, null)
        compare(page.thirdSection.loadedCard, null)
        page.firstSection.loadedCard.value = 7
        page.contentY = page.secondSection.y + 32
        tryVerify(function() { return page.secondSection.loadedCard !== null })
        compare(page.thirdSection.loadedCard, null)
        page.contentY = 0
        compare(page.firstSection.loadedCard.value, 7)
        page.contentY = page.thirdSection.y + 32
        tryVerify(function() { return page.thirdSection.loadedCard !== null })
        page.showComponent("Missing")
        compare(page.firstSection.loadedCard, null)
        compare(page.secondSection.loadedCard, null)
        compare(page.thirdSection.loadedCard, null)
    }

    function test_lazyCreationAndCleanup() {
        completedCount = 0
        destroyedCount = 0
        const page = pageComponent.createObject(testCase, { selectedComponent: "First" })
        verify(page)
        tryCompare(testCase, "completedCount", 1)
        compare(page.firstSection.loadedCard !== null, true)
        compare(page.secondSection.loadedCard, null)
        compare(page.firstSection.loadedCard.titleVisible, false)
        page.showComponent("Second")
        tryCompare(testCase, "completedCount", 2)
        compare(page.firstSection.loadedCard, null)
        compare(page.secondSection.loadedCard !== null, true)
        compare(destroyedCount, 1)
        page.showComponent("")
        tryCompare(testCase, "completedCount", 3)
        compare(page.firstSection.loadedCard !== null, true)
        compare(page.secondSection.loadedCard.titleVisible, true)
        page.showComponent("Missing")
        compare(page.firstSection.loadedCard, null)
        compare(page.secondSection.loadedCard, null)
        compare(destroyedCount, 3)
        page.destroy()
        wait(0)
    }

    width: 640
    height: 480
    visible: true
    when: windowShown
    name: "EUIExampleLoading"

    Component {
        id: viewportComponent

        Gallery.ExamplePage {
            readonly property alias firstSection: viewportFirst
            readonly property alias thirdSection: viewportThird
            readonly property alias secondSection: viewportSecond

            width: 500
            height: 400
            selectedComponent: "First"

            Gallery.ExampleSection {
                id: viewportFirst

                componentName: "First"

                Item {
                    property int value: 0

                    implicitHeight: 600
                }
            }
            Gallery.ExampleSection {
                id: viewportSecond

                componentName: "First"

                Item { implicitHeight: 600 }
            }
            Gallery.ExampleSection {
                id: viewportThird

                componentName: "First"

                Item { implicitHeight: 600 }
            }
        }
    }
    Component {
        id: loadingComponent

        Item {
            property int status: Loader.Loading

            readonly property alias page: loadingPage

            width: 500
            height: 400

            Gallery.ExamplePage {
                id: loadingPage

                readonly property alias firstSection: loadingFirst

                width: 500
                height: 400
                selectedComponent: "First"

                Gallery.ExampleSection {
                    id: loadingFirst

                    componentName: "First"

                    Item { implicitHeight: 600 }
                }
            }
        }
    }
    Component {
        id: pageComponent

        Gallery.ExamplePage {
            readonly property alias firstSection: first
            readonly property alias secondSection: second

            width: 500
            height: 400

            Item {
                width: 1
                height: 1
            }
            Gallery.ExampleSection {
                id: first

                componentName: "First"

                Item {
                    property bool titleVisible: true

                    implicitHeight: 40

                    Component.onCompleted: testCase.completedCount++
                    Component.onDestruction: testCase.destroyedCount++
                }
            }
            Gallery.ExampleSection {
                id: second

                componentName: "Second"

                Item {
                    property bool titleVisible: true

                    implicitHeight: 40

                    Component.onCompleted: testCase.completedCount++
                    Component.onDestruction: testCase.destroyedCount++
                }
            }
        }
    }
}

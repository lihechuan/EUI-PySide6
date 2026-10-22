import EUI 1.0
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

TestCase {
    id: testCase

    function test_layoutAttachedSizesRemainAvailable() {
        const container = createTemporaryObject(attachedContainerComponent, testCase)
        verify(waitForItemPolished(container))
        compare(findChild(container, "attachedHeader").height, 90)
        compare(findChild(container, "attachedAside").width, 250)
        compare(findChild(container, "attachedFooter").height, 70)
    }

    function test_spaceStretchRestoresUserHeights() {
        const space = createTemporaryObject(spaceComponent, testCase, {alignment: "stretch"})
        const first = findChild(space, "firstSpaceItem")
        const second = findChild(space, "secondSpaceItem")
        tryCompare(first, "height", 50)
        space.alignment = "center"
        tryCompare(first, "height", 30)
        compare(second.height, 50)
        compare(first.y, 10)
    }

    function test_scrollbarListViewKeepsVirtualContentExtent() {
        const scrollbar = createTemporaryObject(listComponent, testCase)
        verify(scrollbar !== null)
        const list = findChild(scrollbar, "nativeListView")
        compare(scrollbar.scrollTarget, list)
        tryCompare(list, "contentHeight", 4000)
        scrollbar.setScrollTop(3600)
        compare(scrollbar.scrollTop, 3600)
        tryVerify(function() {
            return list.itemAtIndex(90) !== null
        })
        list.model = 200
        tryCompare(list, "contentHeight", 8000)
    }

    function test_scrollbarImplicitAndExplicitSizes() {
        const scrollbar = createTemporaryObject(columnComponent, testCase)
        verify(scrollbar !== null)
        tryCompare(scrollbar, "contentHeight", 480)
        compare(scrollbar.implicitHeight, 180)
        scrollbar.setScrollTop(10000)
        compare(scrollbar.scrollTop, 380)
        const explicit = createTemporaryObject(explicitScrollComponent, testCase)
        compare(explicit.contentWidth, 500)
        compare(explicit.contentHeight, 600)
        explicit.scrollTo(200, 300)
        compare(explicit.scrollLeft, 200)
        compare(explicit.scrollTop, 300)
    }

    function test_scrollbarHandlesFollowViewport_data() {
        return [
            {tag: "vertical", contentWidth: 80, contentHeight: 600, always: false, padding: 0},
            {tag: "horizontal", contentWidth: 500, contentHeight: 60, always: false, padding: 0},
            {tag: "both", contentWidth: 500, contentHeight: 600, always: false, padding: 0},
            {tag: "noOverflow", contentWidth: 80, contentHeight: 60, always: false, padding: 0},
            {tag: "always", contentWidth: 80, contentHeight: 60, always: true, padding: 0},
            {tag: "padding", contentWidth: 500, contentHeight: 600, always: false, padding: 6}
        ]
    }

    function test_spaceFillRestoresUserBinding() {
        const space = createTemporaryObject(spaceComponent, testCase)
        verify(space !== null)
        const first = findChild(space, "firstSpaceItem")
        const second = findChild(space, "secondSpaceItem")
        space.fill = true
        tryCompare(first, "width", 200)
        tryCompare(second, "width", 200)
        compare(second.y, 48)
        space.fillRatio = 30
        tryCompare(first, "width", 120)
        compare(second.x, 132)
        space.fill = false
        tryCompare(first, "width", 80)
        tryCompare(second, "width", 100)
        space.itemWidth = 96
        tryCompare(first, "width", 96)
        tryCompare(second, "width", 116)
    }

    function test_scrollbarPreservesNativeFlickable() {
        const scrollbar = createTemporaryObject(flickableComponent, testCase)
        verify(scrollbar !== null)
        const flickable = findChild(scrollbar, "nativeFlickable")
        compare(scrollbar.scrollTarget, flickable)
        compare(flickable.contentWidth, 640)
        compare(flickable.contentHeight, 500)
        scrollbar.scrollTo({left: 200, top: 300})
        compare(scrollbar.scrollLeft, 200)
        compare(scrollbar.scrollTop, 300)
        flickable.documentHeight = 720
        compare(flickable.contentHeight, 720)
        scrollbar.setScrollTop(10000)
        compare(scrollbar.scrollTop, 620)
        verify(scrollbar.bottomReached)
    }

    function test_spaceVerticalFillAndDirectionChanges() {
        const space = createTemporaryObject(
            spaceComponent,
            testCase,
            {direction: "vertical", fill: true, fillRatio: 30}
        )
        const first = findChild(space, "firstSpaceItem")
        const second = findChild(space, "secondSpaceItem")
        tryCompare(first, "width", 120)
        tryCompare(second, "width", 120)
        compare(second.x, 0)
        compare(second.y, 48)
        space.width = 600
        tryCompare(first, "width", 180)
        space.fillRatio = 120
        tryCompare(first, "width", 600)
        space.fillRatio = -5
        tryCompare(first, "width", 0)
        space.fillRatio = 50
        space.direction = "horizontal"
        tryCompare(first, "width", 300)
        compare(second.y, 48)
        space.fill = false
        tryCompare(first, "width", 80)
        space.direction = "vertical"
        space.height = 60
        tryVerify(function() {
            return second.x > first.x
        })
        space.height = 200
        tryCompare(second, "x", 0)
        compare(second.y, 48)
    }

    function test_containerNativeLengthsAndResponsiveBindings() {
        const container = createTemporaryObject(containerComponent, testCase)
        verify(container !== null)
        verify(waitForItemPolished(container))
        const header = findChild(container, "containerHeader")
        const footer = findChild(container, "containerFooter")
        const aside = findChild(container, "containerAside")
        const body = findChild(container, "containerBody")
        const main = findChild(container, "containerMain")
        compare(container.effectiveDirection, Qt.Vertical)
        compare(body.effectiveDirection, Qt.Horizontal)
        compare(header.height, 80)
        compare(footer.height, 70)
        compare(aside.width, 240)
        compare(header.width, 600)
        compare(body.height, 250)
        tryCompare(main, "width", 360)
        container.width = 800
        container.height = 500
        tryCompare(aside, "width", 320)
        tryCompare(header, "height", 100)
        compare(footer.height, 70)
        tryCompare(main, "width", 480)
        tryCompare(body, "height", 330)
        container.headerRatio = 0.3
        tryCompare(header, "height", 150)
    }

    function test_scrollbarHandlesFollowViewport(data) {
        const scrollbar = createTemporaryObject(explicitScrollComponent, testCase, {
            always: data.always,
            padding: data.padding,
            contentWidth: data.contentWidth,
            contentHeight: data.contentHeight
        })
        verify(waitForItemPolished(scrollbar))
        const vertical = scrollbar.ScrollBar.vertical
        const horizontal = scrollbar.ScrollBar.horizontal
        compare(vertical.parent, scrollbar)
        compare(horizontal.parent, scrollbar)
        compare(vertical.y, scrollbar.topPadding)
        compare(horizontal.x, scrollbar.leftPadding)
        compare(vertical.height, scrollbar.availableHeight)
        compare(horizontal.width, scrollbar.availableWidth)
        compare(vertical.x, scrollbar.width - vertical.width)
        compare(horizontal.y, scrollbar.height - horizontal.height)
        compare(vertical.visible, data.contentHeight > scrollbar.availableHeight)
        compare(horizontal.visible, data.contentWidth > scrollbar.availableWidth)
        if (vertical.visible)
            verify(vertical.contentItem.height > 4)
        if (horizontal.visible)
            verify(horizontal.contentItem.width > 4)
        scrollbar.scrollTo(40, 40)
        if (data.contentHeight > scrollbar.availableHeight) {
            compare(scrollbar.scrollTop, 40)
            verify(vertical.position > 0)
        }
        if (data.contentWidth > scrollbar.availableWidth) {
            compare(scrollbar.scrollLeft, 40)
            verify(horizontal.position > 0)
        }
        scrollbar.width = 200
        scrollbar.height = 160
        verify(waitForItemPolished(scrollbar))
        compare(vertical.height, scrollbar.availableHeight)
        compare(horizontal.width, scrollbar.availableWidth)
        compare(vertical.x, scrollbar.width - vertical.width)
        compare(horizontal.y, scrollbar.height - horizontal.height)
        scrollbar.LayoutMirroring.enabled = true
        compare(vertical.x, 0)
    }

    width: 900
    height: 700
    visible: true
    when: windowShown
    name: "EUIWebBasicLayout"

    Component {
        id: spaceComponent

        ESpace {
            property real itemWidth: 80

            width: 400
            fillRatio: 50
            size: [12, 18]

            Rectangle {
                height: 30
                objectName: "firstSpaceItem"
                width: parent.parent.itemWidth
            }
            Rectangle {
                height: 50
                objectName: "secondSpaceItem"
                width: parent.parent.itemWidth + 20
            }
        }
    }
    Component {
        id: flickableComponent

        EScrollbar {
            width: 120
            height: 100

            Flickable {
                property real documentHeight: 500

                contentWidth: 640
                contentHeight: documentHeight
                objectName: "nativeFlickable"

                Rectangle {
                    width: 640
                    height: parent.parent.documentHeight
                }
            }
        }
    }
    Component {
        id: listComponent

        EScrollbar {
            width: 120
            height: 100

            ListView {
                model: 100
                objectName: "nativeListView"
                delegate: Rectangle {
                    height: 40
                    width: 120
                }
            }
        }
    }
    Component {
        id: columnComponent

        EScrollbar {
            width: 120
            height: 100
            maxHeight: 180

            Column {
                Repeater {
                    model: 20

                    Rectangle {
                        height: 24
                        width: 120
                    }
                }
            }
        }
    }
    Component {
        id: explicitScrollComponent

        EScrollbar {
            width: 120
            height: 100
            contentWidth: 500
            contentHeight: 600

            Rectangle {
                height: 50
                width: 100
            }
            Rectangle {
                x: 400
                y: 550
                height: 50
                width: 100
            }
        }
    }
    Component {
        id: attachedContainerComponent

        EContainer {
            width: 600
            height: 400

            EHeader {
                Layout.preferredHeight: 90
                objectName: "attachedHeader"
            }
            EContainer {
                EAside {
                    Layout.preferredWidth: 250
                    objectName: "attachedAside"
                }
                EMain {}
            }
            EFooter {
                Layout.preferredHeight: 70
                objectName: "attachedFooter"
            }
        }
    }
    Component {
        id: containerComponent

        EContainer {
            property real headerRatio: 0.2

            width: 600
            height: 400

            EHeader {
                objectName: "containerHeader"
                height: parent.parent.height * parent.parent.headerRatio
            }
            EContainer {
                objectName: "containerBody"

                EAside {
                    width: parent.width * 0.4
                    objectName: "containerAside"
                }
                EMain {
                    objectName: "containerMain"
                }
            }
            EFooter {
                height: 70
                objectName: "containerFooter"
            }
        }
    }
}

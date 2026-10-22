import EUI 1.0
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Controls 2.15

TestCase {
    id: testCase

    function cleanup() {
        provider.size = EStyle.Small
        provider.disabled = false
        link.enabled = true
        mouseMove(testCase, width - 1, height - 1)
    }

    function test_gridWrapAndResize() {
        grid.width = 400
        wait(0)
        compare(firstCol.width, 194)
        compare(secondCol.x, 206)
        compare(fullCol.width, 400)
        compare(fullCol.y, 52)
        compare(grid.implicitHeight, 72)
        grid.width = 600
        wait(0)
        compare(firstCol.width, 294)
        compare(fullCol.width, 600)
    }

    function test_linkFontAndDisabledState() {
        link.forceActiveFocus()
        verify(link.activeFocus)
        compare(link.Accessible.role, Accessible.Link)
        mouseMove(link, link.width / 2, link.height / 2)
        tryCompare(link, "hovered", true)
        compare(link.contentItem.font.underline, true)
        link.enabled = false
        verify(!link.enabled)
        compare(link.contentItem.font.underline, false)
    }

    function test_splitterResizeConstraints() {
        waitForRendering(splitter)
        verify(leftPane.width >= 100)
        const initialWidth = leftPane.width
        mouseDrag(splitter, leftPane.width + 3, splitter.height / 2, 40, 0)
        verify(waitForItemPolished(splitter))
        verify(leftPane.width > initialWidth)
        verify(rightPane.width >= 100)
        mouseDrag(splitter, leftPane.width + 3, splitter.height / 2, -500, 0)
        verify(waitForItemPolished(splitter))
        verify(leftPane.width >= 100)
        verify(rightPane.width >= 100)
    }

    function test_buttonTracksChangingTextWidth() {
        const button = createTemporaryObject(lateButtonComponent, testCase)
        button.text = "A"
        tryVerify(function() {
            return button.contentItem.item.children[0].children[1].text === "A"
                && button.implicitWidth === button.contentItem.item.children[0].children[1].implicitWidth
                    + button.leftPadding + button.rightPadding
        })
        const shortWidth = button.implicitWidth
        button.text = "A much longer translated label"
        tryVerify(function() {
            return button.implicitWidth > shortWidth + 100
        })
        verify(button.implicitWidth > button.leftPadding + button.rightPadding)
        button.text = "A"
        tryCompare(button, "implicitWidth", shortWidth)
    }

    function test_configProviderInheritanceAndOverrides() {
        compare(inherited.size, EStyle.Small)
        compare(explicit.size, EStyle.Large)
        compare(explicitMedium.size, EStyle.Medium)
        compare(space.size, 16)
        provider.size = EStyle.Large
        tryCompare(inherited, "size", EStyle.Large)
        compare(explicit.size, EStyle.Large)
        compare(explicitMedium.size, EStyle.Medium)
        compare(space.size, 16)
        compare(nestedButton.size, EStyle.Small)
        const lateButton = createTemporaryObject(lateButtonComponent, lateHost)
        verify(lateButton)
        tryCompare(lateButton, "size", EStyle.Large)
        provider.size = EStyle.Small
        tryCompare(lateButton, "size", EStyle.Small)
        provider.disabled = true
        verify(!inherited.enabled)
        verify(!lateButton.enabled)
    }

    width: 620
    height: 460
    visible: true
    name: "EUIBasic"
    when: windowShown

    EConfigProvider {
        id: provider

        width: 500
        height: 140
        size: EStyle.Small

        Row {
            spacing: 16

            EButton {
                id: inherited

                text: "Inherited"
            }
            EButton {
                id: explicit

                text: "Explicit"
                size: EStyle.Large
            }
            ESpace {
                id: space

                size: 16
            }
            EButton {
                id: explicitMedium

                text: "Medium"
                size: EStyle.Medium
            }
            EConfigProvider {
                height: 40
                width: 100
                size: EStyle.Small

                EButton {
                    id: nestedButton

                    text: "Nested"
                }
            }
        }
        Item {
            id: lateHost

            y: 60
            height: 40
            width: 200
        }
    }
    ELink {
        id: link

        y: 160
        text: "Link"
    }
    ESplitter {
        id: splitter

        y: 220
        width: 500
        height: 160

        ERectangle {
            id: leftPane

            SplitView.minimumWidth: 100
            SplitView.preferredWidth: 180
        }
        ERectangle {
            id: rightPane

            SplitView.fillWidth: true
            SplitView.minimumWidth: 100
        }
    }
    Component {
        id: lateButtonComponent

        EButton {
            text: "Late"
        }
    }
    ERow {
        id: grid

        y: 390
        gutter: 12
        width: 400

        ECol {
            id: firstCol

            span: 12
            height: 40
        }
        ECol {
            id: secondCol

            span: 12
            height: 40
        }
        ECol {
            id: fullCol

            span: 24
            height: 20
        }
    }
}

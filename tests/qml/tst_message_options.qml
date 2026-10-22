import EUI 1.0
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Controls 2.15

TestCase {
    id: testCase

    property int closedCount: 0

    function cleanup() {
        messages.clear()
        wait(350)
        messages.plain = false
        messages.textColor = EPaletteManager.BasePalette.transparent
        messages.backgroundColor = EPaletteManager.BasePalette.transparent
    }

    function findMessage(key) {
        const overlay = messages.Overlay.overlay
        if (!overlay)
            return null
        for (let index = 0; index < overlay.children.length; ++index) {
            const item = overlay.children[index]
            if (item.manager === messages && item.key === key)
                return item
        }
        return null
    }

    function test_destroyOwnerWithActiveMessages() {
        for (let cycle = 0; cycle < 5; ++cycle) {
            const owner = messageComponent.createObject(window.contentItem)
            verify(owner !== null)
            owner.open("Temporary", "temporary-" + cycle, 0)
            owner.destroy()
            wait(0)
            messages.open("Next", "next-" + cycle, 0)
            verify(messages.close("next-" + cycle))
            wait(350)
        }
    }

    function test_closeAfterPlacementChanges() {
        closedCount = 0
        messages.placement = EPlacement.Top
        messages.open("First", "first", 0)
        messages.open("Second", "second", 0)
        compare(findMessage("first").messagePlacement, EPlacement.Top)
        messages.placement = EPlacement.Bottom
        compare(findMessage("first").messagePlacement, EPlacement.Top)
        verify(messages.close("first"))
        verify(!messages.close("first"))
        verify(messages.close("second"))
        tryCompare(testCase, "closedCount", 2)
        compare(findMessage("first"), null)
        compare(findMessage("second"), null)
        messages.placement = EPlacement.Top
    }

    function test_optionsStayLocalToEachMessage() {
        const textColor = EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Danger)
        const backgroundColor = EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Warning)
        messages.open({ message: "Custom", key: "custom", duration: 0,
            plain: true, textColor: textColor, backgroundColor: backgroundColor })
        messages.open("Default", "default", 0)
        const custom = findMessage("custom")
        const standard = findMessage("default")
        verify(custom !== null)
        verify(standard !== null)
        compare(custom.messagePlain, true)
        compare(standard.messagePlain, false)
        compare(String(custom.messageTextColor), String(textColor))
        compare(String(custom.messageBackgroundColor), String(backgroundColor))
        compare(String(custom.children[0].color), String(backgroundColor))
        let customText = null
        for (let index = 0; index < custom.children.length; ++index) {
            if (custom.children[index].text === custom.message) {
                customText = custom.children[index]
                break
            }
        }
        verify(customText !== null)
        compare(String(customText.color), String(textColor))
        compare(String(standard.messageTextColor), String(EPaletteManager.BasePalette.transparent))
        compare(messages.plain, false)
        compare(String(messages.textColor), String(EPaletteManager.BasePalette.transparent))
        messages.plain = true
        messages.textColor = backgroundColor
        messages.backgroundColor = textColor
        compare(custom.messagePlain, true)
        compare(standard.messagePlain, false)
        compare(String(custom.messageTextColor), String(textColor))
        compare(String(standard.messageTextColor), String(EPaletteManager.BasePalette.transparent))
        messages.open({ key: "empty", duration: 0 })
        compare(findMessage("empty").message, "")
    }

    width: 640
    height: 480
    visible: true
    when: windowShown
    name: "EUIMessageOptions"

    ApplicationWindow {
        id: window

        width: 640
        height: 480
        visible: true

        EMessage {
            id: messages

            duration: 0

            onClosed: ++testCase.closedCount
        }
    }
    Component {
        id: messageComponent

        EMessage {
            duration: 0
        }
    }
}

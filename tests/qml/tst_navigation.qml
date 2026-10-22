import EUI 1.0
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    property int notificationClosedCount: 0
    property bool reopenNotificationOnClose: false

    function click(item) {
        mouseClick(item, item.width / 2, item.height / 2, Qt.LeftButton)
    }

    function test_tabsAddButtonFollowsNavigation_data() {
        return [{tag: "top", position: "top"}, {tag: "bottom", position: "bottom"},
            {tag: "left", position: "left"}, {tag: "right", position: "right"}]
    }

    function linkLabel(item, text) {
        if (item.text === text && item.contentWidth !== undefined)
            return item
        for (let index = 0; index < item.children.length; ++index) {
            const label = linkLabel(item.children[index], text)
            if (label)
                return label
        }
        return null
    }

    function test_dropdownInteraction() {
        click(dropdown)
        tryCompare(dropdown.menu, "visible", true)
        compare(dropdown.menu.count, 2)
        verify(!dropdown.menu.itemAt(1).enabled)
        keyClick(Qt.Key_Escape)
        tryCompare(dropdown.menu, "visible", false)
        dropdown.enabled = false
        dropdown.open()
        compare(dropdown.menu.visible, false)
        dropdown.enabled = true
    }

    function test_stepsBoundaries() {
        compare(steps.statusAt(0), "process")
        steps.advance()
        compare(steps.statusAt(0), "finish")
        compare(steps.statusAt(1), "process")
        steps.active = 100
        compare(steps.active, 3)
        steps.active = -1
        compare(steps.active, 0)
        steps.model = null
        compare(steps.count, 0)
        compare(steps.active, 0)
        verify(!steps.select(0))
        steps.model = ["First", "Second", "Last"]
    }

    function test_scrollNavigation() {
        verify(!anchor.scrollTo(-1))
        verify(!anchor.scrollTo(NaN))
        verify(!anchor.scrollTo(0.5))
        verify(anchor.scrollTo(1))
        compare(scroll.contentY, 240)
        compare(anchor.currentIndex, 1)
        tryCompare(backtop, "visible", true)
        verify(backtop.scrollToTop())
        tryCompare(scroll, "contentY", 0)
        tryCompare(backtop, "visible", false)
        scroll.contentY = 80
        verify(affix.fixed)
    }

    function test_notificationsGroupingAndClose() {
        notificationClosedCount = 0
        const key = notification.open({ key: "one", title: "Saved", message: "Done", duration: 0 })
        compare(key, "one")
        compare(notification.open({ title: "Saved", message: "Done" }), key)
        compare(notification.count, 1)
        verify(notification.close(key))
        tryCompare(testCase, "notificationClosedCount", 1)
        verify(!notification.close("missing"))
    }

    function cleanup() {
        dialog.close()
        drawer.close()
        popover.close()
        popconfirm.close()
        messageBox.close()
        dropdown.close()
        notification.clear()
        reopenNotificationOnClose = false
        tryCompare(dialog, "visible", false)
        tryCompare(drawer, "visible", false)
        tabs.model = [{ text: "First" }, { text: "Disabled", disabled: true }, { text: "Last" }]
        tabs.currentIndex = 0
        tabs.enabled = true
        steps.active = 0
        scroll.contentY = 0
    }

    function test_notificationsReopenAfterClear() {
        notificationClosedCount = 0
        notification.open({ key: "before-clear", title: "First", message: "Done", duration: 0 })
        reopenNotificationOnClose = true
        compare(notification.clear(), 1)
        tryCompare(testCase, "notificationClosedCount", 1)
        compare(notification.count, 1)
        compare(notification.clearing, false)
        verify(notification.close("after-clear"))
        tryCompare(notification, "count", 0)
        compare(notificationClosedCount, 2)
    }

    function test_overlayEscapePoliciesAreIndependent() {
        dialog.closeOnEscape = false
        dialog.open()
        tryCompare(dialog, "opened", true)
        keyClick(Qt.Key_Escape)
        compare(dialog.visible, true)
        dialog.close()
        tryCompare(dialog, "visible", false)
        dialog.closeOnEscape = true
        drawer.closeOnEscape = false
        drawer.open()
        tryCompare(drawer, "opened", true)
        keyClick(Qt.Key_Escape)
        compare(drawer.visible, true)
        drawer.close()
        tryCompare(drawer, "visible", false)
        drawer.closeOnEscape = true
    }

    function test_tabsSelectionAndRemoval() {
        compare(tabs.count, 3)
        verify(!tabs.select(NaN))
        verify(!tabs.select(0.5))
        verify(!tabs.closeTab(NaN))
        verify(!tabs.closeTab(0.5))
        verify(!tabs.select(1))
        verify(!tabs.select(-1))
        verify(tabs.select(2))
        compare(tabs.currentIndex, 2)
        verify(tabs.closeTab(2))
        tryCompare(tabs, "currentIndex", 0)
        compare(tabs.count, 2)
        tabs.enabled = false
        verify(!tabs.select(0))
        tabs.enabled = true
        tabs.model = []
        tryCompare(tabs, "currentIndex", -1)
        tabs.model = null
        tryCompare(tabs, "count", 0)
        verify(!tabs.select(0))
        verify(!tabs.closeTab(0))
    }

    function test_overlayReferencesAndEscape() {
        for (let cycle = 0; cycle < 2; ++cycle) {
            click(referenceButton)
            tryCompare(popover, "visible", true)
            verify(popover.implicitHeight > 32)
            keyClick(Qt.Key_Escape)
            tryCompare(popover, "visible", false)
            dialog.open()
            tryCompare(dialog, "visible", true)
            keyClick(Qt.Key_Escape)
            tryCompare(dialog, "visible", false)
            drawer.open()
            tryCompare(drawer, "opened", true)
            keyClick(Qt.Key_Escape)
            tryCompare(drawer, "visible", false)
        }
        click(referenceButton)
        tryCompare(popover, "visible", true)
        referenceButton.enabled = false
        tryCompare(popover, "visible", false)
        referenceButton.enabled = true
    }

    function test_popconfirmActionsAndPromptValidation() {
        confirmedSpy.clear()
        click(confirmReference)
        tryCompare(popconfirm, "visible", true)
        const acceptButton = findChild(popconfirm, "confirmButton")
        verify(acceptButton)
        click(acceptButton)
        tryCompare(popconfirm, "visible", false)
        compare(confirmedSpy.count, 1)
        messageBox.inputValidator = function(value) {
            return value.length >= 3 || "Too short"
        }
        messageBox.prompt("Name", "Create", "a")
        tryCompare(messageBox, "opened", true)
        const confirmButton = findChild(messageBox, "messageBoxConfirmButton")
        verify(confirmButton)
        click(confirmButton)
        compare(messageBox.visible, true)
        compare(messageBox.inputErrorMessage, "Too short")
        messageBox.inputValue = "valid"
        click(confirmButton)
        tryCompare(messageBox, "visible", false)
        messageBox.prompt("Name", "Create", "")
        compare(messageBox.inputValue, "")
        compare(messageBox.inputErrorMessage, "")
        tryCompare(messageBox, "opened", true)
        click(confirmButton)
        compare(messageBox.inputErrorMessage, "Too short")
    }

    function test_tabsAddButtonFollowsNavigation(data) {
        const item = createTemporaryObject(tabsStyleComponent, testCase,
            {tabPosition: data.position})
        verify(waitForItemPolished(item.contentItem))
        const bar = item.navigation
        const origin = bar.mapToItem(item, 0, 0)
        let add = null
        for (let index = 0; index < item.children.length; ++index) {
            if (item.children[index].iconSource === item.addIcon)
                add = item.children[index]
        }
        verify(add)
        tryVerify(function() {
            return item.activePane !== null
        })
        compare(item.activePane.objectName, "tabsStylePane")
        verify(add.height <= bar.implicitHeight)
        verify(add.y + add.height <= item.height - item.bottomPadding)
        if (item.vertical) {
            compare(add.x, origin.x)
            compare(add.width, bar.width)
            compare(add.y, origin.y + bar.height)
            verify(add.width < item.width)
        } else {
            compare(add.y, origin.y)
            compare(add.height, bar.height)
            verify(add.x >= origin.x + bar.width)
        }
        verify(item.select(1))
        verify(waitForItemPolished(item.contentItem))
        compare(item.activePane.objectName, "tabsStylePane")
        verify(linkLabel(bar, "Custom tab label"))
    }

    function test_anchorTitlesStayInsideNarrowLinks() {
        const item = createTemporaryObject(anchorStyleComponent, testCase)
        verify(waitForItemPolished(item.contentItem))
        const links = []
        for (let index = 0; index < item.contentItem.children.length; ++index) {
            const child = item.contentItem.children[index]
            if (child.minHeight !== undefined)
                links.push(child)
        }
        compare(links.length, 3)
        const labels = [linkLabel(links[0].contentItem, links[0].text),
            linkLabel(links[1].contentItem, links[1].text)]
        for (let index = 0; index < 2; ++index) {
            const link = links[index]
            const label = labels[index]
            verify(label)
            const origin = label.mapToItem(link, 0, 0)
            verify(origin.x >= link.leftPadding)
            verify(label.contentWidth <= link.availableWidth + 1)
            verify(origin.x + label.contentWidth <= link.width - link.rightPadding + 1)
        }
        compare(labels[0].mapToItem(links[0], 0, 0).x, labels[1].mapToItem(links[1], 0, 0).x)
        verify(labels[0].implicitWidth > links[0].availableWidth)
        verify(labels[1].implicitWidth <= links[1].availableWidth)
        verify(Math.abs(labels[1].contentWidth - labels[1].implicitWidth) <= 1)
        const custom = findChild(item, "anchorStyleCustom")
        verify(custom)
        compare(links[2].contentItem.visible, false)
        compare(custom.width, links[2].availableWidth)
        item.width = 240
        verify(waitForItemPolished(item.contentItem))
        verify(labels[0].contentWidth <= links[0].availableWidth + 1)
        compare(custom.width, links[2].availableWidth)
    }

    width: 640
    height: 480
    visible: true
    when: windowShown
    name: "EUINavigation"

    ETabs {
        id: tabs

        width: 400
        model: [{ text: "First" }, { text: "Disabled", disabled: true }, { text: "Last" }]
    }
    ESteps {
        id: steps

        y: 60
        width: 400
        model: ["First", "Second", "Last"]
    }
    EDropdown {
        id: dropdown

        y: 150
        text: "Actions"
        model: [{ text: "Open", command: "open" }, { text: "Disabled", disabled: true }]
    }
    EButton {
        id: referenceButton

        y: 200
        text: "Popover"
    }
    EButton {
        id: confirmReference

        x: 180
        y: 200
        text: "Confirm"
    }
    EPopover {
        id: popover

        title: "Details"
        text: "Useful content"
        reference: referenceButton
    }
    EPopconfirm {
        id: popconfirm

        text: "Continue?"
        reference: confirmReference
    }
    EDialog {
        id: dialog

        exitDuration: 0
        text: "Content"
        title: "Dialog"
        enterDuration: 0
    }
    EDrawer {
        id: drawer

        title: "Drawer"
    }
    EMessageBox {
        id: messageBox

        exitDuration: 0
        enterDuration: 0
    }
    ENotification {
        id: notification

        duration: 0
        grouping: true
        animationDuration: 0

        onClosed: {
            ++testCase.notificationClosedCount
            if (testCase.reopenNotificationOnClose) {
                testCase.reopenNotificationOnClose = false
                open({ key: "after-clear", title: "Second", message: "Done", duration: 0 })
            }
        }
    }
    Flickable {
        id: scroll

        x: 450
        clip: true
        width: 180
        height: 180
        contentHeight: 640

        EText {
            id: firstSection

            text: "First"
        }
        EAffix {
            id: affix

            y: 20
            target: scroll

            EButton {
                text: "Sticky"
            }
        }
        EText {
            id: secondSection

            y: 240
            text: "Second"
        }
    }
    EAnchor {
        id: anchor

        target: scroll
        visible: false
        model: [{ text: "First", target: firstSection }, { text: "Second", target: secondSection }]
    }
    EBacktop {
        id: backtop

        x: 560
        y: 260
        duration: 0
        target: scroll
        visibilityHeight: 100
    }
    SignalSpy {
        id: confirmedSpy

        target: popconfirm
        signalName: "confirmed"
    }
    Component {
        id: anchorStyleTitleComponent

        EText {
            height: 18
            text: "Custom title"
            objectName: "anchorStyleCustom"
        }
    }
    Component {
        id: anchorStyleComponent

        EAnchor {
            width: 120
            model: [{text: "A long anchor title that must remain inside its link"},
                {text: "Short"}, {text: "Custom", contentComponent: anchorStyleTitleComponent}]
        }
    }
    Component {
        id: tabsStylePaneComponent

        Item {
            implicitHeight: 120
            objectName: "tabsStylePane"

            EText {
                anchors.fill: parent
                text: "Pane content"
                wrapMode: Text.WordWrap
            }
        }
    }
    Component {
        id: tabsStyleLabelComponent

        EText {
            text: "Custom tab label"
        }
    }
    Component {
        id: tabsStyleComponent

        ETabs {
            width: 320
            addable: true
            model: [{text: "Overview", contentComponent: tabsStylePaneComponent},
                {text: "Custom", labelComponent: tabsStyleLabelComponent, contentComponent: tabsStylePaneComponent}]
        }
    }
}

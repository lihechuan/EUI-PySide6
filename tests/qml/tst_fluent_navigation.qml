import EUI 1.0
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Controls 2.15

TestCase {
    id: testCase

    property int addCount: 0
    property int retryCount: 0
    property int commandCount: 0
    property string lastCommand: ""

    function stepAt(index) {
        const children = steps.contentItem.children
        for (let position = 0; position < children.length; ++position) {
            if (children[position].stepIndex === index)
                return children[position]
        }
        return null
    }

    function test_menuBarKeyboardNavigation() {
        window.requestActivate()
        waitForRendering(window.contentItem)
        verify(menuBar.open(0))
        wait(0)
        keyClick(Qt.Key_Right)
        tryCompare(menuBar, "activeIndex", 1)
        keyClick(Qt.Key_Left)
        tryCompare(menuBar, "activeIndex", 0)
        keyClick(Qt.Key_Escape)
        tryCompare(menuBar, "activeIndex", -1)
    }

    function childrenWith(item, propertyName) {
        const result = []
        for (let index = 0; index < item.children.length; ++index) {
            if (item.children[index][propertyName] !== undefined)
                result.push(item.children[index])
            else {
                const nested = childrenWith(item.children[index], propertyName)
                for (let child = 0; child < nested.length; ++child)
                    result.push(nested[child])
            }
        }
        return result
    }

    function test_tabsAddMoveAndClose() {
        verify(tabs.requestAdd())
        compare(addCount, 1)
        verify(tabs.moveTab(1, 2))
        compare(tabs.model, ["First", "Third", "Second"])
        compare(tabs.currentIndex, 2)
        verify(tabs.moveTab(0, 2))
        compare(tabs.currentIndex, 1)
        verify(tabs.closeTab(1))
        compare(tabs.model, ["Third", "First"])
        verify(!tabs.moveTab(0.5, 1))
        verify(!tabs.moveTab(0, NaN))
        tabs.enabled = false
        verify(!tabs.requestAdd())
        verify(!tabs.moveTab(0, 1))
    }

    function test_statusViewContentAndTransitions() {
        verify(normalLabel.visible)
        statusView.state = "loading"
        verify(!normalLabel.visible)
        compare(statusView.activeView.visible, true)
        statusView.state = "empty"
        verify(statusView.implicitHeight > 120)
        statusView.state = "error"
        const result = statusView.activeView
        compare(result.styleType, EStyle.Danger)
        statusView.retry()
        compare(retryCount, 1)
        statusView.state = "normal"
        verify(normalLabel.visible)
    }

    function init() {
        steps.enabled = true
        steps.clickable = true
        steps.simple = false
        steps.alignCenter = false
        steps.direction = EOrientation.Horizontal
        steps.processStatus = "process"
        steps.finishStatus = "finish"
        steps.model = [{ title: "Start", description: "Description" }, { title: "Next" }, { title: "Disabled", disabled: true }]
        steps.active = 0
        tabs.enabled = true
        tabs.model = ["First", "Second", "Third"]
        tabs.currentIndex = 1
        tabs.addable = true
        tabs.movable = true
        menuBar.enabled = true
        menuBar.close()
        statusView.state = "normal"
        addCount = 0
        retryCount = 0
        commandCount = 0
        lastCommand = ""
    }

    function test_tabsPointerReorder() {
        for (const position of ["top", "bottom", "left", "right"]) {
            tabs.tabPosition = position
            tabs.model = ["First", "Second", "Third"]
            tabs.currentIndex = 1
            verify(waitForItemPolished(tabs))
            verify(waitForRendering(tabs))
            const items = childrenWith(tabs.contentItem, "tabIndex")
            compare(items.length, 3)
            const destination = items[2].mapToItem(items[0], 20, 10)
            mousePress(items[0], 20, 10, Qt.LeftButton)
            mouseMove(items[0], destination.x, destination.y, 20)
            mouseRelease(items[0], destination.x, destination.y, Qt.LeftButton)
            compare(tabs.model, ["Second", "Third", "First"])
            compare(tabs.currentIndex, 0)
        }
        tabs.tabPosition = "top"
    }

    function test_stepsStatesAndLayout() {
        compare(steps.count, 3)
        compare(steps.statusAt(0), "process")
        verify(stepAt(0) !== null)
        verify(stepAt(0).height > 28)
        verify(steps.select(1))
        compare(steps.statusAt(0), "finish")
        compare(steps.statusAt(1), "process")
        verify(!steps.select(2))
        verify(!steps.select(NaN))
        verify(!steps.select(0.5))
        steps.processStatus = "error"
        compare(stepAt(1).status, "error")
        steps.alignCenter = true
        steps.direction = EOrientation.Vertical
        wait(0)
        verify(steps.implicitHeight >= 3 * 86)
        steps.direction = EOrientation.Horizontal
        steps.simple = true
        tryCompare(steps, "implicitHeight", 64)
        steps.model = null
        compare(steps.count, 0)
        compare(steps.active, 0)
        verify(!steps.select(0))
    }

    function test_menuBarNestedMenusAndCommands() {
        verify(!menuBar.open(-1))
        verify(!menuBar.open(NaN))
        verify(!menuBar.open(2))
        verify(menuBar.open(0))
        compare(menuBar.activeIndex, 0)
        const button = childrenWith(menuBar.contentItem, "menu")[0]
        tryCompare(button.menu, "visible", true)
        compare(button.menu.count, 3)
        verify(!button.menu.itemAt(2).enabled)
        const submenu = button.menu.menuAt(1)
        verify(submenu !== null)
        submenu.open()
        tryCompare(submenu, "count", 1)
        submenu.itemAt(0).triggered()
        compare(lastCommand, "project")
        compare(commandCount, 1)
        compare(menuBar.activeIndex, -1)
        verify(menuBar.open(0))
        verify(menuBar.move(1))
        compare(menuBar.activeIndex, 1)
        menuBar.close()
        compare(menuBar.activeIndex, -1)
        verify(!menuBar.move(NaN))
        verify(!menuBar.move(0))
        menuBar.enabled = false
        verify(!menuBar.open(0))
    }

    function test_nativeMenuFlattening() {
        const disabled = [{ index: "root", disabled: true, children: [{ index: "child" }] }]
        const entries = EDataUtils.menuEntries(disabled, ["root"], false)
        compare(entries.length, 2)
        verify(entries[1].disabled)
        compare(entries[1].indexPath, ["root", "child"])
        verify(entries[0].item === disabled[0])
        const cycle = { index: "cycle" }
        cycle.children = [cycle]
        compare(EDataUtils.menuEntries([cycle], ["cycle"], false).length, 1)
        let deep = { index: "1500" }
        const expanded = []
        for (let level = 1499; level >= 0; --level) {
            expanded.push(String(level))
            deep = { index: String(level), children: [deep] }
        }
        const deepEntries = EDataUtils.menuEntries([deep], expanded, false)
        compare(deepEntries.length, 1501)
        compare(deepEntries[1500].level, 1500)
        compare(EDataUtils.menuEntries([deep], null, false).length, 1)
        compare(EDataUtils.menuEntries([deep], expanded, true).length, 1)
    }

    width: 700
    height: 600
    visible: true
    when: windowShown
    name: "EUIFluentNavigation"

    ApplicationWindow {
        id: window

        width: 700
        height: 600
        visible: true

        EMenuBar {
            id: menuBar

            width: 500
            model: [{ text: "File", children: [
                { text: "Open", index: "open" },
                { text: "New", children: [{ text: "Project", index: "project" }] },
                { text: "Disabled", disabled: true }
            ] }, { text: "View", children: [{ text: "Zoom", index: "zoom" }] }, { text: "Disabled", disabled: true }]

            onCommand: function(index) {
                ++testCase.commandCount
                testCase.lastCommand = index
            }
        }
        ESteps {
            id: steps

            y: 50
            width: 600
        }
        ETabs {
            id: tabs

            y: 320
            width: 600
            closable: true

            onTabAddRequested: ++testCase.addCount
        }
        EStatusView {
            id: statusView

            y: 380
            width: 600
            height: 200

            onRetry: ++testCase.retryCount

            EText {
                id: normalLabel

                text: "Content"
            }
        }
    }
}

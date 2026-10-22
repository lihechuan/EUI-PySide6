import EUI 1.0
import "../../source/qml/EUI/controls/data" as Data
import "../../source/qml/EUI/controls/basic" as Basic
import "../../source/qml/EUI/controls/private" as Private
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Controls 2.15

TestCase {
    id: testCase

    function test_scrollbarLongContent_data() {
        return [{tag: "vertical", vertical: true}, {tag: "horizontal", vertical: false}]
    }

    function test_infiniteScrollAppendAndReplace_data() {
        return [
            {tag: "same-length", appended: 0},
            {tag: "append", appended: 4},
            {tag: "empty", appended: -20}
        ]
    }

    function bars(root) {
        const result = []
        const pending = [root]
        while (pending.length > 0) {
            const item = pending.pop()
            if (item.policy !== undefined && item.position !== undefined && item.size !== undefined)
                result.push(item)
            const children = item.children || []
            for (let index = 0; index < children.length; ++index)
                pending.push(children[index])
        }
        return result
    }

    function test_scrollbarRespectsPoliciesAndContent() {
        const bar = createTemporaryObject(handleComponent, testCase)
        compare(bar.visible, false)
        bar.size = 0.3
        compare(bar.visible, true)
        bar.policy = ScrollBar.AlwaysOff
        compare(bar.visible, false)
        bar.policy = ScrollBar.AlwaysOn
        compare(bar.visible, true)
        bar.size = 1
        compare(bar.visible, false)
        bar.size = 0
        compare(bar.visible, false)
    }

    function test_scrollbarShortViewport() {
        const scroll = createTemporaryObject(scrollComponent, testCase, {height: 24, contentHeight: 20000})
        verify(waitForItemPolished(scroll))
        const bar = scroll.ScrollBar.vertical
        verify(bar.minimumSize < 1, "A short track must leave room for thumb movement")
        mouseDrag(bar, bar.width / 2, bar.contentItem.y + bar.contentItem.height / 2, 0, 30)
        verify(isFinite(scroll.scrollTop))
        verify(scroll.scrollTop > 10000)
    }

    function test_scrollbarDraggingAndTheme() {
        const scroll = createTemporaryObject(scrollComponent, testCase)
        verify(waitForItemPolished(scroll))
        const bar = scroll.ScrollBar.vertical
        const thumb = bar.contentItem
        compare(thumb.width, 8)
        compare(thumb.radius, 4)
        verify(thumb.height >= scroll.minSize)
        const light = thumb.color.toString()
        ETheme.dark = true
        verify(thumb.color.toString() !== light)
        ETheme.dark = false
        mouseDrag(bar, bar.width / 2, thumb.y + thumb.height / 2, 0, 70)
        verify(scroll.scrollTop > 100)
        verify(bar.position > 0)
        scroll.setScrollTop(0)
        compare(scroll.scrollTop, 0)
    }

    function test_scrollbarOnlyUsesItsAttachedHandles() {
        const scroll = createTemporaryObject(scrollComponent, testCase)
        verify(waitForItemPolished(scroll))
        const handles = bars(scroll)
        compare(handles.length, 2, "A scroll view must only have one handle for each axis")
        verify(handles.indexOf(scroll.ScrollBar.vertical) >= 0)
        verify(handles.indexOf(scroll.ScrollBar.horizontal) >= 0)
        compare(scroll.ScrollBar.vertical.size, scroll.availableHeight / scroll.contentHeight)
        compare(scroll.ScrollBar.horizontal.visible, false)
        scroll.setScrollTop(400)
        verify(scroll.ScrollBar.vertical.position > 0)
    }

    function test_infiniteScrollKeepsUserMovementWhileLoading() {
        const rows = []
        for (let index = 0; index < 20; ++index)
            rows.push("Row " + index)
        const list = createTemporaryObject(listComponent, testCase, {model: rows})
        tryVerify(function() { return list.contentHeight > list.height })
        list.forceLayout()
        list.contentY = list.contentHeight - list.height
        verify(list.checkLoad() || list.loading)
        list.contentY -= 80
        const position = list.contentY
        list.model = rows.concat(["Row 20", "Row 21"])
        list.finishLoad(true)
        verify(waitForItemPolished(list))
        compare(list.contentY, position, "A response must preserve the user's latest reading position")
    }

    function test_infiniteScrollKeepsPositionAfterAppending() {
        const rows = []
        for (let index = 0; index < 20; ++index)
            rows.push("Row " + index)
        const list = createTemporaryObject(listComponent, testCase, {model: rows})
        verify(waitForItemPolished(list))
        compare(list.loading, false)
        tryVerify(function() { return list.contentHeight > list.height })
        list.forceLayout()
        list.contentY = list.contentHeight - list.height
        verify(list.checkLoad() || list.loading)
        tryCompare(list, "loading", true)
        const position = list.contentY
        verify(position > 0)
        list.model = rows.concat(["Row 20", "Row 21", "Row 22", "Row 23"])
        list.finishLoad(true)
        verify(waitForItemPolished(list))
        compare(list.count, 24)
        compare(list.contentY, position, "Appending a page must preserve the visible position")
    }

    function test_infiniteScrollAppendAndReplace(data) {
        const rows = []
        for (let index = 0; index < 20; ++index)
            rows.push("Row " + index)
        const list = createTemporaryObject(listComponent, testCase, {model: rows})
        tryVerify(function() { return list.contentHeight > list.height })
        list.forceLayout()
        list.contentY = list.contentHeight - list.height
        verify(list.checkLoad() || list.loading)
        const position = list.contentY
        const next = rows.slice(0, Math.max(0, rows.length + data.appended))
        for (let index = 0; index < data.appended; ++index)
            next.push("Added " + index)
        list.model = next
        list.finishLoad(true)
        verify(waitForItemPolished(list))
        compare(list.contentY, data.appended < 0 ? list.originY : position)
        list.model = ["A fresh list"]
        verify(waitForItemPolished(list))
        compare(list.contentY, list.originY)
    }

    function test_tableScrollbarStaysInViewport() {
        const table = createTemporaryObject(tableComponent, testCase)
        const rows = []
        for (let index = 0; index < 40; ++index)
            rows.push({name: "Row " + index})
        table.model = rows
        verify(waitForItemPolished(table))
        const view = findChild(table, "tableRows")
        const bar = view.ScrollBar.vertical
        const start = bar.mapToItem(table, bar.width / 2, bar.contentItem.y + bar.contentItem.height / 2)
        verify(start.x < table.width, "A wide table must keep its vertical scrollbar inside the viewport")
        mousePress(table, start.x, start.y)
        compare(bar.pressed, true)
        mouseMove(table, start.x, start.y + 60, 30)
        mouseRelease(table, start.x, start.y + 60)
        verify(view.contentY > 0, "Merged cells must not intercept scrollbar dragging")
        table.setScrollLeft(10000)
        const moved = bar.mapToItem(table, bar.width / 2, 0)
        compare(moved.x, start.x)
    }

    function test_scrollbarLongContent(data) {
        const scroll = createTemporaryObject(scrollComponent, testCase, {
            always: false, contentWidth: 20000, contentHeight: 20000
        })
        verify(waitForItemPolished(scroll))
        const bar = data.vertical ? scroll.ScrollBar.vertical : scroll.ScrollBar.horizontal
        const thumb = bar.contentItem
        verify((data.vertical ? bar.width : bar.height) >= 16)
        verify((data.vertical ? thumb.height : thumb.width) >= 36)
        mouseMove(testCase, 1, 1)
        wait(150)
        verify(thumb.opacity >= 0.35, "An idle scrollbar must remain visible")
        const start = data.vertical ? thumb.y + thumb.height / 2 : thumb.x + thumb.width / 2
        const x = data.vertical ? bar.x + 1 : start
        const y = data.vertical ? start : bar.y + 1
        mousePress(scroll, x, y)
        compare(bar.pressed, true, "The edge of the wider hit area must accept dragging")
        compare(data.vertical ? scroll.scrollTop : scroll.scrollLeft, 0)
        mouseMove(scroll, x + (data.vertical ? 0 : 100), y + (data.vertical ? 100 : 0), 30)
        verify((data.vertical ? scroll.scrollTop : scroll.scrollLeft) > 1000)
        mouseMove(scroll, data.vertical ? -20 : scroll.width + 20,
            data.vertical ? scroll.height + 20 : -20, 30)
        compare(bar.pressed, true)
        mouseRelease(scroll, data.vertical ? -20 : scroll.width + 20,
            data.vertical ? scroll.height + 20 : -20)
        compare(bar.pressed, false)
        verify(Math.abs((data.vertical ? scroll.scrollTop : scroll.scrollLeft)
            - (data.vertical ? scroll.contentHeight - scroll.availableHeight
                : scroll.contentWidth - scroll.availableWidth)) < 1)
        mouseClick(bar, data.vertical ? bar.width / 2 : bar.width / 3,
            data.vertical ? bar.height / 3 : bar.height / 2)
        verify(bar.position > 0.2 && bar.position < 0.5)
    }

    width: 640
    height: 480
    visible: true
    when: windowShown
    name: "EUIScrollBehavior"

    Component {
        id: scrollComponent

        Basic.EScrollbar {
            width: 480
            height: 200
            always: true
            contentHeight: 600
            contentWidth: width

            Rectangle {
                height: 600
                width: parent.width
            }
        }
    }
    Component {
        id: listComponent

        Data.EInfiniteScroll {
            delay: 0
            width: 480
            distance: 0
            height: 200
            immediate: false
            delegate: Text {
                height: 40
                text: modelData
            }
        }
    }
    Component {
        id: handleComponent

        Private.ScrollHandle {
            size: 1
            height: 200
            active: true
            orientation: Qt.Vertical
        }
    }
    Component {
        id: tableComponent

        Data.ETable {
            width: 480
            height: 240
            columns: [{prop: "name", label: "Name", width: 1200}]
            spanMethod: function(cell) {
                return cell.rowIndex === 0 ? [2, 1] : cell.rowIndex === 1 ? [0, 0] : [1, 1]
            }
        }
    }
}

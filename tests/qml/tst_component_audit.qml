import EUI 1.0
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function cleanup() {
        ETheme.setDark(false)
    }

    function test_checkboxGroupTracksProgrammaticChanges_data() {
        return [{tag: "plain", buttonStyle: false}, {tag: "button", buttonStyle: true}]
    }

    function test_popoverContentHasInsets() {
        const item = createTemporaryObject(popoverComponent, testCase)
        item.open()
        tryCompare(item, "opened", true)
        compare(item.contentItem.x, item.padding)
        compare(item.contentItem.y, item.padding)
        compare(item.width - item.contentItem.x - item.contentItem.width, item.padding)
        item.close()
    }

    function test_tableRenderedRowsFollowSameCountChanges() {
        const table = createTemporaryObject(tableComponent, testCase)
        verify(waitForItemPolished(table))
        const row = findChild(table, "tableRow")
        compare(row.entry.row.name, "Original")
        table.model = [{id: "b", name: "Replacement"}]
        tryVerify(function() {
            return row.entry.row.name === "Replacement"
        })
    }

    function test_radioLabelsFit(data) {
        const item = createTemporaryObject(data.component, testCase, {size: data.size})
        verify(waitForItemPolished(item))
        verify(item.contentItem.height >= item.contentItem.implicitHeight,
            "Radio labels must fit in every size")
        fuzzyCompare(item.contentItem.y + item.contentItem.height / 2, item.height / 2, 0.5)
        verify(item.contentItem.x + item.contentItem.width <= item.width)
    }

    function test_radioLabelsFit_data() {
        return [{tag: "small", size: EStyle.Small, component: radioComponent},
            {tag: "medium", size: EStyle.Medium, component: radioComponent},
            {tag: "large", size: EStyle.Large, component: radioComponent},
            {tag: "button-small", size: EStyle.Small, component: radioButtonComponent},
            {tag: "button-medium", size: EStyle.Medium, component: radioButtonComponent},
            {tag: "button-large", size: EStyle.Large, component: radioButtonComponent}]
    }

    function test_checkboxGroupTracksProgrammaticChanges(data) {
        const item = createTemporaryObject(groupComponent, testCase, {buttonStyle: data.buttonStyle})
        verify(waitForItemPolished(item))
        const first = item.contentItem.children[0].item
        const second = item.contentItem.children[1].item
        verify(first.checked && !second.checked)
        item.value = ["web"]
        tryCompare(first, "checked", false)
        tryCompare(second, "checked", true)
        mouseClick(first, first.width / 2, first.height / 2)
        compare(item.value, ["web", "desktop"])
    }

    function test_tableRetainedExpansionFollowsRowReplacement() {
        const table = createTemporaryObject(tableComponent, testCase, {
            preserveExpandedContent: true, expandDelegate: expansionComponent, expandRowKeys: ["a", "b"]
        })
        verify(waitForItemPolished(table))
        const row = findChild(table, "tableRow")
        verify(row.retainedContent !== null)
        compare(row.retainedContent.row.id, "a")
        table.model = [{id: "b", name: "Replacement"}]
        tryVerify(function() {
            return row.retainedContent && row.retainedContent.row.id === "b"
        })
        compare(table.preservedExpansions.size, 1)
    }

    function test_menuLabelsFitRows() {
        const item = createTemporaryObject(dropdownComponent, testCase)
        item.open()
        tryCompare(item.menu, "opened", true)
        tryCompare(item.menu, "count", 3)
        for (let index = 0; index < item.menu.count; ++index) {
            const row = item.menu.itemAt(index)
            verify(row.contentItem.height >= row.contentItem.implicitHeight,
                "Opened menu labels must not be squeezed by platform padding")
            fuzzyCompare(row.contentItem.y + row.contentItem.height / 2,
                row.topPadding + row.availableHeight / 2, 0.5)
            compare(row.height, index === 2 ? 42 : 34)
        }
        item.close()
    }

    function test_deepTreeWithMergedRows() {
        const table = createTemporaryObject(tableComponent, testCase)
        let tree = {id: 2000, name: "Leaf"}
        for (let index = 1999; index >= 0; --index)
            tree = {id: index, name: "Node", children: [tree]}
        table.model = [tree]
        table.defaultExpandAll = true
        table.spanMethod = function(context) {
            return context.rowIndex === 0 ? [2, 1] : [1, 1]
        }
        compare(table.displayRows.length, 2001)
        const rows = findChild(table, "tableRows")
        rows.contentY = 22
        verify(waitForItemPolished(table))
        tryVerify(function() {
            return table.mergedRowsAtViewport().length === 1
        })
        compare(table.mergedRowsAtViewport()[0].entry.row.id, 0)
    }

    width: 800
    height: 600
    visible: true
    when: windowShown
    name: "ComponentAudit"

    Component {
        id: expansionComponent

        Item {
            implicitHeight: 60
        }
    }
    Component {
        id: tableComponent

        ETable {
            width: 480
            height: 280
            rowKey: "id"
            model: [{id: "a", name: "Original"}]
            columns: [{prop: "name", label: "Name"}]
        }
    }
    Component {
        id: radioComponent

        ERadio { text: "小尺寸单选框" }
    }
    Component {
        id: groupComponent

        ECheckBoxGroup {
            width: 320
            value: ["desktop"]
            options: [{label: "桌面端", value: "desktop"}, {label: "网页端", value: "web"}]
        }
    }
    Component {
        id: radioButtonComponent

        ERadioButton { text: "小尺寸单选按钮" }
    }
    Component {
        id: dropdownComponent

        EDropdown {
            y: 120
            text: "菜单"
            model: [{text: "打开项目", index: "open"}, {text: "项目设置", index: "settings"},
                {text: "关闭项目", index: "close", divided: true}]
        }
    }
    Component {
        id: popoverComponent

        EPopover {
            x: 100
            y: 180
            title: "项目设置"
            text: "在此调整设置。"
        }
    }
}

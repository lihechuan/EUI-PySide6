import EUI 1.0
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    property int activeRows: 0

    function make(component, properties) {
        const object = createTemporaryObject(component, testCase, properties || {
        })
        verify(object !== null)
        verify(waitForItemPolished(object))
        wait(20)
        return object
    }

    function test_flexGrowthShrinkAndConstraints() {
        const flex = make(flexComponent)
        const first = flex.contentChildren[0]
        const second = flex.contentChildren[1]
        tryCompare(first, "width", 147.5)
        compare(second.width, 242.5)
        second.maxSize = 200
        tryCompare(first, "width", 190)
        compare(second.width, 200)
        flex.width = 150
        tryCompare(first, "width", 70)
        compare(second.width, 70)
        first.minSize = 80
        tryCompare(first, "width", 80)
        compare(second.width, 60)
        first.visible = false
        tryCompare(second, "width", 150)
        compare(second.x, 0)
    }

    function test_applicationContext() {
        const app = make(appComponent)
        const context = app.useApp()
        compare(context.message, app.message)
        compare(context.modal, app.modal)
        compare(context.notification, app.notification)
        app.messageConfig = {
            "duration": 0,
            "max": 1
        }
        tryCompare(app.message, "duration", 0)
        const key = app.message.open("Saved")
        verify(key.length > 0)
        compare(app.message.count, 1)
        app.message.closeAll()
        app.modal.alert("Saved", "Result")
        app.modal.close()
        tryCompare(app.modal, "visible", false)
        app.disabled = true
        compare(app.enabled, false)
    }

    function test_flexWrapReverseAndRestore() {
        const flex = make(fixedFlexComponent)
        const first = flex.contentChildren[0]
        const second = flex.contentChildren[1]
        tryCompare(first, "x", 50)
        compare(second.x, 140)
        flex.reverse = true
        tryCompare(first, "x", 140)
        compare(second.x, 50)
        flex.width = 100
        flex.wrap = true
        flex.reverse = false
        tryVerify(function() {
            return second.y > first.y
        })
        flex.align = "stretch"
        flex.wrap = false
        first.implicitHeight = 20
        second.implicitHeight = 40
        tryCompare(first, "height", 100)
        flex.align = "start"
        tryCompare(first, "height", 20)
        flex.gap = [NaN, -5]
        compare(flex.horizontalGap, 0)
        compare(flex.verticalGap, 0)
        flex.orientation = "vertical"
        tryVerify(function() {
            return second.y > first.y
        })
    }

    function test_listyVirtualizationAndDelegateContext() {
        const entries = []
        for (let index = 0; index < 10000; ++index)
            entries.push({
            "key": index,
            "label": "Item " + index
        })
        const list = make(listyComponent, {
            "items": entries,
            "itemDelegate": countingRow
        })
        tryVerify(function() {
            return activeRows > 0
        })
        verify(activeRows < 50)
        verify(list.scrollTo({
            "key": 9000,
            "align": "top"
        }))
        tryVerify(function() {
            return list.contentY > 200000
        })
        verify(activeRows < 50)
        const before = list.contentY
        verify(!list.scrollTo({
            "key": 2,
            "offset": NaN
        }))
        compare(list.contentY, before)
        const row = findChild(list, "listyTestRow")
        verify(row !== null)
        verify(row.itemData !== null)
        compare(row.itemData.key, row.itemKey)
        list.enabled = false
        verify(!list.scrollTo(0))
        list.enabled = true
        verify(list.scrollTo(0))
        tryCompare(list, "contentY", list.originY)
    }

    function test_floatButtonAndGroup() {
        const group = make(floatGroupComponent)
        compare(group.open, false)
        mouseClick(group.triggerButton)
        compare(group.open, true)
        group.shape = "square"
        const button = findChild(group, "floatAction")
        tryCompare(button, "shape", "square")
        compare(button.circle, false)
        group.placement = "right"
        tryVerify(function() {
            return button.mapToItem(group, 0, 0).x > group.width
        })
        mouseClick(group.triggerButton)
        compare(group.open, false)
        group.trigger = "hover"
        mouseMove(testCase, width - 1, height - 1)
        mouseMove(group.triggerButton, group.triggerButton.width / 2, group.triggerButton.height / 2)
        tryCompare(group, "open", true)
        mouseMove(testCase, width - 1, height - 1)
        tryCompare(group, "open", false)
        group.trigger = "click"
        group.open = true
        group.triggerButton.forceActiveFocus()
        keyClick(Qt.Key_Escape)
        tryCompare(group, "open", false)
        group.enabled = false
        verify(!group.toggle())
        compare(group.open, false)
    }

    function test_borderBeamGeometryAndReducedMotion() {
        const beam = make(beamComponent)
        const canvas = findChild(beam, "borderBeamCanvas")
        verify(canvas !== null)
        const start = canvas.pointAt(0)
        compare(Math.round(start.x), 13)
        compare(Math.round(start.y), 1)
        const wrapped = canvas.pointAt(canvas.perimeter)
        compare(Math.round(wrapped.x), Math.round(start.x))
        beam.count = -10
        compare(beam.beamCount, 1)
        beam.lineWidth = -1
        compare(beam.strokeWidth, 0)
        beam.lineWidth = 2
        beam.reducedMotion = true
        compare(canvas.visible, false)
        beam.reducedMotion = false
        compare(canvas.visible, true)
        beam.color = [{
            "color": "#ff0000",
            "percent": 0
        }, {
            "color": "#0000ff",
            "percent": 100
        }]
        compare(beam.stops.length, 2)
        const tint = beam.colorAt(0.5)
        fuzzyCompare(tint.r, 0.5, 0.01)
        fuzzyCompare(tint.b, 0.5, 0.01)
        beam.running = true
        tryVerify(function() {
            return canvas.phase > 0
        })
        beam.running = false
        const phase = canvas.phase
        wait(30)
        compare(canvas.phase, phase)
    }

    function test_listyGroupingAndKeys() {
        const list = make(listyComponent, {
            "items": [{
                "key": 0,
                "label": "A1",
                "kind": "a"
            }, {
                "key": 1,
                "label": "B1",
                "kind": "b"
            }, {
                "key": 2,
                "label": "A2",
                "kind": "a"
            }],
            "group": {
                "key": "kind",
                "title": function(key, entries) {
                    return key + ":" + entries.length
                }
            },
            "sticky": true
        })
        compare(list.rows.length, 3)
        list.groupHeaderDelegate = groupTitleComponent
        tryVerify(function() {
            return findChild(list, "testGroupTitle") !== null
        })
        const title = findChild(list, "testGroupTitle")
        verify(title.groupTitle.length > 0)
        compare(list.rows[1].key, 2)
        compare(list.rows[1].sourceIndex, 2)
        compare(list.rows[0].groupTitle, "a:2")
        compare(list.errorString, "")
        verify(list.scrollTo({
            "key": 0,
            "align": "top"
        }))
        verify(list.scrollTo({
            "groupKey": "b",
            "align": "top"
        }))
        verify(!list.scrollTo({
            "key": "unknown"
        }))
        verify(!list.scrollTo({
            "key": 0,
            "align": "invalid"
        }))
        verify(!list.scrollTo(NaN))
        list.items = [{
            "key": 1,
            "kind": "a"
        }, {
            "key": 1,
            "kind": "b"
        }]
        verify(!list.scrollTo({
            "key": 1
        }))
        list.group = {
            "key": function() {
                throw new Error("failed")
            }
        }
        compare(list.rows.length, 0)
        verify(list.errorString.indexOf("failed") >= 0)
        list.group = null
        list.items = null
        compare(list.rows.length, 0)
        tryCompare(list, "count", 0)
    }

    function test_listPaginationGridAndEmpty() {
        const list = make(listComponent, {
            "items": Array.from({
                "length": 23
            }, function(_, index) {
                return {
                    "title": "Row " + index
                }
            })
        })
        compare(list.pageCount, 3)
        compare(list.pageItems.length, 10)
        verify(list.setPage(3))
        compare(list.pageItems.length, 3)
        const pager = findChild(list, "listPagination")
        verify(pager !== null)
        verify(pager.setPage(2))
        compare(list.currentPage, 2)
        verify(list.setPage(3))
        tryCompare(pager, "currentPage", 3)
        list.itemDelegate = countingRow
        tryVerify(function() {
            return findChild(list, "listyTestRow") !== null
        })
        const pagedRow = findChild(list, "listyTestRow")
        verify(pagedRow.itemData !== null)
        compare(pagedRow.itemKey, 20)
        verify(!list.setPage(0))
        verify(!list.setPage(NaN))
        list.items = list.items.slice(0, 2)
        compare(list.currentPage, 1)
        compare(list.pageItems.length, 2)
        list.grid = {
            "xs": 1,
            "sm": 2,
            "md": 3,
            "gutter": 8
        }
        list.width = 800
        tryCompare(list, "columns", 3)
        tryVerify(function() {
            return list.view && list.view.cellWidth !== undefined
        })
        clickSpy.target = list
        clickSpy.clear()
        mouseClick(list.view, 30, 30)
        compare(clickSpy.count, 1)
        compare(clickSpy.signalArguments[0][1], 0)
        list.width = 400
        tryCompare(list, "columns", 1)
        list.items = null
        compare(list.itemCount, 0)
        compare(list.pageItems.length, 0)
    }

    height: 700
    width: 1000
    visible: true
    when: windowShown
    name: "AntDesignCore"

    SignalSpy {
        id: clickSpy

        signalName: "itemClicked"
    }
    Component {
        id: flexComponent

        EFlex {
            gap: 10
            height: 80
            width: 400
            align: "start"

            EFlexItem {
                grow: 1
                basis: 100
                implicitHeight: 30
            }
            EFlexItem {
                grow: 3
                basis: 100
                implicitHeight: 40
            }
        }
    }
    Component {
        id: fixedFlexComponent

        EFlex {
            gap: 10
            width: 270
            height: 100
            align: "start"
            justify: "center"

            Rectangle {
                width: 80
                height: 20
                color: "red"
            }
            Rectangle {
                width: 80
                height: 40
                color: "blue"
            }
        }
    }
    Component {
        id: listyComponent

        EListy {
            width: 300
            height: 150
        }
    }
    Component {
        id: groupTitleComponent

        Item {
            property var groupKey: null
            property string groupTitle: ""

            implicitHeight: 32
            objectName: "testGroupTitle"
        }
    }
    Component {
        id: countingRow

        Item {
            property var itemKey: null
            property var itemData: null

            implicitHeight: 24
            objectName: "listyTestRow"

            Component.onCompleted: ++testCase.activeRows
            Component.onDestruction: --testCase.activeRows

            EText {
                anchors.fill: parent
                text: parent.itemData ? parent.itemData.label || parent.itemData.title || "" : ""
            }
        }
    }
    Component {
        id: listComponent

        EList {
            width: 360
            height: 260
            pagination: true
        }
    }
    Component {
        id: floatGroupComponent

        EFloatButtonGroup {
            x: 200
            y: 300
            trigger: "click"

            EFloatButton {
                iconSource: EIcons.CHECK
                objectName: "floatAction"
            }
            EFloatButton {
                iconSource: EIcons.BELL
            }
        }
    }
    Component {
        id: beamComponent

        EBorderBeam {
            radius: 12
            width: 200
            height: 100
            running: false
            color: "#1677ff"
        }
    }
    Component {
        id: appComponent

        EApp {
            width: 400
            height: 200
        }
    }
}

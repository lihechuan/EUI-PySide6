import EUI 1.0
import "../../source/qml/EUI/controls/data/private/TableOperations.js" as Operations
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function test_deepSnapshot() {
        const root = {value: 0}
        let current = root
        for (let index = 1; index < 2000; ++index) {
            current.next = {value: index}
            current = current.next
        }
        current.next = root
        const copy = Operations.clone(root)
        verify(copy !== root)
        current = copy
        for (let index = 0; index < 2000; ++index) {
            compare(current.value, index)
            current = current.next
        }
        verify(current === copy)
    }

    function test_largeInitialization() {
        const rows = []
        for (let index = 0; index < 100000; ++index)
            rows.push({name: "Row " + index, age: index})
        const table = createTemporaryObject(tableComponent, testCase)
        verify(table !== null)
        const started = Date.now()
        table.model = rows
        const elapsed = Date.now() - started
        console.log("table 100000 initialization ms", elapsed)
        verify(elapsed < 5000, "Large model assignment blocked for " + elapsed + " ms")
        compare(table.sourceRows.length, rows.length)
        verify(table.sourceRows[0] !== rows[0])
        rows[0].name = "Changed"
        compare(table.sourceRows[0].name, "Row 0")
        table.model = []
    }

    function test_snapshotPreservesGraph() {
        let reads = 0
        const shared = Object.freeze({value: "Original"})
        const date = new Date(2026, 9, 13)
        const callback = function() { return 1 }
        const row = {id: 1, left: shared, right: shared, date: date, callback: callback,
            missing: undefined, number: NaN}
        row.self = row
        Object.defineProperty(row, "__proto__", {value: shared, enumerable: true})
        Object.defineProperty(row, "hidden", {value: 1})
        Object.defineProperty(row, "derived", {enumerable: true, get: function() {
            ++reads
            return {value: "Derived"}
        }})
        Object.freeze(row)
        reads = 0
        const copy = Operations.clone([row, row, shared])
        verify(reads > 0)
        compare(copy[0].derived.value, "Derived")
        verify(copy[0] !== row)
        verify(copy[0] === copy[1])
        verify(copy[0].self === copy[0])
        verify(copy[0].left === copy[0].right)
        verify(copy[0].left === copy[2])
        verify(copy[2] !== shared)
        verify(copy[0].date instanceof Date)
        verify(copy[0].date !== date)
        compare(copy[0].date.getTime(), date.getTime())
        verify(copy[0].callback === callback)
        verify(Object.prototype.hasOwnProperty.call(copy[0], "missing"))
        verify(isNaN(copy[0].number))
        verify(!Object.prototype.hasOwnProperty.call(copy[0], "hidden"))
        verify(Object.getPrototypeOf(copy[0]) === Object.prototype)
        verify(copy[0].__proto__ === copy[2])
        copy[2].value = "Changed"
        compare(shared.value, "Original")
        compare(copy[0].left.value, "Changed")
    }

    width: 640
    height: 400
    visible: true
    when: windowShown
    name: "TableSnapshot"

    Component {
        id: tableComponent

        ETable {
            width: 640
            height: 360
            visible: false
            historyLimit: 0
            keepSource: false
            columns: [{prop: "name", label: "Name"}, {prop: "age", label: "Age"}]
        }
    }
}

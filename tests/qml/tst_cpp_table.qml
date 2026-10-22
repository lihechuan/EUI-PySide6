import EUI 1.0
import QtQuick 2.15
import QtTest 1.2

TestCase {
    id: testCase

    function test_cppSelectValues() {
        const types = exampleData.models.EChartsTypes
        const select = createTemporaryObject(selectComponent, testCase, {
            model: types, currentIndex: 0, textRole: "label"
        })
        verify(select !== null)
        tryCompare(select, "count", types.length)
        for (let index = 0; index < types.length; ++index) {
            select.currentIndex = index
            compare(select.currentIndex, index)
            compare(select.currentText, types[index].label)
        }
    }

    function test_cppRowsAndColumns() {
        const models = exampleData.models
        verify(EDataUtils.isArray(models.TableRows))
        verify(EDataUtils.isArray([]))
        verify(!EDataUtils.isArray(null))
        verify(!EDataUtils.isArray("row"))
        verify(!EDataUtils.isArray({length: 6}))
        verify(!EDataUtils.isArray(Object.create(Array.prototype)))
        const table = createTemporaryObject(tableComponent, testCase, {
            model: models.TableRows, columns: models.TableColumns
        })
        verify(table !== null)
        compare(table.rowCount, 6)
        compare(table.allColumns.length, 4)
        compare(table.allRows.length, 6)
        compare(table.displayRows.length, 6)
        compare(table.sourceRows.length, 6)
        compare(table.getRecordset().updateRecords.length, 0)
        verify(table.toggleRowExpansion(table.model[0], true))
        compare(table.expandRowKeys[0], table.model[0].name)
        verify(table.toggleRowExpansion({name: table.model[0].name}, false))
        compare(table.expandRowKeys.length, 0)
        verify(!table.toggleRowExpansion({}, true))
        verify(table.setCurrentRow(models.TableRows[0]))
        compare(table.currentRowIndex, 0)
        verify(table.selectRow(1))
        compare(table.currentRow.age, 31)
        verify(!table.selectRow(3))
        verify(table.sort("age", "descending"))
        compare(table.displayRows[0].row.age, 42)
        compare(table.displayRows[5].row.age, 22)
        verify(table.insert({name: "Inserted", age: 18}))
        compare(table.rowCount, 7)
        compare(table.getRecordset().insertRecords.length, 1)
        verify(table.undo())
        compare(table.rowCount, 6)
        compare(table.getRecordset().insertRecords.length, 0)
        verify(table.redo())
        compare(table.rowCount, 7)
        verify(table.revertData())
        compare(table.rowCount, 6)
        table.model = {length: 6}
        compare(table.rowCount, 0)
        compare(table.allRows.length, 0)
    }

    width: 640
    height: 480
    visible: true
    name: "CppTable"
    when: windowShown

    Component {
        id: selectComponent

        ESelect { width: 280 }
    }
    Component {
        id: tableComponent

        ETable {
            width: 620
            height: 320
            rowKey: "name"
            keepSource: true
        }
    }
}

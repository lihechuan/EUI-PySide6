import EUI 1.0
import QtQuick 2.15

ExampleCard {
    ExampleSection {
        componentName: "ETable"
        objectName: "advancedSectionEditing"

        ExampleCase {
            objectName: "advancedCaseEditing"
            title: ELocale.texts.TableEditingExample
            description: ELocale.texts.TableEditingDescription
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    id: editingExample

                    spacing: 12
                    width: parent.width

                    ETable {
                        id: editingTable

                        height: 450
                        rowKey: "id"
                        stripe: true
                        rowHeight: 56
                        editable: true
                        keepSource: true
                        pagination: true
                        showToolbar: true
                        borderMode: "full"
                        width: parent.width
                        columnDraggable: true
                        showColumnSettings: true
                        objectName: "advancedEditingTable"
                        layoutKey: "gallery-business-table"
                        editRules: ({name: [{required: true}], score: [{type: "number", min: 0, max: 100}]})
                        model: {
                            return (exampleData.models.TableAvatars || []).map(function(row, index) {
                                return {id: index + 1, avatar: row.avatar, name: row.name, department: index % 2 ? ELocale.texts.Design : ELocale.texts.DemoDevelopment,
                                    score: 60 + index % 41, joined: "2026-10-01", active: index % 3 !== 0}
                            })
                        }
                        columns: [{type: "selection", width: 48}, {prop: "id", label: ELocale.texts.RecordId, width: 100, sortable: true},
                            {prop: "avatar", label: ELocale.texts.Avatar, width: 76, cellDelegate: avatarCell},
                            {prop: "name", label: ELocale.texts.Name2, minWidth: 160, editable: true, sortable: true},
                            {prop: "department", label: ELocale.texts.TableDepartment, width: 150,
                                editRender: {type: "select", options: [{label: ELocale.texts.Design, value: ELocale.texts.Design}, {label: ELocale.texts.DemoDevelopment, value: ELocale.texts.DemoDevelopment}]}},
                            {prop: "score", label: ELocale.texts.TableScore, width: 100, sortable: true, editRender: {type: "number"}},
                            {prop: "joined", label: ELocale.texts.TableJoined, width: 150, editRender: {type: "date"}},
                            {prop: "active", label: ELocale.texts.TableActive, width: 90, cellDelegate: activeCell, editRender: {type: "checkbox"}}]
                    }
                    Row {
                        spacing: 8

                        EButton {
                            text: ELocale.texts.TableRevert

                            onClicked: editingTable.revertData()
                        }
                        EButton {
                            text: ELocale.texts.TableRowEdit

                            onClicked: {
                                editingTable.cancelEdit()
                                editingTable.editConfig = {mode: "row", trigger: "dblclick"}
                                if (editingTable.displayRows.length)
                                    editingTable.editCell(editingTable.displayRows[0].row, "name")
                            }
                        }
                    }
                    Component {
                        id: activeCell

                        Item {
                            property var row

                            ETag {
                                effect: "light"
                                size: EStyle.Small
                                anchors.centerIn: parent
                                styleType: row && row.active ? EStyle.Success : EStyle.Default
                                text: row && row.active ? ELocale.texts.TableEnabled : ELocale.texts.TableDisabled
                            }
                        }
                    }
                    Component {
                        id: avatarCell

                        Item {
                            property var row

                            EAvatar {
                                size: 40
                                shape: "square"
                                anchors.centerIn: parent
                                alt: row && row.name || ""
                                source: row && row.avatar || ""
                            }
                        }
                    }
                }
            `)

            Column {
                id: editingExample

                spacing: 12
                width: parent.width

                ETable {
                    id: editingTable

                    height: 450
                    rowKey: "id"
                    stripe: true
                    rowHeight: 56
                    editable: true
                    keepSource: true
                    pagination: true
                    showToolbar: true
                    borderMode: "full"
                    width: parent.width
                    columnDraggable: true
                    showColumnSettings: true
                    objectName: "advancedEditingTable"
                    layoutKey: "gallery-business-table"
                    editRules: ({name: [{required: true}], score: [{type: "number", min: 0, max: 100}]})
                    model: {
                        return (exampleData.models.TableAvatars || []).map(function(row, index) {
                            return {id: index + 1, avatar: row.avatar, name: row.name, department: index % 2 ? ELocale.texts.Design : ELocale.texts.DemoDevelopment,
                                score: 60 + index % 41, joined: "2026-10-01", active: index % 3 !== 0}
                        })
                    }
                    columns: [{type: "selection", width: 48}, {prop: "id", label: ELocale.texts.RecordId, width: 100, sortable: true},
                        {prop: "avatar", label: ELocale.texts.Avatar, width: 76, cellDelegate: avatarCell},
                        {prop: "name", label: ELocale.texts.Name2, minWidth: 160, editable: true, sortable: true},
                        {prop: "department", label: ELocale.texts.TableDepartment, width: 150,
                            editRender: {type: "select", options: [{label: ELocale.texts.Design, value: ELocale.texts.Design}, {label: ELocale.texts.DemoDevelopment, value: ELocale.texts.DemoDevelopment}]}},
                        {prop: "score", label: ELocale.texts.TableScore, width: 100, sortable: true, editRender: {type: "number"}},
                        {prop: "joined", label: ELocale.texts.TableJoined, width: 150, editRender: {type: "date"}},
                        {prop: "active", label: ELocale.texts.TableActive, width: 90, cellDelegate: activeCell, editRender: {type: "checkbox"}}]
                }
                Row {
                    spacing: 8

                    EButton {
                        text: ELocale.texts.TableRevert

                        onClicked: editingTable.revertData()
                    }
                    EButton {
                        text: ELocale.texts.TableRowEdit

                        onClicked: {
                            editingTable.cancelEdit()
                            editingTable.editConfig = {mode: "row", trigger: "dblclick"}
                            if (editingTable.displayRows.length)
                                editingTable.editCell(editingTable.displayRows[0].row, "name")
                        }
                    }
                }
                Component {
                    id: activeCell

                    Item {
                        property var row

                        ETag {
                            effect: "light"
                            size: EStyle.Small
                            anchors.centerIn: parent
                            styleType: row && row.active ? EStyle.Success : EStyle.Default
                            text: row && row.active ? ELocale.texts.TableEnabled : ELocale.texts.TableDisabled
                        }
                    }
                }
                Component {
                    id: avatarCell

                    Item {
                        property var row

                        EAvatar {
                            size: 40
                            shape: "square"
                            anchors.centerIn: parent
                            alt: row && row.name || ""
                            source: row && row.avatar || ""
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETable"
        objectName: "advancedSectionSpreadsheet"

        ExampleCase {
            objectName: "advancedCaseSpreadsheet"
            title: ELocale.texts.TableSpreadsheetExample
            description: ELocale.texts.TableSpreadsheetDescription
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    id: spreadsheetExample

                    spacing: 12
                    width: parent.width

                    ETable {
                        id: sheet

                        height: 330
                        rowKey: "id"
                        editable: true
                        keepSource: true
                        showToolbar: true
                        borderMode: "full"
                        width: parent.width
                        rangeSelection: true
                        keyboardNavigation: true
                        objectName: "advancedSpreadsheetTable"
                        editRules: ({name: [{required: true}], score: [{type: "number", min: 0, max: 100}]})
                        model: [{id: 1, name: "Alice", department: "Design", score: 80},
                            {id: 2, name: "Bob", department: "Development", score: 90},
                            {id: 3, name: "Carol", department: "Design", score: 70}]
                        columns: [{prop: "name", label: ELocale.texts.Name2, editable: true},
                            {prop: "department", label: ELocale.texts.TableDepartment, editable: true},
                            {prop: "score", label: ELocale.texts.TableScore, editRender: {type: "number"}}]

                        Component.onCompleted: selectCell(0, 0, false)
                    }
                    EButton {
                        text: ELocale.texts.TablePasteExample

                        onClicked: {
                            sheet.selectCell(0, 0, false)
                            sheet.pasteCellArea("Ada\\tDesign\\t95\\nBen\\tDevelopment\\t88")
                        }
                    }
                }
            `)

            Column {
                id: spreadsheetExample

                spacing: 12
                width: parent.width

                ETable {
                    id: sheet

                    height: 330
                    rowKey: "id"
                    editable: true
                    keepSource: true
                    showToolbar: true
                    borderMode: "full"
                    width: parent.width
                    rangeSelection: true
                    keyboardNavigation: true
                    objectName: "advancedSpreadsheetTable"
                    editRules: ({name: [{required: true}], score: [{type: "number", min: 0, max: 100}]})
                    model: [{id: 1, name: "Alice", department: "Design", score: 80},
                        {id: 2, name: "Bob", department: "Development", score: 90},
                        {id: 3, name: "Carol", department: "Design", score: 70}]
                    columns: [{prop: "name", label: ELocale.texts.Name2, editable: true},
                        {prop: "department", label: ELocale.texts.TableDepartment, editable: true},
                        {prop: "score", label: ELocale.texts.TableScore, editRender: {type: "number"}}]

                    Component.onCompleted: selectCell(0, 0, false)
                }
                EButton {
                    text: ELocale.texts.TablePasteExample

                    onClicked: {
                        sheet.selectCell(0, 0, false)
                        sheet.pasteCellArea("Ada\tDesign\t95\nBen\tDevelopment\t88")
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETable"
        objectName: "advancedSectionGrouping"

        ExampleCase {
            objectName: "advancedCaseGrouping"
            title: ELocale.texts.TableGroupingExample
            description: ELocale.texts.TableGroupingDescription
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    id: groupingExample

                    readonly property var records: [{department: "Design", name: "Alice", score: 80},
                        {department: "Development", name: "Bob", score: 90}, {department: "Design", name: "Carol", score: 70}]

                    spacing: 12
                    width: parent.width

                    ETable {
                        id: grouped

                        height: 380
                        multiSort: true
                        showFooter: true
                        width: parent.width
                        groupFields: ["department"]
                        model: groupingExample.records
                        objectName: "advancedGroupingTable"
                        mergeFooterCells: [{row: 0, col: 0, rowspan: 1, colspan: 2}, {row: 1, col: 0, rowspan: 1, colspan: 2}]
                        footerMethod: function(context) {
                            return [[ELocale.texts.Total, aggregate("score", "sum", context.data)],
                                [ELocale.texts.TableAverage, aggregate("score", "avg", context.data)]].map(function(row) { return [row[0], "", row[1]] })
                        }
                        columns: [{prop: "department", label: ELocale.texts.TableDepartment, sortable: true},
                            {prop: "name", label: ELocale.texts.Name2, sortable: true},
                            {prop: "score", label: ELocale.texts.TableScore, sortable: true, aggregate: "sum"}]

                        Component.onCompleted: setSorts([{prop: "department", order: "ascending"}, {prop: "score", order: "descending"}])
                    }
                    EText {
                        text: ELocale.texts.TablePivot
                    }
                    ETable {
                        height: 180
                        width: parent.width
                        objectName: "advancedPivotTable"
                        model: grouped.pivot("department", "name", "score", "sum").rows
                        columns: grouped.pivot("department", "name", "score", "sum").columns
                    }
                    EChart {
                        type: 1
                        height: 220
                        width: parent.width
                        model: groupingExample.records.map(function(row) { return {label: row.name, value: row.score} })
                    }
                }
            `)

            Column {
                id: groupingExample

                readonly property var records: [{department: "Design", name: "Alice", score: 80},
                    {department: "Development", name: "Bob", score: 90}, {department: "Design", name: "Carol", score: 70}]

                spacing: 12
                width: parent.width

                ETable {
                    id: grouped

                    height: 380
                    multiSort: true
                    showFooter: true
                    width: parent.width
                    groupFields: ["department"]
                    model: groupingExample.records
                    objectName: "advancedGroupingTable"
                    mergeFooterCells: [{row: 0, col: 0, rowspan: 1, colspan: 2}, {row: 1, col: 0, rowspan: 1, colspan: 2}]
                    footerMethod: function(context) {
                        return [[ELocale.texts.Total, aggregate("score", "sum", context.data)],
                            [ELocale.texts.TableAverage, aggregate("score", "avg", context.data)]].map(function(row) { return [row[0], "", row[1]] })
                    }
                    columns: [{prop: "department", label: ELocale.texts.TableDepartment, sortable: true},
                        {prop: "name", label: ELocale.texts.Name2, sortable: true},
                        {prop: "score", label: ELocale.texts.TableScore, sortable: true, aggregate: "sum"}]

                    Component.onCompleted: setSorts([{prop: "department", order: "ascending"}, {prop: "score", order: "descending"}])
                }
                EText {
                    text: ELocale.texts.TablePivot
                }
                ETable {
                    height: 180
                    width: parent.width
                    objectName: "advancedPivotTable"
                    model: grouped.pivot("department", "name", "score", "sum").rows
                    columns: grouped.pivot("department", "name", "score", "sum").columns
                }
                EChart {
                    type: 1
                    height: 220
                    width: parent.width
                    model: groupingExample.records.map(function(row) { return {label: row.name, value: row.score} })
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETable"
        objectName: "advancedSectionVirtual"

        ExampleCase {
            objectName: "advancedCaseVirtual"
            title: ELocale.texts.TableVirtualExample
            description: ELocale.texts.TableVirtualDescription
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    id: virtualExample

                    function createRows() {
                        const rows = []
                        for (let index = 0; index < 10000; ++index)
                            rows.push({id: index + 1, name: "Record " + (index + 1), score: index % 101})
                        return rows
                    }

                    function createColumns() {
                        const columns = [{prop: "id", label: ELocale.texts.RecordId, fixed: "left", width: 90}]
                        for (let index = 0; index < 80; ++index)
                            columns.push({prop: "score", columnKey: "score-" + index, label: "C" + (index + 1), width: 110})
                        columns.push({prop: "name", label: ELocale.texts.Name2, fixed: "right", width: 150})
                        return columns
                    }

                    width: parent.width

                    ETable {
                        fit: false
                        height: 320
                        rowKey: "id"
                        width: parent.width
                        virtualColumns: true
                        model: virtualExample.createRows()
                        objectName: "advancedVirtualTable"
                        columns: virtualExample.createColumns()
                    }
                }
            `)

            Column {
                id: virtualExample

                function createRows() {
                    const rows = []
                    for (let index = 0; index < 10000; ++index)
                        rows.push({id: index + 1, name: "Record " + (index + 1), score: index % 101})
                    return rows
                }

                function createColumns() {
                    const columns = [{prop: "id", label: ELocale.texts.RecordId, fixed: "left", width: 90}]
                    for (let index = 0; index < 80; ++index)
                        columns.push({prop: "score", columnKey: "score-" + index, label: "C" + (index + 1), width: 110})
                    columns.push({prop: "name", label: ELocale.texts.Name2, fixed: "right", width: 150})
                    return columns
                }

                width: parent.width

                ETable {
                    fit: false
                    height: 320
                    rowKey: "id"
                    width: parent.width
                    virtualColumns: true
                    model: virtualExample.createRows()
                    objectName: "advancedVirtualTable"
                    columns: virtualExample.createColumns()
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETable"
        objectName: "advancedSectionDrag"

        ExampleCase {
            objectName: "advancedCaseDrag"
            title: ELocale.texts.TableDragExample
            description: ELocale.texts.TableDragDescription
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: parent.width

                    ETable {
                        height: 300
                        rowKey: "id"
                        showToolbar: true
                        rowDraggable: true
                        width: parent.width
                        columnDraggable: true
                        showColumnSettings: true
                        highlightHoverColumn: true
                        highlightCurrentColumn: true
                        layoutKey: "gallery-drag-table"
                        objectName: "advancedDragTable"
                        model: [{id: 1, name: "Alice", department: "Design"}, {id: 2, name: "Bob", department: "Development"},
                            {id: 3, name: "Carol", department: "Design"}, {id: 4, name: "Dora", department: "Development"}]
                        columns: [{type: "radio", label: ELocale.texts.TableRadio, width: 60},
                            {prop: "id", label: ELocale.texts.RecordId, width: 90},
                            {prop: "name", label: ELocale.texts.Name2},
                            {prop: "department", label: ELocale.texts.TableDepartment}]
                    }
                }
            `)

            Column {
                width: parent.width

                ETable {
                    height: 300
                    rowKey: "id"
                    showToolbar: true
                    rowDraggable: true
                    width: parent.width
                    columnDraggable: true
                    showColumnSettings: true
                    highlightHoverColumn: true
                    highlightCurrentColumn: true
                    layoutKey: "gallery-drag-table"
                    objectName: "advancedDragTable"
                    model: [{id: 1, name: "Alice", department: "Design"}, {id: 2, name: "Bob", department: "Development"},
                        {id: 3, name: "Carol", department: "Design"}, {id: 4, name: "Dora", department: "Development"}]
                    columns: [{type: "radio", label: ELocale.texts.TableRadio, width: 60},
                        {prop: "id", label: ELocale.texts.RecordId, width: 90},
                        {prop: "name", label: ELocale.texts.Name2},
                        {prop: "department", label: ELocale.texts.TableDepartment}]
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETable"
        objectName: "advancedSectionProxy"

        ExampleCase {
            objectName: "advancedCaseProxy"
            title: ELocale.texts.TableProxyExample
            description: ELocale.texts.TableProxyDescription
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    id: proxyExample

                    function query(context) {
                        return new Promise(function(resolve, reject) {
                            Qt.callLater(function() {
                                if (context.form.fail) {
                                    reject(new Error(ELocale.texts.TableDemoFailure))
                                    return
                                }
                                const records = (exampleData.models.TableAvatars || []).filter(function(row) {
                                    return !context.form.name || row.name.toLowerCase().indexOf(context.form.name.toLowerCase()) >= 0
                                })
                                const start = (context.page - 1) * context.pageSize
                                resolve({rows: records.slice(start, start + context.pageSize), total: records.length})
                            })
                        })
                    }

                    spacing: 12
                    width: parent.width

                    Row {
                        spacing: 8

                        EInput {
                            id: queryInput

                            width: 200
                            placeholderText: ELocale.texts.Name2
                        }
                        EButton {
                            text: ELocale.texts.TableQuery

                            onClicked: {
                                remoteTable.queryForm = {name: queryInput.text}
                                remoteTable.commitProxy("reload")
                            }
                        }
                        EButton {
                            text: ELocale.texts.TableDemoError

                            onClicked: {
                                remoteTable.queryForm = {fail: true}
                                remoteTable.commitProxy("query")
                            }
                        }
                    }
                    ETable {
                        id: remoteTable

                        height: 350
                        rowKey: "id"
                        pagination: true
                        showToolbar: true
                        width: parent.width
                        objectName: "advancedProxyTable"
                        proxyConfig: ({query: proxyExample.query})
                        columns: [{prop: "id", label: ELocale.texts.RecordId, width: 90},
                            {prop: "name", label: ELocale.texts.Name2}, {prop: "category", label: ELocale.texts.AvatarCategory}]

                        Component.onCompleted: commitProxy("query")
                    }
                }
            `)

            Column {
                id: proxyExample

                function query(context) {
                    return new Promise(function(resolve, reject) {
                        Qt.callLater(function() {
                            if (context.form.fail) {
                                reject(new Error(ELocale.texts.TableDemoFailure))
                                return
                            }
                            const records = (exampleData.models.TableAvatars || []).filter(function(row) {
                                return !context.form.name || row.name.toLowerCase().indexOf(context.form.name.toLowerCase()) >= 0
                            })
                            const start = (context.page - 1) * context.pageSize
                            resolve({rows: records.slice(start, start + context.pageSize), total: records.length})
                        })
                    })
                }

                spacing: 12
                width: parent.width

                Row {
                    spacing: 8

                    EInput {
                        id: queryInput

                        width: 200
                        placeholderText: ELocale.texts.Name2
                    }
                    EButton {
                        text: ELocale.texts.TableQuery

                        onClicked: {
                            remoteTable.queryForm = {name: queryInput.text}
                            remoteTable.commitProxy("reload")
                        }
                    }
                    EButton {
                        text: ELocale.texts.TableDemoError

                        onClicked: {
                            remoteTable.queryForm = {fail: true}
                            remoteTable.commitProxy("query")
                        }
                    }
                }
                ETable {
                    id: remoteTable

                    height: 350
                    rowKey: "id"
                    pagination: true
                    showToolbar: true
                    width: parent.width
                    objectName: "advancedProxyTable"
                    proxyConfig: ({query: proxyExample.query})
                    columns: [{prop: "id", label: ELocale.texts.RecordId, width: 90},
                        {prop: "name", label: ELocale.texts.Name2}, {prop: "category", label: ELocale.texts.AvatarCategory}]

                    Component.onCompleted: commitProxy("query")
                }
            }
        }
    }
}

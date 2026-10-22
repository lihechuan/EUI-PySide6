import EUI 1.0
import QtQuick 2.15

ExamplePage {
    ExampleSection {
        componentName: "ETable"

        ExampleCard {
            ExampleCase {
                title: ELocale.texts.ColumnsSelectionFiltersAndFixedColumns
                description: ELocale.texts.ChooseVisibleColumnsFilterFromTheHeaderSelect
                code: GalleryStyle.sourceCode(`
                    import EUI 1.0
                    import QtQuick 2.15

                    Column {
                        spacing: 12
                        width: parent.width

                        ETable {
                            id: webTableSelection

                            height: 320
                            border: true
                            rowKey: "id"
                            stripe: true
                            showSummary: true
                            width: parent.width
                            showColumnSettings: true
                            summaryMethod: function(context) {
                                return context.columns.map(function(column) {
                                    if (column.prop === "name")
                                        return webTableSelection.sumText
                                    if (column.prop === "score")
                                        return context.data.reduce(function(total, row) { return total + row.score }, 0)
                                    return ""
                                })
                            }
                            model: [{id: 1, name: "Aurora", department: "Design", status: "Active", score: 94},
                                {id: 2, name: "Atlas", department: "Engineering", status: "Review", score: 87},
                                {id: 3, name: "Cedar", department: "Engineering", status: "Active", score: 96},
                                {id: 4, name: "Nova", department: "Operations", status: "Paused", score: 72, disabled: true}]
                            columns: [{type: "selection", width: 52, fixed: "left", reserveSelection: true, label: ELocale.texts.Selection},
                                {type: "index", label: "#", width: 56},
                                {prop: "name", label: ELocale.texts.Name2, width: 150, sortable: true, fixed: "left"},
                                {prop: "department", label: ELocale.texts.Department, minWidth: 160},
                                {prop: "status", label: ELocale.texts.Status, width: 140,
                                    filters: [{text: "Active", value: "Active"}, {text: "Review", value: "Review"}, {text: "Paused", value: "Paused"}], cellDelegate: webTableStatus},
                                {prop: "score", label: ELocale.texts.Score, width: 110, align: "right", sortable: true},
                                {prop: "action", label: ELocale.texts.Action, width: 100, fixed: "right", cellDelegate: webTableAction}]
                        }
                        Flow {
                            spacing: 12
                            width: parent.width

                            ETag {
                                effect: "plain"
                                text: ELocale.texts.Selected + webTableSelection.selectedRows.length
                            }
                            EButton {
                                text: ELocale.texts.ClearSelection

                                onClicked: webTableSelection.clearSelection()
                            }
                            EButton {
                                text: ELocale.texts.ResetFilters

                                onClicked: webTableSelection.clearFilter()
                            }
                            EButton {
                                text: ELocale.texts.ResetSort

                                onClicked: webTableSelection.clearSort()
                            }
                        }
                        Component {
                            id: webTableStatus

                            Item {
                                property var row

                                ETag {
                                    size: EStyle.Small
                                    anchors.leftMargin: 16
                                    anchors.left: parent.left
                                    text: row ? row.status : ""
                                    anchors.verticalCenter: parent.verticalCenter
                                    styleType: row && row.status === "Active" ? EStyle.Success : row && row.status === "Review" ? EStyle.Warning : EStyle.Info
                                }
                            }
                        }
                        Component {
                            id: webTableAction

                            ETextButton {
                                property var row

                                styleType: EStyle.Primary
                                enabled: row && !row.disabled
                                text: ELocale.texts.View

                                onClicked: webTableMessage.open({message: row ? row.name : "", duration: 2000})
                            }
                        }
                        EMessage {
                            id: webTableMessage
                        }
                    }
                `)

                Column {
                    spacing: 12
                    width: parent.width

                    ETable {
                        id: webTableSelection

                        height: 320
                        border: true
                        rowKey: "id"
                        stripe: true
                        showSummary: true
                        width: parent.width
                        showColumnSettings: true
                        summaryMethod: function(context) {
                            return context.columns.map(function(column) {
                                if (column.prop === "name")
                                    return webTableSelection.sumText
                                if (column.prop === "score")
                                    return context.data.reduce(function(total, row) {
                                        return total + row.score
                                    }, 0)
                                return ""
                            })
                        }
                        model: [{id: 1, name: "Aurora", department: "Design", status: "Active", score: 94},
                            {id: 2, name: "Atlas", department: "Engineering", status: "Review", score: 87},
                            {id: 3, name: "Cedar", department: "Engineering", status: "Active", score: 96},
                            {id: 4, name: "Nova", department: "Operations", status: "Paused", score: 72, disabled: true}]
                        columns: [{type: "selection", width: 52, fixed: "left", reserveSelection: true, label: ELocale.texts.Selection},
                            {type: "index", label: "#", width: 56},
                            {prop: "name", label: ELocale.texts.Name2, width
                                : 150, sortable
                                : true, fixed
                                : "left"},
                            {prop: "department", label: ELocale.texts.Department, minWidth
                                : 160},
                            {prop: "status", label: ELocale.texts.Status, width: 140,
                                filters: [{text: "Active", value: "Active"}, {text: "Review", value: "Review"}, {text: "Paused", value: "Paused"}], cellDelegate: webTableStatus},
                            {prop: "score", label: ELocale.texts.Score, width
                                : 110, align
                                : "right", sortable
                                : true},
                            {prop: "action", label: ELocale.texts.Action, width
                                : 100, fixed
                                : "right", cellDelegate
                                : webTableAction}]
                    }
                    Flow {
                        spacing: 12
                        width: parent.width

                        ETag {
                            effect: "plain"
                            text: ELocale.texts.Selected
                                + webTableSelection.selectedRows.length
                        }
                        EButton {
                            text: ELocale.texts.ClearSelection

                            onClicked: webTableSelection.clearSelection()
                        }
                        EButton {
                            text: ELocale.texts.ResetFilters

                            onClicked: webTableSelection.clearFilter()
                        }
                        EButton {
                            text: ELocale.texts.ResetSort

                            onClicked: webTableSelection.clearSort()
                        }
                    }
                    Component {
                        id: webTableStatus

                        Item {
                            property var row

                            ETag {
                                size: EStyle.Small
                                anchors.leftMargin: 16
                                anchors.left: parent.left
                                text: row ? row.status : ""
                                anchors.verticalCenter: parent.verticalCenter
                                styleType: row && row.status === "Active" ? EStyle.Success
                                    : row && row.status === "Review" ? EStyle.Warning
                                    : EStyle.Info
                            }
                        }
                    }
                    Component {
                        id: webTableAction

                        ETextButton {
                            property var row

                            text: ELocale.texts.View
                            styleType: EStyle.Primary
                            enabled: row && !row.disabled

                            onClicked: webTableMessage.open({message: row ? row.name : "", duration: 2000})
                        }
                    }
                    EMessage {
                        id: webTableMessage
                    }
                }
            }
            ExampleCase {
                title: ELocale.texts.GroupedHeadersTreeRowsAndLazyLoading
                code: GalleryStyle.sourceCode(`
                    import EUI 1.0
                    import QtQuick 2.15

                    ETable {
                        id: webTableTree

                        lazy: true
                        height: 280
                        rowKey: "id"
                        width: parent.width
                        showColumnSettings: true
                        expandRowKeys: ["workspace"]
                        load: function(row, node, resolve) {
                            resolve([{id: row.id + "-a", name: "Loaded task A", owner: "Operations", progress: 68},
                                {id: row.id + "-b", name: "Loaded task B", owner: "Support", progress: 54}])
                        }
                        model: [{id: "workspace", name: "Workspace", owner: "EUI", progress: 80, children: [
                            {id: "gallery", name: "Gallery", owner: "Design", progress: 95},
                            {id: "controls", name: "Controls", owner: "Engineering", progress: 75}]},
                            {id: "remote", name: "Remote workspace", owner: "Operations", progress: 60, hasChildren: true}]
                        columns: [{label: ELocale.texts.Project, children: [
                            {prop: "name", label: ELocale.texts.Name2, minWidth: 220},
                            {prop: "owner", label: ELocale.texts.Owner, minWidth: 130}]},
                            {prop: "progress", label: ELocale.texts.Progress, minWidth: 140,
                                sortable: true, formatter: function(row, value) { return value + "%" }}]
                    }
                `)

                ETable {
                    id: webTableTree

                    lazy: true
                    height: 280
                    rowKey: "id"
                    width: parent.width
                    showColumnSettings: true
                    expandRowKeys: ["workspace"]
                    load: function(row, node, resolve) {
                        resolve([{id: row.id
                            + "-a", name: "Loaded task A", owner: "Operations", progress: 68},
                            {id: row.id + "-b", name: "Loaded task B", owner: "Support", progress: 54}])
                    }
                    columns: [{label: ELocale.texts.Project, children: [
                        {prop: "name", label: ELocale.texts.Name2, minWidth: 220},
                        {prop: "owner", label: ELocale.texts.Owner, minWidth: 130}]},
                        {prop: "progress", label: ELocale.texts.Progress, minWidth
                            : 140,
                            sortable: true, formatter: function(row, value) {
                                return value + "%"
                            }}]
                    model: [{id: "workspace", name: "Workspace", owner: "EUI", progress: 80, children: [
                        {id: "gallery", name: "Gallery", owner: "Design", progress: 95},
                        {id: "controls", name: "Controls", owner: "Engineering", progress: 75}]},
                        {id: "remote", name: "Remote workspace", owner: "Operations", progress: 60, hasChildren: true}]
                }
            }
            ExampleCase {
                title: ELocale.texts.ExpandedDetailsAndMergedCells
                code: GalleryStyle.sourceCode(`
                    import EUI 1.0
                    import QtQuick 2.15

                    Column {
                        spacing: 16
                        width: parent.width

                        ETable {
                            width: parent.width
                            expandDelegate: webTableDetails
                            columns: [{type: "expand", width: 52}, {prop: "name", label: "Project"}, {prop: "owner", label: "Owner"}]
                            model: [{name: "Design system", owner: "Aurora", detail: "Tokens, components and accessible interaction."},
                                {name: "Desktop gallery", owner: "Atlas", detail: "Qt Quick controls with light and dark themes."}]
                        }
                        ETable {
                            border: true
                            width: parent.width
                            columns: [{prop: "team", label: "Team"}, {prop: "name", label: "Member"}]
                            model: [{team: "Design", name: "Aurora"}, {team: "Design", name: "Nova"}, {team: "Engineering", name: "Atlas"}]
                            spanMethod: function(context) {
                                if (context.columnIndex !== 0)
                                    return [1, 1]
                                return context.rowIndex === 0 ? [2, 1] : context.rowIndex === 1 ? [0, 0] : [1, 1]
                            }
                        }

                        Component {
                            id: webTableDetails

                            EText {
                                property var row

                                height: 70
                                leftPadding: 24
                                rightPadding: 24
                                wrapMode: Text.WordWrap
                                text: row ? row.detail : ""
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                `)

                Column {
                    spacing: 16
                    width: parent.width

                    ETable {
                        width: parent.width
                        expandDelegate: webTableDetails
                        columns: [{type: "expand", width: 52}, {prop: "name", label: "Project"}, {prop: "owner", label: "Owner"}]
                        model: [{name: "Design system", owner: "Aurora", detail: "Tokens, components and accessible interaction."},
                            {name: "Desktop gallery", owner: "Atlas", detail: "Qt Quick controls with light and dark themes."}]
                    }
                    ETable {
                        border: true
                        width: parent.width
                        columns: [{prop: "team", label: "Team"}, {prop: "name", label: "Member"}]
                        model: [{team: "Design", name: "Aurora"}, {team: "Design", name: "Nova"}, {team: "Engineering", name: "Atlas"}]
                        spanMethod: function(context) {
                            if (context.columnIndex !== 0)
                                return [1, 1]
                            return context.rowIndex === 0 ? [2, 1] : context.rowIndex === 1 ? [0, 0] : [1, 1]
                        }
                    }
                    Component {
                        id: webTableDetails

                        EText {
                            property var row

                            height: 70
                            leftPadding: 24
                            rightPadding: 24
                            wrapMode: Text.WordWrap
                            text: row ? row.detail : ""
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }
        }
    }
}

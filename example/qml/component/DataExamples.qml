import EUI 1.0
import QtQuick 2.15

ExamplePage {
    id: page

    property string lastSelection: ELocale.texts.NoSelection

    title: ELocale.texts.DataDisplay
    description: ELocale.texts.DisplayBusinessInformationStatusAndStructuredData

    ExampleSection {
        exampleCount: 6
        componentName: "ETable"

        TableAdvancedExamples { }
    }
    ExampleSection {
        componentName: "ETable"

        TableAvatarExample { }
    }
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
    ExampleSection {
        componentName: "ESkeletonItem"

        ExampleCard {
            title: ELocale.texts.CustomSkeletonVariants
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Row {
                    spacing: 16

                    ESkeletonItem {
                        variant: "circle"
                        animated: true
                    }
                    ESkeletonItem {
                        variant: "image"
                        animated: true
                    }
                    ESkeletonItem {
                        variant: "button"
                        animated: true
                    }
                }`)

            Row {
                spacing: 16

                ESkeletonItem {
                    animated: true
                    variant: "circle"
                }
                ESkeletonItem {
                    animated: true
                    variant: "image"
                }
                ESkeletonItem {
                    animated: true
                    variant: "button"
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAvatarGroup"

        ExampleCard {
            title: ELocale.texts.AvatarGroupsCollapseAndHoverPreviews
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EAvatarGroup {
                    size: 44
                    overlap: 10
                    collapseAvatars: true
                    maxCollapseAvatars: 3
                    collapseAvatarsTooltip: true

                    EAvatar {
                        text: "A"
                        source: "qrc:/example/images/gallery/avatar-01.jpg"
                    }
                    EAvatar {
                        text: "B"
                        source: "qrc:/example/images/gallery/avatar-02.jpg"
                    }
                    EAvatar {
                        text: "C"
                        source: "qrc:/example/images/gallery/avatar-03.jpg"
                    }
                    EAvatar {
                        text: "D"
                        source: "qrc:/example/images/gallery/avatar-04.jpg"
                    }
                    EAvatar {
                        text: "E"
                        source: "qrc:/example/images/gallery/avatar-05.jpg"
                    }
                    EAvatar {
                        text: "F"
                        source: "qrc:/example/images/gallery/avatar-06.jpg"
                    }
                }`)

            EAvatarGroup {
                size: 44
                overlap: 10
                collapseAvatars: true
                maxCollapseAvatars: 3
                collapseAvatarsTooltip: true

                EAvatar {
                    text: "A"
                    source: "qrc:/example/images/gallery/avatar-01.jpg"
                }
                EAvatar {
                    text: "B"
                    source: "qrc:/example/images/gallery/avatar-02.jpg"
                }
                EAvatar {
                    text: "C"
                    source: "qrc:/example/images/gallery/avatar-03.jpg"
                }
                EAvatar {
                    text: "D"
                    source: "qrc:/example/images/gallery/avatar-04.jpg"
                }
                EAvatar {
                    text: "E"
                    source: "qrc:/example/images/gallery/avatar-05.jpg"
                }
                EAvatar {
                    text: "F"
                    source: "qrc:/example/images/gallery/avatar-06.jpg"
                }
            }
        }
    }
    ExampleSection {
        componentName: "EEmpty"

        ExampleCard {
            title: ELocale.texts.CustomEmptyStateContent
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EEmpty {
                    width: parent.width
                    description: ELocale.texts.NoProjectsYet
                    imageDelegate: Component {
                        EIcon {
                            iconSize: 64
                            iconSource: EIcons.FOLDER_OPEN
                            color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                        }
                    }

                    EButton {
                        styleType: EStyle.Primary
                        text: ELocale.texts.CreateProject
                    }
                }
`)

            EEmpty {
                width: parent.width
                description: ELocale.texts.NoProjectsYet
                imageDelegate: Component {
                    EIcon {
                        iconSize: 64
                        iconSource: EIcons.FOLDER_OPEN
                        color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                    }
                }

                EButton {
                    styleType: EStyle.Primary
                    text: ELocale.texts.CreateProject
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECard"

        ExampleCard {
            title: ELocale.texts.HoverShadowsHeaderAndFooterDelegates
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ECard {
                    shadow: "hover"
                    width: Math.min(480, parent.width)
                    footer: ELocale.texts.Updated20261010
                    headerDelegate: Component {
                        Row {
                            spacing: 12

                            EText {
                                font.bold: true
                                text: ELocale.texts.ProjectActivity
                            }
                            ETag {
                                styleType: EStyle.Success
                                text: ELocale.texts.InProgress
                            }
                        }
                    }

                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.CardsPreserveTheBodyContentAPIAndSupport
                    }
                }
`)

            ECard {
                shadow: "hover"
                width: Math.min(480, parent.width)
                footer: ELocale.texts.Updated20261010
                headerDelegate: Component {
                    Row {
                        spacing: 12

                        EText {
                            font.bold: true
                            text: ELocale.texts.ProjectActivity
                        }
                        ETag {
                            styleType: EStyle.Success
                            text: ELocale.texts.InProgress
                        }
                    }
                }

                EText {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: ELocale.texts.CardsPreserveTheBodyContentAPIAndSupport
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAvatar"

        ExampleCard {
            title: ELocale.texts.IconAvatarsCustomFallbackAndFitting
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Row {
                    spacing: 16

                    EAvatar {
                        size: 56
                        iconSource: EIcons.PERSON
                    }
                    EAvatar {
                        size: 56
                        shape: "square"
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/example/images/gallery/avatar-01.jpg"
                    }
                    EAvatar {
                        size: 56

                        EText {
                            color: "white"
                            anchors.centerIn: parent
                            text: ELocale.texts.Design
                        }
                    }
                }
`)

            Row {
                spacing: 16

                EAvatar {
                    size: 56
                    iconSource: EIcons.PERSON
                }
                EAvatar {
                    size: 56
                    shape: "square"
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/example/images/gallery/avatar-01.jpg"
                }
                EAvatar {
                    size: 56

                    EText {
                        color: "white"
                        anchors.centerIn: parent
                        text: ELocale.texts.Design
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EBadge"

        ExampleCard {
            title: ELocale.texts.CustomColorsAndOffsets
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Row {
                    spacing: 36

                    EBadge {
                        value: 12
                        color: "#409eff"
                        offset: Qt.point(4, 2)

                        EButton { text: ELocale.texts.Messages }
                    }
                    EBadge {
                        isDot: true
                        offset: Qt.point(-4, 4)

                        EButton { text: ELocale.texts.Notifications }
                    }
                }
`)

            Row {
                spacing: 36

                EBadge {
                    value: 12
                    color: "#409eff"
                    offset: Qt.point(4, 2)

                    EButton { text: ELocale.texts.Messages }
                }
                EBadge {
                    isDot: true
                    offset: Qt.point(-4, 4)

                    EButton { text: ELocale.texts.Notifications }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETag"

        ExampleCard {
            title: ELocale.texts.CheckableTagsCustomColorsAndClosing
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Row {
                    spacing: 12

                    ETag {
                        checkable: true
                        text: ELocale.texts.Toggle
                    }
                    ETag {
                        hit: true
                        color: "#FFF0DE"
                        styleType: EStyle.Warning
                        text: ELocale.texts.Important
                    }
                    ETag {
                        closable: true
                        text: ELocale.texts.Closable

                        onClosed: visible = false
                    }
                }
`)

            Row {
                spacing: 12

                ETag {
                    checkable: true
                    text: ELocale.texts.Toggle
                }
                ETag {
                    hit: true
                    color: "#FFF0DE"
                    styleType: EStyle.Warning
                    text: ELocale.texts.Important
                }
                ETag {
                    closable: true
                    text: ELocale.texts.Closeable

                    onClosed: visible = false
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESkeleton"

        ExampleCard {
            title: ELocale.texts.MultipleSkeletonsThrottledVisibilityAndLoadedContent
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ESwitch {
                        checked: true
                        text: ELocale.texts.Loading

                        onToggled: skeleton.loading = checked
                    }
                    ESkeleton {
                        id: skeleton

                        rows: 2
                        count: 2
                        animated: true
                        width: Math.min(480, parent.width)
                        throttle: ({ leading: 250, trailing: 150 })

                        EText {
                            height: 80
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.LoadedContentHeightFollowsTheActualContentWhen
                        }
                    }
                }
`)

            Column {
                spacing: 16
                width: parent.width

                ESwitch {
                    checked: true
                    text: ELocale.texts.Loading

                    onToggled: webDataSkeleton.loading = checked
                }
                ESkeleton {
                    id: webDataSkeleton

                    rows: 2
                    count: 2
                    animated: true
                    width: Math.min(480, parent.width)
                    throttle: ({ leading: 250, trailing: 150 })

                    EText {
                        height: 80
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.LoadedContentHeightFollowsTheActualContentWhen
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EPagination"

        ExampleCard {
            title: ELocale.texts.PageSizeAndPageJump
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 12
                    width: parent.width

                    EPagination {
                        id: pagination

                        total: 258
                        width: parent.width
                        pageSizes: [10, 20, 50, 100]
                        layout: width < 760 ? "total, sizes, ->, jumper" : "total, sizes, prev, pager, next, jumper"

                        onPageSizeChanged: {
                            if (pager)
                                pager.pageSize = pageSize
                        }
                        onCurrentPageChanged: {
                            if (pager)
                                pager.currentPage = currentPage
                        }
                    }
                    EPagination {
                        id: pager

                        width: parent.width
                        visible: width < 760
                        total: pagination.total
                        layout: "prev, pager, next"
                        pageSize: pagination.pageSize
                        currentPage: pagination.currentPage

                        onCurrentChange: function(number) { pagination.setPage(number) }
                    }
                    EText {
                        text: ELocale.texts.PageSizeStatus.arg(pagination.currentPage).arg(pagination.pageSize)
                    }
                }
            `)

            Column {
                spacing: 12
                width: parent.width

                EPagination {
                    id: webDataPagination

                    total: 258
                    width: parent.width
                    pageSizes: [10, 20, 50, 100]
                    objectName: "galleryPaginationControls"
                    layout: width < 760 ? "total, sizes, ->, jumper"
                        : "total, sizes, prev, pager, next, jumper"

                    onPageSizeChanged: {
                        if (webDataPager)
                            webDataPager.pageSize = pageSize
                    }
                    onCurrentPageChanged: {
                        if (webDataPager)
                            webDataPager.currentPage = currentPage
                    }
                }
                EPagination {
                    id: webDataPager

                    width: parent.width
                    visible: width < 760
                    layout: "prev, pager, next"
                    total: webDataPagination.total
                    objectName: "galleryPaginationPages"
                    pageSize: webDataPagination.pageSize
                    currentPage: webDataPagination.currentPage

                    onCurrentChange: function(number) {
                        webDataPagination.setPage(number)
                    }
                }
                EText {
                    text: ELocale.texts.PageSizeStatus.arg(webDataPagination.currentPage)
                        .arg(webDataPagination.pageSize)
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETree"

        ExampleCard {
            title: ELocale.texts.CheckingPartialSelectionFilteringAndDragAndDrop
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 12
                    width: parent.width

                    EInput {
                        width: Math.min(360, parent.width)
                        placeholderText: ELocale.texts.FilterNodes

                        onTextChanged: tree.filter(text)
                    }
                    ETree {
                        id: tree

                        draggable: true
                        showCheckbox: true
                        expandedKeys: ["team"]
                        expandOnClickNode: true
                        width: Math.min(440, parent.width)
                        model: [{ id: "team", label: ELocale.texts.ProductTeam, children: [
                            { id: "design", label: ELocale.texts.Design }, { id: "engineering", label: ELocale.texts.Engineering },
                            { id: "archived", label: ELocale.texts.Archived, disabled: true }] },
                            { id: "operations", label: ELocale.texts.Operations, children: [{ id: "support", label: ELocale.texts.Support }] }]
                    }
                    Row {
                        spacing: 8

                        EButton {
                            text: ELocale.texts.CheckTeam

                            onClicked: tree.setCheckedKeys(["team"])
                        }
                        EButton {
                            text: ELocale.texts.Clear

                            onClicked: tree.setCheckedKeys([])
                        }
                        ECheckBox {
                            text: ELocale.texts.StrictChecking

                            onToggled: tree.checkStrictly = checked
                        }
                    }
                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.TreeCheckStatus.arg(tree.getCheckedKeys().join(", ")).arg(tree.halfCheckedKeys.join(", "))
                    }
                }
`)

            Column {
                spacing: 12
                width: parent.width

                EInput {
                    width: Math.min(360, parent.width)
                    placeholderText: ELocale.texts.FilterNodes

                    onTextChanged: webDataTree.filter(text)
                }
                ETree {
                    id: webDataTree

                    draggable: true
                    showCheckbox: true
                    expandedKeys: ["team"]
                    expandOnClickNode: true
                    width: Math.min(440, parent.width)
                    model: [{ id: "team", label: ELocale.texts.ProductTeam, children: [
                        { id: "design", label: ELocale.texts.Design }, { id: "engineering", label: ELocale.texts.Engineering },
                        { id: "archived", label: ELocale.texts.Archived, disabled: true }] },
                        { id: "operations", label: ELocale.texts.Operations, children: [{ id: "support", label: ELocale.texts.Support }] }]
                }
                Row {
                    spacing: 8

                    EButton {
                        text: ELocale.texts.CheckTeam

                        onClicked: webDataTree.setCheckedKeys(["team"])
                    }
                    EButton {
                        text: ELocale.texts.Clear

                        onClicked: webDataTree.setCheckedKeys([])
                    }
                    ECheckBox {
                        text: ELocale.texts.StrictChecking

                        onToggled: webDataTree.checkStrictly = checked
                    }
                }
                EText {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: ELocale.texts.Checked2
                        + webDataTree.getCheckedKeys().join(", ")
                        + ELocale.texts.Partial
                        + webDataTree.halfCheckedKeys.join(", ")
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETag"

        ExampleCard {
            code: exampleData.samples.DataExamplesSample0
            description: ELocale.texts.StatusTypesLightAndDarkEffectsSizes

            Flow {
                spacing: 12
                width: parent.width

                ETag {
                    text: ELocale.texts.DefaultTag
                }
                ETag {
                    styleType: EStyle.Success
                    text: ELocale.texts.Success2
                }
                ETag {
                    styleType: EStyle.Warning
                    effect: ELocale.texts.Dark2
                    text: ELocale.texts.Warning2
                }
                ETag {
                    styleType: EStyle.Danger
                    text: ELocale.texts.Danger2
                    effect: ELocale.texts.Plain2
                }
                ETag {
                    enabled: false
                    text: ELocale.texts.Disabled2
                }
                ETag {
                    closable: true
                    text: ELocale.texts.Closable

                    onClosed: visible = false
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAvatar"

        ExampleCard {
            code: exampleData.samples.DataExamplesSample1
            description: ELocale.texts.RoundAndSquareAvatarsWithTextShown

            Row {
                spacing: 16

                EAvatar {
                    size: 48
                    text: ELocale.texts.Eu
                }
                EAvatar {
                    size: 40
                    shape: "square"
                    text: ELocale.texts.Z
                }
                EAvatar {
                    size: 32
                    text: ELocale.texts.L
                    backgroundColor: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Success)
                }
            }
        }
    }
    ExampleSection {
        componentName: "EBadge"

        ExampleCard {
            code: exampleData.samples.DataExamplesSample2
            description: ELocale.texts.NumericBadgesMaximumValuesAndNotificationDots

            Row {
                spacing: 36

                EBadge {
                    value: 12

                    EButton {
                        text: ELocale.texts.Comments
                    }
                }
                EBadge {
                    value: 120

                    EButton {
                        text: ELocale.texts.Messages
                    }
                }
                EBadge {
                    isDot: true

                    EButton {
                        text: ELocale.texts.Updates
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECard"

        ExampleCard {
            code: exampleData.samples.DataExamplesSample3
            description: ELocale.texts.TheHeaderBodyAndFooterFollowThe

            ECard {
                width: parent.width
                footer: ELocale.texts.UpdatedToday
                header: ELocale.texts.ProjectStatus

                Row {
                    spacing: 16

                    ETag {
                        styleType: EStyle.Success
                        text: ELocale.texts.Completed
                    }
                    EText {
                        font.pixelSize: 14
                        text: ELocale.texts.AllTasksAreComplete
                        anchors.verticalCenter: parent.verticalCenter
                        color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EEmpty"

        ExampleCard {
            code: exampleData.samples.DataExamplesSample4
            description: ELocale.texts.ProvideAnExplanationAndNextActionWhen

            EEmpty {
                width: parent.width
                description: ELocale.texts.NoMatchingResults

                EButton {
                    styleType: EStyle.Primary
                    text: ELocale.texts.SearchAgain

                    onClicked: page.lastSelection = ELocale.texts.SearchRefreshed
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESkeleton"

        ExampleCard {
            code: exampleData.samples.DataExamplesSample5
            description: ELocale.texts.SwitchBetweenAnAnimatedSkeletonAndThe

            ESwitch {
                id: skeletonSwitch

                checked: true
                text: ELocale.texts.Loading
            }
            ESkeleton {
                rows: 3
                animated: true
                width: parent.width
                loading: skeletonSwitch.checked

                EText {
                    font.pixelSize: 14
                    text: ELocale.texts.DataIsLoadedYouCanContinue
                    color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETable"

        ExampleCard {
            description: ELocale.texts.ClickAHeaderToSortAndA

            ExampleCase {
                title: ELocale.texts.BasicUsage
                code: exampleData.samples.DataExamplesSample6

                Flow {
                    spacing: 10
                    width: parent.width

                    ETag {
                        effect: "plain"
                        size: EStyle.Small
                        styleType: EStyle.Info
                        text: exampleData.ui.TableRecords.arg(table.rowCount)
                    }
                    EText {
                        height: 28
                        font.pixelSize: 13
                        color: GalleryStyle.muted
                        objectName: "galleryTableSelection"
                        verticalAlignment: Text.AlignVCenter
                        text: table.currentRow ? exampleData.ui.TableSelected.arg(table.currentRow.name)
                            : ELocale.texts.NoSelection
                    }
                    ETag {
                        effect: "plain"
                        size: EStyle.Small
                        styleType: EStyle.Info
                        objectName: "galleryTableSortStatus"
                        text: table.sortOrder === "ascending" ? exampleData.ui.TableAscending
                            : table.sortOrder === "descending" ? exampleData.ui.TableDescending
                                : exampleData.ui.TableOriginalOrder
                    }
                    ETextButton {
                        size: EStyle.Small
                        enabled: table.currentRow !== null
                        objectName: "galleryTableClearSelection"
                        text: exampleData.ui.TableClearSelection

                        onClicked: table.clearSelection()
                    }
                    ETextButton {
                        size: EStyle.Small
                        enabled: table.sortOrder.length > 0
                        text: exampleData.ui.TableClearSort
                        objectName: "galleryTableClearSorting"

                        onClicked: table.sort(table.sortProp, "")
                    }
                }
                ETable {
                    id: table

                    stripe: true
                    rowHeight: 46
                    headerHeight: 44
                    width: parent.width
                    objectName: "galleryTable"
                    model: exampleData.models.TableRows
                    columns: exampleData.models.TableColumns
                }
            }
            ExampleCase {
                title: exampleData.ui.LargeData
                code: exampleData.samples.TableLargeData

                ETable {
                    height: 260
                    stripe: true
                    rowHeight: 46
                    headerHeight: 44
                    width: parent.width
                    model: exampleData.models.ManyRows
                    columns: exampleData.models.VirtualTableColumns
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETree"

        ExampleCard {
            description: ELocale.texts.ClickAnArrowToExpandAndA

            ExampleCase {
                title: ELocale.texts.BasicUsage
                code: exampleData.samples.DataExamplesSample7

                ETree {
                    width: parent.width
                    model: exampleData.models.WorkspaceTree
                    expandedKeys: exampleData.models.ExpandedTreeKeys

                    onNodeSelected: function(node, key) {
                        page.lastSelection = ELocale.texts.SelectedNode1.arg(node.label)
                    }
                }
            }
            ExampleCase {
                title: exampleData.ui.LargeData
                code: exampleData.samples.TreeLargeData

                ETree {
                    height: 260
                    width: parent.width
                    model: exampleData.models.ManyNodes
                }
            }
        }
    }
    ExampleSection {
        componentName: "EPagination"

        ExampleCard {
            code: exampleData.samples.DataExamplesSample8
            description: ELocale.texts.SwitchPagesWithPageNumbersAndPrevious

            EPagination {
                id: pagination

                total: 256
                pageSize: 10

                onCurrentChange: function(number) {
                    page.lastSelection = ELocale.texts.Page1.arg(number)
                }
            }
            EText {
                font.pixelSize: 14
                color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                text: ELocale.texts.Page1Of2.arg(pagination.currentPage).arg(pagination.pageCount)
            }
        }
    }
    DataShowcase { }
    PrimeShowcase { names: ["ETag"] }
}

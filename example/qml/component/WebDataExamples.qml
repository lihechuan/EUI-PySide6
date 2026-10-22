import EUI 1.0
import QtQuick 2.15

ExamplePage {
    id: page

    title: ELocale.texts.DataDisplayInteractions
    description: ELocale.texts.WorkingExamplesOfCheckingFilteringPreviewsPaginationLayouts

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
        componentName: "EImage"

        ExampleCard {
            title: ELocale.texts.MultiplePreviewsZoomRotationAndKeyboardNavigation
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EImage {
                    width: 240
                    height: 160
                    preview: true
                    source: "qrc:/example/images/gallery/lake.jpg"
                    previewSrcList: ["qrc:/example/images/gallery/lake.jpg",
                        "qrc:/example/images/gallery/neon-red.jpg",
                        "qrc:/example/images/gallery/neon-purple.jpg",
                        "qrc:/example/images/gallery/tree.jpg",
                        "qrc:/example/images/gallery/ocean.jpg"]
                    showProgress: true
                    minScale: 0.25
                    maxScale: 4
                }`)

            EImage {
                width: 240
                height: 160
                maxScale: 4
                preview: true
                minScale: 0.25
                showProgress: true
                source: "qrc:/example/images/gallery/lake.jpg"
                previewSrcList: ["qrc:/example/images/gallery/lake.jpg",
                    "qrc:/example/images/gallery/neon-red.jpg",
                    "qrc:/example/images/gallery/neon-purple.jpg",
                    "qrc:/example/images/gallery/tree.jpg",
                    "qrc:/example/images/gallery/ocean.jpg"]
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
        componentName: "ECarousel"

        ExampleCard {
            title: ELocale.texts.CardCarouselHoverPauseAndNamedSlides
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 12
                    width: parent.width

                    ECarousel {
                        id: carousel

                        height: 220
                        type: "card"
                        arrow: "hover"
                        trigger: "hover"
                        pauseOnHover: true
                        width: Math.min(600, parent.width)
                        delegate: EClip {
                            id: slide

                            readonly property var slideData: parent.modelData

                            radius: 8

                            Image {
                                anchors.fill: parent
                                source: slide.slideData.source
                                fillMode: Image.PreserveAspectCrop
                            }
                            EText {
                                padding: 12
                                color: "white"
                                font.pixelSize: 24
                                style: Text.Outline
                                styleColor: "#80000000"
                                text: slide.slideData.title
                                anchors.bottom: parent.bottom
                            }
                        }
                        model: [{ name: "design", title: ELocale.texts.DesignSystem, source: "qrc:/example/images/gallery/lake.jpg" },
                            { name: "build", title: ELocale.texts.ComponentEngineering, source: "qrc:/example/images/gallery/neon-red.jpg" },
                            { name: "ship", title: ELocale.texts.ProductDelivery, source: "qrc:/example/images/gallery/neon-purple.jpg" }]
                    }
                    EButton {
                        text: ELocale.texts.OpenComponentEngineering

                        onClicked: carousel.setActiveItem("build")
                    }
                }
`)

            Column {
                spacing: 12
                width: parent.width

                ECarousel {
                    id: webDataCarousel

                    height: 220
                    type: "card"
                    arrow: "hover"
                    trigger: "hover"
                    pauseOnHover: true
                    width: Math.min(600, parent.width)
                    delegate: EClip {
                        id: slide

                        readonly property var slideData: parent.modelData

                        radius: 8

                        Image {
                            anchors.fill: parent
                            source: slide.slideData.source
                            fillMode: Image.PreserveAspectCrop
                        }
                        EText {
                            padding: 12
                            color: "white"
                            font.pixelSize: 24
                            style: Text.Outline
                            styleColor: "#80000000"
                            text: slide.slideData.title
                            anchors.bottom: parent.bottom
                        }
                    }
                    model: [{ name: "design", title: ELocale.texts.DesignSystem, source: "qrc:/example/images/gallery/lake.jpg" },
                        { name: "build", title: ELocale.texts.ComponentEngineering, source: "qrc:/example/images/gallery/neon-red.jpg" },
                        { name: "ship", title: ELocale.texts.ProductDelivery, source: "qrc:/example/images/gallery/neon-purple.jpg" }]
                }
                EButton {
                    text: ELocale.texts.OpenComponentEngineering

                    onClicked: webDataCarousel.setActiveItem("build")
                }
            }
        }
    }
    ExampleSection {
        componentName: "EDescriptions"

        ExampleCard {
            title: ELocale.texts.ColumnAndRowSpansVerticalLabelsAndExtra
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 12
                    width: parent.width

                    ECheckBox {
                        text: ELocale.texts.VerticalLabels

                        onToggled: details.direction = checked ? "vertical" : "horizontal"
                    }
                    EDescriptions {
                        id: details

                        width: parent.width
                        columns: width < 560 ? 2 : 3
                        extra: ELocale.texts.Verified
                        title: ELocale.texts.ProjectDetails2
                        model: [{ label: ELocale.texts.Name2, value: ELocale.texts.EUIComponentLibrary, span: 2 },
                            { label: ELocale.texts.Version, value: "3.0" }, { label: ELocale.texts.Maintainer, value: ELocale.texts.ProductTeam, rowspan: 2 },
                            { label: ELocale.texts.Platform, value: "Desktop", span: 2 },
                            { label: ELocale.texts.ApiDescription, value: ELocale.texts.ThemesKeyboardAndCustomContent, span: 2 }]
                    }
                }
            `)

            Column {
                spacing: 12
                width: parent.width

                ECheckBox {
                    text: ELocale.texts.VerticalLabels

                    onToggled: webDataDetails.direction = checked ? "vertical" : "horizontal"
                }
                EDescriptions {
                    id: webDataDetails

                    width: parent.width
                    columns: width < 560 ? 2 : 3
                    extra: ELocale.texts.Verified
                    title: ELocale.texts.ProjectDetails2
                    model: [{ label: ELocale.texts.Name2, value: ELocale.texts.EUIComponentLibrary, span: 2 },
                        { label: ELocale.texts.Version, value: "3.0" }, { label: ELocale.texts.Maintainer, value: ELocale.texts.ProductTeam, rowspan: 2 },
                        { label: ELocale.texts.Platform, value: "Desktop", span: 2 },
                        { label: ELocale.texts.Description, value: ELocale.texts.ThemesKeyboardAndCustomContent, span: 2 }]
                }
            }
        }
    }
    ExampleSection {
        componentName: "EProgress"

        ExampleCard {
            title: ELocale.texts.PercentagesColorThresholdsStripesAndIndeterminateProgress
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 20
                    width: parent.width

                    EProgress {
                        width: Math.min(500, parent.width)
                        height: 20
                        percentage: 68
                        showText: true
                        striped: true
                        stripedFlow: true
                        color: [{ color: "#E6A23C", percentage: 30 }, { color: "#409EFF", percentage: 70 },
                            { color: "#67C23A", percentage: 100 }]
                    }
                    EProgress {
                        width: Math.min(500, parent.width)
                        height: 10
                        indeterminate: true
                        duration: 1800
                    }
                }`)

            Column {
                spacing: 20
                width: parent.width

                EProgress {
                    height: 20
                    striped: true
                    percentage: 68
                    showText: true
                    stripedFlow: true
                    width: Math.min(500, parent.width)
                    color: [{ color: "#E6A23C", percentage: 30 }, { color: "#409EFF", percentage: 70 },
                        { color: "#67C23A", percentage: 100 }]
                }
                EProgress {
                    height: 10
                    duration: 1800
                    indeterminate: true
                    width: Math.min(500, parent.width)
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECircleProgress"

        ExampleCard {
            title: ELocale.texts.DashboardStatusAndFormattedText
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Row {
                    spacing: 28

                    ECircleProgress {
                        percentage: 75
                        showText: true
                        dashboard: true
                        strokeWidth: 10
                        status: "warning"
                        format: function(value) { return value + ELocale.texts.Points }
                    }
                    ECircleProgress {
                        showText: true
                        percentage: 100
                        status: "success"
                        strokeLinecap: "square"
                    }
                }
`)

            Row {
                spacing: 28

                ECircleProgress {
                    percentage: 75
                    showText: true
                    dashboard: true
                    strokeWidth: 10
                    status: "warning"
                    format: function(value) {
                        return value + ELocale.texts.Points
                    }
                }
                ECircleProgress {
                    showText: true
                    percentage: 100
                    status: "success"
                    strokeLinecap: "square"
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECollapse"

        ExampleCard {
            title: ELocale.texts.BeforeChangeValidationAndCustomContent
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ECollapse {
                    activeNames: ["overview"]
                    expandIconPosition: "left"
                    width: Math.min(600, parent.width)
                    beforeCollapse: function(name, expanded) { return name !== "locked" }
                    model: [{ name: "overview", title: ELocale.texts.ProjectOverview, content: ELocale.texts.MultiplePanelsAccordionAndAsyncBeforeCollapseValidation },
                        { name: "locked", title: ELocale.texts.ChangeBlockedByValidation, content: ELocale.texts.ThisPanelRemainsClosed },
                        { name: "details", title: ELocale.texts.InteractionDetails, content: ELocale.texts.TitlesAndContentCanUseComponentDelegates }]
                }
`)

            ECollapse {
                activeNames: ["overview"]
                expandIconPosition: "left"
                width: Math.min(600, parent.width)
                beforeCollapse: function(name, expanded) {
                    return name !== "locked"
                }
                model: [{ name: "overview", title: ELocale.texts.ProjectOverview, content: ELocale.texts.MultiplePanelsAccordionAndAsyncBeforeCollapseValidation },
                    { name: "locked", title: ELocale.texts.ChangeBlockedByValidation, content: ELocale.texts.ThisPanelRemainsClosed },
                    { name: "details", title: ELocale.texts.InteractionDetails, content: ELocale.texts.TitlesAndContentCanUseComponentDelegates }]
            }
        }
    }
    ExampleSection {
        componentName: "ESegmented"

        ExampleCard {
            title: ELocale.texts.ValueBindingDisabledOptionsAndKeyboardNavigation
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 12
                    width: parent.width

                    ESegmented {
                        id: segmented

                        width: 360
                        block: true
                        value: "day"
                        model: [{ label: ELocale.texts.Day, value: "day" }, { label: ELocale.texts.Week, value: "week" },
                            { label: ELocale.texts.Month, value: "month" }, { label: ELocale.texts.Year, value: "year", disabled: true }]
                    }
                    EText {
                        text: ELocale.texts.CurrentValue + segmented.currentValue
                    }
                }
`)

            Column {
                spacing: 12
                width: parent.width

                ESegmented {
                    id: webDataSegmented

                    width: 360
                    block: true
                    value: "day"
                    model: [{ label: ELocale.texts.Day, value: "day" }, { label: ELocale.texts.Week, value: "week" },
                        { label: ELocale.texts.Month, value: "month" }, { label: ELocale.texts.Year, value: "year", disabled: true }]
                }
                EText {
                    text: ELocale.texts.CurrentValue
                        + webDataSegmented.currentValue
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
        componentName: "EStatistic"

        ExampleCard {
            title: ELocale.texts.FormattedValuesAndCountdown
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Row {
                    spacing: 48

                    EStatistic {
                        precision: 2
                        prefix: "¥ "
                        value: 12680.25
                        title: ELocale.texts.MonthlyRevenue
                    }
                    EStatistic {
                        countdown: true
                        format: "HH:mm:ss"
                        value: Date.now() + 3600000
                        title: ELocale.texts.NextUpdateIn2
                    }
                }
`)

            Row {
                spacing: 48

                EStatistic {
                    precision: 2
                    prefix: "¥ "
                    value: 12680.25
                    title: ELocale.texts.MonthlyRevenue
                }
                EStatistic {
                    countdown: true
                    format: "HH:mm:ss"
                    value: Date.now() + 3600000
                    title: ELocale.texts.NextUpdateIn2
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETimeline"

        ExampleCard {
            title: ELocale.texts.AlternatingLayoutIconsAndTimestampPositions
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ETimeline {
                    mode: "alternate"
                    width: Math.min(600, parent.width)
                    model: [{ content: ELocale.texts.RequirementsConfirmed, timestamp: "2026-10-01", placement: "top", styleType: EStyle.Success },
                        { content: ELocale.texts.DevelopmentComplete, timestamp: "2026-10-05", icon: EIcons.CHECK, size: "large" },
                        { content: ELocale.texts.ReadyToRelease, timestamp: "2026-10-10", hollow: true, styleType: EStyle.Warning }]
                }
`)

            ETimeline {
                mode: "alternate"
                width: Math.min(600, parent.width)
                model: [{ content: ELocale.texts.RequirementsConfirmed, timestamp: "2026-10-01", placement: "top", styleType: EStyle.Success },
                    { content: ELocale.texts.DevelopmentComplete, timestamp: "2026-10-05", icon: EIcons.CHECK, size: "large" },
                    { content: ELocale.texts.ReadyToRelease, timestamp: "2026-10-10", hollow: true, styleType: EStyle.Warning }]
            }
        }
    }
    ExampleSection {
        componentName: "ECalendar"

        ExampleCard {
            title: ELocale.texts.DateRangesAndCustomDateCells
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ECalendar {
                    value: "2026-10-10"
                    controllerType: "select"
                    width: Math.min(620, parent.width)
                    dateCellDelegate: Component {
                        EText {
                            padding: 10
                            wrapMode: Text.WordWrap
                            text: parent.day.slice(-2) + (parent.day === "2026-10-10" ? ELocale.texts.ReleaseDayMarker : "")
                            color: parent.isSelected ? EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                                : EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                        }
                    }
                }
`)

            ECalendar {
                value: "2026-10-10"
                controllerType: "select"
                width: Math.min(620, parent.width)
                dateCellDelegate: Component {
                    EText {
                        padding: 10
                        wrapMode: Text.WordWrap
                        text: parent.day.slice(-2)
                            + (parent.day === "2026-10-10"
                                ? ELocale.texts.Release
                                : "")
                        color: parent.isSelected
                            ? EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                            : EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                    }
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
        componentName: "EResult"

        ExampleCard {
            title: ELocale.texts.ResultTitlesAndActions
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EResult {
                    width: parent.width
                    styleType: EStyle.Success
                    title: ELocale.texts.PublishedSuccessfully
                    subTitle: ELocale.texts.AllTasksAreCompleteYouCanNowView

                    EButton {
                        styleType: EStyle.Primary
                        text: ELocale.texts.CoreSampleDetails
                    }
                    EButton { text: ELocale.texts.Back }
                }
`)

            EResult {
                width: parent.width
                styleType: EStyle.Success
                title: ELocale.texts.PublishedSuccessfully
                subTitle: ELocale.texts.AllTasksAreCompleteYouCanNowView

                EButton { text: ELocale.texts.Back }
                EButton {
                    styleType: EStyle.Primary
                    text: ELocale.texts.ViewDetails2
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETour"

        ExampleCard {
            title: ELocale.texts.PlacementMasksAndTargetInteraction
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        id: targetButton

                        text: ELocale.texts.StartTour2

                        onClicked: tour.start()
                    }
                    ETour {
                        id: tour

                        placement: "bottom-start"
                        targetAreaClickable: true
                        gap: ({ offset: 8, radius: 6 })
                        steps: [{ target: targetButton, title: ELocale.texts.ActionEntry, description: ELocale.texts.TheTargetRemainsClickableDuringTheTour },
                            { title: ELocale.texts.Done, description: ELocale.texts.ATourCardWithoutATargetAppearsIn }]
                    }
                }
`)

            Column {
                spacing: 16
                width: parent.width

                EButton {
                    id: webDataTargetButton

                    text: ELocale.texts.StartTour2

                    onClicked: webDataTour.start()
                }
                ETour {
                    id: webDataTour

                    placement: "bottom-start"
                    targetAreaClickable: true
                    gap: ({ offset: 8, radius: 6 })
                    steps: [{ target: webDataTargetButton, title: ELocale.texts.ActionEntry, description: ELocale.texts.TheTargetRemainsClickableDuringTheTour },
                        { title: ELocale.texts.Done, description: ELocale.texts.ATourCardWithoutATargetAppearsIn }]
                }
            }
        }
    }
    ExampleSection {
        componentName: "EInfiniteScroll"

        ExampleCard {
            title: ELocale.texts.ThrottledLoadingAndExplicitCompletion
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EInfiniteScroll {
                    id: list

                    delay: 200
                    height: 200
                    distance: 24
                    width: Math.min(480, parent.width)
                    model: [ELocale.texts.Record1, ELocale.texts.Record2, ELocale.texts.Record3, ELocale.texts.Record4]

                    onLoadMore: {
                        const rows = model.slice()
                        for (let index = 0; index < 4; ++index)
                            rows.push(ELocale.texts.Record + (rows.length + 1))
                        model = rows
                        finishLoad(rows.length >= 20)
                    }
                }
`)

            EInfiniteScroll {
                id: webDataList

                delay: 200
                height: 200
                distance: 24
                width: Math.min(480, parent.width)
                model: [ELocale.texts.Record1, ELocale.texts.Record2, ELocale.texts.Record3, ELocale.texts.Record4]

                onLoadMore: {
                    const rows = model.slice()
                    for (let index = 0; index < 4; ++index)
                        rows.push(ELocale.texts.Record + (rows.length + 1))
                    model = rows
                    finishLoad(rows.length >= 20)
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
        componentName: "ECountdown"

        ExampleCard {
            title: ELocale.texts.StandaloneCountdown
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ECountdown {
                    title: ELocale.texts.NextUpdateIn
                    value: Date.now() + 600000
                    format: "mm:ss"
                }`)

            ECountdown {
                format: "mm:ss"
                value: Date.now() + 600000
                title: ELocale.texts.NextUpdateIn
            }
        }
    }
    ExampleSection {
        componentName: "EImageViewer"

        ExampleCard {
            title: ELocale.texts.StandaloneImageViewer
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    EButton {
                        text: ELocale.texts.OpenPreview

                        onClicked: webDataViewer.visible = true
                    }
                    EImageViewer {
                        id: webDataViewer

                        visible: false
                        urlList: ["qrc:/example/images/gallery/lake.jpg",
                            "qrc:/example/images/gallery/neon-red.jpg",
                            "qrc:/example/images/gallery/neon-purple.jpg",
                            "qrc:/example/images/gallery/tree.jpg",
                            "qrc:/example/images/gallery/ocean.jpg"]

                        onPreviewClosed: visible = false
                    }
                }`)

            Column {
                EButton {
                    text: ELocale.texts.OpenPreview

                    onClicked: webDataViewer.visible = true
                }
                EImageViewer {
                    id: webDataViewer

                    visible: false
                    urlList: ["qrc:/example/images/gallery/lake.jpg",
                        "qrc:/example/images/gallery/neon-red.jpg",
                        "qrc:/example/images/gallery/neon-purple.jpg",
                        "qrc:/example/images/gallery/tree.jpg",
                        "qrc:/example/images/gallery/ocean.jpg"]

                    onPreviewClosed: visible = false
                }
            }
        }
    }
}

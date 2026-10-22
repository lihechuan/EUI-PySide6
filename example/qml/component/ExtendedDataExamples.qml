import EUI 1.0
import QtQuick 2.15

ExamplePage {
    id: page

    property var scrollItems: exampleData.models.ScrollItems.slice()

    title: ELocale.texts.MoreDataDisplay
    description: ELocale.texts.CalendarsImagesCarouselsCollapsePanelsTimelinesStatistics

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
        componentName: "ECalendar"

        ExampleCard {
            code: exampleData.samples.ExtendedDataExamplesSample0
            description: ELocale.texts.NavigateMonthsAndSelectADateWith

            ECalendar {
                value: ELocale.texts.Value20261010
                maxDate: ELocale.texts.Value20261231
                minDate: ELocale.texts.Value20260101
            }
        }
    }
    ExampleSection {
        componentName: "ECarousel"

        ExampleCard {
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ECarousel {
                    height: 220
                    width: parent.width
                    model: ["qrc:/example/images/gallery/lake.jpg",
                        "qrc:/example/images/gallery/neon-red.jpg", "qrc:/example/images/gallery/neon-purple.jpg"]
                    delegate: Image {
                        source: parent.modelData
                        fillMode: Image.PreserveAspectCrop
                    }
                }`)
            description: ELocale.texts.SupportsAutoplaySwipeNavigationAndCustomContent

            ECarousel {
                height: 220
                width: parent.width
                model: ["qrc:/example/images/gallery/lake.jpg",
                    "qrc:/example/images/gallery/neon-red.jpg", "qrc:/example/images/gallery/neon-purple.jpg"]
                delegate: Image {
                    source: parent.modelData
                    fillMode: Image.PreserveAspectCrop
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECollapse"

        ExampleCard {
            code: exampleData.samples.ExtendedDataExamplesSample2
            description: ELocale.texts.ExpandAndCollapseContentAccordionModeKeeps

            ECollapse {
                accordion: true
                width: parent.width
                model: exampleData.models.CollapsePanels
                activeNames: exampleData.models.ActiveCollapseNames
            }
        }
    }
    ExampleSection {
        componentName: "EDescriptions"

        ExampleCard {
            code: exampleData.samples.ExtendedDataExamplesSample3
            description: ELocale.texts.DisplayLabeledValuesWithConfigurableColumnsAnd

            EDescriptions {
                columns: 2
                width: parent.width
                title: ELocale.texts.UserInformation
                model: exampleData.models.UserDescriptions
            }
        }
    }
    ExampleSection {
        componentName: "EImage"

        ExampleCard {
            code: exampleData.samples.ExtendedDataExamplesSample4
            description: ELocale.texts.DisplayLoadingAndErrorStatesClickAn

            Row {
                spacing: 16

                EImage {
                    preview: true
                    source: "qrc:/example/images/gallery/lake.jpg"
                }
                EImage {
                    errorText: ELocale.texts.SetAnImageSource
                }
            }
        }
    }
    ExampleSection {
        componentName: "EInfiniteScroll"

        ExampleCard {
            code: exampleData.samples.ExtendedDataExamplesSample5
            description: ELocale.texts.RequestMoreDataNearTheBottomWithout

            EInfiniteScroll {
                id: infiniteScroll

                width: parent.width
                model: page.scrollItems

                onLoadMore: loadDelay.restart()
            }
            Timer {
                id: loadDelay

                interval: 500

                onTriggered: {
                    const next = []
                    for (let index = 0; index < 8; ++index)
                        next.push(page.scrollItems.length + index + 1)
                    page.scrollItems = page.scrollItems.concat(next)
                    infiniteScroll.finishLoad(page.scrollItems.length >= 40)
                }
            }
        }
    }
    ExampleSection {
        componentName: "EResult"

        ExampleCard {
            code: exampleData.samples.ExtendedDataExamplesSample6
            description: ELocale.texts.DisplayOperationResultsWithATitleDescription

            EResult {
                width: parent.width
                title: ELocale.texts.Success3
                subTitle: ELocale.texts.YourChangesAreSavedYouCanContinue

                EButton {
                    text: ELocale.texts.Back
                    styleType: EStyle.Primary
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETimeline"

        ExampleCard {
            code: exampleData.samples.ExtendedDataExamplesSample9
            description: ELocale.texts.DisplayEventTimestampsStatusTypesAndContent

            ETimeline {
                width: parent.width
                model: exampleData.models.TimelineEvents
            }
        }
    }
    ExampleSection {
        componentName: "ETour"

        ExampleCard {
            code: exampleData.samples.ExtendedDataExamplesSample10
            description: ELocale.texts.HighlightTargetControlsInAGuidedTour

            Row {
                spacing: 12

                EButton {
                    id: startTour

                    styleType: EStyle.Primary
                    text: ELocale.texts.StartTour

                    onClicked: tour.start()
                }
                EButton {
                    id: nextTarget

                    text: ELocale.texts.NextAction
                }
            }
            ETour {
                id: tour

                steps: [{
                    "target": startTour,
                    "title": exampleData.models.TourSteps[0].title,
                    "description": exampleData.models.TourSteps[0].description
                }, {
                    "target": nextTarget,
                    "title": exampleData.models.TourSteps[1].title,
                    "description": exampleData.models.TourSteps[1].description
                }]
            }
        }
    }
    ExampleSection {
        componentName: "EStatistic"

        ExampleCard {
            code: exampleData.samples.ExtendedDataExamplesSample11
            description: ELocale.texts.FormatStatisticsWithPrecisionThousandsSeparatorsAnd

            Row {
                spacing: 48

                EStatistic {
                    value: 268500
                    title: ELocale.texts.ActiveUsers
                }
                EStatistic {
                    precision: 2
                    value: 12345.67
                    prefix: ELocale.texts.Symbol2
                    title: ELocale.texts.TodaySSales
                }
                EStatistic {
                    value: 98.6
                    precision: 1
                    suffix: ELocale.texts.Symbol3
                    title: ELocale.texts.CompletionRate
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESegmented"

        ExampleCard {
            code: exampleData.samples.ExtendedDataExamplesSample12
            description: ELocale.texts.AnExclusiveSelectorSupportingStringsOrObjects

            ESegmented {
                model: exampleData.models.Periods
            }
            ESegmented {
                model: exampleData.models.ViewModes
            }
        }
    }
    ExampleSection {
        componentName: "EStatusView"

        ExampleCard {
            code: exampleData.samples.StatusView
            description: exampleData.ui.StatusIntroduction

            ESegmented {
                id: statusSelector

                currentIndex: 0
                model: exampleData.models.StatusStates
            }
            EStatusView {
                id: statusView

                height: 240
                width: parent.width
                state: statusSelector.currentValue
                errorText: exampleData.ui.StatusError

                onRetry: {
                    statusSelector.currentIndex = 1
                    retryTimer.restart()
                }

                EText {
                    font.pixelSize: 14
                    anchors.centerIn: parent
                    text: exampleData.ui.ContentReady
                    color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                }
            }
            Timer {
                id: retryTimer

                interval: 1000

                onTriggered: statusSelector.currentIndex = 0
            }
        }
    }
    ExampleSection {
        componentName: "EChart"

        ExampleCard {
            code: exampleData.samples.Chart
            description: exampleData.ui.ChartIntroduction

            ESegmented {
                id: chartType

                currentIndex: 0
                model: exampleData.models.ChartTypes
            }
            EChart {
                height: 260
                width: parent.width
                type: chartType.currentValue
                model: exampleData.models.ChartValues
            }
        }
    }
    ExampleSection {
        componentName: "EQRCode"

        ExampleCard {
            code: exampleData.samples.QrCode
            description: exampleData.ui.QrIntroduction

            EInput {
                id: qrText

                text: exampleData.ui.ExampleUrl
                width: Math.min(420, parent.width)
            }
            EQRCode {
                width: 180
                height: 180
                text: qrText.text
            }
        }
    }
    ExtendedDataShowcase { }
    PrimeShowcase { names: ["EImage", "EImageViewer"] }
}

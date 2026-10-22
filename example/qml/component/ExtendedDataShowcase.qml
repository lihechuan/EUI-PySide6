import EUI 1.0
import QtQuick 2.15

Column {
    spacing: 24
    width: parent.width

    ExampleSection {
        componentName: "EChart"

        ExampleCase {
            objectName: "showcaseEChart0"
            title: ELocale.texts.AreaChart
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EChart {
                    type: 2
                    height: 220
                    color: "#67c23a"
                    width: Math.min(640, parent.width)
                    model: [{label: "Mon", value: 30}, {label: "Tue", value: 55}, {label: "Wed", value: 42}, {label: "Thu", value: 80}]
                }
            `)

            EChart {
                type: 2
                height: 220
                color: "#67c23a"
                width: Math.min(640, parent.width)
                model: [{label: "Mon", value: 30}, {label: "Tue", value: 55}, {label: "Wed", value: 42}, {label: "Thu", value: 80}]
            }
        }
    }
    ExampleSection {
        componentName: "EChart"

        ExampleCase {
            objectName: "showcaseEChart1"
            title: ELocale.texts.BarChart2
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EChart {
                    type: 1
                    height: 220
                    color: "#e6a23c"
                    width: Math.min(640, parent.width)
                    model: [{label: "Mon", value: 30}, {label: "Tue", value: 55}, {label: "Wed", value: 42}, {label: "Thu", value: 80}]
                }
            `)

            EChart {
                type: 1
                height: 220
                color: "#e6a23c"
                width: Math.min(640, parent.width)
                model: [{label: "Mon", value: 30}, {label: "Tue", value: 55}, {label: "Wed", value: 42}, {label: "Thu", value: 80}]
            }
        }
    }
    ExampleSection {
        componentName: "EChart"

        ExampleCase {
            objectName: "showcaseEChart2"
            title: ELocale.texts.EmptyChart
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EChart {
                    model: []
                    height: 220
                    width: Math.min(640, parent.width)
                }
            `)

            EChart {
                model: []
                height: 220
                width: Math.min(640, parent.width)
            }
        }
    }
    ExampleSection {
        componentName: "EChart"

        ExampleCase {
            objectName: "showcaseEChart3"
            title: ELocale.texts.ChartUpdates
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EChart {
                        id: chart

                        height: 220
                        width: Math.min(640, parent.width)
                        model: [{label: "Mon", value: 30}, {label: "Tue", value: 55}, {label: "Wed", value: 42}, {label: "Thu", value: 80}]
                    }
                    EButton {
                        text: ELocale.texts.UpdateData

                        onClicked: chart.model = [{label: "Mon", value: 80}, {label: "Tue", value: 30}, {label: "Wed", value: 65}, {label: "Thu", value: 45}]
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EChart {
                    id: chart

                    height: 220
                    width: Math.min(640, parent.width)
                    model: [{label: "Mon", value: 30}, {label: "Tue", value: 55}, {label: "Wed", value: 42}, {label: "Thu", value: 80}]
                }
                EButton {
                    text: ELocale.texts.UpdateData

                    onClicked: chart.model = [{label: "Mon", value: 80}, {label: "Tue", value: 30}, {label: "Wed", value: 65}, {label: "Thu", value: 45}]
                }
            }
        }
    }
    ExampleSection {
        componentName: "EImage"

        ExampleCase {
            objectName: "showcaseEImage0"
            title: ELocale.texts.ImageFitModes
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    EImage {
                        width: 140
                        height: 100
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/example/images/gallery/tree.jpg"
                    }
                    EImage {
                        width: 140
                        height: 100
                        fillMode: Image.PreserveAspectCrop
                        source: "qrc:/example/images/gallery/tree.jpg"
                    }
                    EImage {
                        width: 140
                        height: 100
                        fillMode: Image.Stretch
                        source: "qrc:/example/images/gallery/tree.jpg"
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                EImage {
                    width: 140
                    height: 100
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/example/images/gallery/tree.jpg"
                }
                EImage {
                    width: 140
                    height: 100
                    fillMode: Image.PreserveAspectCrop
                    source: "qrc:/example/images/gallery/tree.jpg"
                }
                EImage {
                    width: 140
                    height: 100
                    fillMode: Image.Stretch
                    source: "qrc:/example/images/gallery/tree.jpg"
                }
            }
        }
    }
    ExampleSection {
        componentName: "EImage"

        ExampleCase {
            objectName: "showcaseEImage1"
            title: ELocale.texts.ImageError
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 12

                    EImage {
                        id: errorImage

                        width: 240
                        height: 140
                        objectName: "imageErrorExample"
                        errorText: ELocale.texts.ImageUnavailable
                        source: "qrc:/example/images/gallery/lake.jpg"
                    }
                    EButton {
                        objectName: "simulateImageError"
                        text: ELocale.texts.SimulateImageError

                        onClicked: errorImage.source = "qrc:/example/missing-image.png"
                    }
                }
            `)

            Column {
                spacing: 12

                EImage {
                    id: errorImage

                    width: 240
                    height: 140
                    objectName: "imageErrorExample"
                    errorText: ELocale.texts.ImageUnavailable
                    source: "qrc:/example/images/gallery/lake.jpg"
                }
                EButton {
                    objectName: "simulateImageError"
                    text: ELocale.texts.SimulateImageError

                    onClicked: errorImage.source = "qrc:/example/missing-image.png"
                }
            }
        }
    }
    ExampleSection {
        componentName: "EImage"

        ExampleCase {
            objectName: "showcaseEImage2"
            title: ELocale.texts.ImagePreview
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EImage {
                    width: 180
                    height: 140
                    maxScale: 3
                    minScale: 0.5
                    preview: true
                    zoomRate: 1.2
                    source: "qrc:/example/images/gallery/lake.jpg"
                    previewSrcList: ["qrc:/example/images/gallery/lake.jpg",
                        "qrc:/example/images/gallery/neon-red.jpg",
                        "qrc:/example/images/gallery/neon-purple.jpg",
                        "qrc:/example/images/gallery/tree.jpg",
                        "qrc:/example/images/gallery/ocean.jpg"]
                }
            `)

            EImage {
                width: 180
                height: 140
                maxScale: 3
                minScale: 0.5
                preview: true
                zoomRate: 1.2
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
        componentName: "ETour"

        ExampleCase {
            objectName: "showcaseETour0"
            title: ELocale.texts.GuidedSteps
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        id: target

                        text: ELocale.texts.StartTour

                        onClicked: tour.open()
                    }
                    ETour {
                        id: tour

                        gap: ({offset: 8, radius: 12})
                        steps: [{target: target, title: ELocale.texts.CreateProject, description: ELocale.texts.StartYourWorkHere}, {title: ELocale.texts.Ready2, description: ELocale.texts.ContinueExploringTheComponents}]
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EButton {
                    id: target

                    text: ELocale.texts.StartTour

                    onClicked: tour.open()
                }
                ETour {
                    id: tour

                    gap: ({offset: 8, radius: 12})
                    steps: [{target: target, title: ELocale.texts.CreateProject, description: ELocale.texts.StartYourWorkHere}, {title: ELocale.texts.Ready2, description: ELocale.texts.ContinueExploringTheComponents}]
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETour"

        ExampleCase {
            objectName: "showcaseETour1"
            title: ELocale.texts.UnmaskedTour
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        id: target

                        text: ELocale.texts.ShowHint

                        onClicked: tour.open()
                    }
                    ETour {
                        id: tour

                        mask: false
                        type: "primary"
                        placement: "right"
                        steps: [{target: target, title: ELocale.texts.ActionHint, description: ELocale.texts.ALightweightTourPreservesThePageContext}]
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EButton {
                    id: target

                    text: ELocale.texts.ShowHint

                    onClicked: tour.open()
                }
                ETour {
                    id: tour

                    mask: false
                    type: "primary"
                    placement: "right"
                    steps: [{target: target, title: ELocale.texts.ActionHint, description: ELocale.texts.ALightweightTourPreservesThePageContext}]
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETour"

        ExampleCase {
            objectName: "showcaseETour2"
            title: ELocale.texts.TourMaskOptions
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        id: target

                        text: ELocale.texts.StartTour

                        onClicked: tour.open()
                    }
                    ETour {
                        id: tour

                        showClose: true
                        showArrow: false
                        maskColor: "#B30B1423"
                        closeOnPressEscape: true
                        steps: [{target: target, title: ELocale.texts.Workspace2, description: ELocale.texts.PressEscapeToEndTheTour}]
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EButton {
                    id: target

                    text: ELocale.texts.StartTour

                    onClicked: tour.open()
                }
                ETour {
                    id: tour

                    showClose: true
                    showArrow: false
                    maskColor: "#B30B1423"
                    closeOnPressEscape: true
                    steps: [{target: target, title: ELocale.texts.Workspace2, description: ELocale.texts.PressEscapeToEndTheTour}]
                }
            }
        }
    }
    ExampleSection {
        componentName: "EResult"

        ExampleCase {
            objectName: "showcaseEResult0"
            title: ELocale.texts.SuccessAction
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EResult {
                    styleType: EStyle.Success
                    width: Math.min(480, parent.width)
                    title: ELocale.texts.CoreSampleSaved
                    subTitle: ELocale.texts.TheProjectHasBeenUpdated

                    EButton {
                        text: ELocale.texts.BackToProject
                    }
                }
            `)

            EResult {
                styleType: EStyle.Success
                width: Math.min(480, parent.width)
                title: ELocale.texts.CoreSampleSaved
                subTitle: ELocale.texts.TheProjectHasBeenUpdated

                EButton {
                    text: ELocale.texts.BackToProject
                }
            }
        }
    }
    ExampleSection {
        componentName: "EResult"

        ExampleCase {
            objectName: "showcaseEResult1"
            title: ELocale.texts.ResultStates
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    EResult {
                        styleType: EStyle.Warning
                        title: ELocale.texts.ActionResult
                        width: Math.min(300, parent.width)
                        subTitle: ELocale.texts.ViewTheDetailedDescription
                    }
                    EResult {
                        styleType: EStyle.Danger
                        title: ELocale.texts.ActionResult
                        width: Math.min(300, parent.width)
                        subTitle: ELocale.texts.ViewTheDetailedDescription
                    }
                    EResult {
                        styleType: EStyle.Info
                        title: ELocale.texts.ActionResult
                        width: Math.min(300, parent.width)
                        subTitle: ELocale.texts.ViewTheDetailedDescription
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                EResult {
                    styleType: EStyle.Warning
                    title: ELocale.texts.ActionResult
                    width: Math.min(300, parent.width)
                    subTitle: ELocale.texts.ViewTheDetailedDescription
                }
                EResult {
                    styleType: EStyle.Danger
                    title: ELocale.texts.ActionResult
                    width: Math.min(300, parent.width)
                    subTitle: ELocale.texts.ViewTheDetailedDescription
                }
                EResult {
                    styleType: EStyle.Info
                    title: ELocale.texts.ActionResult
                    width: Math.min(300, parent.width)
                    subTitle: ELocale.texts.ViewTheDetailedDescription
                }
            }
        }
    }
    ExampleSection {
        componentName: "EResult"

        ExampleCase {
            objectName: "showcaseEResult2"
            title: ELocale.texts.CustomResultIcon
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EResult {
                    title: ELocale.texts.Ready2
                    width: Math.min(480, parent.width)
                    subTitle: ELocale.texts.CustomIconAndDescription
                    iconDelegate: Component {
                        EIcon {
                            iconSize: 56
                            color: "#67c23a"
                            iconSource: EIcons.PALETTE
                        }
                    }
                }
            `)

            EResult {
                title: ELocale.texts.Ready2
                width: Math.min(480, parent.width)
                subTitle: ELocale.texts.CustomIconAndDescription
                iconDelegate: Component {
                    EIcon {
                        iconSize: 56
                        color: "#67c23a"
                        iconSource: EIcons.PALETTE
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EQRCode"

        ExampleCase {
            title: ELocale.texts.QRSizes
            objectName: "showcaseEQRCode0"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    EQRCode {
                        width: 100
                        height: 100
                        text: "https://example.com/eui"
                    }
                    EQRCode {
                        width: 140
                        height: 140
                        text: "https://example.com/eui"
                    }
                    EQRCode {
                        width: 180
                        height: 180
                        text: "https://example.com/eui"
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                EQRCode {
                    width: 100
                    height: 100
                    text: "https://example.com/eui"
                }
                EQRCode {
                    width: 140
                    height: 140
                    text: "https://example.com/eui"
                }
                EQRCode {
                    width: 180
                    height: 180
                    text: "https://example.com/eui"
                }
            }
        }
    }
    ExampleSection {
        componentName: "EQRCode"

        ExampleCase {
            objectName: "showcaseEQRCode1"
            title: ELocale.texts.QRColorsAndQuietZone
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EQRCode {
                    width: 180
                    height: 180
                    quietZone: 6
                    color: "#173958"
                    backgroundColor: "#E7F0FF"
                    text: ELocale.texts.EuiDesignSystem
                }
            `)

            EQRCode {
                width: 180
                height: 180
                quietZone: 6
                color: "#173958"
                backgroundColor: "#E7F0FF"
                text: ELocale.texts.EuiDesignSystem
            }
        }
    }
    ExampleSection {
        componentName: "EQRCode"

        ExampleCase {
            objectName: "showcaseEQRCode2"
            title: ELocale.texts.ErrorCorrection
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    EQRCode {
                        width: 140
                        height: 140
                        errorCorrection: 0
                        text: "EUI / Qt Quick"
                    }
                    EQRCode {
                        width: 140
                        height: 140
                        errorCorrection: 1
                        text: "EUI / Qt Quick"
                    }
                    EQRCode {
                        width: 140
                        height: 140
                        errorCorrection: 2
                        text: "EUI / Qt Quick"
                    }
                    EQRCode {
                        width: 140
                        height: 140
                        errorCorrection: 3
                        text: "EUI / Qt Quick"
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                EQRCode {
                    width: 140
                    height: 140
                    errorCorrection: 0
                    text: "EUI / Qt Quick"
                }
                EQRCode {
                    width: 140
                    height: 140
                    errorCorrection: 1
                    text: "EUI / Qt Quick"
                }
                EQRCode {
                    width: 140
                    height: 140
                    errorCorrection: 2
                    text: "EUI / Qt Quick"
                }
                EQRCode {
                    width: 140
                    height: 140
                    errorCorrection: 3
                    text: "EUI / Qt Quick"
                }
            }
        }
    }
    ExampleSection {
        componentName: "EQRCode"

        ExampleCase {
            objectName: "showcaseEQRCode3"
            title: ELocale.texts.LiveQRContent
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EInput {
                        id: content

                        text: "EUI"
                        width: Math.min(480, parent.width)
                    }
                    EQRCode {
                        width: 180
                        height: 180
                        text: content.text
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EInput {
                    id: content

                    text: "EUI"
                    width: Math.min(480, parent.width)
                }
                EQRCode {
                    width: 180
                    height: 180
                    text: content.text
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECalendar"

        ExampleCase {
            objectName: "showcaseECalendar0"
            title: ELocale.texts.CalendarRange
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ECalendar {
                    width: Math.min(640, parent.width)
                    range: [new Date(2026, 9, 1), new Date(2026, 9, 31)]
                }
            `)

            ECalendar {
                width: Math.min(640, parent.width)
                range: [new Date(2026, 9, 1), new Date(2026, 9, 31)]
            }
        }
    }
    ExampleSection {
        componentName: "ECalendar"

        ExampleCase {
            objectName: "showcaseECalendar1"
            title: ELocale.texts.SelectController
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ECalendar {
                    controllerType: "select"
                    width: Math.min(640, parent.width)
                }
            `)

            ECalendar {
                controllerType: "select"
                width: Math.min(640, parent.width)
            }
        }
    }
    ExampleSection {
        componentName: "ECalendar"

        ExampleCase {
            objectName: "showcaseECalendar2"
            title: ELocale.texts.CalendarCellContent
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ECalendar {
                    width: Math.min(640, parent.width)
                    dateCellDelegate: Component {
                        EText {
                            text: parent.date.getDate()
                            horizontalAlignment: Text.AlignHCenter
                            color: parent.isSelected ? "#67c23a" : EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                        }
                    }
                }
            `)

            ECalendar {
                width: Math.min(640, parent.width)
                dateCellDelegate: Component {
                    EText {
                        text: parent.date.getDate()
                        horizontalAlignment: Text.AlignHCenter
                        color: parent.isSelected ? "#67c23a" : EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECarousel"

        ExampleCase {
            objectName: "showcaseECarousel0"
            title: ELocale.texts.CardCarousel
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ECarousel {
                    height: 220
                    type: "card"
                    autoplay: false
                    indicatorPosition: "outside"
                    width: Math.min(480, parent.width)
                    model: [{title: ELocale.texts.Design, source: "qrc:/example/images/gallery/lake.jpg"},
                        {title: ELocale.texts.Engineering, source: "qrc:/example/images/gallery/neon-red.jpg"},
                        {title: ELocale.texts.Publish, source: "qrc:/example/images/gallery/neon-purple.jpg"}]
                    delegate: Component {
                        EClip {
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
                    }
                }
            `)

            ECarousel {
                height: 220
                type: "card"
                autoplay: false
                indicatorPosition: "outside"
                width: Math.min(480, parent.width)
                model: [{title: ELocale.texts.Design, source: "qrc:/example/images/gallery/lake.jpg"},
                    {title: ELocale.texts.Engineering, source: "qrc:/example/images/gallery/neon-red.jpg"},
                    {title: ELocale.texts.Publish, source: "qrc:/example/images/gallery/neon-purple.jpg"}]
                delegate: Component {
                    EClip {
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
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECarousel"

        ExampleCase {
            objectName: "showcaseECarousel1"
            title: ELocale.texts.VerticalCarousel
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ECarousel {
                    height: 220
                    loop: false
                    autoplay: false
                    initialIndex: 1
                    direction: "vertical"
                    width: Math.min(480, parent.width)
                    model: [{title: ELocale.texts.FirstSlide, source: "qrc:/example/images/gallery/lake.jpg"},
                        {title: ELocale.texts.SecondSlide, source: "qrc:/example/images/gallery/neon-red.jpg"},
                        {title: ELocale.texts.ThirdSlide, source: "qrc:/example/images/gallery/neon-purple.jpg"}]
                    delegate: Component {
                        EClip {
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
                    }
                }
            `)

            ECarousel {
                height: 220
                loop: false
                autoplay: false
                initialIndex: 1
                direction: "vertical"
                width: Math.min(480, parent.width)
                model: [{title: ELocale.texts.FirstSlide, source: "qrc:/example/images/gallery/lake.jpg"},
                    {title: ELocale.texts.SecondSlide, source: "qrc:/example/images/gallery/neon-red.jpg"},
                    {title: ELocale.texts.ThirdSlide, source: "qrc:/example/images/gallery/neon-purple.jpg"}]
                delegate: Component {
                    EClip {
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
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECarousel"

        ExampleCase {
            objectName: "showcaseECarousel2"
            title: ELocale.texts.CarouselNavigation
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ECarousel {
                        id: carousel

                        height: 220
                        autoplay: false
                        width: Math.min(480, parent.width)
                        model: [{title: ELocale.texts.Design, source: "qrc:/example/images/gallery/lake.jpg"},
                            {title: ELocale.texts.Engineering, source: "qrc:/example/images/gallery/neon-red.jpg"},
                            {title: ELocale.texts.Publish, source: "qrc:/example/images/gallery/neon-purple.jpg"}]
                        delegate: Component {
                            EClip {
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
                        }
                    }
                    Flow {
                        spacing: 16
                        width: parent.width

                        EButton {
                            text: ELocale.texts.PreviousItem

                            onClicked: carousel.previous()
                        }
                        EButton {
                            text: ELocale.texts.NextItem

                            onClicked: carousel.next()
                        }
                        EText {
                            text: ELocale.texts.CurrentItem + (carousel.currentIndex + 1)
                        }
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                ECarousel {
                    id: carousel

                    height: 220
                    autoplay: false
                    width: Math.min(480, parent.width)
                    model: [{title: ELocale.texts.Design, source: "qrc:/example/images/gallery/lake.jpg"},
                        {title: ELocale.texts.Engineering, source: "qrc:/example/images/gallery/neon-red.jpg"},
                        {title: ELocale.texts.Publish, source: "qrc:/example/images/gallery/neon-purple.jpg"}]
                    delegate: Component {
                        EClip {
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
                    }
                }
                Flow {
                    spacing: 16
                    width: parent.width

                    EButton {
                        text: ELocale.texts.PreviousItem

                        onClicked: carousel.previous()
                    }
                    EButton {
                        text: ELocale.texts.NextItem

                        onClicked: carousel.next()
                    }
                    EText {
                        text: ELocale.texts.CurrentItem + (carousel.currentIndex + 1)
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETimeline"

        ExampleCase {
            objectName: "showcaseETimeline0"
            title: ELocale.texts.AlternatingTimeline
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ETimeline {
                    mode: "alternate"
                    width: Math.min(480, parent.width)
                    model: [{timestamp: "09:00", content: ELocale.texts.CreateProject, styleType: EStyle.Primary}, {timestamp: "10:30", content: ELocale.texts.DesignCompleted, styleType: EStyle.Success}, {timestamp: "12:00", content: ELocale.texts.AwaitingReview, styleType: EStyle.Warning}]
                }
            `)

            ETimeline {
                mode: "alternate"
                width: Math.min(480, parent.width)
                model: [{timestamp: "09:00", content: ELocale.texts.CreateProject, styleType: EStyle.Primary}, {timestamp: "10:30", content: ELocale.texts.DesignCompleted, styleType: EStyle.Success}, {timestamp: "12:00", content: ELocale.texts.AwaitingReview, styleType: EStyle.Warning}]
            }
        }
    }
    ExampleSection {
        componentName: "ETimeline"

        ExampleCase {
            objectName: "showcaseETimeline1"
            title: ELocale.texts.ReverseTimeline
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ETimeline {
                    reverse: true
                    width: Math.min(480, parent.width)
                    model: [{content: ELocale.texts.PendingReview, timestamp: "12:00", hollow: true, size: "large", styleType: EStyle.Warning}, {content: ELocale.texts.Saved2, timestamp: "11:00", icon: EIcons.CHECK, styleType: EStyle.Success}]
                }
            `)

            ETimeline {
                reverse: true
                width: Math.min(480, parent.width)
                model: [{content: ELocale.texts.PendingReview, timestamp: "12:00", hollow: true, size: "large", styleType: EStyle.Warning}, {content: ELocale.texts.Saved2, timestamp: "11:00", icon: EIcons.CHECK, styleType: EStyle.Success}]
            }
        }
    }
    ExampleSection {
        componentName: "ETimeline"

        ExampleCase {
            objectName: "showcaseETimeline2"
            title: ELocale.texts.TimelineDots
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ETimeline {
                    width: Math.min(480, parent.width)
                    dotDelegate: Component {
                        EIcon {
                            iconSize: 20
                            color: "#67c23a"
                            iconSource: EIcons.CHECK
                        }
                    }
                    model: [{timestamp: "09:00", content: ELocale.texts.CreateProject, styleType: EStyle.Primary}, {timestamp: "10:30", content: ELocale.texts.DesignCompleted, styleType: EStyle.Success}, {timestamp: "12:00", content: ELocale.texts.AwaitingReview, styleType: EStyle.Warning}]
                }
            `)

            ETimeline {
                width: Math.min(480, parent.width)
                dotDelegate: Component {
                    EIcon {
                        iconSize: 20
                        color: "#67c23a"
                        iconSource: EIcons.CHECK
                    }
                }
                model: [{timestamp: "09:00", content: ELocale.texts.CreateProject, styleType: EStyle.Primary}, {timestamp: "10:30", content: ELocale.texts.DesignCompleted, styleType: EStyle.Success}, {timestamp: "12:00", content: ELocale.texts.AwaitingReview, styleType: EStyle.Warning}]
            }
        }
    }
    ExampleSection {
        componentName: "ECollapse"

        ExampleCase {
            objectName: "showcaseECollapse0"
            title: ELocale.texts.AccordionCollapse
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ECollapse {
                    accordion: true
                    activeNames: ["design"]
                    width: Math.min(480, parent.width)
                    model: [{name: "design", title: ELocale.texts.DesignGuidelines, content: ELocale.texts.FontsColorsAndSpacing}, {name: "dev", title: ELocale.texts.DevelopmentGuidelines, content: ELocale.texts.QMLAndC}, {name: "locked", title: ELocale.texts.Archived, disabled: true}]
                }
            `)

            ECollapse {
                accordion: true
                activeNames: ["design"]
                width: Math.min(480, parent.width)
                model: [{name: "design", title: ELocale.texts.DesignGuidelines, content: ELocale.texts.FontsColorsAndSpacing}, {name: "dev", title: ELocale.texts.DevelopmentGuidelines, content: ELocale.texts.QMLAndC}, {name: "locked", title: ELocale.texts.Archived, disabled: true}]
            }
        }
    }
    ExampleSection {
        componentName: "ECollapse"

        ExampleCase {
            objectName: "showcaseECollapse1"
            title: ELocale.texts.MultipleExpandedPanels
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ECollapse {
                    activeNames: ["a", "b"]
                    expandIconPosition: "left"
                    width: Math.min(480, parent.width)
                    model: [{name: "a", title: ELocale.texts.BasicInformation, content: ELocale.texts.ProjectNameAndDescription}, {name: "b", title: ELocale.texts.AdvancedSettings, content: ELocale.texts.ComponentThemeAndConfiguration}]
                }
            `)

            ECollapse {
                activeNames: ["a", "b"]
                expandIconPosition: "left"
                width: Math.min(480, parent.width)
                model: [{name: "a", title: ELocale.texts.BasicInformation, content: ELocale.texts.ProjectNameAndDescription}, {name: "b", title: ELocale.texts.AdvancedSettings, content: ELocale.texts.ComponentThemeAndConfiguration}]
            }
        }
    }
    ExampleSection {
        componentName: "ECollapse"

        ExampleCase {
            objectName: "showcaseECollapse2"
            title: ELocale.texts.CollapseGuard
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ESwitch {
                        id: allow

                        checked: true
                        text: ELocale.texts.AllowExpansion
                    }
                    ECollapse {
                        width: Math.min(480, parent.width)
                        beforeCollapse: function() { return allow.checked }
                        model: [{name: "a", title: ELocale.texts.AdvancedSettings, content: ELocale.texts.CheckPermissionsBeforeExpanding}]
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                ESwitch {
                    id: allow

                    checked: true
                    text: ELocale.texts.AllowExpansion
                }
                ECollapse {
                    width: Math.min(480, parent.width)
                    beforeCollapse: function() { return allow.checked }
                    model: [{name: "a", title: ELocale.texts.AdvancedSettings, content: ELocale.texts.CheckPermissionsBeforeExpanding}]
                }
            }
        }
    }
    ExampleSection {
        componentName: "EStatistic"

        ExampleCase {
            objectName: "showcaseEStatistic0"
            title: ELocale.texts.CurrencyStatistic
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EStatistic {
                    prefix: "$"
                    precision: 2
                    value: 1234567.89
                    groupSeparator: ","
                    title: ELocale.texts.TotalAmount
                }
            `)

            EStatistic {
                prefix: "$"
                precision: 2
                value: 1234567.89
                groupSeparator: ","
                title: ELocale.texts.TotalAmount
            }
        }
    }
    ExampleSection {
        componentName: "EStatistic"

        ExampleCase {
            objectName: "showcaseEStatistic1"
            title: ELocale.texts.FormattedStatistic
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EStatistic {
                    value: 2560000
                    title: ELocale.texts.TotalVisits
                    formatter: function(value) { return (value / 1000000).toFixed(2) + " M" }
                }
            `)

            EStatistic {
                value: 2560000
                title: ELocale.texts.TotalVisits
                formatter: function(value) { return (value / 1000000).toFixed(2) + " M" }
            }
        }
    }
    ExampleSection {
        componentName: "EStatistic"

        ExampleCase {
            objectName: "showcaseEStatistic2"
            title: ELocale.texts.StatisticSuffix
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EStatistic {
                    suffix: "%"
                    value: 98.6
                    precision: 1
                    title: ELocale.texts.CompletionRate
                    prefixDelegate: Component {
                        EIcon {
                            iconSize: 24
                            color: "#67c23a"
                            iconSource: EIcons.CHECK
                        }
                    }
                }
            `)

            EStatistic {
                suffix: "%"
                value: 98.6
                precision: 1
                title: ELocale.texts.CompletionRate
                prefixDelegate: Component {
                    EIcon {
                        iconSize: 24
                        color: "#67c23a"
                        iconSource: EIcons.CHECK
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECountdown"

        ExampleCase {
            objectName: "showcaseECountdown0"
            title: ELocale.texts.MinuteCountdown
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ECountdown {
                    format: "mm:ss"
                    value: Date.now() + 120000
                    title: ELocale.texts.Countdown
                }
            `)

            ECountdown {
                format: "mm:ss"
                value: Date.now() + 120000
                title: ELocale.texts.Countdown
            }
        }
    }
    ExampleSection {
        componentName: "ECountdown"

        ExampleCase {
            objectName: "showcaseECountdown1"
            title: ELocale.texts.CountdownCompletion
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ECountdown {
                        id: timer

                        format: "ss"
                        value: Date.now() + 15000
                        title: ELocale.texts.WaitingTime

                        onFinish: result.text = ELocale.texts.Expired
                    }
                    EText {
                        id: result

                        text: ELocale.texts.WaitingForTheCountdownToFinish
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                ECountdown {
                    id: timer

                    format: "ss"
                    value: Date.now() + 15000
                    title: ELocale.texts.WaitingTime

                    onFinish: result.text = ELocale.texts.Expired
                }
                EText {
                    id: result

                    text: ELocale.texts.WaitingForTheCountdownToFinish
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECountdown"

        ExampleCase {
            objectName: "showcaseECountdown2"
            title: ELocale.texts.RestartCountdown
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ECountdown {
                        id: timer

                        format: "mm:ss"
                        value: Date.now() + 60000
                    }
                    EButton {
                        text: ELocale.texts.RestartCountdown2

                        onClicked: timer.value = Date.now() + 60000
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                ECountdown {
                    id: timer

                    format: "mm:ss"
                    value: Date.now() + 60000
                }
                EButton {
                    text: ELocale.texts.RestartCountdown2

                    onClicked: timer.value = Date.now() + 60000
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECountdown"

        ExampleCase {
            objectName: "showcaseECountdown3"
            title: ELocale.texts.DayCountdown
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ECountdown {
                    value: Date.now() + 93600000
                    format: ELocale.texts.DDDaysHHMmSs
                    title: ELocale.texts.TimeUntilRelease
                }
            `)

            ECountdown {
                value: Date.now() + 93600000
                format: ELocale.texts.DDDaysHHMmSs
                title: ELocale.texts.TimeUntilRelease
            }
        }
    }
    ExampleSection {
        componentName: "ESegmented"

        ExampleCase {
            objectName: "showcaseESegmented0"
            title: ELocale.texts.BlockSegmentedControl
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ESegmented {
                    block: true
                    width: Math.min(480, parent.width)
                    model: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                }
            `)

            ESegmented {
                block: true
                width: Math.min(480, parent.width)
                model: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
            }
        }
    }
    ExampleSection {
        componentName: "ESegmented"

        ExampleCase {
            objectName: "showcaseESegmented1"
            title: ELocale.texts.VerticalSegmentedControl
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ESegmented {
                    currentIndex: 1
                    direction: "vertical"
                    model: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                }
            `)

            ESegmented {
                currentIndex: 1
                direction: "vertical"
                model: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
            }
        }
    }
    ExampleSection {
        componentName: "ESegmented"

        ExampleCase {
            objectName: "showcaseESegmented2"
            title: ELocale.texts.SegmentSizes
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ESegmented {
                        size: EStyle.Small
                        model: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                    }
                    ESegmented {
                        size: EStyle.Medium
                        model: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                    }
                    ESegmented {
                        size: EStyle.Large
                        model: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                ESegmented {
                    size: EStyle.Small
                    model: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                }
                ESegmented {
                    size: EStyle.Medium
                    model: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                }
                ESegmented {
                    size: EStyle.Large
                    model: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                }
            }
        }
    }
    ExampleSection {
        componentName: "EStatusView"

        ExampleCase {
            title: ELocale.texts.NormalState
            objectName: "showcaseEStatusView0"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EStatusView {
                    height: 220
                    state: "normal"
                    width: Math.min(480, parent.width)
                    errorTitle: ELocale.texts.UnableToLoadRightNow
                    errorText: ELocale.texts.CheckTheDataAndTryAgain

                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.TheProjectContentIsReady
                    }
                }
            `)

            EStatusView {
                height: 220
                state: "normal"
                width: Math.min(480, parent.width)
                errorTitle: ELocale.texts.UnableToLoadRightNow
                errorText: ELocale.texts.CheckTheDataAndTryAgain

                EText {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: ELocale.texts.TheProjectContentIsReady
                }
            }
        }
    }
    ExampleSection {
        componentName: "EStatusView"

        ExampleCase {
            title: ELocale.texts.LoadingState
            objectName: "showcaseEStatusView1"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EStatusView {
                    height: 220
                    state: "loading"
                    width: Math.min(480, parent.width)
                    errorTitle: ELocale.texts.UnableToLoadRightNow
                    errorText: ELocale.texts.CheckTheDataAndTryAgain

                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.TheProjectContentIsReady
                    }
                }
            `)

            EStatusView {
                height: 220
                state: "loading"
                width: Math.min(480, parent.width)
                errorTitle: ELocale.texts.UnableToLoadRightNow
                errorText: ELocale.texts.CheckTheDataAndTryAgain

                EText {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: ELocale.texts.TheProjectContentIsReady
                }
            }
        }
    }
    ExampleSection {
        componentName: "EStatusView"

        ExampleCase {
            title: ELocale.texts.EmptyState
            objectName: "showcaseEStatusView2"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EStatusView {
                    height: 220
                    state: "empty"
                    width: Math.min(480, parent.width)
                    errorTitle: ELocale.texts.UnableToLoadRightNow
                    errorText: ELocale.texts.CheckTheDataAndTryAgain

                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.TheProjectContentIsReady
                    }
                }
            `)

            EStatusView {
                height: 220
                state: "empty"
                width: Math.min(480, parent.width)
                errorTitle: ELocale.texts.UnableToLoadRightNow
                errorText: ELocale.texts.CheckTheDataAndTryAgain

                EText {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: ELocale.texts.TheProjectContentIsReady
                }
            }
        }
    }
    ExampleSection {
        componentName: "EStatusView"

        ExampleCase {
            objectName: "showcaseEStatusView3"
            title: ELocale.texts.ErrorAndRetry
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EStatusView {
                    height: 220
                    state: "error"
                    width: Math.min(480, parent.width)
                    errorTitle: ELocale.texts.UnableToLoadRightNow
                    errorText: ELocale.texts.CheckTheDataAndTryAgain

                    onRetry: state = "normal"

                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.TheProjectContentIsReady
                    }
                }
            `)

            EStatusView {
                height: 220
                state: "error"
                width: Math.min(480, parent.width)
                errorTitle: ELocale.texts.UnableToLoadRightNow
                errorText: ELocale.texts.CheckTheDataAndTryAgain

                onRetry: state = "normal"

                EText {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: ELocale.texts.TheProjectContentIsReady
                }
            }
        }
    }
    ExampleSection {
        componentName: "EImageViewer"

        ExampleCase {
            objectName: "showcaseEImageViewer0"
            title: ELocale.texts.SingleImageViewer
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        text: ELocale.texts.ViewImages

                        onClicked: viewer.openPreview(viewer.initialIndex)
                    }
                    EImageViewer {
                        id: viewer

                        visible: false
                        urlList: ["qrc:/example/images/gallery/lake.jpg"]
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EButton {
                    text: ELocale.texts.ViewImages

                    onClicked: viewer.openPreview(viewer.initialIndex)
                }
                EImageViewer {
                    id: viewer

                    visible: false
                    urlList: ["qrc:/example/images/gallery/lake.jpg"]
                }
            }
        }
    }
    ExampleSection {
        componentName: "EImageViewer"

        ExampleCase {
            objectName: "showcaseEImageViewer1"
            title: ELocale.texts.GalleryStartIndex
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        text: ELocale.texts.StartFromTheSecondImage

                        onClicked: viewer.openPreview(viewer.initialIndex)
                    }
                    EImageViewer {
                        id: viewer

                        visible: false
                        infinite: false
                        initialIndex: 1
                        urlList: ["qrc:/example/images/gallery/lake.jpg",
                            "qrc:/example/images/gallery/neon-red.jpg",
                            "qrc:/example/images/gallery/neon-purple.jpg",
                            "qrc:/example/images/gallery/tree.jpg",
                            "qrc:/example/images/gallery/ocean.jpg"]
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EButton {
                    text: ELocale.texts.StartFromTheSecondImage

                    onClicked: viewer.openPreview(viewer.initialIndex)
                }
                EImageViewer {
                    id: viewer

                    visible: false
                    infinite: false
                    initialIndex: 1
                    urlList: ["qrc:/example/images/gallery/lake.jpg",
                        "qrc:/example/images/gallery/neon-red.jpg",
                        "qrc:/example/images/gallery/neon-purple.jpg",
                        "qrc:/example/images/gallery/tree.jpg",
                        "qrc:/example/images/gallery/ocean.jpg"]
                }
            }
        }
    }
    ExampleSection {
        componentName: "EImageViewer"

        ExampleCase {
            title: ELocale.texts.ViewerOptions
            objectName: "showcaseEImageViewer2"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        text: ELocale.texts.ViewPreview

                        onClicked: viewer.openPreview(viewer.initialIndex)
                    }
                    EImageViewer {
                        id: viewer

                        maxScale: 2
                        minScale: 0.5
                        visible: false
                        showProgress: false
                        hideOnClickModal: true
                        urlList: ["qrc:/example/images/gallery/lake.jpg"]
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EButton {
                    text: ELocale.texts.ViewPreview

                    onClicked: viewer.openPreview(viewer.initialIndex)
                }
                EImageViewer {
                    id: viewer

                    maxScale: 2
                    minScale: 0.5
                    visible: false
                    showProgress: false
                    hideOnClickModal: true
                    urlList: ["qrc:/example/images/gallery/lake.jpg"]
                }
            }
        }
    }
    ExampleSection {
        componentName: "EImageViewer"

        ExampleCase {
            objectName: "showcaseEImageViewer3"
            title: ELocale.texts.ViewerZoomSteps
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        text: ELocale.texts.ViewImages

                        onClicked: viewer.openPreview(viewer.initialIndex)
                    }
                    EImageViewer {
                        id: viewer

                        zoomRate: 1.5
                        visible: false
                        closeOnPressEscape: true
                        urlList: ["qrc:/example/images/gallery/lake.jpg"]
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EButton {
                    text: ELocale.texts.ViewImages

                    onClicked: viewer.openPreview(viewer.initialIndex)
                }
                EImageViewer {
                    id: viewer

                    zoomRate: 1.5
                    visible: false
                    closeOnPressEscape: true
                    urlList: ["qrc:/example/images/gallery/lake.jpg"]
                }
            }
        }
    }
    ExampleSection {
        componentName: "EDescriptions"

        ExampleCase {
            objectName: "showcaseEDescriptions0"
            title: ELocale.texts.VerticalDescriptions
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EDescriptions {
                    columns: 2
                    width: parent.width
                    direction: "vertical"
                    title: ELocale.texts.ProjectDetails2
                    model: [{label: ELocale.texts.Name2, value: "EUI"}, {label: ELocale.texts.Version, value: "1.0"}, {label: ELocale.texts.Platform, value: "Windows / macOS", span: 2}]
                }
            `)

            EDescriptions {
                columns: 2
                width: parent.width
                direction: "vertical"
                title: ELocale.texts.ProjectDetails2
                model: [{label: ELocale.texts.Name2, value: "EUI"}, {label: ELocale.texts.Version, value: "1.0"}, {label: ELocale.texts.Platform, value: "Windows / macOS", span: 2}]
            }
        }
    }
    ExampleSection {
        componentName: "EDescriptions"

        ExampleCase {
            objectName: "showcaseEDescriptions1"
            title: ELocale.texts.CompactDescriptions
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EDescriptions {
                    columns: 1
                    border: false
                    labelWidth: 80
                    size: EStyle.Small
                    width: parent.width
                    model: [{label: ELocale.texts.Name2, value: "EUI"}, {label: ELocale.texts.Version, value: "1.0"}, {label: ELocale.texts.Platform, value: "Windows / macOS", span: 2}]
                }
            `)

            EDescriptions {
                columns: 1
                border: false
                labelWidth: 80
                size: EStyle.Small
                width: parent.width
                model: [{label: ELocale.texts.Name2, value: "EUI"}, {label: ELocale.texts.Version, value: "1.0"}, {label: ELocale.texts.Platform, value: "Windows / macOS", span: 2}]
            }
        }
    }
    ExampleSection {
        componentName: "EDescriptions"

        ExampleCase {
            objectName: "showcaseEDescriptions2"
            title: ELocale.texts.DescriptionSpans
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EDescriptions {
                    columns: 2
                    width: parent.width
                    extra: ELocale.texts.Published
                    title: ELocale.texts.ProjectDetails2
                    model: [{label: ELocale.texts.Project, value: "EUI", rowspan: 2}, {label: ELocale.texts.Version, value: "1.0"}, {label: ELocale.texts.Platform, value: "Qt Quick"}]
                }
            `)

            EDescriptions {
                columns: 2
                width: parent.width
                extra: ELocale.texts.Published
                title: ELocale.texts.ProjectDetails2
                model: [{label: ELocale.texts.Project, value: "EUI", rowspan: 2}, {label: ELocale.texts.Version, value: "1.0"}, {label: ELocale.texts.Platform, value: "Qt Quick"}]
            }
        }
    }
    ExampleSection {
        componentName: "EInfiniteScroll"

        ExampleCase {
            title: ELocale.texts.LoadOnScroll
            objectName: "showcaseEInfiniteScroll0"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EInfiniteScroll {
                    height: 200
                    distance: 32
                    immediate: false
                    width: Math.min(480, parent.width)
                    model: [ELocale.texts.ProjectNumber.arg(1), ELocale.texts.ProjectNumber.arg(2), ELocale.texts.ProjectNumber.arg(3), ELocale.texts.ProjectNumber.arg(4), ELocale.texts.ProjectNumber.arg(5), ELocale.texts.ProjectNumber.arg(6)]

                    onLoadMore: { model = model.concat([ELocale.texts.NewProject2 + (count + 1)])
                        finishLoad(count >= 12) }
                }
            `)

            EInfiniteScroll {
                height: 200
                distance: 32
                immediate: false
                width: Math.min(480, parent.width)
                model: [ELocale.texts.ProjectNumber.arg(1), ELocale.texts.ProjectNumber.arg(2), ELocale.texts.ProjectNumber.arg(3), ELocale.texts.ProjectNumber.arg(4), ELocale.texts.ProjectNumber.arg(5), ELocale.texts.ProjectNumber.arg(6)]

                onLoadMore: { model = model.concat([ELocale.texts.NewProject2 + (count + 1)])
                    finishLoad(count >= 12) }
            }
        }
    }
    ExampleSection {
        componentName: "EInfiniteScroll"

        ExampleCase {
            title: ELocale.texts.FinishedList
            objectName: "showcaseEInfiniteScroll1"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EInfiniteScroll {
                    height: 200
                    finished: true
                    width: Math.min(480, parent.width)
                    model: [ELocale.texts.ProjectNumber.arg(1), ELocale.texts.ProjectNumber.arg(2), ELocale.texts.ProjectNumber.arg(3)]
                }
            `)

            EInfiniteScroll {
                height: 200
                finished: true
                width: Math.min(480, parent.width)
                model: [ELocale.texts.ProjectNumber.arg(1), ELocale.texts.ProjectNumber.arg(2), ELocale.texts.ProjectNumber.arg(3)]
            }
        }
    }
    ExampleSection {
        componentName: "EInfiniteScroll"

        ExampleCase {
            title: ELocale.texts.LoadingList
            objectName: "showcaseEInfiniteScroll2"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EInfiniteScroll {
                    delay: 500
                    height: 180
                    distance: 64
                    loading: true
                    width: Math.min(480, parent.width)
                    model: [ELocale.texts.ProjectNumber.arg(1), ELocale.texts.ProjectNumber.arg(2), ELocale.texts.ProjectNumber.arg(3), ELocale.texts.ProjectNumber.arg(4)]
                }
            `)

            EInfiniteScroll {
                delay: 500
                height: 180
                distance: 64
                loading: true
                width: Math.min(480, parent.width)
                model: [ELocale.texts.ProjectNumber.arg(1), ELocale.texts.ProjectNumber.arg(2), ELocale.texts.ProjectNumber.arg(3), ELocale.texts.ProjectNumber.arg(4)]
            }
        }
    }
}

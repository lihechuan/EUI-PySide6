import EUI 1.0
import QtQuick 2.15

ExamplePage {
    title: ELocale.texts.BasicComponents
    description: ELocale.texts.InteractiveExamplesOfEachComponentExpandA

    ExampleSection {
        componentName: "ETextArea"

        ExampleCard {
            title: ELocale.texts.MultilineInputWordCountAndAutosize
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ETextArea {
                    maximumLength: 120
                    resize: "vertical"
                    showWordLimit: true
                    width: Math.min(560, parent.width)
                    autosize: ({minRows: 3, maxRows: 6})
                    placeholderText: ELocale.texts.TypeMultipleLinesDragTheLowerRightCorner
                }
            `)

            ETextArea {
                maximumLength: 120
                resize: "vertical"
                showWordLimit: true
                width: Math.min(560, parent.width)
                autosize: ({minRows: 3, maxRows: 6})
                placeholderText: ELocale.texts.TypeMultipleLinesDragTheLowerRightCorner2
            }
        }
    }
    ExampleSection {
        componentName: "EButton"

        ExampleCard {
            title: ELocale.texts.ButtonStatesAndCustomContent
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 12
                    width: parent.width

                    EButton {
                        styleType: EStyle.Primary
                        text: ELocale.texts.Primary
                    }
                    EButton {
                        plain: true
                        styleType: EStyle.Success
                        text: ELocale.texts.Plain
                    }
                    EButton {
                        dashed: true
                        text: ELocale.texts.DemoDashedButton
                    }
                    EButton {
                        bg: true
                        textButton: true
                        text: ELocale.texts.DemoBackgroundButton
                    }
                    EButton {
                        link: true
                        styleType: EStyle.Primary
                        text: ELocale.texts.DemoLinkButton
                    }
                    EButton {
                        leftIcon: true
                        autoInsertSpace: true
                        text: ELocale.texts.Save
                        iconComponent: Component {
                            EIcon {
                                iconSize: 16
                                iconSource: EIcons.CHECK
                            }
                        }
                    }
                }
            `)

            Flow {
                spacing: 12
                width: parent.width

                EButton {
                    styleType: EStyle.Primary
                    text: ELocale.texts.Primary
                }
                EButton {
                    plain: true
                    styleType: EStyle.Success
                    text: ELocale.texts.Plain
                }
                EButton {
                    dashed: true
                    text: ELocale.texts.DemoDashedButton
                }
                EButton {
                    bg: true
                    textButton: true
                    text: ELocale.texts.DemoBackgroundButton
                }
                EButton {
                    link: true
                    styleType: EStyle.Primary
                    text: ELocale.texts.DemoLinkButton
                }
                EButton {
                    leftIcon: true
                    autoInsertSpace: true
                    text: ELocale.texts.Save
                    iconComponent: Component {
                        EIcon {
                            iconSize: 16
                            iconSource: EIcons.CHECK
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EButton"

        ExampleCard {
            introduction: ELocale.texts.ButtonsForCommonActions

            ExampleCase {
                title: ELocale.texts.BasicUsage
                code: exampleData.samples.BasicExamplesSample0

                Flow {
                    spacing: 12
                    width: parent.width

                    EButton {
                        text: ELocale.texts.Default

                        onClicked: buttonStatus.text = text
                    }
                    EButton {
                        styleType: EStyle.Primary
                        text: ELocale.texts.Primary

                        onClicked: buttonStatus.text = text
                    }
                    EButton {
                        plain: true
                        styleType: EStyle.Primary
                        text: ELocale.texts.Plain

                        onClicked: buttonStatus.text = text
                    }
                    EButton {
                        round: true
                        styleType: EStyle.Success
                        text: ELocale.texts.Round

                        onClicked: buttonStatus.text = text
                    }
                }
                EText {
                    id: buttonStatus

                    font.pixelSize: 14
                    text: ELocale.texts.WaitingForAnAction
                    color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                }
            }
            ExampleCase {
                title: ELocale.texts.DisabledState
                code: exampleData.samples.BasicExamplesSample1

                ESwitch {
                    id: disableButtons

                    text: ELocale.texts.Disabled
                }
                Flow {
                    spacing: 12
                    width: parent.width
                    enabled: !disableButtons.checked

                    EButton {
                        text: ELocale.texts.Default
                    }
                    EButton {
                        styleType: EStyle.Primary
                        text: ELocale.texts.Primary
                    }
                }
            }
            ExampleCase {
                title: ELocale.texts.IconButtons
                code: exampleData.samples.BasicExamplesSample3
                description: ELocale.texts.UseIconsourceToAddAnIconCombine

                Flow {
                    spacing: 12
                    width: parent.width

                    EButton {
                        iconSource: EIcons.PENCIL
                        styleType: EStyle.Primary
                    }
                    EButton {
                        styleType: EStyle.Primary
                        iconSource: EIcons.ARROW_UP_RIGHT_FROM_SQUARE
                    }
                    EButton {
                        iconSource: EIcons.DELETE
                        styleType: EStyle.Primary
                    }
                    EButton {
                        styleType: EStyle.Primary
                        text: ELocale.texts.Search
                        iconSource: EIcons.MAGNIFIER
                    }
                    EButton {
                        leftIcon: true
                        styleType: EStyle.Primary
                        text: ELocale.texts.Upload
                        iconSource: EIcons.ARROW_UP_FROM_LINE
                    }
                }
            }
            ExampleCase {
                title: ELocale.texts.LoadingButtons
                code: exampleData.samples.BasicExamplesSample4

                ESwitch {
                    id: loadingButtons

                    text: ELocale.texts.Loading
                }
                Flow {
                    spacing: 12
                    width: parent.width

                    EButton {
                        styleType: EStyle.Primary
                        loading: loadingButtons.checked
                        text: ELocale.texts.DefaultSpinner
                    }
                    EButton {
                        styleType: EStyle.Primary
                        loading: loadingButtons.checked
                        text: ELocale.texts.RotatingArrow
                        loadingIconSource: EIcons.ARROW_ROTATE_RIGHT
                    }
                }
            }
            ExampleCase {
                title: ELocale.texts.ThreeSizes
                code: exampleData.samples.BasicExamplesSample5

                Flow {
                    spacing: 12
                    width: parent.width

                    EButton {
                        size: EStyle.Large
                        styleType: EStyle.Primary
                        text: ELocale.texts.Large
                    }
                    EButton {
                        size: EStyle.Medium
                        styleType: EStyle.Primary
                        text: ELocale.texts.Default
                    }
                    EButton {
                        size: EStyle.Small
                        styleType: EStyle.Primary
                        text: ELocale.texts.Small
                    }
                }
            }
            ExampleCase {
                title: ELocale.texts.CustomColor
                code: exampleData.samples.BasicExamplesSample6
                description: ELocale.texts.SetColorToCustomizeAButtonHover

                Flow {
                    spacing: 12
                    width: parent.width

                    EButton {
                        text: ELocale.texts.Default
                        color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                    }
                    EButton {
                        plain: true
                        text: ELocale.texts.Plain
                        color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                    }
                    EButton {
                        enabled: false
                        text: ELocale.texts.Disabled
                        color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                    }
                    EButton {
                        plain: true
                        enabled: false
                        text: ELocale.texts.DisabledPlain
                        color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                    }
                }
            }
            ExampleCase {
                title: exampleData.ui.ProgressButton
                code: exampleData.samples.ButtonProgress

                EButton {
                    id: progressButton

                    progress: -1
                    styleType: EStyle.Primary
                    text: exampleData.ui.StartProgress
                    enabled: progress < 0 || progress >= 1

                    onClicked: {
                        progress = 0
                        progressTimer.restart()
                    }
                }
                Timer {
                    id: progressTimer

                    repeat: true
                    interval: 120

                    onTriggered: {
                        progressButton.progress = Math.min(1, progressButton.progress + 0.1)
                        if (progressButton.progress >= 1)
                            stop()
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETextButton"

        ExampleCard {
            code: exampleData.samples.BasicExamplesSample2
            introduction: ELocale.texts.TextButtonsWithoutBordersOrBackgrounds
            description: ELocale.texts.UseStyletypeForSemanticColorsAndIsopenbackgroundcolor

            Column {
                spacing: 18
                width: parent.width

                EText {
                    font.pixelSize: 14
                    text: ELocale.texts.BasicTextButton
                    color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                }
                Flow {
                    spacing: 12
                    width: parent.width

                    ETextButton {
                        text: ELocale.texts.Default
                    }
                    ETextButton {
                        styleType: EStyle.Primary
                        text: ELocale.texts.Primary
                    }
                    ETextButton {
                        styleType: EStyle.Success
                        text: ELocale.texts.Success
                    }
                    ETextButton {
                        styleType: EStyle.Info
                        text: ELocale.texts.Info
                    }
                    ETextButton {
                        styleType: EStyle.Warning
                        text: ELocale.texts.Warning
                    }
                    ETextButton {
                        styleType: EStyle.Danger
                        text: ELocale.texts.Danger
                    }
                }
                EText {
                    font.pixelSize: 14
                    text: ELocale.texts.BackgroundColorAlwaysOn
                    color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                }
                Flow {
                    spacing: 12
                    width: parent.width

                    ETextButton {
                        isOpenBackgroundColor: true
                        text: ELocale.texts.Default
                    }
                    ETextButton {
                        styleType: EStyle.Primary
                        isOpenBackgroundColor: true
                        text: ELocale.texts.Primary
                    }
                    ETextButton {
                        styleType: EStyle.Success
                        isOpenBackgroundColor: true
                        text: ELocale.texts.Success
                    }
                    ETextButton {
                        styleType: EStyle.Info
                        text: ELocale.texts.Info
                        isOpenBackgroundColor: true
                    }
                    ETextButton {
                        styleType: EStyle.Warning
                        isOpenBackgroundColor: true
                        text: ELocale.texts.Warning
                    }
                    ETextButton {
                        styleType: EStyle.Danger
                        text: ELocale.texts.Danger
                        isOpenBackgroundColor: true
                    }
                }
                EText {
                    font.pixelSize: 14
                    text: ELocale.texts.DisabledTextButton
                    color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                }
                Flow {
                    spacing: 12
                    width: parent.width

                    ETextButton {
                        enabled: false
                        text: ELocale.texts.Default
                    }
                    ETextButton {
                        enabled: false
                        styleType: EStyle.Primary
                        text: ELocale.texts.Primary
                    }
                    ETextButton {
                        enabled: false
                        styleType: EStyle.Success
                        text: ELocale.texts.Success
                    }
                    ETextButton {
                        enabled: false
                        styleType: EStyle.Info
                        text: ELocale.texts.Info
                    }
                    ETextButton {
                        enabled: false
                        styleType: EStyle.Warning
                        text: ELocale.texts.Warning
                    }
                    ETextButton {
                        enabled: false
                        styleType: EStyle.Danger
                        text: ELocale.texts.Danger
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EText"

        ExampleCard {
            code: exampleData.samples.BasicExamplesSample7
            description: ELocale.texts.TextTypographyWrappingAndColorInheritedFrom

            ERectangle {
                radius: 8
                border.width: 1
                color: GalleryStyle.surface
                border.color: GalleryStyle.line
                objectName: "galleryTextSpecimen"
                width: Math.min(parent.width, 720)
                height: typography.implicitHeight + 48

                Column {
                    id: typography

                    x: 28
                    y: 24
                    spacing: 16
                    width: Math.max(0, parent.width - 56)

                    EText {
                        font.letterSpacing: 0.3
                        font.weight: Font.Medium
                        color: GalleryStyle.accent
                        text: ELocale.texts.READINGTYPOGRAPHY
                        font.pixelSize: GalleryStyle.captionSize
                    }
                    EText {
                        font.bold: true
                        lineHeight: 1.15
                        font.pixelSize: 26
                        width: parent.width
                        wrapMode: Text.WordWrap
                        color: GalleryStyle.text
                        objectName: "galleryTextHeading"
                        text: ELocale.texts.MakeInformationEasyToRead
                    }
                    EText {
                        lineHeight: 1.6
                        font.pixelSize: 14
                        width: parent.width
                        wrapMode: Text.WordWrap
                        color: GalleryStyle.text
                        objectName: "galleryTextBody"
                        text: ELocale.texts.ClearHierarchyMakesContentEasierToScanA
                    }
                    ERectangle {
                        height: 1
                        width: parent.width
                        color: GalleryStyle.line
                    }
                    EText {
                        lineHeight: 1.4
                        font.pixelSize: 12
                        width: parent.width
                        wrapMode: Text.WordWrap
                        color: GalleryStyle.muted
                        text: ELocale.texts.UpdatedToday1MinRead
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECopyableText"

        ExampleCard {
            code: exampleData.samples.BasicExamplesSample8
            description: ELocale.texts.SelectableCopyableTextWithCustomizableColors

            Column {
                spacing: 10
                width: parent.width

                ECopyableText {
                    text: ELocale.texts.DragToSelectAndCopyThisText
                }
                ECopyableText {
                    text: ELocale.texts.CustomColor
                    textColor: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                }
            }
        }
    }
    ExampleSection {
        componentName: "EIcon"

        ExampleCard {
            description: ELocale.texts.IconGlyphsSizesAndColors

            ExampleCase {
                code: iconBrowser.exampleCode
                title: ELocale.texts.AllIcons

                IconGallery {
                    id: iconBrowser
                }
            }
            ExampleCase {
                title: ELocale.texts.SizeAndColor
                code: exampleData.samples.BasicExamplesSample9

                Column {
                    spacing: 16
                    width: parent.width
                    objectName: "galleryIconSpecimen"

                    EText {
                        font.bold: true
                        font.pixelSize: 13
                        color: GalleryStyle.muted
                        text: ELocale.texts.SizeIconSize
                    }
                    Flow {
                        id: iconSizes

                        spacing: 12
                        width: parent.width
                        objectName: "galleryIconSizeGrid"

                        Repeater {
                            model: [16, 24, 32]

                            ERectangle {
                                radius: 8
                                height: 104
                                border.width: 1
                                color: GalleryStyle.surface
                                border.color: GalleryStyle.line
                                objectName: "galleryIconSizeTile"
                                width: Math.max(0, Math.floor((iconSizes.width - 12 * (iconSizes.width < 360
                                    ? 1
                                    : 2))
                                    / (iconSizes.width < 360 ? 2 : 3)))

                                Column {
                                    spacing: 10
                                    anchors.centerIn: parent

                                    EIcon {
                                        width: 36
                                        height: 36
                                        iconSize: modelData
                                        iconSource: EIcons.FOLDER
                                        color: GalleryStyle.accent
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                    EText {
                                        font.pixelSize: 12
                                        text: modelData + " px"
                                        color: GalleryStyle.muted
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                }
                            }
                        }
                    }
                    EText {
                        font.bold: true
                        font.pixelSize: 13
                        color: GalleryStyle.muted
                        text: ELocale.texts.SemanticColorColor
                    }
                    Flow {
                        id: iconTones

                        spacing: 12
                        width: parent.width
                        objectName: "galleryIconToneGrid"

                        Repeater {
                            model: [
                                {icon: EIcons.BELL, name: "BELL", label: ELocale.texts.Primary, tone: EStyle.Primary},
                                {icon: EIcons.CIRCLE_CHECK, name: "CIRCLE_CHECK", label: ELocale.texts.Success, tone: EStyle.Success},
                                {icon: EIcons.TRIANGLE_EXCLAMATION, name: "TRIANGLE_EXCLAMATION", label: ELocale.texts.Warning, tone: EStyle.Warning},
                                {icon: EIcons.CIRCLE_XMARK, name: "CIRCLE_XMARK", label: ELocale.texts.Danger, tone: EStyle.Danger}
                            ]

                            ERectangle {
                                radius: 8
                                height: 88
                                border.width: 1
                                color: GalleryStyle.surface
                                border.color: GalleryStyle.line
                                objectName: "galleryIconToneTile"
                                width: Math.max(0, Math.floor((iconTones.width - 12) / 2))

                                Row {
                                    x: 16
                                    y: 16
                                    spacing: 12

                                    EIcon {
                                        width: 28
                                        height: 28
                                        iconSize: 28
                                        iconSource: modelData.icon
                                        color: EPaletteManager.ThemePalette.fetchColorForStyle(modelData.tone)
                                    }
                                    EText {
                                        font.bold: true
                                        font.pixelSize: 13
                                        text: modelData.label
                                        color: GalleryStyle.text
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }
                                EText {
                                    x: 16
                                    y: 58
                                    elide: Text.ElideRight
                                    color: GalleryStyle.muted
                                    text: "EIcons." + modelData.name
                                    font.family: GalleryStyle.codeFamily
                                    width: Math.max(0, parent.width - 32)
                                    font.pixelSize: GalleryStyle.smallSize
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERotatingIcon"

        ExampleCard {
            code: exampleData.samples.BasicExamplesSample10
            description: ELocale.texts.ControlRotationDurationRunningStateAndTransform

            Row {
                spacing: 28

                ERotatingIcon {
                    running: true
                    iconSource: EIcons.ARROW_ROTATE_RIGHT
                }
                ERotatingIcon {
                    running: false
                    iconSource: EIcons.ARROW_ROTATE_RIGHT
                    color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Warning)
                }
                ERotatingIcon {
                    iconSize: 28
                    duration: 900
                    running: true
                    originX: width / 2
                    originY: height / 2
                    iconSource: EIcons.ARROW_ROTATE_RIGHT
                    color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERectangle"

        ExampleCard {
            code: exampleData.samples.BasicExamplesSample11
            description: ELocale.texts.ThemeAwareRectanglesWithRadiusBorderAnd

            Row {
                spacing: 18

                ERectangle {
                    radius: 8
                    height: 64
                    width: 120
                    color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                }
                ERectangle {
                    height: 64
                    radius: 20
                    width: 120
                    border.width: 2
                    color: EPaletteManager.BasePalette.transparent
                    border.color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Success)
                }
                ERectangle {
                    height: 64
                    radius: 12
                    width: 150
                    opacity: 0.86
                    border.width: 3
                    color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Warning)
                    border.color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Warning)
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAdvancedRectangle"

        ExampleCard {
            code: exampleData.samples.BasicExamplesSample12
            description: ELocale.texts.SetEachCornerRadiusSolidOrDashed

            Flow {
                spacing: 18
                width: parent.width

                EAdvancedRectangle {
                    height: 78
                    width: 140
                    radius: [28, 4, 28, 4]
                    color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                }
                EAdvancedRectangle {
                    height: 78
                    width: 140
                    borderWidth: 2
                    radius: [6, 28, 6, 28]
                    color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Success)
                    borderColor: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Success)
                }
                EAdvancedRectangle {
                    height: 78
                    width: 170
                    borderWidth: 3
                    dashPattern: [4, 2]
                    radius: [30, 8, 30, 8]
                    borderStyle: Qt.DashLine
                    color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Warning)
                    borderColor: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Warning)
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETextArea"

        ExampleCard {
            code: exampleData.samples.BasicExamplesSample13
            description: ELocale.texts.SizesAdaptiveHeightValidationStateAndText

            Column {
                spacing: 12
                width: parent.width

                ETextArea {
                    width: Math.min(parent.width, 520)
                    placeholderText: ELocale.texts.EnterMultipleLines
                }
                ETextArea {
                    height: 72
                    size: EStyle.Small
                    adaptiveHeight: false
                    text: ELocale.texts.FixedHeight
                    width: Math.min(parent.width, 520)
                }
            }
        }
    }
    BasicShowcase { }
}

import EUI 1.0
import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

ExamplePage {
    title: ELocale.texts.LayoutAndBasicFeatures
    description: ELocale.texts.CombineGridsSplitPanelsScrollContainersAnd

    ExampleSection {
        componentName: "EConfigProvider"

        ExampleCard {
            title: ELocale.texts.LocalLanguageAndNestedConfiguration
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EConfigProvider {
                    width: parent.width
                    height: webBasicProviderContent.implicitHeight
                    button: ({plain: true, round: true, type: "primary"})
                    locale: ({name: ELocale.language, texts: {NoData: ELocale.texts.DemoNoDataOverride}})

                    Column {
                        id: webBasicProviderContent

                        spacing: 16
                        width: parent.width
                        EEmpty { width: parent.width }
                        EButton { text: ELocale.texts.DemoLocalButtonDefaults }
                    }
                }
            `)

            EConfigProvider {
                width: parent.width
                height: webBasicProviderContent.implicitHeight
                button: ({plain: true, round: true, type: "primary"})
                locale: ({name: ELocale.language, texts: {NoData: ELocale.texts.DemoNoDataOverride}})

                Column {
                    id: webBasicProviderContent

                    spacing: 16
                    width: parent.width

                    EEmpty { width: parent.width }
                    EButton { text: ELocale.texts.DemoLocalButtonDefaults }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESplitterPanel"

        ExampleCard {
            title: ELocale.texts.PercentageSizesAndConstraints
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ESplitter {
                    height: 180
                    width: parent.width

                    ESplitterPanel {
                        max: "70%"
                        min: "20%"
                        size: "40%"
                        collapsible: true

                        ECard {
                            anchors.fill: parent
                            header: "20% ≤ panel ≤ 70%"
                        }
                    }
                    ESplitterPanel {
                        min: 100

                        ECard {
                            anchors.fill: parent
                            header: ELocale.texts.DemoRemainingSpace
                        }
                    }
                }
            `)

            ESplitter {
                height: 180
                width: parent.width

                ESplitterPanel {
                    max: "70%"
                    min: "20%"
                    size: "40%"
                    collapsible: true

                    ECard {
                        anchors.fill: parent
                        header: "20% ≤ panel ≤ 70%"
                    }
                }
                ESplitterPanel {
                    min: 100

                    ECard {
                        anchors.fill: parent
                        header: ELocale.texts.DemoRemainingSpace
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESplitter"

        ExampleCard {
            title: ELocale.texts.DragSizingCollapseAndDeferredResizing
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 12
                    width: parent.width

                    ESwitch {
                        text: ELocale.texts.ResizeAfterRelease

                        onToggled: webBasicSplitter.lazy = checked
                    }
                    ESplitter {
                        id: webBasicSplitter

                        height: 180
                        width: parent.width

                        ESplitterPanel {
                            min: 100
                            size: "35%"
                            collapsible: true

                            ECard {
                                anchors.fill: parent
                                header: ELocale.texts.Resources
                            }
                        }
                        ESplitterPanel {
                            min: 120

                            ECard {
                                anchors.fill: parent
                                header: ELocale.texts.Workspace
                            }
                        }
                    }
                }
            `)

            Column {
                spacing: 12
                width: parent.width

                ESwitch {
                    text: ELocale.texts.ResizeAfterRelease

                    onToggled: webBasicSplitter.lazy = checked
                }
                ESplitter {
                    id: webBasicSplitter

                    height: 180
                    width: parent.width

                    ESplitterPanel {
                        min: 100
                        size: "35%"
                        collapsible: true

                        ECard {
                            anchors.fill: parent
                            header: ELocale.texts.Resources
                        }
                    }
                    ESplitterPanel {
                        min: 120

                        ECard {
                            anchors.fill: parent
                            header: ELocale.texts.Workspace
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EScrollbar"

        ExampleCard {
            title: ELocale.texts.ScrollPositioningAndEdgeMasks
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 12
                    width: parent.width

                    EScrollbar {
                        id: webBasicScroll

                        mask: true
                        height: 160
                        always: true
                        width: Math.min(560, parent.width)

                        Column {
                            spacing: 8
                            width: webBasicScroll.availableWidth

                            Repeater {
                                model: 12

                                ECard {
                                    padding: 12
                                    width: parent.width
                                    header: "Item " + (index + 1)
                                }
                            }
                        }
                    }
                    Row {
                        spacing: 8

                        EButton {
                            text: ELocale.texts.ScrollToBottom

                            onClicked: webBasicScroll.setScrollTop(10000)
                        }
                        EButton {
                            text: ELocale.texts.BackToTop2

                            onClicked: webBasicScroll.setScrollTop(0)
                        }
                    }
                }
            `)

            Column {
                spacing: 12
                width: parent.width

                EScrollbar {
                    id: webBasicScroll

                    mask: true
                    height: 160
                    always: true
                    width: Math.min(560, parent.width)

                    Column {
                        spacing: 8
                        width: webBasicScroll.availableWidth

                        Repeater {
                            model: 12

                            ECard {
                                padding: 12
                                width: parent.width
                                header: "Item " + (index + 1)
                            }
                        }
                    }
                }
                Row {
                    spacing: 8

                    EButton {
                        text: ELocale.texts.ScrollToBottom

                        onClicked: webBasicScroll.setScrollTop(10000)
                    }
                    EButton {
                        text: ELocale.texts.BackToTop2

                        onClicked: webBasicScroll.setScrollTop(0)
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESpace"

        ExampleCard {
            title: ELocale.texts.PairGapsWrappingAndSpacers
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ESpace {
                    wrap: true
                    spacer: "·"
                    size: [20, 14]
                    width: parent.width
                    EButton { text: "Design" }
                    EButton { text: "Components" }
                    EButton { text: "Interaction" }
                    EButton { text: "Accessibility" }
                }
            `)

            ESpace {
                wrap: true
                spacer: "·"
                size: [20, 14]
                width: parent.width

                EButton { text: "Design" }
                EButton { text: "Components" }
                EButton { text: "Interaction" }
                EButton { text: "Accessibility" }
            }
        }
    }
    ExampleSection {
        componentName: "ERow"

        ExampleCard {
            title: ELocale.texts.ResponsiveGridAndAlignment
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ERow {
                    gutter: [12, 12]
                    width: parent.width
                    viewportWidth: width

                    ECol {
                        md: 8
                        sm: 12
                        xs: 24
                        height: 56

                        ERectangle {
                            radius: 8
                            color: "#409eff"
                            anchors.fill: parent

                            EText {
                                color: "white"
                                anchors.centerIn: parent
                                text: "xs 24 / sm 12 / md 8"
                            }
                        }
                    }
                    ECol {
                        md: 8
                        sm: 12
                        xs: 24
                        height: 56

                        ERectangle {
                            radius: 8
                            color: "#67c23a"
                            anchors.fill: parent

                            EText {
                                color: "white"
                                anchors.centerIn: parent
                                text: "Responsive column"
                            }
                        }
                    }
                    ECol {
                        md: 8
                        sm: 24
                        xs: 24
                        height: 56

                        ERectangle {
                            radius: 8
                            color: "#909399"
                            anchors.fill: parent

                            EText {
                                color: "white"
                                anchors.centerIn: parent
                                text: "Responsive column"
                            }
                        }
                    }
                }
            `)

            ERow {
                gutter: [12, 12]
                width: parent.width
                viewportWidth: width

                ECol {
                    md: 8
                    sm: 12
                    xs: 24
                    height: 56

                    ERectangle {
                        radius: 8
                        color: "#409eff"
                        anchors.fill: parent

                        EText {
                            color: "white"
                            anchors.centerIn: parent
                            text: "xs 24 / sm 12 / md 8"
                        }
                    }
                }
                ECol {
                    md: 8
                    sm: 12
                    xs: 24
                    height: 56

                    ERectangle {
                        radius: 8
                        color: "#67c23a"
                        anchors.fill: parent

                        EText {
                            color: "white"
                            anchors.centerIn: parent
                            text: "Responsive column"
                        }
                    }
                }
                ECol {
                    md: 8
                    sm: 24
                    xs: 24
                    height: 56

                    ERectangle {
                        radius: 8
                        color: "#909399"
                        anchors.fill: parent

                        EText {
                            color: "white"
                            anchors.centerIn: parent
                            text: "Responsive column"
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EContainer"

        ExampleCard {
            code: exampleData.samples.LayoutExamplesSample2

            EContainer {
                height: 210
                width: parent.width

                EHeader {
                    EText {
                        font.pixelSize: 14
                        text: ELocale.texts.HeaderNavigation
                        color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                    }
                }
                EContainer {
                    direction: Qt.Horizontal

                    EAside {
                        implicitWidth: 180

                        EText {
                            font.pixelSize: 14
                            text: ELocale.texts.Sidebar
                            color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                        }
                    }
                    EMain {
                        EText {
                            font.pixelSize: 14
                            text: ELocale.texts.MainContent
                            color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                        }
                    }
                }
                EFooter {
                    EText {
                        font.pixelSize: 14
                        text: ELocale.texts.Footer
                        color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERow"

        ExampleCard {
            code: exampleData.samples.LayoutExamplesSample3

            ERow {
                gutter: 16
                height: 64
                width: parent.width

                ECol {
                    span: 8
                    height: parent.height

                    ERectangle {
                        radius: 4
                        border.width: 1
                        anchors.fill: parent
                        color: EPaletteManager.BasePalette.transparent
                        border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)

                        EText {
                            font.pixelSize: 14
                            anchors.centerIn: parent
                            text: ELocale.texts.Value824
                            color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                        }
                    }
                }
                ECol {
                    span: 16
                    height: parent.height

                    ERectangle {
                        radius: 4
                        border.width: 1
                        anchors.fill: parent
                        color: EPaletteManager.BasePalette.transparent
                        border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)

                        EText {
                            font.pixelSize: 14
                            anchors.centerIn: parent
                            text: ELocale.texts.Value1624
                            color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ELink"

        ExampleCard {
            code: exampleData.samples.LayoutExamplesSample4

            Flow {
                spacing: 20
                width: parent.width

                ELink {
                    href: "https://easy-ui.cn/"
                    text: "EUI " + ELocale.texts.Home
                }
                ELink {
                    enabled: false
                    text: ELocale.texts.DisabledLink
                }
            }
        }
    }
    ExampleSection {
        componentName: "EScrollbar"

        ExampleCard {
            code: exampleData.samples.LayoutExamplesSample5

            EScrollbar {
                height: 160
                width: parent.width

                Column {
                    spacing: 12

                    Repeater {
                        model: 20

                        EText {
                            font.pixelSize: 14
                            text: ELocale.texts.ScrollableItem1.arg(index + 1)
                            color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESpace"

        ExampleCard {
            code: exampleData.samples.LayoutExamplesSample6

            ESpace {
                size: 16
                width: parent.width

                EButton {
                    text: ELocale.texts.Create
                }
                EButton {
                    text: ELocale.texts.Edit
                }
                EButton {
                    text: ELocale.texts.Save
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESplitter"

        ExampleCard {
            code: exampleData.samples.LayoutExamplesSample7
            description: ELocale.texts.DragTheDividerToResizeThePanels

            ESplitter {
                height: 160
                width: parent.width

                ERectangle {
                    radius: 4
                    border.width: 1
                    SplitView.minimumWidth: 100
                    SplitView.preferredWidth: 200
                    color: EPaletteManager.BasePalette.transparent
                    border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)

                    EText {
                        font.pixelSize: 14
                        anchors.centerIn: parent
                        text: ELocale.texts.LeftPanel
                        color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                    }
                }
                ERectangle {
                    radius: 4
                    border.width: 1
                    SplitView.fillWidth: true
                    SplitView.minimumWidth: 100
                    color: EPaletteManager.BasePalette.transparent
                    border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)

                    EText {
                        font.pixelSize: 14
                        anchors.centerIn: parent
                        text: ELocale.texts.RightPanel
                        color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETypography"

        ExampleCard {
            code: exampleData.samples.LayoutExamplesSample8

            ETypography {
                level: 1
                text: ELocale.texts.HeadingOne
            }
            ETypography {
                level: 2
                text: ELocale.texts.HeadingTwo
            }
            ETypography {
                level: 3
                text: ELocale.texts.HeadingThree
            }
            ETypography {
                text: ELocale.texts.BodyTextUsesTheProjectFontConsistent
            }
        }
    }
    ExampleSection {
        componentName: "EConfigProvider"

        ExampleCard {
            code: exampleData.samples.LayoutExamplesSample9

            EConfigProvider {
                id: provider

                height: 90
                width: parent.width
                size: sizeSwitch.checked ? EStyle.Large : EStyle.Small

                Column {
                    spacing: 16

                    ESwitch {
                        id: sizeSwitch

                        text: ELocale.texts.LargeControls
                    }
                    ESpace {
                        EButton {
                            text: ELocale.texts.SharedSize
                        }
                        EInput {
                            placeholderText: ELocale.texts.EnterContent
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EStaggeredLayout"

        ExampleCard {
            code: exampleData.samples.StaggeredLayout
            description: exampleData.ui.StaggeredIntroduction

            EStaggeredLayout {
                columns: 3
                spacing: 12
                width: parent.width

                Repeater {
                    model: exampleData.models.TileHeights

                    ERectangle {
                        radius: 6
                        height: modelData
                        color: EPaletteManager.ThemePalette.surfacePressed(ETheme.dark)

                        EText {
                            text: index + 1
                            font.pixelSize: 14
                            anchors.centerIn: parent
                            color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAppBar"

        ExampleCard {
            code: exampleData.samples.AppBar
            description: exampleData.ui.AppBarIntroduction

            EButton {
                text: exampleData.ui.OpenPreview
                objectName: "galleryOpenAppBarPreview"

                onClicked: appBarWindow.show()
            }
            EApplicationWindow {
                id: appBarWindow

                width: 620
                height: 260
                title: ELocale.texts.Eui
                objectName: "galleryAppBarPreview"
                flags: Qt.Window | Qt.FramelessWindowHint
                color: EPaletteManager.ThemePalette.fetchThemeColor(ETheme.dark)
                appBar: EAppBar {
                    title: ELocale.texts.Eui

                    ETextButton {
                        text: ELocale.language === "zh" ? ELocale.texts.English
                            : ELocale.texts.SimplifiedChinese

                        onClicked: ELocale.language = ELocale.language === "zh" ? "en" : "zh"
                    }
                    EThemeSwitch {
                        anchors.verticalCenter: parent.verticalCenter
                        accessibleName: ETheme.dark ? ELocale.texts.Light : ELocale.texts.Dark
                    }
                }

                EText {
                    font.pixelSize: 14
                    wrapMode: Text.WordWrap
                    anchors.centerIn: parent
                    width: parent.width - 48
                    text: exampleData.ui.AppBarPreview
                    horizontalAlignment: Text.AlignHCenter
                    color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                }
            }
        }
    }
    LayoutShowcase { }
}

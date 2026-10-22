import EUI 1.0
import QtQuick 2.15

ExamplePage {
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
                                text: ELocale.texts.DemoResponsiveColumn
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
                                text: ELocale.texts.DemoResponsiveColumn
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
                            text: ELocale.texts.DemoResponsiveColumn
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
                            text: ELocale.texts.DemoResponsiveColumn
                        }
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
                    EButton { text: ELocale.texts.Design }
                    EButton { text: ELocale.texts.DemoComponents }
                    EButton { text: ELocale.texts.DemoInteraction }
                    EButton { text: ELocale.texts.DemoAccessibility }
                }
            `)

            ESpace {
                wrap: true
                spacer: "·"
                size: [20, 14]
                width: parent.width

                EButton { text: ELocale.texts.Design }
                EButton { text: ELocale.texts.DemoComponents }
                EButton { text: ELocale.texts.DemoInteraction }
                EButton { text: ELocale.texts.DemoAccessibility }
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
                            header: "Remaining space"
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
                        header: "Remaining space"
                    }
                }
            }
        }
    }
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
                    locale: ({name: "en", texts: {NoData: "Nothing here yet"}})

                    Column {
                        id: webBasicProviderContent

                        spacing: 16
                        width: parent.width
                        EEmpty { width: parent.width }
                        EButton { text: "Local button defaults" }
                    }
                }
            `)

            EConfigProvider {
                width: parent.width
                height: webBasicProviderContent.implicitHeight
                button: ({plain: true, round: true, type: "primary"})
                locale: ({name: "en", texts: {NoData: "Nothing here yet"}})

                Column {
                    id: webBasicProviderContent

                    spacing: 16
                    width: parent.width

                    EEmpty { width: parent.width }
                    EButton { text: "Local button defaults" }
                }
            }
        }
    }
}

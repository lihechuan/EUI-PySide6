import EUI 1.0
import QtQuick 2.15

ExamplePage {
    title: ELocale.texts.PageNavigation
    description: ELocale.texts.ScrollNavigationStickyContentAndContextualPage

    ExampleSection {
        componentName: "EPageHeader"

        ExampleCard {
            description: ELocale.texts.PageHeadersProvideABackActionA
            code: exampleData.samples.ExtendedNavigationExamplesSample0

            EPageHeader {
                width: parent.width
                content: ELocale.texts.ProjectDetails

                onBack: headerStatus.text = ELocale.texts.BackActionTriggered

                EButton {
                    text: ELocale.texts.Edit
                    styleType: EStyle.Primary
                }
            }
            EText {
                id: headerStatus

                font.pixelSize: 14
                text: ELocale.texts.CurrentPageProjectDetails
                color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
            }
        }
    }
    ExampleSection {
        componentName: "EAffix"

        ExampleCard {
            description: ELocale.texts.TheActionBarStaysFixedAtThe
            code: exampleData.samples.ExtendedNavigationExamplesSample1

            Flickable {
                id: affixScroll

                clip: true
                height: 180
                contentHeight: 420
                width: parent.width
                boundsBehavior: Flickable.StopAtBounds

                Column {
                    spacing: 24
                    width: parent.width

                    EText {
                        font.pixelSize: 14
                        text: ELocale.texts.ScrollDownToSeeTheStickyBehavior
                        color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                    }
                    EAffix {
                        target: affixScroll

                        EButton {
                            styleType: EStyle.Primary
                            text: ELocale.texts.StickyActionBar
                        }
                    }
                    Repeater {
                        model: 6

                        EText {
                            font.pixelSize: 14
                            text: ELocale.texts.PageContent + (index + 1)
                            color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAnchor"

        ExampleCard {
            code: exampleData.samples.ExtendedNavigationExamplesSample2
            description: ELocale.texts.AnchorLinksScrollToTheSpecifiedContent

            Row {
                spacing: 24
                width: parent.width

                EAnchor {
                    target: anchorScroll
                    model: [{ text: exampleData.models.AnchorLabels[0], target: overview }, { text: exampleData.models.AnchorLabels[1], target: settings }, { text: exampleData.models.AnchorLabels[2], target: resources }]
                }
                Flickable {
                    id: anchorScroll

                    clip: true
                    height: 180
                    contentHeight: 660
                    boundsBehavior: Flickable.StopAtBounds
                    width: Math.max(120, parent.width - 184)

                    Column {
                        width: parent.width

                        EText {
                            id: overview

                            height: 220
                            font.pixelSize: 14
                            text: ELocale.texts.OverviewProjectStatusAndDescription
                            color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                        }
                        EText {
                            id: settings

                            height: 220
                            font.pixelSize: 14
                            text: ELocale.texts.SettingsThemeAndBehavior
                            color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                        }
                        EText {
                            id: resources

                            height: 220
                            font.pixelSize: 14
                            text: ELocale.texts.ResourcesFilesAndDependencies
                            color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EBacktop"

        ExampleCard {
            description: ELocale.texts.TheBackToTopButtonAppearsAfter
            code: exampleData.samples.ExtendedNavigationExamplesSample3

            Item {
                height: 180
                width: parent.width

                Flickable {
                    id: backtopScroll

                    clip: true
                    contentHeight: 620
                    anchors.fill: parent
                    boundsBehavior: Flickable.StopAtBounds

                    Column {
                        spacing: 30

                        Repeater {
                            model: 12

                            EText {
                                font.pixelSize: 14
                                text: ELocale.texts.ScrollableContent + (index + 1)
                                color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                            }
                        }
                    }
                }
                EBacktop {
                    target: backtopScroll
                    visibilityHeight: 100
                    anchors.rightMargin: 16
                    anchors.bottomMargin: 16
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                }
            }
        }
    }
    ExtendedNavigationShowcase { }
}

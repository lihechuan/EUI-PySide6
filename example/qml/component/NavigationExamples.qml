import EUI 1.0
import QtQuick 2.15

ExamplePage {
    title: ELocale.texts.Navigation
    description: ELocale.texts.ClearlyOrganizePageHierarchyWorkflowsAndQuick

    ExampleSection {
        componentName: "ETabs"

        ExampleCase {
            title: ELocale.texts.GuardedTabsAndLazyContent
            description: ELocale.texts.TheSwitchControlsBeforeLeavePanesAreCreatedOnly
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EApplicationWindow {
                    width: 640
                    height: 480
                    visible: true

                    Column {
                        width: parent.width - 48
                        spacing: 16
                        anchors.centerIn: parent

                        ESwitch {
                            id: webNavigationAllowLeave
                \x20\x20\x20\x20\x20\x20\x20\x20
                            checked: true
                            text: ELocale.texts.AllowSwitching
                        }
                        ETabs {
                            lazy: true
                            width: parent.width
                            objectName: "webNavigationTabs"
                            beforeLeave: function() { return webNavigationAllowLeave.checked }
                            model: [{text: ELocale.texts.Overview, name: "overview", contentComponent: webNavigationOverviewPane},
                                {text: ELocale.texts.Activity, name: "activity", contentComponent: webNavigationActivityPane}]
                        }
                        Component {
                            id: webNavigationOverviewPane
                \x20\x20\x20\x20\x20\x20\x20\x20
                            EText {
                                width: parent.width
                                wrapMode: Text.WordWrap
                                text: ELocale.texts.OverviewIsCreatedOnFirstUseAndKeeps
                            }
                        }
                        Component {
                            id: webNavigationActivityPane
                \x20\x20\x20\x20\x20\x20\x20\x20
                            EText {
                                width: parent.width
                                wrapMode: Text.WordWrap
                                text: ELocale.texts.TheActivityPaneHasItsOwnLifecycle
                            }
                        }
                    }
                }
            `)

            ESwitch {
                id: webNavigationAllowLeave

                checked: true
                text: ELocale.texts.AllowSwitching
            }
            ETabs {
                lazy: true
                width: parent.width
                objectName: "webNavigationTabs"
                beforeLeave: function() {
                    return webNavigationAllowLeave.checked
                }
                model: [{text: ELocale.texts.Overview, name
                    : "overview", contentComponent
                    : webNavigationOverviewPane},
                    {text: ELocale.texts.Activity, name
                        : "activity", contentComponent
                        : webNavigationActivityPane}]
            }
            Component {
                id: webNavigationOverviewPane

                EText {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: ELocale.texts.OverviewIsCreatedOnFirstUseAndKeeps
                }
            }
            Component {
                id: webNavigationActivityPane

                EText {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: ELocale.texts.TheActivityPaneHasItsOwnLifecycle
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETabs"

        ExampleCard {
            code: exampleData.samples.NavigationExamplesSample0
            description: ELocale.texts.SupportsKeyboardNavigationDisabledItemsAndClosable

            ETabs {
                id: tabs

                addable: true
                movable: true
                closable: true
                width: parent.width
                model: exampleData.models.Tabs

                onTabAddRequested: model = model.concat([{ text: exampleData.ui.NewTab.arg(model.length
                    + 1) }])
            }
            EText {
                font.pixelSize: 14
                color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                text: tabs.currentIndex >= 0 ? ELocale.texts.CurrentTab + tabs.model[tabs.currentIndex].text
                    : ELocale.texts.AllTabsAreClosed
            }
            EButton {
                text: ELocale.texts.RestoreTabs

                onClicked: tabs.model = exampleData.models.Tabs.slice()
            }
        }
    }
    ExampleSection {
        componentName: "EBreadcrumb"

        ExampleCard {
            code: exampleData.samples.NavigationExamplesSample1
            description: ELocale.texts.ShowsTheCurrentLocationClickAParent

            EBreadcrumb {
                id: breadcrumb

                model: exampleData.models.Breadcrumbs

                onClicked: breadcrumbResult.text = ELocale.texts.NavigateTo + item
            }
            EText {
                id: breadcrumbResult

                font.pixelSize: 14
                text: ELocale.texts.CurrentLocationNavigation
                color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
            }
        }
    }
    ExampleSection {
        componentName: "ESteps"

        ExampleCard {
            code: exampleData.samples.NavigationExamplesSample2
            description: ELocale.texts.StepsDisplayTheCurrentStageCompletedStages

            ESteps {
                id: steps

                active: 1
                clickable: true
                width: parent.width
                model: exampleData.models.ProjectSteps
            }
            EButton {
                text: steps.active >= steps.model.length ? ELocale.texts.StartOver : ELocale.texts.Next

                onClicked: steps.active >= steps.model.length ? steps.active = 0 : steps.advance()
            }
        }
    }
    ExampleSection {
        componentName: "EDropdown"

        ExampleCard {
            code: exampleData.samples.NavigationExamplesSample3
            description: ELocale.texts.DropdownMenusSupportTheMouseArrowKeys

            EDropdown {
                text: ELocale.texts.MoreActions
                model: exampleData.models.DropdownActions

                onCommand: dropdownResult.text = ELocale.texts.Execute + value
            }
            EText {
                id: dropdownResult

                font.pixelSize: 14
                text: ELocale.texts.SelectAnAction
                color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
            }
        }
    }
    ExampleSection {
        componentName: "EMenuBar"

        ExampleCard {
            code: exampleData.samples.MenuBar
            description: exampleData.ui.MenuBarIntroduction

            EMenuBar {
                width: parent.width
                model: exampleData.models.MainMenu

                onCommand: menuBarResult.text = item.text
            }
            EText {
                id: menuBarResult

                font.pixelSize: 14
                text: exampleData.ui.Waiting
                color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
            }
        }
    }
    NavigationShowcase { }
    PrimeShowcase { names: ["EDropdown"] }
}

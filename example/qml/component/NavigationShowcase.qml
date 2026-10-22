import EUI 1.0
import QtQuick 2.15

Column {
    spacing: 24
    width: parent.width

    ExampleSection {
        componentName: "ETabs"

        ExampleCase {
            objectName: "showcaseETabs0"
            title: ELocale.texts.CardTabs
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ETabs {
                        type: "card"
                        stretch: true
                        tabPosition: "bottom"
                        width: Math.min(480, parent.width)
                        model: [{name: "overview", label: ELocale.texts.Overview, contentComponent: pane}, {name: "activity", label: ELocale.texts.Activity, contentComponent: pane}, {name: "settings", label: ELocale.texts.Settings, contentComponent: pane}, {name: "locked", label: ELocale.texts.Archived, disabled: true}]
                    }
                    Component {
                        id: pane

                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: parent.entry.label + ELocale.texts.IndependentTabContent
                        }
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                ETabs {
                    type: "card"
                    stretch: true
                    tabPosition: "bottom"
                    width: Math.min(480, parent.width)
                    model: [{name: "overview", label: ELocale.texts.Overview, contentComponent: pane}, {name: "activity", label: ELocale.texts.Activity, contentComponent: pane}, {name: "settings", label: ELocale.texts.Settings, contentComponent: pane}, {name: "locked", label: ELocale.texts.Archived, disabled: true}]
                }
                Component {
                    id: pane

                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: parent.entry.label + ELocale.texts.IndependentTabContent
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETabs"

        ExampleCase {
            objectName: "showcaseETabs1"
            title: ELocale.texts.VerticalLazyTabs
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ETabs {
                        lazy: true
                        height: 220
                        tabPosition: "left"
                        navigationWidth: 120
                        width: Math.min(480, parent.width)
                        model: [{name: "overview", label: ELocale.texts.Overview, contentComponent: pane}, {name: "activity", label: ELocale.texts.Activity, contentComponent: pane}, {name: "settings", label: ELocale.texts.Settings, contentComponent: pane}, {name: "locked", label: ELocale.texts.Archived, disabled: true}]
                    }
                    Component {
                        id: pane

                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: parent.entry.label + ELocale.texts.IndependentTabContent
                        }
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                ETabs {
                    lazy: true
                    height: 220
                    tabPosition: "left"
                    navigationWidth: 120
                    width: Math.min(480, parent.width)
                    model: [{name: "overview", label: ELocale.texts.Overview, contentComponent: pane}, {name: "activity", label: ELocale.texts.Activity, contentComponent: pane}, {name: "settings", label: ELocale.texts.Settings, contentComponent: pane}, {name: "locked", label: ELocale.texts.Archived, disabled: true}]
                }
                Component {
                    id: pane

                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: parent.entry.label + ELocale.texts.IndependentTabContent
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETabs"

        ExampleCase {
            objectName: "showcaseETabs2"
            title: ELocale.texts.EditableTabs
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ETabs {
                        addable: true
                        movable: true
                        closable: true
                        width: Math.min(480, parent.width)
                        model: [{name: "overview", label: ELocale.texts.Overview, contentComponent: pane}, {name: "activity", label: ELocale.texts.Activity, contentComponent: pane}, {name: "settings", label: ELocale.texts.Settings, contentComponent: pane}, {name: "locked", label: ELocale.texts.Archived, disabled: true}]

                        onTabAddRequested: model = model.concat([{name: "new" + count, label: ELocale.texts.NewTab2 + count, contentComponent: pane}])
                    }
                    Component {
                        id: pane

                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: parent.entry.label + ELocale.texts.IndependentTabContent
                        }
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                ETabs {
                    addable: true
                    movable: true
                    closable: true
                    width: Math.min(480, parent.width)
                    model: [{name: "overview", label: ELocale.texts.Overview, contentComponent: pane}, {name: "activity", label: ELocale.texts.Activity, contentComponent: pane}, {name: "settings", label: ELocale.texts.Settings, contentComponent: pane}, {name: "locked", label: ELocale.texts.Archived, disabled: true}]

                    onTabAddRequested: model = model.concat([{name: "new" + count, label: ELocale.texts.NewTab2 + count, contentComponent: pane}])
                }
                Component {
                    id: pane

                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: parent.entry.label + ELocale.texts.IndependentTabContent
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESteps"

        ExampleCase {
            objectName: "showcaseESteps0"
            title: ELocale.texts.ClickableSteps
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ESteps {
                    active: 1
                    clickable: true
                    alignCenter: true
                    width: Math.min(480, parent.width)
                    model: [{title: ELocale.texts.Selection, description: ELocale.texts.ChooseAWorkspace}, {title: ELocale.texts.Configuration, description: ELocale.texts.ConfigureProject}, {title: ELocale.texts.Done, description: ELocale.texts.Ready2}]
                }
            `)

            ESteps {
                active: 1
                clickable: true
                alignCenter: true
                width: Math.min(480, parent.width)
                model: [{title: ELocale.texts.Selection, description: ELocale.texts.ChooseAWorkspace}, {title: ELocale.texts.Configuration, description: ELocale.texts.ConfigureProject}, {title: ELocale.texts.Done, description: ELocale.texts.Ready2}]
            }
        }
    }
    ExampleSection {
        componentName: "ESteps"

        ExampleCase {
            objectName: "showcaseESteps1"
            title: ELocale.texts.VerticalSteps
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ESteps {
                    active: 1
                    width: 320
                    direction: EOrientation.Vertical
                    model: [{title: ELocale.texts.Selection, description: ELocale.texts.ChooseAWorkspace}, {title: ELocale.texts.Configuration, description: ELocale.texts.ConfigureProject}, {title: ELocale.texts.Done, description: ELocale.texts.Ready2}]
                }
            `)

            ESteps {
                active: 1
                width: 320
                direction: EOrientation.Vertical
                model: [{title: ELocale.texts.Selection, description: ELocale.texts.ChooseAWorkspace}, {title: ELocale.texts.Configuration, description: ELocale.texts.ConfigureProject}, {title: ELocale.texts.Done, description: ELocale.texts.Ready2}]
            }
        }
    }
    ExampleSection {
        componentName: "ESteps"

        ExampleCase {
            objectName: "showcaseESteps2"
            title: ELocale.texts.SimpleSteps
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ESteps {
                    active: 1
                    simple: true
                    width: Math.min(480, parent.width)
                    model: [{title: ELocale.texts.Selection, description: ELocale.texts.ChooseAWorkspace}, {title: ELocale.texts.Configuration, description: ELocale.texts.ConfigureProject}, {title: ELocale.texts.Done, description: ELocale.texts.Ready2}]
                }
            `)

            ESteps {
                active: 1
                simple: true
                width: Math.min(480, parent.width)
                model: [{title: ELocale.texts.Selection, description: ELocale.texts.ChooseAWorkspace}, {title: ELocale.texts.Configuration, description: ELocale.texts.ConfigureProject}, {title: ELocale.texts.Done, description: ELocale.texts.Ready2}]
            }
        }
    }
    ExampleSection {
        componentName: "ESteps"

        ExampleCase {
            objectName: "showcaseESteps3"
            title: ELocale.texts.StepStatus
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ESteps {
                        id: sample

                        processStatus: "error"
                        finishStatus: "success"
                        width: Math.min(480, parent.width)
                        model: [{title: ELocale.texts.Selection, description: ELocale.texts.ChooseAWorkspace}, {title: ELocale.texts.Configuration, description: ELocale.texts.ConfigureProject}, {title: ELocale.texts.Done, description: ELocale.texts.Ready2}]
                    }
                    EButton {
                        text: ELocale.texts.Next

                        onClicked: sample.active = (sample.active + 1) % 4
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                ESteps {
                    id: sample

                    processStatus: "error"
                    finishStatus: "success"
                    width: Math.min(480, parent.width)
                    model: [{title: ELocale.texts.Selection, description: ELocale.texts.ChooseAWorkspace}, {title: ELocale.texts.Configuration, description: ELocale.texts.ConfigureProject}, {title: ELocale.texts.Done, description: ELocale.texts.Ready2}]
                }
                EButton {
                    text: ELocale.texts.Next

                    onClicked: sample.active = (sample.active + 1) % 4
                }
            }
        }
    }
    ExampleSection {
        componentName: "EMenuBar"

        ExampleCase {
            objectName: "showcaseEMenuBar0"
            title: ELocale.texts.MenuShortcuts
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EMenuBar {
                        width: Math.min(480, parent.width)
                        model: [{text: ELocale.texts.File, children: [{index: "new", text: ELocale.texts.New, shortcut: "Ctrl+N"}, {index: "save", text: ELocale.texts.CoreSampleSave, shortcut: "Ctrl+S"}, {index: "close", text: ELocale.texts.Close, divided: true}]}, {text: ELocale.texts.Edit, children: [{index: "copy", text: ELocale.texts.Copy}]}]

                        onCommand: result.text = index
                    }
                    EText {
                        id: result

                        text: ELocale.texts.ChooseACommand
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EMenuBar {
                    width: Math.min(480, parent.width)
                    model: [{text: ELocale.texts.File, children: [{index: "new", text: ELocale.texts.New, shortcut: "Ctrl+N"}, {index: "save", text: ELocale.texts.CoreSampleSave, shortcut: "Ctrl+S"}, {index: "close", text: ELocale.texts.Close, divided: true}]}, {text: ELocale.texts.Edit, children: [{index: "copy", text: ELocale.texts.Copy}]}]

                    onCommand: result.text = index
                }
                EText {
                    id: result

                    text: ELocale.texts.ChooseACommand
                }
            }
        }
    }
    ExampleSection {
        componentName: "EMenuBar"

        ExampleCase {
            objectName: "showcaseEMenuBar1"
            title: ELocale.texts.DisabledCommands
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EMenuBar {
                        width: Math.min(480, parent.width)
                        model: [{text: ELocale.texts.Project, children: [{index: "open", text: ELocale.texts.Open}, {index: "locked", text: ELocale.texts.Archived, disabled: true}]}]

                        onCommand: result.text = index
                    }
                    EText {
                        id: result

                        text: ELocale.texts.ChooseACommand
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EMenuBar {
                    width: Math.min(480, parent.width)
                    model: [{text: ELocale.texts.Project, children: [{index: "open", text: ELocale.texts.Open}, {index: "locked", text: ELocale.texts.Archived, disabled: true}]}]

                    onCommand: result.text = index
                }
                EText {
                    id: result

                    text: ELocale.texts.ChooseACommand
                }
            }
        }
    }
    ExampleSection {
        componentName: "EMenuBar"

        ExampleCase {
            objectName: "showcaseEMenuBar2"
            title: ELocale.texts.NestedMenus
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EMenuBar {
                        width: Math.min(480, parent.width)
                        model: [{text: ELocale.texts.Tools, children: [{text: ELocale.texts.TableExport, children: [{index: "png", text: "PNG"}, {index: "svg", text: "SVG"}]}]}]

                        onCommand: result.text = index
                    }
                    EText {
                        id: result

                        text: ELocale.texts.ChooseACommand
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EMenuBar {
                    width: Math.min(480, parent.width)
                    model: [{text: ELocale.texts.Tools, children: [{text: ELocale.texts.TableExport, children: [{index: "png", text: "PNG"}, {index: "svg", text: "SVG"}]}]}]

                    onCommand: result.text = index
                }
                EText {
                    id: result

                    text: ELocale.texts.ChooseACommand
                }
            }
        }
    }
    ExampleSection {
        componentName: "EMenuBar"

        ExampleCase {
            objectName: "showcaseEMenuBar3"
            title: ELocale.texts.CommandFeedback
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EMenuBar {
                        width: Math.min(480, parent.width)
                        model: [{text: ELocale.texts.View2, children: [{index: "light", text: ELocale.texts.Light2}, {index: "dark", text: ELocale.texts.Dark3}]}]

                        onCommand: result.text = index
                    }
                    EText {
                        id: result

                        text: ELocale.texts.ChooseACommand
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EMenuBar {
                    width: Math.min(480, parent.width)
                    model: [{text: ELocale.texts.View2, children: [{index: "light", text: ELocale.texts.Light2}, {index: "dark", text: ELocale.texts.Dark3}]}]

                    onCommand: result.text = index
                }
                EText {
                    id: result

                    text: ELocale.texts.ChooseACommand
                }
            }
        }
    }
    ExampleSection {
        componentName: "EDropdown"

        ExampleCase {
            objectName: "showcaseEDropdown0"
            title: ELocale.texts.SplitButton
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EDropdown {
                        splitButton: true
                        text: ELocale.texts.ProjectActions
                        model: [{text: ELocale.texts.Edit, command: "edit", iconSource: EIcons.PENCIL}, {text: ELocale.texts.Copy, command: "copy"}, {text: ELocale.texts.Delete, command: "delete", divided: true, disabled: true}]

                        onCommand: result.text = String(value)
                    }
                    EText {
                        id: result

                        text: ELocale.texts.WaitingForAnAction
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EDropdown {
                    splitButton: true
                    text: ELocale.texts.ProjectActions
                    model: [{text: ELocale.texts.Edit, command: "edit", iconSource: EIcons.PENCIL}, {text: ELocale.texts.Copy, command: "copy"}, {text: ELocale.texts.Delete, command: "delete", divided: true, disabled: true}]

                    onCommand: result.text = String(value)
                }
                EText {
                    id: result

                    text: ELocale.texts.WaitingForAnAction
                }
            }
        }
    }
    ExampleSection {
        componentName: "EDropdown"

        ExampleCase {
            objectName: "showcaseEDropdown1"
            title: ELocale.texts.HoverDropdown
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EDropdown {
                        hideTimeout: 300
                        showTimeout: 150
                        trigger: "hover"
                        text: ELocale.texts.ProjectActions
                        model: [{text: ELocale.texts.Edit, command: "edit", iconSource: EIcons.PENCIL}, {text: ELocale.texts.Copy, command: "copy"}, {text: ELocale.texts.Delete, command: "delete", divided: true, disabled: true}]

                        onCommand: result.text = String(value)
                    }
                    EText {
                        id: result

                        text: ELocale.texts.WaitingForAnAction
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EDropdown {
                    hideTimeout: 300
                    showTimeout: 150
                    trigger: "hover"
                    text: ELocale.texts.ProjectActions
                    model: [{text: ELocale.texts.Edit, command: "edit", iconSource: EIcons.PENCIL}, {text: ELocale.texts.Copy, command: "copy"}, {text: ELocale.texts.Delete, command: "delete", divided: true, disabled: true}]

                    onCommand: result.text = String(value)
                }
                EText {
                    id: result

                    text: ELocale.texts.WaitingForAnAction
                }
            }
        }
    }
    ExampleSection {
        componentName: "EDropdown"

        ExampleCase {
            objectName: "showcaseEDropdown2"
            title: ELocale.texts.DropdownSizing
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EDropdown {
                        maxHeight: 140
                        menuWidth: 240
                        showArrow: true
                        text: ELocale.texts.ProjectActions
                        model: [{text: ELocale.texts.Edit, command: "edit", iconSource: EIcons.PENCIL}, {text: ELocale.texts.Copy, command: "copy"}, {text: ELocale.texts.Delete, command: "delete", divided: true, disabled: true}]

                        onCommand: result.text = String(value)
                    }
                    EText {
                        id: result

                        text: ELocale.texts.WaitingForAnAction
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EDropdown {
                    maxHeight: 140
                    menuWidth: 240
                    showArrow: true
                    text: ELocale.texts.ProjectActions
                    model: [{text: ELocale.texts.Edit, command: "edit", iconSource: EIcons.PENCIL}, {text: ELocale.texts.Copy, command: "copy"}, {text: ELocale.texts.Delete, command: "delete", divided: true, disabled: true}]

                    onCommand: result.text = String(value)
                }
                EText {
                    id: result

                    text: ELocale.texts.WaitingForAnAction
                }
            }
        }
    }
    ExampleSection {
        componentName: "EDropdown"

        ExampleCase {
            objectName: "showcaseEDropdown3"
            title: ELocale.texts.PersistentDropdown
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EDropdown {
                        hideOnClick: false
                        text: ELocale.texts.ProjectActions
                        model: [{text: ELocale.texts.Edit, command: "edit", iconSource: EIcons.PENCIL}, {text: ELocale.texts.Copy, command: "copy"}, {text: ELocale.texts.Delete, command: "delete", divided: true, disabled: true}]

                        onCommand: result.text = String(value)
                    }
                    EText {
                        id: result

                        text: ELocale.texts.WaitingForAnAction
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EDropdown {
                    hideOnClick: false
                    text: ELocale.texts.ProjectActions
                    model: [{text: ELocale.texts.Edit, command: "edit", iconSource: EIcons.PENCIL}, {text: ELocale.texts.Copy, command: "copy"}, {text: ELocale.texts.Delete, command: "delete", divided: true, disabled: true}]

                    onCommand: result.text = String(value)
                }
                EText {
                    id: result

                    text: ELocale.texts.WaitingForAnAction
                }
            }
        }
    }
    ExampleSection {
        componentName: "EBreadcrumb"

        ExampleCase {
            objectName: "showcaseEBreadcrumb0"
            title: ELocale.texts.IconSeparator
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EBreadcrumb {
                    separatorIcon: EIcons.CHEVRON_RIGHT
                    model: [{text: ELocale.texts.Workspace2}, {text: ELocale.texts.Project}, {text: ELocale.texts.Details}]
                }
            `)

            EBreadcrumb {
                separatorIcon: EIcons.CHEVRON_RIGHT
                model: [{text: ELocale.texts.Workspace2}, {text: ELocale.texts.Project}, {text: ELocale.texts.Details}]
            }
        }
    }
    ExampleSection {
        componentName: "EBreadcrumb"

        ExampleCase {
            objectName: "showcaseEBreadcrumb1"
            title: ELocale.texts.TextSeparator
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EBreadcrumb {
                    separator: "→"
                    model: [{text: ELocale.texts.Workspace2}, {text: ELocale.texts.Project}, {text: ELocale.texts.Details}]
                }
            `)

            EBreadcrumb {
                separator: "→"
                model: [{text: ELocale.texts.Workspace2}, {text: ELocale.texts.Project}, {text: ELocale.texts.Details}]
            }
        }
    }
    ExampleSection {
        componentName: "EBreadcrumb"

        ExampleCase {
            objectName: "showcaseEBreadcrumb2"
            title: ELocale.texts.ClickableCurrentItem
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EBreadcrumb {
                    clickableLast: true
                    model: [{text: ELocale.texts.Workspace2}, {text: ELocale.texts.Project}, {text: ELocale.texts.Details}]
                }
            `)

            EBreadcrumb {
                clickableLast: true
                model: [{text: ELocale.texts.Workspace2}, {text: ELocale.texts.Project}, {text: ELocale.texts.Details}]
            }
        }
    }
    ExampleSection {
        componentName: "EBreadcrumb"

        ExampleCase {
            objectName: "showcaseEBreadcrumb3"
            title: ELocale.texts.DisabledBreadcrumb
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EBreadcrumb {
                    enabled: false
                    model: [{text: ELocale.texts.Workspace2}, {text: ELocale.texts.Project}, {text: ELocale.texts.Details}]
                }
            `)

            EBreadcrumb {
                enabled: false
                model: [{text: ELocale.texts.Workspace2}, {text: ELocale.texts.Project}, {text: ELocale.texts.Details}]
            }
        }
    }
}

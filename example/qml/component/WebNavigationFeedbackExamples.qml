import EUI 1.0
import QtQuick 2.15

ExamplePage {
    ExampleSection {
        componentName: "EMenu"

        ExampleCase {
            title: ELocale.texts.NestedMenusAndOverflow
            description: ELocale.texts.HoverOpensSubmenusNarrowWidthsMoveEntriesInto
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

                        EMenu {
                            width: parent.width
                            direction: EOrientation.Horizontal
                            objectName: "webNavigationMenu"
                            model: [{index: "workspace", text: ELocale.texts.Workspace, children: [
                                {index: "open", text: ELocale.texts.OpenProject},
                                {index: "recent", text: ELocale.texts.Recent, children: [{index: "gallery", text: "EUI Gallery"}]}]},
                                {index: "settings", text: ELocale.texts.Settings},
                                {index: "restricted", text: ELocale.texts.Restricted, disabled: true}]
                        }
                    }
                }
            `)

            EMenu {
                width: parent.width
                objectName: "webNavigationMenu"
                direction: EOrientation.Horizontal
                model: [{index: "workspace", text: ELocale.texts.Workspace, children
                    : [
                    {index: "open", text: ELocale.texts.OpenProject},
                    {index: "recent", text: ELocale.texts.Recent, children
                        : [{index: "gallery", text: "EUI Gallery"}]}]},
                    {index: "settings", text: ELocale.texts.Settings},
                    {index: "restricted", text: ELocale.texts.Restricted, disabled
                        : true}]
            }
        }
    }
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
        componentName: "EDialog"

        ExampleCase {
            title: ELocale.texts.CloseGuardsAndDragging
            description: ELocale.texts.TheCloseHookWaitsForDoneComponentContent
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

                        EButton {
                            text: ELocale.texts.OpenDialog
                \x20\x20\x20\x20\x20\x20\x20\x20
                            onClicked: webNavigationDialog.open()
                        }
                        EDialog {
                            id: webNavigationDialog
                \x20\x20\x20\x20\x20\x20\x20\x20
                            draggable: true
                            showFooter: false
                            destroyOnClose: true
                            title: ELocale.texts.ConfirmBeforeClosing
                            beforeClose: function(done) {
                                webNavigationDialogConfirmation.complete = done
                                webNavigationDialogConfirmation.open()
                            }
                            contentComponent: webNavigationDialogContent
                        }
                        Component {
                            id: webNavigationDialogContent
                \x20\x20\x20\x20\x20\x20\x20\x20
                            EText {
                                width: parent.width
                                wrapMode: Text.WordWrap
                                text: ELocale.texts.ContentIsDestroyedAfterClosingAndRecreatedWhen
                            }
                        }
                        EDialog {
                            id: webNavigationDialogConfirmation
                \x20\x20\x20\x20\x20\x20\x20\x20
                            property var complete: null
                \x20\x20\x20\x20\x20\x20\x20\x20
                            title: ELocale.texts.ConfirmClose
                            text: ELocale.texts.CloseTheCurrentPanel
                \x20\x20\x20\x20\x20\x20\x20\x20
                            onAccepted: {
                                if (complete)
                                    complete()
                                complete = null
                            }
                            onRejected: {
                                if (complete)
                                    complete(true)
                                complete = null
                            }
                        }
                    }
                }
            `)

            EButton {
                text: ELocale.texts.OpenDialog

                onClicked: webNavigationDialog.open()
            }
            EDialog {
                id: webNavigationDialog

                draggable: true
                showFooter: false
                destroyOnClose: true
                title: ELocale.texts.ConfirmBeforeClosing
                contentComponent: webNavigationDialogContent
                beforeClose: function(done) {
                    webNavigationDialogConfirmation.complete = done
                    webNavigationDialogConfirmation.open()
                }
            }
            Component {
                id: webNavigationDialogContent

                EText {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: ELocale.texts.ContentIsDestroyedAfterClosingAndRecreatedWhen
                }
            }
            EDialog {
                id: webNavigationDialogConfirmation

                property var complete: null

                title: ELocale.texts.ConfirmClose
                text: ELocale.texts.CloseTheCurrentPanel

                onAccepted: {
                    if (complete)
                        complete()
                    complete = null
                }
                onRejected: {
                    if (complete)
                        complete(true)
                    complete = null
                }
            }
        }
    }
    ExampleSection {
        componentName: "EDrawer"

        ExampleCase {
            title: ELocale.texts.CloseGuardsAndResizing
            description: ELocale.texts.TheCloseHookWaitsForDoneComponentContent
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

                        EButton {
                            text: ELocale.texts.OpenDrawer
                \x20\x20\x20\x20\x20\x20\x20\x20
                            onClicked: webNavigationDrawer.open()
                        }
                        EDrawer {
                            id: webNavigationDrawer
                \x20\x20\x20\x20\x20\x20\x20\x20
                            resizable: true
                            destroyOnClose: true
                            title: ELocale.texts.ConfirmBeforeClosing
                            beforeClose: function(done) {
                                webNavigationDrawerConfirmation.complete = done
                                webNavigationDrawerConfirmation.open()
                            }
                            contentComponent: webNavigationDrawerContent
                        }
                        Component {
                            id: webNavigationDrawerContent
                \x20\x20\x20\x20\x20\x20\x20\x20
                            EText {
                                width: parent.width
                                wrapMode: Text.WordWrap
                                text: ELocale.texts.ContentIsDestroyedAfterClosingAndRecreatedWhen
                            }
                        }
                        EDialog {
                            id: webNavigationDrawerConfirmation
                \x20\x20\x20\x20\x20\x20\x20\x20
                            property var complete: null
                \x20\x20\x20\x20\x20\x20\x20\x20
                            title: ELocale.texts.ConfirmClose
                            text: ELocale.texts.CloseTheCurrentPanel
                \x20\x20\x20\x20\x20\x20\x20\x20
                            onAccepted: {
                                if (complete)
                                    complete()
                                complete = null
                            }
                            onRejected: {
                                if (complete)
                                    complete(true)
                                complete = null
                            }
                        }
                    }
                }
            `)

            EButton {
                text: ELocale.texts.OpenDrawer

                onClicked: webNavigationDrawer.open()
            }
            EDrawer {
                id: webNavigationDrawer

                resizable: true
                destroyOnClose: true
                title: ELocale.texts.ConfirmBeforeClosing
                contentComponent: webNavigationDrawerContent
                beforeClose: function(done) {
                    webNavigationDrawerConfirmation.complete = done
                    webNavigationDrawerConfirmation.open()
                }
            }
            Component {
                id: webNavigationDrawerContent

                EText {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: ELocale.texts.ContentIsDestroyedAfterClosingAndRecreatedWhen
                }
            }
            EDialog {
                id: webNavigationDrawerConfirmation

                property var complete: null

                title: ELocale.texts.ConfirmClose
                text: ELocale.texts.CloseTheCurrentPanel

                onAccepted: {
                    if (complete)
                        complete()
                    complete = null
                }
                onRejected: {
                    if (complete)
                        complete(true)
                    complete = null
                }
            }
        }
    }
    ExampleSection {
        componentName: "ELoading"

        ExampleCase {
            title: ELocale.texts.LoadingOverATarget
            description: ELocale.texts.TheMaskBlocksPointerAndWheelInputWithin
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

                        ERectangle {
                            id: webNavigationLoadingTarget
                \x20\x20\x20\x20\x20\x20\x20\x20
                            radius: 8
                            height: 140
                            width: parent.width
                            color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
                \x20\x20\x20\x20\x20\x20\x20\x20
                            EButton {
                                anchors.centerIn: parent
                                text: ELocale.texts.StartTask
                \x20\x20\x20\x20\x20\x20\x20\x20
                                onClicked: webNavigationTaskTimer.restart()
                            }
                        }
                        ELoading {
                            target: webNavigationLoadingTarget
                            loading: webNavigationTaskTimer.running
                            text: ELocale.texts.Working
                            backgroundColor: ETheme.dark ? Qt.rgba(0.1, 0.12, 0.16, 0.85) : Qt.rgba(1, 1, 1, 0.85)
                        }
                        Timer {
                            id: webNavigationTaskTimer
                \x20\x20\x20\x20\x20\x20\x20\x20
                            interval: 1800
                        }
                    }
                }
            `)

            ERectangle {
                id: webNavigationLoadingTarget

                radius: 8
                height: 140
                width: parent.width
                color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)

                EButton {
                    anchors.centerIn: parent
                    text: ELocale.texts.StartTask

                    onClicked: webNavigationTaskTimer.restart()
                }
            }
            ELoading {
                text: ELocale.texts.Working
                target: webNavigationLoadingTarget
                loading: webNavigationTaskTimer.running
                backgroundColor: ETheme.dark ? Qt.rgba(0.1, 0.12, 0.16, 0.85) : Qt.rgba(1, 1, 1, 0.85)
            }
            Timer {
                id: webNavigationTaskTimer

                interval: 1800
            }
        }
    }
}

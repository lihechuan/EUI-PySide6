import EUI 1.0
import QtQuick 2.15

ExamplePage {
    title: ELocale.texts.FeedbackAndOverlays
    description: ELocale.texts.ProvidesAConsistentElementPlusFeedbackExperience

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
        componentName: "EAlert"

        ExampleCard {
            code: exampleData.samples.OverlayExamplesSample0
            description: ELocale.texts.InlineAlertsSupportMultipleStatesDetailedDescriptions

            EAlert {
                width: parent.width
                styleType: EStyle.Success
                title: ELocale.texts.SavedSuccessfully
                description: ELocale.texts.YourChangesHaveBeenSavedToThe
            }
            EAlert {
                closable: false
                width: parent.width
                styleType: EStyle.Warning
                title: ELocale.texts.ReviewTheSettingsBeforeContinuing
            }
        }
    }
    ExampleSection {
        componentName: "EDialog"

        ExampleCard {
            code: exampleData.samples.OverlayExamplesSample1
            description: ELocale.texts.ModalDialogsSupportConfirmationCancellationAClose

            EButton {
                text: ELocale.texts.OpenDialog

                onClicked: dialog.open()
            }
            EText {
                id: dialogResult

                font.pixelSize: 14
                text: ELocale.texts.WaitingForAnAction
                color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
            }
            EDialog {
                id: dialog

                title: ELocale.texts.SaveChanges2
                text: ELocale.texts.SaveYourCurrentChangesYouCanContinue

                onRejected: dialogResult.text = ELocale.texts.Canceled
                onAccepted: dialogResult.text = ELocale.texts.SaveConfirmed
            }
        }
    }
    ExampleSection {
        componentName: "EDrawer"

        ExampleCard {
            code: exampleData.samples.OverlayExamplesSample2
            description: ELocale.texts.SideDrawersDisplaySupplementaryContentAndSupport

            EButton {
                text: ELocale.texts.OpenDrawer

                onClicked: drawer.open()
            }
            EDrawer {
                id: drawer

                title: ELocale.texts.ProjectDetails

                Column {
                    spacing: 20
                    width: parent.width

                    EText {
                        font.pixelSize: 14
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.ViewTheProjectStatusOrChangeSettings
                        color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                    }
                    EInput {
                        width: parent.width
                        placeholderText: ELocale.texts.EnterAProjectName
                    }
                    EButton {
                        text: ELocale.texts.Done
                        styleType: EStyle.Primary

                        onClicked: drawer.close()
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EPopover"

        ExampleCard {
            code: exampleData.samples.OverlayExamplesSample3
            description: ELocale.texts.ClickTheReferenceButtonToViewDetails

            EButton {
                id: popoverButton

                text: ELocale.texts.ViewDetails
            }
            EPopover {
                reference: popoverButton
                title: ELocale.texts.ComponentDetails
                text: ELocale.texts.SupportsPlainTextAndCustomContentWith
            }
        }
    }
    ExampleSection {
        componentName: "EPopconfirm"

        ExampleCard {
            code: exampleData.samples.OverlayExamplesSample4
            description: ELocale.texts.ConfirmAnActionNextToItsTrigger

            EButton {
                id: deleteButton

                styleType: EStyle.Danger
                text: ELocale.texts.DeleteProject
            }
            EText {
                id: confirmResult

                font.pixelSize: 14
                text: ELocale.texts.WaitingForConfirmation
                color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
            }
            EPopconfirm {
                reference: deleteButton
                confirmStyleType: EStyle.Danger
                text: ELocale.texts.DeleteThisProject

                onCanceled: confirmResult.text = ELocale.texts.DeletionCanceled
                onConfirmed: confirmResult.text = ELocale.texts.DeletionConfirmed
            }
        }
    }
    ExampleSection {
        componentName: "ENotification"

        ExampleCard {
            code: exampleData.samples.OverlayExamplesSample5
            description: ELocale.texts.NotificationsAppearFromTheCornerOfThe

            Row {
                spacing: 12

                EButton {
                    text: ELocale.texts.ShowNotification

                    onClicked: notification.open({ title: ELocale.texts.Saved, message: ELocale.texts.YourProjectHasBeenSavedYouCan, type: EStyle.Success })
                }
                EButton {
                    text: ELocale.texts.ClearAll

                    onClicked: notification.clear()
                }
            }
            ENotification {
                id: notification

                grouping: true
            }
        }
    }
    OverlayShowcase { }
    PrimeShowcase { names: ["EDialog"] }
}

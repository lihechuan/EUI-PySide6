import EUI 1.0
import QtQuick 2.15

Column {
    spacing: 24
    width: parent.width

    ExampleSection {
        componentName: "EAlert"

        ExampleCase {
            objectName: "showcaseEAlert0"
            title: ELocale.texts.SemanticFeedback
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    EAlert {
                        showIcon: true
                        styleType: EStyle.Primary
                        title: ELocale.texts.ProjectStatus
                        width: Math.min(360, parent.width)
                        description: ELocale.texts.ThisExampleShowsFeedbackMessagesInDifferentSemantic
                    }
                    EAlert {
                        showIcon: true
                        styleType: EStyle.Success
                        title: ELocale.texts.ProjectStatus
                        width: Math.min(360, parent.width)
                        description: ELocale.texts.ThisExampleShowsFeedbackMessagesInDifferentSemantic
                    }
                    EAlert {
                        showIcon: true
                        styleType: EStyle.Warning
                        title: ELocale.texts.ProjectStatus
                        width: Math.min(360, parent.width)
                        description: ELocale.texts.ThisExampleShowsFeedbackMessagesInDifferentSemantic
                    }
                    EAlert {
                        showIcon: true
                        styleType: EStyle.Danger
                        title: ELocale.texts.ProjectStatus
                        width: Math.min(360, parent.width)
                        description: ELocale.texts.ThisExampleShowsFeedbackMessagesInDifferentSemantic
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                EAlert {
                    showIcon: true
                    styleType: EStyle.Primary
                    title: ELocale.texts.ProjectStatus
                    width: Math.min(360, parent.width)
                    description: ELocale.texts.ThisExampleShowsFeedbackMessagesInDifferentSemantic
                }
                EAlert {
                    showIcon: true
                    styleType: EStyle.Success
                    title: ELocale.texts.ProjectStatus
                    width: Math.min(360, parent.width)
                    description: ELocale.texts.ThisExampleShowsFeedbackMessagesInDifferentSemantic
                }
                EAlert {
                    showIcon: true
                    styleType: EStyle.Warning
                    title: ELocale.texts.ProjectStatus
                    width: Math.min(360, parent.width)
                    description: ELocale.texts.ThisExampleShowsFeedbackMessagesInDifferentSemantic
                }
                EAlert {
                    showIcon: true
                    styleType: EStyle.Danger
                    title: ELocale.texts.ProjectStatus
                    width: Math.min(360, parent.width)
                    description: ELocale.texts.ThisExampleShowsFeedbackMessagesInDifferentSemantic
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAlert"

        ExampleCase {
            title: ELocale.texts.Effects
            objectName: "showcaseEAlert1"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    EAlert {
                        showIcon: true
                        effect: "light"
                        title: ELocale.texts.ProjectStatus
                        width: Math.min(360, parent.width)
                        description: ELocale.texts.ThisExampleShowsFeedbackMessagesInDifferentSemantic
                    }
                    EAlert {
                        effect: "dark"
                        showIcon: true
                        title: ELocale.texts.ProjectStatus
                        width: Math.min(360, parent.width)
                        description: ELocale.texts.ThisExampleShowsFeedbackMessagesInDifferentSemantic
                    }
                    EAlert {
                        showIcon: true
                        effect: "plain"
                        title: ELocale.texts.ProjectStatus
                        width: Math.min(360, parent.width)
                        description: ELocale.texts.ThisExampleShowsFeedbackMessagesInDifferentSemantic
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                EAlert {
                    showIcon: true
                    effect: "light"
                    title: ELocale.texts.ProjectStatus
                    width: Math.min(360, parent.width)
                    description: ELocale.texts.ThisExampleShowsFeedbackMessagesInDifferentSemantic
                }
                EAlert {
                    effect: "dark"
                    showIcon: true
                    title: ELocale.texts.ProjectStatus
                    width: Math.min(360, parent.width)
                    description: ELocale.texts.ThisExampleShowsFeedbackMessagesInDifferentSemantic
                }
                EAlert {
                    showIcon: true
                    effect: "plain"
                    title: ELocale.texts.ProjectStatus
                    width: Math.min(360, parent.width)
                    description: ELocale.texts.ThisExampleShowsFeedbackMessagesInDifferentSemantic
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAlert"

        ExampleCase {
            objectName: "showcaseEAlert2"
            title: ELocale.texts.CenteredCloseAction
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EAlert {
                    center: true
                    closable: true
                    showIcon: true
                    closeText: ELocale.texts.GotIt
                    title: ELocale.texts.UpdateReady
                    width: Math.min(480, parent.width)
                    description: ELocale.texts.ClickTheTextOnTheRightToDismiss
                }
            `)

            EAlert {
                center: true
                closable: true
                showIcon: true
                closeText: ELocale.texts.GotIt
                title: ELocale.texts.UpdateReady
                width: Math.min(480, parent.width)
                description: ELocale.texts.ClickTheTextOnTheRightToDismiss
            }
        }
    }
    ExampleSection {
        componentName: "EAlert"

        ExampleCase {
            objectName: "showcaseEAlert3"
            title: ELocale.texts.PersistentAnnouncement
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EAlert {
                    showIcon: true
                    closable: false
                    styleType: EStyle.Info
                    width: Math.min(480, parent.width)
                    title: ELocale.texts.ReadOnlyAnnouncement
                    description: ELocale.texts.ImportantInformationCanRemainVisible
                }
            `)

            EAlert {
                showIcon: true
                closable: false
                styleType: EStyle.Info
                width: Math.min(480, parent.width)
                title: ELocale.texts.ReadOnlyAnnouncement
                description: ELocale.texts.ImportantInformationCanRemainVisible
            }
        }
    }
    ExampleSection {
        componentName: "EDrawer"

        ExampleCase {
            objectName: "showcaseEDrawer0"
            title: ELocale.texts.LeftDrawer
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        text: ELocale.texts.OpenDrawer

                        onClicked: panel.open()
                    }
                    EDrawer {
                        id: panel

                        drawerSize: 360
                        edge: Qt.LeftEdge
                        title: ELocale.texts.ProjectDetails

                        Column {
                            spacing: 16
                            width: parent.width

                            EText {
                                width: parent.width
                                wrapMode: Text.WordWrap
                                text: ELocale.texts.WorkWithProjectContentInTheDrawer
                            }
                            EInput {
                                width: parent.width
                                placeholderText: ELocale.texts.ProjectName
                            }
                            EButton {
                                text: ELocale.texts.Done
                                styleType: EStyle.Primary

                                onClicked: panel.close()
                            }
                        }
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EButton {
                    text: ELocale.texts.OpenDrawer

                    onClicked: panel.open()
                }
                EDrawer {
                    id: panel

                    drawerSize: 360
                    edge: Qt.LeftEdge
                    title: ELocale.texts.ProjectDetails

                    Column {
                        spacing: 16
                        width: parent.width

                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.WorkWithProjectContentInTheDrawer
                        }
                        EInput {
                            width: parent.width
                            placeholderText: ELocale.texts.ProjectName
                        }
                        EButton {
                            text: ELocale.texts.Done
                            styleType: EStyle.Primary

                            onClicked: panel.close()
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EDrawer"

        ExampleCase {
            objectName: "showcaseEDrawer1"
            title: ELocale.texts.BottomDrawer
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        text: ELocale.texts.OpenDrawer

                        onClicked: panel.open()
                    }
                    EDrawer {
                        id: panel

                        drawerSize: "45%"
                        edge: Qt.BottomEdge
                        title: ELocale.texts.ProjectDetails

                        Column {
                            spacing: 16
                            width: parent.width

                            EText {
                                width: parent.width
                                wrapMode: Text.WordWrap
                                text: ELocale.texts.WorkWithProjectContentInTheDrawer
                            }
                            EInput {
                                width: parent.width
                                placeholderText: ELocale.texts.ProjectName
                            }
                            EButton {
                                text: ELocale.texts.Done
                                styleType: EStyle.Primary

                                onClicked: panel.close()
                            }
                        }
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EButton {
                    text: ELocale.texts.OpenDrawer

                    onClicked: panel.open()
                }
                EDrawer {
                    id: panel

                    drawerSize: "45%"
                    edge: Qt.BottomEdge
                    title: ELocale.texts.ProjectDetails

                    Column {
                        spacing: 16
                        width: parent.width

                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.WorkWithProjectContentInTheDrawer
                        }
                        EInput {
                            width: parent.width
                            placeholderText: ELocale.texts.ProjectName
                        }
                        EButton {
                            text: ELocale.texts.Done
                            styleType: EStyle.Primary

                            onClicked: panel.close()
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EDrawer"

        ExampleCase {
            objectName: "showcaseEDrawer2"
            title: ELocale.texts.ResizableDrawerFooter
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        text: ELocale.texts.OpenResizableDrawer

                        onClicked: panel.open()
                    }
                    EDrawer {
                        id: panel

                        resizable: true
                        minimumSize: 240
                        drawerSize: "40%"
                        title: ELocale.texts.ProjectDetails2
                        footerComponent: Component {
                            EButton {
                                text: ELocale.texts.Done

                                onClicked: panel.close()
                            }
                        }

                        EText {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: ELocale.texts.DragTheDrawerEdgeToResizeIt
                        }
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EButton {
                    text: ELocale.texts.OpenResizableDrawer

                    onClicked: panel.open()
                }
                EDrawer {
                    id: panel

                    resizable: true
                    minimumSize: 240
                    drawerSize: "40%"
                    title: ELocale.texts.ProjectDetails2
                    footerComponent: Component {
                        EButton {
                            text: ELocale.texts.Done

                            onClicked: panel.close()
                        }
                    }

                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.DragTheDrawerEdgeToResizeIt
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EDialog"

        ExampleCase {
            objectName: "showcaseEDialog0"
            title: ELocale.texts.DialogActions
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        text: ELocale.texts.OpenDialog

                        onClicked: panel.open()
                    }
                    EDialog {
                        id: panel

                        center: true
                        cancelText: ELocale.texts.Back
                        title: ELocale.texts.ProjectSettings
                        confirmText: ELocale.texts.CoreSampleSave
                        text: ELocale.texts.AdjustTheProjectSettingsBeforeContinuing
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EButton {
                    text: ELocale.texts.OpenDialog

                    onClicked: panel.open()
                }
                EDialog {
                    id: panel

                    center: true
                    cancelText: ELocale.texts.Back
                    title: ELocale.texts.ProjectSettings
                    confirmText: ELocale.texts.CoreSampleSave
                    text: ELocale.texts.AdjustTheProjectSettingsBeforeContinuing
                }
            }
        }
    }
    ExampleSection {
        componentName: "EDialog"

        ExampleCase {
            objectName: "showcaseEDialog1"
            title: ELocale.texts.ModelessDialog
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        text: ELocale.texts.OpenDialog

                        onClicked: panel.open()
                    }
                    EDialog {
                        id: panel

                        modal: false
                        draggable: true
                        showFooter: false
                        title: ELocale.texts.ProjectSettings
                        text: ELocale.texts.AdjustTheProjectSettingsBeforeContinuing
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EButton {
                    text: ELocale.texts.OpenDialog

                    onClicked: panel.open()
                }
                EDialog {
                    id: panel

                    modal: false
                    draggable: true
                    showFooter: false
                    title: ELocale.texts.ProjectSettings
                    text: ELocale.texts.AdjustTheProjectSettingsBeforeContinuing
                }
            }
        }
    }
    ExampleSection {
        componentName: "EDialog"

        ExampleCase {
            objectName: "showcaseEDialog2"
            title: ELocale.texts.FullscreenDialog
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        text: ELocale.texts.OpenFullscreenDialog

                        onClicked: panel.open()
                    }
                    EDialog {
                        id: panel

                        fullscreen: true
                        title: ELocale.texts.FullscreenWorkspace
                        text: ELocale.texts.AnEditingPanelSuitableForLargerAmountsOf
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EButton {
                    text: ELocale.texts.OpenFullscreenDialog

                    onClicked: panel.open()
                }
                EDialog {
                    id: panel

                    fullscreen: true
                    title: ELocale.texts.FullscreenWorkspace
                    text: ELocale.texts.AnEditingPanelSuitableForLargerAmountsOf
                }
            }
        }
    }
    ExampleSection {
        componentName: "EPopover"

        ExampleCase {
            objectName: "showcaseEPopover0"
            title: ELocale.texts.PopupPlacement
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        id: target

                        text: ELocale.texts.ShowHint
                    }
                    EPopover {
                        id: panel

                        reference: target
                        placement: EPlacement.Right
                        title: ELocale.texts.ProjectActions
                        text: ELocale.texts.ThisActionAppliesToTheCurrentProject
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EButton {
                    id: target

                    text: ELocale.texts.ShowHint
                }
                EPopover {
                    id: panel

                    reference: target
                    placement: EPlacement.Right
                    title: ELocale.texts.ProjectActions
                    text: ELocale.texts.ThisActionAppliesToTheCurrentProject
                }
            }
        }
    }
    ExampleSection {
        componentName: "EPopover"

        ExampleCase {
            objectName: "showcaseEPopover1"
            title: ELocale.texts.HoverDelays
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        id: target

                        text: ELocale.texts.ShowHint
                    }
                    EPopover {
                        id: panel

                        hideAfter: 200
                        showAfter: 300
                        trigger: "hover"
                        reference: target
                        title: ELocale.texts.ProjectActions
                        text: ELocale.texts.ThisActionAppliesToTheCurrentProject
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EButton {
                    id: target

                    text: ELocale.texts.ShowHint
                }
                EPopover {
                    id: panel

                    hideAfter: 200
                    showAfter: 300
                    trigger: "hover"
                    reference: target
                    title: ELocale.texts.ProjectActions
                    text: ELocale.texts.ThisActionAppliesToTheCurrentProject
                }
            }
        }
    }
    ExampleSection {
        componentName: "EPopover"

        ExampleCase {
            objectName: "showcaseEPopover2"
            title: ELocale.texts.ArrowAndEffect
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        id: target

                        text: ELocale.texts.ShowHint
                    }
                    EPopover {
                        id: panel

                        effect: "dark"
                        showArrow: false
                        reference: target
                        title: ELocale.texts.ProjectActions
                        text: ELocale.texts.ThisActionAppliesToTheCurrentProject
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EButton {
                    id: target

                    text: ELocale.texts.ShowHint
                }
                EPopover {
                    id: panel

                    effect: "dark"
                    showArrow: false
                    reference: target
                    title: ELocale.texts.ProjectActions
                    text: ELocale.texts.ThisActionAppliesToTheCurrentProject
                }
            }
        }
    }
    ExampleSection {
        componentName: "EPopover"

        ExampleCase {
            objectName: "showcaseEPopover3"
            title: ELocale.texts.ManualPopup
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        id: target

                        text: ELocale.texts.ShowHint

                        onClicked: panel.open()
                    }
                    EPopover {
                        id: panel

                        reference: target
                        trigger: "manual"
                        title: ELocale.texts.ProjectActions
                        text: ELocale.texts.ThisActionAppliesToTheCurrentProject
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EButton {
                    id: target

                    text: ELocale.texts.ShowHint

                    onClicked: panel.open()
                }
                EPopover {
                    id: panel

                    reference: target
                    trigger: "manual"
                    title: ELocale.texts.ProjectActions
                    text: ELocale.texts.ThisActionAppliesToTheCurrentProject
                }
            }
        }
    }
    ExampleSection {
        componentName: "EPopconfirm"

        ExampleCase {
            objectName: "showcaseEPopconfirm0"
            title: ELocale.texts.PopupPlacement
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        id: target

                        text: ELocale.texts.ShowHint
                    }
                    EPopconfirm {
                        id: panel

                        reference: target
                        placement: EPlacement.Right
                        title: ELocale.texts.ProjectActions
                        text: ELocale.texts.ThisActionAppliesToTheCurrentProject
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EButton {
                    id: target

                    text: ELocale.texts.ShowHint
                }
                EPopconfirm {
                    id: panel

                    reference: target
                    placement: EPlacement.Right
                    title: ELocale.texts.ProjectActions
                    text: ELocale.texts.ThisActionAppliesToTheCurrentProject
                }
            }
        }
    }
    ExampleSection {
        componentName: "EPopconfirm"

        ExampleCase {
            title: ELocale.texts.HoverDelays
            objectName: "showcaseEPopconfirm1"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        id: target

                        text: ELocale.texts.ShowHint
                    }
                    EPopconfirm {
                        id: panel

                        hideAfter: 200
                        showAfter: 300
                        trigger: "hover"
                        reference: target
                        title: ELocale.texts.ProjectActions
                        text: ELocale.texts.ThisActionAppliesToTheCurrentProject
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EButton {
                    id: target

                    text: ELocale.texts.ShowHint
                }
                EPopconfirm {
                    id: panel

                    hideAfter: 200
                    showAfter: 300
                    trigger: "hover"
                    reference: target
                    title: ELocale.texts.ProjectActions
                    text: ELocale.texts.ThisActionAppliesToTheCurrentProject
                }
            }
        }
    }
    ExampleSection {
        componentName: "EPopconfirm"

        ExampleCase {
            objectName: "showcaseEPopconfirm2"
            title: ELocale.texts.ArrowAndEffect
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        id: target

                        text: ELocale.texts.ShowHint
                    }
                    EPopconfirm {
                        id: panel

                        effect: "dark"
                        showArrow: false
                        reference: target
                        title: ELocale.texts.ProjectActions
                        text: ELocale.texts.ThisActionAppliesToTheCurrentProject
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EButton {
                    id: target

                    text: ELocale.texts.ShowHint
                }
                EPopconfirm {
                    id: panel

                    effect: "dark"
                    showArrow: false
                    reference: target
                    title: ELocale.texts.ProjectActions
                    text: ELocale.texts.ThisActionAppliesToTheCurrentProject
                }
            }
        }
    }
    ExampleSection {
        componentName: "EPopconfirm"

        ExampleCase {
            title: ELocale.texts.ManualPopup
            objectName: "showcaseEPopconfirm3"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        id: target

                        text: ELocale.texts.ShowHint

                        onClicked: panel.open()
                    }
                    EPopconfirm {
                        id: panel

                        reference: target
                        trigger: "manual"
                        title: ELocale.texts.ProjectActions
                        text: ELocale.texts.ThisActionAppliesToTheCurrentProject
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EButton {
                    id: target

                    text: ELocale.texts.ShowHint

                    onClicked: panel.open()
                }
                EPopconfirm {
                    id: panel

                    reference: target
                    trigger: "manual"
                    title: ELocale.texts.ProjectActions
                    text: ELocale.texts.ThisActionAppliesToTheCurrentProject
                }
            }
        }
    }
    ExampleSection {
        componentName: "ENotification"

        ExampleCase {
            objectName: "showcaseENotification0"
            title: ELocale.texts.SemanticNotification
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    Flow {
                        spacing: 16
                        width: parent.width

                        EButton {
                            text: ELocale.texts.ShowNotification

                            onClicked: messages.open({message: ELocale.texts.TheProjectHasBeenUpdated2, title: ELocale.texts.ProjectNotification, styleType: EStyle.Success})
                        }
                        EButton {
                            text: ELocale.texts.ClearNotifications

                            onClicked: messages.closeAll()
                        }
                    }
                    ENotification {
                        id: messages
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                Flow {
                    spacing: 16
                    width: parent.width

                    EButton {
                        text: ELocale.texts.ShowNotification

                        onClicked: messages.open({message: ELocale.texts.TheProjectHasBeenUpdated2, title: ELocale.texts.ProjectNotification, styleType: EStyle.Success})
                    }
                    EButton {
                        text: ELocale.texts.ClearNotifications

                        onClicked: messages.closeAll()
                    }
                }
                ENotification {
                    id: messages
                }
            }
        }
    }
    ExampleSection {
        componentName: "ENotification"

        ExampleCase {
            objectName: "showcaseENotification1"
            title: ELocale.texts.PlacementAndDuration
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    Flow {
                        spacing: 16
                        width: parent.width

                        EButton {
                            text: ELocale.texts.ShowNotification

                            onClicked: messages.open({message: ELocale.texts.TheProjectHasBeenUpdated2, title: ELocale.texts.ProjectNotification, styleType: EStyle.Warning})
                        }
                        EButton {
                            text: ELocale.texts.ClearNotifications

                            onClicked: messages.closeAll()
                        }
                    }
                    ENotification {
                        id: messages

                        duration: 1500
                        placement: EPlacement.BottomRight
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                Flow {
                    spacing: 16
                    width: parent.width

                    EButton {
                        text: ELocale.texts.ShowNotification

                        onClicked: messages.open({message: ELocale.texts.TheProjectHasBeenUpdated2, title: ELocale.texts.ProjectNotification, styleType: EStyle.Warning})
                    }
                    EButton {
                        text: ELocale.texts.ClearNotifications

                        onClicked: messages.closeAll()
                    }
                }
                ENotification {
                    id: messages

                    duration: 1500
                    placement: EPlacement.BottomRight
                }
            }
        }
    }
    ExampleSection {
        componentName: "ENotification"

        ExampleCase {
            objectName: "showcaseENotification2"
            title: ELocale.texts.GroupedNotifications
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    Flow {
                        spacing: 16
                        width: parent.width

                        EButton {
                            text: ELocale.texts.ShowNotification

                            onClicked: messages.open({message: ELocale.texts.TheProjectHasBeenUpdated2, title: ELocale.texts.ProjectNotification, styleType: EStyle.Info})
                        }
                        EButton {
                            text: ELocale.texts.ClearNotifications

                            onClicked: messages.closeAll()
                        }
                    }
                    ENotification {
                        id: messages

                        grouping: true
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                Flow {
                    spacing: 16
                    width: parent.width

                    EButton {
                        text: ELocale.texts.ShowNotification

                        onClicked: messages.open({message: ELocale.texts.TheProjectHasBeenUpdated2, title: ELocale.texts.ProjectNotification, styleType: EStyle.Info})
                    }
                    EButton {
                        text: ELocale.texts.ClearNotifications

                        onClicked: messages.closeAll()
                    }
                }
                ENotification {
                    id: messages

                    grouping: true
                }
            }
        }
    }
    ExampleSection {
        componentName: "ENotification"

        ExampleCase {
            objectName: "showcaseENotification3"
            title: ELocale.texts.PersistentNotifications
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    Flow {
                        spacing: 16
                        width: parent.width

                        EButton {
                            text: ELocale.texts.ShowNotification

                            onClicked: messages.open({message: ELocale.texts.TheProjectHasBeenUpdated2, title: ELocale.texts.ProjectNotification, styleType: EStyle.Primary})
                        }
                        EButton {
                            text: ELocale.texts.ClearNotifications

                            onClicked: messages.closeAll()
                        }
                    }
                    ENotification {
                        id: messages

                        duration: 0
                        showClose: true
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                Flow {
                    spacing: 16
                    width: parent.width

                    EButton {
                        text: ELocale.texts.ShowNotification

                        onClicked: messages.open({message: ELocale.texts.TheProjectHasBeenUpdated2, title: ELocale.texts.ProjectNotification, styleType: EStyle.Primary})
                    }
                    EButton {
                        text: ELocale.texts.ClearNotifications

                        onClicked: messages.closeAll()
                    }
                }
                ENotification {
                    id: messages

                    duration: 0
                    showClose: true
                }
            }
        }
    }
}

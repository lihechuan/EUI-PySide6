import EUI 1.0
import QtQuick 2.15

Column {
    spacing: 24
    width: parent.width

    ExampleSection {
        componentName: "EMessageBox"

        ExampleCase {
            title: ELocale.texts.AlertMessage
            objectName: "showcaseEMessageBox0"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        text: ELocale.texts.OpenMessageBox

                        onClicked: panel.alert(ELocale.texts.TheProjectHasBeenSaved, ELocale.texts.Done)
                    }
                    EMessageBox {
                        id: panel
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

                EButton {
                    text: ELocale.texts.OpenMessageBox

                    onClicked: panel.alert(ELocale.texts.TheProjectHasBeenSaved, ELocale.texts.Done)
                }
                EMessageBox {
                    id: panel
                }
                EText {
                    id: result

                    text: ELocale.texts.WaitingForAnAction
                }
            }
        }
    }
    ExampleSection {
        componentName: "EMessageBox"

        ExampleCase {
            objectName: "showcaseEMessageBox1"
            title: ELocale.texts.ConfirmationResult
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        text: ELocale.texts.OpenMessageBox

                        onClicked: panel.confirm(ELocale.texts.ContinueTheCurrentAction, ELocale.texts.Confirm2)
                    }
                    EMessageBox {
                        id: panel

                        onCompleted: result.text = action
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

                EButton {
                    text: ELocale.texts.OpenMessageBox

                    onClicked: panel.confirm(ELocale.texts.ContinueTheCurrentAction, ELocale.texts.Confirm2)
                }
                EMessageBox {
                    id: panel

                    onCompleted: result.text = action
                }
                EText {
                    id: result

                    text: ELocale.texts.WaitingForAnAction
                }
            }
        }
    }
    ExampleSection {
        componentName: "EMessageBox"

        ExampleCase {
            objectName: "showcaseEMessageBox2"
            title: ELocale.texts.PromptValidation
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        text: ELocale.texts.OpenMessageBox

                        onClicked: panel.prompt(ELocale.texts.EnterAProjectName, ELocale.texts.NewProject, "EUI")
                    }
                    EMessageBox {
                        id: panel

                        inputPattern: /^.{3,20}$/
                        inputErrorMessage: ELocale.texts.Enter3To20Characters

                        onConfirmed: result.text = value
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

                EButton {
                    text: ELocale.texts.OpenMessageBox

                    onClicked: panel.prompt(ELocale.texts.EnterAProjectName, ELocale.texts.NewProject, "EUI")
                }
                EMessageBox {
                    id: panel

                    inputPattern: /^.{3,20}$/
                    inputErrorMessage: ELocale.texts.Enter3To20Characters

                    onConfirmed: result.text = value
                }
                EText {
                    id: result

                    text: ELocale.texts.WaitingForAnAction
                }
            }
        }
    }
    ExampleSection {
        componentName: "EMessageBox"

        ExampleCase {
            objectName: "showcaseEMessageBox3"
            title: ELocale.texts.StyledConfirmation
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        text: ELocale.texts.OpenMessageBox

                        onClicked: panel.confirm(ELocale.texts.ReadyToPublishTheProject, ELocale.texts.Publish)
                    }
                    EMessageBox {
                        id: panel

                        roundButton: true
                        styleType: EStyle.Success
                        confirmStyleType: EStyle.Success
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

                EButton {
                    text: ELocale.texts.OpenMessageBox

                    onClicked: panel.confirm(ELocale.texts.ReadyToPublishTheProject, ELocale.texts.Publish)
                }
                EMessageBox {
                    id: panel

                    roundButton: true
                    styleType: EStyle.Success
                    confirmStyleType: EStyle.Success
                }
                EText {
                    id: result

                    text: ELocale.texts.WaitingForAnAction
                }
            }
        }
    }
}

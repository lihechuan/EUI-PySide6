import EUI 1.0
import QtQuick 2.15

ExamplePage {
    title: ELocale.texts.MessageConfirmation
    description: ELocale.texts.UseMessageBoxesToConfirmDecisionsOr

    ExampleSection {
        componentName: "EMessageBox"

        ExampleCard {
            code: exampleData.samples.ExtendedFeedbackExamplesSample0
            description: ELocale.texts.ConfirmationAndPromptModesShareTheSame

            Row {
                spacing: 12

                EButton {
                    text: ELocale.texts.ConfirmAction

                    onClicked: messageBox.confirm(
                        ELocale.texts.SaveTheCurrentChanges,
                        ELocale.texts.SaveChanges
                    )
                }
                EButton {
                    text: ELocale.texts.EnterAName

                    onClicked: messageBox.prompt(
                        ELocale.texts.EnterANameWithAtLeastThree,
                        ELocale.texts.NewProject,
                        ""
                    )
                }
            }
            EText {
                id: boxResult

                font.pixelSize: 14
                text: ELocale.texts.WaitingForAnAction
                color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
            }
            EMessageBox {
                id: messageBox

                inputPlaceholder: ELocale.texts.ProjectName
                inputValidator: function(value) {
                    return value.trim().length >= 3 || ELocale.texts.TheNameMustContainAtLeastThree
                }

                onCanceled: boxResult.text = ELocale.texts.Canceled
                onConfirmed: boxResult.text = showInput ? ELocale.texts.ProjectName2 + value
                    : ELocale.texts.SaveConfirmed
            }
        }
    }
    ExtendedFeedbackShowcase { }
}

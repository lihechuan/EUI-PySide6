import EUI 1.0
import QtQuick 2.15

ExamplePage {
    id: page

    property var account: ({
        "name": "",
        "email": ""
    })

    title: ELocale.texts.FormComponents
    description: ELocale.texts.SelectionTextAndNumberInputsSlidersSwitches

    ExampleSection {
        componentName: "EForm"

        ExampleCard {
            description: ELocale.texts.DecimalAndTypedValuesParticipateInModelValidation
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    EForm {
                        id: form

                        width: parent.width
                        model: ({amount: 1.25})

                        onSubmitted: console.log(valid, model.amount)

                        EFormItem {
                            prop: "amount"
                            required: true
                            width: parent.width
                            label: ELocale.texts.Amount
                            rules: [{type: "number", min: 0.25, max: 10}]
                            labelComponent: Component {
                                EText {
                                    font.bold: true
                                    text: parent.label
                                }
                            }
                            errorComponent: Component {
                                EText {
                                    text: parent.message
                                    color: EPaletteManager.StatePalette.validationColor(EValidationState.Error)
                                }
                            }

                            ESpinBox {
                                numberTo: 10
                                precision: 2
                                editable: true
                                numberStep: 0.25
                                numberValue: 1.25
                            }
                        }
                    }
                    EButton {
                        text: ELocale.texts.ValidateSubmission

                        onClicked: form.submit()
                    }
                }
`)

            Column {
                spacing: 12
                width: parent.width

                EForm {
                    id: webFormModel

                    width: parent.width
                    model: ({amount: 1.25})
                    objectName: "webFormModel"

                    onSubmitted: webFormSubmitStatus.text = valid
                        ? ELocale.texts.ValidatedSubmittedSignalEmitted
                        : ELocale.texts.CheckTheField

                    EFormItem {
                        prop: "amount"
                        required: true
                        width: parent.width
                        label: ELocale.texts.Amount
                        rules: [{type: "number", min: 0.25, max: 10}]
                        labelComponent: Component {
                            EText {
                                font.bold: true
                                text: parent.label
                            }
                        }
                        errorComponent: Component {
                            EText {
                                text: parent.message
                                color: EPaletteManager.StatePalette.validationColor(EValidationState.Error)
                            }
                        }

                        ESpinBox {
                            numberTo: 10
                            precision: 2
                            editable: true
                            numberStep: 0.25
                            numberValue: 1.25
                        }
                    }
                }
                EButton {
                    text: ELocale.texts.ValidateSubmission

                    onClicked: webFormModel.submit()
                }
                EText {
                    id: webFormSubmitStatus

                    width: parent.width
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECheckBox"

        ExampleCard {
            description: ELocale.texts.MapBooleanChecksToStringsNumbersOrObjects
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    ECheckBox {
                        value: "no"
                        falseValue: "no"
                        trueValue: "yes"
                        text: ELocale.texts.ReceiveNotifications
                    }
                }
`)

            ECheckBox {
                value: "no"
                falseValue: "no"
                trueValue: "yes"
                borderVisible: false
                text: ELocale.texts.ReceiveNotifications
            }
        }
    }
    ExampleSection {
        componentName: "ESwitch"

        ExampleCard {
            description: ELocale.texts.SynchronousOrAsynchronousGuardsRunBeforeAChange
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    ESwitch {
                        value: "off"
                        activeValue: "on"
                        inactiveValue: "off"
                        activeColor: "#67c23a"
                        activeIcon: EIcons.CHECK
                        inactiveColor: "#909399"
                        inactiveIcon: EIcons.XMARK
                        activeText: ELocale.texts.Enabled2
                        inactiveText: ELocale.texts.Disabled3
                        beforeChange: function() { return Promise.resolve(true) }
                    }
                }
`)

            Column {
                spacing: 16
                width: parent.width

                ECheckBox {
                    id: webFormAllowSwitch

                    checked: true
                    borderVisible: false
                    text: ELocale.texts.AllowChanges
                }
                ESwitch {
                    value: "off"
                    activeValue: "on"
                    inactiveValue: "off"
                    activeColor: "#67c23a"
                    activeIcon: EIcons.CHECK
                    inactiveColor: "#909399"
                    inactiveIcon: EIcons.XMARK
                    objectName: "webFormSwitch"
                    activeText: ELocale.texts.Enabled2
                    inactiveText: ELocale.texts.Disabled3
                    beforeChange: function() {
                        return Promise.resolve(webFormAllowSwitch.checked)
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESlider"

        ExampleCard {
            description: ELocale.texts.RealStepStopsMarksAndFormattedTooltipsNative
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    ESlider {
                        from: 0
                        to: 100
                        value: 50
                        stepSize: 25
                        showStops: true
                        showInput: true
                        marks: ({0: "0%", 25: "25%", 50: "50%", 75: "75%", 100: "100%"})
                        formatTooltip: function(value) { return value + "%" }
                    }
                }`)

            ESlider {
                to: 100
                value: 50
                stepSize: 25
                showInput: true
                showStops: true
                objectName: "webFormSlider"
                width: Math.min(520, parent.width)
                formatTooltip: function(value) {
                    return value + "%"
                }
                marks: ({0: "0%", 25: "25%", 50: "50%", 75: "75%", 100: "100%"})
            }
        }
    }
    ExampleSection {
        componentName: "ESpinBox"

        ExampleCard {
            description: ELocale.texts.DecimalValuesUseNumberValueIntegerValueSteppingAnd
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    ESpinBox {
                        from: -10
                        to: 20
                        value: 7
                        editable: true
                    }
                    ESpinBox {
                        precision: 2
                        editable: true
                        prefix: "$"
                        stepStrictly: true
                        controlsPosition: "right"
                        numberFrom: -1.5
                        numberTo: 20.5
                        numberStep: 0.25
                        numberValue: 1.25
                        onNumberModified: console.log(numberValue)
                    }
                }`)

            Flow {
                spacing: 16
                width: parent.width

                ESpinBox {
                    to: 20
                    value: 7
                    from: -10
                    editable: true
                    objectName: "webFormInteger"
                }
                ESpinBox {
                    prefix: "$"
                    precision: 2
                    editable: true
                    numberTo: 20.5
                    numberFrom: -1.5
                    numberStep: 0.25
                    numberValue: 1.25
                    stepStrictly: true
                    controlsPosition: "right"
                    objectName: "webFormDecimal"
                }
            }
        }
    }
    ExampleSection {
        componentName: "EInput"

        ExampleCard {
            description: ELocale.texts.ParsingAndFormattingRunOnEditingCompletionWord
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 640
                    spacing: 16

                    EInput {
                        text: "$128"
                        clearable: true
                        prependComponent: Component {
                            EText {
                                padding: 8
                                text: "USD"
                            }
                        }
                        parser: function(value) { return value.replace(/\\$/g, "") }
                        formatter: function(value) { return value ? "$" + value : "" }
                        appendComponent: Component {
                            EText {
                                padding: 8
                                text: ELocale.texts.Month2
                            }
                        }
                    }
                    EInput {
                        clearable: true
                        maximumLength: 40
                        showWordLimit: true
                        suffixComponent: Component {
                            EText {
                                text: "QML"
                                font.pixelSize: 12
                            }
                        }
                        prefixComponent: Component {
                            EIcon {
                                iconSize: 14
                                iconSource: EIcons.MAGNIFIER
                            }
                        }
                    }
                }
`)

            Column {
                spacing: 16
                width: parent.width

                EInput {
                    text: "$128"
                    clearable: true
                    width: Math.min(360, parent.width)
                    objectName: "webFormFormattedInput"
                    parser: function(value) {
                        return value.replace(/\$/g, "")
                    }
                    prependComponent: Component {
                        EText {
                            padding: 8
                            text: "USD"
                        }
                    }
                    formatter: function(value) {
                        return value ? "$" + value : ""
                    }
                    appendComponent: Component {
                        EText {
                            padding: 8
                            text: ELocale.texts.Month2
                        }
                    }
                }
                EInput {
                    clearable: true
                    maximumLength: 40
                    showWordLimit: true
                    width: Math.min(440, parent.width)
                    placeholderText: ELocale.texts.UpTo40Characters
                    suffixComponent: Component {
                        EText {
                            text: "QML"
                            font.pixelSize: 12
                        }
                    }
                    prefixComponent: Component {
                        EIcon {
                            iconSize: 14
                            iconSource: EIcons.MAGNIFIER
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECheckBox"

        ExampleCard {
            code: exampleData.samples.FormExamplesSample0
            description: ELocale.texts.SizesIndicatorsBordersSemanticStylesAndColors

            Flow {
                spacing: 12
                width: parent.width

                ECheckBox {
                    text: ELocale.texts.Unchecked
                }
                ECheckBox {
                    checked: true
                    text: ELocale.texts.Checked
                }
                ECheckBox {
                    checked: true
                    borderVisible: false
                    text: ELocale.texts.WithoutBorder
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECheckBoxButton"

        ExampleCard {
            code: exampleData.samples.FormExamplesSample1
            description: ELocale.texts.ButtonCheckboxesWithRadiusBordersAndSemantic

            Flow {
                spacing: 12
                width: parent.width

                ECheckBoxButton {
                    text: ELocale.texts.OptionOne
                }
                ECheckBoxButton {
                    radius: 8
                    checked: true
                    text: ELocale.texts.OptionTwo
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERadio"

        ExampleCard {
            code: exampleData.samples.FormExamplesSample2
            description: ELocale.texts.RadioSizesIndicatorsAndCustomColors

            Flow {
                spacing: 14
                width: parent.width

                ERadio {
                    checked: true
                    text: ELocale.texts.Default2
                }
                ERadio {
                    size: EStyle.Small
                    text: ELocale.texts.Small2
                }
                ERadio {
                    borderVisible: false
                    text: ELocale.texts.WithoutBorder
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERadioButton"

        ExampleCard {
            description: ELocale.texts.RadioButtons
            code: exampleData.samples.FormExamplesSample3

            Flow {
                spacing: 12
                width: parent.width

                ERadioButton {
                    checked: true
                    text: ELocale.texts.Beijing
                }
                ERadioButton {
                    text: ELocale.texts.Shanghai
                }
            }
        }
    }
    ExampleSection {
        componentName: "EInput"

        ExampleCard {
            code: exampleData.samples.FormExamplesSample4
            description: ELocale.texts.PrefixAndSuffixIconsClearingPasswordsSizes

            Column {
                spacing: 12
                width: parent.width

                EInput {
                    width: Math.min(parent.width, 520)
                    placeholderText: ELocale.texts.EnterAPassword
                }
                EInput {
                    clearable: true
                    prefixIcon: EIcons.AT
                    width: Math.min(parent.width, 520)
                    placeholderText: ELocale.texts.SmallInput
                }
                EInput {
                    showPassword: true
                    suffixIcon: EIcons.EYE
                    text: exampleData.models.Password
                    width: Math.min(parent.width, 520)
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESlider"

        ExampleCard {
            code: exampleData.samples.FormExamplesSample5
            description: ELocale.texts.RangeStepSizeHorizontalOrVerticalOrientation

            Column {
                spacing: 16
                width: parent.width

                ESlider {
                    value: 30
                    width: Math.min(parent.width, 520)
                }
                ESlider {
                    to: 10
                    from: 0
                    value: 6
                    stepSize: 1
                    styleType: EStyle.Success
                    width: Math.min(parent.width, 520)
                    color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Success)
                }
                ESlider {
                    from: 0
                    to: 100
                    value: 45
                    stepSize: 5
                    trackSize: 8
                    handleSize: 24
                    size: EStyle.Large
                    styleType: EStyle.Primary
                    orientation: Qt.Horizontal
                    width: Math.min(parent.width, 520)
                    color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESpinBox"

        ExampleCard {
            code: exampleData.samples.FormExamplesSample6
            description: ELocale.texts.NumberRangeIconsEditingSizesAndValidation

            Flow {
                spacing: 24
                width: parent.width

                Column {
                    spacing: 10
                    width: Math.min(parent.width, 220)

                    EText {
                        font.bold: true
                        font.pixelSize: 14
                        text: ELocale.texts.Default2
                    }
                    ESpinBox {
                        to: 10
                        from: 0
                        value: 2
                        width: parent.width
                    }
                    ETag {
                        text: "0 – 10"
                        effect: "plain"
                        styleType: EStyle.Info
                    }
                }
                Column {
                    spacing: 10
                    width: Math.min(parent.width, 220)

                    EText {
                        font.bold: true
                        font.pixelSize: 14
                        text: ELocale.texts.Input + " · ±2"
                    }
                    ESpinBox {
                        to: 20
                        value: 0
                        from: -20
                        stepSize: 2
                        editable: true
                        width: parent.width
                    }
                    ETag {
                        effect: "plain"
                        text: "−20 – 20"
                        styleType: EStyle.Info
                    }
                }
                Column {
                    spacing: 10
                    width: Math.min(parent.width, 220)

                    EText {
                        font.bold: true
                        font.pixelSize: 14
                        text: ELocale.texts.Validate
                    }
                    ESpinBox {
                        id: validationSpinBox

                        from: 0
                        to: 100
                        value: 20
                        stepSize: 5
                        iconSize: 18
                        editable: true
                        indicatorWidth: 42
                        size: EStyle.Large
                        indicatorHeight: 38
                        selectByMouse: true
                        width: parent.width
                        incIcon: EIcons.PLUS
                        decIcon: EIcons.MINUS
                        styleType: EStyle.Warning
                        validationState: EValidationState.Warning
                        validationMessage: ELocale.texts.EnterAValue
                        textColor: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Warning)
                    }
                    ETag {
                        text: validationSpinBox.validationMessage
                        styleType: validationSpinBox.hasValidationError ? EStyle.Danger : EStyle.Warning
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESwitch"

        ExampleCard {
            code: exampleData.samples.FormExamplesSample7
            description: ELocale.texts.IconsOrientationSizesColorsAndAccessibleNames

            Flow {
                spacing: 20
                width: parent.width

                ESwitch {
                    text: ELocale.texts.Default2
                }
                ESwitch {
                    checked: true
                    text: ELocale.texts.Enabled2
                }
            }
        }
    }
    ExampleSection {
        componentName: "EThemeSwitch"

        ExampleCard {
            code: exampleData.samples.FormExamplesSample8
            description: ELocale.texts.ThemeTransitionsSizesAndThumbTrackBorder

            Row {
                spacing: 24

                EThemeSwitch {
                }
                EThemeSwitch {
                    duration: 300
                    darkIconColor: EPaletteManager.BasePalette.white
                    lightThumbColor: EPaletteManager.BasePalette.white
                    darkBorderColor: EPaletteManager.ThemePalette.textRegular(false)
                    darkTrackColor: EPaletteManager.ThemePalette.surfacePressed(true)
                    lightTrackColor: EPaletteManager.ThemePalette.surfaceHover(false)
                    darkThumbColor: EPaletteManager.ThemePalette.fetchThemeColor(true)
                    lightBorderColor: EPaletteManager.ThemePalette.borderDefault(false)
                    lightIconColor: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Warning)
                }
                EText {
                    font.pixelSize: 14
                    text: ELocale.texts.CurrentDarkMode1.arg(ETheme.dark)
                    color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                }
            }
        }
    }
    ExampleSection {
        componentName: "EFormItem"

        ExampleCard {
            code: exampleData.samples.FormExamplesSample9
            description: ELocale.texts.FormItemsWithLabelsHelpTextValidation

            EFormItem {
                id: standaloneItem

                error: ""
                form: null
                prop: "email"
                rowSpacing: 8
                labelWidth: 90
                required: true
                resettable: true
                showMessage: true
                size: EStyle.Large
                formDisabled: false
                validateEvent: true
                inlineMessage: false
                labelPosition: "left"
                propagateToField: true
                showSuccessState: true
                validateOnChange: true
                inheritFormConfig: false
                label: ELocale.texts.Email
                hideRequiredAsterisk: false
                objectName: "galleryFormItem"
                requiredAsteriskPosition: "left"
                labelSuffix: ELocale.texts.Symbol6
                width: Math.min(parent.width, 560)
                rules: exampleData.models.EmailRules
                validationState: EValidationState.Success
                validationMessage: ELocale.texts.ValidFormat
                requiredMessage: ELocale.texts.EnterYourEmail
                helpText: ELocale.texts.UsedForAccountNotifications
                validator: function(value) {
                    return String(value).indexOfELocale.texts.Symbol7 > 0
                        || ELocale.texts.EnterAValidEmailAddress
                }

                EInput {
                    clearable: true
                    width: parent.width
                    text: ELocale.texts.DemoExampleCom
                }
            }
            EFormItem {
                rowSpacing: 8
                labelWidth: 90
                size: EStyle.Large
                labelPosition: "left"
                label: ELocale.texts.ExternalError
                labelSuffix: ELocale.texts.Symbol6
                width: Math.min(parent.width, 560)
                error: ELocale.texts.ErrorReturnedByTheServer

                EInput {
                    width: parent.width
                    text: ELocale.texts.ResetValue
                }
            }
            EDescriptions {
                columns: 1
                objectName: "galleryFormFeedback"
                width: Math.min(parent.width, 560)
                model: [{
                    "label": ELocale.texts.Email,
                    "value": standaloneItem.fieldValue
                }, {
                    "label": ELocale.texts.Messages,
                    "value": standaloneItem.effectiveMessage
                }]
            }
            Flow {
                spacing: 10
                width: parent.width

                EButton {
                    styleType: EStyle.Primary
                    text: ELocale.texts.Validate
                    objectName: "galleryFormValidate"

                    onClicked: standaloneItem.validate()
                }
                EButton {
                    text: ELocale.texts.StartOver
                    objectName: "galleryFormReset"

                    onClicked: standaloneItem.resetField()
                }
                ETag {
                    size: EStyle.Large
                    styleType: standaloneItem.hasValidationError ? EStyle.Danger
                        : standaloneItem.validationState === EValidationState.Success ? EStyle.Success
                            : EStyle.Info
                    text: standaloneItem.validating ? ELocale.texts.Loading
                        : standaloneItem.hasValidationError ? ELocale.texts.ValidationFailed
                        : standaloneItem.validationState === EValidationState.Success
                            ? ELocale.texts.ValidFormat
                            : ELocale.texts.Input
                }
                ETag {
                    size: EStyle.Large
                    text: ELocale.texts.Edit
                    visible: standaloneItem.fieldFocused
                }
            }
        }
    }
    ExampleSection {
        componentName: "EForm"

        ExampleCard {
            code: exampleData.samples.FormExamplesSample10
            description: ELocale.texts.ModelsRulesLayoutsValidationTimingResetPolicies

            EForm {
                id: accountForm

                spacing: 16
                inline: false
                labelWidth: 90
                disabled: false
                columnSpacing: 20
                showMessage: true
                size: EStyle.Large
                model: page.account
                inlineMessage: false
                focusFirstError: true
                labelPosition: "left"
                validateOnChange: true
                validateOnRuleChange: true
                hideRequiredAsterisk: false
                requiredAsteriskPosition: "left"
                labelSuffix: ELocale.texts.Symbol6
                width: Math.min(parent.width, 620)
                rules: exampleData.models.AccountRules

                EFormItem {
                    prop: "name"
                    required: true
                    width: parent.width
                    label: ELocale.texts.Name2

                    EInput {
                        clearable: true
                        width: parent.width
                        placeholderText: ELocale.texts.NameIsRequired
                    }
                }
                EFormItem {
                    prop: "email"
                    width: parent.width
                    label: ELocale.texts.Email

                    EInput {
                        clearable: true
                        width: parent.width
                        placeholderText: ELocale.texts.NameExampleCom
                    }
                }
            }
            Flow {
                spacing: 10
                width: parent.width

                EButton {
                    styleType: EStyle.Primary
                    text: ELocale.texts.Validate

                    onClicked: accountForm.validate()
                }
                EButton {
                    text: ELocale.texts.ClearValidation

                    onClicked: accountForm.clearValidation()
                }
                EButton {
                    text: ELocale.texts.FocusFirstError

                    onClicked: accountForm.scrollToField("name")
                }
                EText {
                    font.pixelSize: 14
                    width: parent.width
                    wrapMode: Text.WordWrap
                    objectName: "galleryFormStatus"
                    color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                    text: accountForm.validating
                        ? ELocale.texts.Validating
                        : accountForm.valid
                            ? ELocale.texts.AllFieldsPassedValidation
                            : ELocale.texts.CheckTheMessagesInTheForm
                }
            }
        }
    }
    FormShowcase { }
    PrimeShowcase { names: ["EInput", "EFormItem"] }
}

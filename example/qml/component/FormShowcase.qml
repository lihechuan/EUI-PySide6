import EUI 1.0
import QtQuick 2.15

Column {
    spacing: 24
    width: parent.width

    ExampleSection {
        componentName: "ESpinBox"

        ExampleCase {
            objectName: "showcaseESpinBox0"
            title: ELocale.texts.ThreeSizes2
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ESpinBox {
                        precision: 1
                        editable: true
                        numberStep: 0.5
                        numberValue: 12.5
                        size: EStyle.Small
                        width: Math.min(220, parent.width)
                    }
                    ESpinBox {
                        precision: 1
                        editable: true
                        numberStep: 0.5
                        numberValue: 12.5
                        size: EStyle.Medium
                        width: Math.min(220, parent.width)
                    }
                    ESpinBox {
                        precision: 1
                        editable: true
                        numberStep: 0.5
                        numberValue: 12.5
                        size: EStyle.Large
                        width: Math.min(220, parent.width)
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ESpinBox {
                    precision: 1
                    editable: true
                    numberStep: 0.5
                    numberValue: 12.5
                    size: EStyle.Small
                    width: Math.min(220, parent.width)
                }
                ESpinBox {
                    precision: 1
                    editable: true
                    numberStep: 0.5
                    numberValue: 12.5
                    size: EStyle.Medium
                    width: Math.min(220, parent.width)
                }
                ESpinBox {
                    precision: 1
                    editable: true
                    numberStep: 0.5
                    numberValue: 12.5
                    size: EStyle.Large
                    width: Math.min(220, parent.width)
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESpinBox"

        ExampleCase {
            objectName: "showcaseESpinBox1"
            title: ELocale.texts.ReadOnlyAndDisabled
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ESpinBox {
                        precision: 1
                        editable: true
                        readOnly: true
                        numberStep: 0.5
                        enabled: readOnly
                        numberValue: 12.5
                        width: Math.min(220, parent.width)
                    }
                    ESpinBox {
                        precision: 1
                        editable: true
                        numberStep: 0.5
                        readOnly: false
                        enabled: readOnly
                        numberValue: 12.5
                        width: Math.min(220, parent.width)
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ESpinBox {
                    precision: 1
                    editable: true
                    readOnly: true
                    numberStep: 0.5
                    enabled: readOnly
                    numberValue: 12.5
                    width: Math.min(220, parent.width)
                }
                ESpinBox {
                    precision: 1
                    editable: true
                    numberStep: 0.5
                    readOnly: false
                    enabled: readOnly
                    numberValue: 12.5
                    width: Math.min(220, parent.width)
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESpinBox"

        ExampleCase {
            objectName: "showcaseESpinBox2"
            title: ELocale.texts.ValidationStates
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ESpinBox {
                        precision: 1
                        editable: true
                        numberStep: 0.5
                        numberValue: 12.5
                        width: Math.min(220, parent.width)
                        validationState: EValidationState.Success
                        validationMessage: ELocale.texts.ValidationMessage
                    }
                    ESpinBox {
                        precision: 1
                        editable: true
                        numberStep: 0.5
                        numberValue: 12.5
                        width: Math.min(220, parent.width)
                        validationState: EValidationState.Warning
                        validationMessage: ELocale.texts.ValidationMessage
                    }
                    ESpinBox {
                        precision: 1
                        editable: true
                        numberStep: 0.5
                        numberValue: 12.5
                        width: Math.min(220, parent.width)
                        validationState: EValidationState.Error
                        validationMessage: ELocale.texts.ValidationMessage
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ESpinBox {
                    precision: 1
                    editable: true
                    numberStep: 0.5
                    numberValue: 12.5
                    width: Math.min(220, parent.width)
                    validationState: EValidationState.Success
                    validationMessage: ELocale.texts.ValidationMessage
                }
                ESpinBox {
                    precision: 1
                    editable: true
                    numberStep: 0.5
                    numberValue: 12.5
                    width: Math.min(220, parent.width)
                    validationState: EValidationState.Warning
                    validationMessage: ELocale.texts.ValidationMessage
                }
                ESpinBox {
                    precision: 1
                    editable: true
                    numberStep: 0.5
                    numberValue: 12.5
                    width: Math.min(220, parent.width)
                    validationState: EValidationState.Error
                    validationMessage: ELocale.texts.ValidationMessage
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESpinBox"

        ExampleCase {
            objectName: "showcaseESpinBox3"
            title: ELocale.texts.CurrencyAndRightControls
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ESpinBox {
                    prefix: "$"
                    precision: 2
                    numberFrom: 0
                    numberTo: 100
                    editable: true
                    numberStep: 0.25
                    numberValue: 24.5
                    controlsPosition: "right"
                    width: Math.min(480, parent.width)
                }
            `)

            ESpinBox {
                prefix: "$"
                precision: 2
                numberFrom: 0
                numberTo: 100
                editable: true
                numberStep: 0.25
                numberValue: 24.5
                controlsPosition: "right"
                width: Math.min(480, parent.width)
            }
        }
    }
    ExampleSection {
        componentName: "EFormItem"

        ExampleCase {
            objectName: "showcaseEFormItem0"
            title: ELocale.texts.RequiredValidation
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EForm {
                        id: sample

                        model: ({name: ""})
                        width: Math.min(480, parent.width)

                        EFormItem {
                            prop: "name"
                            required: true
                            width: parent.width
                            labelPosition: "top"
                            label: ELocale.texts.ProjectName
                            helpText: ELocale.texts.Use3To20Characters
                            rules: [{min: 3, max: 20, message: ELocale.texts.Enter3To20Characters}]

                            EInput {
                                width: parent.width
                                placeholderText: ELocale.texts.ProjectName
                            }
                        }
                    }
                    Flow {
                        spacing: 16
                        width: parent.width

                        EButton {
                            styleType: EStyle.Primary
                            text: ELocale.texts.TableValidate

                            onClicked: sample.validate()
                        }
                        EButton {
                            text: ELocale.texts.Reset

                            onClicked: sample.resetFields()
                        }
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EForm {
                    id: sample

                    model: ({name: ""})
                    width: Math.min(480, parent.width)

                    EFormItem {
                        prop: "name"
                        required: true
                        width: parent.width
                        labelPosition: "top"
                        label: ELocale.texts.ProjectName
                        helpText: ELocale.texts.Use3To20Characters
                        rules: [{min: 3, max: 20, message: ELocale.texts.Enter3To20Characters}]

                        EInput {
                            width: parent.width
                            placeholderText: ELocale.texts.ProjectName
                        }
                    }
                }
                Flow {
                    spacing: 16
                    width: parent.width

                    EButton {
                        styleType: EStyle.Primary
                        text: ELocale.texts.TableValidate

                        onClicked: sample.validate()
                    }
                    EButton {
                        text: ELocale.texts.Reset

                        onClicked: sample.resetFields()
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EFormItem"

        ExampleCase {
            objectName: "showcaseEFormItem1"
            title: ELocale.texts.LabelAlignment
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EForm {
                        id: sample

                        model: ({name: ""})
                        width: Math.min(480, parent.width)

                        EFormItem {
                            prop: "name"
                            required: true
                            labelWidth: 100
                            width: parent.width
                            labelPosition: "left"
                            label: ELocale.texts.ProjectName
                            helpText: ELocale.texts.Use3To20Characters
                            rules: [{min: 3, max: 20, message: ELocale.texts.Enter3To20Characters}]

                            EInput {
                                width: parent.width
                                placeholderText: ELocale.texts.ProjectName
                            }
                        }
                    }
                    Flow {
                        spacing: 16
                        width: parent.width

                        EButton {
                            styleType: EStyle.Primary
                            text: ELocale.texts.TableValidate

                            onClicked: sample.validate()
                        }
                        EButton {
                            text: ELocale.texts.Reset

                            onClicked: sample.resetFields()
                        }
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EForm {
                    id: sample

                    model: ({name: ""})
                    width: Math.min(480, parent.width)

                    EFormItem {
                        prop: "name"
                        required: true
                        labelWidth: 100
                        width: parent.width
                        labelPosition: "left"
                        label: ELocale.texts.ProjectName
                        helpText: ELocale.texts.Use3To20Characters
                        rules: [{min: 3, max: 20, message: ELocale.texts.Enter3To20Characters}]

                        EInput {
                            width: parent.width
                            placeholderText: ELocale.texts.ProjectName
                        }
                    }
                }
                Flow {
                    spacing: 16
                    width: parent.width

                    EButton {
                        styleType: EStyle.Primary
                        text: ELocale.texts.TableValidate

                        onClicked: sample.validate()
                    }
                    EButton {
                        text: ELocale.texts.Reset

                        onClicked: sample.resetFields()
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EFormItem"

        ExampleCase {
            objectName: "showcaseEFormItem2"
            title: ELocale.texts.ValidationOnChange
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EForm {
                        id: sample

                        model: ({name: ""})
                        width: Math.min(480, parent.width)

                        EFormItem {
                            prop: "name"
                            required: true
                            width: parent.width
                            showSuccessState: true
                            validateOnChange: true
                            label: ELocale.texts.ProjectName
                            helpText: ELocale.texts.Use3To20Characters
                            rules: [{min: 3, max: 20, message: ELocale.texts.Enter3To20Characters}]

                            EInput {
                                width: parent.width
                                placeholderText: ELocale.texts.ProjectName
                            }
                        }
                    }
                    Flow {
                        spacing: 16
                        width: parent.width

                        EButton {
                            styleType: EStyle.Primary
                            text: ELocale.texts.TableValidate

                            onClicked: sample.validate()
                        }
                        EButton {
                            text: ELocale.texts.Reset

                            onClicked: sample.resetFields()
                        }
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EForm {
                    id: sample

                    model: ({name: ""})
                    width: Math.min(480, parent.width)

                    EFormItem {
                        prop: "name"
                        required: true
                        width: parent.width
                        showSuccessState: true
                        validateOnChange: true
                        label: ELocale.texts.ProjectName
                        helpText: ELocale.texts.Use3To20Characters
                        rules: [{min: 3, max: 20, message: ELocale.texts.Enter3To20Characters}]

                        EInput {
                            width: parent.width
                            placeholderText: ELocale.texts.ProjectName
                        }
                    }
                }
                Flow {
                    spacing: 16
                    width: parent.width

                    EButton {
                        styleType: EStyle.Primary
                        text: ELocale.texts.TableValidate

                        onClicked: sample.validate()
                    }
                    EButton {
                        text: ELocale.texts.Reset

                        onClicked: sample.resetFields()
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EFormItem"

        ExampleCase {
            objectName: "showcaseEFormItem3"
            title: ELocale.texts.DisabledForm
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EForm {
                        id: sample

                        model: ({name: ""})
                        width: Math.min(480, parent.width)

                        EFormItem {
                            prop: "name"
                            required: true
                            formDisabled: true
                            width: parent.width
                            hideRequiredAsterisk: true
                            label: ELocale.texts.ProjectName
                            helpText: ELocale.texts.Use3To20Characters
                            rules: [{min: 3, max: 20, message: ELocale.texts.Enter3To20Characters}]

                            EInput {
                                width: parent.width
                                placeholderText: ELocale.texts.ProjectName
                            }
                        }
                    }
                    Flow {
                        spacing: 16
                        width: parent.width

                        EButton {
                            styleType: EStyle.Primary
                            text: ELocale.texts.TableValidate

                            onClicked: sample.validate()
                        }
                        EButton {
                            text: ELocale.texts.Reset

                            onClicked: sample.resetFields()
                        }
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EForm {
                    id: sample

                    model: ({name: ""})
                    width: Math.min(480, parent.width)

                    EFormItem {
                        prop: "name"
                        required: true
                        formDisabled: true
                        width: parent.width
                        hideRequiredAsterisk: true
                        label: ELocale.texts.ProjectName
                        helpText: ELocale.texts.Use3To20Characters
                        rules: [{min: 3, max: 20, message: ELocale.texts.Enter3To20Characters}]

                        EInput {
                            width: parent.width
                            placeholderText: ELocale.texts.ProjectName
                        }
                    }
                }
                Flow {
                    spacing: 16
                    width: parent.width

                    EButton {
                        styleType: EStyle.Primary
                        text: ELocale.texts.TableValidate

                        onClicked: sample.validate()
                    }
                    EButton {
                        text: ELocale.texts.Reset

                        onClicked: sample.resetFields()
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERadioButton"

        ExampleCase {
            objectName: "showcaseERadioButton0"
            title: ELocale.texts.SizesAndSelection
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ERadioButton {
                        checked: true
                        size: EStyle.Small
                        text: ELocale.texts.Option
                    }
                    ERadioButton {
                        checked: true
                        size: EStyle.Medium
                        text: ELocale.texts.Option
                    }
                    ERadioButton {
                        checked: true
                        size: EStyle.Large
                        text: ELocale.texts.Option
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ERadioButton {
                    checked: true
                    size: EStyle.Small
                    text: ELocale.texts.Option
                }
                ERadioButton {
                    checked: true
                    size: EStyle.Medium
                    text: ELocale.texts.Option
                }
                ERadioButton {
                    checked: true
                    size: EStyle.Large
                    text: ELocale.texts.Option
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERadioButton"

        ExampleCase {
            objectName: "showcaseERadioButton1"
            title: ELocale.texts.SemanticColors
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ERadioButton {
                        checked: true
                        styleType: EStyle.Primary
                        text: ELocale.texts.Option
                    }
                    ERadioButton {
                        checked: true
                        styleType: EStyle.Success
                        text: ELocale.texts.Option
                    }
                    ERadioButton {
                        checked: true
                        styleType: EStyle.Warning
                        text: ELocale.texts.Option
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ERadioButton {
                    checked: true
                    styleType: EStyle.Primary
                    text: ELocale.texts.Option
                }
                ERadioButton {
                    checked: true
                    styleType: EStyle.Success
                    text: ELocale.texts.Option
                }
                ERadioButton {
                    checked: true
                    styleType: EStyle.Warning
                    text: ELocale.texts.Option
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERadioButton"

        ExampleCase {
            objectName: "showcaseERadioButton2"
            title: ELocale.texts.DisabledStates
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ERadioButton {
                        checked: true
                        enabled: false
                        text: ELocale.texts.CannotBeChanged
                    }
                    ERadioButton {
                        checked: false
                        enabled: false
                        text: ELocale.texts.CannotBeChanged
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ERadioButton {
                    checked: true
                    enabled: false
                    text: ELocale.texts.CannotBeChanged
                }
                ERadioButton {
                    checked: false
                    enabled: false
                    text: ELocale.texts.CannotBeChanged
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERadioButton"

        ExampleCase {
            objectName: "showcaseERadioButton3"
            title: ELocale.texts.SelectionBinding
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ERadioButton {
                        id: choice

                        text: ELocale.texts.EnableThisOption
                    }
                    EText {
                        text: choice.checked ? ELocale.texts.Checked : ELocale.texts.Unchecked
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                ERadioButton {
                    id: choice

                    text: ELocale.texts.EnableThisOption
                }
                EText {
                    text: choice.checked ? ELocale.texts.Checked : ELocale.texts.Unchecked
                }
            }
        }
    }
    ExampleSection {
        componentName: "EThemeSwitch"

        ExampleCase {
            title: ELocale.texts.ThemeStatus
            objectName: "showcaseEThemeSwitch0"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EThemeSwitch {
                        id: toggle

                        duration: 250
                        transitionDuration: 300
                    }
                    EText {
                        text: ETheme.dark ? ELocale.texts.DarkTheme : ELocale.texts.LightTheme
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EThemeSwitch {
                    id: toggle

                    duration: 250
                    transitionDuration: 300
                }
                EText {
                    text: ETheme.dark ? ELocale.texts.DarkTheme : ELocale.texts.LightTheme
                }
            }
        }
    }
    ExampleSection {
        componentName: "EThemeSwitch"

        ExampleCase {
            objectName: "showcaseEThemeSwitch1"
            title: ELocale.texts.CustomTrackColors
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EThemeSwitch {
                    darkIconColor: "#DCEBFF"
                    darkThumbColor: "#409eff"
                    darkTrackColor: "#173958"
                    lightIconColor: "#409eff"
                    lightThumbColor: "#FFFFFF"
                    lightTrackColor: "#C3DEF4"
                }
            `)

            EThemeSwitch {
                darkIconColor: "#DCEBFF"
                darkThumbColor: "#409eff"
                darkTrackColor: "#173958"
                lightIconColor: "#409eff"
                lightThumbColor: "#FFFFFF"
                lightTrackColor: "#C3DEF4"
            }
        }
    }
    ExampleSection {
        componentName: "EThemeSwitch"

        ExampleCase {
            objectName: "showcaseEThemeSwitch2"
            title: ELocale.texts.InstantTransition
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EThemeSwitch {
                    duration: 0
                    transitionDuration: 0
                }
            `)

            EThemeSwitch {
                duration: 0
                transitionDuration: 0
            }
        }
    }
    ExampleSection {
        componentName: "EThemeSwitch"

        ExampleCase {
            objectName: "showcaseEThemeSwitch3"
            title: ELocale.texts.DisabledToggle
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EThemeSwitch {
                    enabled: false
                }
            `)

            EThemeSwitch {
                enabled: false
            }
        }
    }
    ExampleSection {
        componentName: "ECheckBoxButton"

        ExampleCase {
            objectName: "showcaseECheckBoxButton0"
            title: ELocale.texts.SizesAndSelection
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ECheckBoxButton {
                        checked: true
                        size: EStyle.Small
                        text: ELocale.texts.Option
                    }
                    ECheckBoxButton {
                        checked: true
                        size: EStyle.Medium
                        text: ELocale.texts.Option
                    }
                    ECheckBoxButton {
                        checked: true
                        size: EStyle.Large
                        text: ELocale.texts.Option
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ECheckBoxButton {
                    checked: true
                    size: EStyle.Small
                    text: ELocale.texts.Option
                }
                ECheckBoxButton {
                    checked: true
                    size: EStyle.Medium
                    text: ELocale.texts.Option
                }
                ECheckBoxButton {
                    checked: true
                    size: EStyle.Large
                    text: ELocale.texts.Option
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECheckBoxButton"

        ExampleCase {
            title: ELocale.texts.SemanticColors
            objectName: "showcaseECheckBoxButton1"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ECheckBoxButton {
                        checked: true
                        styleType: EStyle.Primary
                        text: ELocale.texts.Option
                    }
                    ECheckBoxButton {
                        checked: true
                        styleType: EStyle.Success
                        text: ELocale.texts.Option
                    }
                    ECheckBoxButton {
                        checked: true
                        styleType: EStyle.Warning
                        text: ELocale.texts.Option
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ECheckBoxButton {
                    checked: true
                    styleType: EStyle.Primary
                    text: ELocale.texts.Option
                }
                ECheckBoxButton {
                    checked: true
                    styleType: EStyle.Success
                    text: ELocale.texts.Option
                }
                ECheckBoxButton {
                    checked: true
                    styleType: EStyle.Warning
                    text: ELocale.texts.Option
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECheckBoxButton"

        ExampleCase {
            title: ELocale.texts.DisabledStates
            objectName: "showcaseECheckBoxButton2"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ECheckBoxButton {
                        checked: true
                        enabled: false
                        text: ELocale.texts.CannotBeChanged
                    }
                    ECheckBoxButton {
                        checked: false
                        enabled: false
                        text: ELocale.texts.CannotBeChanged
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ECheckBoxButton {
                    checked: true
                    enabled: false
                    text: ELocale.texts.CannotBeChanged
                }
                ECheckBoxButton {
                    checked: false
                    enabled: false
                    text: ELocale.texts.CannotBeChanged
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECheckBoxButton"

        ExampleCase {
            title: ELocale.texts.SelectionBinding
            objectName: "showcaseECheckBoxButton3"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ECheckBoxButton {
                        id: choice

                        text: ELocale.texts.EnableThisOption
                    }
                    EText {
                        text: choice.checked ? ELocale.texts.Checked : ELocale.texts.Unchecked
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                ECheckBoxButton {
                    id: choice

                    text: ELocale.texts.EnableThisOption
                }
                EText {
                    text: choice.checked ? ELocale.texts.Checked : ELocale.texts.Unchecked
                }
            }
        }
    }
    ExampleSection {
        componentName: "EForm"

        ExampleCase {
            objectName: "showcaseEForm0"
            title: ELocale.texts.RequiredValidation
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EForm {
                        id: sample

                        model: ({name: ""})
                        labelPosition: "top"
                        width: Math.min(480, parent.width)

                        EFormItem {
                            prop: "name"
                            required: true
                            width: parent.width
                            label: ELocale.texts.ProjectName
                            helpText: ELocale.texts.Use3To20Characters
                            rules: [{min: 3, max: 20, message: ELocale.texts.Enter3To20Characters}]

                            EInput {
                                width: parent.width
                                placeholderText: ELocale.texts.ProjectName
                            }
                        }
                    }
                    Flow {
                        spacing: 16
                        width: parent.width

                        EButton {
                            styleType: EStyle.Primary
                            text: ELocale.texts.TableValidate

                            onClicked: sample.validate()
                        }
                        EButton {
                            text: ELocale.texts.Reset

                            onClicked: sample.resetFields()
                        }
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EForm {
                    id: sample

                    model: ({name: ""})
                    labelPosition: "top"
                    width: Math.min(480, parent.width)

                    EFormItem {
                        prop: "name"
                        required: true
                        width: parent.width
                        label: ELocale.texts.ProjectName
                        helpText: ELocale.texts.Use3To20Characters
                        rules: [{min: 3, max: 20, message: ELocale.texts.Enter3To20Characters}]

                        EInput {
                            width: parent.width
                            placeholderText: ELocale.texts.ProjectName
                        }
                    }
                }
                Flow {
                    spacing: 16
                    width: parent.width

                    EButton {
                        styleType: EStyle.Primary
                        text: ELocale.texts.TableValidate

                        onClicked: sample.validate()
                    }
                    EButton {
                        text: ELocale.texts.Reset

                        onClicked: sample.resetFields()
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EForm"

        ExampleCase {
            objectName: "showcaseEForm1"
            title: ELocale.texts.LabelAlignment
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EForm {
                        id: sample

                        labelWidth: 100
                        model: ({name: ""})
                        labelPosition: "left"
                        width: Math.min(480, parent.width)

                        EFormItem {
                            prop: "name"
                            required: true
                            width: parent.width
                            label: ELocale.texts.ProjectName
                            helpText: ELocale.texts.Use3To20Characters
                            rules: [{min: 3, max: 20, message: ELocale.texts.Enter3To20Characters}]

                            EInput {
                                width: parent.width
                                placeholderText: ELocale.texts.ProjectName
                            }
                        }
                    }
                    Flow {
                        spacing: 16
                        width: parent.width

                        EButton {
                            styleType: EStyle.Primary
                            text: ELocale.texts.TableValidate

                            onClicked: sample.validate()
                        }
                        EButton {
                            text: ELocale.texts.Reset

                            onClicked: sample.resetFields()
                        }
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EForm {
                    id: sample

                    labelWidth: 100
                    model: ({name: ""})
                    labelPosition: "left"
                    width: Math.min(480, parent.width)

                    EFormItem {
                        prop: "name"
                        required: true
                        width: parent.width
                        label: ELocale.texts.ProjectName
                        helpText: ELocale.texts.Use3To20Characters
                        rules: [{min: 3, max: 20, message: ELocale.texts.Enter3To20Characters}]

                        EInput {
                            width: parent.width
                            placeholderText: ELocale.texts.ProjectName
                        }
                    }
                }
                Flow {
                    spacing: 16
                    width: parent.width

                    EButton {
                        styleType: EStyle.Primary
                        text: ELocale.texts.TableValidate

                        onClicked: sample.validate()
                    }
                    EButton {
                        text: ELocale.texts.Reset

                        onClicked: sample.resetFields()
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EForm"

        ExampleCase {
            objectName: "showcaseEForm2"
            title: ELocale.texts.ValidationOnChange
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EForm {
                        id: sample

                        model: ({name: ""})
                        validateOnChange: true
                        width: Math.min(480, parent.width)

                        EFormItem {
                            prop: "name"
                            required: true
                            width: parent.width
                            label: ELocale.texts.ProjectName
                            helpText: ELocale.texts.Use3To20Characters
                            rules: [{min: 3, max: 20, message: ELocale.texts.Enter3To20Characters}]

                            EInput {
                                width: parent.width
                                placeholderText: ELocale.texts.ProjectName
                            }
                        }
                    }
                    Flow {
                        spacing: 16
                        width: parent.width

                        EButton {
                            styleType: EStyle.Primary
                            text: ELocale.texts.TableValidate

                            onClicked: sample.validate()
                        }
                        EButton {
                            text: ELocale.texts.Reset

                            onClicked: sample.resetFields()
                        }
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EForm {
                    id: sample

                    model: ({name: ""})
                    validateOnChange: true
                    width: Math.min(480, parent.width)

                    EFormItem {
                        prop: "name"
                        required: true
                        width: parent.width
                        label: ELocale.texts.ProjectName
                        helpText: ELocale.texts.Use3To20Characters
                        rules: [{min: 3, max: 20, message: ELocale.texts.Enter3To20Characters}]

                        EInput {
                            width: parent.width
                            placeholderText: ELocale.texts.ProjectName
                        }
                    }
                }
                Flow {
                    spacing: 16
                    width: parent.width

                    EButton {
                        styleType: EStyle.Primary
                        text: ELocale.texts.TableValidate

                        onClicked: sample.validate()
                    }
                    EButton {
                        text: ELocale.texts.Reset

                        onClicked: sample.resetFields()
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EForm"

        ExampleCase {
            objectName: "showcaseEForm3"
            title: ELocale.texts.DisabledForm
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EForm {
                        id: sample

                        disabled: true
                        model: ({name: ""})
                        hideRequiredAsterisk: true
                        width: Math.min(480, parent.width)

                        EFormItem {
                            prop: "name"
                            required: true
                            width: parent.width
                            label: ELocale.texts.ProjectName
                            helpText: ELocale.texts.Use3To20Characters
                            rules: [{min: 3, max: 20, message: ELocale.texts.Enter3To20Characters}]

                            EInput {
                                width: parent.width
                                placeholderText: ELocale.texts.ProjectName
                            }
                        }
                    }
                    Flow {
                        spacing: 16
                        width: parent.width

                        EButton {
                            styleType: EStyle.Primary
                            text: ELocale.texts.TableValidate

                            onClicked: sample.validate()
                        }
                        EButton {
                            text: ELocale.texts.Reset

                            onClicked: sample.resetFields()
                        }
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EForm {
                    id: sample

                    disabled: true
                    model: ({name: ""})
                    hideRequiredAsterisk: true
                    width: Math.min(480, parent.width)

                    EFormItem {
                        prop: "name"
                        required: true
                        width: parent.width
                        label: ELocale.texts.ProjectName
                        helpText: ELocale.texts.Use3To20Characters
                        rules: [{min: 3, max: 20, message: ELocale.texts.Enter3To20Characters}]

                        EInput {
                            width: parent.width
                            placeholderText: ELocale.texts.ProjectName
                        }
                    }
                }
                Flow {
                    spacing: 16
                    width: parent.width

                    EButton {
                        styleType: EStyle.Primary
                        text: ELocale.texts.TableValidate

                        onClicked: sample.validate()
                    }
                    EButton {
                        text: ELocale.texts.Reset

                        onClicked: sample.resetFields()
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EInput"

        ExampleCase {
            objectName: "showcaseEInput0"
            title: ELocale.texts.ThreeSizes2
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    EInput {
                        text: "Qt Quick"
                        size: EStyle.Small
                        width: Math.min(220, parent.width)
                    }
                    EInput {
                        text: "Qt Quick"
                        size: EStyle.Medium
                        width: Math.min(220, parent.width)
                    }
                    EInput {
                        text: "Qt Quick"
                        size: EStyle.Large
                        width: Math.min(220, parent.width)
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                EInput {
                    text: "Qt Quick"
                    size: EStyle.Small
                    width: Math.min(220, parent.width)
                }
                EInput {
                    text: "Qt Quick"
                    size: EStyle.Medium
                    width: Math.min(220, parent.width)
                }
                EInput {
                    text: "Qt Quick"
                    size: EStyle.Large
                    width: Math.min(220, parent.width)
                }
            }
        }
    }
    ExampleSection {
        componentName: "EInput"

        ExampleCase {
            objectName: "showcaseEInput1"
            title: ELocale.texts.ReadOnlyAndDisabled
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    EInput {
                        readOnly: true
                        text: "Qt Quick"
                        enabled: readOnly
                        width: Math.min(220, parent.width)
                    }
                    EInput {
                        readOnly: false
                        text: "Qt Quick"
                        enabled: readOnly
                        width: Math.min(220, parent.width)
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                EInput {
                    readOnly: true
                    text: "Qt Quick"
                    enabled: readOnly
                    width: Math.min(220, parent.width)
                }
                EInput {
                    readOnly: false
                    text: "Qt Quick"
                    enabled: readOnly
                    width: Math.min(220, parent.width)
                }
            }
        }
    }
    ExampleSection {
        componentName: "EInput"

        ExampleCase {
            objectName: "showcaseEInput2"
            title: ELocale.texts.ValidationStates
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    EInput {
                        text: "Qt Quick"
                        width: Math.min(220, parent.width)
                        validationState: EValidationState.Success
                        validationMessage: ELocale.texts.ValidationMessage
                    }
                    EInput {
                        text: "Qt Quick"
                        width: Math.min(220, parent.width)
                        validationState: EValidationState.Warning
                        validationMessage: ELocale.texts.ValidationMessage
                    }
                    EInput {
                        text: "Qt Quick"
                        width: Math.min(220, parent.width)
                        validationState: EValidationState.Error
                        validationMessage: ELocale.texts.ValidationMessage
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                EInput {
                    text: "Qt Quick"
                    width: Math.min(220, parent.width)
                    validationState: EValidationState.Success
                    validationMessage: ELocale.texts.ValidationMessage
                }
                EInput {
                    text: "Qt Quick"
                    width: Math.min(220, parent.width)
                    validationState: EValidationState.Warning
                    validationMessage: ELocale.texts.ValidationMessage
                }
                EInput {
                    text: "Qt Quick"
                    width: Math.min(220, parent.width)
                    validationState: EValidationState.Error
                    validationMessage: ELocale.texts.ValidationMessage
                }
            }
        }
    }
    ExampleSection {
        componentName: "EInput"

        ExampleCase {
            objectName: "showcaseEInput3"
            title: ELocale.texts.PrefixSuffixAndClear
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EInput {
                    clearable: true
                    text: "workspace"
                    width: Math.min(480, parent.width)
                    suffixComponent: Component {
                        EText {
                            text: ".eui"
                        }
                    }
                    prefixComponent: Component {
                        EIcon {
                            iconSize: 16
                            iconSource: EIcons.MAGNIFIER
                        }
                    }
                }
            `)

            EInput {
                clearable: true
                text: "workspace"
                width: Math.min(480, parent.width)
                suffixComponent: Component {
                    EText {
                        text: ".eui"
                    }
                }
                prefixComponent: Component {
                    EIcon {
                        iconSize: 16
                        iconSource: EIcons.MAGNIFIER
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERadio"

        ExampleCase {
            objectName: "showcaseERadio0"
            title: ELocale.texts.SizesAndSelection
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ERadio {
                        checked: true
                        size: EStyle.Small
                        text: ELocale.texts.Option
                    }
                    ERadio {
                        checked: true
                        size: EStyle.Medium
                        text: ELocale.texts.Option
                    }
                    ERadio {
                        checked: true
                        size: EStyle.Large
                        text: ELocale.texts.Option
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ERadio {
                    checked: true
                    size: EStyle.Small
                    text: ELocale.texts.Option
                }
                ERadio {
                    checked: true
                    size: EStyle.Medium
                    text: ELocale.texts.Option
                }
                ERadio {
                    checked: true
                    size: EStyle.Large
                    text: ELocale.texts.Option
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERadio"

        ExampleCase {
            objectName: "showcaseERadio1"
            title: ELocale.texts.SemanticColors
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ERadio {
                        checked: true
                        styleType: EStyle.Primary
                        text: ELocale.texts.Option
                    }
                    ERadio {
                        checked: true
                        styleType: EStyle.Success
                        text: ELocale.texts.Option
                    }
                    ERadio {
                        checked: true
                        styleType: EStyle.Warning
                        text: ELocale.texts.Option
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ERadio {
                    checked: true
                    styleType: EStyle.Primary
                    text: ELocale.texts.Option
                }
                ERadio {
                    checked: true
                    styleType: EStyle.Success
                    text: ELocale.texts.Option
                }
                ERadio {
                    checked: true
                    styleType: EStyle.Warning
                    text: ELocale.texts.Option
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERadio"

        ExampleCase {
            objectName: "showcaseERadio2"
            title: ELocale.texts.DisabledStates
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ERadio {
                        checked: true
                        enabled: false
                        text: ELocale.texts.CannotBeChanged
                    }
                    ERadio {
                        checked: false
                        enabled: false
                        text: ELocale.texts.CannotBeChanged
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ERadio {
                    checked: true
                    enabled: false
                    text: ELocale.texts.CannotBeChanged
                }
                ERadio {
                    checked: false
                    enabled: false
                    text: ELocale.texts.CannotBeChanged
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERadio"

        ExampleCase {
            objectName: "showcaseERadio3"
            title: ELocale.texts.SelectionBinding
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ERadio {
                        id: choice

                        text: ELocale.texts.EnableThisOption
                    }
                    EText {
                        text: choice.checked ? ELocale.texts.Checked : ELocale.texts.Unchecked
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                ERadio {
                    id: choice

                    text: ELocale.texts.EnableThisOption
                }
                EText {
                    text: choice.checked ? ELocale.texts.Checked : ELocale.texts.Unchecked
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESlider"

        ExampleCase {
            objectName: "showcaseESlider0"
            title: ELocale.texts.StepsAndStops
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ESlider {
                    from: 0
                    to: 100
                    value: 35
                    stepSize: 10
                    showStops: true
                    width: Math.min(480, parent.width)
                }
            `)

            ESlider {
                from: 0
                to: 100
                value: 35
                stepSize: 10
                showStops: true
                width: Math.min(480, parent.width)
            }
        }
    }
    ExampleSection {
        componentName: "ESlider"

        ExampleCase {
            objectName: "showcaseESlider1"
            title: ELocale.texts.MarksAndFormattedTooltip
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ESlider {
                    from: 0
                    to: 100
                    value: 35
                    width: Math.min(480, parent.width)
                    formatTooltip: function(value) { return Math.round(value) + "%" }
                    marks: ({0: ELocale.texts.Lowest, 25: ELocale.texts.Recommended, 75: ELocale.texts.Higher, 100: ELocale.texts.Highest})
                }
            `)

            ESlider {
                from: 0
                to: 100
                value: 35
                width: Math.min(480, parent.width)
                formatTooltip: function(value) { return Math.round(value) + "%" }
                marks: ({0: ELocale.texts.Lowest, 25: ELocale.texts.Recommended, 75: ELocale.texts.Higher, 100: ELocale.texts.Highest})
            }
        }
    }
    ExampleSection {
        componentName: "ESlider"

        ExampleCase {
            objectName: "showcaseESlider2"
            title: ELocale.texts.DisabledRange
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ESlider {
                    value: 35
                    enabled: false
                    showTooltip: false
                    width: Math.min(480, parent.width)
                }
            `)

            ESlider {
                value: 35
                enabled: false
                showTooltip: false
                width: Math.min(480, parent.width)
            }
        }
    }
    ExampleSection {
        componentName: "ESwitch"

        ExampleCase {
            objectName: "showcaseESwitch0"
            title: ELocale.texts.LabeledSizes
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ESwitch {
                        size: EStyle.Small
                        activeText: ELocale.texts.On
                        inactiveText: ELocale.texts.Close
                    }
                    ESwitch {
                        size: EStyle.Medium
                        activeText: ELocale.texts.On
                        inactiveText: ELocale.texts.Close
                    }
                    ESwitch {
                        size: EStyle.Large
                        activeText: ELocale.texts.On
                        inactiveText: ELocale.texts.Close
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ESwitch {
                    size: EStyle.Small
                    activeText: ELocale.texts.On
                    inactiveText: ELocale.texts.Close
                }
                ESwitch {
                    size: EStyle.Medium
                    activeText: ELocale.texts.On
                    inactiveText: ELocale.texts.Close
                }
                ESwitch {
                    size: EStyle.Large
                    activeText: ELocale.texts.On
                    inactiveText: ELocale.texts.Close
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESwitch"

        ExampleCase {
            objectName: "showcaseESwitch1"
            title: ELocale.texts.MappedValues
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ESwitch {
                        id: toggle

                        checked: true
                        activeValue: "enabled"
                        inactiveValue: "paused"
                    }
                    EText {
                        text: String(toggle.value)
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                ESwitch {
                    id: toggle

                    checked: true
                    activeValue: "enabled"
                    inactiveValue: "paused"
                }
                EText {
                    text: String(toggle.value)
                }
            }
        }
    }
    ExampleSection {
        componentName: "ESwitch"

        ExampleCase {
            objectName: "showcaseESwitch2"
            title: ELocale.texts.LoadingAndDisabled
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ESwitch {
                        checked: true
                        loading: true
                        enabled: loading
                    }
                    ESwitch {
                        checked: true
                        loading: false
                        enabled: loading
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ESwitch {
                    checked: true
                    loading: true
                    enabled: loading
                }
                ESwitch {
                    checked: true
                    loading: false
                    enabled: loading
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECheckBox"

        ExampleCase {
            objectName: "showcaseECheckBox0"
            title: ELocale.texts.SizesAndSelection
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ECheckBox {
                        checked: true
                        size: EStyle.Small
                        text: ELocale.texts.Option
                    }
                    ECheckBox {
                        checked: true
                        size: EStyle.Medium
                        text: ELocale.texts.Option
                    }
                    ECheckBox {
                        checked: true
                        size: EStyle.Large
                        text: ELocale.texts.Option
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ECheckBox {
                    checked: true
                    size: EStyle.Small
                    text: ELocale.texts.Option
                }
                ECheckBox {
                    checked: true
                    size: EStyle.Medium
                    text: ELocale.texts.Option
                }
                ECheckBox {
                    checked: true
                    size: EStyle.Large
                    text: ELocale.texts.Option
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECheckBox"

        ExampleCase {
            objectName: "showcaseECheckBox1"
            title: ELocale.texts.SemanticColors
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ECheckBox {
                        checked: true
                        styleType: EStyle.Primary
                        text: ELocale.texts.Option
                    }
                    ECheckBox {
                        checked: true
                        styleType: EStyle.Success
                        text: ELocale.texts.Option
                    }
                    ECheckBox {
                        checked: true
                        styleType: EStyle.Warning
                        text: ELocale.texts.Option
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ECheckBox {
                    checked: true
                    styleType: EStyle.Primary
                    text: ELocale.texts.Option
                }
                ECheckBox {
                    checked: true
                    styleType: EStyle.Success
                    text: ELocale.texts.Option
                }
                ECheckBox {
                    checked: true
                    styleType: EStyle.Warning
                    text: ELocale.texts.Option
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECheckBox"

        ExampleCase {
            objectName: "showcaseECheckBox2"
            title: ELocale.texts.DisabledStates
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ECheckBox {
                        checked: true
                        enabled: false
                        text: ELocale.texts.CannotBeChanged
                    }
                    ECheckBox {
                        checked: false
                        enabled: false
                        text: ELocale.texts.CannotBeChanged
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ECheckBox {
                    checked: true
                    enabled: false
                    text: ELocale.texts.CannotBeChanged
                }
                ECheckBox {
                    checked: false
                    enabled: false
                    text: ELocale.texts.CannotBeChanged
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECheckBox"

        ExampleCase {
            objectName: "showcaseECheckBox3"
            title: ELocale.texts.SelectionBinding
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ECheckBox {
                        id: choice

                        text: ELocale.texts.EnableThisOption
                    }
                    EText {
                        text: choice.checked ? ELocale.texts.Checked : ELocale.texts.Unchecked
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                ECheckBox {
                    id: choice

                    text: ELocale.texts.EnableThisOption
                }
                EText {
                    text: choice.checked ? ELocale.texts.Checked : ELocale.texts.Unchecked
                }
            }
        }
    }
}

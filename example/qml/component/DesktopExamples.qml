import EUI 1.0
import QtQuick 2.15

ExamplePage {
    id: control

    readonly property var definitions: [
    {
        "name": "EFilePicker",
        "cases": [
            {
                "name": "EFilePicker",
                "title": "PickerOpenExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nEFilePicker {\n    width: Math.min(420, parent ? parent.width : 420)\n}\n"
            },
            {
                "name": "EFilePicker",
                "title": "PickerSaveFile",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nEFilePicker {\n    width: Math.min(420, parent ? parent.width : 420)\n    mode: \"save\"\n}\n"
            },
            {
                "name": "EFilePicker",
                "title": "PickerMultipleExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nEFilePicker {\n    width: Math.min(420, parent ? parent.width : 420)\n    multiple: true\n}\n"
            },
            {
                "name": "EFilePicker",
                "title": "PickerFiltersExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nEFilePicker {\n    width: Math.min(420, parent ? parent.width : 420)\n    nameFilters: [\"Text files (*.txt *.qml)\", \"All files (*)\"]\n}\n"
            },
            {
                "name": "EFilePicker",
                "title": "PickerDisabledExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nEFilePicker {\n    width: Math.min(420, parent ? parent.width : 420)\n    enabled: false\n}\n"
            }
        ]
    },
    {
        "name": "EFolderPicker",
        "cases": [
            {
                "name": "EFolderPicker",
                "title": "PickerFolderExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nEFolderPicker {\n    width: Math.min(420, parent ? parent.width : 420)\n}\n"
            },
            {
                "name": "EFolderPicker",
                "title": "PickerInitialFolderExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nEFolderPicker {\n    width: Math.min(420, parent ? parent.width : 420)\n    folder: Qt.resolvedUrl(\".\")\n}\n"
            },
            {
                "name": "EFolderPicker",
                "title": "PickerDisabledExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nEFolderPicker {\n    width: Math.min(420, parent ? parent.width : 420)\n    enabled: false\n}\n"
            },
            {
                "name": "EFolderPicker",
                "title": "PickerBrowse",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nEFolderPicker {\n    width: Math.min(420, parent ? parent.width : 420)\n    clearable: false\n}\n"
            },
            {
                "name": "EFolderPicker",
                "title": "PickerOpenExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nEFolderPicker {\n    width: Math.min(420, parent ? parent.width : 420)\n    size: EStyle.Small\n}\n"
            }
        ]
    },
    {
        "name": "EToolBar",
        "cases": [
            {
                "name": "EToolBar",
                "title": "ToolbarActionsExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nEToolBar {\n    width: Math.min(420, parent ? parent.width : 420)\n    model: [{text: ELocale.texts.DesktopOpen, command: \"open\", iconSource: EIcons.FOLDER},\n        {text: ELocale.texts.DesktopSave, command: \"save\", iconSource: EIcons.COPY},\n        {text: ELocale.texts.DesktopCopy, command: \"copy\", iconSource: EIcons.COPY}]\n}\n"
            },
            {
                "name": "EToolBar",
                "title": "ToolbarOverflowExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nEToolBar {\n    width: Math.min(150, parent ? parent.width : 150)\n    model: [{text: ELocale.texts.DesktopOpen, command: \"open\", iconSource: EIcons.FOLDER},\n        {text: ELocale.texts.DesktopSave, command: \"save\", iconSource: EIcons.COPY},\n        {text: ELocale.texts.DesktopCopy, command: \"copy\", iconSource: EIcons.COPY}]\n}\n"
            },
            {
                "name": "EToolBar",
                "title": "ToolbarCheckedExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nEToolBar {\n    width: Math.min(420, parent ? parent.width : 420)\n    model: [{text: ELocale.texts.DesktopBold, checkable: true}]\n}\n"
            },
            {
                "name": "EToolBar",
                "title": "ToolbarIconsExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nEToolBar {\n    width: Math.min(420, parent ? parent.width : 420)\n    model: [{text: ELocale.texts.DesktopOpen, command: \"open\", iconSource: EIcons.FOLDER},\n        {text: ELocale.texts.DesktopSave, command: \"save\", iconSource: EIcons.COPY},\n        {text: ELocale.texts.DesktopCopy, command: \"copy\", iconSource: EIcons.COPY}]\n    showText: false\n}\n"
            },
            {
                "name": "EToolBar",
                "title": "ToolbarNativeExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nEToolBar {\n    width: Math.min(420, parent ? parent.width : 420)\n    model: [{action: saveAction}]\n\n    Action {\n        id: saveAction\n\n        text: ELocale.texts.DesktopSave\n        checkable: true\n    }\n}\n"
            }
        ]
    },
    {
        "name": "ECodeView",
        "cases": [
            {
                "name": "ECodeView",
                "title": "CodeViewBasicExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nECodeView {\n    width: Math.min(420, parent ? parent.width : 420)\n    height: 160\n    code: \"import EUI 1.0\\n\\nEButton {\\n    text: \\\"Hello\\\"\\n}\\n\"\n}\n"
            },
            {
                "name": "ECodeView",
                "title": "CodeViewNumbersExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nECodeView {\n    width: Math.min(420, parent ? parent.width : 420)\n    height: 160\n    code: \"EInput {\\n    clearable: true\\n}\\n\"\n    showLineNumbers: false\n}\n"
            },
            {
                "name": "ECodeView",
                "title": "CodeViewCopyExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nECodeView {\n    width: Math.min(420, parent ? parent.width : 420)\n    height: 160\n    code: \"EFilePicker {\\n    mode: \\\"save\\\"\\n}\\n\"\n    showCopy: false\n}\n"
            },
            {
                "name": "ECodeView",
                "title": "CodeViewJsExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nECodeView {\n    width: Math.min(420, parent ? parent.width : 420)\n    height: 160\n    code: \"function sum(a, b) {\\n    return a + b\\n}\\n\"\n    language: \"javascript\"\n}\n"
            },
            {
                "name": "ECodeView",
                "title": "CodeViewPlainExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nECodeView {\n    width: Math.min(420, parent ? parent.width : 420)\n    height: 160\n    code: ELocale.texts.DesktopPlainCodeSample\n    language: \"text\"\n}\n"
            }
        ]
    },
    {
        "name": "ECommandPalette",
        "cases": [
            {
                "name": "ECommandPalette",
                "title": "PaletteBasicExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nColumn {\n    width: Math.min(420, parent ? parent.width : 420)\n    spacing: 8\n\n    EButton {\n        text: ELocale.texts.DesktopOpenPalette\n\n        onClicked: palette.open()\n    }\n    ECommandPalette {\n        id: palette\n\n        shortcut: \"\"\n        model: [{text: ELocale.texts.DesktopOpen, command: \"open\", iconSource: EIcons.FOLDER},\n        {text: ELocale.texts.DesktopSave, command: \"save\", iconSource: EIcons.COPY},\n        {text: ELocale.texts.DesktopCopy, command: \"copy\", iconSource: EIcons.COPY}]\n    }\n}\n"
            },
            {
                "name": "ECommandPalette",
                "title": "PaletteKeywordsExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nColumn {\n    width: Math.min(420, parent ? parent.width : 420)\n    spacing: 8\n\n    EButton {\n        text: ELocale.texts.DesktopOpenPalette\n\n        onClicked: palette.open()\n    }\n    ECommandPalette {\n        id: palette\n\n        shortcut: \"\"\n        model: [{text: ELocale.texts.DesktopOpen, command: \"open\", keywords: ELocale.texts.DesktopDocumentKeywords},\n            {text: ELocale.texts.DesktopSave, command: \"save\"}]\n    }\n}\n"
            },
            {
                "name": "ECommandPalette",
                "title": "PaletteDisabledExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nColumn {\n    width: Math.min(420, parent ? parent.width : 420)\n    spacing: 8\n\n    EButton {\n        text: ELocale.texts.DesktopOpenPalette\n\n        onClicked: palette.open()\n    }\n    ECommandPalette {\n        id: palette\n\n        shortcut: \"\"\n        model: [{text: ELocale.texts.DesktopOpen, command: \"open\", enabled: false},\n            {text: ELocale.texts.DesktopSave, command: \"save\"}]\n    }\n}\n"
            },
            {
                "name": "ECommandPalette",
                "title": "PalettePersistentExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nColumn {\n    width: Math.min(420, parent ? parent.width : 420)\n    spacing: 8\n\n    EButton {\n        text: ELocale.texts.DesktopOpenPalette\n\n        onClicked: palette.open()\n    }\n    ECommandPalette {\n        id: palette\n\n        shortcut: \"\"\n        model: [{text: ELocale.texts.DesktopOpen, command: \"open\", iconSource: EIcons.FOLDER},\n        {text: ELocale.texts.DesktopSave, command: \"save\", iconSource: EIcons.COPY},\n        {text: ELocale.texts.DesktopCopy, command: \"copy\", iconSource: EIcons.COPY}]\n        closeOnTrigger: false\n    }\n}\n"
            },
            {
                "name": "ECommandPalette",
                "title": "PaletteNativeExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nColumn {\n    width: Math.min(420, parent ? parent.width : 420)\n    spacing: 8\n\n    EButton {\n        text: ELocale.texts.DesktopOpenPalette\n\n        onClicked: palette.open()\n    }\n    ECommandPalette {\n        id: palette\n\n        shortcut: \"\"\n        model: [{action: saveAction}]\n    }\n    Action {\n        id: saveAction\n\n        text: ELocale.texts.DesktopSave\n    }\n}\n"
            }
        ]
    },
    {
        "name": "EWizard",
        "cases": [
            {
                "name": "EWizard",
                "title": "WizardBasicExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nEWizard {\n    id: wizard\n\n    width: Math.min(520, parent ? parent.width : 520)\n    model: [{title: ELocale.texts.WizardFirstStep, component: firstPage},\n        {title: ELocale.texts.WizardSecondStep, component: reviewPage}]\n\n    Component {\n        id: firstPage\n\n        EInput { placeholderText: ELocale.texts.DesktopNameHint }\n    }\n    Component {\n        id: reviewPage\n\n        EText { text: ELocale.texts.WizardSecondStep }\n    }\n}\n"
            },
            {
                "name": "EWizard",
                "title": "WizardValidationExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nEWizard {\n    id: wizard\n\n    width: Math.min(520, parent ? parent.width : 520)\n    beforeLeave: function(from, to) { return to <= from || wizard.currentPage.text.length > 0 }\n    model: [{title: ELocale.texts.WizardFirstStep, component: firstPage},\n        {title: ELocale.texts.WizardSecondStep, component: reviewPage}]\n\n    Component {\n        id: firstPage\n\n        EInput { placeholderText: ELocale.texts.DesktopNameHint }\n    }\n    Component {\n        id: reviewPage\n\n        EText { text: ELocale.texts.WizardSecondStep }\n    }\n}\n"
            },
            {
                "name": "EWizard",
                "title": "WizardAsyncExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nEWizard {\n    id: wizard\n\n    width: Math.min(520, parent ? parent.width : 520)\n    beforeLeave: function() { return Promise.resolve(true) }\n    model: [{title: ELocale.texts.WizardFirstStep, component: firstPage},\n        {title: ELocale.texts.WizardSecondStep, component: reviewPage}]\n\n    Component {\n        id: firstPage\n\n        EInput { placeholderText: ELocale.texts.DesktopNameHint }\n    }\n    Component {\n        id: reviewPage\n\n        EText { text: ELocale.texts.WizardSecondStep }\n    }\n}\n"
            },
            {
                "name": "EWizard",
                "title": "WizardJumpExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nEWizard {\n    id: wizard\n\n    width: Math.min(520, parent ? parent.width : 520)\n    allowJump: true\n    model: [{title: ELocale.texts.WizardFirstStep, component: firstPage},\n        {title: ELocale.texts.WizardSecondStep, component: reviewPage}]\n\n    Component {\n        id: firstPage\n\n        EInput { placeholderText: ELocale.texts.DesktopNameHint }\n    }\n    Component {\n        id: reviewPage\n\n        EText { text: ELocale.texts.WizardSecondStep }\n    }\n}\n"
            },
            {
                "name": "EWizard",
                "title": "WizardDisabledExample",
                "code": "import EUI 1.0\nimport QtQuick 2.15\nimport QtQuick.Controls 2.15\n\nEWizard {\n    id: wizard\n\n    width: Math.min(520, parent ? parent.width : 520)\n    model: [{title: ELocale.texts.WizardFirstStep, component: firstPage}, {title: ELocale.texts.WizardThirdStep, disabled: true},\n        {title: ELocale.texts.WizardSecondStep, component: reviewPage}]\n\n    Component {\n        id: firstPage\n\n        EInput { placeholderText: ELocale.texts.DesktopNameHint }\n    }\n    Component {\n        id: reviewPage\n\n        EText { text: ELocale.texts.WizardSecondStep }\n    }\n}\n"
            }
        ]
    }
]

    title: ELocale.texts.DesktopComponents

    Repeater {
        model: control.definitions

        ExampleSection {
            id: section

            property var definition: modelData

            exampleCount: 5
            componentName: definition.name

            Column {
                readonly property string code: ""
                readonly property bool hasSource: section.definition.cases.every(function(example) {
                    return example.code.length > 0
                })

                spacing: 24
                width: parent ? parent.width : 0

                Repeater {
                    model: section.definition.cases

                    ExampleCase {
                        id: scenario

                        property var sample: null
                        property var definition: modelData

                        code: definition.code
                        title: ELocale.texts[definition.title]
                        objectName: "showcase" + section.componentName + index

                        Item {
                            id: preview

                            width: parent.width
                            implicitHeight: scenario.sample ? Math.max(48, scenario.sample.implicitHeight,
                                scenario.sample.height) : 160

                            Component.onCompleted: {
                                scenario.sample = Qt.createQmlObject(scenario.code, preview, scenario.objectName)
                            }
                        }
                    }
                }
            }
        }
    }
}

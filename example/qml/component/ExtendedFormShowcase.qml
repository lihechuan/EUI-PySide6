import EUI 1.0
import QtQuick 2.15

Column {
    spacing: 24
    width: parent.width

    ExampleSection {
        componentName: "ERadioGroup"

        ExampleCase {
            objectName: "showcaseERadioGroup0"
            title: ELocale.texts.ButtonGroupSizes
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ERadioGroup {
                        buttonStyle: true
                        size: EStyle.Small
                        options: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                    }
                    ERadioGroup {
                        buttonStyle: true
                        size: EStyle.Medium
                        options: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                    }
                    ERadioGroup {
                        buttonStyle: true
                        size: EStyle.Large
                        options: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                ERadioGroup {
                    buttonStyle: true
                    size: EStyle.Small
                    options: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                }
                ERadioGroup {
                    buttonStyle: true
                    size: EStyle.Medium
                    options: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                }
                ERadioGroup {
                    buttonStyle: true
                    size: EStyle.Large
                    options: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERadioGroup"

        ExampleCase {
            objectName: "showcaseERadioGroup1"
            title: ELocale.texts.ValuesAndDisabledOptions
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ERadioGroup {
                        id: choices

                        options: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                    }
                    EText {
                        text: choices.value === undefined ? ELocale.texts.NotSelected : JSON.stringify(choices.value)
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                ERadioGroup {
                    id: choices

                    options: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                }
                EText {
                    text: choices.value === undefined ? ELocale.texts.NotSelected : JSON.stringify(choices.value)
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERadioGroup"

        ExampleCase {
            objectName: "showcaseERadioGroup2"
            title: ELocale.texts.DisabledGroup
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ERadioGroup {
                    enabled: false
                    buttonStyle: true
                    options: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                }
            `)

            ERadioGroup {
                enabled: false
                buttonStyle: true
                options: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
            }
        }
    }
    ExampleSection {
        componentName: "ECheckBoxGroup"

        ExampleCase {
            objectName: "showcaseECheckBoxGroup0"
            title: ELocale.texts.ButtonGroupSizes
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ECheckBoxGroup {
                        buttonStyle: true
                        size: EStyle.Small
                        options: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                    }
                    ECheckBoxGroup {
                        buttonStyle: true
                        size: EStyle.Medium
                        options: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                    }
                    ECheckBoxGroup {
                        buttonStyle: true
                        size: EStyle.Large
                        options: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                ECheckBoxGroup {
                    buttonStyle: true
                    size: EStyle.Small
                    options: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                }
                ECheckBoxGroup {
                    buttonStyle: true
                    size: EStyle.Medium
                    options: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                }
                ECheckBoxGroup {
                    buttonStyle: true
                    size: EStyle.Large
                    options: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECheckBoxGroup"

        ExampleCase {
            objectName: "showcaseECheckBoxGroup1"
            title: ELocale.texts.ValuesAndDisabledOptions
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ECheckBoxGroup {
                        id: choices

                        options: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                    }
                    EText {
                        text: JSON.stringify(choices.value)
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                ECheckBoxGroup {
                    id: choices

                    options: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                }
                EText {
                    text: JSON.stringify(choices.value)
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECheckBoxGroup"

        ExampleCase {
            title: ELocale.texts.DisabledGroup
            objectName: "showcaseECheckBoxGroup2"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ECheckBoxGroup {
                    enabled: false
                    buttonStyle: true
                    options: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                }
            `)

            ECheckBoxGroup {
                enabled: false
                buttonStyle: true
                options: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
            }
        }
    }
    ExampleSection {
        componentName: "EUpload"

        ExampleCase {
            objectName: "showcaseEUpload0"
            title: ELocale.texts.ManualImageSelection
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EUpload {
                    limit: 3
                    multiple: true
                    autoUpload: false
                    maxFileSize: 2097152
                    accept: ".png,.jpg,.svg"
                }
            `)

            EUpload {
                limit: 3
                multiple: true
                autoUpload: false
                maxFileSize: 2097152
                accept: ".png,.jpg,.svg"
            }
        }
    }
    ExampleSection {
        componentName: "EUpload"

        ExampleCase {
            title: ELocale.texts.DropZone
            objectName: "showcaseEUpload1"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EUpload {
                    drag: true
                    multiple: true
                    autoUpload: false
                    showFileList: true
                    width: Math.min(480, parent.width)
                }
            `)

            EUpload {
                drag: true
                multiple: true
                autoUpload: false
                showFileList: true
                width: Math.min(480, parent.width)
            }
        }
    }
    ExampleSection {
        componentName: "EUpload"

        ExampleCase {
            objectName: "showcaseEUpload2"
            title: ELocale.texts.PictureCards
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EUpload {
                    limit: 4
                    autoUpload: false
                    pictureCardSize: 96
                    listType: "picture-card"
                    fileList: [{url: "qrc:/example/images/gallery/lake.jpg", name: "lake.jpg", status: "ready"},
                        {url: "qrc:/example/images/gallery/tree.jpg", name: "tree.jpg", status: "ready"},
                        {url: "qrc:/example/images/gallery/ocean.jpg", name: "ocean.jpg", status: "ready"}]
                }
            `)

            EUpload {
                limit: 4
                autoUpload: false
                pictureCardSize: 96
                listType: "picture-card"
                fileList: [{url: "qrc:/example/images/gallery/lake.jpg", name: "lake.jpg", status: "ready"},
                    {url: "qrc:/example/images/gallery/tree.jpg", name: "tree.jpg", status: "ready"},
                    {url: "qrc:/example/images/gallery/ocean.jpg", name: "ocean.jpg", status: "ready"}]
            }
        }
    }
    ExampleSection {
        componentName: "EMention"

        ExampleCase {
            objectName: "showcaseEMention0"
            title: ELocale.texts.MultiplePrefixes
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EMention {
                    prefix: ["@", "#"]
                    width: Math.min(480, parent.width)
                    placeholderText: ELocale.texts.TypeOrToChooseATechnology
                    options: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                }
            `)

            EMention {
                prefix: ["@", "#"]
                width: Math.min(480, parent.width)
                placeholderText: ELocale.texts.TypeOrToChooseATechnology
                options: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
            }
        }
    }
    ExampleSection {
        componentName: "EMention"

        ExampleCase {
            objectName: "showcaseEMention1"
            title: ELocale.texts.MultilineMentions
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EMention {
                    height: 120
                    type: "textarea"
                    width: Math.min(480, parent.width)
                    placeholderText: ELocale.texts.TypeInTheMultilineDescription
                    options: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                }
            `)

            EMention {
                height: 120
                type: "textarea"
                width: Math.min(480, parent.width)
                placeholderText: ELocale.texts.TypeInTheMultilineDescription
                options: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
            }
        }
    }
    ExampleSection {
        componentName: "EMention"

        ExampleCase {
            objectName: "showcaseEMention2"
            title: ELocale.texts.WholeMentions
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EMention {
                    split: " "
                    whole: true
                    showArrow: true
                    width: Math.min(480, parent.width)
                    options: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                }
            `)

            EMention {
                split: " "
                whole: true
                showArrow: true
                width: Math.min(480, parent.width)
                options: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
            }
        }
    }
    ExampleSection {
        componentName: "ECaptcha"

        ExampleCase {
            objectName: "showcaseECaptcha0"
            title: ELocale.texts.CaptchaLengths
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ECaptcha {
                        length: 4
                        height: 60
                        width: 160
                    }
                    ECaptcha {
                        length: 6
                        height: 60
                        width: 160
                    }
                    ECaptcha {
                        length: 8
                        height: 60
                        width: 160
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ECaptcha {
                    length: 4
                    height: 60
                    width: 160
                }
                ECaptcha {
                    length: 6
                    height: 60
                    width: 160
                }
                ECaptcha {
                    length: 8
                    height: 60
                    width: 160
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECaptcha"

        ExampleCase {
            objectName: "showcaseECaptcha1"
            title: ELocale.texts.CaptchaColors
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ECaptcha {
                    length: 6
                    height: 72
                    width: 220
                    color: "#DDEEFF"
                    backgroundColor: "#173958"
                }
            `)

            ECaptcha {
                length: 6
                height: 72
                width: 220
                color: "#DDEEFF"
                backgroundColor: "#173958"
            }
        }
    }
    ExampleSection {
        componentName: "ECaptcha"

        ExampleCase {
            objectName: "showcaseECaptcha2"
            title: ELocale.texts.ManualRefresh
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ECaptcha {
                        id: captcha

                        height: 64
                        width: 200
                    }
                    EButton {
                        text: ELocale.texts.RefreshImage

                        onClicked: captcha.refresh()
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                ECaptcha {
                    id: captcha

                    height: 64
                    width: 200
                }
                EButton {
                    text: ELocale.texts.RefreshImage

                    onClicked: captcha.refresh()
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECaptcha"

        ExampleCase {
            objectName: "showcaseECaptcha3"
            title: ELocale.texts.CaptchaValidation
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ECaptcha {
                        id: captcha

                        height: 64
                        width: 200
                    }
                    EInput {
                        id: field

                        width: Math.min(480, parent.width)
                        placeholderText: ELocale.texts.EnterTheVerificationCode
                    }
                    EButton {
                        text: ELocale.texts.Verify

                        onClicked: result.text = captcha.verify(field.text) ? ELocale.texts.VerificationSuccessful : ELocale.texts.PleaseTryAgain
                    }
                    EText {
                        id: result

                        text: ELocale.texts.TheVerificationCodeIsCaseSensitive
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                ECaptcha {
                    id: captcha

                    height: 64
                    width: 200
                }
                EInput {
                    id: field

                    width: Math.min(480, parent.width)
                    placeholderText: ELocale.texts.EnterTheVerificationCode
                }
                EButton {
                    text: ELocale.texts.Verify

                    onClicked: result.text = captcha.verify(field.text) ? ELocale.texts.VerificationSuccessful : ELocale.texts.PleaseTryAgain
                }
                EText {
                    id: result

                    text: ELocale.texts.TheVerificationCodeIsCaseSensitive
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETransfer"

        ExampleCase {
            objectName: "showcaseETransfer0"
            title: ELocale.texts.SelectionAndOrder
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ETransfer {
                    value: ["qt"]
                    targetOrder: "push"
                    width: Math.min(640, parent.width)
                    rightTitle: ELocale.texts.ProjectTechnologies
                    leftTitle: ELocale.texts.AvailableTechnologies
                    props: ({key: "value", label: "label", disabled: "disabled"})
                    data: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                }
            `)

            ETransfer {
                value: ["qt"]
                targetOrder: "push"
                width: Math.min(640, parent.width)
                rightTitle: ELocale.texts.ProjectTechnologies
                leftTitle: ELocale.texts.AvailableTechnologies
                props: ({key: "value", label: "label", disabled: "disabled"})
                data: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
            }
        }
    }
    ExampleSection {
        componentName: "ETransfer"

        ExampleCase {
            objectName: "showcaseETransfer1"
            title: ELocale.texts.FilterableTransfer
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ETransfer {
                    filterable: true
                    width: Math.min(640, parent.width)
                    props: ({key: "value", label: "label", disabled: "disabled"})
                    data: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                }
            `)

            ETransfer {
                filterable: true
                width: Math.min(640, parent.width)
                props: ({key: "value", label: "label", disabled: "disabled"})
                data: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
            }
        }
    }
    ExampleSection {
        componentName: "ETransfer"

        ExampleCase {
            objectName: "showcaseETransfer2"
            title: ELocale.texts.DisabledTransfer
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ETransfer {
                    enabled: false
                    value: ["qml"]
                    width: Math.min(640, parent.width)
                    props: ({key: "value", label: "label", disabled: "disabled"})
                    data: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
                }
            `)

            ETransfer {
                enabled: false
                value: ["qml"]
                width: Math.min(640, parent.width)
                props: ({key: "value", label: "label", disabled: "disabled"})
                data: [{label: "QML", value: "qml"}, {label: "Qt", value: "qt"}, {label: "C++", value: "cpp", disabled: true}]
            }
        }
    }
    ExampleSection {
        componentName: "ECascader"

        ExampleCase {
            title: ELocale.texts.LeafValues
            objectName: "showcaseECascader0"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ECascader {
                    clearable: true
                    emitPath: false
                    width: Math.min(480, parent.width)
                    options: [{id: "design", value: "design", label: ELocale.texts.Design, children: [{id: "icon", value: "icon", label: ELocale.texts.Icon}, {id: "theme", value: "theme", label: ELocale.texts.Theme}]}, {id: "dev", value: "dev", label: ELocale.texts.Engineering, children: [{id: "qml", value: "qml", label: "QML"}, {id: "cpp", value: "cpp", label: "C++"}]}]
                }
            `)

            ECascader {
                clearable: true
                emitPath: false
                width: Math.min(480, parent.width)
                options: [{id: "design", value: "design", label: ELocale.texts.Design, children: [{id: "icon", value: "icon", label: ELocale.texts.Icon}, {id: "theme", value: "theme", label: ELocale.texts.Theme}]}, {id: "dev", value: "dev", label: ELocale.texts.Engineering, children: [{id: "qml", value: "qml", label: "QML"}, {id: "cpp", value: "cpp", label: "C++"}]}]
            }
        }
    }
    ExampleSection {
        componentName: "ECascader"

        ExampleCase {
            objectName: "showcaseECascader1"
            title: ELocale.texts.MultiplePaths
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ECascader {
                    multiple: true
                    collapseTags: true
                    maxCollapseTags: 1
                    width: Math.min(480, parent.width)
                    options: [{id: "design", value: "design", label: ELocale.texts.Design, children: [{id: "icon", value: "icon", label: ELocale.texts.Icon}, {id: "theme", value: "theme", label: ELocale.texts.Theme}]}, {id: "dev", value: "dev", label: ELocale.texts.Engineering, children: [{id: "qml", value: "qml", label: "QML"}, {id: "cpp", value: "cpp", label: "C++"}]}]
                }
            `)

            ECascader {
                multiple: true
                collapseTags: true
                maxCollapseTags: 1
                width: Math.min(480, parent.width)
                options: [{id: "design", value: "design", label: ELocale.texts.Design, children: [{id: "icon", value: "icon", label: ELocale.texts.Icon}, {id: "theme", value: "theme", label: ELocale.texts.Theme}]}, {id: "dev", value: "dev", label: ELocale.texts.Engineering, children: [{id: "qml", value: "qml", label: "QML"}, {id: "cpp", value: "cpp", label: "C++"}]}]
            }
        }
    }
    ExampleSection {
        componentName: "ECascader"

        ExampleCase {
            objectName: "showcaseECascader2"
            title: ELocale.texts.FilteringAndStrictSelection
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ECascader {
                    filterable: true
                    separator: " → "
                    checkStrictly: true
                    width: Math.min(480, parent.width)
                    options: [{id: "design", value: "design", label: ELocale.texts.Design, children: [{id: "icon", value: "icon", label: ELocale.texts.Icon}, {id: "theme", value: "theme", label: ELocale.texts.Theme}]}, {id: "dev", value: "dev", label: ELocale.texts.Engineering, children: [{id: "qml", value: "qml", label: "QML"}, {id: "cpp", value: "cpp", label: "C++"}]}]
                }
            `)

            ECascader {
                filterable: true
                separator: " → "
                checkStrictly: true
                width: Math.min(480, parent.width)
                options: [{id: "design", value: "design", label: ELocale.texts.Design, children: [{id: "icon", value: "icon", label: ELocale.texts.Icon}, {id: "theme", value: "theme", label: ELocale.texts.Theme}]}, {id: "dev", value: "dev", label: ELocale.texts.Engineering, children: [{id: "qml", value: "qml", label: "QML"}, {id: "cpp", value: "cpp", label: "C++"}]}]
            }
        }
    }
    ExampleSection {
        componentName: "EInputTag"

        ExampleCase {
            objectName: "showcaseEInputTag0"
            title: ELocale.texts.TagLimitsAndCollapse
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EInputTag {
                    max: 6
                    clearable: true
                    collapseTags: true
                    maxCollapseTags: 2
                    width: Math.min(480, parent.width)
                    value: ["QML", "Qt", "C++", ELocale.texts.Design]
                }
            `)

            EInputTag {
                max: 6
                clearable: true
                collapseTags: true
                maxCollapseTags: 2
                width: Math.min(480, parent.width)
                value: ["QML", "Qt", "C++", ELocale.texts.Design]
            }
        }
    }
    ExampleSection {
        componentName: "EInputTag"

        ExampleCase {
            objectName: "showcaseEInputTag1"
            title: ELocale.texts.ReadOnlyTags
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EInputTag {
                    enabled: false
                    closable: false
                    width: Math.min(480, parent.width)
                    value: [ELocale.texts.Desktop, ELocale.texts.Web]
                    prefixComponent: Component {
                        EIcon {
                            iconSize: 16
                            iconSource: EIcons.TAG
                        }
                    }
                }
            `)

            EInputTag {
                enabled: false
                closable: false
                width: Math.min(480, parent.width)
                value: [ELocale.texts.Desktop, ELocale.texts.Web]
                prefixComponent: Component {
                    EIcon {
                        iconSize: 16
                        iconSource: EIcons.TAG
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EInputTag"

        ExampleCase {
            objectName: "showcaseEInputTag2"
            title: ELocale.texts.DelimiterAndSorting
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EInputTag {
                    delimiter: ","
                    draggable: true
                    value: ["QML", "Qt", "C++"]
                    width: Math.min(480, parent.width)
                    placeholderText: ELocale.texts.TypeACommaToCompleteATag
                }
            `)

            EInputTag {
                delimiter: ","
                draggable: true
                value: ["QML", "Qt", "C++"]
                width: Math.min(480, parent.width)
                placeholderText: ELocale.texts.TypeACommaToCompleteATag
            }
        }
    }
    ExampleSection {
        componentName: "EInputOtp"

        ExampleCase {
            objectName: "showcaseEInputOtp0"
            title: ELocale.texts.CodeLengths
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    EInputOtp {
                        length: 4
                        numericOnly: true
                        size: EStyle.Small
                    }
                    EInputOtp {
                        length: 6
                        numericOnly: true
                        size: EStyle.Small
                    }
                    EInputOtp {
                        length: 8
                        numericOnly: true
                        size: EStyle.Small
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                EInputOtp {
                    length: 4
                    numericOnly: true
                    size: EStyle.Small
                }
                EInputOtp {
                    length: 6
                    numericOnly: true
                    size: EStyle.Small
                }
                EInputOtp {
                    length: 8
                    numericOnly: true
                    size: EStyle.Small
                }
            }
        }
    }
    ExampleSection {
        componentName: "EInputOtp"

        ExampleCase {
            objectName: "showcaseEInputOtp1"
            title: ELocale.texts.MaskedAlphanumericCode
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EInputOtp {
                    length: 6
                    masked: true
                    value: "ABC123"
                    numericOnly: false
                }
            `)

            EInputOtp {
                length: 6
                masked: true
                value: "ABC123"
                numericOnly: false
            }
        }
    }
    ExampleSection {
        componentName: "EInputOtp"

        ExampleCase {
            objectName: "showcaseEInputOtp2"
            title: ELocale.texts.DisabledCode
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EInputOtp {
                    length: 6
                    enabled: false
                    value: "123456"
                }
            `)

            EInputOtp {
                length: 6
                enabled: false
                value: "123456"
            }
        }
    }
    ExampleSection {
        componentName: "EInputOtp"

        ExampleCase {
            objectName: "showcaseEInputOtp3"
            title: ELocale.texts.CodeCompletion
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EInputOtp {
                        id: otp

                        length: 4
                        numericOnly: true
                    }
                    EText {
                        text: otp.value.length === 4 ? ELocale.texts.InputComplete + otp.value : ELocale.texts.WaitingForTheCompleteVerificationCode
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EInputOtp {
                    id: otp

                    length: 4
                    numericOnly: true
                }
                EText {
                    text: otp.value.length === 4 ? ELocale.texts.InputComplete + otp.value : ELocale.texts.WaitingForTheCompleteVerificationCode
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETimeSelect"

        ExampleCase {
            title: ELocale.texts.WorkingHours
            objectName: "showcaseETimeSelect0"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ETimeSelect {
                    end: "18:00"
                    step: "00:30"
                    start: "09:00"
                    width: Math.min(480, parent.width)
                }
            `)

            ETimeSelect {
                end: "18:00"
                step: "00:30"
                start: "09:00"
                width: Math.min(480, parent.width)
            }
        }
    }
    ExampleSection {
        componentName: "ETimeSelect"

        ExampleCase {
            title: ELocale.texts.TimeBounds
            objectName: "showcaseETimeSelect1"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ETimeSelect {
                    end: "12:00"
                    step: "00:15"
                    start: "08:00"
                    maxTime: "11:30"
                    minTime: "09:00"
                    includeEndTime: true
                    width: Math.min(480, parent.width)
                }
            `)

            ETimeSelect {
                end: "12:00"
                step: "00:15"
                start: "08:00"
                maxTime: "11:30"
                minTime: "09:00"
                includeEndTime: true
                width: Math.min(480, parent.width)
            }
        }
    }
    ExampleSection {
        componentName: "ETimeSelect"

        ExampleCase {
            objectName: "showcaseETimeSelect2"
            title: ELocale.texts.DisabledFormat
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ETimeSelect {
                    end: "17:00"
                    enabled: false
                    start: "09:00"
                    format: "hh:mm AP"
                    width: Math.min(480, parent.width)
                }
            `)

            ETimeSelect {
                end: "17:00"
                enabled: false
                start: "09:00"
                format: "hh:mm AP"
                width: Math.min(480, parent.width)
            }
        }
    }
    ExampleSection {
        componentName: "ETreeSelect"

        ExampleCase {
            objectName: "showcaseETreeSelect0"
            title: ELocale.texts.LeafSelection
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ETreeSelect {
                    nodeKey: "id"
                    leavesOnly: true
                    defaultExpandAll: true
                    width: Math.min(480, parent.width)
                    data: [{id: "design", value: "design", label: ELocale.texts.Design, children: [{id: "icon", value: "icon", label: ELocale.texts.Icon}, {id: "theme", value: "theme", label: ELocale.texts.Theme}]}, {id: "dev", value: "dev", label: ELocale.texts.Engineering, children: [{id: "qml", value: "qml", label: "QML"}, {id: "cpp", value: "cpp", label: "C++"}]}]
                }
            `)

            ETreeSelect {
                nodeKey: "id"
                leavesOnly: true
                defaultExpandAll: true
                width: Math.min(480, parent.width)
                data: [{id: "design", value: "design", label: ELocale.texts.Design, children: [{id: "icon", value: "icon", label: ELocale.texts.Icon}, {id: "theme", value: "theme", label: ELocale.texts.Theme}]}, {id: "dev", value: "dev", label: ELocale.texts.Engineering, children: [{id: "qml", value: "qml", label: "QML"}, {id: "cpp", value: "cpp", label: "C++"}]}]
            }
        }
    }
    ExampleSection {
        componentName: "ETreeSelect"

        ExampleCase {
            objectName: "showcaseETreeSelect1"
            title: ELocale.texts.IndependentSelection
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ETreeSelect {
                    nodeKey: "id"
                    showCheckbox: true
                    checkStrictly: true
                    defaultExpandAll: true
                    width: Math.min(480, parent.width)
                    data: [{id: "design", value: "design", label: ELocale.texts.Design, children: [{id: "icon", value: "icon", label: ELocale.texts.Icon}, {id: "theme", value: "theme", label: ELocale.texts.Theme}]}, {id: "dev", value: "dev", label: ELocale.texts.Engineering, children: [{id: "qml", value: "qml", label: "QML"}, {id: "cpp", value: "cpp", label: "C++"}]}]
                }
            `)

            ETreeSelect {
                nodeKey: "id"
                showCheckbox: true
                checkStrictly: true
                defaultExpandAll: true
                width: Math.min(480, parent.width)
                data: [{id: "design", value: "design", label: ELocale.texts.Design, children: [{id: "icon", value: "icon", label: ELocale.texts.Icon}, {id: "theme", value: "theme", label: ELocale.texts.Theme}]}, {id: "dev", value: "dev", label: ELocale.texts.Engineering, children: [{id: "qml", value: "qml", label: "QML"}, {id: "cpp", value: "cpp", label: "C++"}]}]
            }
        }
    }
    ExampleSection {
        componentName: "ETreeSelect"

        ExampleCase {
            objectName: "showcaseETreeSelect2"
            title: ELocale.texts.ExpandedDisabledTree
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ETreeSelect {
                    nodeKey: "id"
                    enabled: false
                    expandedKeys: ["design"]
                    width: Math.min(480, parent.width)
                    data: [{id: "design", value: "design", label: ELocale.texts.Design, children: [{id: "icon", value: "icon", label: ELocale.texts.Icon}, {id: "theme", value: "theme", label: ELocale.texts.Theme}]}, {id: "dev", value: "dev", label: ELocale.texts.Engineering, children: [{id: "qml", value: "qml", label: "QML"}, {id: "cpp", value: "cpp", label: "C++"}]}]
                }
            `)

            ETreeSelect {
                nodeKey: "id"
                enabled: false
                expandedKeys: ["design"]
                width: Math.min(480, parent.width)
                data: [{id: "design", value: "design", label: ELocale.texts.Design, children: [{id: "icon", value: "icon", label: ELocale.texts.Icon}, {id: "theme", value: "theme", label: ELocale.texts.Theme}]}, {id: "dev", value: "dev", label: ELocale.texts.Engineering, children: [{id: "qml", value: "qml", label: "QML"}, {id: "cpp", value: "cpp", label: "C++"}]}]
            }
        }
    }
    ExampleSection {
        componentName: "EColorPicker"

        ExampleCase {
            title: ELocale.texts.AlphaAndRGB
            objectName: "showcaseEColorPicker0"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EColorPicker {
                    showAlpha: true
                    colorFormat: "rgb"
                    value: "#80409EFF"
                }
            `)

            EColorPicker {
                showAlpha: true
                colorFormat: "rgb"
                value: "#80409EFF"
            }
        }
    }
    ExampleSection {
        componentName: "EColorPicker"

        ExampleCase {
            objectName: "showcaseEColorPicker1"
            title: ELocale.texts.PresetsAndLiveUpdates
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EColorPicker {
                    value: "#67c23a"
                    showButtons: false
                    commitOnConfirm: false
                    predefine: ["#409EFF", "#67c23a", "#e6a23c", "#e6a23c"]
                }
            `)

            EColorPicker {
                value: "#67c23a"
                showButtons: false
                commitOnConfirm: false
                predefine: ["#409EFF", "#67c23a", "#e6a23c", "#e6a23c"]
            }
        }
    }
    ExampleSection {
        componentName: "EColorPicker"

        ExampleCase {
            title: ELocale.texts.OpaqueColor
            objectName: "showcaseEColorPicker2"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EColorPicker {
                    clearable: false
                    showAlpha: false
                    value: "#409EFF"
                    colorFormat: "hex"
                }
            `)

            EColorPicker {
                clearable: false
                showAlpha: false
                value: "#409EFF"
                colorFormat: "hex"
            }
        }
    }
    ExampleSection {
        componentName: "ERangeSlider"

        ExampleCase {
            title: ELocale.texts.StepsAndStops
            objectName: "showcaseERangeSlider0"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ERangeSlider {
                    from: 0
                    to: 100
                    stepSize: 10
                    first.value: 20
                    showStops: true
                    second.value: 70
                    width: Math.min(480, parent.width)
                }
            `)

            ERangeSlider {
                from: 0
                to: 100
                stepSize: 10
                first.value: 20
                showStops: true
                second.value: 70
                width: Math.min(480, parent.width)
            }
        }
    }
    ExampleSection {
        componentName: "ERangeSlider"

        ExampleCase {
            objectName: "showcaseERangeSlider1"
            title: ELocale.texts.MarksAndFormattedTooltip
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ERangeSlider {
                    from: 0
                    to: 100
                    first.value: 20
                    second.value: 70
                    width: Math.min(480, parent.width)
                    formatTooltip: function(value) { return Math.round(value) + "%" }
                    marks: ({0: ELocale.texts.Lowest, 25: ELocale.texts.Recommended, 75: ELocale.texts.Higher, 100: ELocale.texts.Highest})
                }
            `)

            ERangeSlider {
                from: 0
                to: 100
                first.value: 20
                second.value: 70
                width: Math.min(480, parent.width)
                formatTooltip: function(value) { return Math.round(value) + "%" }
                marks: ({0: ELocale.texts.Lowest, 25: ELocale.texts.Recommended, 75: ELocale.texts.Higher, 100: ELocale.texts.Highest})
            }
        }
    }
    ExampleSection {
        componentName: "ERangeSlider"

        ExampleCase {
            title: ELocale.texts.DisabledRange
            objectName: "showcaseERangeSlider2"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ERangeSlider {
                    enabled: false
                    first.value: 20
                    second.value: 70
                    showTooltip: false
                    width: Math.min(480, parent.width)
                }
            `)

            ERangeSlider {
                enabled: false
                first.value: 20
                second.value: 70
                showTooltip: false
                width: Math.min(480, parent.width)
            }
        }
    }
    ExampleSection {
        componentName: "EShortcutPicker"

        ExampleCase {
            title: ELocale.texts.DefaultShortcut
            objectName: "showcaseEShortcutPicker0"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EShortcutPicker {
                    sequence: "Ctrl+Shift+S"
                    width: Math.min(480, parent.width)
                }
            `)

            EShortcutPicker {
                sequence: "Ctrl+Shift+S"
                width: Math.min(480, parent.width)
            }
        }
    }
    ExampleSection {
        componentName: "EShortcutPicker"

        ExampleCase {
            title: ELocale.texts.ShortcutBinding
            objectName: "showcaseEShortcutPicker1"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EShortcutPicker {
                        id: shortcut

                        width: Math.min(480, parent.width)
                    }
                    EText {
                        text: shortcut.sequence.length > 0 ? shortcut.sequence : ELocale.texts.ClickToRecordAShortcut
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EShortcutPicker {
                    id: shortcut

                    width: Math.min(480, parent.width)
                }
                EText {
                    text: shortcut.sequence.length > 0 ? shortcut.sequence : ELocale.texts.ClickToRecordAShortcut
                }
            }
        }
    }
    ExampleSection {
        componentName: "EShortcutPicker"

        ExampleCase {
            title: ELocale.texts.DisabledPicker
            objectName: "showcaseEShortcutPicker2"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EShortcutPicker {
                    enabled: false
                    sequence: "Alt+F4"
                    width: Math.min(480, parent.width)
                }
            `)

            EShortcutPicker {
                enabled: false
                sequence: "Alt+F4"
                width: Math.min(480, parent.width)
            }
        }
    }
    ExampleSection {
        componentName: "EShortcutPicker"

        ExampleCase {
            title: ELocale.texts.ClearAndRecord
            objectName: "showcaseEShortcutPicker3"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EShortcutPicker {
                        id: shortcut

                        sequence: "Ctrl+K"
                        width: Math.min(480, parent.width)
                    }
                    EButton {
                        text: ELocale.texts.ClearShortcut

                        onClicked: shortcut.sequence = ""
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EShortcutPicker {
                    id: shortcut

                    sequence: "Ctrl+K"
                    width: Math.min(480, parent.width)
                }
                EButton {
                    text: ELocale.texts.ClearShortcut

                    onClicked: shortcut.sequence = ""
                }
            }
        }
    }
    ExampleSection {
        componentName: "EDateTimePicker"

        ExampleCase {
            title: ELocale.texts.TimeRanges
            objectName: "showcaseEDateTimePicker0"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EDateTimePicker {
                    isRange: true
                    width: Math.min(480, parent.width)
                    endPlaceholder: ELocale.texts.EndTime
                    startPlaceholder: ELocale.texts.StartTime
                }
            `)

            EDateTimePicker {
                isRange: true
                width: Math.min(480, parent.width)
                endPlaceholder: ELocale.texts.EndTime
                startPlaceholder: ELocale.texts.StartTime
            }
        }
    }
    ExampleSection {
        componentName: "EDateTimePicker"

        ExampleCase {
            title: ELocale.texts.DisabledTimes
            objectName: "showcaseEDateTimePicker1"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EDateTimePicker {
                    width: Math.min(480, parent.width)
                    disabledHours: function() { return [0, 1, 2, 3, 4, 5, 23] }
                    disabledMinutes: function(hour) { return hour === 6 ? [0, 15, 30] : [] }
                }
            `)

            EDateTimePicker {
                width: Math.min(480, parent.width)
                disabledHours: function() { return [0, 1, 2, 3, 4, 5, 23] }
                disabledMinutes: function(hour) { return hour === 6 ? [0, 15, 30] : [] }
            }
        }
    }
    ExampleSection {
        componentName: "EDateTimePicker"

        ExampleCase {
            objectName: "showcaseEDateTimePicker2"
            title: ELocale.texts.ArrowControlsAndFormats
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EDateTimePicker {
                    arrowControl: true
                    timeFormat: "HH:mm"
                    dateFormat: "yyyy/MM/dd"
                    width: Math.min(480, parent.width)
                }
            `)

            EDateTimePicker {
                arrowControl: true
                timeFormat: "HH:mm"
                dateFormat: "yyyy/MM/dd"
                width: Math.min(480, parent.width)
            }
        }
    }
    ExampleSection {
        componentName: "EColorPickerPanel"

        ExampleCase {
            title: ELocale.texts.AlphaAndRGB
            objectName: "showcaseEColorPickerPanel0"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EColorPickerPanel {
                    showAlpha: true
                    colorFormat: "rgb"
                    value: "#80409EFF"
                }
            `)

            EColorPickerPanel {
                showAlpha: true
                colorFormat: "rgb"
                value: "#80409EFF"
            }
        }
    }
    ExampleSection {
        componentName: "EColorPickerPanel"

        ExampleCase {
            objectName: "showcaseEColorPickerPanel1"
            title: ELocale.texts.PresetsAndLiveUpdates
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EColorPickerPanel {
                    value: "#67c23a"
                    showButtons: false
                    commitOnConfirm: false
                    predefine: ["#409EFF", "#67c23a", "#e6a23c", "#e6a23c"]
                }
            `)

            EColorPickerPanel {
                value: "#67c23a"
                showButtons: false
                commitOnConfirm: false
                predefine: ["#409EFF", "#67c23a", "#e6a23c", "#e6a23c"]
            }
        }
    }
    ExampleSection {
        componentName: "EColorPickerPanel"

        ExampleCase {
            title: ELocale.texts.OpaqueColor
            objectName: "showcaseEColorPickerPanel2"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EColorPickerPanel {
                    clearable: false
                    showAlpha: false
                    value: "#409EFF"
                    colorFormat: "hex"
                }
            `)

            EColorPickerPanel {
                clearable: false
                showAlpha: false
                value: "#409EFF"
                colorFormat: "hex"
            }
        }
    }
}

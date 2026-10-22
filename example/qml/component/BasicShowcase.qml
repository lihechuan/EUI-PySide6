import EUI 1.0
import QtQuick 2.15

Column {
    spacing: 24
    width: parent.width

    ExampleSection {
        componentName: "EIcon"

        ExampleCase {
            objectName: "showcaseEIcon0"
            title: ELocale.texts.AccentColors
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    EIcon {
                        iconSize: 32
                        color: "#409EFF"
                        iconSource: EIcons.PALETTE
                    }
                    EIcon {
                        iconSize: 32
                        color: "#67c23a"
                        iconSource: EIcons.PALETTE
                    }
                    EIcon {
                        iconSize: 32
                        color: "#e6a23c"
                        iconSource: EIcons.PALETTE
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                EIcon {
                    iconSize: 32
                    color: "#409EFF"
                    iconSource: EIcons.PALETTE
                }
                EIcon {
                    iconSize: 32
                    color: "#67c23a"
                    iconSource: EIcons.PALETTE
                }
                EIcon {
                    iconSize: 32
                    color: "#e6a23c"
                    iconSource: EIcons.PALETTE
                }
            }
        }
    }
    ExampleSection {
        componentName: "EIcon"

        ExampleCase {
            objectName: "showcaseEIcon1"
            title: ELocale.texts.LabeledIconAction
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EButton {
                    leftIcon: true
                    iconSource: EIcons.PENCIL
                    styleType: EStyle.Primary
                    text: ELocale.texts.EditProject
                }
            `)

            EButton {
                leftIcon: true
                iconSource: EIcons.PENCIL
                styleType: EStyle.Primary
                text: ELocale.texts.EditProject
            }
        }
    }
    ExampleSection {
        componentName: "EIcon"

        ExampleCase {
            objectName: "showcaseEIcon2"
            title: ELocale.texts.IconScale
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    EIcon {
                        iconSize: 16
                        iconSource: EIcons.PALETTE
                    }
                    EIcon {
                        iconSize: 24
                        iconSource: EIcons.PALETTE
                    }
                    EIcon {
                        iconSize: 32
                        iconSource: EIcons.PALETTE
                    }
                    EIcon {
                        iconSize: 48
                        iconSource: EIcons.PALETTE
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                EIcon {
                    iconSize: 16
                    iconSource: EIcons.PALETTE
                }
                EIcon {
                    iconSize: 24
                    iconSource: EIcons.PALETTE
                }
                EIcon {
                    iconSize: 32
                    iconSource: EIcons.PALETTE
                }
                EIcon {
                    iconSize: 48
                    iconSource: EIcons.PALETTE
                }
            }
        }
    }
    ExampleSection {
        componentName: "EText"

        ExampleCase {
            objectName: "showcaseEText0"
            title: ELocale.texts.TruncationAndLineLimits
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EText {
                        truncated: true
                        width: Math.min(480, parent.width)
                        text: ELocale.texts.ALongTextThatExceedsTheContainerWidth
                    }
                    EText {
                        lineClamp: 2
                        wrapMode: Text.WordWrap
                        width: Math.min(480, parent.width)
                        text: ELocale.texts.MultilineTextCanBeLimitedToASet
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EText {
                    truncated: true
                    width: Math.min(480, parent.width)
                    text: ELocale.texts.ALongTextThatExceedsTheContainerWidth
                }
                EText {
                    lineClamp: 2
                    wrapMode: Text.WordWrap
                    width: Math.min(480, parent.width)
                    text: ELocale.texts.MultilineTextCanBeLimitedToASet
                }
            }
        }
    }
    ExampleSection {
        componentName: "EText"

        ExampleCase {
            objectName: "showcaseEText1"
            title: ELocale.texts.TextSizes
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    EText {
                        size: EStyle.Small
                        text: ELocale.texts.QtQuickClearReading
                    }
                    EText {
                        size: EStyle.Medium
                        text: ELocale.texts.QtQuickClearReading
                    }
                    EText {
                        size: EStyle.Large
                        text: ELocale.texts.QtQuickClearReading
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                EText {
                    size: EStyle.Small
                    text: ELocale.texts.QtQuickClearReading
                }
                EText {
                    size: EStyle.Medium
                    text: ELocale.texts.QtQuickClearReading
                }
                EText {
                    size: EStyle.Large
                    text: ELocale.texts.QtQuickClearReading
                }
            }
        }
    }
    ExampleSection {
        componentName: "EText"

        ExampleCase {
            objectName: "showcaseEText2"
            title: ELocale.texts.SemanticText
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    EText {
                        type: "primary"
                        text: ELocale.texts.StatusInformation
                    }
                    EText {
                        type: "success"
                        text: ELocale.texts.StatusInformation
                    }
                    EText {
                        type: "warning"
                        text: ELocale.texts.StatusInformation
                    }
                    EText {
                        type: "danger"
                        text: ELocale.texts.StatusInformation
                    }
                    EText {
                        type: "info"
                        text: ELocale.texts.StatusInformation
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                EText {
                    type: "primary"
                    text: ELocale.texts.StatusInformation
                }
                EText {
                    type: "success"
                    text: ELocale.texts.StatusInformation
                }
                EText {
                    type: "warning"
                    text: ELocale.texts.StatusInformation
                }
                EText {
                    type: "danger"
                    text: ELocale.texts.StatusInformation
                }
                EText {
                    type: "info"
                    text: ELocale.texts.StatusInformation
                }
            }
        }
    }
    ExampleSection {
        componentName: "EText"

        ExampleCase {
            objectName: "showcaseEText3"
            title: ELocale.texts.RichText
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EText {
                    wrapMode: Text.WordWrap
                    textFormat: Text.RichText
                    width: Math.min(480, parent.width)
                    text: ELocale.texts.BTitleBIDescriptionIBrQt
                }
            `)

            EText {
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                width: Math.min(480, parent.width)
                text: ELocale.texts.BTitleBIDescriptionIBrQt
            }
        }
    }
    ExampleSection {
        componentName: "EButton"

        ExampleCase {
            objectName: "showcaseEButton0"
            title: ELocale.texts.SemanticActions
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    EButton {
                        plain: true
                        styleType: EStyle.Primary
                        text: ELocale.texts.Action
                    }
                    EButton {
                        plain: true
                        styleType: EStyle.Success
                        text: ELocale.texts.Action
                    }
                    EButton {
                        plain: true
                        styleType: EStyle.Warning
                        text: ELocale.texts.Action
                    }
                    EButton {
                        plain: true
                        styleType: EStyle.Danger
                        text: ELocale.texts.Action
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                EButton {
                    plain: true
                    styleType: EStyle.Primary
                    text: ELocale.texts.Action
                }
                EButton {
                    plain: true
                    styleType: EStyle.Success
                    text: ELocale.texts.Action
                }
                EButton {
                    plain: true
                    styleType: EStyle.Warning
                    text: ELocale.texts.Action
                }
                EButton {
                    plain: true
                    styleType: EStyle.Danger
                    text: ELocale.texts.Action
                }
            }
        }
    }
    ExampleSection {
        componentName: "EButton"

        ExampleCase {
            objectName: "showcaseEButton1"
            title: ELocale.texts.ActionLimitsAndReset
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EButton {
                        id: sample

                        property int count: 0

                        enabled: count < 3
                        styleType: EStyle.Primary
                        text: ELocale.texts.SubmitCount.arg(count).arg(3)

                        onClicked: ++count
                    }
                    EButton {
                        text: ELocale.texts.Reset

                        onClicked: sample.count = 0
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EButton {
                    id: sample

                    property int count: 0

                    enabled: count < 3
                    styleType: EStyle.Primary
                    text: ELocale.texts.SubmitCount.arg(count).arg(3)

                    onClicked: ++count
                }
                EButton {
                    text: ELocale.texts.Reset

                    onClicked: sample.count = 0
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERectangle"

        ExampleCase {
            objectName: "showcaseERectangle0"
            title: ELocale.texts.CornerShapes
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ERectangle {
                        radius: 0
                        height: 72
                        width: 100
                        color: "#409EFF"
                    }
                    ERectangle {
                        height: 72
                        radius: 12
                        width: 100
                        color: "#409EFF"
                    }
                    ERectangle {
                        height: 72
                        radius: 36
                        width: 100
                        color: "#409EFF"
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ERectangle {
                    radius: 0
                    height: 72
                    width: 100
                    color: "#409EFF"
                }
                ERectangle {
                    height: 72
                    radius: 12
                    width: 100
                    color: "#409EFF"
                }
                ERectangle {
                    height: 72
                    radius: 36
                    width: 100
                    color: "#409EFF"
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERectangle"

        ExampleCase {
            objectName: "showcaseERectangle1"
            title: ELocale.texts.OutlineWeights
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ERectangle {
                        height: 72
                        radius: 12
                        width: 100
                        border.width: 1
                        color: "transparent"
                        border.color: "#67c23a"
                    }
                    ERectangle {
                        height: 72
                        radius: 12
                        width: 100
                        border.width: 2
                        color: "transparent"
                        border.color: "#67c23a"
                    }
                    ERectangle {
                        height: 72
                        radius: 12
                        width: 100
                        border.width: 4
                        color: "transparent"
                        border.color: "#67c23a"
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ERectangle {
                    height: 72
                    radius: 12
                    width: 100
                    border.width: 1
                    color: "transparent"
                    border.color: "#67c23a"
                }
                ERectangle {
                    height: 72
                    radius: 12
                    width: 100
                    border.width: 2
                    color: "transparent"
                    border.color: "#67c23a"
                }
                ERectangle {
                    height: 72
                    radius: 12
                    width: 100
                    border.width: 4
                    color: "transparent"
                    border.color: "#67c23a"
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERectangle"

        ExampleCase {
            objectName: "showcaseERectangle2"
            title: ELocale.texts.GradientSurface
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ERectangle {
                    radius: 16
                    height: 100
                    width: Math.min(420, parent.width)
                    gradient: Gradient {
                        GradientStop {
                            position: 0
                            color: "#409eff"
                        }
                        GradientStop {
                            position: 1
                            color: "#67c23a"
                        }
                    }
                }
            `)

            ERectangle {
                radius: 16
                height: 100
                width: Math.min(420, parent.width)
                gradient: Gradient {
                    GradientStop {
                        position: 0
                        color: "#409eff"
                    }
                    GradientStop {
                        position: 1
                        color: "#67c23a"
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERectangle"

        ExampleCase {
            objectName: "showcaseERectangle3"
            title: ELocale.texts.ContentSurface
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ERectangle {
                    height: 96
                    radius: 16
                    width: 240
                    color: "#173958"

                    EText {
                        color: "#E7F0FF"
                        anchors.centerIn: parent
                        text: ELocale.texts.WorkspaceLabel
                    }
                }
            `)

            ERectangle {
                height: 96
                radius: 16
                width: 240
                color: "#173958"

                EText {
                    color: "#E7F0FF"
                    anchors.centerIn: parent
                    text: ELocale.texts.WorkspaceLabel
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETextArea"

        ExampleCase {
            objectName: "showcaseETextArea0"
            title: ELocale.texts.ThreeSizes2
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ETextArea {
                        rows: 3
                        size: EStyle.Small
                        text: ELocale.texts.TwoLineSample
                        width: Math.min(220, parent.width)
                    }
                    ETextArea {
                        rows: 3
                        size: EStyle.Medium
                        text: ELocale.texts.TwoLineSample
                        width: Math.min(220, parent.width)
                    }
                    ETextArea {
                        rows: 3
                        size: EStyle.Large
                        text: ELocale.texts.TwoLineSample
                        width: Math.min(220, parent.width)
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ETextArea {
                    rows: 3
                    size: EStyle.Small
                    text: ELocale.texts.TwoLineSample
                    width: Math.min(220, parent.width)
                }
                ETextArea {
                    rows: 3
                    size: EStyle.Medium
                    text: ELocale.texts.TwoLineSample
                    width: Math.min(220, parent.width)
                }
                ETextArea {
                    rows: 3
                    size: EStyle.Large
                    text: ELocale.texts.TwoLineSample
                    width: Math.min(220, parent.width)
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETextArea"

        ExampleCase {
            objectName: "showcaseETextArea1"
            title: ELocale.texts.ReadOnlyAndDisabled
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ETextArea {
                        rows: 3
                        readOnly: true
                        enabled: readOnly
                        text: ELocale.texts.TwoLineSample
                        width: Math.min(220, parent.width)
                    }
                    ETextArea {
                        rows: 3
                        readOnly: false
                        enabled: readOnly
                        text: ELocale.texts.TwoLineSample
                        width: Math.min(220, parent.width)
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ETextArea {
                    rows: 3
                    readOnly: true
                    enabled: readOnly
                    text: ELocale.texts.TwoLineSample
                    width: Math.min(220, parent.width)
                }
                ETextArea {
                    rows: 3
                    readOnly: false
                    enabled: readOnly
                    text: ELocale.texts.TwoLineSample
                    width: Math.min(220, parent.width)
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETextArea"

        ExampleCase {
            objectName: "showcaseETextArea2"
            title: ELocale.texts.ValidationStates
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ETextArea {
                        rows: 3
                        text: ELocale.texts.TwoLineSample
                        width: Math.min(220, parent.width)
                        validationState: EValidationState.Success
                        validationMessage: ELocale.texts.ValidationMessage
                    }
                    ETextArea {
                        rows: 3
                        text: ELocale.texts.TwoLineSample
                        width: Math.min(220, parent.width)
                        validationState: EValidationState.Warning
                        validationMessage: ELocale.texts.ValidationMessage
                    }
                    ETextArea {
                        rows: 3
                        text: ELocale.texts.TwoLineSample
                        width: Math.min(220, parent.width)
                        validationState: EValidationState.Error
                        validationMessage: ELocale.texts.ValidationMessage
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ETextArea {
                    rows: 3
                    text: ELocale.texts.TwoLineSample
                    width: Math.min(220, parent.width)
                    validationState: EValidationState.Success
                    validationMessage: ELocale.texts.ValidationMessage
                }
                ETextArea {
                    rows: 3
                    text: ELocale.texts.TwoLineSample
                    width: Math.min(220, parent.width)
                    validationState: EValidationState.Warning
                    validationMessage: ELocale.texts.ValidationMessage
                }
                ETextArea {
                    rows: 3
                    text: ELocale.texts.TwoLineSample
                    width: Math.min(220, parent.width)
                    validationState: EValidationState.Error
                    validationMessage: ELocale.texts.ValidationMessage
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETextArea"

        ExampleCase {
            objectName: "showcaseETextArea3"
            title: ELocale.texts.WordCountAndAutosize
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ETextArea {
                    maximumLength: 80
                    showWordLimit: true
                    width: Math.min(480, parent.width)
                    autosize: ({minRows: 2, maxRows: 5})
                    placeholderText: ELocale.texts.UpTo80Characters
                }
            `)

            ETextArea {
                maximumLength: 80
                showWordLimit: true
                width: Math.min(480, parent.width)
                autosize: ({minRows: 2, maxRows: 5})
                placeholderText: ELocale.texts.UpTo80Characters
            }
        }
    }
    ExampleSection {
        componentName: "ETextButton"

        ExampleCase {
            title: ELocale.texts.Sizes
            objectName: "showcaseETextButton0"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ETextButton {
                        size: EStyle.Small
                        styleType: EStyle.Primary
                        text: ELocale.texts.CoreSampleDetails
                    }
                    ETextButton {
                        size: EStyle.Medium
                        styleType: EStyle.Primary
                        text: ELocale.texts.CoreSampleDetails
                    }
                    ETextButton {
                        size: EStyle.Large
                        styleType: EStyle.Primary
                        text: ELocale.texts.CoreSampleDetails
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ETextButton {
                    size: EStyle.Small
                    styleType: EStyle.Primary
                    text: ELocale.texts.CoreSampleDetails
                }
                ETextButton {
                    size: EStyle.Medium
                    styleType: EStyle.Primary
                    text: ELocale.texts.CoreSampleDetails
                }
                ETextButton {
                    size: EStyle.Large
                    styleType: EStyle.Primary
                    text: ELocale.texts.CoreSampleDetails
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETextButton"

        ExampleCase {
            title: ELocale.texts.IconActions
            objectName: "showcaseETextButton1"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ETextButton {
                        leftIcon: true
                        iconSource: EIcons.PENCIL
                        text: ELocale.texts.Action
                    }
                    ETextButton {
                        leftIcon: true
                        iconSource: EIcons.CHECK
                        text: ELocale.texts.Action
                    }
                    ETextButton {
                        leftIcon: true
                        iconSource: EIcons.DELETE
                        text: ELocale.texts.Action
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ETextButton {
                    leftIcon: true
                    iconSource: EIcons.PENCIL
                    text: ELocale.texts.Action
                }
                ETextButton {
                    leftIcon: true
                    iconSource: EIcons.CHECK
                    text: ELocale.texts.Action
                }
                ETextButton {
                    leftIcon: true
                    iconSource: EIcons.DELETE
                    text: ELocale.texts.Action
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETextButton"

        ExampleCase {
            objectName: "showcaseETextButton2"
            title: ELocale.texts.DisabledAndHighlighted
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ETextButton {
                        enabled: true
                        styleType: EStyle.Primary
                        isOpenBackgroundColor: true
                        text: ELocale.texts.ProjectActions
                    }
                    ETextButton {
                        enabled: false
                        styleType: EStyle.Primary
                        isOpenBackgroundColor: true
                        text: ELocale.texts.ProjectActions
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ETextButton {
                    enabled: true
                    styleType: EStyle.Primary
                    isOpenBackgroundColor: true
                    text: ELocale.texts.ProjectActions
                }
                ETextButton {
                    enabled: false
                    styleType: EStyle.Primary
                    isOpenBackgroundColor: true
                    text: ELocale.texts.ProjectActions
                }
            }
        }
    }
    ExampleSection {
        componentName: "ETextButton"

        ExampleCase {
            objectName: "showcaseETextButton3"
            title: ELocale.texts.RoundedActions
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ETextButton {
                        round: true
                        styleType: EStyle.Success
                        text: ELocale.texts.Status
                        isOpenBackgroundColor: true
                    }
                    ETextButton {
                        round: true
                        styleType: EStyle.Warning
                        text: ELocale.texts.Status
                        isOpenBackgroundColor: true
                    }
                    ETextButton {
                        round: true
                        styleType: EStyle.Danger
                        text: ELocale.texts.Status
                        isOpenBackgroundColor: true
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ETextButton {
                    round: true
                    styleType: EStyle.Success
                    text: ELocale.texts.Status
                    isOpenBackgroundColor: true
                }
                ETextButton {
                    round: true
                    styleType: EStyle.Warning
                    text: ELocale.texts.Status
                    isOpenBackgroundColor: true
                }
                ETextButton {
                    round: true
                    styleType: EStyle.Danger
                    text: ELocale.texts.Status
                    isOpenBackgroundColor: true
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERotatingIcon"

        ExampleCase {
            title: ELocale.texts.RotationSpeeds
            objectName: "showcaseERotatingIcon0"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    ERotatingIcon {
                        iconSize: 28
                        duration: 600
                        running: true
                        iconSource: EIcons.ARROW_ROTATE_RIGHT
                    }
                    ERotatingIcon {
                        iconSize: 28
                        running: true
                        duration: 1400
                        iconSource: EIcons.ARROW_ROTATE_RIGHT
                    }
                    ERotatingIcon {
                        iconSize: 28
                        running: true
                        duration: 2800
                        iconSource: EIcons.ARROW_ROTATE_RIGHT
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                ERotatingIcon {
                    iconSize: 28
                    duration: 600
                    running: true
                    iconSource: EIcons.ARROW_ROTATE_RIGHT
                }
                ERotatingIcon {
                    iconSize: 28
                    running: true
                    duration: 1400
                    iconSource: EIcons.ARROW_ROTATE_RIGHT
                }
                ERotatingIcon {
                    iconSize: 28
                    running: true
                    duration: 2800
                    iconSource: EIcons.ARROW_ROTATE_RIGHT
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERotatingIcon"

        ExampleCase {
            title: ELocale.texts.PauseAndResume
            objectName: "showcaseERotatingIcon1"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    ESwitch {
                        id: active

                        checked: true
                        text: ELocale.texts.RunAnimation
                    }
                    ERotatingIcon {
                        iconSize: 32
                        running: active.checked
                        iconSource: EIcons.ARROW_ROTATE_RIGHT
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                ESwitch {
                    id: active

                    checked: true
                    text: ELocale.texts.RunAnimation
                }
                ERotatingIcon {
                    iconSize: 32
                    running: active.checked
                    iconSource: EIcons.ARROW_ROTATE_RIGHT
                }
            }
        }
    }
    ExampleSection {
        componentName: "ERotatingIcon"

        ExampleCase {
            title: ELocale.texts.RotationOrigin
            objectName: "showcaseERotatingIcon2"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ERotatingIcon {
                    width: 80
                    height: 80
                    originX: 0
                    iconSize: 24
                    originY: height / 2
                    iconSource: EIcons.PALETTE
                }
            `)

            ERotatingIcon {
                width: 80
                height: 80
                originX: 0
                iconSize: 24
                originY: height / 2
                iconSource: EIcons.PALETTE
            }
        }
    }
    ExampleSection {
        componentName: "ERotatingIcon"

        ExampleCase {
            objectName: "showcaseERotatingIcon3"
            title: ELocale.texts.StaticStatusIcon
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ERotatingIcon {
                    iconSize: 36
                    running: false
                    color: "#67c23a"
                    iconSource: EIcons.CHECK
                }
            `)

            ERotatingIcon {
                iconSize: 36
                running: false
                color: "#67c23a"
                iconSource: EIcons.CHECK
            }
        }
    }
    ExampleSection {
        componentName: "ECopyableText"

        ExampleCase {
            objectName: "showcaseECopyableText0"
            title: ELocale.texts.SelectableParagraphs
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ECopyableText {
                    wrapMode: Text.WordWrap
                    width: Math.min(480, parent.width)
                    text: ELocale.texts.SelectableCopyParagraph
                }
            `)

            ECopyableText {
                wrapMode: Text.WordWrap
                width: Math.min(480, parent.width)
                text: ELocale.texts.SelectableCopyParagraph
            }
        }
    }
    ExampleSection {
        componentName: "ECopyableText"

        ExampleCase {
            title: ELocale.texts.CodeSelection
            objectName: "showcaseECopyableText1"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ECopyableText {
                    width: Math.min(480, parent.width)
                    text: "import EUI 1.0\\nEButton { text: \\"Hello\\" }"
                    font.family: Qt.platform.os === "windows" ? "Consolas" : "Menlo"
                }
            `)

            ECopyableText {
                width: Math.min(480, parent.width)
                text: "import EUI 1.0\nEButton { text: \"Hello\" }"
                font.family: Qt.platform.os === "windows" ? "Consolas" : "Menlo"
            }
        }
    }
    ExampleSection {
        componentName: "ECopyableText"

        ExampleCase {
            objectName: "showcaseECopyableText2"
            title: ELocale.texts.CopyableIdentifier
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                ECopyableText {
                    font.pixelSize: 18
                    textColor: "#409EFF"
                    text: "PROJECT-2026-001"
                }
            `)

            ECopyableText {
                font.pixelSize: 18
                textColor: "#409EFF"
                text: "PROJECT-2026-001"
            }
        }
    }
    ExampleSection {
        componentName: "ECopyableText"

        ExampleCase {
            objectName: "showcaseECopyableText3"
            title: ELocale.texts.ContactSelection
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: ELocale.texts.DragToSelectTextAndUseTheStandard
                    }
                    ECopyableText {
                        font.underline: true
                        text: "support@example.com"
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EText {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: ELocale.texts.DragToSelectTextAndUseTheStandard
                }
                ECopyableText {
                    font.underline: true
                    text: "support@example.com"
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAdvancedRectangle"

        ExampleCase {
            title: ELocale.texts.IndependentCorners
            objectName: "showcaseEAdvancedRectangle0"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    EAdvancedRectangle {
                        height: 72
                        width: 100
                        color: "#409EFF"
                        radius: [0, 24, 0, 24]
                    }
                    EAdvancedRectangle {
                        height: 72
                        width: 100
                        color: "#409EFF"
                        radius: [24, 0, 24, 0]
                    }
                    EAdvancedRectangle {
                        height: 72
                        width: 100
                        color: "#409EFF"
                        radius: [24, 24, 4, 4]
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                EAdvancedRectangle {
                    height: 72
                    width: 100
                    color: "#409EFF"
                    radius: [0, 24, 0, 24]
                }
                EAdvancedRectangle {
                    height: 72
                    width: 100
                    color: "#409EFF"
                    radius: [24, 0, 24, 0]
                }
                EAdvancedRectangle {
                    height: 72
                    width: 100
                    color: "#409EFF"
                    radius: [24, 24, 4, 4]
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAdvancedRectangle"

        ExampleCase {
            title: ELocale.texts.BorderPatterns
            objectName: "showcaseEAdvancedRectangle1"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Flow {
                    spacing: 16
                    width: parent.width

                    EAdvancedRectangle {
                        height: 72
                        width: 100
                        borderWidth: 2
                        color: "transparent"
                        borderColor: "#67c23a"
                        radius: [12, 12, 12, 12]
                        borderStyle: Qt.SolidLine
                    }
                    EAdvancedRectangle {
                        height: 72
                        width: 100
                        borderWidth: 2
                        color: "transparent"
                        borderColor: "#67c23a"
                        borderStyle: Qt.DashLine
                        radius: [12, 12, 12, 12]
                    }
                    EAdvancedRectangle {
                        height: 72
                        width: 100
                        borderWidth: 2
                        color: "transparent"
                        borderColor: "#67c23a"
                        borderStyle: Qt.DotLine
                        radius: [12, 12, 12, 12]
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                EAdvancedRectangle {
                    height: 72
                    width: 100
                    borderWidth: 2
                    color: "transparent"
                    borderColor: "#67c23a"
                    radius: [12, 12, 12, 12]
                    borderStyle: Qt.SolidLine
                }
                EAdvancedRectangle {
                    height: 72
                    width: 100
                    borderWidth: 2
                    color: "transparent"
                    borderColor: "#67c23a"
                    borderStyle: Qt.DashLine
                    radius: [12, 12, 12, 12]
                }
                EAdvancedRectangle {
                    height: 72
                    width: 100
                    borderWidth: 2
                    color: "transparent"
                    borderColor: "#67c23a"
                    borderStyle: Qt.DotLine
                    radius: [12, 12, 12, 12]
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAdvancedRectangle"

        ExampleCase {
            title: ELocale.texts.CustomDashPattern
            objectName: "showcaseEAdvancedRectangle2"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EAdvancedRectangle {
                    height: 80
                    width: 280
                    borderWidth: 3
                    color: "transparent"
                    borderColor: "#e6a23c"
                    radius: [16, 16, 16, 16]
                    dashPattern: [6, 2, 1, 2]
                    borderStyle: Qt.CustomDashLine
                }
            `)

            EAdvancedRectangle {
                height: 80
                width: 280
                borderWidth: 3
                color: "transparent"
                borderColor: "#e6a23c"
                radius: [16, 16, 16, 16]
                dashPattern: [6, 2, 1, 2]
                borderStyle: Qt.CustomDashLine
            }
        }
    }
    ExampleSection {
        componentName: "EAdvancedRectangle"

        ExampleCase {
            title: ELocale.texts.AsymmetricSurface
            objectName: "showcaseEAdvancedRectangle3"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EAdvancedRectangle {
                    height: 96
                    width: 240
                    color: "#173958"
                    radius: [28, 6, 28, 6]

                    EText {
                        color: "#E7F0FF"
                        anchors.centerIn: parent
                        text: ELocale.texts.PanelLabel
                    }
                }
            `)

            EAdvancedRectangle {
                height: 96
                width: 240
                color: "#173958"
                radius: [28, 6, 28, 6]

                EText {
                    color: "#E7F0FF"
                    anchors.centerIn: parent
                    text: ELocale.texts.PanelLabel
                }
            }
        }
    }
}

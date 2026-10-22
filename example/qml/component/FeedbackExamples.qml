import EUI 1.0
import QtQuick 2.15

ExamplePage {
    title: ELocale.texts.FeedbackComponents
    description: ELocale.texts.ProgressLoadingMessagesAndTooltipsWithState

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
    ExampleSection {
        componentName: "ECircleProgress"

        ExampleCard {
            title: ELocale.texts.DashboardStatusAndFormattedText
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Row {
                    spacing: 28

                    ECircleProgress {
                        percentage: 75
                        showText: true
                        dashboard: true
                        strokeWidth: 10
                        status: "warning"
                        format: function(value) { return value + ELocale.texts.Points }
                    }
                    ECircleProgress {
                        showText: true
                        percentage: 100
                        status: "success"
                        strokeLinecap: "square"
                    }
                }
`)

            Row {
                spacing: 28

                ECircleProgress {
                    percentage: 75
                    showText: true
                    dashboard: true
                    strokeWidth: 10
                    status: "warning"
                    format: function(value) {
                        return value + ELocale.texts.Points
                    }
                }
                ECircleProgress {
                    showText: true
                    percentage: 100
                    status: "success"
                    strokeLinecap: "square"
                }
            }
        }
    }
    ExampleSection {
        componentName: "EProgress"

        ExampleCard {
            title: ELocale.texts.PercentagesColorThresholdsStripesAndIndeterminateProgress
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 20
                    width: parent.width

                    EProgress {
                        width: Math.min(500, parent.width)
                        height: 20
                        percentage: 68
                        showText: true
                        striped: true
                        stripedFlow: true
                        color: [{ color: "#E6A23C", percentage: 30 }, { color: "#409EFF", percentage: 70 },
                            { color: "#67C23A", percentage: 100 }]
                    }
                    EProgress {
                        width: Math.min(500, parent.width)
                        height: 10
                        indeterminate: true
                        duration: 1800
                    }
                }`)

            Column {
                spacing: 20
                width: parent.width

                EProgress {
                    height: 20
                    striped: true
                    percentage: 68
                    showText: true
                    stripedFlow: true
                    width: Math.min(500, parent.width)
                    color: [{ color: "#E6A23C", percentage: 30 }, { color: "#409EFF", percentage: 70 },
                        { color: "#67C23A", percentage: 100 }]
                }
                EProgress {
                    height: 10
                    duration: 1800
                    indeterminate: true
                    width: Math.min(500, parent.width)
                }
            }
        }
    }
    ExampleSection {
        componentName: "ECircleProgress"

        ExampleCard {
            code: exampleData.samples.FeedbackExamplesSample0
            description: ELocale.texts.ValuesStartingAnglesBordersMetersTextAnd

            Row {
                spacing: 26

                ECircleProgress {
                    width: 92
                    height: 92
                    value: 0.35
                    objectName: "galleryCircleProgress"
                }
                ECircleProgress {
                    width: 92
                    height: 92
                    value: 0.68
                    strokeWidth: 10
                    styleType: EStyle.Warning
                    objectName: "galleryCircleProgress"
                }
                ECircleProgress {
                    width: 110
                    height: 110
                    value: 0.72
                    dashboard: true
                    startAngle: 120
                    strokeWidth: 10
                    clockwise: false
                    showBackground: true
                    styleType: EStyle.Success
                    objectName: "galleryCircleProgress"
                    color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Success)
                }
            }
        }
    }
    ExampleSection {
        componentName: "ELoading"

        ExampleCard {
            code: exampleData.samples.FeedbackExamplesSample1
            description: ELocale.texts.DurationBordersSweepAngleDirectionMaterialMode

            Flow {
                spacing: 28
                width: parent.width
                objectName: "galleryLoadingGrid"

                Column {
                    width: 112
                    spacing: 12
                    objectName: "galleryLoadingCase"

                    Item {
                        height: 64
                        width: parent.width

                        ELoading {
                            width: 46
                            height: 46
                            anchors.centerIn: parent
                        }
                    }
                    EText {
                        font.pixelSize: 13
                        width: parent.width
                        text: ELocale.texts.Default2
                        objectName: "galleryLoadingLabel"
                        horizontalAlignment: Text.AlignHCenter
                        color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                    }
                }
                Column {
                    width: 112
                    spacing: 12
                    objectName: "galleryLoadingCase"

                    Item {
                        height: 64
                        width: parent.width

                        ELoading {
                            width: 52
                            height: 52
                            material: true
                            showBackground: false
                            anchors.centerIn: parent
                            color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Success)
                        }
                    }
                    EText {
                        text: "Material"
                        font.pixelSize: 13
                        width: parent.width
                        objectName: "galleryLoadingLabel"
                        horizontalAlignment: Text.AlignHCenter
                        color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                    }
                }
                Column {
                    width: 112
                    spacing: 12
                    objectName: "galleryLoadingCase"

                    Item {
                        height: 64
                        width: parent.width

                        ELoading {
                            width: 64
                            height: 64
                            duration: 800
                            material: true
                            strokeWidth: 7
                            sweepAngle: 230
                            clockwise: false
                            showBackground: false
                            anchors.centerIn: parent
                            styleType: EStyle.Warning
                            color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Warning)
                        }
                    }
                    EText {
                        font.pixelSize: 13
                        width: parent.width
                        objectName: "galleryLoadingLabel"
                        text: ELocale.texts.Counterclockwise
                        horizontalAlignment: Text.AlignHCenter
                        color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EProgress"

        ExampleCard {
            code: exampleData.samples.FeedbackExamplesSample2
            description: ELocale.texts.LinearProgressValuesDirectionAndCustomColors

            Column {
                spacing: 14
                width: parent.width

                EProgress {
                    value: 0.25
                    width: Math.min(parent.width, 560)
                    objectName: "galleryLinearProgress"
                }
                EProgress {
                    value: 0.5
                    styleType: EStyle.Warning
                    width: Math.min(parent.width, 560)
                    objectName: "galleryLinearProgress"
                }
                EProgress {
                    value: 0.76
                    styleType: EStyle.Success
                    width: Math.min(parent.width, 560)
                    objectName: "galleryLinearProgress"
                    color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Success)
                }
            }
        }
    }
    ExampleSection {
        componentName: "EMessage"

        ExampleCard {
            code: exampleData.samples.FeedbackExamplesSample3
            description: ELocale.texts.PlacementDurationGroupingCloseBehaviorSemanticStyles

            EMessage {
                id: messageCenter

                plain: false
                center: false
                duration: 2600
                clearing: false
                grouping: false
                showClose: true
                closeOnClick: false
                type: EStyle.Default
                placement: EPlacement.Top
                styleType: EStyle.Primary
                textColor: EPaletteManager.BasePalette.transparent
                backgroundColor: EPaletteManager.BasePalette.transparent
            }
            Flow {
                spacing: 10
                width: parent.width

                EButton {
                    text: ELocale.texts.DefaultMessage

                    onClicked: messageCenter.openELocale.texts.ThisIsADefaultMessage
                }
                EButton {
                    styleType: EStyle.Success
                    text: ELocale.texts.SuccessMessage

                    onClicked: messageCenter.open({
                        "message": ELocale.texts.SavedSuccessfully,
                        "key": ELocale.texts.SaveSuccess,
                        "duration": 3200,
                        "showClose": true,
                        "closeOnClick": true,
                        "center": true,
                        "plain": true,
                        "type": EStyle.Success,
                        "styleType": EStyle.Success,
                        "textColor": EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Success),
                        "backgroundColor": EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
                    })
                }
                EButton {
                    styleType: EStyle.Warning
                    text: ELocale.texts.GroupAtBottomRight

                    onClicked: {
                        messageCenter.placement = EPlacement.BottomRight
                        messageCenter.grouping = true
                        messageCenter.openELocale.texts.RepeatedMessagesAreGrouped
                    }
                }
                EButton {
                    text: ELocale.texts.CloseSelectedMessage

                    onClicked: messageCenter.closeELocale.texts.SaveSuccess
                }
                EButton {
                    styleType: EStyle.Danger
                    text: ELocale.texts.ClearMessages

                    onClicked: messageCenter.clear()
                }
            }
        }
    }
    ExampleSection {
        componentName: "EToolTip"

        ExampleCard {
            code: exampleData.samples.FeedbackExamplesSample4
            description: ELocale.texts.PlacementDelayTimeoutSemanticStylesAndCustom

            Flow {
                spacing: 16
                width: parent.width

                EButton {
                    text: ELocale.texts.TopTooltip

                    EToolTip {
                        text: ELocale.texts.Top
                        visible: parent.hovered
                        placement: EPlacement.Top
                    }
                }
                EButton {
                    text: ELocale.texts.LeftTooltip

                    EToolTip {
                        visible: parent.hovered
                        text: ELocale.texts.Left
                        placement: EPlacement.Left
                    }
                }
            }
        }
    }
    FeedbackShowcase { }
}

import EUI 1.0
import QtQuick 2.15

ExamplePage {
    title: ELocale.texts.AnimationEffects

    ExampleSection {
        componentName: "EAnimation"

        ExampleCase {
            id: playground

            readonly property var filteredEffects: EAnimation.effects.filter(function(effect) {
                return new RegExp(categories[Math.max(0, categorySelector.currentIndex)].pattern).test(effect)
            })
            readonly property string invocation: 'EAnimation.play(animationCard, "' + effectSelector.currentText
                + '", { duration: ' + durationInput.value + ', distance: ' + distanceInput.value + ' })'
            readonly property var categories: [
                {label: ELocale.texts.AnimationAll, pattern: ""},
                {label: ELocale.texts.AnimationFade, pattern: "^fade"},
                {label: ELocale.texts.AnimationSlide, pattern: "^slide"},
                {label: ELocale.texts.AnimationScaleZoom, pattern: "^(scale|zoom)"},
                {label: ELocale.texts.AnimationRotateRoll, pattern: "^(rotate|roll|spin)"},
                {label: ELocale.texts.AnimationBounce, pattern: "^bounce"},
                {label: ELocale.texts.AnimationFlip, pattern: "^flip"},
                {label: ELocale.texts.AnimationAttention,
                    pattern: "^(shake|pulse|swing|tada|wobble|jello|rubberBand|flash|heartBeat|headShake)"},
                {label: ELocale.texts.AnimationLightSpeed, pattern: "^lightSpeed"}
            ]

            objectName: "showcaseEAnimation0"
            title: ELocale.texts.AnimationPlayground
            description: ELocale.texts.AnimationPlaygroundNote
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 320
                    spacing: 16

                    Rectangle {
                        id: animationCard

                        radius: 12
                        width: 220
                        height: 100
                        color: "#409eff"
                    }
                    EButton {
                        text: "${ELocale.texts.AnimationPlay}"

                        onClicked: ${playground.invocation}
                    }
                }
            `)

            Flow {
                spacing: 16
                width: parent.width

                Column {
                    spacing: 8

                    EText { text: ELocale.texts.AnimationCategory }
                    ESelect {
                        id: categorySelector

                        width: 200
                        currentIndex: 0
                        objectName: "animationCategorySelector"
                        model: playground.categories.map(function(category) { return category.label })
                    }
                }
                Column {
                    spacing: 8

                    EText { text: ELocale.texts.AnimationEffect }
                    ESelect {
                        id: effectSelector

                        width: 200
                        currentIndex: 0
                        model: playground.filteredEffects
                        objectName: "animationEffectSelector"

                        onModelChanged: currentIndex = 0
                    }
                }
                Column {
                    spacing: 8

                    EText { text: ELocale.texts.AnimationDuration }
                    ESpinBox {
                        id: durationInput

                        from: 0
                        to: 2000
                        value: 300
                        stepSize: 50
                        editable: true
                        objectName: "animationDurationInput"
                    }
                }
                Column {
                    spacing: 8
                    width: 180

                    EText { text: ELocale.texts.AnimationDistance.arg(distanceInput.value) }
                    ESlider {
                        id: distanceInput

                        to: 80
                        from: 0
                        value: 24
                        stepSize: 1
                        width: parent.width
                        objectName: "animationDistanceInput"
                    }
                }
            }
            EText {
                width: parent.width
                wrapMode: Text.WordWrap
                objectName: "animationEffectCount"
                text: ELocale.texts.AnimationCount.arg(effectSelector.count).arg(EAnimation.effects.length)
            }
            Item {
                height: 180
                width: parent.width

                ERectangle {
                    id: animationCard

                    radius: 12
                    width: 220
                    height: 100
                    anchors.centerIn: parent
                    color: GalleryStyle.accent
                    objectName: "animationPreviewCard"

                    EText {
                        text: "EUI"
                        color: "white"
                        font.pixelSize: 28
                        anchors.centerIn: parent
                        font.weight: Font.DemiBold
                    }
                }
            }
            Flow {
                spacing: 12
                width: parent.width

                EButton {
                    styleType: EStyle.Primary
                    objectName: "animationPlayButton"
                    text: ELocale.texts.AnimationPlay

                    onClicked: EAnimation.play(animationCard, effectSelector.currentText,
                        {duration: durationInput.value, distance: distanceInput.value})
                }
                EButton {
                    objectName: "animationResetButton"
                    text: ELocale.texts.AnimationReset

                    onClicked: EAnimation.stop(animationCard)
                }
                EButton {
                    objectName: "animationCopyButton"
                    text: ELocale.texts.AnimationCopyCall

                    onClicked: exampleClipboard.setText(playground.invocation)
                }
            }
            ECopyableText {
                width: parent.width
                color: GalleryStyle.accent
                text: playground.invocation
                objectName: "animationInvocation"
                font.family: GalleryStyle.codeFamily

                MouseArea {
                    hoverEnabled: true
                    anchors.fill: parent
                    cursorShape: Qt.ArrowCursor
                    acceptedButtons: Qt.NoButton
                    objectName: "animationSourcePointer"
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAnimation"

        ExampleCase {
            objectName: "showcaseEAnimation1"
            title: ELocale.texts.AnimationShake
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 320
                    spacing: 16

                    EInput {
                        id: input

                        width: parent.width
                        placeholderText: "${ELocale.texts.AnimationInputHint}"
                    }
                    EButton {
                        text: "${ELocale.texts.AnimationShake}"

                        onClicked: EAnimation.play(input, "shake")
                    }
                }
            `)

            EInput {
                id: input

                width: Math.min(320, parent.width)
                placeholderText: ELocale.texts.AnimationInputHint
            }
            EButton {
                text: ELocale.texts.AnimationShake

                onClicked: EAnimation.play(input, "shake")
            }
        }
    }
    ExampleSection {
        componentName: "EAnimation"

        ExampleCase {
            objectName: "showcaseEAnimation2"
            title: ELocale.texts.AnimationPulse
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EButton {
                    id: button

                    styleType: EStyle.Primary
                    text: "${ELocale.texts.AnimationPulse}"

                    onClicked: EAnimation.play(button, "pulse")
                }
            `)

            EButton {
                id: pulseButton

                styleType: EStyle.Primary
                text: ELocale.texts.AnimationPulse

                onClicked: EAnimation.play(pulseButton, "pulse")
            }
        }
    }
    ExampleSection {
        componentName: "EAnimation"

        ExampleCase {
            objectName: "showcaseEAnimation3"
            title: ELocale.texts.AnimationFade
            description: ELocale.texts.AnimationVisibilityNote
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    width: 320
                    spacing: 16

                    EText {
                        id: label

                        text: "EUI Animation"
                    }
                    Row {
                        spacing: 12

                        EButton {
                            text: "fadeOut"

                            onClicked: EAnimation.play(label, "fadeOut")
                        }
                        EButton {
                            text: "fadeIn"

                            onClicked: EAnimation.play(label, "fadeIn")
                        }
                    }
                }
            `)

            EText {
                id: fadeLabel

                font.pixelSize: 24
                text: "EUI Animation"
            }
            Flow {
                spacing: 12
                width: parent.width

                EButton {
                    text: "fadeOut"

                    onClicked: EAnimation.play(fadeLabel, "fadeOut")
                }
                EButton {
                    text: "fadeIn"

                    onClicked: EAnimation.play(fadeLabel, "fadeIn")
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAnimation"

        ExampleCase {
            objectName: "showcaseEAnimation4"
            title: ELocale.texts.AnimationLayout
            description: ELocale.texts.AnimationLayoutNote
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Item {
                    width: 320
                    height: 140

                    EButton {
                        id: button

                        anchors.centerIn: parent
                        text: "${ELocale.texts.AnimationLayout}"

                        onClicked: EAnimation.play(button, "slideInUp", { duration: 500, distance: 32 })
                    }
                }
            `)

            Item {
                height: 140
                width: parent.width

                EButton {
                    id: anchoredButton

                    anchors.centerIn: parent
                    text: ELocale.texts.AnimationLayout

                    onClicked: EAnimation.play(anchoredButton, "slideInUp", {duration: 500, distance: 32})
                }
            }
        }
    }
}

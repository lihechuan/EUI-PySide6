import EUI 1.0
import QtQuick 2.15

ExamplePage {
    title: exampleData.ui.VisualEffects

    ExampleSection {
        componentName: "EClip"

        ExampleCard {
            code: exampleData.samples.RoundedClip
            introduction: exampleData.ui.ClipIntroduction

            EClip {
                id: roundedClip

                height: 180
                radius: clipRadius.value
                width: Math.min(440, parent.width)

                ERectangle {
                    anchors.fill: parent
                    color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)

                    ERectangle {
                        rotation: -20
                        width: parent.width
                        height: parent.height / 2
                        anchors.right: parent.right
                        color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Success)
                    }
                    EButton {
                        property int clickCount: 0

                        anchors.centerIn: parent
                        text: exampleData.ui.ClipClicks.arg(clickCount)

                        onClicked: ++clickCount
                    }
                }
            }
            EText {
                font.pixelSize: 14
                text: exampleData.ui.ClipRadius
                color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
            }
            ESlider {
                id: clipRadius

                to: 80
                from: 0
                value: 32
                width: 280
                stepSize: 1
            }
        }
    }
    ExampleSection {
        componentName: "EAcrylic"

        ExampleCard {
            introduction: exampleData.ui.AcrylicIntroduction

            ExampleCase {
                title: exampleData.ui.AcrylicTitle
                code: exampleData.samples.AcrylicEffect

                Item {
                    height: 240
                    width: parent.width

                    Image {
                        id: backdrop

                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                        source: "qrc:/example/images/gallery/lake.jpg"
                    }
                    EAcrylic {
                        id: acrylic

                        radius: 8
                        height: 170
                        sourceItem: backdrop
                        anchors.centerIn: parent
                        blurRadius: blurSlider.value
                        tintOpacity: tintSlider.value
                        width: Math.min(320, parent.width - 48)

                        EText {
                            font.bold: true
                            font.pixelSize: 20
                            anchors.centerIn: parent
                            text: exampleData.ui.AcrylicTitle
                            color: EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
                        }
                    }
                }
                Flow {
                    spacing: 20
                    width: parent.width

                    Column {
                        spacing: 8

                        EText {
                            font.pixelSize: 14
                            text: exampleData.ui.BlurRadius
                            color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                        }
                        ESlider {
                            id: blurSlider

                            to: 64
                            from: 0
                            value: 24
                            width: 200
                            stepSize: 1
                        }
                    }
                    Column {
                        spacing: 8

                        EText {
                            font.pixelSize: 14
                            text: exampleData.ui.TintOpacity
                            color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                        }
                        ESlider {
                            id: tintSlider

                            to: 1
                            from: 0
                            width: 200
                            value: 0.65
                            stepSize: 0.05
                        }
                    }
                    EButton {
                        text: exampleData.ui.Refresh

                        onClicked: acrylic.refresh()
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EShadow"

        ExampleCard {
            introduction: exampleData.ui.ShadowIntroduction

            ExampleCase {
                title: exampleData.ui.ShadowTitle
                code: exampleData.samples.ShadowEffect

                Item {
                    height: 170
                    width: parent.width

                    ERectangle {
                        radius: 8
                        width: 220
                        height: 100
                        anchors.centerIn: parent
                        color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
                        border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)

                        EShadow {
                            z: -1
                            anchors.fill: parent
                            radius: parent.radius
                            elevation: elevationSlider.value
                        }
                        EText {
                            font.pixelSize: 18
                            anchors.centerIn: parent
                            text: exampleData.ui.ShadowTitle
                            color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                        }
                    }
                }
                EText {
                    font.pixelSize: 14
                    text: exampleData.ui.ShadowElevation
                    color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
                }
                ESlider {
                    id: elevationSlider

                    to: 32
                    from: 0
                    value: 8
                    width: 280
                    stepSize: 1
                }
            }
        }
    }
    ExampleSection {
        componentName: "EParallaxView"

        ExampleCard {
            code: exampleData.samples.ParallaxEffect
            introduction: exampleData.ui.ParallaxIntroduction

            EParallaxView {
                height: 280
                spacing: 24
                width: parent.width
                backgroundComponent: Component {
                    Image {
                        source: "qrc:/example/images/gallery/tree.jpg"
                        fillMode: Image.PreserveAspectCrop

                        ERectangle {
                            color: "#66000000"
                            anchors.fill: parent
                        }
                    }
                }

                Repeater {
                    model: 10

                    EText {
                        height: 48
                        font.pixelSize: 14
                        text: ELocale.texts.ScrollableContent + (index + 1)
                        color: "white"
                    }
                }
            }
        }
    }
    VisualEffectsShowcase { }
}

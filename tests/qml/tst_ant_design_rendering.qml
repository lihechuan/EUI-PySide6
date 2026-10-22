import EUI 1.0
import QtQuick 2.15
import QtTest 1.2
import QtQuick.Window 2.15

TestCase {
    id: testCase

    function cleanup() {
        ETheme.setDark(false)
    }

    function test_rendering_data() {
        return [{
            "tag": "light-wide",
            "dark": false,
            "narrow": false
        }, {
            "tag": "dark-wide",
            "dark": true,
            "narrow": false
        }, {
            "tag": "light-narrow",
            "dark": false,
            "narrow": true
        }, {
            "tag": "dark-narrow",
            "dark": true,
            "narrow": true
        }]
    }

    function test_rendering(data) {
        ETheme.setDark(data.dark)
        const scene = createTemporaryObject(sceneComponent, testCase, {
            "width": data.narrow ? 360 : 720
        })
        verify(scene !== null)
        verify(waitForItemPolished(scene))
        const canvas = findChild(scene, "borderBeamCanvas")
        tryCompare(canvas, "available", true)
        canvas.phase = 0.25
        canvas.requestPaint()
        scene.Window.window.update()
        verify(waitForRendering(scene))
        const image = grabImage(scene)
        verify(image.width > 0)
        const background = scene.color
        let accented = 0
        for (let x = 20; x < image.width - 20; ++x) {
            if (Math.abs(image.red(x, 22) - Math.round(background.r * 255)) > 20)
                ++accented

        }
        verify(accented > 10, "The beam must visibly render on the border")
        const grid = findChild(scene, "previewList")
        compare(grid.columns, data.narrow ? 1 : 2)
    }

    width: 760
    height: 500
    visible: true
    when: windowShown
    name: "AntDesignRendering"

    Component {
        id: sceneComponent

        ERectangle {
            width: 720
            height: 440
            color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)

            EBorderBeam {
                x: 20
                y: 20
                size: 180
                radius: 12
                height: 100
                lineWidth: 4
                running: false
                width: parent.width - 40

                EText {
                    anchors.centerIn: parent
                    text: ELocale.texts.CoreSampleAlpha
                }
            }
            EList {
                x: 20
                y: 144
                height: 260
                bordered: true
                width: parent.width - 40
                objectName: "previewList"
                grid: ({
                    "xs": 1,
                    "sm": 2,
                    "gutter": 12
                })
                items: [{
                    "title": ELocale.texts.CoreSampleAlpha,
                    "description": ELocale.texts.CoreSampleDescription
                }, {
                    "title": ELocale.texts.CoreSampleBeta,
                    "description": ELocale.texts.CoreSampleDescription
                }]
            }
            EFloatButtonGroup {
                open: true
                trigger: "click"
                placement: "left"
                x: parent.width - width - 28
                y: parent.height - height - 28

                EFloatButton {
                    badge: 8
                    iconSource: EIcons.BELL
                }
                EFloatButton {
                    iconSource: EIcons.CHECK
                }
            }
        }
    }
}

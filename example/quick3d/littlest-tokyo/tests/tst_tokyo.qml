import ".." as Demo
import QtQuick
import QtTest

Item {
    height: 800
    width: 1100

    Demo.TokyoScene {
        id: scene

        anchors.fill: parent
    }
    TestCase {
        id: tests

        function test_windowControls() {
            const frame = createTemporaryObject(windowComponent, null)
            verify(frame !== null)
            verify(waitForRendering(frame.contentItem, 10000))
            const viewport = findChild(frame, "tokyoScene")
            const pause = findChild(frame, "playPauseButton")
            verify(viewport.playing)
            mouseClick(pause)
            compare(viewport.playing, false)
            mouseClick(findChild(frame, "restartButton"))
            compare(viewport.elapsed, 0)
            mouseClick(pause)
            compare(viewport.playing, true)
            const speed = findChild(frame, "speedSelector")
            speed.currentIndex = 2
            speed.activated(2)
            compare(viewport.playbackRate, 2)
            speed.currentIndex = 1
            speed.activated(1)
            tryVerify(function() { return viewport.fps > 0 }, 10000)
            waitForRendering(frame.contentItem)
            const output = Qt.resolvedUrl("../../../../build/littlest-tokyo/window.png")
                .toString().replace(/^file:\/\//, "").replace(/^\/([A-Za-z]:)/, "$1")
            grabImage(frame.contentItem).save(output)
            frame.width = 640
            frame.height = 520
            waitForRendering(frame.contentItem)
            verify(viewport.width > 0)
            verify(viewport.height > 0)
            verify(speed.mapToItem(frame.contentItem, speed.width, 0).x < frame.width)
        }

        function test_sceneAndInteraction() {
            verify(waitForRendering(scene, 10000))
            tryVerify(function() { return scene.fps > 0 }, 15000)
            compare(scene.duration, 10)
            const model = findChild(scene, "tokyoModel")
            const blade = findChild(scene, "Plane104")
            verify(model !== null)
            verify(blade !== null)
            const rotation = blade.rotation.toString()
            wait(350)
            verify(blade.rotation.toString() !== rotation, "Imported keyframes must animate the actual model")

            scene.playing = false
            wait(100)
            const paused = scene.elapsed
            const pausedRotation = blade.rotation.toString()
            wait(200)
            compare(scene.elapsed, paused)
            compare(blade.rotation.toString(), pausedRotation)
            scene.restart()
            wait(100)
            compare(scene.elapsed, 0)

            scene.playbackRate = 2
            scene.playing = true
            wait(350)
            verify(scene.elapsed > 0.4, "Playback rate must immediately affect the imported timeline")
            scene.playing = false
            scene.playbackRate = 1
            model.timeline.currentFrame = 9900
            scene.playing = true
            wait(250)
            scene.playing = false
            verify(scene.elapsed < 1, "The ten-second animation must loop back to its start")
            scene.restart()

            const camera = findChild(scene, "sceneCamera")
            const rig = findChild(scene, "cameraRig")
            const controller = findChild(scene, "orbitController")
            const initialAngle = rig.eulerRotation.y
            mousePress(controller, 450, 350, Qt.LeftButton)
            mouseMove(controller, 500, 365)
            wait(100)
            mouseMove(controller, 550, 385)
            wait(100)
            mouseRelease(controller, 550, 385, Qt.LeftButton)
            wait(100)
            verify(Math.abs(rig.eulerRotation.y - initialAngle) > 1)
            const distance = camera.z
            mouseWheel(controller, 500, 350, 0, 120)
            wait(100)
            verify(camera.z < distance)
            scene.resetView()
            compare(camera.z, 950)
            compare(rig.eulerRotation, Qt.vector3d(-12, 32, 0))

            waitForRendering(scene)
            const image = grabImage(scene)
            verify(image.width > 0)
            verify(image.height > 0)
            let colored = 0
            for (let y = 120; y < image.height - 120; y += 20) {
                for (let x = 120; x < image.width - 120; x += 20) {
                    if (Math.abs(image.red(x, y) - 231) > 20
                            || Math.abs(image.green(x, y) - 229) > 20
                            || Math.abs(image.blue(x, y) - 226) > 20)
                        colored++
                }
            }
            verify(colored > 100, "The rendered scene must contain the textured model")
            const output = Qt.resolvedUrl("../../../../build/littlest-tokyo/preview.png")
                .toString().replace(/^file:\/\//, "").replace(/^\/([A-Za-z]:)/, "$1")
            image.save(output)
            scene.playing = true
        }

        when: windowShown
        name: "LittlestTokyo3D"
    }
    Component {
        id: windowComponent

        Demo.Main {}
    }
}

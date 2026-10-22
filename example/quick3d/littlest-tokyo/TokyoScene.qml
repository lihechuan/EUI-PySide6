import "assets"
import QtQuick
import QtQuick3D
import QtQuick3D.Helpers

Item {
    id: root

    property bool playing: true
    property real playbackRate: 1
    property color backgroundColor: "#e7e5e2"

    readonly property real fps: view.renderStats.fps
    readonly property real duration: tokyo.timeline.endFrame / 1000
    readonly property real elapsed: tokyo.timeline.currentFrame / 1000

    function restart() {
        tokyo.timeline.currentFrame = 0
    }

    function resetView() {
        cameraRig.eulerRotation = Qt.vector3d(-12, 32, 0)
        sceneCamera.z = 950
    }

    View3D {
        id: view

        camera: sceneCamera
        anchors.fill: parent
        environment: SceneEnvironment {
            probeExposure: 1
            clearColor: root.backgroundColor
            backgroundMode: SceneEnvironment.Color
            antialiasingMode: SceneEnvironment.MSAA
            antialiasingQuality: SceneEnvironment.High
            lightProbe: Texture { source: "assets/maps/studio.hdr" }
        }

        Node {
            id: cameraRig

            objectName: "cameraRig"
            position: Qt.vector3d(0, 50, 0)
            eulerRotation: Qt.vector3d(-12, 32, 0)

            PerspectiveCamera {
                id: sceneCamera

                z: 950
                clipNear: 1
                clipFar: 10000
                fieldOfView: 40
                objectName: "sceneCamera"
            }
        }
        DirectionalLight {
            brightness: 0.5
            eulerRotation: Qt.vector3d(-35, -30, 0)
        }
        LittlestTokyo {
            id: tokyo

            objectName: "tokyoModel"
            position: Qt.vector3d(100, 100, 0)
        }
    }
    OrbitCameraController {
        origin: cameraRig
        panEnabled: false
        camera: sceneCamera
        anchors.fill: parent
        objectName: "orbitController"
    }
    FrameAnimation {
        running: root.playing

        onTriggered: tokyo.timeline.currentFrame = (tokyo.timeline.currentFrame
            + frameTime * 1000 * root.playbackRate) % tokyo.timeline.endFrame
    }
}

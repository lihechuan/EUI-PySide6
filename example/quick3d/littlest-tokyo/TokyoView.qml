import EUI 1.0
import QtQuick

Item {
    id: root

    property bool active: true
    property string language: "zh"

    readonly property real fps: scene.fps
    readonly property bool chinese: language === "zh"

    TokyoScene {
        id: scene

        anchors.fill: parent
        anchors.topMargin: 76
        objectName: "tokyoScene"
        playing: root.active && playback.playing
        anchors.bottomMargin: controlPanel.height + 56
        backgroundColor: ETheme.dark ? "#1e2026" : "#e7e5e2"
    }
    Column {
        spacing: 6
        anchors.topMargin: 24
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        EText {
            font.pixelSize: 22
            font.letterSpacing: 4
            text: "LITTLEST TOKYO"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        EText {
            font.pixelSize: 13
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.chinese ? "Qt Quick 3D · 关键帧动画" : "Qt Quick 3D · Keyframe animation"
        }
    }
    ERectangle {
        id: controlPanel

        radius: 12
        anchors.bottomMargin: 40
        anchors.bottom: parent.bottom
        height: controls.implicitHeight + 24
        width: Math.min(parent.width - 32, 740)
        color: ETheme.dark ? "#292c34" : "#ffffff"
        anchors.horizontalCenter: parent.horizontalCenter

        Flow {
            id: controls

            spacing: 12
            anchors.centerIn: parent
            width: parent.width - 24

            EButton {
                id: playback

                property bool playing: true

                objectName: "playPauseButton"
                text: playing ? root.chinese ? "暂停" : "Pause" : root.chinese ? "播放" : "Play"

                onClicked: playing = !playing
            }
            EButton {
                objectName: "restartButton"
                text: root.chinese ? "重新播放" : "Restart"

                onClicked: scene.restart()
            }
            EButton {
                objectName: "resetViewButton"
                text: root.chinese ? "重置视角" : "Reset view"

                onClicked: scene.resetView()
            }
            ESelect {
                width: 86
                currentIndex: 1
                model: ["0.5×", "1×", "2×"]
                objectName: "speedSelector"

                onActivated: scene.playbackRate = [0.5, 1, 2][currentIndex]
            }
            EText {
                height: playback.height
                verticalAlignment: Text.AlignVCenter
                text: scene.elapsed.toFixed(1) + " / " + scene.duration.toFixed(1) + " s"
            }
            EText {
                height: playback.height
                text: Math.round(scene.fps) + " FPS"
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
    EText {
        font.pixelSize: 12
        wrapMode: Text.WordWrap
        anchors.bottomMargin: 14
        width: parent.width - 24
        anchors.bottom: parent.bottom
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        text: root.chinese ? "拖拽旋转 · 滚轮缩放  |  模型：Glen Fox · CC BY 4.0"
            : "Drag to orbit · Scroll to zoom  |  Model: Glen Fox · CC BY 4.0"
    }
}

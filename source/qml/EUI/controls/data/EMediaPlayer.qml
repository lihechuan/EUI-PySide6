import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtMultimedia
import QtQuick.Controls

Control {
    id: control

    property alias muted: audioOutput.muted
    property bool controlsVisible: true
    property alias source: player.source
    property alias volume: audioOutput.volume
    property bool autoPlay: false

    readonly property int duration: player.duration
    readonly property int position: player.position
    readonly property string errorString: player.errorString
    readonly property int playbackState: player.playbackState

    signal failed(string message)

    function play() {
        player.play()
    }

    function stop() {
        player.stop()
    }

    function pause() {
        player.pause()
    }

    function seek(position) {
        player.position = position
    }

    implicitWidth: 480
    implicitHeight: 300
    contentItem: VideoOutput {
        id: videoOutput
    }
    background: ERectangle {
        color: EPaletteManager.BasePalette.black
    }

    MediaPlayer {
        id: player

        audioOutput: AudioOutput {
            id: audioOutput
        }
        videoOutput: videoOutput

        onErrorOccurred: control.failed(errorString)
        onSourceChanged: if (control.autoPlay) play()
    }
    ERectangle {
        height: 48
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        visible: control.controlsVisible
        color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)

        Row {
            spacing: 12
            anchors.margins: 8
            anchors.fill: parent

            ETextButton {
                text: ""
                iconSource: control.playbackState === MediaPlayer.PlayingState ? EIcons.PAUSE : EIcons.PLAY
                accessibleName: control.playbackState === MediaPlayer.PlayingState
                    ? EControlConfig.textFor(control, "Pause", ELocale.texts)
                    : EControlConfig.textFor(control, "Play", ELocale.texts)

                onClicked: {
                    if (control.playbackState === MediaPlayer.PlayingState)
                        player.pause()
                    else
                        player.play()
                }
            }
            ESlider {
                from: 0
                stepSize: 1000
                to: player.duration
                value: player.position
                enabled: player.seekable
                width: Math.max(0, parent.width - 168)
                anchors.verticalCenter: parent.verticalCenter

                onMoved: player.position = value
            }
            ETextButton {
                text: ""
                iconSource: audioOutput.muted ? EIcons.VOLUME_XMARK : EIcons.VOLUME_FILL
                accessibleName: EControlConfig.textFor(control, "Mute", ELocale.texts)

                onClicked: audioOutput.muted = !audioOutput.muted
            }
            ESlider {
                to: 1
                from: 0
                width: 64
                value: audioOutput.volume
                anchors.verticalCenter: parent.verticalCenter

                onMoved: audioOutput.volume = value
            }
        }
    }
}

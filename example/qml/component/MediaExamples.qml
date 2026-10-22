import EUI 1.0
import QtQuick 2.15

ExamplePage {
    title: exampleData.ui.MediaTitle

    ExampleSection {
        componentName: "EMediaPlayer"

        ExampleCard {
            code: exampleData.samples.MediaPlayer
            description: exampleData.ui.MediaIntroduction

            EInput {
                id: mediaSource

                width: parent.width
                placeholderText: exampleData.ui.MediaSourcePlaceholder
            }
            EMediaPlayer {
                id: player

                height: 260
                width: parent.width
                source: mediaSource.text
            }
            Flow {
                spacing: 12
                width: parent.width

                EButton {
                    text: exampleData.ui.PlayPause
                    enabled: mediaSource.text.length > 0

                    onClicked: player.playbackState === 1 ? player.pause() : player.play()
                }
                EButton {
                    text: exampleData.ui.Stop

                    onClicked: player.stop()
                }
                ESwitch {
                    text: exampleData.ui.Muted

                    onCheckedChanged: player.muted = checked
                }
            }
            ESlider {
                to: player.duration
                value: player.position
                enabled: player.duration > 0
                width: Math.min(480, parent.width)

                onMoved: player.seek(value)
            }
            EText {
                font.pixelSize: 14
                width: parent.width
                wrapMode: Text.WordWrap
                text: player.errorString
                color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Danger)
            }
        }
    }
    MediaShowcase { }
}

import EUI 1.0
import QtQuick 2.15

Column {
    spacing: 24
    width: parent.width

    ExampleSection {
        componentName: "EMediaPlayer"

        ExampleCase {
            objectName: "showcaseEMediaPlayer0"
            title: ELocale.texts.PlaybackControls
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EInput {
                        id: source

                        width: Math.min(480, parent.width)
                        placeholderText: ELocale.texts.EnterALocalFilePathOrMediaURL
                    }
                    EMediaPlayer {
                        id: player

                        height: 220
                        autoPlay: false
                        source: source.text
                        width: Math.min(640, parent.width)
                    }
                    Flow {
                        spacing: 16
                        width: parent.width

                        EButton {
                            text: ELocale.texts.Play
                            enabled: source.text.length > 0

                            onClicked: player.play()
                        }
                        EButton {
                            text: ELocale.texts.Pause

                            onClicked: player.pause()
                        }
                        EButton {
                            text: ELocale.texts.Stop

                            onClicked: player.stop()
                        }
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EInput {
                    id: source

                    width: Math.min(480, parent.width)
                    placeholderText: ELocale.texts.EnterALocalFilePathOrMediaURL
                }
                EMediaPlayer {
                    id: player

                    height: 220
                    autoPlay: false
                    source: source.text
                    width: Math.min(640, parent.width)
                }
                Flow {
                    spacing: 16
                    width: parent.width

                    EButton {
                        text: ELocale.texts.Play
                        enabled: source.text.length > 0

                        onClicked: player.play()
                    }
                    EButton {
                        text: ELocale.texts.Pause

                        onClicked: player.pause()
                    }
                    EButton {
                        text: ELocale.texts.Stop

                        onClicked: player.stop()
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EMediaPlayer"

        ExampleCase {
            title: ELocale.texts.VolumeAndMute
            objectName: "showcaseEMediaPlayer1"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EInput {
                        id: source

                        width: Math.min(480, parent.width)
                        placeholderText: ELocale.texts.EnterALocalFilePathOrMediaURL
                    }
                    EMediaPlayer {
                        id: player

                        height: 220
                        autoPlay: false
                        source: source.text
                        width: Math.min(640, parent.width)
                    }
                    Column {
                        spacing: 16
                        width: parent.width

                        ESlider {
                            to: 1
                            from: 0
                            value: 0.5
                            stepSize: 0.05
                            width: Math.min(480, parent.width)

                            onMoved: player.volume = value
                        }
                        ESwitch {
                            text: ELocale.texts.Mute

                            onCheckedChanged: player.muted = checked
                        }
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EInput {
                    id: source

                    width: Math.min(480, parent.width)
                    placeholderText: ELocale.texts.EnterALocalFilePathOrMediaURL
                }
                EMediaPlayer {
                    id: player

                    height: 220
                    autoPlay: false
                    source: source.text
                    width: Math.min(640, parent.width)
                }
                Column {
                    spacing: 16
                    width: parent.width

                    ESlider {
                        to: 1
                        from: 0
                        value: 0.5
                        stepSize: 0.05
                        width: Math.min(480, parent.width)

                        onMoved: player.volume = value
                    }
                    ESwitch {
                        text: ELocale.texts.Mute

                        onCheckedChanged: player.muted = checked
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EMediaPlayer"

        ExampleCase {
            title: ELocale.texts.CustomSeeking
            objectName: "showcaseEMediaPlayer2"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EInput {
                        id: source

                        width: Math.min(480, parent.width)
                        placeholderText: ELocale.texts.EnterALocalFilePathOrMediaURL
                    }
                    EMediaPlayer {
                        id: player

                        height: 220
                        autoPlay: false
                        source: source.text
                        controlsVisible: false
                        width: Math.min(640, parent.width)
                    }
                    ESlider {
                        from: 0
                        to: player.duration
                        value: player.position
                        enabled: player.duration > 0
                        width: Math.min(480, parent.width)

                        onMoved: player.seek(value)
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EInput {
                    id: source

                    width: Math.min(480, parent.width)
                    placeholderText: ELocale.texts.EnterALocalFilePathOrMediaURL
                }
                EMediaPlayer {
                    id: player

                    height: 220
                    autoPlay: false
                    source: source.text
                    controlsVisible: false
                    width: Math.min(640, parent.width)
                }
                ESlider {
                    from: 0
                    to: player.duration
                    value: player.position
                    enabled: player.duration > 0
                    width: Math.min(480, parent.width)

                    onMoved: player.seek(value)
                }
            }
        }
    }
    ExampleSection {
        componentName: "EMediaPlayer"

        ExampleCase {
            title: ELocale.texts.MediaErrors
            objectName: "showcaseEMediaPlayer3"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    EInput {
                        id: source

                        width: Math.min(480, parent.width)
                        placeholderText: ELocale.texts.EnterALocalFilePathOrMediaURL
                    }
                    EMediaPlayer {
                        id: player

                        height: 220
                        autoPlay: false
                        source: source.text
                        width: Math.min(640, parent.width)
                    }
                    EText {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: player.errorString.length > 0 ? player.errorString : ELocale.texts.WaitingForAMediaURL
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                EInput {
                    id: source

                    width: Math.min(480, parent.width)
                    placeholderText: ELocale.texts.EnterALocalFilePathOrMediaURL
                }
                EMediaPlayer {
                    id: player

                    height: 220
                    autoPlay: false
                    source: source.text
                    width: Math.min(640, parent.width)
                }
                EText {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: player.errorString.length > 0 ? player.errorString : ELocale.texts.WaitingForAMediaURL
                }
            }
        }
    }
}

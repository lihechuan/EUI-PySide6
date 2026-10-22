import EUI 1.0
import QtQuick 2.15

Column {
    spacing: 24
    width: parent.width

    ExampleSection {
        componentName: "EShadow"

        ExampleCase {
            objectName: "showcaseEShadow0"
            title: ELocale.texts.LowElevation
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Item {
                    height: 160
                    width: Math.min(480, parent.width)

                    ERectangle {
                        height: 90
                        radius: 16
                        width: 220
                        color: "#173958"
                        anchors.centerIn: parent

                        EShadow {
                            z: -1
                            elevation: 4
                            color: "#66000000"
                            anchors.fill: parent
                            radius: parent.radius
                        }
                        EText {
                            color: "#E7F0FF"
                            anchors.centerIn: parent
                            text: ELocale.texts.EuiSurface
                        }
                    }
                }
            `)

            Item {
                height: 160
                width: Math.min(480, parent.width)

                ERectangle {
                    height: 90
                    radius: 16
                    width: 220
                    color: "#173958"
                    anchors.centerIn: parent

                    EShadow {
                        z: -1
                        elevation: 4
                        color: "#66000000"
                        anchors.fill: parent
                        radius: parent.radius
                    }
                    EText {
                        color: "#E7F0FF"
                        anchors.centerIn: parent
                        text: ELocale.texts.EuiSurface
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EShadow"

        ExampleCase {
            objectName: "showcaseEShadow1"
            title: ELocale.texts.HighElevation
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Item {
                    height: 160
                    width: Math.min(480, parent.width)

                    ERectangle {
                        height: 90
                        radius: 16
                        width: 220
                        color: "#173958"
                        anchors.centerIn: parent

                        EShadow {
                            z: -1
                            elevation: 24
                            color: "#88000000"
                            anchors.fill: parent
                            radius: parent.radius
                        }
                        EText {
                            color: "#E7F0FF"
                            anchors.centerIn: parent
                            text: ELocale.texts.EuiSurface
                        }
                    }
                }
            `)

            Item {
                height: 160
                width: Math.min(480, parent.width)

                ERectangle {
                    height: 90
                    radius: 16
                    width: 220
                    color: "#173958"
                    anchors.centerIn: parent

                    EShadow {
                        z: -1
                        elevation: 24
                        color: "#88000000"
                        anchors.fill: parent
                        radius: parent.radius
                    }
                    EText {
                        color: "#E7F0FF"
                        anchors.centerIn: parent
                        text: ELocale.texts.EuiSurface
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EShadow"

        ExampleCase {
            objectName: "showcaseEShadow2"
            title: ELocale.texts.TintedShadow
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Item {
                    height: 160
                    width: Math.min(480, parent.width)

                    ERectangle {
                        height: 90
                        radius: 16
                        width: 220
                        color: "#173958"
                        anchors.centerIn: parent

                        EShadow {
                            z: -1
                            elevation: 16
                            color: "#80409EFF"
                            anchors.fill: parent
                            radius: parent.radius
                        }
                        EText {
                            color: "#E7F0FF"
                            anchors.centerIn: parent
                            text: ELocale.texts.EuiSurface
                        }
                    }
                }
            `)

            Item {
                height: 160
                width: Math.min(480, parent.width)

                ERectangle {
                    height: 90
                    radius: 16
                    width: 220
                    color: "#173958"
                    anchors.centerIn: parent

                    EShadow {
                        z: -1
                        elevation: 16
                        color: "#80409EFF"
                        anchors.fill: parent
                        radius: parent.radius
                    }
                    EText {
                        color: "#E7F0FF"
                        anchors.centerIn: parent
                        text: ELocale.texts.EuiSurface
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EShadow"

        ExampleCase {
            objectName: "showcaseEShadow3"
            title: ELocale.texts.RoundedShadow
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Item {
                    height: 160
                    width: Math.min(480, parent.width)

                    ERectangle {
                        radius: 50
                        width: 100
                        height: 100
                        color: "#67c23a"
                        anchors.centerIn: parent

                        EShadow {
                            z: -1
                            elevation: 16
                            anchors.fill: parent
                            radius: parent.radius
                        }
                    }
                }
            `)

            Item {
                height: 160
                width: Math.min(480, parent.width)

                ERectangle {
                    radius: 50
                    width: 100
                    height: 100
                    color: "#67c23a"
                    anchors.centerIn: parent

                    EShadow {
                        z: -1
                        elevation: 16
                        anchors.fill: parent
                        radius: parent.radius
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAcrylic"

        ExampleCase {
            objectName: "showcaseEAcrylic0"
            title: ELocale.texts.SubtleAcrylic
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Item {
                    height: 200
                    width: Math.min(480, parent.width)

                    ERectangle {
                        id: backdrop

                        anchors.fill: parent
                        gradient: Gradient {
                            GradientStop {
                                position: 0
                                color: "#409eff"
                            }
                            GradientStop {
                                position: 1
                                color: "#67c23a"
                            }
                        }

                        EText {
                            text: "EUI"
                            color: "white"
                            font.pixelSize: 64
                            anchors.centerIn: parent
                        }
                    }
                    EAcrylic {
                        radius: 20
                        height: 140
                        blurRadius: 12
                        tintOpacity: 0.25
                        sourceItem: backdrop
                        anchors.centerIn: parent
                        width: parent.width * 0.75

                        EText {
                            color: "#E7F0FF"
                            font.pixelSize: 20
                            anchors.centerIn: parent
                            text: ELocale.texts.AcrylicLabel
                        }
                    }
                }
            `)

            Item {
                height: 200
                width: Math.min(480, parent.width)

                ERectangle {
                    id: backdrop

                    anchors.fill: parent
                    gradient: Gradient {
                        GradientStop {
                            position: 0
                            color: "#409eff"
                        }
                        GradientStop {
                            position: 1
                            color: "#67c23a"
                        }
                    }

                    EText {
                        text: "EUI"
                        color: "white"
                        font.pixelSize: 64
                        anchors.centerIn: parent
                    }
                }
                EAcrylic {
                    radius: 20
                    height: 140
                    blurRadius: 12
                    tintOpacity: 0.25
                    sourceItem: backdrop
                    anchors.centerIn: parent
                    width: parent.width * 0.75

                    EText {
                        color: "#E7F0FF"
                        font.pixelSize: 20
                        anchors.centerIn: parent
                        text: ELocale.texts.AcrylicLabel
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAcrylic"

        ExampleCase {
            objectName: "showcaseEAcrylic1"
            title: ELocale.texts.TintedAcrylic
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Item {
                    height: 200
                    width: Math.min(480, parent.width)

                    ERectangle {
                        id: backdrop

                        anchors.fill: parent
                        gradient: Gradient {
                            GradientStop {
                                position: 0
                                color: "#409eff"
                            }
                            GradientStop {
                                position: 1
                                color: "#67c23a"
                            }
                        }

                        EText {
                            text: "EUI"
                            color: "white"
                            font.pixelSize: 64
                            anchors.centerIn: parent
                        }
                    }
                    EAcrylic {
                        radius: 20
                        height: 140
                        blurRadius: 40
                        tintOpacity: 0.7
                        sourceItem: backdrop
                        tintColor: "#173958"
                        anchors.centerIn: parent
                        width: parent.width * 0.75

                        EText {
                            color: "#E7F0FF"
                            font.pixelSize: 20
                            anchors.centerIn: parent
                            text: ELocale.texts.AcrylicLabel
                        }
                    }
                }
            `)

            Item {
                height: 200
                width: Math.min(480, parent.width)

                ERectangle {
                    id: backdrop

                    anchors.fill: parent
                    gradient: Gradient {
                        GradientStop {
                            position: 0
                            color: "#409eff"
                        }
                        GradientStop {
                            position: 1
                            color: "#67c23a"
                        }
                    }

                    EText {
                        text: "EUI"
                        color: "white"
                        font.pixelSize: 64
                        anchors.centerIn: parent
                    }
                }
                EAcrylic {
                    radius: 20
                    height: 140
                    blurRadius: 40
                    tintOpacity: 0.7
                    sourceItem: backdrop
                    tintColor: "#173958"
                    anchors.centerIn: parent
                    width: parent.width * 0.75

                    EText {
                        color: "#E7F0FF"
                        font.pixelSize: 20
                        anchors.centerIn: parent
                        text: ELocale.texts.AcrylicLabel
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAcrylic"

        ExampleCase {
            objectName: "showcaseEAcrylic2"
            title: ELocale.texts.SmoothGlass
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Item {
                    height: 200
                    width: Math.min(480, parent.width)

                    Image {
                        id: backdrop

                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                        source: "qrc:/example/images/gallery/lake.jpg"
                    }
                    EAcrylic {
                        radius: 20
                        height: 140
                        blurRadius: 24
                        noiseOpacity: 0
                        tintOpacity: 0.4
                        sourceItem: backdrop
                        anchors.centerIn: parent
                        width: parent.width * 0.75

                        EText {
                            color: "#E7F0FF"
                            font.pixelSize: 20
                            anchors.centerIn: parent
                            text: ELocale.texts.AcrylicLabel
                        }
                    }
                }
            `)

            Item {
                height: 200
                width: Math.min(480, parent.width)

                Image {
                    id: backdrop

                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    source: "qrc:/example/images/gallery/lake.jpg"
                }
                EAcrylic {
                    radius: 20
                    height: 140
                    blurRadius: 24
                    noiseOpacity: 0
                    tintOpacity: 0.4
                    sourceItem: backdrop
                    anchors.centerIn: parent
                    width: parent.width * 0.75

                    EText {
                        color: "#E7F0FF"
                        font.pixelSize: 20
                        anchors.centerIn: parent
                        text: ELocale.texts.AcrylicLabel
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EAcrylic"

        ExampleCase {
            objectName: "showcaseEAcrylic3"
            title: ELocale.texts.RefreshCapturedBackground
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                Column {
                    spacing: 16
                    width: parent.width

                    Item {
                        height: 180
                        width: Math.min(480, parent.width)

                        ERectangle {
                            id: backdrop

                            color: "#409eff"
                            anchors.fill: parent
                        }
                        EAcrylic {
                            id: glass

                            height: 120
                            live: false
                            sourceItem: backdrop
                            anchors.centerIn: parent
                            width: parent.width * 0.8
                        }
                    }
                    EButton {
                        text: ELocale.texts.ChangeBackgroundAndRefresh

                        onClicked: { backdrop.color = backdrop.color === "#409eff" ? "#67c23a" : "#409eff"
                            glass.refresh() }
                    }
                }
            `)

            Column {
                spacing: 16
                width: parent.width

                Item {
                    height: 180
                    width: Math.min(480, parent.width)

                    ERectangle {
                        id: backdrop

                        color: "#409eff"
                        anchors.fill: parent
                    }
                    EAcrylic {
                        id: glass

                        height: 120
                        live: false
                        sourceItem: backdrop
                        anchors.centerIn: parent
                        width: parent.width * 0.8
                    }
                }
                EButton {
                    text: ELocale.texts.ChangeBackgroundAndRefresh

                    onClicked: { backdrop.color = backdrop.color === "#409eff" ? "#67c23a" : "#409eff"
                        glass.refresh() }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EClip"

        ExampleCase {
            objectName: "showcaseEClip0"
            title: ELocale.texts.SquareClip
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EClip {
                    radius: 0
                    width: 180
                    height: 180

                    ERectangle {
                        width: 240
                        height: 240
                        rotation: 25
                        anchors.centerIn: parent
                        gradient: Gradient {
                            GradientStop {
                                position: 0
                                color: "#409eff"
                            }
                            GradientStop {
                                position: 1
                                color: "#67c23a"
                            }
                        }
                    }
                }
            `)

            EClip {
                radius: 0
                width: 180
                height: 180

                ERectangle {
                    width: 240
                    height: 240
                    rotation: 25
                    anchors.centerIn: parent
                    gradient: Gradient {
                        GradientStop {
                            position: 0
                            color: "#409eff"
                        }
                        GradientStop {
                            position: 1
                            color: "#67c23a"
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EClip"

        ExampleCase {
            objectName: "showcaseEClip1"
            title: ELocale.texts.RoundedClip
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EClip {
                    radius: 40
                    width: 180
                    height: 180

                    ERectangle {
                        width: 240
                        height: 240
                        rotation: 25
                        anchors.centerIn: parent
                        gradient: Gradient {
                            GradientStop {
                                position: 0
                                color: "#409eff"
                            }
                            GradientStop {
                                position: 1
                                color: "#67c23a"
                            }
                        }
                    }
                }
            `)

            EClip {
                radius: 40
                width: 180
                height: 180

                ERectangle {
                    width: 240
                    height: 240
                    rotation: 25
                    anchors.centerIn: parent
                    gradient: Gradient {
                        GradientStop {
                            position: 0
                            color: "#409eff"
                        }
                        GradientStop {
                            position: 1
                            color: "#67c23a"
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EClip"

        ExampleCase {
            objectName: "showcaseEClip2"
            title: ELocale.texts.CircleClip
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EClip {
                    radius: 90
                    width: 180
                    height: 180

                    ERectangle {
                        width: 240
                        height: 240
                        rotation: 25
                        anchors.centerIn: parent
                        gradient: Gradient {
                            GradientStop {
                                position: 0
                                color: "#409eff"
                            }
                            GradientStop {
                                position: 1
                                color: "#67c23a"
                            }
                        }
                    }
                }
            `)

            EClip {
                radius: 90
                width: 180
                height: 180

                ERectangle {
                    width: 240
                    height: 240
                    rotation: 25
                    anchors.centerIn: parent
                    gradient: Gradient {
                        GradientStop {
                            position: 0
                            color: "#409eff"
                        }
                        GradientStop {
                            position: 1
                            color: "#67c23a"
                        }
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EClip"

        ExampleCase {
            objectName: "showcaseEClip3"
            title: ELocale.texts.ImageClip
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EClip {
                    radius: 24
                    width: 180
                    height: 180

                    EImage {
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                        source: "qrc:/example/images/gallery/ocean.jpg"
                    }
                }
            `)

            EClip {
                radius: 24
                width: 180
                height: 180

                EImage {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    source: "qrc:/example/images/gallery/ocean.jpg"
                }
            }
        }
    }
    ExampleSection {
        componentName: "EParallaxView"

        ExampleCase {
            title: ELocale.texts.SubtleParallax
            objectName: "showcaseEParallaxView0"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EParallaxView {
                    speed: 0.2
                    height: 220
                    spacing: 20
                    width: Math.min(480, parent.width)
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
                        model: 8

                        EText {
                            height: 64
                            color: "#E7F0FF"
                            text: ELocale.texts.ContentArea + (index + 1)
                        }
                    }
                }
            `)

            EParallaxView {
                speed: 0.2
                height: 220
                spacing: 20
                width: Math.min(480, parent.width)
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
                    model: 8

                    EText {
                        height: 64
                        color: "#E7F0FF"
                        text: ELocale.texts.ContentArea + (index + 1)
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EParallaxView"

        ExampleCase {
            title: ELocale.texts.StrongParallax
            objectName: "showcaseEParallaxView1"
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EParallaxView {
                    speed: 0.7
                    height: 220
                    spacing: 20
                    width: Math.min(480, parent.width)
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
                        model: 8

                        EText {
                            height: 64
                            color: "#E7F0FF"
                            text: ELocale.texts.ContentArea + (index + 1)
                        }
                    }
                }
            `)

            EParallaxView {
                speed: 0.7
                height: 220
                spacing: 20
                width: Math.min(480, parent.width)
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
                    model: 8

                    EText {
                        height: 64
                        color: "#E7F0FF"
                        text: ELocale.texts.ContentArea + (index + 1)
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EParallaxView"

        ExampleCase {
            objectName: "showcaseEParallaxView2"
            title: ELocale.texts.FixedBackground
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EParallaxView {
                    speed: 0
                    height: 220
                    spacing: 20
                    width: Math.min(480, parent.width)
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
                        model: 8

                        EText {
                            height: 64
                            color: "#E7F0FF"
                            text: ELocale.texts.ContentArea + (index + 1)
                        }
                    }
                }
            `)

            EParallaxView {
                speed: 0
                height: 220
                spacing: 20
                width: Math.min(480, parent.width)
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
                    model: 8

                    EText {
                        height: 64
                        color: "#E7F0FF"
                        text: ELocale.texts.ContentArea + (index + 1)
                    }
                }
            }
        }
    }
    ExampleSection {
        componentName: "EParallaxView"

        ExampleCase {
            objectName: "showcaseEParallaxView3"
            title: ELocale.texts.FollowingBackground
            code: GalleryStyle.sourceCode(`
                import EUI 1.0
                import QtQuick 2.15

                EParallaxView {
                    speed: 1
                    height: 220
                    spacing: 20
                    width: Math.min(480, parent.width)
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
                        model: 8

                        EText {
                            height: 64
                            color: "#E7F0FF"
                            text: ELocale.texts.ContentArea + (index + 1)
                        }
                    }
                }
            `)

            EParallaxView {
                speed: 1
                height: 220
                spacing: 20
                width: Math.min(480, parent.width)
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
                    model: 8

                    EText {
                        height: 64
                        color: "#E7F0FF"
                        text: ELocale.texts.ContentArea + (index + 1)
                    }
                }
            }
        }
    }
}

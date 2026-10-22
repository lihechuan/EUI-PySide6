import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control

    property var model: []
    property bool loop: true
    property int interval: 3000
    property bool autoplay: true
    property int initialIndex: 0
    property real cardScale: 0.83
    property string arrow: "always"
    property bool interactive: true
    property bool motionBlur: false
    property string type: "default"
    property bool pauseOnHover: true
    property string trigger: "click"
    property string direction: "horizontal"
    property Component delegate: defaultSlide
    property string indicatorPosition: "inside"
    property alias currentIndex: slides.currentIndex

    readonly property int count: slides.count
    readonly property bool hasLabels: EDataUtils.isArray(model) && model.some(function(item) {
        return item && item.label !== undefined && String(item.label).length > 0
    })

    signal changed(int index)
    signal indexChanged(int index, int previousIndex)

    function next() {
        return setCurrentIndex(currentIndex + 1)
    }

    function previous() {
        return setCurrentIndex(currentIndex - 1)
    }

    function setActiveItem(value) {
        if (typeof value === "string" && EDataUtils.isArray(model)) {
            const index = model.findIndex(function(item) {
                return item && item.name === value
            })
            return index >= 0 && setCurrentIndex(index)
        }
        return setCurrentIndex(Number(value))
    }

    function setCurrentIndex(index) {
        if (!enabled || count === 0 || !isFinite(index))
            return false

        const requested = Math.floor(index)
        const next = loop ? ((requested % count) + count) % count
            : Math.max(0, Math.min(count - 1, requested))
        if (next === currentIndex)
            return false

        currentIndex = next
        return true
    }

    hoverEnabled: true
    implicitWidth: 480
    implicitHeight: 260
    contentItem: Item {
        clip: true

        SwipeView {
            id: slides

            anchors.centerIn: parent
            objectName: "carouselSlides"
            clip: control.type !== "card"
            interactive: control.interactive
            layer.enabled: control.motionBlur && internal.blurAmount > 0.001
            orientation: control.direction === "vertical" ? Qt.Vertical : Qt.Horizontal
            height: Math.max(0, parent.height - (control.indicatorPosition === "outside" ? 32 : 0))
            width: control.type === "card" && orientation === Qt.Horizontal ? parent.width * 0.7
                : parent.width
            layer.effect: ShaderEffect {
                property variant source
                property real amount: internal.blurAmount
                property vector2d direction: control.direction === "vertical"
                    ? Qt.vector2d(0, 0.016) : Qt.vector2d(0.016, 0)

                fragmentShader: "qrc:/qt/qml/EUI/Shaders/motion-blur.frag.qsb"
            }

            onCurrentIndexChanged: {
                if (control.motionBlur)
                    blurPulse.restart()
                control.changed(currentIndex)
                control.indexChanged(currentIndex, internal.previousIndex)
                internal.previousIndex = currentIndex
            }

            Repeater {
                model: EDataUtils.isArray(control.model) ? control.model : []

                Loader {
                    property int slideIndex: index
                    property var modelData: control.model[index]

                    width: slides.width
                    height: slides.height
                    sourceComponent: control.delegate
                    opacity: control.type === "card" && !SwipeView.isCurrentItem ? 0.6 : 1
                    active: SwipeView.isCurrentItem || SwipeView.isNextItem || SwipeView.isPreviousItem
                    scale: control.type === "card" && !SwipeView.isCurrentItem
                        ? Math.max(0.1, Math.min(1, control.cardScale))
                        : 1
                }
            }
        }
        EButton {
            implicitWidth: 32
            anchors.leftMargin: 12
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            text: EControlConfig.textFor(control, "PreviousGlyph", ELocale.texts)
            visible: control.count > 1 && control.arrow !== "never"
                && (control.arrow !== "hover" || control.hovered)

            onClicked: control.previous()
        }
        EButton {
            implicitWidth: 32
            anchors.rightMargin: 12
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            text: EControlConfig.textFor(control, "NextGlyph", ELocale.texts)
            visible: control.count > 1 && control.arrow !== "never"
                && (control.arrow !== "hover" || control.hovered)

            onClicked: control.next()
        }
        PageIndicator {
            interactive: true
            count: control.count
            anchors.bottom: parent.bottom
            currentIndex: control.currentIndex
            anchors.horizontalCenter: parent.horizontalCenter
            visible: count > 1 && control.indicatorPosition !== "none"
            delegate: ERectangle {
                readonly property string label: control.model[index]
                    && control.model[index].label !== undefined
                    ? String(control.model[index].label) : String(index + 1)

                radius: 3
                implicitHeight: control.hasLabels ? 24 : 6
                implicitWidth: control.hasLabels ? labelText.implicitWidth + 16
                    : index === control.currentIndex ? 18
                    : 6
                color: index === control.currentIndex
                    ? EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
                    : EPaletteManager.ThemePalette.textDisabled(ETheme.dark)

                EText {
                    id: labelText

                    font.pixelSize: 12
                    text: parent.label
                    anchors.centerIn: parent
                    visible: control.hasLabels
                    color: index === control.currentIndex ? EPaletteManager.BasePalette.white
                        : EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
                }
                MouseArea {
                    hoverEnabled: true
                    anchors.fill: parent

                    onClicked: control.setCurrentIndex(index)
                    onEntered: {
                        if (control.trigger === "hover")
                            control.setCurrentIndex(index)
                    }
                }
            }

            onCurrentIndexChanged: {
                if (currentIndex !== control.currentIndex)
                    control.setCurrentIndex(currentIndex)
            }
        }
        EEmpty {
            imageSize: 48
            anchors.centerIn: parent
            visible: control.count === 0
        }
    }

    Component.onCompleted: setCurrentIndex(initialIndex)

    Binding {
        delayed: true
        property: "currentIndex"
        value: slides ? slides.currentIndex : -1
        target: slides ? slides.contentItem : null
    }
    QtObject {
        id: internal

        property real blurAmount: 0
        property int previousIndex: -1
    }
    SequentialAnimation {
        id: blurPulse

        NumberAnimation {
            to: 1
            duration: 60
            target: internal
            property: "blurAmount"
        }
        NumberAnimation {
            to: 0
            duration: 240
            target: internal
            property: "blurAmount"
        }
    }
    Timer {
        repeat: true
        objectName: "carouselAutoTimer"
        interval: Math.max(100, control.interval)
        running: control.autoplay && control.enabled && control.visible && control.count > 1
            && (!control.pauseOnHover || !control.hovered)

        onTriggered: control.next()
    }
    Component {
        id: defaultSlide

        EImage {
            anchors.fill: parent
            source: typeof parent.modelData === "string" ? parent.modelData
                : parent.modelData && parent.modelData.source ? parent.modelData.source : ""
        }
    }
}

import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls

Control {
    id: control
    default property alias content: fallbackContent.data

    property int size: 40
    property string alt: ""
    property url source: ""
    property string text: ""
    property int iconSource: 0
    property string srcset: ""
    property string shape: "circle"
    property int fillMode: Image.PreserveAspectCrop
    property color backgroundColor: EPaletteManager.ThemePalette.textDisabled(ETheme.dark)

    readonly property url effectiveSource: sourceForDensity()
    readonly property bool loaded: avatarImage.status === Image.Ready

    signal loadError()

    function sourceForDensity() {
        if (!srcset.trim())
            return source
        const candidates = srcset.split(",").map(function(entry) {
            const parts = entry.trim().split(/\s+/)
            const descriptor = parts.length > 1 ? parts[parts.length - 1] : "1x"
            const numeric = parseFloat(descriptor)
            return { url: parts[0], density: descriptor.indexOf("w") >= 0 ? numeric / Math.max(1, size)
                : numeric }
        }).filter(function(entry) {
            return entry.url && isFinite(entry.density) && entry.density > 0
        })
            .sort(function(left, right) {
                return left.density - right.density
            })
        if (!candidates.length)
            return source
        const ratio = Screen.devicePixelRatio
        return (candidates.filter(function(entry) {
            return entry.density >= ratio
        })[0] || candidates[candidates.length - 1]).url
    }

    clip: true
    padding: 0
    opacity: enabled ? 1 : 0.5
    Accessible.name: alt || text
    implicitHeight: implicitWidth
    implicitWidth: Math.max(1, size)
    background: ERectangle {
        color: control.backgroundColor
        radius: control.shape === "square" ? 4 : width / 2
    }
    contentItem: Item {
        EText {
            font.bold: true
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: EPaletteManager.BasePalette.white
            font.pixelSize: Math.max(12, control.size * 0.4)
            visible: !control.loaded && control.iconSource === 0 && fallbackContent.children.length === 0
            text: control.text.length > 0 ? control.text
                : EControlConfig.textFor(control, "AvatarPlaceholder", ELocale.texts)
        }
        EIcon {
            anchors.centerIn: parent
            iconSize: control.size * 0.55
            iconSource: control.iconSource
            color: EPaletteManager.BasePalette.white
            visible: !control.loaded && control.iconSource !== 0 && fallbackContent.children.length === 0
        }
        Item {
            id: fallbackContent

            anchors.fill: parent
            visible: !control.loaded
        }
        Image {
            id: avatarImage

            visible: false
            asynchronous: true
            anchors.fill: parent
            fillMode: control.fillMode
            source: control.effectiveSource
            sourceSize: Qt.size(control.width, control.height)

            onStatusChanged: {
                if (status === Image.Error)
                    control.loadError()
                else if (status === Image.Ready)
                    avatarCanvas.requestPaint()
            }
        }
        Canvas {
            id: avatarCanvas

            anchors.fill: parent
            visible: control.loaded

            onImageLoaded: requestPaint()
            onWidthChanged: requestPaint()
            onHeightChanged: requestPaint()
            onPaint: {
                const context = getContext("2d")
                context.reset()
                if (!control.loaded
                    || width <= 0
                    || height <= 0
                    || avatarImage.implicitWidth <= 0
                    || avatarImage.implicitHeight <= 0)
                    return

                context.beginPath()
                if (control.shape === "circle")
                    context.arc(width / 2, height / 2, Math.min(width, height) / 2, 0, Math.PI * 2)
                else
                    context.roundedRect(0, 0, width, height, 4, 4)
                context.clip()
                const sourceWidth = avatarImage.implicitWidth
                const sourceHeight = avatarImage.implicitHeight
                if (control.fillMode === Image.Stretch) {
                    context.drawImage(avatarImage, 0, 0, width, height)
                } else {
                    const factor = control.fillMode === Image.PreserveAspectFit
                        ? Math.min(width / sourceWidth, height / sourceHeight)
                        : Math.max(width / sourceWidth, height / sourceHeight)
                    const targetWidth = sourceWidth * factor
                    const targetHeight = sourceHeight * factor
                    context.drawImage(avatarImage, (width - targetWidth) / 2,
                        (height - targetHeight) / 2, targetWidth, targetHeight)
                }
            }
        }
    }

    onShapeChanged: avatarCanvas.requestPaint()
    onFillModeChanged: avatarCanvas.requestPaint()
}

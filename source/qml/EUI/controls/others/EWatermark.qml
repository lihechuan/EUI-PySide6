import EUI 1.0
import EUI.Private 1.0
import QtQuick 2.15
import QtQml 2.15

Item {
    id: control
    default property alias containerContent: containerHost.data

    property var content
    property url image: ""
    property int zIndex: 9
    property real fontGap: 0
    property real rotate: -22
    property int tileWidth: 180
    property int tileHeight: 100
    property string textAlign: "center"
    property point offset: Qt.point(0, 0)
    property point gap: Qt.point(100, 100)
    property string textBaseline: "middle"
    property Component contentComponent: null
    property font font: Qt.font({ pixelSize: 16 })
    property color color: EPaletteManager.ThemePalette.fetchInverseThemeColor(ETheme.dark)

    readonly property real effectiveGapX: Math.max(0, gap.x)
    readonly property real effectiveGapY: Math.max(0, gap.y)
    readonly property real stepX: effectiveTileWidth + effectiveGapX
    readonly property real effectiveTileWidth: Math.max(1, tileWidth)
    readonly property real stepY: effectiveTileHeight + effectiveGapY
    readonly property real effectiveTileHeight: Math.max(1, tileHeight)
    readonly property bool hasContent: resolvedContent.length > 0 || image.toString().length > 0
    readonly property int rowCount: hasContent && width > 0 && height > 0
        ? Math.ceil((height + effectiveTileHeight) / stepY) + 2
        : 0
    readonly property int columnCount: hasContent && width > 0 && height > 0
        ? Math.ceil((width + effectiveTileWidth) / stepX) + 2
        : 0
    readonly property string resolvedContent: {
        if (EDataUtils.isArray(content))
            return content.join("\n")
        if (content === undefined || content === null)
            return ""
        return String(content)
    }

    z: zIndex
    clip: true
    opacity: 0.15
    Accessible.ignored: true
    implicitWidth: containerHost.childrenRect.width
    implicitHeight: containerHost.childrenRect.height

    onGapChanged: imageCanvas.requestPaint()
    onOffsetChanged: imageCanvas.requestPaint()
    onRotateChanged: imageCanvas.requestPaint()
    onTileWidthChanged: imageCanvas.requestPaint()
    onTileHeightChanged: imageCanvas.requestPaint()
    Component.onCompleted: {
        if (image.toString().length > 0)
            imageCanvas.loadImage(image)
    }
    onImageChanged: {
        if (image.toString().length > 0)
            imageCanvas.loadImage(image)
        imageCanvas.requestPaint()
    }

    Item {
        id: containerHost

        x: control.x
        y: control.y
        z: control.z - 1
        clip: control.clip
        scale: control.scale
        width: control.width
        height: control.height
        parent: control.parent
        visible: control.visible
        rotation: control.rotation
        transformOrigin: control.transformOrigin

        Loader {
            anchors.fill: parent
            sourceComponent: control.contentComponent
        }
    }
    Canvas {
        id: imageCanvas

        parent: control
        anchors.fill: parent
        objectName: "watermarkImageCanvas"
        visible: control.image.toString().length > 0

        onImageLoaded: requestPaint()
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        onPaint: {
            const context = getContext("2d")
            context.reset()
            if (!visible || !isImageLoaded(control.image))
                return
            for (let row = -1; row < control.rowCount; ++row) {
                for (let column = -1; column < control.columnCount; ++column) {
                    context.save()
                    context.translate(column * control.stepX
                        + control.offset.x
                        + control.effectiveTileWidth / 2,
                        row * control.stepY + control.offset.y + control.effectiveTileHeight / 2)
                    context.rotate(control.rotate * Math.PI / 180)
                    context.drawImage(control.image, -control.effectiveTileWidth / 2, -control.effectiveTileHeight / 2,
                        control.effectiveTileWidth, control.effectiveTileHeight)
                    context.restore()
                }
            }
        }
    }
    WatermarkRenderer {
        parent: control
        font: control.font
        anchors.fill: parent
        color: control.color
        offset: control.offset
        rotate: control.rotate
        fontGap: control.fontGap
        textAlign: control.textAlign
        text: control.resolvedContent
        objectName: "watermarkRenderer"
        textBaseline: control.textBaseline
        visible: control.image.toString().length === 0
        gap: Qt.point(control.effectiveGapX, control.effectiveGapY)
        tileSize: Qt.size(control.effectiveTileWidth, control.effectiveTileHeight)
    }
}

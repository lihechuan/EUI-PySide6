import EUI 1.0
import QtQuick 2.15
import QtQml 2.15

Item {
    id: control

    property real lineWidth: 1
    property int contentSpacing: 20
    property alias font: label.font
    property alias text: label.text
    property int verticalHeight: 16
    property string borderStyle: "solid"
    property Component contentComponent: null
    property int contentPosition: EPlacement.Center
    property int direction: EOrientation.Horizontal
    property color textColor: EPaletteManager.ThemePalette.fetchInverseThemeColor(ETheme.dark)
    property color color: ETheme.dark
        ? EPaletteManager.BasePalette.charcoalGray
        : EPaletteManager.BasePalette.gainsboro

    readonly property real effectiveLineWidth: Math.max(0, lineWidth)
    readonly property bool horizontal: direction !== EOrientation.Vertical
    readonly property real effectiveContentSpacing: Math.max(0, contentSpacing)
    readonly property real availableContentWidth: Math.max(0, width - 2 * effectiveContentSpacing)
    readonly property bool hasContent: horizontal && (label.text.length > 0 || contentLoader.item !== null)
    readonly property int effectiveContentPosition: contentPosition === EPlacement.Left
        || contentPosition === EPlacement.Right
        ? contentPosition
        : EPlacement.Center

    Accessible.name: text
    height: implicitHeight
    Accessible.role: Accessible.Separator
    width: horizontal ? implicitWidth : effectiveLineWidth
    implicitWidth: horizontal
        ? Math.max(100, hasContent
            ? Math.max(label.implicitWidth, (contentLoader.item ? contentLoader.item.implicitWidth : 0))
                + 2 * effectiveContentSpacing
            : 0)
        : effectiveLineWidth
    implicitHeight: horizontal
        ? (hasContent
            ? Math.max(effectiveLineWidth, label.implicitHeight, (contentLoader.item
                ? contentLoader.item.implicitHeight
                : 0))
            : effectiveLineWidth)
        : Math.max(0, verticalHeight)

    Loader {
        id: contentLoader

        x: label.x
        sourceComponent: control.contentComponent
        anchors.verticalCenter: parent.verticalCenter
        width: control.horizontal
            ? Math.min(contentLoader.item ? contentLoader.item.implicitWidth
                : 0, control.availableContentWidth)
            : 0
    }
    Canvas {
        id: lineCanvas

        anchors.fill: parent
        visible: control.borderStyle !== "solid"

        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        onVisibleChanged: requestPaint()
        onPaint: {
            const context = getContext("2d")
            context.reset()
            if (!visible || control.borderStyle === "none" || control.borderStyle === "hidden")
                return
            const thickness = control.effectiveLineWidth
            context.strokeStyle = control.color
            const shaded = ["groove", "ridge", "inset", "outset"].indexOf(control.borderStyle) >= 0
            context.lineWidth = control.borderStyle === "double" ? thickness / 3
                : shaded ? thickness / 2
                : thickness
            context.setLineDash(control.borderStyle === "dashed" ? [thickness * 5, thickness * 3]
                : control.borderStyle === "dotted" ? [thickness, thickness * 2] : [])
            const offsets = control.borderStyle === "double" ? [-thickness / 3, thickness / 3]
                : shaded ? [-thickness / 4, thickness / 4] : [0]
            for (let index = 0; index < offsets.length; ++index) {
                const offset = offsets[index]
                if (shaded) {
                    const dark = control.borderStyle === "inset"
                        || control.borderStyle === "groove" && index === 0
                        || control.borderStyle === "ridge" && index === 1
                    context.strokeStyle = dark ? Qt.darker(control.color, 1.5)
                        : Qt.lighter(control.color, 1.5)
                }
                context.beginPath()
                if (control.horizontal) {
                    const y = height / 2 + offset
                    context.moveTo(0, y)
                    context.lineTo(control.hasContent ? Math.max(0, label.x - control.effectiveContentSpacing)
                        : width, y)
                    if (control.hasContent) {
                        context.moveTo(label.x + label.width + control.effectiveContentSpacing, y)
                        context.lineTo(width, y)
                    }
                } else {
                    context.moveTo(width / 2 + offset, 0)
                    context.lineTo(width / 2 + offset, height)
                }
                context.stroke()
            }
        }
    }
    Connections {
        function onTextChanged() {
            lineCanvas.requestPaint()
        }

        function onColorChanged() {
            lineCanvas.requestPaint()
        }

        function onDirectionChanged() {
            lineCanvas.requestPaint()
        }

        function onLineWidthChanged() {
            lineCanvas.requestPaint()
        }

        function onBorderStyleChanged() {
            lineCanvas.requestPaint()
        }

        function onContentSpacingChanged() {
            lineCanvas.requestPaint()
        }

        function onContentPositionChanged() {
            lineCanvas.requestPaint()
        }

        target: control
    }
    EText {
        id: label

        maximumLineCount: 1
        elide: Text.ElideRight
        color: control.textColor
        objectName: "dividerLabel"
        anchors.verticalCenter: parent.verticalCenter
        visible: control.hasContent && !control.contentComponent
        width: Math.min(Math.max(implicitWidth, (contentLoader.item ? contentLoader.item.implicitWidth
            : 0)), control.availableContentWidth)
        x: control.effectiveContentPosition === EPlacement.Left
            ? 0
            : control.effectiveContentPosition === EPlacement.Right
            ? Math.max(0, control.width - width)
            : Math.max(0, (control.width - width) / 2)
    }
    ERectangle {
        id: leftLine

        x: 0
        radius: 0
        color: control.color
        height: control.effectiveLineWidth
        anchors.verticalCenter: parent.verticalCenter
        visible: control.horizontal && control.borderStyle === "solid"
        width: control.hasContent
            ? Math.max(0, label.x - control.effectiveContentSpacing)
            : Math.max(0, control.width)
    }
    ERectangle {
        id: rightLine

        radius: 0
        color: control.color
        height: control.effectiveLineWidth
        width: Math.max(0, control.width - x)
        anchors.verticalCenter: parent.verticalCenter
        x: Math.min(control.width,
            label.x + label.width + control.effectiveContentSpacing)
        visible: control.horizontal && control.borderStyle === "solid" && control.hasContent
    }
    ERectangle {
        radius: 0
        color: control.color
        anchors.centerIn: parent
        width: control.effectiveLineWidth
        height: Math.max(0, control.height)
        visible: !control.horizontal && control.borderStyle === "solid"
    }
}

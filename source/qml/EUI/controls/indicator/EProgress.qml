import EUI 1.0
import QtQuick 2.15
import QtQml 2.15

Item {
    id: control
    default property alias content: customText.data

    property var value: 0
    property var percentage
    property var format: null
    property string status: ""
    property int duration: 3000
    property int strokeWidth: 6
    property bool striped: false
    property bool showText: false
    property bool textInside: false
    property bool stripedFlow: false
    property bool indeterminate: false
    property string strokeLinecap: "round"
    property int styleType: EStyle.Primary
    property var color: EPaletteManager.BasePalette.transparent

    readonly property color effectiveColor: resolveColor()
    readonly property string displayText: typeof format === "function" ? String(format(normalizedValue * 100))
        : Math.round(normalizedValue * 100) + "%"
    readonly property int effectiveStyle: status === "success" ? EStyle.Success
        : status === "exception" ? EStyle.Danger : status === "warning" ? EStyle.Warning : styleType
    readonly property real normalizedValue: {
        const number = percentage === undefined ? Number(value) : Number(percentage) / 100
        return isFinite(number) ? Math.max(0, Math.min(1, number)) : 0
    }

    function resolveColor() {
        let selected = color
        try {
            if (typeof color === "function")
                selected = color(normalizedValue * 100)
            else if (EDataUtils.isArray(color)) {
                const colors = color.filter(function(item) {
                    return item && isFinite(item.percentage)
                })
                    .slice().sort(function(left, right) {
                        return left.percentage - right.percentage
                    })
                if (colors.length > 0) {
                    selected = colors[colors.length - 1].color
                    for (let index = 0; index < colors.length; ++index) {
                        if (normalizedValue * 100 <= colors[index].percentage) {
                            selected = colors[index].color
                            break
                        }
                    }
                } else {
                    selected = EPaletteManager.BasePalette.transparent
                }
            }
        } catch (error) {
            selected = EPaletteManager.BasePalette.transparent
        }
        return EPaletteManager.StatePalette.computeBackgroundColor(
            EPaletteManager.createStateObject(this, EStyle.Color)
                .setDark(ETheme.dark)
                .setEnabled(enabled)
                .setColor(selected || EPaletteManager.BasePalette.transparent)
                .setComponentStyle(effectiveStyle)
        )
    }

    implicitWidth: 240
    implicitHeight: textInside && showText ? Math.max(20, strokeWidth) : Math.max(0, strokeWidth)

    QtObject {
        id: internal

        property real phase: 0
    }
    ERectangle {
        id: track

        clip: true
        objectName: "progressTrack"
        height: Math.max(0, control.height)
        anchors.verticalCenter: parent.verticalCenter
        radius: control.strokeLinecap === "round" ? height / 2 : 0
        width: Math.max(0, parent.width - (control.showText && !control.textInside ? label.implicitWidth + 12
            : 0))
        color: EPaletteManager.StatePalette.computeBackgroundColor(
            EPaletteManager.createStateObject(this, EStyle.Color)
                .setDark(ETheme.dark)
                .setPlain(true)
                .setColor(EPaletteManager.ThemePalette.fetchInverseThemeColor(ETheme.dark))

        )

        Repeater {
            model: control.indeterminate ? 2 : 1

            ERectangle {
                id: fill

                clip: true
                color: control.effectiveColor
                height: Math.max(0, parent.height)
                radius: control.strokeLinecap === "round" ? height / 2 : 0
                objectName: index === 0 ? "progressFill" : "progressWrapFill"
                x: control.indeterminate ? (internal.phase - index) * parent.width : 0
                width: parent.width * (control.indeterminate ? 0.25 : control.normalizedValue)

                Behavior on width {
                    enabled: !control.indeterminate

                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutQuad
                    }
                }
                Canvas {
                    id: stripesCanvas

                    anchors.fill: parent
                    visible: control.striped

                    onWidthChanged: requestPaint()
                    onHeightChanged: requestPaint()
                    onPaint: {
                        const ctx = getContext("2d")
                        ctx.reset()
                        ctx.clearRect(0, 0, width, height)
                        ctx.fillStyle = "#33FFFFFF"
                        const spacing = Math.max(12, height * 2)
                        const offset = control.stripedFlow ? internal.phase * spacing : 0
                        for (let x = -spacing + offset; x < width + spacing; x += spacing) {
                            ctx.beginPath()
                            ctx.moveTo(x, 0)
                            ctx.lineTo(x + spacing / 2, 0)
                            ctx.lineTo(x + spacing / 2 - height, height)
                            ctx.lineTo(x - height, height)
                            ctx.closePath()
                            ctx.fill()
                        }
                    }

                    Connections {
                        function onPhaseChanged() {
                            stripesCanvas.requestPaint()
                        }

                        target: internal
                    }
                }
            }
        }
    }
    EText {
        id: label

        font.pixelSize: 13
        text: control.displayText
        verticalAlignment: Text.AlignVCenter
        x: control.textInside ? 0 : track.width + 12
        anchors.verticalCenter: parent.verticalCenter
        height: Math.max(control.height, implicitHeight)
        width: control.textInside ? track.width : implicitWidth
        visible: control.showText && customText.children.length === 0
        horizontalAlignment: control.textInside ? Text.AlignHCenter : Text.AlignLeft
        color: control.textInside ? EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
            : EPaletteManager.ThemePalette.textRegular(ETheme.dark)
    }
    Item {
        id: customText

        height: childrenRect.height
        x: control.textInside ? 0 : track.width + 12
        anchors.verticalCenter: parent.verticalCenter
        width: control.textInside ? track.width : childrenRect.width
    }
    NumberAnimation {
        to: 1
        from: 0
        target: internal
        property: "phase"
        loops: Animation.Infinite
        duration: Math.max(100, control.duration)
        running: control.visible
            && control.enabled
            && (control.indeterminate || control.striped && control.stripedFlow)
    }
}

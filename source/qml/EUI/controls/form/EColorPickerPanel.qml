import EUI 1.0
import EUI.Private 1.0
import "." as FormControls
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control

    property real hue: 0
    property real alpha: 1
    property var predefine: []
    property real brightness: 1
    property real saturation: 0
    property bool clearable: false
    property bool showAlpha: false
    property bool showButtons: false
    property string colorFormat: "hex"
    property bool commitOnConfirm: false
    property var valueOnClear: EControlConfig.valueFor(control, "valueOnClear", "")
    property var value: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary).toString()

    signal cleared()
    signal canceled()
    signal confirmed(var value)
    signal picked(string value)
    signal activeChanged(var value)

    function updateColor() {
        return selectColor(Qt.hsva(hue, saturation, brightness, showAlpha ? alpha : 1).toString())
    }

    function confirm() {
        if (!enabled || !parseColor(value))
            return false
        internal.editing = false
        picked(value)
        confirmed(value)
        return true
    }

    function cancel() {
        if (!internal.editing)
            return false
        internal.editing = false
        value = internal.originalValue
        activeChanged(value)
        if (!commitOnConfirm)
            picked(value)
        canceled()
        return true
    }

    function clear() {
        if (!enabled)
            return false
        value = typeof valueOnClear === "function" ? valueOnClear() : valueOnClear
        internal.editing = false
        activeChanged(value)
        picked(value)
        cleared()
        return true
    }

    function begin(nextValue) {
        if (arguments.length > 0
            && (nextValue === "" || nextValue === null || nextValue === undefined || parseColor(nextValue)))
            value = nextValue
        internal.originalValue = value
        internal.editing = true
    }

    function syncColor() {
        const parsed = parseColor(value)
        if (!parsed)
            return
        internal.color = parsed
        hue = Math.max(0, internal.color.hsvHue)
        saturation = internal.color.hsvSaturation
        brightness = internal.color.hsvValue
        alpha = internal.color.a
    }

    function selectColor(color) {
        const parsed = parseColor(color)
        if (!enabled || !parsed)
            return false
        if (showButtons && !internal.editing)
            begin(value)
        value = formattedColor(parsed)
        activeChanged(value)
        if (!commitOnConfirm)
            picked(value)
        return true
    }

    function formattedColor(color) {
        internal.color = color
        const item = internal.color
        const alpha = Math.round(item.a * 1000) / 1000
        if (colorFormat === "name")
            return EValueUtils.colorName(item.toString())
        if (colorFormat === "rgb" || colorFormat === "prgb") {
            const parts = [item.r, item.g, item.b].map(function(channel) {
                return colorFormat === "prgb" ? Math.round(channel * 100) + "%" : Math.round(channel * 255)
            })
            return showAlpha ? "rgba(" + parts.join(", ") + ", " + alpha + ")"
                : "rgb(" + parts.join(", ") + ")"
        }
        if (colorFormat === "hsl" || colorFormat === "hsv") {
            const hsv = colorFormat === "hsv"
            const parts = [Math.round(Math.max(0, hsv ? item.hsvHue : item.hslHue) * 360),
                Math.round((hsv ? item.hsvSaturation : item.hslSaturation) * 100) + "%",
                Math.round((hsv ? item.hsvValue : item.hslLightness) * 100) + "%"]
            return colorFormat
                + (showAlpha ? "a(" : "(")
                + parts.join(", ")
                + (showAlpha ? ", " + alpha : "")
                + ")"
        }
        if (["hex3", "hex4", "hex6", "hex8"].indexOf(colorFormat) >= 0) {
            const compact = colorFormat === "hex3" || colorFormat === "hex4"
            const channels = [item.r, item.g, item.b]
            if (colorFormat === "hex4" || colorFormat === "hex8")
                channels.push(item.a)
            return "#" + channels.map(function(channel) {
                const hex = Math.round(channel * (compact ? 15 : 255)).toString(16)
                return compact ? hex : ("0" + hex).slice(-2)
            }).join("")
        }
        return showAlpha ? item.toString() : Qt.rgba(item.r, item.g, item.b, 1).toString()
    }

    function parseColor(text, format) {
        const input = String(text).trim().toLowerCase()
        if (/^#(?:[0-9a-f]{3}|[0-9a-f]{4})$/.test(input)) {
            const channels = input.slice(1).split("").map(function(channel) {
                return parseInt(channel, 16) / 15
            })
            return Qt.rgba(channels[0], channels[1], channels[2], channels.length > 3 ? channels[3] : 1)
        }
        if (/^#[0-9a-f]{8}$/.test(input) && (format === undefined ? colorFormat : format) === "hex8")
            return Qt.rgba(parseInt(input.slice(1, 3), 16) / 255, parseInt(input.slice(3, 5), 16) / 255,
                parseInt(input.slice(5, 7), 16) / 255, parseInt(input.slice(7, 9), 16) / 255)
        if (/^#(?:[0-9a-f]{6}|[0-9a-f]{8})$/.test(input))
            return input
        const match = /^(rgba?|hsla?|hsva?)\(([^)]+)\)$/.exec(input)
        if (!match)
            return EValueUtils.parseColor(input) || null
        const parts = match[2].split(",").map(function(part) {
            return part.trim()
        })
        const withAlpha = match[1].slice(-1) === "a"
        if (parts.length !== (withAlpha ? 4 : 3))
            return null
        const opacity = withAlpha ? Number(parts[3]) : 1
        if (!isFinite(opacity) || opacity < 0 || opacity > 1)
            return null
        if (match[1].indexOf("rgb") === 0) {
            const channels = parts.slice(0, 3).map(function(part) {
                return part.slice(-1) === "%" ? Number(part.slice(0, -1)) / 100 : Number(part) / 255
            })
            if (channels.some(function(value) {
                return !isFinite(value) || value < 0 || value > 1
            }))
                return null
            return Qt.rgba(channels[0], channels[1], channels[2], opacity)
        }
        const hue = Number(parts[0])
        const saturation = Number(parts[1].replace(/%$/, "")) / 100
        const lightness = Number(parts[2].replace(/%$/, "")) / 100
        if (!isFinite(hue) || !isFinite(saturation) || !isFinite(lightness)
                || saturation < 0 || saturation > 1 || lightness < 0 || lightness > 1) return null
        const normalizedHue = ((hue % 360) + 360) % 360 / 360
        return (match[1].indexOf("hsv") === 0 ? Qt.hsva(normalizedHue, saturation, lightness, opacity)
            : Qt.hsla(normalizedHue, saturation, lightness, opacity))
    }

    padding: 12
    implicitWidth: 300
    background: FieldSurface {}
    implicitHeight: colorColumn.implicitHeight + topPadding + bottomPadding
    contentItem: Column {
        id: colorColumn

        spacing: 12

        ColorSquare {
            hue: control.hue
            width: parent.width
            height: implicitHeight
            brightness: control.brightness
            saturation: control.saturation

            onMoved: {
                control.saturation = saturation
                control.brightness = brightness
                control.updateColor()
            }
        }
        FormControls.ESlider {
            id: hueSlider

            to: 1
            from: 0
            padding: 0
            implicitHeight: 24
            showTooltip: false
            value: control.hue
            width: parent.width
            objectName: "colorHueSlider"
            Accessible.name: EControlConfig.textFor(control, "Hue", ELocale.texts)
            handle: ERectangle {
                width: 6
                radius: 2
                height: 18
                border.width: 2
                y: (hueSlider.height - height) / 2
                color: Qt.hsva(control.hue, 1, 1, 1)
                border.color: EPaletteManager.BasePalette.white
                x: (hueSlider.width - width) * hueSlider.visualPosition
            }
            background: ERectangle {
                radius: 4
                height: 12
                x: hueSlider.handle.width / 2
                y: (hueSlider.height - height) / 2
                width: hueSlider.width - hueSlider.handle.width
                gradient: Gradient {
                    orientation: Gradient.Horizontal

                    GradientStop {
                        position: 0
                        color: Qt.hsva(0, 1, 1, 1)
                    }
                    GradientStop {
                        position: 1 / 6
                        color: Qt.hsva(1 / 6, 1, 1, 1)
                    }
                    GradientStop {
                        position: 2 / 6
                        color: Qt.hsva(2 / 6, 1, 1, 1)
                    }
                    GradientStop {
                        position: 3 / 6
                        color: Qt.hsva(3 / 6, 1, 1, 1)
                    }
                    GradientStop {
                        position: 4 / 6
                        color: Qt.hsva(4 / 6, 1, 1, 1)
                    }
                    GradientStop {
                        position: 5 / 6
                        color: Qt.hsva(5 / 6, 1, 1, 1)
                    }
                    GradientStop {
                        position: 1
                        color: Qt.hsva(1, 1, 1, 1)
                    }
                }
            }

            onMoved: {
                control.hue = value
                control.updateColor()
            }
        }
        FormControls.ESlider {
            id: alphaSlider

            to: 1
            from: 0
            padding: 0
            implicitHeight: 24
            showTooltip: false
            width: parent.width
            value: control.alpha
            visible: control.showAlpha
            objectName: "colorAlphaSlider"
            Accessible.name: EControlConfig.textFor(control, "Opacity", ELocale.texts)
            handle: ERectangle {
                width: 6
                radius: 2
                height: 18
                border.width: 2
                y: (alphaSlider.height - height) / 2
                x: (alphaSlider.width - width) * alphaSlider.visualPosition
                color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
                border.color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
            }
            background: Item {
                id: alphaTrack

                readonly property int checkerColumns: Math.min(64, Math.max(1, Math.ceil(width / 8)))

                height: 12
                x: alphaSlider.handle.width / 2
                y: (alphaSlider.height - height) / 2
                width: alphaSlider.width - alphaSlider.handle.width

                Row {
                    anchors.fill: parent

                    Repeater {
                        model: alphaTrack.checkerColumns
                        delegate: Column {
                            width: alphaTrack.width / alphaTrack.checkerColumns

                            ERectangle {
                                height: 6
                                width: parent.width
                                color: index % 2 ? EPaletteManager.ThemePalette.surfacePressed(ETheme.dark)
                                    : EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
                            }
                            ERectangle {
                                height: 6
                                width: parent.width
                                color: index % 2 ? EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
                                    : EPaletteManager.ThemePalette.surfacePressed(ETheme.dark)
                            }
                        }
                    }
                }
                ERectangle {
                    anchors.fill: parent
                    gradient: Gradient {
                        orientation: Gradient.Horizontal

                        GradientStop {
                            position: 0
                            color: Qt.hsva(control.hue, control.saturation, control.brightness, 0)
                        }
                        GradientStop {
                            position: 1
                            color: Qt.hsva(control.hue, control.saturation, control.brightness, 1)
                        }
                    }
                }
            }

            onMoved: {
                control.alpha = value
                control.updateColor()
            }
        }
        Flow {
            spacing: 6
            width: parent.width

            Repeater {
                model: control.predefine
                delegate: ERectangle {
                    radius: 3
                    width: 24
                    height: 24
                    border.width: 1
                    color: modelData
                    border.color: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)

                    MouseArea {
                        anchors.fill: parent
                        enabled: control.enabled
                        cursorShape: Qt.PointingHandCursor

                        onClicked: control.selectColor(String(modelData))
                    }
                }
            }
        }
        EInput {
            width: parent.width
            text: control.value === undefined || control.value === null ? "" : String(control.value)
            placeholderText: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary).toString()

            onEditingFinished: {
                control.selectColor(text)
                text = Qt.binding(function() {
                    return control.value
                })
            }
        }
        Row {
            spacing: 8
            anchors.right: parent.right
            visible: control.showButtons

            ETextButton {
                visible: control.clearable
                text: EControlConfig.textFor(control, "ClearAll", ELocale.texts)

                onClicked: control.clear()
            }
            ETextButton {
                text: EControlConfig.textFor(control, "Cancel", ELocale.texts)

                onClicked: control.cancel()
            }
            EButton {
                styleType: EStyle.Primary
                text: EControlConfig.textFor(control, "Confirm", ELocale.texts)

                onClicked: control.confirm()
            }
        }
    }

    onValueChanged: syncColor()
    Component.onCompleted: {
        internal.format = colorFormat
        syncColor()
    }
    onColorFormatChanged: {
        const parsed = parseColor(value, internal.format)
        internal.format = colorFormat
        if (parsed)
            value = formattedColor(parsed)
    }

    QtObject {
        id: internal

        property bool editing: false
        property string format: "hex"
        property var originalValue: ""
        property color color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary).toString()
    }
}

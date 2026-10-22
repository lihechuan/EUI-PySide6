import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Control {
    id: control

    property var value: 0
    property int precision: 0
    property string title: ""
    property string prefix: ""
    property string suffix: ""
    property var formatter: null
    property bool countdown: false
    property string format: "HH:mm:ss"
    property Component titleDelegate: null
    property Component prefixDelegate: null
    property Component suffixDelegate: null
    property string groupSeparator: EControlConfig.textFor(control, "NumberGroupSeparator", ELocale.texts)
    property string decimalSeparator: EControlConfig.textFor(control, "NumberDecimalSeparator", ELocale.texts)

    readonly property string displayValue: formatValue()
    readonly property real remaining: Math.max(0, Number(value) - internal.now)

    signal finished()
    signal changed(real remaining)

    function tick() {
        internal.now = Date.now()
        changed(remaining)
        if (remaining === 0 && !internal.finished) {
            internal.finished = true
            finished()
        }
    }

    function formatValue() {
        if (typeof formatter === "function")
            return String(formatter(countdown ? remaining : value))
        if (countdown)
            return formatCountdown()
        return isFinite(Number(value))
            ? EDataUtils.formatNumber(value, precision, groupSeparator, decimalSeparator)
            : EControlConfig.textFor(control, "MissingValue", ELocale.texts)
    }

    function formatCountdown() {
        const tokens = format.replace(/\[[^\]]*\]/g, "")
        const hasDays = /D/.test(tokens)
        const hasHours = /H/.test(tokens)
        const hasMinutes = /m/.test(tokens)
        const units = {
            D: Math.floor(remaining / 86400000),
            H: Math.floor(remaining / 3600000) % (hasDays ? 24 : 1000000000),
            m: Math.floor(remaining / 60000) % (hasHours || hasDays ? 60 : 1000000000),
            s: Math.floor(remaining / 1000) % (hasMinutes || hasHours || hasDays ? 60 : 1000000000),
            S: Math.floor(remaining % 1000)
        }
        return format.replace(/\[([^\]]*)\]|D{1,2}|H{1,2}|m{1,2}|s{1,2}|S{1,3}/g, function(token, literal) {
            if (literal !== undefined)
                return literal
            let text = String(token[0] === "S" ? Math.floor(units.S / Math.pow(10, 3 - token.length))
                : units[token[0]])
            while (text.length < token.length)
                text = "0" + text
            return text
        })
    }

    implicitWidth: statisticColumn.implicitWidth
    implicitHeight: statisticColumn.implicitHeight
    contentItem: Column {
        id: statisticColumn

        spacing: 8

        EText {
            font.pixelSize: 14
            text: control.title
            visible: text.length > 0 && !titleSlot.active
            color: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
        }
        Loader {
            id: titleSlot

            active: sourceComponent !== null
            sourceComponent: control.titleDelegate
        }
        Row {
            spacing: 4

            Loader {
                active: sourceComponent !== null
                sourceComponent: control.prefixDelegate
            }
            EText {
                font.pixelSize: 28
                objectName: "statisticValue"
                color: EPaletteManager.ThemePalette.textPrimary(ETheme.dark)
                text: (control.prefixDelegate ? "" : control.prefix) + control.displayValue
                    + (control.suffixDelegate ? "" : control.suffix)
            }
            Loader {
                active: sourceComponent !== null
                sourceComponent: control.suffixDelegate
            }
        }
    }

    Component.onCompleted: {
        if (countdown)
            tick()
    }
    onValueChanged: {
        if (!internal)
            return
        internal.finished = false
        internal.now = Date.now()
        if (countdown)
            Qt.callLater(tick)
    }

    QtObject {
        id: internal

        property bool finished: false
        property real now: Date.now()
    }
    Timer {
        repeat: true
        running: control.countdown && control.visible && control.enabled && !internal.finished
        interval: /S{2,3}/.test(control.format.replace(/\[[^\]]*\]/g, "")) ? 30
            : /S/.test(control.format.replace(/\[[^\]]*\]/g, "")) ? 100 : 250

        onTriggered: control.tick()
    }
}

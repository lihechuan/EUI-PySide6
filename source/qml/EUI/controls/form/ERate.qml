import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQuick.Controls

Control {
    id: control

    property int max: 5
    property var icons: []
    property var texts: []
    property real value: 0
    property var colors: []
    property real hoverValue: -1
    property real lowThreshold: 2
    property bool readOnly: false
    property bool showText: false
    property bool allowHalf: false
    property bool clearable: false
    property real highThreshold: 4
    property bool showScore: false
    property bool validateEvent: true
    property int voidIcon: EIcons.STAR
    property int disabledVoidIcon: voidIcon
    property int halfIcon: EIcons.STAR_FILL
    property string scoreTemplate: "{value}"
    property color disabledVoidColor: voidColor
    property int size: EControlConfig.sizeFor(control)
    property color textColor: EPaletteManager.ThemePalette.textRegular(ETheme.dark)
    property color voidColor: EPaletteManager.ThemePalette.textDisabled(ETheme.dark)
    property color activeColor: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Warning)

    readonly property real currentScore: hoverValue >= 0 ? hoverValue : value
    readonly property color currentColor: thresholdValue(colors, currentScore, activeColor)
    readonly property int currentIcon: thresholdValue(icons, currentScore, EIcons.STAR_FILL)

    signal rated(real value)

    function resetCurrentValue() {
        hoverValue = -1
    }

    function setCurrentValue(nextValue) {
        if (!enabled || readOnly || !isFinite(nextValue))
            return false
        hoverValue = Math.max(0, Math.min(Math.max(0, max), nextValue))
        return true
    }

    function setRating(nextValue) {
        if (!enabled || readOnly || !isFinite(nextValue))
            return false
        const normalized = Math.max(0, Math.min(Math.max(0, max), nextValue))
        value = clearable && value === normalized ? 0 : normalized
        rated(value)
        return true
    }

    function thresholdValue(settings, score, fallback) {
        if (EDataUtils.isArray(settings)) {
            if (settings.length === 0)
                return fallback
            const level = settings.length === 3 ? score <= lowThreshold ? 0 : score >= highThreshold ? 2 : 1
                : Math.min(settings.length - 1, Math.max(0, Math.ceil(score) - 1))
            return settings[level]
        }
        if (!settings || typeof settings !== "object")
            return fallback
        const thresholds = Object.keys(settings).map(Number).filter(isFinite).sort(function(left, right) {
            return left - right
        })
        for (let index = 0; index < thresholds.length; ++index) {
            const entry = settings[thresholds[index]]
            const excluded = entry && typeof entry === "object" && entry.excluded
            if (excluded ? score < thresholds[index] : score <= thresholds[index])
                return entry && typeof entry === "object" ? entry.value : entry
        }
        return fallback
    }

    spacing: 6
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    Accessible.role: Accessible.Slider
    implicitHeight: EDefaultConfig.controlHeight(control.size)
    Accessible.name: EControlConfig.textFor(control, "Rating12", ELocale.texts).arg(value).arg(max)
    implicitWidth: stars.implicitWidth + leftPadding + rightPadding
        + (ratingText.visible ? ratingText.implicitWidth + spacing : 0)
    contentItem: Row {
        id: stars

        spacing: control.spacing

        Repeater {
            model: Math.max(0, control.max)
            delegate: Item {
                height: control.implicitHeight
                width: EDefaultConfig.iconSize(control.size) + 6

                EIcon {
                    iconSize: parent.width
                    anchors.centerIn: parent
                    color: control.readOnly || !control.enabled ? control.disabledVoidColor
                        : control.voidColor
                    iconSource: control.readOnly || !control.enabled ? control.disabledVoidIcon
                        : control.voidIcon
                }
                Item {
                    clip: true
                    height: parent.height
                    width: parent.width * Math.max(0, Math.min(1,
                        (control.hoverValue >= 0 ? control.hoverValue : control.value) - index))

                    EIcon {
                        iconSize: width
                        height: parent.height
                        color: control.currentColor
                        objectName: "rateFilledIcon"
                        opacity: control.enabled ? 1 : 0.5
                        width: EDefaultConfig.iconSize(control.size) + 6
                        iconSource: control.currentScore - index > 0 && control.currentScore - index < 1
                            ? control.halfIcon : control.currentIcon
                    }
                }
                MouseArea {
                    hoverEnabled: true
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    enabled: control.enabled && !control.readOnly

                    onExited: control.hoverValue = -1
                    onPositionChanged: control.hoverValue = index
                        + (control.allowHalf && mouse.x < width / 2 ? 0.5 : 1)
                    onClicked: {
                        control.forceActiveFocus()
                        control.setRating(index + (control.allowHalf && mouse.x < width / 2 ? 0.5 : 1))
                    }
                }
            }
        }
    }

    onEnabledChanged: if (!enabled)
        hoverValue = -1
    onReadOnlyChanged: if (readOnly)
        hoverValue = -1
    onMaxChanged: if (value > Math.max(0, max))
        value = Math.max(0, max)
    onValueChanged: {
        const normalized = Math.max(0, Math.min(Math.max(0, max), isFinite(value) ? value : 0))
        if (value !== normalized)
            value = normalized
    }
    Keys.onPressed: function(event) {
        const step = allowHalf ? 0.5 : 1
        if (event.key === Qt.Key_Left || event.key === Qt.Key_Down) {
            setRating(value - step)
            event.accepted = true
        } else if (event.key === Qt.Key_Right || event.key === Qt.Key_Up) {
            setRating(value + step)
            event.accepted = true
        }
    }

    EText {
        id: ratingText

        color: control.textColor
        anchors.verticalCenter: parent.verticalCenter
        visible: control.showScore || control.showText
        x: stars.x + stars.implicitWidth + control.spacing
        text: control.showScore ? control.scoreTemplate.replace("{value}", String(control.value))
            : control.texts[Math.max(0, Math.ceil(control.value) - 1)] || ""
    }
}

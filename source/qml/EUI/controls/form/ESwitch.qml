import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

Switch {
    id: control

    property var value
    property int activeIcon
    property int inactiveIcon
    property int duration: 300
    property bool loading: false
    property string activeText: ""
    property var activeValue: true
    property var beforeChange: null
    property string inactiveText: ""
    property var inactiveValue: false
    property bool validateEvent: true
    property string accessibleName: text
    property int size: EControlConfig.sizeFor(control)
    property color activeColor: EPaletteManager.ThemePalette.fetchColorForStyle()
    property color inactiveColor: EPaletteManager.StatePalette.resolveSwitchOffColor(
        EPaletteManager.createStateObject(this, EStyle.Color)
            .setDark(ETheme.dark)
    )

    signal changeRejected(string message)

    function requestChange(nextChecked, previousChecked) {
        if (!enabled || loading)
            return false
        const revision = ++guardState.revision
        const previous = previousChecked === undefined ? checked : previousChecked
        function apply(allowed) {
            if (revision !== guardState.revision || !control.enabled)
                return false
            loading = false
            if (allowed === false)
                return false
            checked = nextChecked
            value = checked ? activeValue : inactiveValue
            return true
        }
        try {
            const result = typeof beforeChange === "function" ? beforeChange() : true
            if (result && typeof result.then === "function") {
                checked = previous
                loading = true
                result.then(apply, function(error) {
                    if (revision !== guardState.revision)
                        return
                    loading = false
                    changeRejected(String(error))
                })
                return true
            }
            if (result === false)
                checked = previous
            return apply(result)
        } catch (error) {
            checked = previous
            changeRejected(String(error))
            return false
        }
    }

    padding: 0
    spacing: 8
    width: implicitWidth
    height: implicitHeight
    Accessible.checked: control.checked
    Accessible.role: Accessible.CheckBox
    Accessible.name: control.accessibleName
    text: checked ? activeText : inactiveText
    font.pixelSize: EDefaultConfig.controlFontPixelSize(control.size)
    implicitWidth: (control.text.length > 0 ? implicitContentWidth : inside.minWidth)
        + leftPadding + rightPadding
    implicitHeight: Math.max(EDefaultConfig.switchHeight(control.size),
        control.text.length > 0 ? implicitContentHeight + topPadding + bottomPadding : 0)
    contentItem: EText {
        font: control.font
        text: control.text
        elide: Text.ElideRight
        objectName: "switchLabel"
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator && !control.mirrored
            ? control.indicator.width + control.spacing : 0
        rightPadding: control.indicator && control.mirrored
            ? control.indicator.width + control.spacing : 0
        color: EPaletteManager.StatePalette.defaultTextColor(
            EPaletteManager.createStateObject(this, EStyle.TextColor)
                .setDark(ETheme.dark)
                .setEnabled(control.enabled)
        )
    }
    indicator: ERectangle {
        clip: true
        radius: height
        width: inside.baseWidth
        objectName: "switchTrack"
        height: inside.trackHeight
        y: control.topPadding + (control.availableHeight - height) / 2
        x: control.mirrored ? control.width - width - control.rightPadding : control.leftPadding
        color: EPaletteManager.StatePalette.computeBackgroundColor(
            EPaletteManager.createStateObject(this, EStyle.Color)
                .setDark(ETheme.dark)
                .setEnabled(control.enabled)
                .setColor(inside.color)
                .setComponentStyle(EStyle.Default)
        )

        Behavior on color {
            ColorAnimation {
                easing.type: Easing.Bezier
                duration: Math.max(0, control.duration)
                easing.bezierCurve: [0.645, 0.045, 0.355, 1, 1, 1]
            }
        }

        ERectangle {
            y: 2
            height: width
            radius: height / 2
            objectName: "switchThumb"
            width: Math.max(0, inside.trackHeight - 4)
            x: 2 + control.visualPosition * Math.max(0, parent.width - width - 4)
            color: EPaletteManager.DefaultPalette.resolveThemeBackgroundColor(false)

            ELoading {
                height: width
                width: parent.width - 4
                anchors.centerIn: parent
                visible: control.loading
            }
            EIcon {
                color: inside.color
                anchors.fill: parent
                iconSource: inside.icon
                visible: !control.loading
                iconSize: parent.width - 4

                Behavior on color {
                    ColorAnimation {
                        easing.type: Easing.Bezier
                        duration: Math.max(0, control.duration)
                        easing.bezierCurve: [0.645, 0.045, 0.355, 1, 1, 1]
                    }
                }
            }
            Behavior on x {
                NumberAnimation {
                    easing.type: Easing.Bezier
                    duration: Math.max(0, control.duration)
                    easing.bezierCurve: [0.645, 0.045, 0.355, 1, 1, 1]
                }
            }
        }
    }

    onValueChanged: if (value !== undefined)
        checked = value === activeValue
    onToggled: {
        if (loading)
            checked = !checked
        else
            requestChange(checked, !checked)
    }
    onEnabledChanged: if (!enabled && loading) {
        ++guardState.revision
        loading = false
    }
    Component.onCompleted: {
        if (value !== undefined)
            checked = value === activeValue
        else
            value = checked ? activeValue : inactiveValue
    }
    onCheckedChanged: Qt.callLater(function() {
        if (control && !control.loading)
            control.value = control.checked ? control.activeValue : control.inactiveValue
    })

    QtObject {
        id: inside

        property int minWidth: EDefaultConfig.switchHeight(control.size) * 2
        property int icon: control.checked ? control.activeIcon : control.inactiveIcon
        property color color: control.checked ? control.activeColor : control.inactiveColor
        property int baseWidth: control.text.length > 0 ? minWidth : Math.max(control.width, minWidth)
        property int trackHeight: Math.max(0, control.text.length > 0
            ? EDefaultConfig.switchHeight(control.size) : control.height)
    }
    QtObject {
        id: guardState

        property int revision: 0
    }
}

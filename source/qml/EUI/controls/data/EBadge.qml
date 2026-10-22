import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15

Item {
    id: control
    default property alias content: contentHost.data

    property int max: 99
    property var value: ""
    property bool isDot: false
    property bool hidden: false
    property bool showZero: false
    property point offset: Qt.point(0, 0)
    property int styleType: EStyle.Danger
    property Component badgeDelegate: null
    property color color: EPaletteManager.BasePalette.transparent

    readonly property bool hasValue: value !== "" && value !== null && value !== undefined
    readonly property bool badgeVisible: !hidden && (isDot || (hasValue && (value !== 0 || showZero)))
    readonly property string displayValue: {
        if (!hasValue)
            return ""
        if (typeof value === "number" && value > Math.max(0, max))
            return EControlConfig.textFor(control, "BadgeOverflow", ELocale.texts).arg(Math.max(0, max))
        return String(value)
    }

    implicitWidth: contentHost.childrenRect.x + contentHost.childrenRect.width
    implicitHeight: contentHost.childrenRect.y + contentHost.childrenRect.height

    Item {
        id: contentHost

        anchors.fill: parent
    }
    ERectangle {
        border.width: 1
        radius: height / 2
        objectName: "badgeIndicator"
        visible: control.badgeVisible
        height: control.isDot ? 10 : 20
        y: -height / 2 + control.offset.y
        opacity: control.enabled ? 1 : 0.5
        x: control.width - width / 2 + control.offset.x
        width: control.isDot ? 10 : Math.max(20, badgeText.implicitWidth + 12)
        border.color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
        color: control.color.a > 0 ? control.color
            : EPaletteManager.ThemePalette.fetchColorForStyle(control.styleType)

        EText {
            id: badgeText

            font.pixelSize: 12
            anchors.centerIn: parent
            text: control.displayValue
            color: EPaletteManager.BasePalette.white
            visible: !control.isDot && !badgeSlot.active
        }
        Loader {
            id: badgeSlot

            property var value: control.value
            property string displayValue: control.displayValue

            anchors.centerIn: parent
            active: sourceComponent !== null
            sourceComponent: control.badgeDelegate
        }
    }
}

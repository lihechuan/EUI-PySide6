import EUI 1.0
import QtQuick 2.15

EButton {
    id: control

    property var badge: ""
    property string tooltip: ""
    property string shape: "circle"
    property alias content: control.text

    z: 100
    minHeight: 48
    circle: shape !== "square"
    implicitWidth: Math.max(minHeight, implicitContentWidth + leftPadding + rightPadding)

    EShadow {
        radius: control.circle ? control.height / 2 : 4
    }
    EBadge {
        z: 1
        anchors.fill: parent
        isDot: !!(control.badge && typeof control.badge === "object" && control.badge.isDot)
        hidden: !!(control.badge && typeof control.badge === "object" && control.badge.hidden)
        showZero: !!(control.badge && typeof control.badge === "object" && control.badge.showZero)
        value: control.badge && typeof control.badge === "object" ? control.badge.value : control.badge
        max: control.badge && typeof control.badge === "object" && isFinite(control.badge.max)
            ? Math.max(0, control.badge.max)
            : 99
        offset: control.badge && typeof control.badge === "object" && control.badge.offset !== undefined
            ? control.badge.offset
            : Qt.point(0, 0)
        color: control.badge && typeof control.badge === "object" && control.badge.color !== undefined
            ? control.badge.color
            : EPaletteManager.BasePalette.transparent
    }
    EToolTip {
        text: control.tooltip
        visible: control.hovered && text.length > 0
    }
}

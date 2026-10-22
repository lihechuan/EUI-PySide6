import EUI 1.0
import QtQuick 2.15

ERectangle {
    id: control

    property real position: 0
    property Item slider: null
    property bool pressed: false

    readonly property bool horizontal: !slider || slider.horizontal
    readonly property real diameter: slider ? Math.max(0, slider.handleSize) : 0
    readonly property real visualDiameter: hovered.hovered || pressed ? diameter * 1.25 : diameter

    border.width: 2
    width: visualDiameter
    height: visualDiameter
    radius: visualDiameter / 2
    x: horizontal ? (parent.width - width) * position : 0
    y: horizontal ? 0 : (parent.height - height) * position
    color: EPaletteManager.ThemePalette.surfaceComponent(ETheme.dark)
    anchors.verticalCenter: horizontal ? parent.verticalCenter : undefined
    anchors.horizontalCenter: horizontal ? undefined : parent.horizontalCenter
    border.color: EPaletteManager.StatePalette.resolveEffectiveBorderColor(
        EPaletteManager.createStateObject(this, EStyle.BorderColor)
            .setDark(ETheme.dark)
            .setEnabled(control.slider && control.slider.enabled)
            .setColor(control.slider ? control.slider.color : EPaletteManager.BasePalette.transparent)
            .setIsFound(true)
            .setComponentStyle(control.slider ? control.slider.styleType : EStyle.Primary)
    )

    HoverHandler {
        id: hovered

        acceptedDevices: PointerDevice.Mouse
        enabled: control.slider && control.slider.enabled
    }
    Behavior on width {
        NumberAnimation {
            duration: 120
            easing.type: Easing.OutCubic
        }
    }
    Behavior on height {
        NumberAnimation {
            duration: 120
            easing.type: Easing.OutCubic
        }
    }
}

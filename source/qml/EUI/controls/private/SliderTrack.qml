import EUI 1.0
import QtQuick 2.15

ERectangle {
    id: control

    property Item slider: null
    property real toPosition: 1
    property real fromPosition: 0

    readonly property bool horizontal: !slider || slider.horizontal
    readonly property real start: Math.min(fromPosition, toPosition)
    readonly property real length: Math.abs(toPosition - fromPosition)
    readonly property real thickness: slider ? Math.max(0, slider.trackSize) : 0

    radius: thickness / 2
    width: horizontal ? parent.width : thickness
    height: horizontal ? thickness : parent.height
    x: horizontal ? 0 : (parent.width - width) / 2
    y: horizontal ? (parent.height - height) / 2 : 0
    color: EPaletteManager.ThemePalette.surfacePressed(ETheme.dark)

    ERectangle {
        radius: parent.radius
        x: control.horizontal ? parent.width * control.start : 0
        y: control.horizontal ? 0 : parent.height * control.start
        width: control.horizontal ? parent.width * control.length : parent.width
        height: control.horizontal ? parent.height : parent.height * control.length
        color: EPaletteManager.StatePalette.computeBackgroundColor(
            EPaletteManager.createStateObject(this, EStyle.Color)
                .setDark(ETheme.dark)
                .setEnabled(control.slider && control.slider.enabled)
                .setColor(control.slider ? control.slider.color : EPaletteManager.BasePalette.transparent)
                .setComponentStyle(control.slider ? control.slider.styleType : EStyle.Primary)
        )
    }
}

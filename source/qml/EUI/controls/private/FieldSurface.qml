import EUI 1.0
import QtQuick 2.15

ERectangle {
    id: control

    property bool focused: false
    property bool hovered: false
    property int styleType: EStyle.Primary
    property int validationState: EValidationState.None

    radius: 4
    border.width: 1
    color: EPaletteManager.StatePalette.resolveRectBackgroundColor(
        EPaletteManager.createStateObject(this, EStyle.Color)
            .setDark(ETheme.dark)
            .setEnabled(control.enabled)
    )
    border.color: enabled && validationState !== EValidationState.None
        ? EPaletteManager.StatePalette.validationColor(validationState)
        : EPaletteManager.StatePalette.resolveRectBorderColor(
            EPaletteManager.createStateObject(this, EStyle.BorderColor)
                .setDark(ETheme.dark)
                .setEnabled(control.enabled)
                .setHovered(control.hovered)
                .setActiveFocus(control.focused)
                .setComponentStyle(control.styleType)
        )
}

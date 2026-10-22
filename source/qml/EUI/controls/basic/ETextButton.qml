import EUI 1.0

EBaseButton {
    id: control

    property bool isOpenBackgroundColor: false

    plain: true
    textButton: true
    background: ERectangle {
        border.width: 1
        border.color: color
        implicitHeight: Math.max(0, control.minHeight)
        radius: control.circle ? Math.max(0, control.width / 2)
            : (control.round ? 20 : 4)
        color: EPaletteManager.StatePalette.adjustPlainTextButtonColor(
            EPaletteManager.createStateObject(this, EStyle.Color)
                .setDark(ETheme.dark)
                .setHovered(control.hovered)
                .setPressed(control.pressed)
                .setEnabled(control.enabled)
                .setColor(EPaletteManager.ThemePalette.fetchThemeColor(ETheme.dark))
                .setIsOpenBackgroundColor(control.isOpenBackgroundColor)
        )
    }
}

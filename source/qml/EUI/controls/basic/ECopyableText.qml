import EUI 1.0
import QtQuick 2.15

TextEdit {
    id: control

    property color textColor: EPaletteManager.StatePalette.defaultTextColor(
        EPaletteManager.createStateObject(this, EStyle.TextColor)
            .setDark(ETheme.dark)
            .setEnabled(control.enabled)
    )

    focus: false
    readOnly: true
    selectByMouse: true
    wrapMode: Text.WrapAnywhere
    renderType: Text.QtRendering
    selectionColor: EPaletteManager.BasePalette.blue
    selectedTextColor: EPaletteManager.BasePalette.white
    color: EPaletteManager.StatePalette.computeEffectiveTextColor(
        EPaletteManager.createStateObject(this, EStyle.Color)
            .setDark(ETheme.dark)
            .setEnabled(control.enabled)
            .setPlain(true)
            .setColor(textColor)
    )
}

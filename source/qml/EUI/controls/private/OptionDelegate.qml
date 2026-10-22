import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQuick.Controls

ItemDelegate {
    id: control

    property bool selected: false
    property int size: EControlConfig.sizeFor(control)

    readonly property color accentColor: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)

    topPadding: 0
    bottomPadding: 0
    hoverEnabled: true
    font.bold: selected
    leftPadding: EDefaultConfig.horizontalPadding(size)
    rightPadding: EDefaultConfig.horizontalPadding(size)
    font.pixelSize: EDefaultConfig.controlFontPixelSize(size)
    implicitHeight: Math.max(30, EDefaultConfig.controlHeight(size) + 2)
    background: ERectangle {
        radius: 0
        color: control.enabled && control.selected
            ? Qt.rgba(control.accentColor.r, control.accentColor.g, control.accentColor.b, ETheme.dark ? 0.18 : 0.1)
            : control.enabled && (control.hovered || control.highlighted)
            ? EPaletteManager.ThemePalette.surfaceHover(ETheme.dark)
            : EPaletteManager.BasePalette.transparent
    }
    contentItem: EText {
        font: control.font
        text: control.text
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
        color: EPaletteManager.StatePalette.computeEffectiveTextColor(
            EPaletteManager.createStateObject(this, EStyle.TextColor)
                .setDark(ETheme.dark)
                .setEnabled(control.enabled)
                .setTextButton(true)
                .setComponentStyle(control.selected ? EStyle.Primary : EStyle.Default)
        )
    }
}

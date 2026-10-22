import EUI 1.0
import EUI.Private 1.0
import QtQuick 2.15

ChartRenderer {
    id: control

    gridColor: EPaletteManager.ThemePalette.borderDefault(ETheme.dark)
    textColor: EPaletteManager.ThemePalette.textSecondary(ETheme.dark)
    color: EPaletteManager.ThemePalette.fetchColorForStyle(EStyle.Primary)
}

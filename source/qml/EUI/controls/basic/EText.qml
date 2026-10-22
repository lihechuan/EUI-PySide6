import EUI 1.0
import QtQuick 2.15

Text {
    property string type: ""
    property int lineClamp: 0
    property bool truncated: false
    property int size: EStyle.Medium

    wrapMode: lineClamp > 0 ? Text.Wrap : Text.NoWrap
    maximumLineCount: lineClamp > 0 ? lineClamp : 2147483647
    font.pixelSize: EDefaultConfig.controlFontPixelSize(size)
    elide: truncated || lineClamp > 0 ? Text.ElideRight : Text.ElideNone
    color: type.length ? EPaletteManager.ThemePalette.fetchColorForStyle(
        type === "primary" ? EStyle.Primary
            : type === "success" ? EStyle.Success
            : type === "warning" ? EStyle.Warning
            : type === "danger" ? EStyle.Danger
            : EStyle.Info
    ) : EPaletteManager.ThemePalette.fetchInverseThemeColor(ETheme.dark)
}

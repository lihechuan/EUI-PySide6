import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15

ETextButton {
    id: control

    property url href
    property var underline: EControlConfig.optionFor(control, "link", "underline", true)

    link: true
    hoverEnabled: true
    Accessible.role: Accessible.Link
    styleType: EControlConfig.styleFor(control, "link", "type", EStyle.Default)
    font.underline: enabled
        && (underline === "always" || (underline === true || underline === "hover") && hovered)
    contentItem: EText {
        font: control.font
        text: control.text
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
        color: EPaletteManager.StatePalette.computeEffectiveTextColor(
            EPaletteManager.createStateObject(this, EStyle.TextColor)
                .setDark(ETheme.dark)
                .setHovered(control.hovered)
                .setPressed(control.pressed)
                .setEnabled(control.enabled)
                .setPlain(true)
                .setColor(control.color)
                .setComponentStyle(control.styleType)
                .setTextButton(true)
        )
    }

    onClicked: {
        if (href.toString().length > 0)
            Qt.openUrlExternally(href)
    }
}

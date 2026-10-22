import EUI 1.0
import "." as FormControls
import QtQuick 2.15
import QtQml 2.15

FormControls.ECheckBox {
    id: control

    property int radius: 0
    property int borderWidth: 1
    property int styleType: EStyle.Default
    property color color: EPaletteManager.BasePalette.transparent

    checkState: Qt.Unchecked
    indicator: ERectangle { }
    leftPadding: EDefaultConfig.horizontalPadding(control.size)
    rightPadding: EDefaultConfig.horizontalPadding(control.size)
    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    font.pixelSize: EDefaultConfig.controlFontPixelSize(control.size)
    background: ERectangle {
        anchors.fill: parent
        color: inside.backgroundColor
        border.color: inside.borderColor
        radius: Math.max(0, control.radius)
        border.width: Math.max(0, control.borderWidth)
    }
    contentItem: EText {
        font: control.font
        text: control.text
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: control.checked && control.enabled
            ? EPaletteManager.BasePalette.white
            : EPaletteManager.StatePalette.computeTextColor(
                EPaletteManager.createStateObject(this, EStyle.Color)
                    .setDark(ETheme.dark)
                    .setHovered(control.hovered)
                    .setPressed(control.pressed)
                    .setEnabled(control.enabled)
                    .setPlain(true)
                    .setIsFound(control.hovered)
                    .setColor(control.color)
                    .setComponentStyle(control.styleType)
                    .setTextButton(true)
            )
    }

    QtObject {
        id: inside

        property color borderColor: EPaletteManager.StatePalette.resolveEffectiveBorderColor(
            EPaletteManager.createStateObject(this, EStyle.BorderColor)
                .setDark(ETheme.dark)
                .setHovered(control.checked)
                .setEnabled(control.enabled)
                .setPlain(true)
                .setIsFound(control.checked)
                .setColor(control.color)
                .setComponentStyle(control.styleType)
                .setBorder(true)
        )
        property color backgroundColor: !control.checked ? EPaletteManager.BasePalette.transparent
            : EPaletteManager.StatePalette.computeBackgroundColor(
                EPaletteManager.createStateObject(this, EStyle.Color)
                    .setDark(ETheme.dark)
                    .setHovered(true)
                    .setEnabled(control.enabled)
                    .setPlain(true)
                    .setColor(control.color)
                    .setComponentStyle(control.styleType)
                    .setBorder(true)
            )
    }
}

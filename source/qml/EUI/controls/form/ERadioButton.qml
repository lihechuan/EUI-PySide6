import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

RadioButton {
    id: control

    property int radius: 0
    property int borderWidth: 1
    property var label: undefined
    property var value: undefined
    property bool validateEvent: true
    property var modelValue: undefined
    property int styleType: EStyle.Default
    property int size: EControlConfig.sizeFor(control)
    property color color: EPaletteManager.BasePalette.transparent

    readonly property var effectiveValue: value !== undefined ? value : label !== undefined ? label : text

    signal changed(var value)

    topPadding: 0
    font.bold: true
    bottomPadding: 0
    indicator: ERectangle { }
    Accessible.name: control.text
    Accessible.checked: control.checked
    Accessible.role: Accessible.RadioButton
    implicitHeight: EDefaultConfig.controlHeight(control.size)
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

    onEffectiveValueChanged: {
        if (typedState.completed && modelValue !== undefined)
            checked = modelValue === effectiveValue
    }
    onModelValueChanged: {
        if (!typedState.completed || typedState.syncing)
            return
        typedState.syncing = true
        checked = modelValue === effectiveValue
        typedState.syncing = false
    }
    Component.onCompleted: {
        typedState.completed = true
        typedState.syncing = true
        if (modelValue !== undefined)
            checked = modelValue === effectiveValue
        else if (checked)
            modelValue = effectiveValue
        typedState.syncing = false
    }
    onCheckedChanged: {
        if (!typedState.completed || typedState.syncing || !checked && modelValue !== effectiveValue)
            return
        typedState.syncing = true
        modelValue = checked ? effectiveValue : undefined
        typedState.syncing = false
        changed(modelValue)
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
    QtObject {
        id: typedState

        property bool syncing: false
        property bool completed: false
    }
}

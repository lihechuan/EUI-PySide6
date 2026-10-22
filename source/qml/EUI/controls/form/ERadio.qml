import EUI 1.0
import "../config/EControlConfig.js" as EControlConfig
import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls

RadioButton {
    id: control

    property var label: undefined
    property var value: undefined
    property bool borderVisible: true
    property bool validateEvent: true
    property var modelValue: undefined
    property int styleType: EStyle.Default
    property int size: EControlConfig.sizeFor(control)
    property color color: EPaletteManager.BasePalette.transparent
    property int optSize: EDefaultConfig.selectionIndicatorSize(control.size)

    readonly property var effectiveValue: value !== undefined ? value : label !== undefined ? label : text

    signal changed(var value)

    spacing: 8
    topPadding: 0
    font.bold: true
    bottomPadding: 0
    Accessible.name: control.text
    Accessible.checked: control.checked
    Accessible.role: Accessible.RadioButton
    implicitHeight: EDefaultConfig.controlHeight(control.size)
    leftPadding: EDefaultConfig.horizontalPadding(control.size)
    rightPadding: EDefaultConfig.horizontalPadding(control.size)
    font.pixelSize: EDefaultConfig.controlFontPixelSize(control.size)
    background: ERectangle {
        id: backgroundRectangle

        anchors.fill: parent
        border.width: control.borderVisible ? 1 : 0
        color: EPaletteManager.BasePalette.transparent
        border.color: EPaletteManager.StatePalette.resolveEffectiveBorderColor(
            EPaletteManager.createStateObject(this, EStyle.BorderColor)
                .setDark(ETheme.dark)
                .setHovered(control.checked)
                .setEnabled(control.enabled)
                .setPlain(true)
                .setIsFound((control.checked && control.enabled))
                .setColor(control.color)
                .setComponentStyle(control.styleType)
                .setBorder(true)
        )
    }
    contentItem: EText {
        font: control.font
        text: control.text
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        leftPadding: control.indicator && !control.mirrored ? control.indicator.width + control.spacing : 0
        rightPadding: control.indicator && control.mirrored ? control.indicator.width + control.spacing : 10
        color: EPaletteManager.StatePalette.computeTextColor(
            EPaletteManager.createStateObject(this, EStyle.Color)
                .setDark(ETheme.dark)
                .setHovered(control.checked)
                .setEnabled(control.enabled)
                .setPlain(true)
                .setIsFound((control.checked && control.enabled))
                .setColor(control.color)
                .setComponentStyle(control.styleType)
                .setTextButton(true)
        )
    }
    indicator: ERectangle {
        border.width: 1
        width: Math.max(0, optSize)
        height: Math.max(0, optSize)
        radius: Math.max(0, optSize)
        anchors.left: backgroundRectangle.left
        anchors.verticalCenter: backgroundRectangle.verticalCenter
        anchors.leftMargin: EDefaultConfig.horizontalPadding(control.size)
        border.color: EPaletteManager.StatePalette.resolveEffectiveBorderColor(
            EPaletteManager.createStateObject(this, EStyle.BorderColor)
                .setDark(ETheme.dark)
                .setHovered(control.checked)
                .setEnabled(control.enabled)
                .setPlain(true)
                .setIsFound(control.checked ? control.enabled : control.hovered)
                .setColor(control.color)
                .setComponentStyle(control.styleType)
                .setBorder(true)
        )
        color: EPaletteManager.StatePalette.resolveEffectiveBackgroundColor(
            EPaletteManager.createStateObject(this, EStyle.Color)
                .setDark(ETheme.dark)
                .setHovered(control.enabled ? control.checked : false)
                .setEnabled(control.enabled)
                .setPlain(true)
                .setIsFound(control.enabled ? control.checked : false)
                .setColor(control.color)
                .setComponentStyle(control.styleType)
                .setBorder(control.enabled ? (control.checked > 0) : true)
        )

        ERectangle {
            radius: width / 2
            width: parent.width / 2
            height: parent.height / 2
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            opacity: control.checked ? 1 : 0
            color: control.enabled ? EPaletteManager.BasePalette.white
                : EPaletteManager.StatePalette.computeTextColor(
                    EPaletteManager.createStateObject(this, EStyle.Color)
                        .setDark(ETheme.dark)
                        .setHovered(control.hovered)
                        .setPressed(control.pressed)
                        .setEnabled(control.enabled)
                        .setPlain(true)
                        .setColor(control.color)
                        .setComponentStyle(control.styleType)
                )

            Behavior on opacity {
                NumberAnimation {
                    duration: 200

                    easing {
                        type: Easing.InOutQuad
                    }
                }
            }
        }
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
        id: typedState

        property bool syncing: false
        property bool completed: false
    }
}
